# /database

Create database operations following repository pattern and migration best practices.

## Required Information

Before starting, clarify:
1. **Operation type**: Migration, Query, Repository, or Seed data?
2. **Entity**: What domain entity does this relate to?
3. **Database**: PostgreSQL, MySQL, SQLite?
4. **ORM/Query builder**: sqlc, GORM, Prisma, TypeORM, raw SQL?

## Workflow Options

### A. Database Migration

#### Step 1: Design Schema Change
```sql
-- What tables/columns are affected?
-- Is this additive (safe) or destructive (dangerous)?
-- What's the rollback plan?
```

#### Step 2: Create Migration File
```
migrations/
├── 20240130_001_create_orders_table.up.sql
└── 20240130_001_create_orders_table.down.sql
```

#### Step 3: Write Up Migration
```sql
-- migrations/20240130_001_create_orders_table.up.sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    status VARCHAR(50) NOT NULL DEFAULT 'draft',
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
```

#### Step 4: Write Down Migration
```sql
-- migrations/20240130_001_create_orders_table.down.sql
DROP TABLE IF EXISTS orders;
```

#### Migration Checklist
- [ ] Up migration is idempotent (or uses IF NOT EXISTS)
- [ ] Down migration fully reverses the up
- [ ] Indexes added for common queries
- [ ] Foreign keys have ON DELETE behavior
- [ ] Large table changes are backward compatible

---

### B. Repository Implementation

#### Step 1: Define Repository Interface (Domain Layer)
```go
// internal/domain/order/repository.go
type OrderRepository interface {
    FindByID(ctx context.Context, id OrderID) (*Order, error)
    FindByCustomer(ctx context.Context, customerID CustomerID) ([]*Order, error)
    FindPending(ctx context.Context) ([]*Order, error)
    Save(ctx context.Context, order *Order) error
    Delete(ctx context.Context, id OrderID) error
}
```

#### Step 2: Implement Repository (Infrastructure Layer)
```go
// internal/infrastructure/persistence/postgres/order_repository.go
type PostgresOrderRepository struct {
    db *sql.DB
}

func (r *PostgresOrderRepository) FindByID(ctx context.Context, id domain.OrderID) (*domain.Order, error) {
    query := `SELECT id, customer_id, status, total_amount, created_at, updated_at
              FROM orders WHERE id = $1`

    row := r.db.QueryRowContext(ctx, query, id.String())
    return r.scanOrder(row)
}

func (r *PostgresOrderRepository) Save(ctx context.Context, order *domain.Order) error {
    query := `INSERT INTO orders (id, customer_id, status, total_amount, created_at, updated_at)
              VALUES ($1, $2, $3, $4, $5, $6)
              ON CONFLICT (id) DO UPDATE SET
                  status = EXCLUDED.status,
                  total_amount = EXCLUDED.total_amount,
                  updated_at = NOW()`

    _, err := r.db.ExecContext(ctx, query,
        order.ID().String(),
        order.CustomerID().String(),
        order.Status().String(),
        order.Total().Amount(),
        order.CreatedAt(),
        order.UpdatedAt(),
    )
    return err
}
```

#### Step 3: Write Integration Tests
```go
func TestOrderRepository_Save(t *testing.T) {
    ctx := context.Background()
    db := setupTestDB(t)
    repo := NewPostgresOrderRepository(db)

    order := domain.NewOrder(customerID, items)

    err := repo.Save(ctx, order)
    require.NoError(t, err)

    found, err := repo.FindByID(ctx, order.ID())
    require.NoError(t, err)
    assert.Equal(t, order.ID(), found.ID())
}
```

---

### C. Query Optimization

#### Step 1: Analyze Current Query
```sql
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = '...'
AND status = 'pending'
ORDER BY created_at DESC;
```

#### Step 2: Identify Issues
- Sequential scan on large table?
- Missing index?
- N+1 query pattern?
- Unnecessary columns selected?

#### Step 3: Optimize
```sql
-- Add composite index for common query pattern
CREATE INDEX idx_orders_customer_status_created
ON orders(customer_id, status, created_at DESC);

-- Optimize query to use index
SELECT id, customer_id, status, total_amount, created_at
FROM orders
WHERE customer_id = $1 AND status = $2
ORDER BY created_at DESC
LIMIT 50;
```

---

## Code Templates by Tool

### sqlc (Go)
```sql
-- queries/orders.sql

-- name: GetOrder :one
SELECT * FROM orders WHERE id = $1;

-- name: ListOrdersByCustomer :many
SELECT * FROM orders
WHERE customer_id = $1
ORDER BY created_at DESC;

-- name: CreateOrder :one
INSERT INTO orders (customer_id, status, total_amount)
VALUES ($1, $2, $3)
RETURNING *;

-- name: UpdateOrderStatus :exec
UPDATE orders SET status = $2, updated_at = NOW()
WHERE id = $1;
```

### Prisma (TypeScript)
```typescript
// Repository using Prisma
export class PrismaOrderRepository implements OrderRepository {
  constructor(private prisma: PrismaClient) {}

  async findById(id: string): Promise<Order | null> {
    const data = await this.prisma.order.findUnique({
      where: { id },
      include: { items: true },
    });
    return data ? this.toDomain(data) : null;
  }

  async save(order: Order): Promise<void> {
    await this.prisma.order.upsert({
      where: { id: order.id },
      create: this.toPersistence(order),
      update: this.toPersistence(order),
    });
  }
}
```

### TypeORM (TypeScript)
```typescript
@Entity('orders')
export class OrderEntity {
  @PrimaryColumn('uuid')
  id: string;

  @Column('uuid')
  customerId: string;

  @Column({ type: 'varchar', length: 50 })
  status: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  totalAmount: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => OrderItemEntity, (item) => item.order)
  items: OrderItemEntity[];
}
```

## Checklist Before Completion

### Migrations
- [ ] Up and down migrations tested locally
- [ ] Backward compatible for zero-downtime deploys
- [ ] Indexes added for query patterns
- [ ] Data migration handles existing records

### Repository
- [ ] Implements domain interface
- [ ] Maps between domain and persistence models
- [ ] Handles not found vs error cases
- [ ] Uses context for cancellation/timeout
- [ ] Integration tests with real database

### Queries
- [ ] EXPLAIN ANALYZE shows index usage
- [ ] No N+1 query patterns
- [ ] Pagination for large result sets
- [ ] Proper parameter binding (no SQL injection)

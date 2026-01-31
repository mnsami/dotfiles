---
priority: medium
---
# DDD Pattern Reference

## Value Objects

Value objects are defined by their attributes, not identity.

### Characteristics
- Immutable after creation
- Equality based on attribute values
- Self-validating (invalid state impossible)
- Side-effect free methods

### Examples

```typescript
// Good: Value Object
class Money {
  constructor(
    readonly amount: number,
    readonly currency: string
  ) {
    if (amount < 0) throw new Error('Amount cannot be negative');
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies');
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }
}
```

```go
// Good: Value Object in Go
type Email struct {
    address string
}

func NewEmail(address string) (Email, error) {
    if !isValidEmail(address) {
        return Email{}, errors.New("invalid email format")
    }
    return Email{address: address}, nil
}

func (e Email) String() string { return e.address }
func (e Email) Domain() string { return strings.Split(e.address, "@")[1] }
```

## Entities

Entities have identity that persists through state changes.

### Characteristics
- Unique identifier
- Mutable state through controlled methods
- Lifecycle that matters to the domain
- Equality based on ID, not attributes

### Example

```typescript
class Order {
  private constructor(
    readonly id: OrderId,
    private items: OrderItem[],
    private status: OrderStatus
  ) {}

  static create(id: OrderId): Order {
    return new Order(id, [], OrderStatus.Draft);
  }

  addItem(product: Product, quantity: number): void {
    if (this.status !== OrderStatus.Draft) {
      throw new Error('Cannot modify confirmed order');
    }
    this.items.push(new OrderItem(product, quantity));
  }

  confirm(): void {
    if (this.items.length === 0) {
      throw new Error('Cannot confirm empty order');
    }
    this.status = OrderStatus.Confirmed;
  }
}
```

## Aggregates

Aggregates are clusters of entities and value objects treated as a unit.

### Rules
1. One entity is the "root" - the only entry point
2. External references only to the root, not internal objects
3. Changes to internals only through root methods
4. Delete the root = delete the entire aggregate
5. Keep aggregates small (prefer smaller over larger)

### Example

```
Order (Aggregate Root)
├── OrderItem (Entity, internal)
├── ShippingAddress (Value Object)
└── PaymentDetails (Value Object)
```

## Domain Events

Events capture something that happened in the domain.

### Characteristics
- Immutable (past tense naming)
- Contain all relevant data
- Can be persisted for event sourcing
- Enable loose coupling between aggregates

### Example

```typescript
interface DomainEvent {
  occurredAt: Date;
}

class OrderConfirmed implements DomainEvent {
  constructor(
    readonly orderId: string,
    readonly customerId: string,
    readonly totalAmount: Money,
    readonly occurredAt: Date = new Date()
  ) {}
}
```

## Repositories

Repositories provide collection-like access to aggregates.

### Interface Design
- Domain-focused methods (findByEmail, not findByColumn)
- Return domain objects, not raw data
- Hide persistence details

### Example

```typescript
interface OrderRepository {
  findById(id: OrderId): Promise<Order | null>;
  findByCustomer(customerId: CustomerId): Promise<Order[]>;
  findPendingOrders(): Promise<Order[]>;
  save(order: Order): Promise<void>;
}
```

## Application Services

Orchestrate use cases without containing business logic.

### Responsibilities
- Transaction boundaries
- Authorization checks
- Coordinating multiple aggregates
- Publishing domain events

### Example

```typescript
class ConfirmOrderUseCase {
  constructor(
    private orderRepo: OrderRepository,
    private paymentService: PaymentService,
    private eventBus: EventBus
  ) {}

  async execute(orderId: string): Promise<void> {
    const order = await this.orderRepo.findById(new OrderId(orderId));
    if (!order) throw new NotFoundError('Order not found');

    await this.paymentService.authorize(order.paymentDetails);
    order.confirm();

    await this.orderRepo.save(order);
    await this.eventBus.publish(new OrderConfirmed(order.id, ...));
  }
}
```

## Anti-Patterns to Avoid

### Anemic Domain Model
❌ Entities with only getters/setters, logic in services

### God Aggregate
❌ Aggregates that are too large and have many responsibilities

### Repository Creep
❌ Business logic leaking into repository implementations

### Leaky Abstractions
❌ Domain layer depending on infrastructure details

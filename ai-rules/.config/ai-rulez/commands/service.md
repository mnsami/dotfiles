# /service

Create a service/use case following clean architecture and DDD principles.

## Required Information

Before starting, clarify:
1. **Service name**: What operation does it perform? (e.g., CreateOrder, ProcessPayment)
2. **Layer**: Application Service (orchestration) or Domain Service (domain logic)?
3. **Dependencies**: What repositories, external services does it need?
4. **Input/Output**: What does it receive and return?

## Service Types

### Application Service (Use Case)
- Orchestrates the workflow
- No business logic (delegates to domain)
- Handles transactions
- Publishes events
- Maps between DTOs and domain objects

### Domain Service
- Contains domain logic that doesn't belong to an entity
- Operates on multiple aggregates
- Stateless
- No infrastructure dependencies

## Workflow

### Step 1: Define the Interface

```go
// Application Service
type CreateOrderUseCase interface {
    Execute(ctx context.Context, req CreateOrderRequest) (*CreateOrderResponse, error)
}

// Domain Service
type PricingService interface {
    CalculateOrderTotal(items []OrderItem, customer Customer) Money
}
```

### Step 2: Define DTOs (Application Service only)

```go
type CreateOrderRequest struct {
    CustomerID      string            `json:"customer_id" validate:"required,uuid"`
    Items           []OrderItemDTO    `json:"items" validate:"required,min=1"`
    ShippingAddress AddressDTO        `json:"shipping_address" validate:"required"`
}

type CreateOrderResponse struct {
    OrderID   string    `json:"order_id"`
    Status    string    `json:"status"`
    Total     float64   `json:"total"`
    CreatedAt time.Time `json:"created_at"`
}
```

### Step 3: Implement the Service

#### Application Service Pattern
```go
type createOrderUseCase struct {
    orderRepo    domain.OrderRepository
    customerRepo domain.CustomerRepository
    pricing      domain.PricingService
    eventBus     EventBus
    txManager    TransactionManager
}

func NewCreateOrderUseCase(
    orderRepo domain.OrderRepository,
    customerRepo domain.CustomerRepository,
    pricing domain.PricingService,
    eventBus EventBus,
    txManager TransactionManager,
) *createOrderUseCase {
    return &createOrderUseCase{
        orderRepo:    orderRepo,
        customerRepo: customerRepo,
        pricing:      pricing,
        eventBus:     eventBus,
        txManager:    txManager,
    }
}

func (uc *createOrderUseCase) Execute(ctx context.Context, req CreateOrderRequest) (*CreateOrderResponse, error) {
    // 1. Validate request
    if err := validate(req); err != nil {
        return nil, fmt.Errorf("validation failed: %w", err)
    }

    // 2. Load dependencies
    customer, err := uc.customerRepo.FindByID(ctx, domain.CustomerID(req.CustomerID))
    if err != nil {
        return nil, fmt.Errorf("customer not found: %w", err)
    }

    // 3. Create domain object
    items := mapToOrderItems(req.Items)
    order, err := domain.NewOrder(customer.ID(), items, mapToAddress(req.ShippingAddress))
    if err != nil {
        return nil, fmt.Errorf("invalid order: %w", err)
    }

    // 4. Apply domain logic
    total := uc.pricing.CalculateOrderTotal(items, customer)
    order.SetTotal(total)

    // 5. Persist in transaction
    err = uc.txManager.Execute(ctx, func(ctx context.Context) error {
        return uc.orderRepo.Save(ctx, order)
    })
    if err != nil {
        return nil, fmt.Errorf("failed to save order: %w", err)
    }

    // 6. Publish events (outside transaction)
    for _, event := range order.Events() {
        uc.eventBus.Publish(ctx, event)
    }

    // 7. Return response
    return &CreateOrderResponse{
        OrderID:   order.ID().String(),
        Status:    order.Status().String(),
        Total:     order.Total().Amount(),
        CreatedAt: order.CreatedAt(),
    }, nil
}
```

#### Domain Service Pattern
```go
type pricingService struct {
    discountRules []DiscountRule
}

func NewPricingService(discountRules []DiscountRule) *pricingService {
    return &pricingService{discountRules: discountRules}
}

func (s *pricingService) CalculateOrderTotal(items []OrderItem, customer Customer) Money {
    subtotal := Money{Amount: 0, Currency: "USD"}

    for _, item := range items {
        subtotal = subtotal.Add(item.Price().Multiply(item.Quantity()))
    }

    // Apply discount rules
    for _, rule := range s.discountRules {
        if rule.Applies(customer, items) {
            subtotal = rule.Apply(subtotal)
        }
    }

    return subtotal
}
```

### Step 4: Write Tests

```go
func TestCreateOrderUseCase_Execute(t *testing.T) {
    tests := []struct {
        name    string
        req     CreateOrderRequest
        setup   func(*mocks)
        want    *CreateOrderResponse
        wantErr bool
    }{
        {
            name: "creates order successfully",
            req:  validOrderRequest(),
            setup: func(m *mocks) {
                m.customerRepo.EXPECT().
                    FindByID(gomock.Any(), gomock.Any()).
                    Return(testCustomer(), nil)
                m.orderRepo.EXPECT().
                    Save(gomock.Any(), gomock.Any()).
                    Return(nil)
            },
            want:    expectedResponse(),
            wantErr: false,
        },
        {
            name: "fails when customer not found",
            req:  validOrderRequest(),
            setup: func(m *mocks) {
                m.customerRepo.EXPECT().
                    FindByID(gomock.Any(), gomock.Any()).
                    Return(nil, domain.ErrNotFound)
            },
            want:    nil,
            wantErr: true,
        },
    }

    for _, tc := range tests {
        t.Run(tc.name, func(t *testing.T) {
            m := newMocks(t)
            tc.setup(m)

            uc := NewCreateOrderUseCase(m.orderRepo, m.customerRepo, m.pricing, m.eventBus, m.txManager)
            got, err := uc.Execute(context.Background(), tc.req)

            if tc.wantErr {
                require.Error(t, err)
            } else {
                require.NoError(t, err)
                assert.Equal(t, tc.want.OrderID, got.OrderID)
            }
        })
    }
}
```

## Output Structure

```
internal/
├── application/
│   └── order/
│       ├── create_order.go           # Use case implementation
│       ├── create_order_test.go      # Unit tests
│       ├── dto.go                    # Request/Response DTOs
│       └── mapper.go                 # Domain <-> DTO mapping
│
└── domain/
    └── order/
        ├── pricing_service.go        # Domain service
        └── pricing_service_test.go
```

## Error Handling Patterns

```go
// Define domain errors
var (
    ErrOrderNotFound    = errors.New("order not found")
    ErrInvalidOrder     = errors.New("invalid order")
    ErrInsufficientStock = errors.New("insufficient stock")
)

// Wrap errors with context
func (uc *createOrderUseCase) Execute(ctx context.Context, req CreateOrderRequest) (*CreateOrderResponse, error) {
    customer, err := uc.customerRepo.FindByID(ctx, req.CustomerID)
    if errors.Is(err, domain.ErrNotFound) {
        return nil, fmt.Errorf("customer %s: %w", req.CustomerID, ErrCustomerNotFound)
    }
    if err != nil {
        return nil, fmt.Errorf("failed to fetch customer: %w", err)
    }
    // ...
}
```

## Checklist Before Completion

- [ ] Dependencies injected via constructor
- [ ] Request validation at service boundary
- [ ] Domain logic in domain layer (not in service)
- [ ] Errors wrapped with context
- [ ] Events published after successful persistence
- [ ] Transaction boundary correctly defined
- [ ] Unit tests with mocked dependencies
- [ ] Edge cases and error paths tested

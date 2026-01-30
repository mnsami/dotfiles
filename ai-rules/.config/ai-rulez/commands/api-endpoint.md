# /api-endpoint

Create a complete API endpoint following DDD and clean architecture principles.

## Required Information

Before starting, clarify:
1. **Endpoint**: HTTP method + path (e.g., `POST /api/v1/orders`)
2. **Purpose**: What does this endpoint do?
3. **Request**: Body schema, query params, path params
4. **Response**: Success response, error responses
5. **Auth**: Authentication/authorization requirements

## Workflow

### Step 1: Define the Contract
```
Method: POST
Path: /api/v1/orders
Auth: Bearer token required
Request Body: { customerId, items[], shippingAddress }
Response 201: { orderId, status, total }
Response 400: { error, details[] }
Response 401: { error: "Unauthorized" }
```

### Step 2: Create Domain Layer (if needed)
- [ ] Entity or Aggregate (e.g., `Order`)
- [ ] Value Objects (e.g., `OrderId`, `Money`, `Address`)
- [ ] Domain Events (e.g., `OrderCreated`)
- [ ] Repository Interface

### Step 3: Create Application Layer
- [ ] Request DTO with validation
- [ ] Response DTO
- [ ] Use Case / Application Service
- [ ] Map between DTOs and domain objects

### Step 4: Create Infrastructure Layer
- [ ] Repository implementation
- [ ] External service adapters (if needed)

### Step 5: Create API Layer
- [ ] Route registration
- [ ] Handler/Controller
- [ ] Request validation middleware
- [ ] Error handling middleware
- [ ] Auth middleware integration

### Step 6: Write Tests
- [ ] Unit tests for domain logic
- [ ] Unit tests for use case (mock repository)
- [ ] Integration test for handler
- [ ] Contract test for API

## Output Structure

Generate files in this order:

```
# 1. Domain (if new aggregate)
internal/domain/order/
├── order.go              # Aggregate
├── order_test.go
├── value_objects.go      # OrderId, etc.
└── repository.go         # Interface

# 2. Application
internal/application/order/
├── create_order.go       # Use case
├── create_order_test.go
├── dto.go                # Request/Response DTOs
└── mapper.go             # Domain <-> DTO mapping

# 3. Infrastructure
internal/infrastructure/persistence/
└── order_repository.go   # Repository impl

# 4. API
internal/api/handlers/
├── order_handler.go
└── order_handler_test.go

internal/api/routes/
└── order_routes.go
```

## Code Templates

### Handler Pattern
```go
func (h *OrderHandler) CreateOrder(w http.ResponseWriter, r *http.Request) {
    // 1. Parse & validate request
    var req CreateOrderRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        respondError(w, http.StatusBadRequest, "invalid request body")
        return
    }
    if err := h.validator.Validate(req); err != nil {
        respondError(w, http.StatusBadRequest, err.Error())
        return
    }

    // 2. Execute use case
    result, err := h.createOrderUseCase.Execute(r.Context(), req)
    if err != nil {
        handleUseCaseError(w, err)
        return
    }

    // 3. Return response
    respondJSON(w, http.StatusCreated, result)
}
```

### Use Case Pattern
```go
type CreateOrderUseCase struct {
    orderRepo OrderRepository
    eventBus  EventBus
}

func (uc *CreateOrderUseCase) Execute(ctx context.Context, req CreateOrderRequest) (*CreateOrderResponse, error) {
    // 1. Create domain object
    order, err := domain.NewOrder(req.CustomerID, req.Items, req.ShippingAddress)
    if err != nil {
        return nil, fmt.Errorf("invalid order: %w", err)
    }

    // 2. Persist
    if err := uc.orderRepo.Save(ctx, order); err != nil {
        return nil, fmt.Errorf("failed to save order: %w", err)
    }

    // 3. Publish events
    uc.eventBus.Publish(order.Events()...)

    // 4. Return response
    return &CreateOrderResponse{
        OrderID: order.ID().String(),
        Status:  order.Status().String(),
        Total:   order.Total().Amount(),
    }, nil
}
```

## Checklist Before Completion

- [ ] Request validation covers all edge cases
- [ ] Error responses are consistent and helpful
- [ ] Auth/authz properly enforced
- [ ] Domain invariants protected
- [ ] Tests cover happy path + error cases
- [ ] API documentation updated (OpenAPI/Swagger)

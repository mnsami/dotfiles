---
priority: high
---
# Testing Standards

## Test Pyramid Distribution

Follow the test pyramid - more unit tests, fewer integration, minimal E2E:

| Layer | Coverage Target | Speed |
|-------|-----------------|-------|
| Unit | 70-80% of tests | < 10ms each |
| Integration | 15-25% of tests | < 1s each |
| E2E | 5-10% of tests | < 30s each |

## Mandatory Testing

### Always Test
- Domain entities and value objects
- Business logic and calculations
- Input validation
- Error handling paths
- API contract (request/response format)

### Test Strategically
- Database queries (integration)
- External API integrations (contract tests)
- Authentication/authorization flows
- Critical user journeys (E2E)

## Test File Organization

```
src/
├── domain/
│   └── order/
│       ├── order.ts
│       └── order.test.ts        # Colocated unit tests
├── application/
│   └── order/
│       ├── createOrder.ts
│       └── createOrder.test.ts
└── tests/
    ├── integration/              # Integration tests
    │   └── order.integration.test.ts
    └── e2e/                      # E2E tests
        └── checkout.e2e.test.ts
```

## Naming Conventions

### Test Files
- Unit tests: `*.test.ts` or `*_test.go`
- Integration: `*.integration.test.ts`
- E2E: `*.e2e.test.ts`

### Test Names
Describe the scenario clearly:
```
describe('Order')
  describe('addItem')
    it('increases total by item price')
    it('throws when order is confirmed')
```

## Test Independence

- Each test runs independently
- No shared mutable state between tests
- Tests can run in any order
- Use setup/teardown for isolation

## Assertions

- One logical assertion per test (can be multiple expects)
- Assert on behavior, not implementation
- Use meaningful assertion messages
- Prefer specific assertions over generic ones

## Mocking Rules

- Mock at boundaries (external services, databases)
- Don't mock the unit under test
- Don't mock value objects
- Verify interactions sparingly
- Prefer fakes over mocks when practical

## Continuous Integration

- All tests run on every PR
- Unit tests run first (fast feedback)
- Integration tests run after unit
- E2E tests run last (or nightly)
- Failing tests block merge

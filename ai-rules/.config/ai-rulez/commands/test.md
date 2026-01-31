# /test

Activate the testing-expert skill and generate tests following the Test Pyramid strategy.

## Workflow

### 1. Analyze the Code
- Identify the layer (domain, application, infrastructure, UI)
- Determine appropriate test type (unit, integration, E2E)
- Find all testable behaviors and edge cases

### 2. Plan Test Coverage
For each testable unit:
- Happy path scenarios
- Edge cases and boundary conditions
- Error handling paths
- State transitions (if applicable)

### 3. Write Tests
Following project conventions:
- Use AAA (Arrange-Act-Assert) or Given-When-Then structure
- Table-driven tests for multiple scenarios
- Appropriate mocking strategy
- Clear, descriptive test names

### 4. Review Coverage
- Ensure critical paths are covered
- Check for missing edge cases
- Verify error conditions are tested

## Test Type Selection

| Code Layer | Primary Test Type | Mocking Strategy |
|------------|-------------------|------------------|
| Domain entities | Unit | None (pure logic) |
| Value objects | Unit | None |
| Application services | Unit/Integration | Mock repositories |
| Repositories | Integration | Real database |
| API handlers | Integration | Mock services |
| UI components | Unit/Integration | Mock data, minimal mocks |

## Output Format

```markdown
## Test Plan for [Component/Function]

### Test Type: [Unit/Integration/E2E]
**Reason:** [Why this test type]

### Scenarios
1. ✅ [Happy path description]
2. ⚠️ [Edge case description]
3. ❌ [Error case description]

### Tests

```[lang]
describe('[Component]', () => {
  describe('[method/behavior]', () => {
    it('[scenario in plain English]', () => {
      // Arrange
      ...
      // Act
      ...
      // Assert
      ...
    });
  });
});
```

### Mocking Notes
- [What's mocked and why]

### Coverage Notes
- [Any gaps or future test recommendations]
```

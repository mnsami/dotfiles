# /refactor

Activate the refactoring-expert skill and analyze code for improvements aligned with DDD and SOLID principles.

## Workflow

### 1. Code Smell Detection
Identify issues in these categories:
- **SOLID violations**: SRP, OCP, LSP, ISP, DIP breaches
- **DDD anti-patterns**: Anemic models, leaky abstractions, god aggregates
- **General smells**: Long methods, large classes, duplication, primitive obsession

### 2. Refactoring Recommendations
For each smell:
- Name the smell and its impact
- Propose a specific refactoring pattern
- Estimate effort (low/medium/high)
- Note any risks or prerequisites

### 3. Prioritized Action Plan
Order by:
1. Quick wins (high impact, low effort)
2. Safety improvements (reduce bugs)
3. Maintainability (long-term value)

### 4. Implementation Steps
For each refactoring:
- Step-by-step transformation
- Tests to add/update
- Before/after code preview

## Prerequisites
- Ensure tests exist before refactoring
- Commit current state first
- Make one change at a time

## Output Format

```markdown
## Code Smell Analysis

### 🔴 Critical
- [Smell]: [Description] → [Refactoring]

### 🟡 Important
- [Smell]: [Description] → [Refactoring]

### 🟢 Nice to Have
- [Smell]: [Description] → [Refactoring]

## Recommended Refactoring Order
1. [First refactoring] - [Why first]
2. [Second refactoring] - [Depends on #1]

## Detailed Implementation
### Refactoring: [Name]
**Current code:**
```[lang]
// problematic code
```

**After refactoring:**
```[lang]
// improved code
```

**Steps:**
1. ...
2. ...
```

---
priority: low
---
# Refactoring Catalog

Quick reference for common refactoring patterns and when to apply them.

## Composing Methods

| Refactoring | When to Use |
|-------------|-------------|
| Extract Method | Code block does one thing, or needs a comment |
| Inline Method | Method body is as clear as the name |
| Extract Variable | Expression is complex or used multiple times |
| Inline Variable | Variable adds no clarity |
| Replace Temp with Query | Temporary result could be a method |

## Moving Features

| Refactoring | When to Use |
|-------------|-------------|
| Move Method | Method uses more features of another class |
| Move Field | Field is used more by another class |
| Extract Class | Class has multiple responsibilities |
| Inline Class | Class does too little |
| Hide Delegate | Client calls through an intermediary |
| Remove Middle Man | Too much delegation |

## Organizing Data

| Refactoring | When to Use |
|-------------|-------------|
| Replace Primitive with Object | Primitive has behavior or validation |
| Replace Array with Object | Array elements mean different things |
| Change Value to Reference | Need shared, mutable object |
| Change Reference to Value | Need immutable, comparable object |

## Simplifying Conditionals

| Refactoring | When to Use |
|-------------|-------------|
| Decompose Conditional | Complex conditional expression |
| Consolidate Conditional | Multiple conditionals with same result |
| Replace Nested Conditional with Guard | Deep nesting with early returns |
| Replace Conditional with Polymorphism | Conditionals based on type |
| Introduce Null Object | Null checks scattered through code |

## Simplifying Method Calls

| Refactoring | When to Use |
|-------------|-------------|
| Rename Method | Name doesn't describe what it does |
| Add/Remove Parameter | Method needs more/less information |
| Introduce Parameter Object | Multiple parameters travel together |
| Preserve Whole Object | Passing several values from one object |
| Replace Parameter with Method | Parameter value can be calculated |
| Introduce Named Parameters | Many parameters, unclear meaning |

## Dealing with Generalization

| Refactoring | When to Use |
|-------------|-------------|
| Pull Up Method/Field | Subclasses share behavior |
| Push Down Method/Field | Behavior only relevant to some subclasses |
| Extract Interface | Need to abstract implementations |
| Collapse Hierarchy | Subclass adds little value |
| Replace Inheritance with Delegation | Subclass uses only part of parent |
| Replace Delegation with Inheritance | Class delegates everything |

## Safe Refactoring Checklist

Before refactoring:
- [ ] Tests exist and pass
- [ ] Code is committed
- [ ] Refactoring goal is clear

During refactoring:
- [ ] One change at a time
- [ ] Tests run after each change
- [ ] Commit at stable points

After refactoring:
- [ ] All tests still pass
- [ ] No behavior change
- [ ] Code is cleaner

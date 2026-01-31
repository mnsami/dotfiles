---
priority: high
---
# DDD-Inspired & SOLID Principles

## SOLID Principles (Always Apply)

### Single Responsibility
- Each class/module has one reason to change
- Functions do one thing well
- Split when you see "and" in descriptions

### Open/Closed
- Open for extension, closed for modification
- Use interfaces and composition over inheritance
- New behavior through new code, not changing existing

### Liskov Substitution
- Subtypes must be substitutable for their base types
- Don't override methods to throw exceptions or do nothing
- Honor the contract of the interface

### Interface Segregation
- Prefer small, focused interfaces over large ones
- Clients shouldn't depend on methods they don't use
- Split fat interfaces into role-specific ones

### Dependency Inversion
- Depend on abstractions, not concretions
- High-level modules shouldn't depend on low-level details
- Inject dependencies, don't instantiate them

## DDD-Inspired Patterns (Apply Where They Add Value)

### When to Use Full DDD
- Complex business domains with rich behavior
- Multiple bounded contexts that need clear boundaries
- Long-lived projects with evolving requirements

### When Simpler is Better
- CRUD-heavy areas with little business logic
- Simple data transformations
- Infrastructure and utility code

### Ubiquitous Language
- Use domain terms in code, not technical jargon
- Variable names reflect business concepts
- Align with how domain experts speak

### Value Objects
- Use for concepts defined by their attributes (Money, Email, DateRange)
- Make them immutable
- Implement equality by value, not reference

### Entities
- Use for concepts with identity that persists over time
- Minimize public setters, expose behavior instead
- Keep entities focused on their core responsibility

### Aggregates
- Group related entities with a single root
- All changes go through the aggregate root
- Keep aggregates small and focused

### Domain Services
- Use for operations that don't belong to a single entity
- Stateless operations on domain objects
- Named after the action they perform

### Repositories
- Abstract data access behind domain-focused interfaces
- Return domain objects, not database records
- Keep query logic in the repository, not scattered

## Layered Architecture

```
┌─────────────────────────────────────┐
│  Presentation / API / Controllers   │
├─────────────────────────────────────┤
│  Application Services / Use Cases   │
├─────────────────────────────────────┤
│  Domain (Entities, Value Objects)   │
├─────────────────────────────────────┤
│  Infrastructure (DB, External APIs) │
└─────────────────────────────────────┘
```

- Dependencies point inward (toward domain)
- Domain layer has no external dependencies
- Infrastructure implements domain interfaces

---
priority: high
targets: ["CLAUDE.md", ".cursorrules"]
---
# PHP Development Standards

## Style & Conventions
- Follow PSR-12 coding style strictly
- Use strict types: `declare(strict_types=1);` in all files
- Use PHP 8.1+ features: enums, readonly properties, named arguments
- Prefer typed properties and return types everywhere
- Use null-safe operator `?->` and nullsafe coalescing `??`

## Object-Oriented Design
- Favor composition over inheritance
- Use interfaces for dependencies (dependency injection)
- Keep classes focused (single responsibility)
- Use final classes by default, extend only when designed for it
- Leverage PHP 8 attributes for metadata

## Error Handling
- Use exceptions for exceptional cases, not flow control
- Create custom exception classes for domain errors
- Never catch Exception broadly, be specific
- Log exceptions with full context

## Testing
- Use PHPUnit for unit and integration tests
- Use Mockery or Prophecy for mocking
- Structure tests with Arrange-Act-Assert pattern
- Use data providers for parameterized tests
- Aim for high coverage on business logic

## Frameworks & Tools
- Laravel or Symfony for full-stack applications
- Doctrine or Eloquent for ORM
- PHPStan or Psalm at max level for static analysis
- PHP CS Fixer for automated style fixes
- Composer for dependency management

## Database
- Use migrations for all schema changes
- Use Eloquent/Doctrine relationships properly
- Avoid N+1 queries (eager loading)
- Use query builder or repositories, avoid raw SQL in controllers

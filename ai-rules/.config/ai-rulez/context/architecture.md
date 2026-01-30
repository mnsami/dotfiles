---
priority: medium
---
# Architecture Context

## General Architecture Preferences
- Prefer simple, boring solutions over complex, clever ones
- Follow established patterns in the existing codebase
- Separate concerns: business logic, data access, presentation
- Use dependency injection for testability
- Prefer composition over inheritance

## API Design
- Use RESTful conventions for HTTP APIs
- Return appropriate HTTP status codes
- Version APIs when breaking changes are needed
- Document endpoints with OpenAPI/Swagger when applicable
- Use consistent naming conventions (snake_case or camelCase, pick one)

## Database Practices
- Use migrations for all schema changes
- Index columns used in WHERE clauses and JOINs
- Prefer explicit column lists over SELECT *
- Use transactions for multi-step operations
- Document complex queries with comments

## Configuration Management
- Use environment variables for configuration
- Never hardcode environment-specific values
- Provide sensible defaults where appropriate
- Document all required configuration options

---
priority: high
targets: ["CLAUDE.md", ".cursorrules"]
---
# Python Development Standards

## Style & Conventions
- Follow PEP 8 style guide
- Use type hints (PEP 484) for all function signatures
- Use Python 3.10+ features: match statements, union types with `|`
- Prefer f-strings for string formatting
- Use pathlib for file system operations

## Code Organization
- Keep modules focused and cohesive
- Use `__all__` to define public API
- Prefer absolute imports over relative
- Structure packages with clear boundaries
- Use dataclasses or Pydantic for data structures

## Error Handling
- Use specific exception types, not bare `except:`
- Create custom exceptions for domain errors
- Use context managers for resource management
- Log exceptions with traceback information

## Type Hints
- Use `Optional[T]` or `T | None` for nullable types
- Use `TypeVar` for generic functions
- Use `Protocol` for structural subtyping
- Run mypy in strict mode in CI

## Testing
- Use pytest as the test framework
- Use fixtures for test setup
- Use parametrize for data-driven tests
- Use unittest.mock or pytest-mock for mocking
- Aim for high coverage on business logic

## Tools & Environment
- Use pyproject.toml for project configuration
- Use uv, poetry, or pip-tools for dependency management
- Use ruff for linting and formatting
- Use pre-commit hooks for consistency
- Use virtual environments always

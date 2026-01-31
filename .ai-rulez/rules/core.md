---
priority: critical
---
# Core Development Standards

## Communication Style
- Be concise and direct in explanations
- Explain reasoning for non-obvious decisions
- Ask clarifying questions before making assumptions on complex tasks
- Provide context when suggesting alternatives

## Code Quality Principles
- Write self-documenting code with meaningful variable and function names
- Keep functions small and focused (single responsibility principle)
- Add comments only for "why", never for "what" (code should be self-explanatory)
- Prefer readability over cleverness
- Delete dead code instead of commenting it out

## Error Handling
- Handle errors explicitly, never silently ignore them
- Provide meaningful error messages that help debugging
- Fail fast and fail clearly
- Log errors with sufficient context for debugging

## Testing Philosophy
- Write tests for new functionality before or alongside implementation
- Tests should be readable and serve as documentation
- Prefer integration tests over unit tests for business logic
- Unit test pure functions and complex algorithms
- Test edge cases and error paths, not just happy paths

## Security Mindset
- Never commit secrets, credentials, or API keys
- Validate and sanitize all external inputs
- Use parameterized queries for database operations
- Follow principle of least privilege

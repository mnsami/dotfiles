---
priority: high
targets: ["CLAUDE.md", ".cursorrules"]
---
# Go Development Standards

## Style & Idioms
- Follow Effective Go and Go Code Review Comments
- Use gofmt/goimports for formatting (non-negotiable)
- Prefer short variable names in small scopes (i, ok, err)
- Use meaningful names for package-level and exported identifiers
- Accept interfaces, return structs

## Error Handling
- Always check errors, never use `_` for error returns
- Wrap errors with context using `fmt.Errorf("context: %w", err)`
- Return errors, don't panic (except for truly unrecoverable situations)
- Use sentinel errors or custom error types for errors callers need to check

## Package Design
- Keep packages focused and cohesive
- Avoid circular dependencies
- Use internal/ for private packages
- Export only what's necessary
- Document all exported identifiers

## Concurrency
- Use channels for communication, mutexes for state
- Prefer `sync.WaitGroup` for waiting on goroutines
- Always handle context cancellation
- Use `context.Context` as the first parameter
- Never start goroutines without a way to stop them

## Testing
- Use table-driven tests with `t.Run` for subtests
- Use testify/assert or testify/require for assertions
- Mock external dependencies with interfaces
- Use `_test` package suffix for black-box testing when appropriate
- Run `go vet` and `staticcheck` in CI

## Common Libraries
- Chi or Gin for HTTP routers
- sqlc or sqlx for database access
- zerolog or slog for structured logging
- viper for configuration
- testify for testing utilities

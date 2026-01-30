---
priority: high
targets: ["CLAUDE.md", ".cursorrules"]
---
# TypeScript Development Standards

## Type System
- Enable strict mode in tsconfig.json (always)
- Avoid `any` - use `unknown` when type is truly unknown
- Use type inference where types are obvious
- Prefer interfaces for object shapes, types for unions/intersections
- Use generics for reusable, type-safe abstractions

## Code Style
- Use const by default, let when reassignment needed, never var
- Prefer arrow functions for callbacks and short functions
- Use destructuring for cleaner code
- Prefer template literals over string concatenation
- Use optional chaining `?.` and nullish coalescing `??`

## Async Patterns
- Use async/await over raw Promises
- Handle errors with try/catch in async functions
- Avoid mixing callbacks and Promises
- Use Promise.all for parallel operations
- Consider AbortController for cancellation

## Frontend Specific
- Use functional components with hooks (React)
- Keep components small and focused
- Lift state up or use state management for shared state
- Memoize expensive computations with useMemo/useCallback
- Use proper TypeScript types for event handlers

## Backend Specific (Node.js)
- Use ESM modules (import/export)
- Structure code with clear separation (routes, controllers, services)
- Validate request inputs at the boundary
- Use proper HTTP status codes
- Handle async errors with middleware

## Testing
- Use Jest or Vitest for testing
- Use React Testing Library for component tests
- Test behavior, not implementation
- Mock external dependencies
- Use TypeScript in tests for type safety

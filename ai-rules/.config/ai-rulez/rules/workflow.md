---
priority: high
---
# Development Workflow Standards

## Git Commit Conventions
- Use conventional commit format: `type(scope): description`
- Types: feat, fix, refactor, docs, test, chore, perf, style
- Keep commits atomic and focused on a single change
- Write commit messages in imperative mood ("Add feature" not "Added feature")
- Reference issue numbers when applicable

## Pull Request Guidelines
- Keep PRs small and focused (< 400 lines when possible)
- Write clear PR descriptions explaining the "why"
- Include testing instructions when relevant
- Self-review before requesting reviews
- Address all review comments before merging

## Code Review Approach
- Review for correctness, readability, and maintainability
- Suggest improvements constructively
- Ask questions instead of making assumptions
- Approve when good enough, don't block on style preferences

## Branch Strategy
- Use feature branches for new work
- Keep branches short-lived
- Rebase on main before merging to keep history clean
- Delete branches after merging

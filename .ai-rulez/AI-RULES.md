# AI Rules Ecosystem

Centralized AI coding rules for Claude Code, Cursor, and other AI tools.

## Overview

This package provides a single source of truth for AI coding assistant rules that can be shared across all your projects. It uses [ai-rulez](https://github.com/Goldziher/ai-rulez) to generate tool-specific configurations.

**Core Principles:**
- DDD-inspired architecture
- SOLID principles
- Test Pyramid strategy
- Pragmatic Atomic Design for UI

## Structure

This uses the "standard structure" that ai-rulez auto-detects (`.ai-rulez/` directory at repo root):

```
dotfiles/
└── .ai-rulez/                     # ai-rulez standard structure
    ├── rules/                     # Constraints (always applied)
    │   ├── core.md               # Universal coding standards
    │   ├── workflow.md           # Git, PR, code review conventions
    │   ├── ddd-solid.md          # DDD + SOLID principles
    │   ├── testing-standards.md  # Test Pyramid strategy
    │   └── ui-design-principles.md # shadcn/ui + Tailwind conventions
    │
    ├── context/                  # Reference documentation
    │   ├── architecture.md       # Architecture preferences
    │   ├── ddd-patterns.md       # DDD pattern catalog
    │   ├── refactoring-catalog.md # Code smells & refactorings
    │   └── component-architecture.md # Pragmatic Atomic Design
    │
    ├── skills/                   # AI expert personas
    │   ├── architect/            # System design expertise
    │   ├── code-reviewer/        # Code review expertise
    │   ├── debugger/             # Debugging expertise
    │   ├── ddd-expert/           # Domain modeling expertise
    │   ├── refactoring-expert/   # Refactoring expertise
    │   ├── testing-expert/       # Test design expertise
    │   └── ui-ux-expert/         # UI/UX design expertise
    │
    ├── domains/                  # Language-specific rules & skills
    │   ├── go/
    │   ├── php/
    │   ├── typescript/
    │   └── python/
    │
    ├── commands/                 # Workflow commands
    │   ├── review.md             # /review - Code review
    │   ├── refactor.md           # /refactor - Refactoring analysis
    │   ├── test.md               # /test - Generate tests
    │   ├── explain.md            # /explain - Code explanation
    │   ├── design-review.md      # /design-review - UI/UX review
    │   ├── api-endpoint.md       # /api-endpoint - Create API endpoint
    │   ├── react-component.md    # /react-component - Create React component
    │   ├── database.md           # /database - Database operations
    │   └── service.md            # /service - Create service/use case
    │
    └── templates/                # Project setup templates
```

## Installation

### Prerequisites

1. Install GNU Stow:
   ```bash
   # macOS
   brew install stow

   # Ubuntu/Debian
   sudo apt install stow
   ```

2. Install ai-rulez:
   ```bash
   # Homebrew
   brew install goldziher/tap/ai-rulez

   # npm
   npm install -g ai-rulez

   # pip
   pip install ai-rulez
   ```

### Setup

1. Clone your dotfiles (if not already):
   ```bash
   git clone https://github.com/mnsami/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run stow to create symlinks:
   ```bash
   ./stow.sh install
   ```

3. Verify installation:
   ```bash
   ls -la ~/.config/ai-rulez/
   ```

## Usage

### Setting Up a New Project

1. Create the ai-rulez config:
   ```bash
   mkdir -p .ai-rulez
   cp ~/dotfiles/.ai-rulez/templates/ai-rulez.yml.template .ai-rulez/config.yaml
   ```

2. Edit `.ai-rulez/config.yaml`:
   ```yaml
   version: "3.0"
   name: my-project

   includes:
     - name: mnsami-standards
       source: https://github.com/mnsami/dotfiles.git
       ref: master
       include: [rules, context, skills, commands, domains]
       merge_strategy: local-override

   profiles:
     default: [go]  # or [php], [typescript], [python]

   presets:
     - claude
     - cursor
   ```

3. Generate configs:
   ```bash
   ai-rulez generate
   ```

### Available Profiles

| Profile | Description |
|---------|-------------|
| `go` | Go development standards |
| `php` | PHP/Laravel/Symfony standards |
| `typescript` | TypeScript/React/Node.js standards |
| `python` | Python/FastAPI/Django standards |

Combine for full-stack: `profiles: { default: [go, typescript] }`

---

## Commands Reference

### Task Commands (Analysis & Review)

| Command | Description | Activates Skills |
|---------|-------------|------------------|
| `/review` | Code review with severity levels | code-reviewer |
| `/refactor` | Analyze code smells, suggest improvements | refactoring-expert |
| `/test` | Generate tests following Test Pyramid | testing-expert |
| `/explain` | Explain code at appropriate depth | - |
| `/design-review` | UI/UX accessibility & best practices review | ui-ux-expert |

### Workflow Commands (Code Generation)

| Command | Description | Output |
|---------|-------------|--------|
| `/api-endpoint` | Create complete API endpoint | Handler, service, repository, tests |
| `/react-component` | Create React component | Component, tests, hooks |
| `/database` | Database operations | Migrations, repositories, queries |
| `/service` | Create service/use case | Application/domain service with tests |

### Example Usage

```
# Create a new API endpoint
/api-endpoint POST /api/v1/orders - Create order with items and shipping

# Create a React component
/react-component OrderList - Feature component displaying paginated orders

# Generate tests for existing code
/test src/domain/order/order.go

# Refactor with DDD/SOLID analysis
/refactor src/services/orderService.ts
```

---

## Skills Reference

### Architectural Skills

| Skill | Use When |
|-------|----------|
| `architect` | Designing systems, making architectural decisions |
| `ddd-expert` | Modeling domains, bounded contexts, aggregates |

### Task Skills

| Skill | Use When |
|-------|----------|
| `refactoring-expert` | Improving code structure without changing behavior |
| `testing-expert` | Designing test strategies, writing effective tests |
| `code-reviewer` | Reviewing code for quality, security, maintainability |
| `debugger` | Systematic debugging and root cause analysis |

### UI Skills

| Skill | Use When |
|-------|----------|
| `ui-ux-expert` | Component design, accessibility, shadcn/ui patterns |

### Language Skills

| Skill | Use When |
|-------|----------|
| `go-expert` | Go-specific patterns, idioms, testing |
| `php-expert` | PHP/Laravel/Symfony best practices |
| `ts-expert` | TypeScript/React/Node.js development |
| `python-expert` | Python/FastAPI/Django development |

---

## Rules Reference

### Always Applied

| Rule | Purpose |
|------|---------|
| `core.md` | Universal coding standards |
| `workflow.md` | Git, PR, code review conventions |
| `ddd-solid.md` | DDD + SOLID principles |
| `testing-standards.md` | Test Pyramid, coverage targets |

### UI Projects

| Rule | Purpose |
|------|---------|
| `ui-design-principles.md` | shadcn/ui + Tailwind conventions, accessibility |

---

## Context Reference

Reference documentation loaded when relevant:

| Context | Contains |
|---------|----------|
| `architecture.md` | General architecture preferences |
| `ddd-patterns.md` | Value Objects, Entities, Aggregates, Repositories |
| `refactoring-catalog.md` | Code smells and refactoring patterns |
| `component-architecture.md` | Pragmatic Atomic Design (ui/ → patterns/ → features/) |

---

## Customization

### Adding Project-Specific Rules

Create `.ai-rulez/rules/project.md` in your project:

```markdown
---
priority: critical
---
# Project: my-api

## Architecture
- REST API using Chi router
- PostgreSQL with sqlc

## Constraints
- All endpoints authenticated except /health
- Maximum 200ms response time
```

### Adding a New Language Domain

```bash
mkdir -p ~/.config/ai-rulez/domains/rust/{rules,skills/rust-expert}
# Add rules and skills
# Use in projects with: profiles: { default: [rust] }
```

---

## Troubleshooting

### Symlinks not working
```bash
cd ~/dotfiles && ./stow.sh restow
```

### ai-rulez not finding config
```bash
ls -la ~/.config/ai-rulez/
```

### Generated files empty
Check `includes` path in `config.yaml` and repo accessibility.

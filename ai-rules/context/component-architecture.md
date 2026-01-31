---
priority: medium
---
# Pragmatic Atomic Design: Component Architecture

## Overview

A modern, practical component organization that takes the useful parts of Atomic Design while avoiding over-engineering.

## Directory Structure

```
src/
├── components/
│   ├── ui/              # Atoms + Simple Molecules (shadcn/ui lives here)
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   └── form.tsx
│   │
│   ├── patterns/        # Organisms - Complex, Reusable Compositions
│   │   ├── header/
│   │   │   ├── header.tsx
│   │   │   ├── header.test.tsx
│   │   │   └── index.ts
│   │   ├── sidebar/
│   │   ├── data-table/
│   │   └── form-wizard/
│   │
│   └── features/        # Feature-Specific Components
│       ├── auth/
│       │   ├── login-form.tsx
│       │   ├── register-form.tsx
│       │   └── forgot-password.tsx
│       ├── dashboard/
│       │   ├── stats-card.tsx
│       │   ├── recent-activity.tsx
│       │   └── quick-actions.tsx
│       └── orders/
│           ├── order-list.tsx
│           ├── order-details.tsx
│           └── order-form.tsx
│
├── lib/                 # Utilities and helpers
│   ├── utils.ts
│   └── cn.ts            # className utility
│
└── styles/
    └── globals.css      # Tailwind directives + custom styles
```

## Layer Definitions

### UI Layer (`components/ui/`)
The building blocks. These are shadcn/ui components plus any custom primitives.

**Characteristics:**
- No business logic
- Highly reusable across projects
- Controlled by props
- Stateless or minimal internal state
- Well-documented props

**Examples:**
- Button, Input, Select, Checkbox
- Card, Dialog, Drawer, Sheet
- Toast, Alert, Badge
- Form fields and validation display

### Patterns Layer (`components/patterns/`)
Complex, reusable UI patterns that combine multiple UI components.

**Characteristics:**
- Reusable across features
- May have internal state
- No direct API calls (data passed via props)
- Tested as units

**Examples:**
```tsx
// DataTable - reusable table pattern
<DataTable
  columns={columns}
  data={data}
  onRowClick={handleClick}
  pagination
  sorting
/>

// FormWizard - multi-step form pattern
<FormWizard
  steps={steps}
  onComplete={handleComplete}
  validateStep={validateStep}
/>

// CommandPalette - keyboard-driven search
<CommandPalette
  commands={commands}
  onSelect={handleSelect}
/>
```

### Features Layer (`components/features/`)
Feature-specific components tied to business logic.

**Characteristics:**
- Specific to one feature/domain
- May fetch data directly
- May have complex state
- Composed of UI and Pattern components
- Lives close to the feature it serves

**Examples:**
```tsx
// Feature: Auth
components/features/auth/
├── login-form.tsx       # Uses ui/form, ui/input, ui/button
├── register-form.tsx
└── user-menu.tsx        # Uses patterns/dropdown

// Feature: Orders
components/features/orders/
├── order-list.tsx       # Uses patterns/data-table
├── order-details.tsx    # Uses ui/card, ui/badge
└── order-filters.tsx    # Uses ui/select, ui/checkbox
```

## Component Composition Rules

### ✅ Allowed Dependencies

```
features/ → patterns/ → ui/
    ↓           ↓        ↓
   OK          OK       OK
```

- **UI components**: No dependencies on patterns or features
- **Patterns**: Can use UI components, not features
- **Features**: Can use both UI and patterns

### ❌ Prohibited Dependencies

- UI components importing from patterns or features
- Patterns importing from features
- Circular dependencies between features

## File Naming Conventions

```
# UI components (shadcn/ui style)
button.tsx
input.tsx
dropdown-menu.tsx

# Pattern components
data-table/
├── data-table.tsx
├── data-table-pagination.tsx
├── data-table-header.tsx
└── index.ts

# Feature components
login-form.tsx
order-list.tsx
dashboard-stats.tsx
```

## When to Create What

### Create a UI Component When:
- It's a primitive with no business logic
- It will be used across many features
- It matches a shadcn/ui component pattern

### Create a Pattern When:
- Combining 3+ UI components into reusable pattern
- The same composition appears in multiple features
- It's complex enough to warrant encapsulation

### Create a Feature Component When:
- It's specific to one feature/page
- It has feature-specific business logic
- It won't be reused elsewhere

## Colocation Guidelines

Keep related files together:

```
components/features/orders/
├── order-list.tsx
├── order-list.test.tsx
├── order-list.stories.tsx    # Optional: Storybook
├── use-orders.ts             # Feature-specific hook
└── order-types.ts            # Feature-specific types
```

## Migration Path

When a feature component becomes reusable:

1. Identify the generic parts
2. Extract to patterns/ with generic props
3. Keep feature component as thin wrapper
4. Add tests for the pattern

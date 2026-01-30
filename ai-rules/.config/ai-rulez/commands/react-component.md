# /react-component

Create a React component following pragmatic atomic design and shadcn/ui conventions.

## Required Information

Before starting, clarify:
1. **Component name**: What is it called?
2. **Layer**: ui/ (primitive), patterns/ (reusable), or features/ (specific)?
3. **Purpose**: What does it do?
4. **Props**: What data/callbacks does it need?
5. **States**: Loading, error, empty, success states?

## Workflow

### Step 1: Determine Component Layer

| Layer | Criteria | Example |
|-------|----------|---------|
| `ui/` | No business logic, highly reusable | Button, Card, Input |
| `patterns/` | Combines 3+ ui components, reusable pattern | DataTable, FormWizard |
| `features/` | Feature-specific, may fetch data | OrderList, UserProfile |

### Step 2: Define the Interface

```typescript
interface ComponentProps {
  // Required props
  data: DataType;
  onAction: (id: string) => void;

  // Optional props with defaults
  variant?: 'default' | 'compact';
  className?: string;
}
```

### Step 3: Plan States

- [ ] **Default**: Normal display
- [ ] **Loading**: Skeleton or spinner
- [ ] **Empty**: Helpful message + action
- [ ] **Error**: Error message + retry
- [ ] **Disabled**: Reduced opacity, no interaction

### Step 4: Implement Component

```typescript
// 1. Imports
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

// 2. Types
interface Props { ... }

// 3. Component
export function ComponentName({ prop1, prop2, className }: Props) {
  // Hooks
  const [state, setState] = useState();

  // Handlers
  const handleClick = () => { ... };

  // Render
  return (
    <div className={cn("base-styles", className)}>
      ...
    </div>
  );
}
```

### Step 5: Add Accessibility

- [ ] Semantic HTML elements
- [ ] ARIA labels where needed
- [ ] Keyboard navigation
- [ ] Focus management
- [ ] Screen reader testing

### Step 6: Write Tests

- [ ] Renders correctly with required props
- [ ] Handles all states (loading, error, empty)
- [ ] User interactions work
- [ ] Accessibility tests pass

## Output Structure

```
components/
├── ui/                          # For ui/ layer
│   └── component-name.tsx
│
├── patterns/                    # For patterns/ layer
│   └── component-name/
│       ├── component-name.tsx
│       ├── component-name.test.tsx
│       ├── use-component-name.ts    # Custom hook if needed
│       └── index.ts
│
└── features/                    # For features/ layer
    └── feature-name/
        ├── component-name.tsx
        ├── component-name.test.tsx
        ├── use-component-data.ts    # Data fetching hook
        └── types.ts
```

## Code Templates

### UI Component (Atom/Molecule)
```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const componentVariants = cva(
  "base-classes-here",
  {
    variants: {
      variant: {
        default: "variant-default-classes",
        secondary: "variant-secondary-classes",
      },
      size: {
        sm: "size-sm-classes",
        md: "size-md-classes",
        lg: "size-lg-classes",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "md",
    },
  }
);

export interface ComponentProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof componentVariants> {
  // Additional props
}

export function Component({
  className,
  variant,
  size,
  ...props
}: ComponentProps) {
  return (
    <div
      className={cn(componentVariants({ variant, size }), className)}
      {...props}
    />
  );
}
```

### Pattern Component (Organism)
```tsx
"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

interface SearchBarProps {
  onSearch: (query: string) => void;
  placeholder?: string;
  isLoading?: boolean;
  className?: string;
}

export function SearchBar({
  onSearch,
  placeholder = "Search...",
  isLoading = false,
  className,
}: SearchBarProps) {
  const [query, setQuery] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(query);
  };

  return (
    <form
      onSubmit={handleSubmit}
      className={cn("flex gap-2", className)}
    >
      <Input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder={placeholder}
        disabled={isLoading}
        aria-label="Search query"
      />
      <Button type="submit" disabled={isLoading}>
        {isLoading ? "Searching..." : "Search"}
      </Button>
    </form>
  );
}
```

### Feature Component
```tsx
"use client";

import { useOrders } from "./use-orders";
import { DataTable } from "@/components/patterns/data-table";
import { OrderFilters } from "./order-filters";
import { Skeleton } from "@/components/ui/skeleton";
import { Alert, AlertDescription } from "@/components/ui/alert";

export function OrderList() {
  const { orders, isLoading, error, refetch } = useOrders();

  if (isLoading) {
    return <OrderListSkeleton />;
  }

  if (error) {
    return (
      <Alert variant="destructive">
        <AlertDescription>
          Failed to load orders.{" "}
          <button onClick={refetch} className="underline">
            Try again
          </button>
        </AlertDescription>
      </Alert>
    );
  }

  if (orders.length === 0) {
    return <OrderListEmpty />;
  }

  return (
    <div className="space-y-4">
      <OrderFilters />
      <DataTable columns={columns} data={orders} />
    </div>
  );
}

function OrderListSkeleton() {
  return (
    <div className="space-y-2">
      {[...Array(5)].map((_, i) => (
        <Skeleton key={i} className="h-12 w-full" />
      ))}
    </div>
  );
}

function OrderListEmpty() {
  return (
    <div className="text-center py-12">
      <p className="text-muted-foreground">No orders found</p>
    </div>
  );
}
```

## Checklist Before Completion

- [ ] Props interface is well-typed
- [ ] All states handled (loading, error, empty)
- [ ] Accessible (keyboard, ARIA, contrast)
- [ ] Responsive (mobile-first)
- [ ] Uses shadcn/ui components appropriately
- [ ] Follows naming conventions
- [ ] Tests written and passing
- [ ] Exported from index.ts

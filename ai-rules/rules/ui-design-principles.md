---
priority: high
targets: ["CLAUDE.md", ".cursorrules"]
---
# UI/UX Design Principles

## Framework: shadcn/ui + Tailwind CSS

We use shadcn/ui components built on Radix primitives with Tailwind CSS for styling.

## Core Principles

### 1. Accessibility First
- All interactive elements keyboard accessible
- Proper ARIA labels and roles
- Color contrast meets WCAG AA (4.5:1 for text)
- Focus states visible and clear
- Screen reader compatible

### 2. Responsive Design
- Mobile-first approach
- Breakpoints: sm(640px), md(768px), lg(1024px), xl(1280px)
- Touch-friendly targets (min 44x44px)
- Fluid typography and spacing
- Test on real devices

### 3. Consistency
- Use design tokens (colors, spacing, typography)
- Consistent component behavior
- Predictable interaction patterns
- Unified visual language

### 4. Performance
- Minimize bundle size
- Lazy load below-fold content
- Optimize images
- Avoid layout shift (CLS)

## shadcn/ui Conventions

### Component Usage
```tsx
// ✅ Import from @/components/ui
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"

// ✅ Use variants for consistency
<Button variant="outline" size="sm">Cancel</Button>
<Button variant="default">Confirm</Button>
```

### Customization
- Extend via className, not inline styles
- Use Tailwind utilities for layout adjustments
- Modify theme in tailwind.config for global changes
- Create composite components for repeated patterns

### Form Patterns
```tsx
// Use shadcn/ui form with react-hook-form
<Form {...form}>
  <FormField
    control={form.control}
    name="email"
    render={({ field }) => (
      <FormItem>
        <FormLabel>Email</FormLabel>
        <FormControl>
          <Input {...field} />
        </FormControl>
        <FormMessage />
      </FormItem>
    )}
  />
</Form>
```

## Tailwind CSS Guidelines

### Spacing
- Use consistent spacing scale: 1, 2, 3, 4, 6, 8, 12, 16
- Prefer gap over margin for flex/grid layouts
- Use padding for internal spacing

### Colors
- Use semantic color names from theme
- `primary`, `secondary`, `destructive`, `muted`
- Avoid hardcoded hex values
- Support dark mode with `dark:` prefix

### Typography
- Use design system type scale
- `text-sm`, `text-base`, `text-lg`, `text-xl`
- Consistent font weights
- Line heights appropriate for content

### Layout
```tsx
// ✅ Prefer composition
<div className="flex flex-col gap-4 p-6">
  <header className="flex items-center justify-between">
  <main className="grid grid-cols-1 md:grid-cols-2 gap-6">
```

## Component Design Rules

### State Feedback
- Loading states for async operations
- Disabled states clearly visible
- Error states with helpful messages
- Success confirmation for actions

### Interactive Elements
- Hover states for all clickables
- Active/pressed states
- Focus rings visible
- Clear affordances (buttons look clickable)

### Empty States
- Helpful message explaining the state
- Action to resolve (if applicable)
- Illustration optional, not required

### Error Handling
- Inline validation feedback
- Toast/notification for async errors
- Clear recovery actions
- Never lose user input on error

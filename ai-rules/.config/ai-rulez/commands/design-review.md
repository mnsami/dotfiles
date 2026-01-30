# /design-review

Activate the ui-ux-expert skill and review UI components for design quality, accessibility, and best practices.

## Review Checklist

### 1. Component Structure
- [ ] Follows pragmatic atomic design (ui/ → patterns/ → features/)
- [ ] Proper component composition
- [ ] No prohibited dependencies (features importing from patterns correctly)
- [ ] Appropriate colocation of related files

### 2. Accessibility (A11y)
- [ ] Keyboard navigable (Tab, Enter, Escape, Arrow keys)
- [ ] ARIA labels and roles where needed
- [ ] Color contrast meets WCAG AA
- [ ] Focus states visible
- [ ] Screen reader compatible
- [ ] Respects reduced-motion preferences

### 3. Responsiveness
- [ ] Mobile-first approach
- [ ] Works at all breakpoints (sm, md, lg, xl)
- [ ] Touch-friendly targets (min 44x44px)
- [ ] No horizontal scroll on mobile
- [ ] Images and media responsive

### 4. State Management
- [ ] Loading states for async operations
- [ ] Error states with recovery actions
- [ ] Empty states with helpful guidance
- [ ] Disabled states clearly visible
- [ ] Form validation feedback

### 5. shadcn/ui & Tailwind Usage
- [ ] Using shadcn/ui components appropriately
- [ ] Consistent use of design tokens
- [ ] No hardcoded colors/sizes
- [ ] Dark mode support (if applicable)
- [ ] Proper variant usage

### 6. Performance
- [ ] No unnecessary re-renders
- [ ] Large lists virtualized
- [ ] Images optimized
- [ ] Lazy loading where appropriate

## Output Format

```markdown
## Design Review: [Component Name]

### Overview
[Brief description of what this component does]

### ✅ Strengths
- [What's done well]

### ⚠️ Issues Found

#### Accessibility
| Issue | Severity | Recommendation |
|-------|----------|----------------|
| [Issue] | High/Med/Low | [Fix] |

#### Responsiveness
| Issue | Severity | Recommendation |
|-------|----------|----------------|
| [Issue] | High/Med/Low | [Fix] |

#### Best Practices
| Issue | Severity | Recommendation |
|-------|----------|----------------|
| [Issue] | High/Med/Low | [Fix] |

### 📝 Suggested Improvements

#### Code Changes
```tsx
// Before
...

// After
...
```

### 🎯 Priority Actions
1. [Most critical fix]
2. [Second priority]
3. [Nice to have]
```

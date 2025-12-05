# Cart Item Modification — Requirements

## Feature description
Allow users to modify items already added to their cart within the Sandwich Shop Flutter app. Modifications include adjusting the quantity of an item and removing an item entirely. Changes should update the cart totals immediately, persist to the app's cart model/state, and provide a short undo option for removals.

## User stories
- As a customer, I want to increase the quantity of a cart item so I can order multiple of the same sandwich.
- As a customer, I want to decrease the quantity of a cart item so I can reduce how many I order.
- As a customer, I want to remove an item from the cart so I can discard unwanted items.
- As a customer, I want an Undo option after removing an item so I can recover accidental deletions.
- As a customer, I want the cart summary (total items and total price) to update immediately when I modify items so I can see the current cost.
- As a developer, I want quantity bounds (min/max) enforced so invalid orders are prevented.

## Acceptance criteria
- UI
  - A Cart screen or persistent cart panel lists each cart item with name, unit price, current quantity, and row total.
  - Each row has controls to increase and decrease quantity and a Remove (trash) action.
  - Decrease control is disabled at the configured minimum (default min = 1). If the app allows decrement to zero, it must be treated as removal and show Undo.
  - Increase control is disabled at the configured maximum (e.g., maxQuantity per item passed from Order screen).

- Behavior
  - Changing quantity updates the displayed row total and overall cart totals immediately.
  - Removing an item removes its row and updates totals.
  - After removal, an Undo Snackbar (or similar) appears for a short timeout to restore the removed item.
  - Edits persist to the Cart model/state so other UI components reflect the change.

- Validation & Errors
  - Attempting to increase beyond max shows a subtle error message (SnackBar or inline hint) and prevents the change.
  - Persistence failures (if applicable) surface a retryable error without losing the user's intent.

- Edge cases
  - Duplicate items: ensure consistent behavior (prefer aggregation into single row with quantity).
  - Price changes: clarify whether prices are locked at add-time; if prices update, surface differences to user.
  - Empty cart: show an empty state and disable checkout.
  - Accessibility: controls should be operable via assistive tech and keyboard.

- Tests
  - Unit/integration tests cover quantity increments/decrements, removal + undo, and totals recalculation.
  - UI tests verify disabled states at min/max and proper display of the Undo Snackbar.

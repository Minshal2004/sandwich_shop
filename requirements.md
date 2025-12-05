# Cart Item Modification — Detailed Requirements

## Feature description
Enable in-app modification of items already added to the cart. Users must be able to change item quantities and remove items entirely from the cart. Modifications must be reflected immediately in the UI and in the app's cart model/state. Provide a short-term undo mechanism for deletions. The feature applies to the local, in-memory cart used by the app (no server sync required for this iteration).

Scope:
- Aggregate duplicate items of the same variant into a single cart row with a quantity.
- Support decrement (and optional increment) controls per row.
- Treat decrementing to zero as removal and show an Undo affordance.
- Enforce configurable min/max quantity bounds (default min = 1, max = OrderScreen.maxQuantity).

Assumptions:
- Cart is stored in a Cart model accessible by the UI.
- Price is stored on the CartItem at add-time and should be used for row and totals calculations.
- No external persistence or backend API integration for this ticket.

## User stories
- As a shopper, I want to increase the quantity of a cart item so I can order multiple of the same sandwich.
- As a shopper, I want to decrease the quantity of a cart item so I can reduce the number ordered.
- As a shopper, I want to remove an item from my cart so I can discard unwanted items.
- As a shopper, I want to undo a recent removal so I can recover mistaken deletions.
- As a shopper, I want visible cart totals that update immediately so I can see the current cost.
- As a developer, I want quantity bounds enforced so invalid orders are prevented.
- As a QA engineer, I want deterministic behavior for duplicates (aggregation vs multiple rows) so tests are stable.

For each user story, include the acceptance note:
- Quantity edits must update UI and cart model immediately.
- Removal must update UI and cart model and show an undo option.
- Undo must restore the removed item with its prior quantity and position where practical.

## Acceptance criteria

### UI
- The cart view (either a dedicated Cart screen or persistent cart panel) lists each aggregated cart item with:
  - Item name (variant descriptor).
  - Unit price.
  - Quantity (numeric).
  - Row total (unit price * quantity) — optional but recommended.
  - Controls: decrement ("-") button; optionally increment ("+"); a distinct Remove action if desired.
- Decrement control is disabled when quantity == min (default 1) if removal via explicit Remove is preferred. If decrement-to-zero is allowed, the row is removed.
- A summary area shows:
  - Total items (sum of quantities).
  - Subtotal (sum of row totals).
  - Optionally tax and grand total (if tax logic exists).
- Removing an item shows an Undo Snackbar (or similar) for a short duration (e.g., 3–5 seconds).

### Behavior
- Modifying quantity updates:
  - The row's displayed quantity and row total.
  - The cart summary totals immediately.
  - The underlying Cart model/state immediately.
- Removing an item:
  - Removes the aggregated row from the cart view.
  - Updates summary totals.
  - Shows Undo that, when tapped, restores the removed item and quantity.
- Undo semantics:
  - Undo restores the last removed item state (name, unit price, quantity). If multiple rapid deletes happen, only the most recent undo target must be restored via that Snackbar.
- Quantity bounds:
  - Attempts to increase beyond configured max are prevented and surface a subtle message (SnackBar or inline helper).
  - Attempts to decrease below min are prevented or treated as removal per UI pattern chosen.
- Duplicate handling:
  - When adding the same variant again, aggregate into the existing row and increase its quantity (preferred). Tests and UI must reflect this aggregation.

### Data / Model
- Cart model updates must be the single source of truth for cart data used by all UI components.
- CartItem objects contain id, name, price; aggregation is keyed by deterministic variant descriptor (e.g., name).
- Totals calculation uses stored CartItem.price values and current quantity counts.

### Validation & Errors
- Prevent invalid quantities (negative or NaN).
- If persistence or state update fails (rare for in-memory carts), show a non-blocking error and allow retry; do not discard user's intent.
- Show helpful messages when user hits max quantity.

### Edge cases
- Decrement-to-zero: if the UI allows reaching zero, treat it as removal and show Undo.
- Rapid operations: handle quick sequences of increment/decrement/remove without inconsistent totals; use debounced UI updates if needed.
- Price changes: if product prices are updated elsewhere while an item is in the cart, decide policy — either lock price at add-time (preferred) or surface a price-diff notice and require user confirmation.
- Multiple identical items added separately: prefer aggregation; ensure that undo restores correct quantity rather than duplicate rows.
- Empty cart: display clear empty-state copy; disable checkout.
- SnackBar collisions: hide existing SnackBar before showing a new Undo to avoid confusion; consider stacking logic for multiple simultaneous undos.

### Accessibility
- Buttons must have semantic labels (e.g., "Decrease quantity for Footlong veggieDelight").
- Controls must be reachable by keyboard and screen readers.
- Visual state changes (disabled buttons, totals) must be perceivable (contrast, color, and text).

### Testing / QA criteria
- Unit tests:
  - Validate Cart model methods for add, remove single instance, aggregate counts, and totals.
  - Validate undo logic restores the prior cart state.
- Widget tests:
  - Verify increment/decrement buttons change visible quantity and totals.
  - Verify decrementing to zero removes the row and totals update.
  - Verify the Undo Snackbar restores the removed item and totals when tapped.
  - Verify disabled states at min and max quantity.
- Integration tests (optional):
  - Simulate typical user flows: add items, modify quantities, remove item, undo, and perform checkout path.

### Non-goals (this iteration)
- No server-side cart synchronization.
- No user accounts or cross-device persistence.
- No complex promotions or dynamic price rules.

## Implementation notes (developer hints)
- Use the Cart model as a single source of truth and rebuild cart widgets from it.
- Prefer aggregating identical variants by a deterministic key (e.g., variant descriptor string).
- Keep UI immediate (optimistic) for local state changes and show Undo for destructive actions.
- Keep max/min bounds configurable from the OrderScreen or CartConfig constants to simplify tests.

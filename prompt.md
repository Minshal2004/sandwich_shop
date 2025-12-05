# Cart Item Modification Feature

## Context
The Sandwich Shop Flutter app lets users build sandwiches and add them to a local cart. Currently the app shows a cart summary (total items and total price) but does not provide UI to edit items once added. This feature enables users to modify items already in their cart: change item quantity and remove items.

## Feature description
- Screen / Component:
  - Add a "Cart" screen or a persistent cart panel accessible from the main screen.
  - The cart lists each CartItem (name, unit price, current quantity, row total).
  - Each cart row includes:
    - Decrease quantity button (disabled at 1 or customizable min).
    - Increase quantity button (disabled at configurable max).
    - A numeric display of the current quantity (editable inline or via step buttons).
    - A "Remove" button (trash icon) to delete the item entirely.
  - At the bottom: cart totals (total items, subtotal, tax, grand total) and an optional "Checkout" button.

- Behavior:
  - Quantity changes immediately update the UI and the cart totals.
  - Removing an item removes its row and updates totals.
  - Provide an "Undo" Snackbar after remove (with short timeout) to restore the removed item.
  - Validate quantity bounds (min = 1, max = app-configured maxQuantity per order item).
  - Persist changes to the existing Cart model so other UI (cart summary) reflects updates.

- UX considerations:
  - Optimistic updates: reflect change immediately in UI; persist to storage/state synchronously for local cart.
  - Use clear affordances (icons and tooltips) and accessible labels for screen readers.
  - Confirm destructive actions only if they are hard to recover (e.g., clearing entire cart), otherwise use Undo.

## Edge cases
- Quantity reaches zero:
  - If the UI allows decrement to zero, treat as removal; show Undo Snackbar.
  - Prefer disabling decrease at 1 and require explicit Remove for clarity.
- Max quantity exceeded:
  - If user attempts to increase beyond configured limit, prevent the change and show a subtle message (SnackBar or inline error).
- Duplicate items:
  - If the same sandwich variant is added multiple times, either aggregate into one cart row (preferred) or display multiple rows with unique ids; ensure quantity editing behaves consistently.
- Concurrency / synchronization:
  - If the cart state is shared across screens, ensure updates propagate (use ChangeNotifier, streams, or state management solution).
- Price changes:
  - If menu prices change while items are in cart, decide whether to lock price at add-time or update prices; surface differences to users.
- Persistence failures:
  - If saving the cart to local storage fails, show an error and allow retry; avoid losing user changes.
- Accessibility and input:
  - For keyboard/assistive tech, allow numeric input and button controls; validate pasted/typed quantities.
- Empty cart:
  - Show an empty state copy and disable checkout; allow navigation back to menu.


# Test design — SauceDemo

Six browser tests were selected to cover the main customer journey and the highest risks: access, incorrect prices, lost cart state and failed orders.

| Test | Risk and validation |
| --- | --- |
| **01 Authentication** | Five demo users can log in; a locked account and wrong password are rejected. All seven attempts run in isolated sessions. |
| **02 Sorting** | All four name/price sort orders are correct, and each product retains its original price. |
| **03 Cart lifecycle** | Every product is added and removed across listing, detail and cart views. Validate badge counts, cart contents and empty state. |
| **04 Checkout validation** | Missing first name, last name or postal code blocks checkout. Both Cancel actions preserve the cart. |
| **05 Order and PDF** | Verify selected items, subtotal, tax, total and confirmation; compare the downloaded PDF's products, prices and customer details with checkout. |
| **06 Navigation** | Check menu open/close, All Items, Reset App State, Logout and About navigation. |

**Approach:** Separate `.robot` suites with shared `.resource` keywords, stable `data-test` locators and isolated browser contexts. Dynamic counts and item-price data prevent unnecessary hardcoding. Browser assertions wait for UI state instead of using fixed sleeps. Receipt checks use `pypdf` on the downloaded file.

**Scope:** Related login and menu scenarios are grouped to stay within the six-test limit. Cross-browser, accessibility and visual regression are excluded. Actual browser execution must be verified before submission.

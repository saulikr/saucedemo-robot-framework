*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/login.resource
Resource          ../resources/inventory.resource
Resource          ../resources/cart.resource
Resource          ../resources/checkout.resource
Resource          ../resources/pdf.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser
Test Setup        Open Fresh Session
Test Teardown     Close Test Session

*** Test Cases ***
Completed Order And PDF Receipt Match Checkout
    Sign In As Standard User
    ${selected}=    Create List    @{ORDER_PRODUCTS}
    Should Not Be Empty    ${selected}
    ${expected_cart_count}=    Get Length    ${selected}
    ${item_prices}    ${expected_subtotal}=    Add Selected Products And Read Prices    ${selected}
    Cart Badge Should Show Count    ${expected_cart_count}
    Open Shopping Cart
    Cart Should Contain Exactly    ${selected}
    Proceed To Checkout
    Fill Customer Information    ${ORDER_CUSTOMER}[first_name]    ${ORDER_CUSTOMER}[last_name]    ${ORDER_CUSTOMER}[postal_code]
    Continue To Overview
    Overview Should Contain Exactly    ${selected}
    ${tax_cents}    ${total_cents}=    Overview Totals Should Be Correct    ${expected_subtotal}
    Finish Order
    ${receipt_path}=    Download Completed Order PDF
    PDF Receipt Should Match Completed Checkout
    ...    ${receipt_path}
    ...    ${selected}
    ...    ${item_prices}
    ...    ${expected_subtotal}
    ...    ${tax_cents}
    ...    ${total_cents}
    ...    ${ORDER_CUSTOMER}
    Cart Badge Should Be Empty
    Back To Products After Order
    FOR    ${name}    IN    @{selected}
        Inventory Should Show Add Button For    ${name}
    END

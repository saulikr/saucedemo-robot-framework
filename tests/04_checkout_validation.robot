*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/login.resource
Resource          ../resources/inventory.resource
Resource          ../resources/cart.resource
Resource          ../resources/checkout.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser
Test Setup        Open Fresh Session
Test Teardown     Close Test Session

*** Test Cases ***
Checkout Validates Mandatory Fields And Cancel Actions
    Sign In As Standard User
    ${expected_cart}=    Create List    @{CHECKOUT_VALIDATION_PRODUCTS}
    Should Not Be Empty    ${expected_cart}
    ${expected_cart_count}=    Get Length    ${expected_cart}
    FOR    ${product_name}    IN    @{expected_cart}
        Add Product To Cart From Inventory    ${product_name}
    END
    Open Shopping Cart
    Proceed To Checkout
    Cancel Checkout Information
    Cart Should Contain Exactly    ${expected_cart}
    Proceed To Checkout
    Checkout Should Reject Missing Field    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${FIRST_NAME_REQUIRED_ERROR}
    Checkout Should Reject Missing Field    ${ORDER_CUSTOMER}[first_name]    ${EMPTY}    ${EMPTY}    ${LAST_NAME_REQUIRED_ERROR}
    Checkout Should Reject Missing Field    ${ORDER_CUSTOMER}[first_name]    ${ORDER_CUSTOMER}[last_name]    ${EMPTY}    ${POSTAL_CODE_REQUIRED_ERROR}
    Fill Customer Information    ${ORDER_CUSTOMER}[first_name]    ${ORDER_CUSTOMER}[last_name]    ${ORDER_CUSTOMER}[postal_code]
    Continue To Overview
    Cancel Checkout Overview
    Cart Badge Should Show Count    ${expected_cart_count}
    Products Page Should Be Open
    Open Shopping Cart
    Cart Should Contain Exactly    ${expected_cart}

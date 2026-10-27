*** Settings ***
Resource    common.resource
Resource    inventory.resource

*** Keywords ***
Cart Rows Locator
    # Cart rows have no data-test attribute; centralize this CSS fallback.
    RETURN    css=.cart_item

Cart Row Locator
    [Arguments]    ${name}
    ${rows}=    Cart Rows Locator
    ${locator}=    Set Variable    ${rows}:has([data-test="inventory-item-name"]:text-is("${name}"))
    RETURN    ${locator}

Cart Remove Button Locator
    [Arguments]    ${name}
    ${row}=    Cart Row Locator    ${name}
    ${locator}=    Set Variable    ${row} >> css=button[data-test^="remove"]
    RETURN    ${locator}

Cart Product Name Locator
    [Arguments]    ${name}
    ${row}=    Cart Row Locator    ${name}
    ${locator}=    Set Variable    ${row} >> css=[data-test="inventory-item-name"]
    RETURN    ${locator}

Cart Should Contain Exactly
    [Arguments]    ${expected_names}
    ${expected_count}=    Get Length    ${expected_names}
    ${rows}=    Cart Rows Locator
    Get Element Count    ${rows}    ==    ${expected_count}
    FOR    ${name}    IN    @{expected_names}
        ${row}=    Cart Row Locator    ${name}
        Get Element Count    ${row}    ==    1
    END

Remove Product In Cart
    [Arguments]    ${name}
    ${remove_button}=    Cart Remove Button Locator    ${name}
    Click    ${remove_button}
    ${row}=    Cart Row Locator    ${name}
    Get Element Count    ${row}    ==    0

Open Product Detail From Cart
    [Arguments]    ${name}
    ${name_locator}=    Cart Product Name Locator    ${name}
    Click    ${name_locator}
    Detail Should Show Product    ${name}

Continue Shopping
    Click    css=[data-test="continue-shopping"]
    Products Page Should Be Open

Proceed To Checkout
    Click    css=[data-test="checkout"]
    Get Text    css=[data-test="title"]    ==    Checkout: Your Information

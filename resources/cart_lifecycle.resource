*** Settings ***
Resource         common.resource
Resource         inventory.resource
Resource         cart.resource

*** Keywords ***
Add Every Product From Inventory And Details
    [Arguments]    ${names}
    ${remaining}=    Create List
    Should Not Be Empty    ${CART_ADD_VIEWS}
    Cart Badge Should Be Empty
    FOR    ${index}    ${name}    IN ENUMERATE    @{names}
        ${view_index}=    Evaluate    $index % len($CART_ADD_VIEWS)
        ${view}=    Get From List    ${CART_ADD_VIEWS}    ${view_index}
        IF    $view == 'listing'
            Add Product To Cart From Inventory    ${name}
        ELSE IF    $view == 'detail'
            Open Product Details From Inventory    ${name}
            Add Product To Cart From Details
            Back To Products
        ELSE
            Fail    Unsupported add view: ${view}
        END
        Append To List    ${remaining}    ${name}
        ${count}=    Get Length    ${remaining}
        Cart Badge Should Show Count    ${count}
        ${remove_button}=    Inventory Remove Button Locator    ${name}
        Get Element States    ${remove_button}    contains    visible
    END
    Open Shopping Cart
    Cart Should Contain Exactly    ${remaining}
    RETURN    ${remaining}

Remove Every Product From Cart Details And Inventory
    [Arguments]    ${names}    ${remaining}
    Should Not Be Empty    ${CART_REMOVE_VIEWS}
    FOR    ${index}    ${name}    IN ENUMERATE    @{names}
        ${view_index}=    Evaluate    $index % len($CART_REMOVE_VIEWS)
        ${view}=    Get From List    ${CART_REMOVE_VIEWS}    ${view_index}
        IF    $view == 'cart'
            Remove Product In Cart    ${name}
        ELSE IF    $view == 'detail'
            Open Product Detail From Cart    ${name}
            Remove Product From Cart In Details
            Back To Products
            Open Shopping Cart
        ELSE IF    $view == 'listing'
            Continue Shopping
            Remove Product From Cart In Inventory    ${name}
            Open Shopping Cart
        ELSE
            Fail    Unsupported remove view: ${view}
        END
        Remove Values From List    ${remaining}    ${name}
        ${count}=    Get Length    ${remaining}
        Cart Badge Should Show Count    ${count}
        Cart Should Contain Exactly    ${remaining}
    END
    Continue Shopping
    FOR    ${name}    IN    @{names}
        Inventory Should Show Add Button For    ${name}
    END

*** Settings ***
Resource         common.resource

*** Keywords ***
Products Page Should Be Open
    Get Text    css=[data-test="title"]    ==    Products
    Get Element Count    css=[data-test="inventory-item"]    ==    ${EXPECTED_CATALOG_SIZE}

Inventory Product Locator
    [Arguments]    ${name}
    ${locator}=    Set Variable    css=[data-test="inventory-item"]:has([data-test="inventory-item-name"]:text-is("${name}"))
    RETURN    ${locator}

Inventory Add Button Locator
    [Arguments]    ${name}
    ${product}=    Inventory Product Locator    ${name}
    RETURN    ${product} >> css=button[data-test^="add-to-cart"]

Inventory Remove Button Locator
    [Arguments]    ${name}
    ${product}=    Inventory Product Locator    ${name}
    RETURN    ${product} >> css=button[data-test^="remove"]

Inventory Product Name Locator
    [Arguments]    ${name}
    ${product}=    Inventory Product Locator    ${name}
    RETURN    ${product} >> css=[data-test="inventory-item-name"]

Read Product Names
    Get Element Count    css=[data-test="inventory-item"]    ==    ${EXPECTED_CATALOG_SIZE}
    ${names}=    Get Text    css=[data-test="inventory-item-name"]    text_type=allInnerTexts
    Length Should Be    ${names}    ${EXPECTED_CATALOG_SIZE}
    RETURN    ${names}

Read Product Catalog
    ${names}=    Read Product Names
    ${price_texts}=    Get Text    css=[data-test="inventory-item-price"]    text_type=allInnerTexts
    ${prices}=    Create List
    ${price_map}=    Create Dictionary
    ${name_count}=    Get Length    ${names}
    Length Should Be    ${price_texts}    ${name_count}
    FOR    ${index}    ${name}    IN ENUMERATE    @{names}
        ${price_text}=    Get From List    ${price_texts}    ${index}
        ${cents}=    Money Text To Cents    ${price_text}
        Dictionary Should Not Contain Key    ${price_map}    ${name}
        Append To List    ${prices}    ${cents}
        Set To Dictionary    ${price_map}    ${name}    ${cents}
    END
    RETURN    ${names}    ${prices}    ${price_map}

Select Sort Option And Verify Names
    [Arguments]    ${sort_code}    ${expected_names}    ${original_price_map}
    Select Options By    css=[data-test="product-sort-container"]    value    ${sort_code}
    Get Property    css=[data-test="product-sort-container"]    value    ==    ${sort_code}
    FOR    ${index}    ${expected_name}    IN ENUMERATE    @{expected_names}
        Get Text    css=[data-test="inventory-item-name"] >> nth=${index}    ==    ${expected_name}
    END
    ${actual_names}    ${actual_prices}    ${actual_price_map}=    Read Product Catalog
    Lists Should Be Equal    ${actual_names}    ${expected_names}
    Dictionaries Should Be Equal    ${actual_price_map}    ${original_price_map}

Select Sort Option And Verify Prices
    [Arguments]    ${sort_code}    ${expected_prices}    ${original_price_map}
    Select Options By    css=[data-test="product-sort-container"]    value    ${sort_code}
    Get Property    css=[data-test="product-sort-container"]    value    ==    ${sort_code}
    FOR    ${index}    ${expected_cents}    IN ENUMERATE    @{expected_prices}
        ${expected_text}=    Cents To Currency Text    ${expected_cents}
        Get Text    css=[data-test="inventory-item-price"] >> nth=${index}    ==    ${expected_text}
    END
    ${actual_names}    ${actual_prices}    ${actual_price_map}=    Read Product Catalog
    Lists Should Be Equal    ${actual_prices}    ${expected_prices}
    Dictionaries Should Be Equal    ${actual_price_map}    ${original_price_map}

Add Product To Cart From Inventory
    [Arguments]    ${name}
    ${button}=    Inventory Add Button Locator    ${name}
    Click    ${button}
    ${remove_button}=    Inventory Remove Button Locator    ${name}
    Get Element States    ${remove_button}    contains    visible

Remove Product From Cart In Inventory
    [Arguments]    ${name}
    ${button}=    Inventory Remove Button Locator    ${name}
    Click    ${button}
    Inventory Should Show Add Button For    ${name}

Inventory Should Show Add Button For
    [Arguments]    ${name}
    ${button}=    Inventory Add Button Locator    ${name}
    Get Element States    ${button}    contains    visible

Open Product Details From Inventory
    [Arguments]    ${name}
    ${name_locator}=    Inventory Product Name Locator    ${name}
    Click    ${name_locator}
    Detail Should Show Product    ${name}

Detail Should Show Product
    [Arguments]    ${name}
    Get Text    css=[data-test="inventory-item-name"]    ==    ${name}

Add Product To Cart From Details
    Click    css=button[data-test^="add-to-cart"]
    Get Element States    css=button[data-test^="remove"]    contains    visible

Remove Product From Cart In Details
    Click    css=button[data-test^="remove"]
    Get Element States    css=button[data-test^="add-to-cart"]    contains    visible

Back To Products
    Click    css=[data-test="back-to-products"]
    Products Page Should Be Open

Open Shopping Cart
    Click    css=[data-test="shopping-cart-link"]
    Get Text    css=[data-test="title"]    ==    Your Cart

Add Selected Products And Read Prices
    [Arguments]    ${selected_names}
    ${price_map}=    Create Dictionary
    ${subtotal_cents}=    Set Variable    ${0}
    FOR    ${name}    IN    @{selected_names}
        ${item}=    Inventory Product Locator    ${name}
        ${price_text}=    Get Text    ${item} >> css=[data-test="inventory-item-price"]
        ${price_cents}=    Money Text To Cents    ${price_text}
        Set To Dictionary    ${price_map}    ${name}    ${price_cents}
        ${subtotal_cents}=    Evaluate    $subtotal_cents + $price_cents
        Add Product To Cart From Inventory    ${name}
    END
    RETURN    ${price_map}    ${subtotal_cents}

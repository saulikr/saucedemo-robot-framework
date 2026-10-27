*** Settings ***
Resource    common.resource
Resource    cart.resource

*** Keywords ***
Fill Customer Information
    [Arguments]    ${first}    ${last}    ${postal}
    Fill Text    css=[data-test="firstName"]    ${first}
    Fill Text    css=[data-test="lastName"]     ${last}
    Fill Text    css=[data-test="postalCode"]   ${postal}

Checkout Should Reject Missing Field
    [Arguments]    ${first}    ${last}    ${postal}    ${expected_message}
    Fill Customer Information    ${first}    ${last}    ${postal}
    Click    css=[data-test="continue"]
    Get Text    css=[data-test="error"]    contains    ${expected_message}
    Get Text    css=[data-test="title"]    ==    Checkout: Your Information

Cancel Checkout Information
    Click    css=[data-test="cancel"]
    Get Text    css=[data-test="title"]    ==    Your Cart

Continue To Overview
    Click    css=[data-test="continue"]
    Get Text    css=[data-test="title"]    ==    Checkout: Overview

Cancel Checkout Overview
    Click    css=[data-test="cancel"]
    Get Text    css=[data-test="title"]    ==    Products

Overview Should Contain Exactly
    [Arguments]    ${expected_names}
    Cart Should Contain Exactly    ${expected_names}

Overview Totals Should Be Correct
    [Arguments]    ${expected_subtotal_cents}
    ${subtotal_text}=    Get Text    css=[data-test="subtotal-label"]
    ${tax_text}=         Get Text    css=[data-test="tax-label"]
    ${total_text}=       Get Text    css=[data-test="total-label"]
    ${subtotal}=    Money Text To Cents    ${subtotal_text}
    ${tax}=         Money Text To Cents    ${tax_text}
    ${total}=       Money Text To Cents    ${total_text}
    Should Be Equal As Integers    ${subtotal}    ${expected_subtotal_cents}
    Should Be True                 ${tax} >= 0
    ${expected_total}=    Evaluate    ${subtotal} + ${tax}
    Should Be Equal As Integers    ${total}    ${expected_total}
    RETURN    ${tax}    ${total}

Finish Order
    Click    css=[data-test="finish"]
    Get Text    css=[data-test="complete-header"]    ==    Thank you for your order!

Back To Products After Order
    Click    css=[data-test="back-to-products"]
    Get Text    css=[data-test="title"]    ==    Products

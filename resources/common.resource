*** Settings ***
Library     Browser
Library     Collections
Library     String
Resource    test_data.resource

*** Keywords ***
Start Test Browser
    New Browser    chromium    headless=${HEADLESS}
    Set Retry Assertions For    ${ASSERTION_RETRY_TIMEOUT}

Open Fresh Session
    New Context    acceptDownloads=True
    New Page    ${BASE_URL}
    Get Element States    css=[data-test="username"]    contains    visible

Close Test Session
    Close Context

Money Text To Cents
    [Arguments]    ${text}
    ${number}=    Fetch From Right    ${text}    $
    ${number}=    Strip String    ${number}
    @{parts}=    Split String    ${number}    .
    Length Should Be    ${parts}    2
    ${decimal_places}=    Get Length    ${parts}[1]
    Should Be Equal As Integers    ${decimal_places}    2
    ${dollars}=    Convert To Integer    ${parts}[0]
    ${cents}=      Convert To Integer    ${parts}[1]
    ${result}=     Evaluate    ${dollars} * 100 + ${cents}
    RETURN    ${result}

Cart Badge Should Show Count
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 0
        Cart Badge Should Be Empty
    ELSE
        ${expected_text}=    Convert To String    ${expected_count}
        Get Text    css=[data-test="shopping-cart-badge"]    ==    ${expected_text}
    END

Cart Badge Should Be Empty
    # SauceDemo removes the badge when the cart is empty.
    Get Element Count    css=[data-test="shopping-cart-badge"]    ==    0

Cents To Currency Text
    [Arguments]    ${cents}
    ${currency}=    Evaluate    "$%d.%02d" % ($cents // 100, $cents % 100)
    RETURN    ${currency}

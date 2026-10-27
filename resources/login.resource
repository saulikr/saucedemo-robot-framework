*** Settings ***
Resource    common.resource

*** Keywords ***
Sign In
    [Arguments]    ${username}    ${password}
    Fill Text    css=[data-test="username"]    ${username}
    Fill Text    css=[data-test="password"]    ${password}
    Click        css=[data-test="login-button"]

Sign In As Standard User
    Sign In    ${STANDARD_USER}    ${PASSWORD}
    Get Text    css=[data-test="title"]    ==    Products

Login Should Be Denied
    [Arguments]    ${username}    ${password}    ${expected_error}
    Sign In    ${username}    ${password}
    Get Text    css=[data-test="error"]    contains    ${expected_error}
    Get Element States    css=[data-test="username"]    contains    visible
    Get Element Count    css=[data-test="title"]    ==    0

Login Should Succeed In Fresh Session
    [Arguments]    ${username}
    ${original_timeout}=    Set Variable    ${None}
    IF    $username == $SLOW_LOGIN_USER
        ${original_timeout}=    Set Browser Timeout    ${SLOW_LOGIN_TIMEOUT}
    END
    TRY
        Open Fresh Session
        Sign In    ${username}    ${PASSWORD}
        Get Text    css=[data-test="title"]    ==    Products
        Get Element Count    css=[data-test="inventory-item"]    ==    ${EXPECTED_CATALOG_SIZE}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
        IF    $username == $SLOW_LOGIN_USER
            Set Browser Timeout    ${original_timeout}
        END
    END

Login Should Be Denied In Fresh Session
    [Arguments]    ${username}    ${password}    ${expected_error}
    TRY
        Open Fresh Session
        Login Should Be Denied    ${username}    ${password}    ${expected_error}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

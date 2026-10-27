*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/login.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser

*** Test Cases ***
All Demo Accounts Respect Login Rules
    FOR    ${username}    IN    @{LOGIN_ENABLED_USERS}
        Run Keyword And Continue On Failure    Login Should Succeed In Fresh Session    ${username}
    END
    Run Keyword And Continue On Failure
    ...    Login Should Be Denied In Fresh Session
    ...    ${LOCKED_USER}
    ...    ${PASSWORD}
    ...    ${LOCKED_LOGIN_ERROR}
    Run Keyword And Continue On Failure
    ...    Login Should Be Denied In Fresh Session
    ...    ${STANDARD_USER}
    ...    ${INVALID_PASSWORD}
    ...    ${INVALID_LOGIN_ERROR}

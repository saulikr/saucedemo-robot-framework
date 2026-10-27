*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/login.resource
Resource          ../resources/inventory.resource
Resource          ../resources/cart_lifecycle.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser
Test Setup        Open Fresh Session
Test Teardown     Close Test Session

*** Test Cases ***
Every Product Can Be Added And Removed Across Views
    Sign In As Standard User
    Products Page Should Be Open
    ${names}=    Read Product Names
    ${remaining}=    Add Every Product From Inventory And Details    ${names}
    Remove Every Product From Cart Details And Inventory    ${names}    ${remaining}

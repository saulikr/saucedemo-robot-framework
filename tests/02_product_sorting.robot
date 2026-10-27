*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/login.resource
Resource          ../resources/inventory.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser
Test Setup        Open Fresh Session
Test Teardown     Close Test Session

*** Test Cases ***
All Four Sort Options Reorder Products Correctly
    Sign In As Standard User
    Products Page Should Be Open
    ${names}    ${prices}    ${price_map}=    Read Product Catalog

    ${alphabetical}=    Copy List    ${names}
    Sort List    ${alphabetical}
    ${reverse_alphabetical}=    Copy List    ${alphabetical}
    Reverse List    ${reverse_alphabetical}
    Select Sort Option And Verify Names    ${SORT_NAME_DESC}    ${reverse_alphabetical}    ${price_map}
    Select Sort Option And Verify Names    ${SORT_NAME_ASC}    ${alphabetical}    ${price_map}

    ${ascending_prices}=    Copy List    ${prices}
    Sort List    ${ascending_prices}
    ${descending_prices}=    Copy List    ${ascending_prices}
    Reverse List    ${descending_prices}
    Select Sort Option And Verify Prices    ${SORT_PRICE_ASC}    ${ascending_prices}     ${price_map}
    Select Sort Option And Verify Prices    ${SORT_PRICE_DESC}    ${descending_prices}    ${price_map}

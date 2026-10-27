*** Settings ***
Resource          ../resources/common.resource
Resource          ../resources/navigation.resource
Suite Setup       Start Test Browser
Suite Teardown    Close Browser

*** Test Cases ***
Navigation Menu Actions Reach Expected Destinations
    Run Keyword And Continue On Failure    Menu Opens Closes And Reopens
    Run Keyword And Continue On Failure    All Items Navigates Back To Products
    Run Keyword And Continue On Failure    Reset App State Clears Shopping Cart
    Run Keyword And Continue On Failure    Logout Returns To Login Page
    Run Keyword And Continue On Failure    About Opens Sauce Labs Website

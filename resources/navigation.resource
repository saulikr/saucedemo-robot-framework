*** Settings ***
Resource         common.resource
Resource         login.resource
Resource         inventory.resource
Resource         cart.resource

*** Variables ***
${MENU_BUTTON}       css=#react-burger-menu-btn
${MENU_CLOSE_BUTTON}    css=#react-burger-cross-btn
${ALL_ITEMS_LINK}    css=#inventory_sidebar_link
${ABOUT_LINK}        css=#about_sidebar_link
${LOGOUT_LINK}       css=#logout_sidebar_link
${RESET_LINK}        css=#reset_sidebar_link

*** Keywords ***
Close Navigation Menu If Open
    # Reset App State can leave the sidebar open.
    ${states}=    Get Element States    ${MENU_CLOSE_BUTTON}
    IF    'visible' in $states
        Click    ${MENU_CLOSE_BUTTON}
    END

Add Products For Menu Tests
    ${products}=    Create List    @{NAVIGATION_TEST_PRODUCTS}
    Should Not Be Empty    ${products}
    FOR    ${name}    IN    @{products}
        Add Product To Cart From Inventory    ${name}
    END
    RETURN    ${products}

Open Navigation Menu
    Click    ${MENU_BUTTON}
    Get Element States    ${ALL_ITEMS_LINK}    contains    visible

Menu Should Show All Four Options
    Get Text    ${ALL_ITEMS_LINK}    ==    All Items
    Get Text    ${ABOUT_LINK}        ==    About
    Get Text    ${LOGOUT_LINK}       ==    Logout
    Get Text    ${RESET_LINK}        ==    Reset App State

Menu Opens Closes And Reopens
    TRY
        Open Fresh Session
        Sign In As Standard User
        Open Navigation Menu
        Menu Should Show All Four Options
        Click    ${MENU_CLOSE_BUTTON}
        Get Element States    ${MENU_BUTTON}    contains    visible
        Open Navigation Menu
        Menu Should Show All Four Options
        Click    ${MENU_CLOSE_BUTTON}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

All Items Navigates Back To Products
    TRY
        Open Fresh Session
        Sign In As Standard User
        ${added_products}=    Add Products For Menu Tests
        Open Shopping Cart
        Open Navigation Menu
        Click    ${ALL_ITEMS_LINK}
        Products Page Should Be Open
        ${expected_count}=    Get Length    ${added_products}
        Cart Badge Should Show Count    ${expected_count}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

Reset App State Clears Shopping Cart
    TRY
        Open Fresh Session
        Sign In As Standard User
        ${added_products}=    Add Products For Menu Tests
        ${expected_count}=    Get Length    ${added_products}
        Cart Badge Should Show Count    ${expected_count}
        Open Navigation Menu
        Click    ${RESET_LINK}
        Cart Badge Should Be Empty
        Close Navigation Menu If Open
        Open Shopping Cart
        ${empty_cart}=    Create List
        Cart Should Contain Exactly    ${empty_cart}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

Logout Returns To Login Page
    TRY
        Open Fresh Session
        Sign In As Standard User
        Open Navigation Menu
        Click    ${LOGOUT_LINK}
        Get Element States    css=[data-test="login-button"]    contains    visible
        Get Element States    css=[data-test="username"]    contains    visible
        Get Element Count    css=[data-test="title"]    ==    0
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

About Opens Sauce Labs Website
    TRY
        Open Fresh Session
        Sign In As Standard User
        Open Navigation Menu
        # Check the link destination, not third-party website availability.
        Get Attribute    ${ABOUT_LINK}    href    contains    ${ABOUT_EXPECTED_DOMAIN}
        Click With Options    ${ABOUT_LINK}    noWaitAfter=${True}
        Get Url    contains    ${ABOUT_EXPECTED_DOMAIN}
    FINALLY
        Run Keyword And Ignore Error    Close Test Session
    END

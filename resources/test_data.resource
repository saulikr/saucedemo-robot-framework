*** Variables ***
${BASE_URL}                     https://www.saucedemo.com/
${HEADLESS}                     ${True}
${ASSERTION_RETRY_TIMEOUT}      5s
${SLOW_LOGIN_TIMEOUT}          60s
${PDF_DOWNLOAD_TIMEOUT}        30s

${STANDARD_USER}               standard_user
${LOCKED_USER}                 locked_out_user
${SLOW_LOGIN_USER}             performance_glitch_user
${PASSWORD}                    secret_sauce
${INVALID_PASSWORD}            incorrect_password
${LOCKED_LOGIN_ERROR}          Sorry, this user has been locked out
${INVALID_LOGIN_ERROR}         Username and password do not match
${FIRST_NAME_REQUIRED_ERROR}   First Name is required
${LAST_NAME_REQUIRED_ERROR}    Last Name is required
${POSTAL_CODE_REQUIRED_ERROR}  Postal Code is required
${ABOUT_EXPECTED_DOMAIN}       saucelabs.com
@{LOGIN_ENABLED_USERS}         ${STANDARD_USER}    problem_user    ${SLOW_LOGIN_USER}    error_user    visual_user

# Fixed demo catalog size is a contract assertion, not an iteration limit.
${EXPECTED_CATALOG_SIZE}       6

# SauceDemo sort values are option identifiers, not displayed labels.
${SORT_NAME_ASC}               az
${SORT_NAME_DESC}              za
${SORT_PRICE_ASC}              lohi
${SORT_PRICE_DESC}             hilo

${BACKPACK}                    Sauce Labs Backpack
${BIKE_LIGHT}                  Sauce Labs Bike Light
@{CHECKOUT_VALIDATION_PRODUCTS}    ${BACKPACK}
@{ORDER_PRODUCTS}              ${BACKPACK}    ${BIKE_LIGHT}
@{NAVIGATION_TEST_PRODUCTS}    ${BACKPACK}

@{CART_ADD_VIEWS}              listing    detail
@{CART_REMOVE_VIEWS}           cart    detail    listing

${CUSTOMER_FIRST_NAME}         Ada
${CUSTOMER_LAST_NAME}          Lovelace
${CUSTOMER_POSTAL_CODE}        00100
&{ORDER_CUSTOMER}             first_name=${CUSTOMER_FIRST_NAME}    last_name=${CUSTOMER_LAST_NAME}    postal_code=${CUSTOMER_POSTAL_CODE}

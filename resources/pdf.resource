*** Settings ***
Resource         common.resource
Library          OperatingSystem

*** Keywords ***
Download Completed Order PDF
    ${receipt_dir}=    Join Path    ${RUN_DIR}    pdf
    Create Directory    ${receipt_dir}
    ${receipt_path}=    Join Path    ${receipt_dir}    order-receipt-${RUN_ID}.pdf
    # Listen before clicking to avoid missing an immediate download.
    ${promise}=    Promise To Wait For Download    saveAs=${receipt_path}    download_timeout=${PDF_DOWNLOAD_TIMEOUT}
    Click    css=[data-test="generate-pdf-order"]
    ${download}=    Wait For    ${promise}
    Should Be Equal    ${download}[state]    finished
    Should Start With    ${download}[suggestedFilename]    swag-labs-order-
    Should End With    ${download}[suggestedFilename]    .pdf
    File Should Exist    ${download}[saveAs]
    RETURN    ${download}[saveAs]

PDF Receipt Should Match Completed Checkout
    [Arguments]    ${receipt_path}    ${product_names}    ${item_price_map}    ${subtotal_cents}    ${tax_cents}    ${total_cents}    ${customer}
    ${pdf_bytes}=    Get Binary File    ${receipt_path}
    Should Not Be Empty    ${pdf_bytes}
    Should Be True    $pdf_bytes.startswith(b'%PDF-')
    ${reader}=    Evaluate    pypdf.PdfReader($receipt_path)    modules=pypdf
    ${page_count}=    Evaluate    len($reader.pages)
    Should Be True    ${page_count} >= 1
    ${text}=    Evaluate    ' '.join(' '.join((page.extract_text() or '').split()) for page in $reader.pages)

    Should Contain    ${text}    Swag Labs
    Should Contain    ${text}    Order Receipt
    Should Contain    ${text}    Order Date
    Should Contain    ${text}    SHIP TO ${customer}[first_name] ${customer}[last_name] ${customer}[postal_code]
    FOR    ${product_name}    IN    @{product_names}
        ${price_cents}=    Get From Dictionary    ${item_price_map}    ${product_name}
        ${price}=    Cents To Currency Text    ${price_cents}
        Should Contain    ${text}    ${product_name} ${price}
    END
    ${subtotal}=    Cents To Currency Text    ${subtotal_cents}
    ${tax}=    Cents To Currency Text    ${tax_cents}
    ${total}=    Cents To Currency Text    ${total_cents}
    Should Contain    ${text}    Item total ${subtotal}
    Should Contain    ${text}    Tax ${tax}
    Should Contain    ${text}    Total ${total}
    Should Contain    ${text}    Thank you for your order!

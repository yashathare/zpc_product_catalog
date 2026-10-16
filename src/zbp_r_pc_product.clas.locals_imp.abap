CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS setDefaults       FOR DETERMINE ON MODIFY IMPORTING keys FOR Product~setDefaults.
    METHODS validateProductId FOR VALIDATE ON SAVE    IMPORTING keys FOR Product~validateProductId.
    METHODS validatePrice     FOR VALIDATE ON SAVE    IMPORTING keys FOR Product~validatePrice.
    METHODS validateStock     FOR VALIDATE ON SAVE    IMPORTING keys FOR Product~validateStock.
    METHODS validateCurrency  FOR VALIDATE ON SAVE    IMPORTING keys FOR Product~validateCurrency.
ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD setDefaults.
    READ ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product FIELDS ( CurrencyCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(products).
    DELETE products WHERE CurrencyCode IS NOT INITIAL.
    CHECK products IS NOT INITIAL.
    MODIFY ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product UPDATE FIELDS ( CurrencyCode )
      WITH VALUE #( FOR p IN products ( %tky = p-%tky CurrencyCode = 'EUR' ) ).
  ENDMETHOD.

  METHOD validateProductId.
    READ ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product FIELDS ( ProductId ) WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).
      APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_PRODUCT_ID' ) TO reported-product.
      IF product-ProductId IS INITIAL.
        CONTINUE.
      ENDIF.

      IF NOT matches( val = product-ProductId regex = '[A-Z0-9][A-Z0-9-]*' ).
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.
        APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_PRODUCT_ID'
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                   text = 'Product ID may only contain upper-case letters, digits and hyphens.' )
          %element-ProductId = if_abap_behv=>mk-on ) TO reported-product.
        CONTINUE.
      ENDIF.

      SELECT SINGLE @abap_true FROM zr_pc_product
        WHERE ProductId = @product-ProductId AND ProductUuid <> @product-ProductUuid
        INTO @DATA(exists).
      IF sy-subrc = 0.
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.
        APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_PRODUCT_ID'
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                   text = |Product ID { product-ProductId } already exists.| )
          %element-ProductId = if_abap_behv=>mk-on ) TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePrice.
    READ ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product FIELDS ( Price ) WITH CORRESPONDING #( keys )
      RESULT DATA(products).
    LOOP AT products INTO DATA(product).
      APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_PRICE' ) TO reported-product.
      IF product-Price <= 0.
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.
        APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_PRICE'
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                   text = 'Price must be greater than zero.' )
          %element-Price = if_abap_behv=>mk-on ) TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateStock.
    READ ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product FIELDS ( Stock ) WITH CORRESPONDING #( keys )
      RESULT DATA(products).
    LOOP AT products INTO DATA(product).
      APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_STOCK' ) TO reported-product.
      IF product-Stock < 0.
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.
        APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_STOCK'
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                   text = 'Stock must not be negative.' )
          %element-Stock = if_abap_behv=>mk-on ) TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCurrency.
    READ ENTITIES OF zr_pc_product IN LOCAL MODE
      ENTITY Product FIELDS ( CurrencyCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(products).
    LOOP AT products INTO DATA(product).
      APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_CURRENCY' ) TO reported-product.
      IF product-CurrencyCode IS INITIAL.
        CONTINUE.
      ENDIF.
      SELECT SINGLE @abap_true FROM I_Currency
        WHERE Currency = @product-CurrencyCode INTO @DATA(valid).
      IF sy-subrc <> 0.
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.
        APPEND VALUE #( %tky = product-%tky %state_area = 'VALIDATE_CURRENCY'
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                   text = |Currency { product-CurrencyCode } is not valid.| )
          %element-CurrencyCode = if_abap_behv=>mk-on ) TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

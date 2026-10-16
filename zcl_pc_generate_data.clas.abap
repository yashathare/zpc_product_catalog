CLASS zcl_pc_generate_data DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_pc_generate_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA products TYPE STANDARD TABLE OF zpc_product WITH DEFAULT KEY.
    GET TIME STAMP FIELD DATA(ts).
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).

    products = VALUE #(
      ( product_id = 'LAP-1001' product_name = 'ProBook 14 Laptop'      category = 'Electronics'     price = '899.00' currency_code = 'EUR' stock = 25  description = '14-inch business laptop, 16 GB RAM, 512 GB SSD' )
      ( product_id = 'MON-2001' product_name = 'UltraView 27 Monitor'   category = 'Electronics'     price = '299.90' currency_code = 'EUR' stock = 8   description = '27-inch 4K IPS monitor' )
      ( product_id = 'KEY-3001' product_name = 'Ergo Wireless Keyboard' category = 'Accessories'     price = '59.50'  currency_code = 'EUR' stock = 120 description = 'Ergonomic wireless keyboard' )
      ( product_id = 'MOU-3002' product_name = 'Precision Mouse'        category = 'Accessories'     price = '39.00'  currency_code = 'EUR' stock = 0   description = 'Wireless precision mouse' )
      ( product_id = 'DSK-4001' product_name = 'Standing Desk 160cm'    category = 'Furniture'       price = '549.00' currency_code = 'EUR' stock = 6   description = 'Height-adjustable standing desk' )
      ( product_id = 'CHR-4002' product_name = 'Office Chair Comfort'   category = 'Furniture'       price = '249.00' currency_code = 'EUR' stock = 40  description = 'Ergonomic office chair' )
      ( product_id = 'PEN-5001' product_name = 'Gel Pens (Pack of 10)'  category = 'Office Supplies' price = '7.90'   currency_code = 'EUR' stock = 500 description = 'Blue gel pens' )
      ( product_id = 'NTB-5002' product_name = 'A5 Notebook'            category = 'Office Supplies' price = '4.50'   currency_code = 'EUR' stock = 3   description = 'Hardcover A5 notebook, dotted' ) ).

    TRY.
        LOOP AT products ASSIGNING FIELD-SYMBOL(<p>).
          <p>-product_uuid          = cl_system_uuid=>create_uuid_x16_static( ).
          <p>-created_by            = user.
          <p>-created_at            = ts.
          <p>-last_changed_at       = ts.
          <p>-local_last_changed_at = ts.
        ENDLOOP.
      CATCH cx_uuid_error INTO DATA(uuid_error).
        out->write( uuid_error->get_text( ) ).
        RETURN.
    ENDTRY.

    DELETE FROM zpc_product.
    INSERT zpc_product FROM TABLE @products.
    out->write( |{ sy-dbcnt } products inserted.| ).
  ENDMETHOD.
ENDCLASS.

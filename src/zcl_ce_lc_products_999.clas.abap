CLASS zcl_ce_lc_products_999 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_rap_query_provider.

    CONSTANTS:
      gc_url          TYPE string VALUE 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/',
      gc_service_root TYPE string VALUE 'API_PRODUCT_SRV/'.

    TYPES t_product_range TYPE RANGE OF zz_lc_a_product-product.
    TYPES t_business_data TYPE TABLE OF zz_lc_a_product.

    METHODS:
      get_products
        IMPORTING
          it_filter_cond   TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
          top              TYPE i OPTIONAL
          skip             TYPE i OPTIONAL
        EXPORTING
          et_business_data TYPE  t_business_data
        RAISING
          /iwbep/cx_cp_remote
          /iwbep/cx_gateway
          cx_web_http_client_error
          cx_http_dest_provider_error.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_lc_products_999 IMPLEMENTATION.

  METHOD get_products.

    DATA: lt_business_data TYPE TABLE OF zz_lc_a_product,
          lo_http_client   TYPE REF TO if_web_http_client,
          lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA: lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    TRY.
        " Create http client
        " Details depend on your connection settings
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                                  cl_http_destination_provider=>create_by_url(
                                          i_url = gc_url ) ).

        DATA(lo_http_request) = lo_http_client->get_http_request( ).
        lo_http_request->set_header_fields(
            VALUE #(
                (  name = 'Accept' value = 'application/json' )
                (  name = 'APIKey' value = 'k7mbUeEXNGv0Sn5WdAPYAFJ8KIwa3bvr' )
        ) ).


        lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
          EXPORTING
            iv_service_definition_name = 'Z_LC_PRODUCTS_999'
            io_http_client             = lo_http_client
            iv_relative_service_root   = gc_service_root ).

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_PRODUCT' )->create_request_for_read( ).



        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).


        LOOP AT it_filter_cond INTO DATA(ls_filter_cond).
          DATA(lo_filter_node)  = lo_filter_factory->create_by_range( iv_property_path     = ls_filter_cond-name
                                                                      it_range             = ls_filter_cond-range ).

          IF lo_filter_node_root IS INITIAL.
            lo_filter_node_root = lo_filter_node.
          ELSE.
            lo_filter_node_root = lo_filter_node_root->and( lo_filter_node ).

          ENDIF.

        ENDLOOP.

        IF lo_filter_node_root IS NOT INITIAL.
          lo_request->set_filter( lo_filter_node_root ).
        ENDIF.



        lo_request->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = et_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

    ENDTRY.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA business_data TYPE TABLE OF zz_lc_a_product.
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    ranges_table = VALUE #( (  sign = 'I' option = 'CP' low = '*AVC*' ) ).
    filter_conditions = VALUE #( ( name = 'PRODUCT'  range = ranges_table ) ).

    TRY.
        get_products(
          EXPORTING
            it_filter_cond    = filter_conditions
            top               =  3
            skip              =  1
          IMPORTING
            et_business_data  = business_data
          ) .
        out->write( business_data ).

      CATCH cx_root INTO DATA(exception).

        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD if_rap_query_provider~select.

    DATA lt_business_data TYPE TABLE OF zz_lc_a_product.
    DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).

        get_products(
                 EXPORTING
                   it_filter_cond    = lt_filter_cond
                   top               = CONV i( lv_top )
                   skip              = CONV i( lv_skip )
                 IMPORTING
                   et_business_data  = lt_business_data
                 ) .

        io_response->set_total_number_of_records( lines( lt_business_data ) ).
        io_response->set_data( lt_business_data ).

      CATCH cx_root INTO DATA(lx_root).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_root )->if_message~get_longtext( ).
    ENDTRY.


  ENDMETHOD.

ENDCLASS.

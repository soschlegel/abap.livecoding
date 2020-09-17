CLASS lhc_prod_rating DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS check_email FOR VALIDATE ON SAVE
      IMPORTING keys FOR prod_rating~check_email.

ENDCLASS.

CLASS lhc_prod_rating IMPLEMENTATION.

  METHOD check_email.

    READ ENTITIES OF ZLC_I_ProdRating_999 IN LOCAL MODE
      ENTITY prod_rating
        FIELDS ( email )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ratings).

    LOOP AT lt_ratings INTO DATA(ls_rating).

      DATA(lo_regex) = NEW cl_abap_regex(
        pattern       = '^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$'
        ignore_case   = abap_true ).


      DATA(lo_matcher) = lo_regex->create_matcher( text = ls_rating-email ).

      IF lo_matcher->match( ) IS INITIAL.

        APPEND VALUE #( %key = ls_rating-%key ) TO failed-prod_rating.

        APPEND VALUE #( %key = ls_rating-%key
                        %msg = new_message( id      = 'YSSC_LIVECODING'
                                            number  = '001'
                                            v1      = ls_rating-email
                                            severity = if_abap_behv_message=>severity-error )
                       %element-email = if_abap_behv=>mk-on ) TO reported-prod_rating.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

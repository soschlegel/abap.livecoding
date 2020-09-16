CLASS lhc_prod_rating DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS check_email FOR VALIDATE ON SAVE
      IMPORTING keys FOR prod_rating~check_email.

ENDCLASS.

CLASS lhc_prod_rating IMPLEMENTATION.

  METHOD check_email.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

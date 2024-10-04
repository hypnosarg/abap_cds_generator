CLASS zcx_caut_cds_generator DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF gc_activate_failed,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '060',
        attr1 TYPE scx_attrname VALUE 'GV_CDS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_activate_failed .
    CONSTANTS:
      BEGIN OF gc_cds_exists,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '062',
        attr1 TYPE scx_attrname VALUE 'GV_CDS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_cds_exists .
    CONSTANTS:
      BEGIN OF gc_delete_failed,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '061',
        attr1 TYPE scx_attrname VALUE 'GV_CDS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_delete_failed .
    CONSTANTS:
      BEGIN OF gc_join_exists,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '027',
        attr1 TYPE scx_attrname VALUE 'GV_TABLE',
        attr2 TYPE scx_attrname VALUE 'GV_ALIAS',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_join_exists .
    CONSTANTS:
      BEGIN OF gc_join_not_found,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '039',
        attr1 TYPE scx_attrname VALUE 'GV_TABLE',
        attr2 TYPE scx_attrname VALUE 'GV_ALIAS',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_join_not_found .
    CONSTANTS:
      BEGIN OF gc_save_failed,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '059',
        attr1 TYPE scx_attrname VALUE 'GV_CDS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_save_failed .
    CONSTANTS:
      BEGIN OF gc_transport_invalid,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '063',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_transport_invalid .
    CONSTANTS:
      BEGIN OF gc_view_exists,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '058',
        attr1 TYPE scx_attrname VALUE 'GV_VIEW',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_view_exists .
    CONSTANTS:
      BEGIN OF gc_adding_to_transport_failed,
        msgid TYPE symsgid VALUE 'ZCAUT',
        msgno TYPE symsgno VALUE '064',
        attr1 TYPE scx_attrname VALUE 'GV_CDS',
        attr2 TYPE scx_attrname VALUE 'GV_TRANSPORT',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_adding_to_transport_failed .
    DATA gv_alias TYPE string READ-ONLY .
    DATA gv_cds TYPE ddname READ-ONLY .
    DATA gv_table TYPE string READ-ONLY .
    DATA gv_transport TYPE trkorr READ-ONLY .
    DATA gv_view TYPE viewname16 READ-ONLY .

    METHODS constructor
      IMPORTING
        !iv_textid    LIKE if_t100_message=>t100key OPTIONAL
        !io_previous  LIKE previous OPTIONAL
        !iv_table     TYPE string OPTIONAL
        !iv_alias     TYPE string OPTIONAL
        !iv_cds       TYPE ddname OPTIONAL
        !iv_view      TYPE viewname16 OPTIONAL
        !iv_transport TYPE trkorr OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_caut_cds_generator IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = io_previous.

    me->gv_table = iv_table .
    me->gv_transport = iv_transport .
    me->gv_alias = iv_alias .
    me->gv_cds = iv_cds .
    me->gv_view = iv_view .

    CLEAR me->textid.
    IF iv_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

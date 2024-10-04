class ZCL_ACPF_CDS_GENERATOR definition
  public
  abstract
  create public .

public section.

  constants GC_NAME_SEPARATOR type CHAR1 value '_' ##NO_TEXT.

  class-methods CHECK_CDS_EXISTS
    importing
      !IV_CDS_NAME type DDNAME
    returning
      value(RV_EXISTS) type FLAG
    raising
      ZCX_CAUT_CDS_GENERATOR .
  class-methods CREATE_CDS_NAME
    importing
      !IV_LOGICAL_GROUP type ZACPF_D_LOGICAL_GROUP
      !IV_PARAMETER_NAME type ZACPF_D_CDS_CAT_PARAMETER_NAME
      !IV_PACKAGE type DEVCLASS
    returning
      value(RV_NAME) type ZACPF_D_CDS_VIEW_NAME .
  class-methods DELETE
    importing
      !IV_CDS_NAME type DDNAME
      !IV_TRANSPORT type TRKORR optional
    raising
      ZCX_ACPF_CDS_GENERATOR .
  class-methods PARSE_CDS_NAME
    importing
      !IV_CDS_NAME type DDNAME
    returning
      value(RV_PACKAGE) type DEVCLASS .
  methods CONSTRUCTOR
    importing
      !IV_LOGICAL_GROUP type ZACPF_D_LOGICAL_GROUP
      !IV_PARAMETER_NAME type ZACPF_D_CDS_CAT_PARAMETER_NAME .
  methods GENERATE
  abstract
    importing
      !IV_TRANSPORT type TRKORR optional
    raising
      ZCX_ACPF_CDS_GENERATOR .
protected section.

  data GV_LOGICAL_GROUP type ZACPF_D_LOGICAL_GROUP .
  data GV_PARAMETER_NAME type ZACPF_D_CDS_CAT_PARAMETER_NAME .

  methods CREATE_VIEW_ID
    importing
      !IV_ID type CHAR2 optional
    returning
      value(RV_ID) type CHAR2 .
  methods CREATE_VIEW_NAME
    importing
      !IV_CDS_NAME type ZACPF_D_CDS_VIEW_NAME
    returning
      value(RV_NAME) type VIEWNAME16 .
private section.
ENDCLASS.



CLASS ZCL_ACPF_CDS_GENERATOR IMPLEMENTATION.


  METHOD check_cds_exists.
    rv_exists = zcl_caut_cds_generator=>check_cds_exists( iv_cds_name ).
  ENDMETHOD.


  METHOD constructor.
    gv_logical_group = iv_logical_group.
    gv_parameter_name = iv_parameter_name.
  ENDMETHOD.


  METHOD create_cds_name.
    CONCATENATE iv_package 'CDS' iv_logical_group+0(6) iv_parameter_name
      INTO rv_name SEPARATED BY gc_name_separator.
  ENDMETHOD.


  METHOD create_view_id.
    IF iv_id IS INITIAL.
      rv_id = '00'. " first ID possible
      RETURN.
    ENDIF.

    DATA(lv_first_chars) = sy-abcde.
    DATA(lv_second_chars) = '0123456789' && lv_first_chars.
    DATA(lv_second_chars_length) = strlen( lv_second_chars ).

    CATCH SYSTEM-EXCEPTIONS OTHERS = 1.
      DATA(lv_number_id) = iv_id * 1.
      DATA(lv_next_number_id) = lv_number_id + 1.

      IF lv_next_number_id < 100.
        rv_id = |{ lv_next_number_id WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
      ELSE.
        rv_id = 'A0'. " first ID with a letter
      ENDIF.

      RETURN.
    ENDCATCH.
    CHECK sy-subrc <> 0.

    DATA(lv_first_char) = iv_id+0(1).
    DATA(lv_second_char) = iv_id+1(1).

    FIND FIRST OCCURRENCE OF lv_first_char IN lv_first_chars MATCH OFFSET DATA(lv_first_char_position).
    FIND FIRST OCCURRENCE OF lv_second_char IN lv_second_chars MATCH OFFSET DATA(lv_second_char_position).

    lv_second_char_position = lv_second_char_position + 1.
    IF lv_second_char_position >= lv_second_chars_length.
      lv_first_char_position = lv_first_char_position + 1.
      lv_second_char_position = 0.
    ENDIF.

    rv_id = lv_first_chars+lv_first_char_position(1) && lv_second_chars+lv_second_char_position(1).
  ENDMETHOD.


  METHOD create_view_name.
    CONSTANTS:
      lc_object_type_view TYPE objecttyp VALUE 'VIEW'.

    SELECT SINGLE objectname
      FROM ddldependency
      WHERE ddlname = @iv_cds_name
        AND objecttype = @lc_object_type_view
      INTO @rv_name.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.

    " get package from CDS name
    DATA(lv_package) = parse_cds_name( iv_cds_name ).

    " create view name with a star, to find the last one created
    CONCATENATE lv_package 'V' gv_logical_group+0(6)
      INTO DATA(lv_name) SEPARATED BY gc_name_separator.
    CONCATENATE lv_name '%' INTO DATA(lv_name_with_star).

    SELECT objectname
      FROM ddldependency
      WHERE objectname LIKE @lv_name_with_star
        AND objecttype = @lc_object_type_view
      ORDER BY objectname DESCENDING
      INTO @DATA(lv_last_view_name)
      UP TO 1 ROWS.

      EXIT.
    ENDSELECT.

    " view not found, this is the first CDS for the logical group
    IF sy-subrc <> 0.
      rv_name = lv_name && create_view_id( ).
      RETURN.
    ENDIF.

    DATA(lv_id) = lv_last_view_name+14(2).
    DATA(lv_next_id) = create_view_id( lv_id ).

    rv_name = lv_name && lv_next_id.
  ENDMETHOD.


  METHOD delete.
    TRY.
        zcl_caut_cds_generator=>delete(
          EXPORTING
            iv_name      = iv_cds_name
            iv_transport = iv_transport  ).
      CATCH zcx_caut_cds_generator INTO DATA(lo_generator_exception). " CDS Generator Exceptions
        RAISE EXCEPTION TYPE zcx_acpf_cds_generator
          EXPORTING
            iv_textid   = zcx_acpf_cds_generator=>gc_cds_deletion_failed
            iv_cds_name = iv_cds_name
            io_previous = lo_generator_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD parse_cds_name.
    CHECK iv_cds_name IS NOT INITIAL.
    SPLIT iv_cds_name AT gc_name_separator
      INTO rv_package DATA(lv_rest_of_name).                "#EC NEEDED
  ENDMETHOD.
ENDCLASS.

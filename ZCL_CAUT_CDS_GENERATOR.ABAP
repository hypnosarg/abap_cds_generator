class ZCL_CAUT_CDS_GENERATOR definition
  public
  final
  create public .

public section.

  types GTY_V_AUTHORIZATION_CHECK_TYPE type STRING .
  types GTY_V_CONDITION_TYPE type STRING .
  types GTY_V_JOIN_TYPE type STRING .
  types:
    BEGIN OF gty_s_from,
        table    TYPE string,
        alias    TYPE string,
        distinct TYPE boole_d,
      END OF gty_s_from .
  types:
    BEGIN OF gty_s_condition,
        type           TYPE gty_v_condition_type,
        left_table     TYPE string,
        left_field     TYPE string,
        operator       TYPE string,
        right_table    TYPE string,
        right_field    TYPE string,
        not            TYPE boole_d,
        open_brackets  TYPE boole_d,
        close_brackets TYPE boole_d,
      END OF gty_s_condition .
  types:
    gty_t_conditions TYPE STANDARD TABLE OF gty_s_condition WITH DEFAULT KEY .
  types:
    BEGIN OF gty_s_field,
        table TYPE string,
        field TYPE string,
        key   TYPE boole_d,
        alias TYPE string,
      END OF gty_s_field .
  types:
    gty_t_fields TYPE STANDARD TABLE OF gty_s_field WITH DEFAULT KEY .
  types:
    BEGIN OF gty_s_join,
        joined_table       TYPE string,
        joined_table_alias TYPE string,
        type               TYPE gty_v_join_type,
        on_clause          TYPE gty_t_conditions,
      END OF gty_s_join .
  types:
    gty_t_joins TYPE STANDARD TABLE OF gty_s_join WITH DEFAULT KEY .

  constants:
    BEGIN OF gc_authorization_check_type,
        check           TYPE gty_v_authorization_check_type VALUE '#CHECK',
        not_allowed     TYPE gty_v_authorization_check_type VALUE '#NOT_ALLOWED',
        not_required    TYPE gty_v_authorization_check_type VALUE '#NOT_REQUIRED',
        privileged_only TYPE gty_v_authorization_check_type VALUE '#PRIVILEGED_ONLY',
      END OF gc_authorization_check_type .
  constants:
    BEGIN OF gc_condition_type,
        and TYPE gty_v_condition_type VALUE 'AND',
        or  TYPE gty_v_condition_type VALUE 'OR',
      END OF gc_condition_type .
  constants:
    BEGIN OF gc_join_type,
        inner       TYPE gty_v_join_type VALUE 'INNER JOIN',
        left_outer  TYPE gty_v_join_type VALUE 'LEFT OUTER JOIN',
        right_outer TYPE gty_v_join_type VALUE 'RIGHT OUTER JOIN',
      END OF gc_join_type .
  constants GC_PACKAGE_LOCAL type DEVCLASS value '$TMP' ##NO_TEXT.
  data GS_FROM type GTY_S_FROM read-only .
  data GT_FIELDS type GTY_T_FIELDS read-only .
  data GT_GROUP_FIELDS type ACO_TT_STRING read-only .
  data GT_JOINS type GTY_T_JOINS read-only .
  data GT_WHERE type GTY_T_CONDITIONS read-only .
  data GV_AUTHORIZATION_CHECK type GTY_V_AUTHORIZATION_CHECK_TYPE read-only value GC_AUTHORIZATION_CHECK_TYPE-CHECK ##NO_TEXT.
  data GV_CDS_LABEL type STRING read-only .
  data GV_CDS_NAME type DDNAME read-only .
  data GV_OVERWRITE type BOOLE_D read-only value ABAP_FALSE ##NO_TEXT.
  data GV_VIEW_NAME type VIEWNAME16 read-only .

  class-methods ADD_TO_TRANSPORT
    importing
      !IV_CDS_NAME type CLIKE
      !IV_TRANSPORT type TRKORR
    raising
      ZCX_CAUT_CDS_GENERATOR .
  class-methods CHECK_CDS_EXISTS
    importing
      !IV_CDS_NAME type DDNAME
    returning
      value(RV_EXISTS) type FLAG
    raising
      ZCX_CAUT_CDS_GENERATOR .
  class-methods DELETE
    importing
      !IV_NAME type DDNAME
      !IV_TRANSPORT type TRKORR optional
    raising
      ZCX_CAUT_CDS_GENERATOR .
  methods ADD_FIELD
    importing
      !IV_TABLE type CLIKE optional
      !IV_FIELD type CLIKE
      !IV_IS_KEY type BOOLE_D optional
      !IV_ALIAS type CLIKE optional
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods ADD_GROUP_FIELD
    importing
      !IV_FIELD type CLIKE
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods ADD_JOIN_CONDITION
    importing
      !IV_TABLE type CLIKE
      !IV_ALIAS type CLIKE optional
      !IV_FIELD type CLIKE
      !IV_OPERATOR type CLIKE default '='
      !IV_RIGHT_TABLE type CLIKE optional
      !IV_RIGHT_FIELD type CLIKE
      !IV_TYPE type GTY_V_CONDITION_TYPE default GC_CONDITION_TYPE-AND
      !IV_NOT type BOOLE_D default ABAP_FALSE
      !IV_OPEN_BRACKETS type BOOLE_D default ABAP_FALSE
      !IV_CLOSE_BRACKETS type BOOLE_D default ABAP_FALSE
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR
    raising
      ZCX_CAUT_CDS_GENERATOR .
  methods ADD_JOIN_TABLE
    importing
      !IV_TABLE type CLIKE
      !IV_ALIAS type CLIKE optional
      !IV_TYPE type GTY_V_JOIN_TYPE default GC_JOIN_TYPE-INNER
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR
    raising
      ZCX_CAUT_CDS_GENERATOR .
  methods ADD_WHERE_CONDITION
    importing
      !IV_LEFT_TABLE type CLIKE optional
      !IV_LEFT_FIELD type CLIKE
      !IV_OPERATOR type CLIKE default '='
      !IV_RIGHT_TABLE type CLIKE optional
      !IV_RIGHT_FIELD type CLIKE
      !IV_TYPE type GTY_V_CONDITION_TYPE default GC_CONDITION_TYPE-AND
      !IV_NOT type BOOLE_D default ABAP_FALSE
      !IV_OPEN_BRACKETS type BOOLE_D default ABAP_FALSE
      !IV_CLOSE_BRACKETS type BOOLE_D default ABAP_FALSE
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods GENERATE
    importing
      !IV_PACKAGE type DEVCLASS
      !IV_TRANSPORT type TRKORR optional
    raising
      ZCX_CAUT_CDS_GENERATOR .
  methods SET_AUTHORIZATION_CHECK
    importing
      !IV_AUTHORIZATION_CHECK type GTY_V_AUTHORIZATION_CHECK_TYPE default GC_AUTHORIZATION_CHECK_TYPE-CHECK
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods SET_CDS_LABEL
    importing
      !IV_LABEL type TEXT40
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods SET_CDS_NAME
    importing
      !IV_CDS_NAME type DDNAME
      !IV_VIEW_NAME type VIEWNAME16
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR
    raising
      ZCX_CAUT_CDS_GENERATOR .
  methods SET_FROM
    importing
      !IV_TABLE type CLIKE
      !IV_ALIAS type CLIKE optional
      !IV_DISTINCT type BOOLE_D default ABAP_FALSE
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  methods SET_OVERWRITE
    importing
      !IV_OVERWRITE type BOOLE_D
    returning
      value(RO_INSTANCE) type ref to ZCL_CAUT_CDS_GENERATOR .
  PROTECTED SECTION.
private section.

  data GV_LEVEL type I .
  data GV_SOURCE type STRING .

  methods ADD_FIELDS .
  methods ADD_GROUP .
  methods ADD_HEADER .
  methods ADD_JOINS .
  methods ADD_NEW_LINE .
  methods ADD_SELECT .
  methods ADD_SOURCE
    importing
      !IV_SOURCE type STRING .
  methods ADD_WHERE .
  methods INDENT .
ENDCLASS.



CLASS ZCL_CAUT_CDS_GENERATOR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->ADD_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        CLIKE(optional)
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [--->] IV_IS_KEY                      TYPE        BOOLE_D(optional)
* | [--->] IV_ALIAS                       TYPE        CLIKE(optional)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_field.
    APPEND VALUE #(
      table = |{ iv_table CASE = LOWER }|
      field = |{ iv_field CASE = LOWER }|
      key = iv_is_key
      alias = |{ iv_alias CASE = LOWER }| ) TO gt_fields.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_FIELDS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_fields.
    " Add selection field list
    add_new_line( ).
    indent( ).
    add_source( |\{| ).

    gv_level = gv_level + 1.
    LOOP AT gt_fields REFERENCE INTO DATA(ld_field).
      IF sy-tabix > 1.
        add_source( |,| ).
      ENDIF.

      add_new_line( ).
      indent( ).

      IF ld_field->key = abap_true.
        add_source( |KEY | ).
      ENDIF.

      IF ld_field->table IS NOT INITIAL.
        add_source( |{ ld_field->table }.| ).
      ENDIF.

      add_source( |{ ld_field->field }| ).

      IF ld_field->alias IS NOT INITIAL.
        add_source( | AS { ld_field->alias }| ).
      ENDIF.
    ENDLOOP.
    gv_level = gv_level - 1.

    add_new_line( ).
    indent( ).
    add_source( |\}| ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_GROUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_group.
    CHECK gt_group_fields[] IS NOT INITIAL.

    add_new_line( ).
    add_source( |GROUP BY| ).

    LOOP AT gt_group_fields INTO DATA(lv_field).
      IF sy-tabix > 1.
        add_source( |,| ).
      ENDIF.

      add_source( | { lv_field }| ).
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->ADD_GROUP_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_group_field.
    APPEND |{ iv_field CASE = LOWER }| TO gt_group_fields.
    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_HEADER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_header.
    " Mandatory annotations
    indent( ).
    add_source( |@AbapCatalog.sqlViewName: '{ gv_view_name }'| ).
    add_new_line( ).
    indent( ).
    add_source( |@AbapCatalog.compiler.compareFilter: true| ).
    add_new_line( ).
    indent( ).
    add_source( |@AbapCatalog.preserveKey: true| ).
    add_new_line( ).
    indent( ).
    add_source( |@AccessControl.authorizationCheck: { gv_authorization_check }| ).
    add_new_line( ).
    indent( ).
    add_source( |@EndUserText.label: '{ gv_cds_label }'| ).
    add_new_line( ).
    add_new_line( ).

    " DDL source top
    indent( ).
    add_source( |DEFINE VIEW { gv_cds_name }| ).
    add_new_line( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_JOINS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_joins.
    CHECK gt_joins IS NOT INITIAL.

    " Add joins
    gv_level = gv_level + 2.
    LOOP AT gt_joins REFERENCE INTO DATA(ld_join).
      add_new_line( ).
      indent( ).

      add_source( |{ ld_join->type } { ld_join->joined_table }| ).
      IF ld_join->joined_table_alias IS NOT INITIAL.
        add_source( | AS { ld_join->joined_table_alias }| ).
      ENDIF.

      gv_level = gv_level + 1.
      LOOP AT ld_join->on_clause REFERENCE INTO DATA(ld_on).
        add_new_line( ).
        indent( ).

        IF sy-tabix = 1.
          add_source( |ON | ).
        ELSE.
          IF ld_on->type = gc_condition_type-or.
            add_source( |OR | ).
          ELSE.
            add_source( |AND | ).
          ENDIF.
        ENDIF.

        " negation of the condition
        IF ld_on->not = abap_true.
          add_source( |NOT | ).
        ENDIF.

        " open brackets for the condition
        IF ld_on->open_brackets = abap_true.
          add_source( |( | ).
          gv_level = gv_level + 1.
        ENDIF.

        " use alias if given
        IF ld_join->joined_table_alias IS NOT INITIAL.
          add_source( |{ ld_join->joined_table_alias }.| ).
        ELSE.
          add_source( |{ ld_join->joined_table }.| ).
        ENDIF.

        add_source( |{ ld_on->left_field } | ).
        add_source( |{ ld_on->operator } | ).

        " table of the connection field is provided
        " it doesn't have to be, e.g. IS NULL condition
        IF ld_on->right_table IS NOT INITIAL.
          add_source( |{ ld_on->right_table }.| ).
        ENDIF.

        add_source( |{ ld_on->right_field } | ).

        " close brackets for the condition
        IF ld_on->close_brackets = abap_true.
          add_source( |) | ).
          gv_level = gv_level - 1.
        ENDIF.
      ENDLOOP.

      gv_level = gv_level - 1.
    ENDLOOP.

    gv_level = gv_level - 2.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->ADD_JOIN_CONDITION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        CLIKE
* | [--->] IV_ALIAS                       TYPE        CLIKE(optional)
* | [--->] IV_FIELD                       TYPE        CLIKE
* | [--->] IV_OPERATOR                    TYPE        CLIKE (default ='=')
* | [--->] IV_RIGHT_TABLE                 TYPE        CLIKE(optional)
* | [--->] IV_RIGHT_FIELD                 TYPE        CLIKE
* | [--->] IV_TYPE                        TYPE        GTY_V_CONDITION_TYPE (default =GC_CONDITION_TYPE-AND)
* | [--->] IV_NOT                         TYPE        BOOLE_D (default =ABAP_FALSE)
* | [--->] IV_OPEN_BRACKETS               TYPE        BOOLE_D (default =ABAP_FALSE)
* | [--->] IV_CLOSE_BRACKETS              TYPE        BOOLE_D (default =ABAP_FALSE)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_join_condition.
    READ TABLE gt_joins REFERENCE INTO DATA(ld_join)
      WITH KEY joined_table = |{ iv_table CASE = LOWER }|
               joined_table_alias = |{ iv_alias CASE = LOWER }|.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_join_not_found
          iv_table  = iv_table
          iv_alias  = iv_alias.
    ENDIF.

    APPEND VALUE #(
      left_field = |{ iv_field CASE = LOWER }|
      operator = iv_operator
      right_table = iv_right_table
      right_field = iv_right_field
      type = iv_type
      not = iv_not
      open_brackets = iv_open_brackets
      close_brackets = iv_close_brackets ) TO ld_join->on_clause.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->ADD_JOIN_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        CLIKE
* | [--->] IV_ALIAS                       TYPE        CLIKE(optional)
* | [--->] IV_TYPE                        TYPE        GTY_V_JOIN_TYPE (default =GC_JOIN_TYPE-INNER)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_join_table.
    DATA(lv_table_lower) = |{ iv_table CASE = LOWER }|.
    DATA(lv_alias_lower) = |{ iv_alias CASE = LOWER }|.

    READ TABLE gt_joins TRANSPORTING NO FIELDS
      WITH KEY joined_table = lv_table_lower
               joined_table_alias = lv_alias_lower.
    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_join_exists
          iv_table  = iv_table
          iv_alias  = iv_alias.
    ENDIF.

    APPEND VALUE #(
      joined_table = lv_table_lower
      joined_table_alias = lv_alias_lower
      type = iv_type ) TO gt_joins.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_NEW_LINE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_new_line.
    gv_source = gv_source && cl_abap_char_utilities=>newline.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_SELECT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_select.
    gv_level = gv_level + 1.

    " DDL from section
    indent( ).
    add_source( |AS SELECT | ).
    IF gs_from-distinct = abap_true.
      add_source( |DISTINCT | ).
    ENDIF.
    add_source( |FROM { gs_from-table }| ).
    IF gs_from-alias IS NOT INITIAL.
      add_source( | AS { gs_from-alias }| ).
    ENDIF.

    gv_level = gv_level - 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_SOURCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SOURCE                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_source.
    gv_source = gv_source && iv_source.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CAUT_CDS_GENERATOR=>ADD_TO_TRANSPORT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CDS_NAME                    TYPE        CLIKE
* | [--->] IV_TRANSPORT                   TYPE        TRKORR
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_to_transport.
    DATA:
      lv_cds_name TYPE ddname,
      lt_e071     TYPE TABLE OF e071,
      lt_e071k    TYPE TABLE OF e071k.

    APPEND VALUE #(
      trkorr = iv_transport
      pgmid = 'R3TR'
      object = 'DDLS'
      obj_name = iv_cds_name
      lockflag = abap_true ) TO lt_e071.

    " add to a transport request
    CALL FUNCTION 'TR_APPEND_TO_COMM_OBJS_KEYS'
      EXPORTING
        wi_trkorr = iv_transport
      TABLES
        wt_e071   = lt_e071
        wt_e071k  = lt_e071k
      EXCEPTIONS
        OTHERS    = 1.
    CHECK sy-subrc <> 0.

    lv_cds_name = iv_cds_name.
    RAISE EXCEPTION TYPE zcx_caut_cds_generator
      EXPORTING
        iv_textid    = zcx_caut_cds_generator=>gc_adding_to_transport_failed
        iv_cds       = lv_cds_name
        iv_transport = iv_transport.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->ADD_WHERE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_where.
    CHECK gt_where[] IS NOT INITIAL.

    add_new_line( ).
    add_source( |WHERE | ).

    gv_level = gv_level + 1.
    LOOP AT gt_where REFERENCE INTO DATA(ld_where).
      IF sy-tabix > 1.
        add_new_line( ).
        indent( ).

        IF ld_where->type = gc_condition_type-or.
          add_source( |OR | ).
        ELSE.
          add_source( |AND | ).
        ENDIF.
      ENDIF.

      " negation of the condition
      IF ld_where->not = abap_true.
        add_source( |NOT | ).
      ENDIF.

      " open brackets for the condition
      IF ld_where->open_brackets = abap_true.
        add_source( |( | ).
        gv_level = gv_level + 1.
      ENDIF.

      " use alias if given
      IF ld_where->left_table IS NOT INITIAL.
        add_source( |{ ld_where->left_table }.| ).
      ENDIF.

      add_source( |{ ld_where->left_field } | ).
      add_source( |{ ld_where->operator } | ).

      " table of the connection field is provided
      " it doesn't have to be, e.g. IS NULL condition
      IF ld_where->right_table IS NOT INITIAL.
        add_source( |{ ld_where->right_table }.| ).
      ENDIF.

      add_source( |{ ld_where->right_field } | ).

      " close brackets for the condition
      IF ld_where->close_brackets = abap_true.
        add_source( |) | ).
        gv_level = gv_level - 1.
      ENDIF.
    ENDLOOP.

    gv_level = gv_level - 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->ADD_WHERE_CONDITION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LEFT_TABLE                  TYPE        CLIKE(optional)
* | [--->] IV_LEFT_FIELD                  TYPE        CLIKE
* | [--->] IV_OPERATOR                    TYPE        CLIKE (default ='=')
* | [--->] IV_RIGHT_TABLE                 TYPE        CLIKE(optional)
* | [--->] IV_RIGHT_FIELD                 TYPE        CLIKE
* | [--->] IV_TYPE                        TYPE        GTY_V_CONDITION_TYPE (default =GC_CONDITION_TYPE-AND)
* | [--->] IV_NOT                         TYPE        BOOLE_D (default =ABAP_FALSE)
* | [--->] IV_OPEN_BRACKETS               TYPE        BOOLE_D (default =ABAP_FALSE)
* | [--->] IV_CLOSE_BRACKETS              TYPE        BOOLE_D (default =ABAP_FALSE)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_where_condition.
    APPEND VALUE #(
      left_table = |{ iv_left_table CASE = LOWER }|
      left_field = |{ iv_left_field CASE = LOWER }|
      operator = iv_operator
      right_table = iv_right_table
      right_field = iv_right_field
      type = iv_type
      not = iv_not
      open_brackets = iv_open_brackets
      close_brackets = iv_close_brackets ) TO gt_where.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CAUT_CDS_GENERATOR=>CHECK_CDS_EXISTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CDS_NAME                    TYPE        DDNAME
* | [<-()] RV_EXISTS                      TYPE        FLAG
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_cds_exists.
    rv_exists = abap_false.

    " check if CDS exists
    SELECT SINGLE 'X'
      FROM tadir
      WHERE pgmid = 'R3TR'
        AND object = 'DDLS'
        AND obj_name = @iv_cds_name
        AND delflag = @abap_false
      INTO @DATA(lv_cds_found).
    CHECK sy-subrc = 0.

    rv_exists = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CAUT_CDS_GENERATOR=>DELETE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        DDNAME
* | [--->] IV_TRANSPORT                   TYPE        TRKORR(optional)
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete.
    DATA:
      lv_object_name   TYPE sobj_name,
      lv_package       TYPE devclass,
      lv_source_system TYPE srcsystem.

    CHECK iv_name IS NOT INITIAL.

    SELECT SINGLE devclass
      FROM tadir
      WHERE pgmid = 'R3TR'
        AND object = 'DDLS'
        AND obj_name = @iv_name
      INTO @lv_package.
    IF sy-subrc <> 0. " not found, nothing to delete
      RETURN.
    ENDIF.

    IF iv_transport IS INITIAL AND lv_package <> gc_package_local.
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_transport_invalid.
    ENDIF.

    TRY.
        cl_dd_ddl_handler_factory=>create( )->delete( |{ iv_name }| ).

        IF lv_package <> gc_package_local.
          add_to_transport(
            iv_cds_name = iv_name
            iv_transport = iv_transport ).
        ENDIF.
      CATCH cx_dd_ddl_delete INTO DATA(lo_delete_exception).
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid   = zcx_caut_cds_generator=>gc_delete_failed
            iv_cds      = iv_name
            io_previous = lo_delete_exception.
    ENDTRY.

    lv_source_system = sy-sysid.                          "#EC SYSID_OK

    " delete TADIR-entry for ddlsource
    lv_object_name = iv_name.
    CALL FUNCTION 'TR_TADIR_INTERFACE'
      EXPORTING
        iv_delflag               = abap_true
        wi_test_modus            = abap_false
        wi_tadir_pgmid           = 'R3TR'
        wi_tadir_object          = 'DDLS'
        wi_tadir_obj_name        = lv_object_name
        wi_tadir_srcsystem       = lv_source_system
        wi_tadir_author          = sy-uname
        wi_tadir_devclass        = lv_package
      EXCEPTIONS
        tadir_entry_not_existing = 0
        OTHERS                   = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_delete_failed
          iv_cds    = iv_name.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->GENERATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PACKAGE                     TYPE        DEVCLASS
* | [--->] IV_TRANSPORT                   TYPE        TRKORR(optional)
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate.
    DATA:
      ls_cds_info TYPE ddddlsrcv.

    IF iv_transport IS INITIAL AND iv_package <> gc_package_local.
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_transport_invalid.
    ENDIF.

    CLEAR:
      gv_level,
      gv_source.

    add_header( ).
    add_select( ).
    add_joins( ).
    add_fields( ).
    add_where( ).
    add_group( ).

    ls_cds_info-ddlname = gv_cds_name.
    ls_cds_info-ddlanguage = sy-langu.
    ls_cds_info-ddtext = gv_cds_label.
    ls_cds_info-source = gv_source.

    " below code is a copy from function FKK_INV_CDS_VIEW_CREATE
    " with naming convention and other minor adjustments
    DATA(lo_dd_ddl_handler) = cl_dd_ddl_handler_factory=>create( ).

    " check if view already exists
    TRY.
        lo_dd_ddl_handler->read(
          EXPORTING name      = ls_cds_info-ddlname
          IMPORTING got_state = DATA(lv_got_state) ).
      CATCH cx_dd_ddl_read.
    ENDTRY.

    IF lv_got_state = 'A' AND gv_overwrite = abap_false.
      " view already exists in an active state
      RAISE EXCEPTION TYPE zcx_caut_cds_generator
        EXPORTING
          iv_textid = zcx_caut_cds_generator=>gc_cds_exists
          iv_cds    = gv_cds_name.
    ENDIF.

    " save DDL source and activate CDS-view
    TRY.
        lo_dd_ddl_handler->check(
          EXPORTING name       = ls_cds_info-ddlname
          CHANGING  ddlsrcv_wa = ls_cds_info ).

        DATA(lo_wb_ddl_handler) = cl_wb_ddl_handler_factory=>create( ).
        lo_wb_ddl_handler->save(
          name         = ls_cds_info-ddlname
          put_state    = 'N'
          ddddlsrcv_wa = ls_cds_info ).

        lo_wb_ddl_handler->write_tadir(
          objectname = ls_cds_info-ddlname
          devclass   = iv_package
          username   = sy-uname
          prid       = 1 ).

        lo_wb_ddl_handler->mass_activate( VALUE if_ddic_wb_ddls_secobj_manager=>ty_ddls_names( ( ddls_name = ls_cds_info-ddlname ) ) ).

        IF iv_package <> gc_package_local.
          add_to_transport(
            iv_cds_name = ls_cds_info-ddlname
            iv_transport = iv_transport ).
        ENDIF.
      CATCH cx_dd_ddl_check INTO DATA(lo_check_exception).
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid   = zcx_caut_cds_generator=>gc_save_failed
            iv_cds      = gv_cds_name
            io_previous = lo_check_exception.
      CATCH cx_dd_ddl_save INTO DATA(lo_save_exception).
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid   = zcx_caut_cds_generator=>gc_save_failed
            iv_cds      = gv_cds_name
            io_previous = lo_save_exception.
      CATCH cx_dd_ddl_activate INTO DATA(lo_activate_exception).
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid   = zcx_caut_cds_generator=>gc_activate_failed
            iv_cds      = gv_cds_name
            io_previous = lo_activate_exception.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CAUT_CDS_GENERATOR->INDENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD indent.
    DO gv_level TIMES.
      gv_source = gv_source && `  `.
    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->SET_AUTHORIZATION_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AUTHORIZATION_CHECK         TYPE        GTY_V_AUTHORIZATION_CHECK_TYPE (default =GC_AUTHORIZATION_CHECK_TYPE-CHECK)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_authorization_check.
    gv_authorization_check = iv_authorization_check.
    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->SET_CDS_LABEL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LABEL                       TYPE        TEXT40
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cds_label.
    gv_cds_label = iv_label.
    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->SET_CDS_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CDS_NAME                    TYPE        DDNAME
* | [--->] IV_VIEW_NAME                   TYPE        VIEWNAME16
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* | [!CX!] ZCX_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cds_name.
    IF gv_overwrite = abap_false.
      IF check_cds_exists( iv_cds_name ).
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid = zcx_caut_cds_generator=>gc_cds_exists
            iv_cds    = iv_cds_name.
      ENDIF.
    ENDIF.

    " check if ABAP dictionary view exists
    " because it can be a standalone view
    " (not connected to the CDS we want to create/update)
    SELECT SINGLE 'X'
      FROM tadir
      WHERE pgmid = 'R3TR'
        AND object = 'VIEW'
        AND obj_name = @iv_view_name
      INTO @DATA(lv_view_found).
    IF sy-subrc = 0.
      " it does
      " so check if it is assigned to the CDS we're trying to create
      " if it is and overwrite flag = true --> no issue
      SELECT SINGLE 'X'
        FROM ddldependency
        WHERE ddlname = @iv_cds_name
          AND objectname = @iv_view_name
          AND objecttype = 'VIEW'
        INTO @DATA(lv_same_cds).
      IF sy-subrc = 0 AND lv_same_cds = abap_true AND gv_overwrite = abap_true.
        " no issue --> do nothing
      ELSE.
        RAISE EXCEPTION TYPE zcx_caut_cds_generator
          EXPORTING
            iv_textid = zcx_caut_cds_generator=>gc_view_exists
            iv_view   = iv_view_name.
      ENDIF.
    ENDIF.

    gv_cds_name = iv_cds_name.
    gv_view_name = iv_view_name.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->SET_FROM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        CLIKE
* | [--->] IV_ALIAS                       TYPE        CLIKE(optional)
* | [--->] IV_DISTINCT                    TYPE        BOOLE_D (default =ABAP_FALSE)
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_from.
    gs_from-table = |{ iv_table CASE = LOWER }|.
    gs_from-alias = |{ iv_alias CASE = LOWER }|.
    gs_from-distinct = iv_distinct.

    ro_instance = me.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CAUT_CDS_GENERATOR->SET_OVERWRITE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OVERWRITE                   TYPE        BOOLE_D
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CAUT_CDS_GENERATOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_overwrite.
    gv_overwrite = iv_overwrite.
    ro_instance = me.
  ENDMETHOD.
ENDCLASS.

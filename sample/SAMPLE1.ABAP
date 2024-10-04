
        DATA(lo_cds_generator) = NEW zcl_caut_cds_generator( ).
        lo_cds_generator->set_overwrite( abap_true ).

        " name of the CDS and View
        lo_cds_generator->set_cds_name(
          iv_cds_name = gs_structured_list-cds_view
          iv_view_name = create_view_name( gs_structured_list-cds_view ) ).

        " description of the CDS
        lo_cds_generator->set_cds_label( |ARC003 StrVal List { gs_structured_list-logical_group+0(6) }/{ gs_structured_list-list_name }| ).

        " FROM clause of the CDS
        lo_cds_generator->set_from( iv_table = 'ZACPF_LG_DV_LV' ).

        " fields to be selected
        DATA(lv_position) = 1.
        LOOP AT gt_structured_list_fields REFERENCE INTO DATA(ld_field).
          cl_abap_typedescr=>describe_by_name(
            EXPORTING
              p_name         = ld_field->data_element
            RECEIVING
              p_descr_ref    = lo_type
            EXCEPTIONS
              type_not_found = 1
              OTHERS         = 2 ).
          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE zcx_acpf_cds_generator
              EXPORTING
                iv_textid       = zcx_acpf_cds_generator=>gc_data_element_not_found
                iv_data_element = ld_field->data_element.
          ENDIF.

          lo_data_element_type ?= lo_type.
          DATA(lv_length) = lo_data_element_type->length / cl_abap_char_utilities=>charsize.

          " retrieve value from the concatenated string saved in DB
          DATA(lv_field_logic) = |SUBSTRING(value, { lv_position }, { lv_length })|.

          " set the type of the value
          CASE lo_data_element_type->type_kind.
            WHEN cl_abap_elemdescr=>typekind_char
              OR cl_abap_elemdescr=>typekind_clike
              OR cl_abap_elemdescr=>typekind_csequence
              OR cl_abap_elemdescr=>typekind_string.

              DATA(lv_field_type) = |abap.char( { lv_length } )|.
            WHEN cl_abap_elemdescr=>typekind_date.
              lv_field_type = |abap.dats( )|.
            WHEN cl_abap_elemdescr=>typekind_int
              OR cl_abap_elemdescr=>typekind_int8.

              lv_field_type = |abap.int8( )|.
            WHEN cl_abap_elemdescr=>typekind_int1.
              lv_field_type = |abap.int1( )|.
            WHEN cl_abap_elemdescr=>typekind_int2.
              lv_field_type = |abap.int2( )|.
            WHEN cl_abap_elemdescr=>typekind_num.
              lv_field_type = |abap.numc( { lv_length } )|.
            WHEN cl_abap_elemdescr=>typekind_packed.
              lv_field_type = |abap.dec( { lv_length }, { lo_data_element_type->decimals } )|.
            WHEN cl_abap_elemdescr=>typekind_time.
              lv_field_type = |abap.tims( )|.
            WHEN OTHERS.
              " the type needs to be implemented
              ASSERT 1 = 0.
          ENDCASE.
          lv_field_logic = |CAST({ lv_field_logic } AS { lv_field_type })|.
          lv_field_logic = |CAST({ lv_field_logic } AS { ld_field->data_element })|.

          lo_cds_generator->add_field(
            iv_field = lv_field_logic
            iv_alias = ld_field->field_name
            iv_is_key = ld_field->key_field ).

          " next field starts after current + 1 character for separator
          lv_position = lv_position + lv_length + 1.
        ENDLOOP.

        " WHERE condition for the CDS
        lo_cds_generator->add_where_condition(
          iv_left_field = 'LOGICAL_GROUP'
          iv_right_field = |'{ gs_structured_list-logical_group }'| ).
        lo_cds_generator->add_where_condition(
          iv_left_field = 'LIST_NAME'
          iv_right_field = |'{ gs_structured_list-linked_value_list }'| ).

        " generate CDS
        lo_cds_generator->generate(
          iv_package = parse_cds_name( gs_structured_list-cds_view )
          iv_transport = iv_transport ).
      CATCH cx_sy_move_cast_error INTO DATA(lo_cast_exception).
        RAISE EXCEPTION TYPE zcx_acpf_cds_generator
          EXPORTING
            iv_textid       = zcx_acpf_cds_generator=>gc_data_element_not_found
            iv_data_element = ld_field->data_element
            io_previous     = lo_cast_exception.
      CATCH zcx_caut_cds_generator INTO DATA(lo_generator_exception). " CDS Generator Exceptions
        RAISE EXCEPTION TYPE zcx_acpf_cds_generator
          EXPORTING
            iv_textid   = zcx_acpf_cds_generator=>gc_cds_generation_failed
            iv_cds_name = gs_structured_list-cds_view
            io_previous = lo_generator_exception.
    ENDTRY.


 

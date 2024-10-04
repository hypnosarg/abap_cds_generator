    CONSTANTS:
      lc_domvalue_l TYPE fieldname VALUE 'domvalue_l',
      lc_domname    TYPE fieldname VALUE 'domname',
      lc_as4local   TYPE fieldname VALUE 'as4local'.

    TRY.
        DATA(lo_cds_generator) = NEW zcl_caut_cds_generator( ).
        lo_cds_generator->set_overwrite( abap_true ).

        " name of the CDS and View
        lo_cds_generator->set_cds_name(
          iv_cds_name = gs_value_group-generated_cds
          iv_view_name = create_view_name( gs_value_group-generated_cds ) ).

        " description of the CDS
        lo_cds_generator->set_cds_label( |ARC003 Value Group { gs_value_group-logical_group+0(6) }/{ gs_value_group-group_name }| ).

        " FROM clause of the CDS
        lo_cds_generator->set_from( iv_table = gs_value_group-src_tab iv_alias = 'a' iv_distinct = abap_true ).

        " JOIN table
        lo_cds_generator->add_join_table(
          iv_table = 'ZACPF_C_GR_SOV_P'
          iv_alias = 'b' ).

        lo_cds_generator->add_join_condition(
          iv_table = 'ZACPF_C_GR_SOV_P'
          iv_alias = 'b'
          iv_field = 'LOGICAL_GROUP'
          iv_right_field = |'{ gs_value_group-logical_group }'| ).


        lo_cds_generator->add_join_condition(
          iv_table = 'ZACPF_C_GR_SOV_P'
          iv_alias = 'b'
          iv_field = 'GROUP_NAME'
          iv_right_field = |'{ gs_value_group-group_name }'| ).

        lo_cds_generator->add_join_condition(
          iv_table = 'ZACPF_C_GR_SOV_P'
          iv_alias = 'b'
          iv_field = 'LOW'
          iv_operator = '<='
          iv_right_table = 'a'
          iv_right_field = lc_domvalue_l
          iv_not = abap_false
          iv_open_brackets = abap_true ).

        lo_cds_generator->add_join_condition(
          iv_table = 'ZACPF_C_GR_SOV_P'
          iv_alias = 'b'
          iv_field = 'HIGH'
          iv_operator = '>='
          iv_right_table = 'a'
          iv_right_field = lc_domvalue_l
          iv_close_brackets = abap_true ).

        " ADD field
        lo_cds_generator->add_field( iv_table = 'a' iv_field = lc_domvalue_l iv_is_key = abap_true ).

        "ADD where condition
        lo_cds_generator->add_where_condition(
          iv_left_field  = lc_domname
          iv_right_field = |'{ to_upper( gs_value_group-src_field ) }'| ).

        lo_cds_generator->add_where_condition(
          iv_left_field  = lc_as4local
          iv_right_field = |'A'| ).

        " generate CDS
        lo_cds_generator->generate(
          iv_package = parse_cds_name( gs_value_group-generated_cds )
          iv_transport = iv_transport ).


      CATCH zcx_caut_cds_generator INTO DATA(lo_generator_exception). " CDS Generator Exceptions
        RAISE EXCEPTION TYPE zcx_acpf_cds_generator
          EXPORTING
            iv_textid   = zcx_acpf_cds_generator=>gc_cds_generation_failed
            iv_cds_name = gs_value_group-generated_cds
            io_previous = lo_generator_exception.
    ENDTRY.


*&---------------------------------------------------------------------*
*& Include          ZFI05R0021_F02
*&---------------------------------------------------------------------*


CLASS gcl_falv DEFINITION INHERITING FROM zcl_falv.
  PUBLIC SECTION.

  PROTECTED SECTION.

    "redefinition of event handler
    METHODS evf_user_command REDEFINITION.
    METHODS evf_top_of_page REDEFINITION.
    METHODS evf_data_changed REDEFINITION.
    METHODS evf_data_changed_finished REDEFINITION.
  PRIVATE SECTION.

ENDCLASS.


CLASS gcl_falv IMPLEMENTATION.

  METHOD evf_user_command.

    CASE e_ucomm.
      WHEN zcl_falv_dynamic_status=>b_01.

        me->check_changed_data( ).

*        CLEAR gd_answer.
**        gd_message = 'Are you sure to save this data to ZFIDT00305?'.
*        gd_message = 'Are you sure to save this Amount Adjustment to ZFIDT00305?'.
*        PERFORM f_confirm    USING 'Are you sure to save?'
*                                   gd_message
*                                   'Yes'
*                                   'No'
*                          CHANGING gd_answer.
*
*        CHECK gd_answer EQ '1'.

*        PERFORM f_save_to_table.

      WHEN zcl_falv_dynamic_status=>b_02.

        me->check_changed_data( ).

*        PERFORM f_save_zip_to_local_pc.

      WHEN OTHERS.
        super->evf_user_command( e_ucomm ).
    ENDCASE.

  ENDMETHOD.

  METHOD evf_top_of_page.

    DATA: ld_text TYPE text255.

    e_dyndoc_id->add_text( text = 'PT Adira Dinamika Multifinance Tbk'
                           sap_emphasis = cl_dd_area=>strong ).

    "*--------------------------------------------------------------------*

    e_dyndoc_id->new_line( repeat = 0 ).

    "*--------------------------------------------------------------------*

    e_dyndoc_id->add_table(
      EXPORTING
        no_of_columns = 2
        border = '0'
      IMPORTING
        table               = DATA(lr_table)
    ).

    lr_table->add_column(
      EXPORTING
        width               = '10%'
      IMPORTING
        column              = DATA(lr_col1)
    ).
    lr_table->add_column(
      EXPORTING
        width               = '70%'
      IMPORTING
        column              = DATA(lr_col2)
    ).

    "*--------------------------------------------------------------------*

    CLEAR ld_text.
    ld_text = gc_report_title.
    lr_col1->add_text( text = 'Program Name:' sap_style = cl_dd_area=>standard ).
    CLEAR ld_text.
    ld_text = gc_report_title.
    lr_col2->add_text( text = ld_text sap_style = cl_dd_area=>standard ).

    "*--------------------------------------------------------------------*

    lr_table->new_row( ).
    CLEAR ld_text.
*    ld_text = gd_run. CONDENSE ld_text.
    WRITE gd_run TO ld_text. CONDENSE ld_text.
    CONCATENATE ld_text 'seconds' INTO ld_text SEPARATED BY space.
    lr_col1->add_text( text = 'Execution Time:' sap_style = cl_dd_area=>standard ).
    lr_col2->add_text( text = ld_text sap_style = cl_dd_area=>standard ).

    "*--------------------------------------------------------------------*

    e_dyndoc_id->merge_document( ).

  ENDMETHOD.

  METHOD evf_data_changed.

    me->soft_refresh( ).

  ENDMETHOD.

  METHOD evf_data_changed_finished.

*    PERFORM f_calculate_amount_final.

    IF e_modified EQ 'X'.
      me->soft_refresh( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.


*&---------------------------------------------------------------------*
*& Form F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GD_RB
*&      --> GIT_ZFI314[]
*&      --> GIT_DATA_SUM[]
*&      --> GIT_DATA_DETAIL[]
*&---------------------------------------------------------------------*
FORM f_display_data  USING    p_rb
                              p_git_zfi314 TYPE gtt_zfi314
                              p_git_data_sum TYPE gtt_data_sum
                              p_git_data_detail TYPE gtt_data_detail.

*--------------------------------------------------------------------*

  "FALV creation with only table passed
*  DATA(lcl_falv) = zcl_falv=>create( CHANGING ct_table = p_git_data ).

  "creation of falv with local redefinition
  DATA lcl_falv TYPE REF TO gcl_falv.

  CASE p_rb.
    WHEN 'NO TRACING'.

      lcl_falv ?= gcl_falv=>create( EXPORTING  i_subclass = cl_abap_classdescr=>describe_by_name( p_name = 'GCL_FALV' )
                                    CHANGING ct_table = p_git_zfi314 ) .

    WHEN 'TRACING LEVEL 1'.
      lcl_falv ?= gcl_falv=>create( EXPORTING  i_subclass = cl_abap_classdescr=>describe_by_name( p_name = 'GCL_FALV' )
                              CHANGING ct_table = p_git_data_sum ) .

    WHEN 'TRACING LEVEL 2'.

      lcl_falv ?= gcl_falv=>create( EXPORTING  i_subclass = cl_abap_classdescr=>describe_by_name( p_name = 'GCL_FALV' )
                                    CHANGING ct_table = p_git_data_detail ) .

  ENDCASE.


  IF sy-batch EQ ''.
    lcl_falv->check_changed_data( ).
  ENDIF.

  "Add title variable
  lcl_falv->title_v1 = gc_report_title.

*  "Set checkbox
*  lcl_falv->set_mark_field( 'SELECT' ).

  "Set zebra
  lcl_falv->layout->set_zebra( iv_value = 'X' ).

*  "Set checkbox editable
*  lcl_falv->column( 'SELECT' )->set_edit( abap_true ).

  "Set column optimization
*  lcl_falv->column( 'SELECT' )->set_col_opt( iv_value = 'X' ).
  lcl_falv->layout->set_col_opt( iv_value = 'X' ).
  lcl_falv->layout->set_cwidth_opt( iv_value = 'X' ).
  lcl_falv->layout->set_totals_bef( 'X' ). "Sum on Top

  "Set Gui status to fully dynamic (no standard buttons of ALV Grid)
*  lcl_falv->gui_status->fully_dynamic = abap_true.

  PERFORM f_modify_field USING p_rb
                               lcl_falv.

  "Add button
  PERFORM f_add_button USING '' "p_indicator
                             lcl_falv.

  "Change grid to edit mode
  lcl_falv->set_editable( iv_modify = abap_true ).

  "Set size top of page
  lcl_falv->top_of_page_height = 75.

  "Display full screen grid
  lcl_falv->show_top_of_page( )->display( ).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_ADD_BUTTON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> FALV
*&---------------------------------------------------------------------*
FORM f_add_button USING p_indicator
                        p_me TYPE REF TO gcl_falv.

*  CASE p_indicator.
*    WHEN 'X'.
*
*      p_me->gui_status->add_button(
*        EXPORTING
*          iv_button              = zcl_falv_dynamic_status=>b_01
*          iv_text                = 'Save to Table'
*          iv_icon                = icon_system_save
*          iv_qinfo               = 'Save to Table ZFIDT00305'
*        EXCEPTIONS
*          button_already_filled  = 1
*          button_does_not_exists = 2
*          icon_and_text_empty    = 3
*          OTHERS                 = 4
*      ).
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*
*      p_me->gui_status->add_button(
*        EXPORTING
*          iv_button              = zcl_falv_dynamic_status=>b_02
*          iv_text                = 'Save as ZIP'
*          iv_icon                = icon_store
*          iv_qinfo               = 'Save as ZIP to Local PC'
*        EXCEPTIONS
*          button_already_filled  = 1
*          button_does_not_exists = 2
*          icon_and_text_empty    = 3
*          OTHERS                 = 4
*      ).
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*
*    WHEN ''.
*
*      CASE gd_rb.
*        WHEN 'NO TRACING'.
*
*          p_me->gui_status->add_button(
*            EXPORTING
*              iv_button              = zcl_falv_dynamic_status=>b_01
*              iv_text                = 'Save to Table'
*              iv_icon                = icon_system_save
*              iv_qinfo               = 'Save to Table ZFIDT00305'
*            EXCEPTIONS
*              button_already_filled  = 1
*              button_does_not_exists = 2
*              icon_and_text_empty    = 3
*              OTHERS                 = 4
*          ).
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*
*          p_me->gui_status->add_button(
*            EXPORTING
*              iv_button              = zcl_falv_dynamic_status=>b_02
*              iv_text                = 'Save as ZIP'
*              iv_icon                = icon_store
*              iv_qinfo               = 'Save as ZIP to Local PC'
*            EXCEPTIONS
*              button_already_filled  = 1
*              button_does_not_exists = 2
*              icon_and_text_empty    = 3
*              OTHERS                 = 4
*          ).
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*
*        WHEN 'TRACING LEVEL 1'.
*          "Do nothing
*
*        WHEN 'TRACING LEVEL 2'.
*          "Do nothing
*
*      ENDCASE.
*
*  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_MODIFY_FIELD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> FALV
*&---------------------------------------------------------------------*
FORM f_modify_field USING p_rb
                          p_me TYPE REF TO gcl_falv.

  CASE p_rb.
    WHEN 'NO TRACING'.

      p_me->column( 'MANDT' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'BUKRS' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'GJAHR' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'MONAT' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'ZPEMBETULAN' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'ZNO_BUKPOT_INTERNAL' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'ZNO_BUKPOT' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'ZNPWP' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'STCD1' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'NPWPNM' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'LIFNR' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'WITHT' )->set_key( '' )->set_fix_column( '' ).
      p_me->column( 'WITHCD' )->set_key( '' )->set_fix_column( '' ).

      p_me->column( 'TXBHW' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'QSSHH' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'WMWST' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'QBSHH' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'TXBHW_R' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'QSSHH_R' )->set_cfieldname( 'WAERS_DUMMY' ).
      p_me->column( 'WMWST_R' )->set_cfieldname( 'WAERS_DUMMY' ).

*      p_me->column( 'ZTRF_SKD_SK' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'ZTRF_PPH21' )->set_cfieldname( 'WAERS' ).

      p_me->column( 'TXBHW' )->set_do_sum( 'X' ).
      p_me->column( 'QSSHH' )->set_do_sum( 'X' ).
      p_me->column( 'WMWST' )->set_do_sum( 'X' ).
      p_me->column( 'QBSHH' )->set_do_sum( 'X' ).
      p_me->column( 'TXBHW_R' )->set_do_sum( 'X' ).
      p_me->column( 'QSSHH_R' )->set_do_sum( 'X' ).
      p_me->column( 'WMWST_R' )->set_do_sum( 'X' ).

*      p_me->column( 'ZTRF_SKD_SK' )->set_do_sum( 'X' ).
*      p_me->column( 'ZTRF_PPH21' )->set_do_sum( 'X' ).

      p_me->column( 'MANDT' )->set_no_out( 'X' ).
      p_me->column( 'WAERS_DUMMY' )->set_no_out( 'X' ).

    WHEN 'TRACING LEVEL 1'.

*      p_me->column( 'TXBHW' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'QSSHH' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'WMWST' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'QBSHH' )->set_cfieldname( 'WAERS' ).

      p_me->column( 'TXBHW' )->set_do_sum( 'X' ).
      p_me->column( 'QSSHH' )->set_do_sum( 'X' ).
      p_me->column( 'WMWST' )->set_do_sum( 'X' ).
      p_me->column( 'QBSHH' )->set_do_sum( 'X' ).

    WHEN 'TRACING LEVEL 2'.

*      p_me->column( 'WRBTR' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'DMBTR' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'TXBHW' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'WMWST' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'QSSHH' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'QBSHH' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'WT_ACCBS' )->set_cfieldname( 'WAERS' ).
*      p_me->column( 'WT_ACCWT' )->set_cfieldname( 'WAERS' ).

      p_me->column( 'WRBTR' )->set_do_sum( 'X' ).
      p_me->column( 'DMBTR' )->set_do_sum( 'X' ).
      p_me->column( 'TXBHW' )->set_do_sum( 'X' ).
      p_me->column( 'WMWST' )->set_do_sum( 'X' ).
      p_me->column( 'QSSHH' )->set_do_sum( 'X' ).
      p_me->column( 'QBSHH' )->set_do_sum( 'X' ).
      p_me->column( 'WT_ACCBS' )->set_do_sum( 'X' ).
      p_me->column( 'WT_ACCWT' )->set_do_sum( 'X' ).

  ENDCASE.

ENDFORM.

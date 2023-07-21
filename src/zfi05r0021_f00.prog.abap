*&---------------------------------------------------------------------*
*& Include          ZFI02R0032_F00
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_INITIALIZATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_initialization .

  PERFORM set_text .

ENDFORM.


*&---------------------------------------------------------------------*
*& Form SET_TEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_text .

  text900 = 'Selection Area'.
  %_s_bukrs_%_app_%-text = 'Company Code'.
  %_s_gjahr_%_app_%-text = 'Fiscal Year'.
  %_s_monat_%_app_%-text = 'Period'.

  text600 = 'Selection Area 2 (Will you save to Table or not?)'.
  text601 = 'Switch On / Off'.
  text602 = '(X = On | <BLANK> = Off)'.

  text700 = 'Tracing'.
  text701 = 'No Tracing'.
  text702 = 'Tracing Level 1'.
  text703 = 'Tracing Level 2'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_modify_screen .

  IF c_sw_tab EQ 'X'.

    LOOP AT SCREEN.

      CASE screen-name.
        WHEN 'S_BUKRS-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
        WHEN 'S_GJAHR-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
        WHEN 'S_MONAT-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
      ENDCASE.

      rb1 = 'X'.
      rb2 = ''.

      CASE screen-group1.
        WHEN 'P2'.
          screen-input = '0'.
          MODIFY SCREEN.
      ENDCASE.

    ENDLOOP.

  ELSE.

    LOOP AT SCREEN.

      CASE screen-name.
        WHEN 'S_BUKRS-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
        WHEN 'S_GJAHR-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
        WHEN 'S_MONAT-LOW'.
          screen-required = '2'.
          MODIFY SCREEN.
      ENDCASE.

    ENDLOOP.

  ENDIF.

*  IF c_sw_fm EQ ''.
*
*    LOOP AT SCREEN.
*
*      CASE screen-name.
*        WHEN 'S_ZLEVEL-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RBUKRS-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RECID-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_BALDAT-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*      CASE screen-group1.
*        WHEN 'P1'.
*          screen-input = '0'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*    ENDLOOP.
*
*  ELSE.
*
*    LOOP AT SCREEN.
*
*      CASE screen-name.
*        WHEN 'S_ZLEVEL-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RBUKRS-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RECID-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_BALDAT-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*      CASE screen-group1.
*        WHEN 'P2'.
*          screen-input = '0'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*    ENDLOOP.
*
*    rb1 = 'X'.
*    rb2 = ''.
*    rb3 = ''.
*
*  ENDIF.
*
*  IF c_sw_log EQ 'X'.
*
*    LOOP AT SCREEN.
*
*      CASE screen-name.
*        WHEN 'S_ZLEVEL-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RBUKRS-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_RECID-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*        WHEN 'S_BALDAT-LOW'.
*          screen-required = '2'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*      CASE screen-group1.
*        WHEN 'P2'.
*          screen-input = '0'.
*          MODIFY SCREEN.
*      ENDCASE.
*
*    ENDLOOP.
*
*    rb1 = 'X'.
*    rb2 = ''.
*    rb3 = ''.
*
*  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_MANDATORY_VALIDATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_mandatory_validation .

  IF sy-ucomm = 'ONLI'.

    IF s_bukrs-low IS INITIAL.
      SET CURSOR FIELD 'S_BUKRS-LOW'.
      MESSAGE 'Fill out all required entry fields' TYPE 'E'.
    ENDIF.

    IF s_gjahr-low IS INITIAL.
      SET CURSOR FIELD 'S_GJAHR-LOW'.
      MESSAGE 'Fill out all required entry fields' TYPE 'E'.
    ENDIF.

    IF s_monat-low IS INITIAL.
      SET CURSOR FIELD 'S_MONAT-LOW'.
      MESSAGE 'Fill out all required entry fields' TYPE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.


FORM f_progress_bar_single USING p_value
                                 p_type
                                 p_display_like.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 0
      text       = p_value.

  MESSAGE p_value TYPE p_type DISPLAY LIKE p_display_like.

ENDFORM.


FORM f_progress_bar USING p_value
                          p_tabix
                          p_nlines.

  DATA: w_text(250),
        w_percentage      TYPE p,
        w_percent_char(3).

  w_percentage    = ( p_tabix / p_nlines ) * 100.
  w_percent_char  = w_percentage.

  SHIFT w_percent_char LEFT DELETING LEADING ' '.
  CONCATENATE w_percent_char '% complete' INTO w_text.
  CONCATENATE p_value w_text INTO w_text SEPARATED BY space.

*This check needs to be in, otherwise when looping around big tables
*SAP will re-display indicator too many times causing report to run
*very slow. (No need to re-display same percentage anyways)

  IF w_percentage GT gd_percent
      OR p_tabix  EQ 1.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = w_percentage
        text       = w_text.
    MESSAGE w_text TYPE 'S'.

    gd_percent = w_percentage.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_START_TIMER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_start_timer .
  "Record start time
  GET RUN TIME FIELD gd_start.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_STOP_TIMER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_stop_timer .
  "Record end time
  GET RUN TIME FIELD gd_stop.
  "Run time (milliseconds instead of seconds)
  gd_run = ( gd_stop - gd_start ) / 1000000.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_DATE_WITH_SEPARATOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GWA_EXCEL_RAW_COL4  text
*      -->P_GWA_EXCEL_FIX_VALID_FROM  text
*----------------------------------------------------------------------*
FORM f_conv_date_with_separator  USING    p_input
                                          p_separator
                                 CHANGING p_output.
  CLEAR p_output.
  p_output = p_input+6(2) && p_separator &&
             p_input+4(2) && p_separator &&
             p_input(4).
ENDFORM.                    " F_CONVERT_DATE_WITH_SEPARATOR


*&---------------------------------------------------------------------*
*& Form F_CONFIRM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      <--P_LD_ANSWER  text
*&---------------------------------------------------------------------*
FORM f_confirm USING p_word1
                     p_word2
                     p_button1
                     p_button2
            CHANGING p_answer.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = p_word1
      text_question         = p_word2
      text_button_1         = p_button1
      text_button_2         = p_button2
      display_cancel_button = 'X'
    IMPORTING
      answer                = p_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    "Do nothing
  ENDIF.

ENDFORM.

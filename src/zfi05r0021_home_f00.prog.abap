*&---------------------------------------------------------------------*
*& Include          ZFI02R0033_HOME_F00
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

*  text901 = 'Selection Option'.
  text904 = 'Selection Area'.
*  text903 = 'Selection Area (Run via FM purpose only! Don''t use if you use Selection Screen)'.
*  text904 = 'Tracing'.

*  %_s_rbukrs_%_app_%-text = 'Company Code'.
*  %_s_poper_%_app_%-text = 'Period'.
*  %_s_gjahr_%_app_%-text = 'Fiscal Year'.

*  %_s_recid_%_app_%-text = 'Recon. ID'.
*  %_s_zlevel_%_app_%-text = 'Level'.
*  %_s_baldat_%_app_%-text = 'Balance Date'.
*  %_s_unlv1_%_app_%-text = 'Unit ID Level 1'.
*  %_s_unlv2_%_app_%-text = 'Unit ID Level 2'.
*  %_s_unlv3_%_app_%-text = 'Unit ID Level 3'.

*  %_c_switch_%_app_%-text = 'Turn on'.
*  %_p_datum_%_app_%-text = 'Date'.
*  %_p_uzeit_%_app_%-text = 'Time'.

*  text701 = 'Switch On / Off'.
*  text702 = '(X = On | <BLANK> = Off)'.
  text801 = 'FI: Parameter Kode MAP (ZFIDT00309)'.
  text802 = 'FI: Parameter Seleksi WHT Type (ZFIDT00310)'.
  text803 = 'FI: Parameter Kode Negara (ZFIDT00311)'.
  text804 = 'FI: Parameter NITKU (ZFIDT00312)'.
  text805 = 'FI: Parameter Konfigurasi Pembulatan (ZFIDT00313)'.
  text806 = 'FI: Transaksi Pajak (ZFIDT00314)'.

  text811 = 'Program New Table Bukti Potong Pajak'.

ENDFORM.

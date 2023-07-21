*&---------------------------------------------------------------------*
*& Include          ZFI05R0021_TOP
*&---------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Type-Pools                                                         *
*--------------------------------------------------------------------*
*TYPE-POOLS: icon, truxs, col, fiehc.
*--------------------------------------------------------------------*
* End - Type-Pools                                                   *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Nodes                                                              *
*--------------------------------------------------------------------*
*NODES: peras.
*--------------------------------------------------------------------*
* End - Nodes                                                        *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Infotype
*--------------------------------------------------------------------*
*INFOTYPES: 0000, 0001, 2006 MODE N.
*INFOTYPES: 0000, 0001, 2006.
*--------------------------------------------------------------------*
* End Infotype
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Tables                                                             *
*--------------------------------------------------------------------*
TABLES: zfivt00100.
*--------------------------------------------------------------------*
* End - Tables                                                       *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Global Constants                                                   *
*--------------------------------------------------------------------*
CONSTANTS: gc_report_title TYPE lvc_title VALUE 'Program New Table Bukti Potong Pajak',
           gc_rbukrs       TYPE bukrs VALUE 'ADMF',
           gc_znpwp_ttd    TYPE tvarvc-name VALUE 'ZFI05R0021_ZNPWP_TTD',
           gc_znik_ttd     TYPE tvarvc-name VALUE 'ZFI05R0021_ZNIK_TTD',
           gc_zpbk         TYPE tvarvc-name VALUE 'ZFI05R0021_ZPBK',
           gc_zjenis_dok   TYPE tvarvc-name VALUE 'ZFI05R0021_ZJENIS_DOK',
           gc_zqq          TYPE tvarvc-name VALUE 'ZFI05R0021_ZQQ',
           gc_zper_ppn     TYPE tvarvc-name VALUE 'ZFI05R0021_ZPER_PPN'.
*--------------------------------------------------------------------*
* End - Global Constants                                             *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Global Types                                                       *
*--------------------------------------------------------------------*
*Custom

TYPES: BEGIN OF gty_data_sum,
         bukrs               TYPE zficd_zfi046_b-bukrs,
         gjahr               TYPE zficd_zfi046_b-gjahr,
         monat               TYPE zficd_zfi046_b-monat,
         zpembetulan         TYPE zficd_zfi046_b-zpembetulan,
         zno_bukpot_internal TYPE zficd_zfi046_b-zno_bukpot_internal,
         zno_bukpot          TYPE zficd_zfi046_b-zno_bukpot,
         znpwp               TYPE zficd_zfi046_b-znpwp,
         stcd1               TYPE zficd_zfi046_b-stcd1,
         npwpnm              TYPE zficd_zfi046_b-npwpnm,
         lifnr               TYPE zficd_zfi046_b-lifnr,
         witht               TYPE zficd_zfi046_b-witht,
         withcd              TYPE zficd_zfi046_b-withcd,
         waers               TYPE zficd_zfi046_b-waers,

         txbhw               TYPE zficd_zfi046_b-txbhw,
         qsshh               TYPE zficd_zfi046_b-qsshh,
         wmwst               TYPE zficd_zfi046_b-wmwst,
         qbshh               TYPE zficd_zfi046_b-qbshh,
       END OF gty_data_sum.

TYPES: BEGIN OF gty_zfidt00314.
    INCLUDE TYPE zfidt00314.
TYPES: waers_dummy TYPE waers.
TYPES: END OF gty_zfidt00314.

TYPES: gtt_zfi314      TYPE TABLE OF gty_zfidt00314,
       gtt_data_detail TYPE TABLE OF zficd_zfi046_b,
       gtt_t059fb      TYPE TABLE OF t059fb,
       gtt_data_sum    TYPE TABLE OF gty_data_sum.

*--------------------------------------------------------------------*
*Standard
TYPES: BEGIN OF gty_named_dref,
         name TYPE string,
         dref TYPE REF TO data,
       END OF gty_named_dref.
*--------------------------------------------------------------------*
* End - Global Types                                                 *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Global Variable                                                    *
*--------------------------------------------------------------------*
*Custom

*---Variable Program - Table & Work Area
DATA: git_zfi314      TYPE TABLE OF gty_zfidt00314,
      gwa_zfi314      TYPE gty_zfidt00314,
      git_data_detail TYPE TABLE OF zficd_zfi046_b,
      gwa_data_detail TYPE zficd_zfi046_b,
      git_t059fb      TYPE TABLE OF t059fb,
      git_data_sum    TYPE TABLE OF gty_data_sum,
      gwa_data_sum    TYPE gty_data_sum,

      git_tvarvc      TYPE TABLE OF tvarvc,
*      git_zfidt00309  TYPE TABLE OF zfidt00309,
      git_zfidt00310  TYPE TABLE OF zfidt00310,
*      git_zfidt00311  TYPE TABLE OF zfidt00311,
*      git_zfidt00312  TYPE TABLE OF zfidt00312,
      git_zfidt00313  TYPE TABLE OF zfidt00313.

*--------------------------------------------------------------------*
*Standard

*---Variable Program - Single Value
DATA: gd_rb         TYPE char20,
      gd_line_excel TYPE i,
      gd_tabix      TYPE i,
      gd_subrc      TYPE sy-subrc,
      gd_message    TYPE text255,
      gd_times      TYPE i,
      gd_answer(1). "Variable for Popup Answer.

*---For AMDP Class
DATA: gd_where          TYPE sxmsbody,
      gd_where1         TYPE sxmsbody,
      gd_where2         TYPE sxmsbody,
      gd_where3         TYPE sxmsbody,
      gd_where4         TYPE sxmsbody,
      gd_where5         TYPE sxmsbody,
      git_named_seltabs TYPE TABLE OF gty_named_dref,
      gwa_named_seltabs TYPE gty_named_dref.

*---For Refresh ALV
DATA: gwa_stable     TYPE lvc_s_stbl,
      gd_refreshmode TYPE salv_de_constant.

*---For Debugger
DATA: git_terminal          TYPE TABLE OF tvarvc WITH HEADER LINE,
      gd_opcode_usr_attr(1) TYPE x VALUE 5,
      gd_terminal           TYPE usr41-terminal,
      gd_zdebug             TYPE text255,
      gd_flag               TYPE text255.

*---For Status Progress
DATA: gd_percent TYPE i,
      gd_lines   TYPE i.

*---Variable Get Execution Time
DATA: gd_start TYPE p DECIMALS 3,
      gd_stop  TYPE p DECIMALS 3,
      gd_run   TYPE p DECIMALS 3.
*--------------------------------------------------------------------*
* End - Global Variable                                              *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Global Range                                                       *
*--------------------------------------------------------------------*
*Custom

*--------------------------------------------------------------------*

*Standard

RANGES: gra_name FOR tvarvc-name.
*--------------------------------------------------------------------*
* End - Global Variable                                              *
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* Define                                                             *
*--------------------------------------------------------------------*
DEFINE f_fill_range.
  &1-sign = &2.
  &1-option = &3.
  &1-low = &4.
  &1-high = &5.
  APPEND &1.
END-OF-DEFINITION.

"Example: f_fill_range: lra_lptyp 'I' 'EQ' lwa_lptyp-lptyp ''.
*--------------------------------------------------------------------*
* End - Define                                                       *
*--------------------------------------------------------------------*


*----------------------------------------------------------------------*
* Selection Screen                                                     *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK a01 WITH FRAME TITLE text900.
SELECT-OPTIONS: s_bukrs FOR zfivt00100-bukrs MEMORY ID zfi05r0021_bukrs NO-EXTENSION NO INTERVALS DEFAULT gc_rbukrs,
                s_gjahr FOR zfivt00100-gjahr MEMORY ID zfi05r0021_gjahr NO-EXTENSION NO INTERVALS,
                s_monat FOR zfivt00100-monat MEMORY ID zfi05r0021_monat NO-EXTENSION NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a01.

*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a05 WITH FRAME TITLE text600.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (31) text601.
PARAMETERS: c_sw_tab AS CHECKBOX USER-COMMAND u2. "MODIF ID p1. "Checkbox Switch Save
SELECTION-SCREEN COMMENT 36(30) text602.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK a05.

*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a04 WITH FRAME TITLE text700.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS rb1 RADIOBUTTON GROUP rb1 DEFAULT 'X' MODIF ID p2.
SELECTION-SCREEN COMMENT 4(30) text701.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS rb2 RADIOBUTTON GROUP rb1.
SELECTION-SCREEN COMMENT 4(30) text702  MODIF ID p2.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS rb3 RADIOBUTTON GROUP rb1  MODIF ID p2.
SELECTION-SCREEN COMMENT 4(30) text703.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK a04.
*----------------------------------------------------------------------*
* End - Selection Screen                                               *
*----------------------------------------------------------------------*

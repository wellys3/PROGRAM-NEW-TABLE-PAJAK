*&---------------------------------------------------------------------*
*& Report ZFI05R0021
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Description : Program New Table Bukti Potong Pajak
*&
*& Module      : Financial Accounting
*& Functional  : - Yeremia Khristian Suherman (yeremia.suherman@equine.co.id)
*& FSD Loc.    : - SO2_MIME_REPOSITORY --> SAP --> PUBLIC --> ZFSD
*& FSD         : - 0022. 01. CR27A - FSD - NEW TABLE
*& Developer   : Welly Sugiarto (welly.sugiarto@equine.co.id)
*& Date        : April 3rd, 2022
*& Copyright   : © 2023 PT Equine Global
*&               © 2023 PT Adira Dinamika Multi Finance
*&
*& Transport Request History (Any changes of TR will be updated here future):
*& *  A4DK908668 SAPABAP EG-AB-FI CR27A - Program New Table Pajak WSU YKS #1
*& *  Changelog: * Initial Release
*& *  A4DK909043 SAPABAP EG-AB-FI CR27A - Program New Table Pajak WSU YKS #2
*& *  Changelog: #1 Fix logic TXBHW_R (A3), QSSHH_R (A4), WMWST_R (A5)
*& *             #2 Add logic ZTRF_PPH21 (B2)
*& *             #3 Fix logic ZTIN (N)
*& *             #4 Add logic ZTRF_SKD_SK
*&---------------------------------------------------------------------*


REPORT zfi05r0021.


*----------------------------------------------------------------------*
* Includes                                                             *
*----------------------------------------------------------------------*
INCLUDE: zfi05r0021_top, "Types, Data, Constant Declaration & Selection-Screen.
         zfi05r0021_f00, "Other Function for whole this program
         zfi05r0021_f01, "Get Data
         zfi05r0021_f02. "Display Data
*----------------------------------------------------------------------*
* End - Includes                                                       *
*----------------------------------------------------------------------*


*----------------------------------------------------------------------*
* Initialization                                                       *
*----------------------------------------------------------------------*
INITIALIZATION.
  PERFORM f_initialization.
*----------------------------------------------------------------------*
* End - Initialization                                                 *
*----------------------------------------------------------------------*


*----------------------------------------------------------------------*
* Start-of-Selection                                                   *
*----------------------------------------------------------------------*
START-OF-SELECTION.

*  CLEAR gd_subrc.
*  PERFORM f_pre_execute CHANGING gd_subrc.
  PERFORM f_pre_execute.

*  CHECK gd_subrc EQ 0.

*--------------------------------------------------------------------*
*Check authorization sy-uname to table ZFIDT00316

  CLEAR gd_subrc.
  PERFORM f_check_auth CHANGING gd_subrc.

  CHECK gd_subrc EQ 0.

*--------------------------------------------------------------------*
*Check apakah ada data di ZFIDT00314 yang sesuai dengan selection screen?

  IF c_sw_tab EQ 'X'.

    IF sy-batch EQ 'X'.
      "Do nothing
    ELSE.

      SELECT SINGLE * FROM zfidt00314 INTO @DATA(lwa_zfidt00314)
        WHERE bukrs EQ @s_bukrs-low AND
              gjahr EQ @s_gjahr-low AND
              monat EQ @s_monat-low.
      IF sy-subrc EQ 0.

        CLEAR gd_answer.
        gd_message = 'There is existing data with your selection data, are you sure to overwrite?'.
        PERFORM f_confirm    USING 'Are you sure?'
                                   gd_message
                                   'Yes'
                                   'No'
                          CHANGING gd_answer.

        CHECK gd_answer EQ '1'.

      ENDIF.

    ENDIF.

  ENDIF.

*--------------------------------------------------------------------*

  PERFORM f_execute.

END-OF-SELECTION.
*----------------------------------------------------------------------*
* End - Start-of-Selection                                             *
*----------------------------------------------------------------------*


*----------------------------------------------------------------------*
* At-Selection-Screen                                                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
*  PERFORM f_download_template.
  PERFORM f_mandatory_validation.
*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_screen.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  PERFORM f_get_file_dir CHANGING p_file.
*----------------------------------------------------------------------*
* End - At-Selection-Screen                                            *
*----------------------------------------------------------------------*

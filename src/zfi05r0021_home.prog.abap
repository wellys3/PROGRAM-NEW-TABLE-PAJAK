*&---------------------------------------------------------------------*
*& Report ZFI02R0033_HOME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Description : Program New Table Bukti Potong Pajak - Home
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
*&---------------------------------------------------------------------*


REPORT zfi05r0021_home.


*----------------------------------------------------------------------*
* Includes                                                             *
*----------------------------------------------------------------------*
INCLUDE zfi05r0021_home_top.  "Types, Data, Constant Declaration & Selection-Screen.
INCLUDE zfi05r0021_home_f00.  "Other Function for whole this program
INCLUDE zfi05r0021_home_f01.  "Get Data
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

  CLEAR gd_subrc.
  PERFORM f_check_auth CHANGING gd_subrc.

  CHECK gd_subrc EQ 0.

  PERFORM f_execute.

END-OF-SELECTION.
*----------------------------------------------------------------------*
* End - Start-of-Selection                                             *

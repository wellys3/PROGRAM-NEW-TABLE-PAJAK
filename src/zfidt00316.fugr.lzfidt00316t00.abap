*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00316......................................*
DATA:  BEGIN OF STATUS_ZFIDT00316                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00316                    .
CONTROLS: TCTRL_ZFIDT00316
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00316                    .
TABLES: ZFIDT00316                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

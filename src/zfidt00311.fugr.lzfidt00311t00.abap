*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00311......................................*
DATA:  BEGIN OF STATUS_ZFIDT00311                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00311                    .
CONTROLS: TCTRL_ZFIDT00311
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00311                    .
TABLES: ZFIDT00311                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

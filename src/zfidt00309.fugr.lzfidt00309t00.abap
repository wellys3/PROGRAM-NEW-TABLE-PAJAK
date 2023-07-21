*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00309......................................*
DATA:  BEGIN OF STATUS_ZFIDT00309                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00309                    .
CONTROLS: TCTRL_ZFIDT00309
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00309                    .
TABLES: ZFIDT00309                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

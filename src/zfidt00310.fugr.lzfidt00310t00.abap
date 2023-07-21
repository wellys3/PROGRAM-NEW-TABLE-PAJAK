*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00310......................................*
DATA:  BEGIN OF STATUS_ZFIDT00310                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00310                    .
CONTROLS: TCTRL_ZFIDT00310
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00310                    .
TABLES: ZFIDT00310                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

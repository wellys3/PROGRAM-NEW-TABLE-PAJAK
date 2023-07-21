*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00312......................................*
DATA:  BEGIN OF STATUS_ZFIDT00312                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00312                    .
CONTROLS: TCTRL_ZFIDT00312
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00312                    .
TABLES: ZFIDT00312                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

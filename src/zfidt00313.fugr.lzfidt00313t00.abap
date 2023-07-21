*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFIDT00313......................................*
DATA:  BEGIN OF STATUS_ZFIDT00313                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFIDT00313                    .
CONTROLS: TCTRL_ZFIDT00313
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFIDT00313                    .
TABLES: ZFIDT00313                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

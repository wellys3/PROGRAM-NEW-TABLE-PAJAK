*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZFIDT00311
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZFIDT00311         .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

FUNCTION ZROUND_AMOUNT_THOUSAND.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SIGN) TYPE  CHAR1
*"     REFERENCE(IM_INPUT) TYPE  TOTAL_AMOUNT
*"  EXPORTING
*"     REFERENCE(EX_OUTPUT) TYPE  TOTAL_AMOUNT
*"----------------------------------------------------------------------

*Fungsi function ini untuk round up or down
*Misal Sign - : 123.123,00   --> 123.000,00
*               1.150.023,00 --> 1.150.000,00

*Misal Sign + : 123.123,00   --> 124.000,00
*               1.150.023,00 --> 1.151.000,00

*--------------------------------------------------------------------*

  DATA: ld_mod    TYPE int4,
        ld_output TYPE total_amount.

*--------------------------------------------------------------------*

  IF im_sign EQ '+' OR im_sign EQ '-'.
    "Do nothing
  ELSE.
    EXIT.
  ENDIF.

*--------------------------------------------------------------------*

  CLEAR ld_output.
  ld_output = im_input.

*--------------------------------------------------------------------*

  DO.

    ld_mod = ld_output MOD 1000.

    IF ld_mod = 0.
      EXIT.
    ENDIF.

    CASE im_sign.
      WHEN '+'.
        ld_output = ld_output + 1.
      WHEN '-'.
        ld_output = ld_output - 1.
    ENDCASE.

  ENDDO.

*--------------------------------------------------------------------*

  ex_output = ld_output.

ENDFUNCTION.

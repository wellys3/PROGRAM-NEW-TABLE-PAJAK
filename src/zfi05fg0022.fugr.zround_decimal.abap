FUNCTION zround_decimal.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_METHOD_ROUNDING) TYPE  ZFIDE01213
*"     REFERENCE(IM_DECIMAL) TYPE  I
*"     REFERENCE(IM_INPUT) TYPE  TOTAL_AMOUNT
*"  EXPORTING
*"     REFERENCE(EX_OUTPUT) TYPE  TOTAL_AMOUNT
*"----------------------------------------------------------------------

* Fungsi function ini untuk round
* Misal R:
* 125.001,51 --> 125.002,00
* 125.001,50 --> 125.002,00
* 125.001,49 --> 125.001,00

* Misal RD:
* 125.001,49 --> 125.001,00
* 125.001,51 --> 125.001,00

* Misal RU:
* 125.001,49 --> 125.002,00
* 125.001,51 --> 125.002,00

*--------------------------------------------------------------------*

  CONSTANTS: lc_var TYPE total_amount VALUE '0.50'.

  DATA: ld_sign       TYPE char1,
        ld_amount_str TYPE char30,
        ld_amount     TYPE total_amount,
        ld_amount_b   TYPE total_amount.

*--------------------------------------------------------------------*

  CLEAR: ld_amount, ld_amount_b.

*--------------------------------------------------------------------*

  CASE im_method_rounding.
    WHEN 'R'.
      ld_amount_str = im_input.
      CONDENSE ld_amount_str.

      DATA(ld_len) = strlen( ld_amount_str ) - 3.
      ld_amount = ld_amount_str(ld_len).

      CLEAR ld_amount_b.
      ld_amount_b = im_input - ld_amount.

      IF ld_amount_b >= lc_var.
        ld_sign = '+'.
      ELSE.
        ld_sign = '-'.
      ENDIF.

    WHEN 'RU'.
      ld_sign = '+'.
    WHEN 'RD'.
      ld_sign = '-'.
  ENDCASE.

*--------------------------------------------------------------------*

  CALL FUNCTION 'ROUND'
    EXPORTING
      decimals      = 0
      input         = im_input
      sign          = ld_sign
    IMPORTING
      output        = ex_output
    EXCEPTIONS
      input_invalid = 1
      overflow      = 2
      type_invalid  = 3
      OTHERS        = 4.

ENDFUNCTION.

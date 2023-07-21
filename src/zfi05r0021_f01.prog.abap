*&---------------------------------------------------------------------*
*& Include          ZFI05R0021_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_CHECK_AUTH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GD_SUBRC
*&---------------------------------------------------------------------*
FORM f_check_auth  CHANGING p_subrc.

  SELECT SINGLE * FROM zfidt00316
    INTO @DATA(lwa_zfidt00316)
      WHERE bname EQ @sy-uname.
  IF sy-subrc EQ 0.
    p_subrc = 0.
  ELSE.
    p_subrc = 1.

    CLEAR gd_message.
    gd_message = '''' && sy-uname && ''''.
    CONCATENATE 'Your User ID' gd_message 'are not authorized to access this program!'
      INTO gd_message
        SEPARATED BY space.
    MESSAGE gd_message TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_PRE_EXECUTE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GD_SUBRC
*&---------------------------------------------------------------------*
*FORM f_pre_execute  CHANGING p_gd_subrc.
FORM f_pre_execute.

*--------------------------------------------------------------------*
*Get Radio Button

  IF rb1 EQ 'X'.
    gd_rb = 'NO TRACING'.
  ELSEIF rb2 EQ 'X'.
    gd_rb = 'TRACING LEVEL 1'.
  ELSEIF rb3 EQ 'X'.
    gd_rb = 'TRACING LEVEL 2'.
*  ELSEIF rb4 EQ 'X'.
*    gd_rb = 'TRACING LEVEL 3'.
  ENDIF.

*--------------------------------------------------------------------*

  f_fill_range: gra_name 'I' 'EQ' gc_znpwp_ttd ''.
  f_fill_range: gra_name 'I' 'EQ' gc_znik_ttd ''.
  f_fill_range: gra_name 'I' 'EQ' gc_zpbk ''.
  f_fill_range: gra_name 'I' 'EQ' gc_zjenis_dok ''.
  f_fill_range: gra_name 'I' 'EQ' gc_zqq ''.
  f_fill_range: gra_name 'I' 'EQ' gc_zper_ppn ''.

  SELECT * FROM tvarvc INTO TABLE git_tvarvc
    WHERE name IN gra_name.

*--------------------------------------------------------------------*

*  SELECT * FROM zfidt00309 INTO TABLE git_zfidt00309.
  SELECT * FROM zfidt00310 INTO TABLE git_zfidt00310.
*  SELECT * FROM zfidt00311 INTO TABLE git_zfidt00311.
*  SELECT * FROM zfidt00312 INTO TABLE git_zfidt00312.
  SELECT * FROM zfidt00313 INTO TABLE git_zfidt00313.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_EXECUTE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_execute .

  PERFORM f_start_timer.

  PERFORM f_get_data CHANGING git_data_detail[]
                              git_t059fb[].

  IF git_data_detail[] IS NOT INITIAL.

    CASE gd_rb.
      WHEN 'NO TRACING'.

        PERFORM f_process_summary USING git_data_detail[]
                               CHANGING git_data_sum[].

        PERFORM f_prepare_data USING git_data_detail[]
                                     git_data_sum[]
                            CHANGING git_zfi314[].

        PERFORM f_save_data_to_zfidt00314 USING git_zfi314[].

        PERFORM f_stop_timer.
        "001: This program sucessfully executed! (Exec. Time & seconds)
        MESSAGE s071(zfimsg) WITH gd_run.

        PERFORM f_display_data USING gd_rb

                                     git_zfi314[]
                                     git_data_sum[]
                                     git_data_detail[].

      WHEN 'TRACING LEVEL 1'.

        PERFORM f_process_summary USING git_data_detail[]
                               CHANGING git_data_sum[].

        PERFORM f_stop_timer.
        "001: This program sucessfully executed! (Exec. Time & seconds)
        MESSAGE s071(zfimsg) WITH gd_run.

        PERFORM f_display_data USING gd_rb

                                     git_zfi314[]
                                     git_data_sum[]
                                     git_data_detail[].

      WHEN 'TRACING LEVEL 2'.

        PERFORM f_stop_timer.
        "001: This program sucessfully executed! (Exec. Time & seconds)
        MESSAGE s071(zfimsg) WITH gd_run.

        PERFORM f_display_data USING gd_rb

                                     git_zfi314[]
                                     git_data_sum[]
                                     git_data_detail[].

    ENDCASE.

  ELSE.
    MESSAGE 'No data found' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GIT_Z046[]
*&---------------------------------------------------------------------*
FORM f_get_data  CHANGING p_git_data_detail TYPE gtt_data_detail
                          p_git_t059fb TYPE gtt_t059fb.

*--------------------------------------------------------------------*

  PERFORM f_progress_bar_single USING 'Getting data...' 'S' 'S'.

  "*--------------------------------------------------------------------*

  CLEAR p_git_data_detail.

  "*--------------------------------------------------------------------*

  SELECT * FROM zficd_zfi046_b INTO TABLE @p_git_data_detail
    WHERE bukrs IN @s_bukrs AND
          gjahr IN @s_gjahr AND
          monat IN @s_monat AND
          zno_bukpot_internal NE @space.

  SELECT * FROM t059fb INTO TABLE p_git_t059fb
    WHERE land1 EQ 'ID'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_PREPARE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GIT_Z046[]
*&---------------------------------------------------------------------*
FORM f_prepare_data  USING    p_git_data_detail TYPE gtt_data_detail
                              p_git_data_sum TYPE gtt_data_sum
                     CHANGING p_git_zfi314 TYPE gtt_zfi314.

  FIELD-SYMBOLS: <lfs>, <lfs_b>.

  RANGES : lra_stcd1 FOR zfidt00314-stcd1.

  DATA : ld_field        TYPE zfidt00313-zfield,
         ld_fs(100),
         ld_fs_b(100),
         ld_amount       TYPE total_amount,
         ld_ztrf_skd_sk  TYPE zfidt00314-ztrf_skd_sk,
         ld_ztrf_pph21   TYPE zfidt00314-ztrf_pph21,
         ld_max_wt_valid TYPE t059fb-wt_valid.

*--------------------------------------------------------------------*

  CLEAR p_git_zfi314[].

  "*--------------------------------------------------------------------*

  CLEAR lra_stcd1[].
  f_fill_range: lra_stcd1 'I' 'EQ' '' ''.
  f_fill_range: lra_stcd1 'I' 'EQ' '000000000000000' ''.

  "*--------------------------------------------------------------------*

  CLEAR: gd_percent, gd_lines.
  DESCRIBE TABLE p_git_data_detail LINES gd_lines.

  LOOP AT p_git_data_detail INTO DATA(lwa_data_detail).

    PERFORM f_progress_bar USING 'Preparing data...'
                                  sy-tabix
                                  gd_lines.

    "*--------------------------------------------------------------------*

    CLEAR gwa_zfi314.

    "*--------------------------------------------------------------------*

    gwa_zfi314-waers_dummy = 'IDR'.

    "*--------------------------------------------------------------------*
    "A, B, C, D, E, F, G, H, I, J, K

    MOVE-CORRESPONDING lwa_data_detail TO gwa_zfi314.

*    gwa_zfi314-bukrs = lwa_data_detail-bukrs.
*    gwa_zfi314-gjahr = lwa_data_detail-gjahr.
*    gwa_zfi314-monat = lwa_data_detail-monat.
*    gwa_zfi314-zpembetulan = lwa_data_detail-zpembetulan.
*    gwa_zfi314-zno_bukpot_internal = lwa_data_detail-zno_bukpot_internal.
*    gwa_zfi314-zno_bukpot = lwa_data_detail-zno_bukpot.
*    gwa_zfi314-znpwp = lwa_data_detail-znpwp.
*    gwa_zfi314-stcd1 = lwa_data_detail-stcd1.
*    gwa_zfi314-npwpnm = lwa_data_detail-npwpnm.
*    gwa_zfi314-lifnr = lwa_data_detail-lifnr.
*    gwa_zfi314-witht = lwa_data_detail-witht.
*    gwa_zfi314-withcd = lwa_data_detail-withcd.

    "*--------------------------------------------------------------------*
    "Q

*    gwa_zfi314-npwpadr = lwa_data_detail-npwpadr.

    "*--------------------------------------------------------------------*
    "S, T, U

*    gwa_zfi314-zkode_kjs = lwa_data_detail-zkode_kjs.
*    gwa_zfi314-zkode_map = lwa_data_detail-zkode_map.
*    gwa_zfi314-zspt_group = lwa_data_detail-zspt_group.

    "*--------------------------------------------------------------------*
    "V, W

*    gwa_zfi314-land1 = lwa_data_detail-land1.
*    gwa_zfi314-zland1 = lwa_data_detail-zland1.

    "*--------------------------------------------------------------------*
    "X

*    gwa_zfi314-zkode_penghasilan = lwa_data_detail-zkode_penghasilan.

    "*--------------------------------------------------------------------*
    "Y

*    gwa_zfi314-zkode_object = lwa_data_detail-zkode_object.

    "*--------------------------------------------------------------------*
    "A7, A8
*    gwa_zfi314-zbudat_bukpot = lwa_data_detail-zbudat_bukpot.
*    gwa_zfi314-zbudat_bukpot_internal = lwa_data_detail-zbudat_bukpot_internal.

    "*--------------------------------------------------------------------*
    "A9
*    gwa_zfi314-zfl_fasilitas = lwa_data_detail-zfl_fasilitas.

    "*--------------------------------------------------------------------*
    "B9
*    gwa_zfi314-znitku = lwa_data_detail-znitku.

    "*--------------------------------------------------------------------*
    "L

*    IF gwa_zfi314-stcd1 NE '000000000000000'.
    IF gwa_zfi314-stcd1 NOT IN lra_stcd1.
      gwa_zfi314-zfl_npniti = 'NPWP'.
    ELSE.
      READ TABLE git_zfidt00310 INTO DATA(lwa_zfidt00310)
        WITH KEY witht = lwa_data_detail-witht
                 withcd = lwa_data_detail-withcd.
      IF sy-subrc EQ 0.
        gwa_zfi314-zfl_npniti = lwa_zfidt00310-zfl_npniti.
      ENDIF.

    ENDIF.

    "*--------------------------------------------------------------------*
    "M

*    SELECT SINGLE * FROM i_businesspartnersupplier INTO @DATA(lwa_ibsupplier) WHERE supplier EQ @lwa_data_detail-lifnr.
    SELECT SINGLE * FROM zmmdt00002 INTO @DATA(lwa_zmm002) WHERE bpartner EQ @lwa_data_detail-lifnr.

    IF gwa_zfi314-zfl_npniti = 'NIK'.

      IF sy-subrc EQ 0.

*        IF sy-subrc EQ 0.

        SELECT SINGLE * FROM zmmdt00024 INTO @DATA(lwa_zmm024)
          WHERE request_number EQ @lwa_zmm002-request_number AND
                identificationcategory EQ 'ZKTP'.
        IF sy-subrc EQ 0.
          gwa_zfi314-znik = lwa_zmm024-identificationnumber.
        ENDIF.

*        ENDIF.

      ENDIF.
    ELSE.
      gwa_zfi314-znik = ''.
    ENDIF.

    "*--------------------------------------------------------------------*
    "N

*    SELECT SINGLE * FROM zmmdt00042 INTO @DATA(lwa_zmm042) WHERE bpartner EQ @lwa_ibsupplier-businesspartner.

*{(ADD)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #3    A4DK909043
*    SELECT SINGLE * FROM zmmdt00042 INTO @DATA(lwa_zmm042) WHERE bpartner EQ @lwa_zmm002-request_number.
*}(END OF ADD)/SAPABAP/EG-WSU/EG-YKS/20072023

*{(ADD)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #3    A4DK909043
    SELECT SINGLE * FROM zmmdt00042 INTO @DATA(lwa_zmm042) WHERE bpartner EQ @lwa_zmm002-bpartner.
*}(END OF ADD)/SAPABAP/EG-WSU/EG-YKS/20072023

    IF sy-subrc EQ 0.
      IF gwa_zfi314-zfl_npniti = 'TIN'.
        gwa_zfi314-ztin = lwa_zmm042-codnum.
      ELSE.
        gwa_zfi314-ztin = ''.
      ENDIF.

    ENDIF.

    "*--------------------------------------------------------------------*
    "O

    IF gwa_zfi314-zfl_npniti = 'NIK' OR gwa_zfi314-zfl_npniti = 'TIN'.
      gwa_zfi314-npwpnm_b = lwa_data_detail-npwpnm.
    ELSE.
      gwa_zfi314-npwpnm_b = ''.
    ENDIF.

    "*--------------------------------------------------------------------*
    "P

    READ TABLE git_tvarvc INTO DATA(lwa_tvarvc) WITH KEY name = gc_zqq.
    IF sy-subrc EQ 0.
      gwa_zfi314-zqq = lwa_tvarvc-low.
    ENDIF.

    "*--------------------------------------------------------------------*
    "R

    IF gwa_zfi314-zfl_npniti = 'NIK' OR gwa_zfi314-zfl_npniti = 'TIN'.
      gwa_zfi314-npwpadr_b = lwa_data_detail-npwpadr.
    ELSE.
      gwa_zfi314-npwpadr_b = ''.
    ENDIF.

    "*--------------------------------------------------------------------*
    "Z, A0, A1, A2

*    READ TABLE p_git_data_sum INTO DATA(lwa_data_sum)
*      WITH KEY bukrs = lwa_data_detail-bukrs
*               gjahr = lwa_data_detail-gjahr
*               monat = lwa_data_detail-monat
*               zno_bukpot_internal = lwa_data_detail-zno_bukpot_internal
*               zpembetulan = lwa_data_detail-zpembetulan
*               waers = lwa_data_detail-waers.
*    IF sy-subrc EQ 0.
*      gwa_zfi314-txbhw = lwa_data_sum-txbhw.
*      gwa_zfi314-qsshh = lwa_data_sum-qsshh.
*      gwa_zfi314-wmwst = lwa_data_sum-wmwst.
*      gwa_zfi314-qbshh = lwa_data_sum-qbshh.
*    ENDIF.

    READ TABLE p_git_data_sum INTO DATA(lwa_data_sum)
      WITH KEY bukrs = lwa_data_detail-bukrs
               gjahr = lwa_data_detail-gjahr
               monat = lwa_data_detail-monat
               zpembetulan = lwa_data_detail-zpembetulan
               zno_bukpot_internal = lwa_data_detail-zno_bukpot_internal
               zno_bukpot = lwa_data_detail-zno_bukpot
               znpwp = lwa_data_detail-znpwp
               stcd1 = lwa_data_detail-stcd1
               npwpnm = lwa_data_detail-npwpnm
               lifnr = lwa_data_detail-lifnr
               witht = lwa_data_detail-witht
               withcd = lwa_data_detail-withcd
               waers = lwa_data_detail-waers.
    IF sy-subrc EQ 0.
      gwa_zfi314-txbhw = lwa_data_sum-txbhw.
      gwa_zfi314-qsshh = lwa_data_sum-qsshh.
      gwa_zfi314-wmwst = lwa_data_sum-wmwst.
      gwa_zfi314-qbshh = lwa_data_sum-qbshh.
    ENDIF.

    "*--------------------------------------------------------------------*
    "A3, A4, A5

    LOOP AT git_zfidt00313 INTO DATA(lwa_zfidt00313).

      CASE lwa_zfidt00313-zfield.
        WHEN 'ZTRF_SKD_SK'.

          "*--------------------------------------------------------------------*
          "B1 = ( [A2] QBSHH / [Z] TXBHW ) * 100

          IF gwa_zfi314-zfl_fasilitas EQ 'SKD'.

            CLEAR ld_ztrf_skd_sk.
            ld_ztrf_skd_sk = ( gwa_zfi314-qbshh / gwa_zfi314-txbhw ) * 100.

*{(ADD)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #4    A4DK909043
            gwa_zfi314-ztrf_skd_sk = ld_ztrf_skd_sk.
*}(END OF ADD)/SAPABAP/EG-WSU/EG-YKS/20072023

          ENDIF.

        WHEN OTHERS.

*          ld_fs = 'LWA_DATA_DETAIL' && '-' && lwa_zfidt00313-zfield.
          ld_fs = 'GWA_ZFI314' && '-' && lwa_zfidt00313-zfield.
          CONDENSE ld_fs NO-GAPS.
          ASSIGN (ld_fs) TO <lfs>.

          IF <lfs> IS ASSIGNED.

            ld_fs_b = lwa_zfidt00313-zfield.
            REPLACE ALL OCCURRENCES OF '_R' IN ld_fs_b WITH ''.

*{(REM)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #1    A4DK909043
*            ld_fs_b = 'LWA_DATA_DETAIL' && '-' && ld_fs_b.
*}(END OF REM)/SAPABAP/EG-WSU/EG-YKS/20072023

*{(ADD)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #1    A4DK909043
            ld_fs_b = 'GWA_ZFI314' && '-' && ld_fs_b.
*}(END OF ADD)/SAPABAP/EG-WSU/EG-YKS/20072023

            CONDENSE ld_fs_b NO-GAPS.
            ASSIGN (ld_fs_b) TO <lfs_b>.

            IF <lfs_b> IS ASSIGNED.

              IF lwa_zfidt00313-flag_rounding EQ 'X'.

*                CLEAR ld_amount.
*                PERFORM f_round_amount_thousand    USING '-'
*                                                         <lfs_b>
*                                                CHANGING ld_amount.

                CLEAR ld_amount.
                PERFORM f_round_decimal USING lwa_zfidt00313-method_rounding
                                              <lfs_b>
                                     CHANGING ld_amount.

              ELSE.

                CLEAR ld_amount.
                ld_amount = <lfs_b>.

              ENDIF.

              <lfs> = ld_amount.

            ENDIF.

          ENDIF.

      ENDCASE.

    ENDLOOP.

    "*--------------------------------------------------------------------*
    "A6
    IF gwa_zfi314-zfl_npniti EQ 'TIN'.

      READ TABLE git_tvarvc INTO lwa_tvarvc WITH KEY name = gc_zper_ppn.
      IF sy-subrc EQ 0.
        gwa_zfi314-zper_ppn = lwa_tvarvc-low.
      ENDIF.

    ENDIF.

    "*--------------------------------------------------------------------*
    "B0
    CASE gwa_zfi314-zfl_fasilitas.
      WHEN 'SKB'.
        gwa_zfi314-znum_skb_skt_skd_sk = lwa_zmm042-skbnum.
      WHEN 'SKT'.
        gwa_zfi314-znum_skb_skt_skd_sk = lwa_zmm042-skppnum.
      WHEN 'SKD'.
        gwa_zfi314-znum_skb_skt_skd_sk = lwa_zmm042-codnum(21).
      WHEN 'N'.
        gwa_zfi314-znum_skb_skt_skd_sk = ''.
    ENDCASE.

    "*--------------------------------------------------------------------*
    "B2 = ( [A2]/[A0] ) * 100
    IF gwa_zfi314-zkode_map EQ '411121'.

      CLEAR ld_ztrf_pph21.
      ld_ztrf_pph21 =  ( gwa_zfi314-qbshh / gwa_zfi314-qsshh ) * 100.

      "*--------------------------------------------------------------------*

      CLEAR ld_max_wt_valid.
      SELECT SINGLE MAX( wt_valid )
        FROM @git_t059fb AS a
          WHERE waers = @gwa_zfi314-waers AND
                witht = @gwa_zfi314-witht AND
                wt_withcd = @gwa_zfi314-withcd
                  ##itab_key_in_select
                  ##itab_db_select
                    INTO @ld_max_wt_valid.

      IF sy-subrc EQ 0 AND ld_max_wt_valid IS NOT INITIAL.

        SELECT *
          FROM @git_t059fb AS a
            WHERE waers = @gwa_zfi314-waers AND
                  witht = @gwa_zfi314-witht AND
                  wt_withcd = @gwa_zfi314-withcd AND
                  wt_valid = @ld_max_wt_valid
                    ##itab_key_in_select
                    ##itab_db_select
                      INTO TABLE @DATA(lit_t059fb_c).

*{(ADD)/Equine/SAPABAP/EG-WSU/EG-YKS/20072023/Cause: #2    A4DK909043
        IF lit_t059fb_c[] IS NOT INITIAL.

          DESCRIBE TABLE lit_t059fb_c LINES DATA(ld_lines).

          IF ld_lines EQ 1.

            READ TABLE lit_t059fb_c INTO DATA(lwa_t059fb_c) INDEX 1.
            IF sy-subrc EQ 0.
              gwa_zfi314-ztrf_pph21 = lwa_t059fb_c-qsatz.
            ENDIF.

          ELSE.

            DELETE lit_t059fb_c WHERE qsatz > ld_ztrf_pph21.
            SORT lit_t059fb_c DESCENDING BY qsatz.

            READ TABLE lit_t059fb_c INTO lwa_t059fb_c INDEX 1.
            IF sy-subrc EQ 0.
              gwa_zfi314-ztrf_pph21 = lwa_t059fb_c-qsatz.
            ENDIF.

          ENDIF.

        ENDIF.
        CLEAR lit_t059fb_c[].
*}(END OF ADD)/SAPABAP/EG-WSU/EG-YKS/20072023

      ENDIF.

      "*--------------------------------------------------------------------*

    ENDIF.

    "*--------------------------------------------------------------------*
    "B3, B4, B5, B6

    READ TABLE git_tvarvc INTO lwa_tvarvc WITH KEY name = gc_znpwp_ttd.
    IF sy-subrc EQ 0.
      gwa_zfi314-znpwp_ttd = lwa_tvarvc-low.
    ENDIF.

    READ TABLE git_tvarvc INTO lwa_tvarvc WITH KEY name = gc_znik_ttd.
    IF sy-subrc EQ 0.
      gwa_zfi314-znik_ttd = lwa_tvarvc-low.
    ENDIF.

    READ TABLE git_tvarvc INTO lwa_tvarvc WITH KEY name = gc_zpbk.
    IF sy-subrc EQ 0.
      gwa_zfi314-zpbk = lwa_tvarvc-low.
    ENDIF.

    READ TABLE git_tvarvc INTO lwa_tvarvc WITH KEY name = gc_zjenis_dok.
    IF sy-subrc EQ 0.
      gwa_zfi314-zjenis_dok = lwa_tvarvc-low.
    ENDIF.

    "*--------------------------------------------------------------------*
    "B7

    IF gwa_zfi314-zfl_fasilitas EQ 'SKT'.
      gwa_zfi314-zfl_npwp_setor = 'Y'.
    ELSE.
      gwa_zfi314-zfl_npwp_setor = 'N'.
    ENDIF.

    "*--------------------------------------------------------------------*
    "B8

    IF gwa_zfi314-zkode_map EQ '411121' AND lwa_data_detail-land1 EQ 'ID'.
      gwa_zfi314-zfl_jenis_wp_ln_21 = 'N'.
    ELSE.
      gwa_zfi314-zfl_jenis_wp_ln_21 = 'Y'.
    ENDIF.

    "*--------------------------------------------------------------------*

    APPEND gwa_zfi314 TO p_git_zfi314.

  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_PROCESS_SUMMARY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GIT_Z046[]
*&      <-- GIT_DATA_SUM[]
*&---------------------------------------------------------------------*
FORM f_process_summary  USING    p_git_data TYPE gtt_data_detail
                        CHANGING p_git_data_sum TYPE gtt_data_sum.

*--------------------------------------------------------------------*

  PERFORM f_progress_bar_single USING 'Process Summary...' 'S' 'S'.

  "*--------------------------------------------------------------------*

  CLEAR p_git_data_sum[].

  "*--------------------------------------------------------------------*

*         bukrs               TYPE zficd_zfi046_b-bukrs,
*         gjahr               TYPE zficd_zfi046_b-gjahr,
*         monat               TYPE zficd_zfi046_b-monat,
*         zno_bukpot_internal TYPE zficd_zfi046_b-zno_bukpot_internal,
*         zpembetulan         TYPE zficd_zfi046_b-zpembetulan,
*         waers               TYPE zficd_zfi046_b-waers,
*
*         txbhw               TYPE zficd_zfi046_b-txbhw,
*         qsshh               TYPE zficd_zfi046_b-qsshh,
*         wmwst               TYPE zficd_zfi046_b-wmwst,
*         qbshh               TYPE zficd_zfi046_b-qbshh,

  SELECT bukrs,
         gjahr,
         monat,
         zpembetulan,
         zno_bukpot_internal,
         zno_bukpot,
         znpwp,
         stcd1,
         npwpnm,
         lifnr,
         witht,
         withcd,
         waers,

         SUM( txbhw ) AS txbhw,
         SUM( qsshh ) AS qsshh,
         SUM( wmwst ) AS wmwst,
         SUM( qbshh ) AS qbshh
    FROM @p_git_data AS a
*    GROUP BY bukrs, gjahr, monat, zno_bukpot_internal, zpembetulan, waers
    GROUP BY bukrs, gjahr, monat, zpembetulan, zno_bukpot_internal, zno_bukpot, znpwp, stcd1, npwpnm, lifnr, witht, withcd, waers
      INTO CORRESPONDING FIELDS OF TABLE @p_git_data_sum
    ##db_feature_mode[itabs_in_from_clause]
    ##itab_key_in_select
    ##itab_db_select.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_SAVE_DATA_TO_ZFIDT00314
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GIT_ZFI314[]
*&---------------------------------------------------------------------*
FORM f_save_data_to_zfidt00314  USING    p_git_zfi314 TYPE gtt_zfi314.

*--------------------------------------------------------------------*

  DATA: lit_zfidt00314 TYPE TABLE OF zfidt00314.

*--------------------------------------------------------------------*

  CHECK c_sw_tab EQ 'X'.

*--------------------------------------------------------------------*

  CLEAR gd_answer.
  IF sy-batch EQ 'X'.
    gd_answer = '1'.
  ELSE.
    gd_message = 'Are you sure to save data to ZFIDT00314?'.
    PERFORM f_confirm    USING 'Are you sure?'
                               gd_message
                               'Yes'
                               'No'
                      CHANGING gd_answer.
  ENDIF.

  CHECK gd_answer EQ '1'.

*--------------------------------------------------------------------*

  CLEAR lit_zfidt00314[].
  lit_zfidt00314[] = p_git_zfi314[].
  MODIFY zfidt00314 FROM TABLE p_git_zfi314[].
  IF sy-subrc EQ 0.
    COMMIT WORK AND WAIT.
    MESSAGE 'Successfully saved to ZFIDT00314' TYPE 'S'.
  ELSE.
    MESSAGE 'Failed save to ZFIDT00305' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_ROUND_AMOUNT_THOUSAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> <LFS_B>
*&      <-- LD_AMOUNT
*&---------------------------------------------------------------------*
FORM f_round_amount_thousand  USING    p_sign
                                       p_input
                              CHANGING p_output.

  CALL FUNCTION 'ZROUND_AMOUNT_THOUSAND'
    EXPORTING
      im_sign   = p_sign
      im_input  = p_input
    IMPORTING
      ex_output = p_output.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form F_ROUND_DECIMAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LWA_ZFIDT00313_METHOD_ROUNDING
*&      --> <LFS_B>
*&      <-- LD_AMOUNT
*&---------------------------------------------------------------------*
FORM f_round_decimal  USING    p_method_rounding
                               p_input
                      CHANGING p_output.

  CALL FUNCTION 'ZROUND_DECIMAL'
    EXPORTING
      im_method_rounding = p_method_rounding
      im_decimal         = 0
      im_input           = p_input
    IMPORTING
      ex_output          = p_output.

ENDFORM.

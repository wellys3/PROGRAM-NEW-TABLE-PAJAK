@AbapCatalog.sqlViewName: 'ZFIVT00100'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.usageType.serviceQuality: #B
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.sizeCategory: #XXL
@EndUserText.label: 'Table ZFIDT00046 (Program ZFI05R0021)'
define view ZFICD_ZFI046_B
  as select from    zfidt00046 as a
  //  as select from ZFICD_ZFI046_TF_CDS as a
  //    left outer join t030       as b on  a.mandt = b.mandt
  //                                    and a.witht = b.bwmod
  //                                    and b.ktopl = 'ADMF'
  //                                    and b.ktosl = 'WIT'
  //    left outer join bseg       as c on  a.mandt = c.mandt
  //                                    and a.bukrs = c.bukrs
  //                                    and a.belnr = c.belnr
  //                                    and a.gjahr = c.gjahr
  //                                    and b.konts = c.hkont
  //                                    and c.augbl != ''
    left outer join lfa1       as b on  a.mandt = b.mandt
                                    and a.lifnr = b.lifnr
    left outer join zfidt00311 as c on  b.mandt = c.mandt
                                    and b.land1 = c.land1
    left outer join zfidt00309 as d on  a.mandt     = d.mandt
                                    and a.zkode_map = d.zkode_map
    left outer join zfidt00003 as e on  a.mandt  = e.mandt
                                    and a.witht  = e.witht
                                    and a.withcd = e.zwht_code
    left outer join zfidt00310 as f on  a.mandt  = f.mandt
                                    and a.witht  = f.witht
                                    and a.withcd = f.withcd
    left outer join zfidt00312 as g on  a.mandt = g.mandt
                                    and a.zctr  = g.zctr
{
  key a.mandt,
  key a.bukrs,
  key a.belnr,
  key a.gjahr,
  key a.buzei,
  key a.zcount,
  key a.zpembetulan,

      a.budat,
      a.monat,
      a.blart,
      a.ebeln,
      a.ebelp,
      a.bedat,
      a.lfbnr,
      a.xblnr,

      a.lifnr,
      b.land1,
      c.zland1,

      a.kunnr,
      a.stcd1,
      a.witht,
      a.withcd,
      e.zkode_object,
      f.zfl_fasilitas,
//      f.zfl_npniti,

      a.bupla,
      a.mwskz,
      a.zvtc,
      a.bklas,
      a.ztdf,
      a.waers,
      a.wrbtr,
      a.dmbtr,
      a.kursf,
      a.txbhw,
      a.wmwst,
      a.qsshh,
      a.znpwp,
      a.npwpnm,
      a.npwpadr,
      a.prctr,
      a.zctr,
      g.znitku,
      a.zkode_kjs,

      a.zkode_map,
      d.zkode_penghasilan,

      a.zspt_group,
      a.qbshh,
      a.wt_accbs,
      a.wt_accwt,
      a.xref2,
      a.xref1_hd,
      a.zno_bukpot,
      a.zbudat_bukpot,
      a.zno_bukpot_internal,
      a.zbudat_bukpot_internal,
      a.zbelnr_appajak,
      a.zbudat_appajak,
      a.zno_ssp_ext,
      a.zbelnr_ssp,
      a.zbudat_ssp,
      a.zno_bpe,
      a.zbudat_bpe,
      a.zbelnr_spt,
      a.zbudat_spt,
      a.bktxt,
      a.zstatus,
      a.zno_pembetulan,
      a.zbudat_cancel,
      a.zaddress,
      a.erdat,
      a.erzet,
      a.ernam,
      a.aedat,
      a.aezet,
      a.aenam
}

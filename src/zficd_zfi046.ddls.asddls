@AbapCatalog.sqlViewName: 'ZFIVT00085'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.usageType.serviceQuality: #B
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.sizeCategory: #XXL
@EndUserText.label: 'Get Data ZFIDT00046'
define view ZFICD_ZFI046
  as select from    zfidt00046 as a
    left outer join t030       as b on  a.mandt = b.mandt
                                    and a.witht = b.bwmod
                                    and b.ktopl = 'ADMF'
                                    and b.ktosl = 'WIT'
    left outer join bseg       as c on  a.mandt = c.mandt
                                    and a.bukrs = c.bukrs
                                    and a.belnr = c.belnr
                                    and a.gjahr = c.gjahr
                                    and b.konts = c.hkont
                                    and c.augbl != ''
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
      a.kunnr,
      a.stcd1,
      a.witht,
      b.konts,
      c.augbl,
      a.withcd,
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
      a.zkode_kjs,
      a.zkode_map,
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
group by
  a.mandt,
  a.bukrs,
  a.belnr,
  a.gjahr,
  a.buzei,
  a.zcount,
  a.zpembetulan,
  a.budat,
  a.monat,
  a.blart,
  a.ebeln,
  a.ebelp,
  a.bedat,
  a.lfbnr,
  a.xblnr,
  a.lifnr,
  a.kunnr,
  a.stcd1,
  a.witht,
  b.konts,
  c.augbl,
  a.withcd,
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
  a.zkode_kjs,
  a.zkode_map,
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
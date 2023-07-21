@AbapCatalog.sqlViewName: 'ZFIVT00101'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.usageType.serviceQuality: #B
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.sizeCategory: #XXL
@EndUserText.label: 'Copied From ZFICD_ZFI046_TF, Set as CDS'
define view ZFICD_ZFI046_TF_CDS
  as select from ZFICD_ZFI046_TF as a
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
      a.withcd,
      a.bupla,
      a.mwskz,
      a.zvtc,
      a.bklas,
      a.ztdf,
      a.waers,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.wrbtr,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.dmbtr,
      a.kursf,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.txbhw,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.wmwst,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.qsshh,

      a.znpwp,
      a.npwpnm,
      a.npwpadr,
      a.prctr,
      a.zctr,
      a.zkode_kjs,
      a.zkode_map,
      a.zspt_group,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.qbshh,

      @Semantics: { amount : {currencyCode: 'waers'} }
      a.wt_accbs,

      @Semantics: { amount : {currencyCode: 'waers'} }
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

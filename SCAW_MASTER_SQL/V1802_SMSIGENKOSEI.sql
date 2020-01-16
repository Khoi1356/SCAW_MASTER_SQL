﻿
 CREATE VIEW [dbo].[V1802_SMSIGENKOSEI] as SELECT        FCOMPANYCD, FKOJUNHINCD, FKYOTENCD, FSEZOPTCD, FKOJUN, FSIGENCD, FVALIDYMD, FSTDHOUR, FSAGYOKB, FINVALYMD, FENTDT, FENTPRG, FENTUSR, FUPDTEDT, FUPDTEPRG, FUPDTEUSR
FROM            OPENQUERY(as400_mpUTEST, 
                         'select
   ''RRC'' as FCOMPANYCD,
    T1.ITHNBN as FKOJUNHINCD,
   ''RRC'' as FKYOTENCD,
   ''*'' as FSEZOPTCD,
   ''confirm'' as FKOJUN,
   ''confirm'' as FSIGENCD,
   ''1900/01/01'' as FVALIDYMD,
   ''confirm'' as FSTDHOUR,
   ''RRC'' as FSAGYOKB,
   ''2999/12/31'' as FINVALYMD,
   ''20190131'' as FENTDT,
   ''ISM'' as FENTPRG,
   '''' AS FENTUSR,
   '''' AS FUPDTEDT,
   '''' AS FUPDTEPRG,
   '''' as FUPDTEUSR
  from MPFLIB.MPIT00  as T1')

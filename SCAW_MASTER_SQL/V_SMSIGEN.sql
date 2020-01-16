


CREATE view [dbo].[V_SMSIGEN] as 
SELECT
	  'RRC' as [FCOMPANYCD] 
      ,CASE WHEN SUBSTRING(KOCD,1,1) !='9' THEN '0'+ KOCD ELSE KOCD END   as [FSIGENCD] -- Mã tài nguyên
      ,cast('1900/01/01'as nvarchar(20)) as [FVALIDYMD] -- Giới hạn ngày hợp lê
      ,'en' as [FLNGKB] -- ngôn ngữ
      ,cast('2999/12/31'as nvarchar(20)) as[FINVALYMD] -- giới hạn ngyaf hợp lệ
      ,trim(KONAM) as[FSIGENMEI] -- tên tài nguyên
      ,''+KOBCD as[FSIGENCLASSCD] -- Mã lớp tài nguyên
	  ,0 as FCHARGE
	  ,0 AS FKANSETUCHARGE
	  ,'*' AS FGENKAYOSOCD
	  ,'' aS FKEIHICHARGE -- NULL
	  , '' AS FKEIHIGENKAYOSOCD -- NULL
	  ,CASE WHEN SUBSTRING(KOCD,1,1) !='9' THEN '0'+ KOCD ELSE '' END AS FTANTOCD
	  ,'*' AS FSIGENGRPCD
	  ,CASE WHEN SUBSTRING(KOCD,1,1) !='9' THEN '0'+ KOCD ELSE KOCD END  AS FSUMSIGENCD
	  ,'' AS FCRPKB -- NULL
	  ,1 AS FYOTEIFLG
	  ,1 AS FJSKFLG
      ,1 as [FJORITU] --Hệ số nhân =1 khi không được chỉ định
 FROM openquery(as400_mputest,'Select * from ZRFLIB.ZRKO00 where KOBCD != ''9999'' and KOBCD != ''0261'' and KOBCD != ''9998'' and KONAM !=''V40-1''') 
 union 
 SELECT
	  'RRC' as [FCOMPANYCD] 
      ,replace(case when isnull(DensanCode,'') = '' then  upper(trim(MachineID)) collate database_default else DensanCode collate database_default end,' ','')  as [FSIGENCD]  -- Mã tài nguyên
      ,cast('1900/01/01'as nvarchar(20)) as [FVALIDYMD] -- Giới hạn ngày hợp lê
      ,'en' as [FLNGKB] -- ngôn ngữ
      ,cast('2999/12/31'as nvarchar(20)) as[FINVALYMD] -- giới hạn ngyaf hợp lệ
      ,upper(trim(MachineID)) collate database_default as[FSIGENMEI] -- tên tài nguyên
      ,'0242' as[FSIGENCLASSCD] -- Mã lớp tài nguyên
	  ,0 as FCHARGE
	  ,0 AS FKANSETUCHARGE
	  ,'*' AS FGENKAYOSOCD
	  ,'' aS FKEIHICHARGE -- NULL
	  , '' AS FKEIHIGENKAYOSOCD -- NULL
	  ,'' AS FTANTOCD
	  ,'*' AS FSIGENGRPCD
	  ,replace(case when isnull(DensanCode,'') = '' then  upper(trim(MachineID)) collate database_default else DensanCode collate database_default end,' ','') AS FSUMSIGENCD --- đồng bộ với FSIGENCD
	  ,'' AS FCRPKB -- NULL
	  ,1 AS FYOTEIFLG
	  ,1 AS FJSKFLG
      ,1 as [FJORITU] --Hệ số nhân =1 khi không được chỉ định
  FROM rrc_database.dbo.[222_Machine] t1 left join openquery(as400_mputest,'Select * from ZRFLIB.ZRKO00 where KOBCD != ''9999''') t2 on t1.DensanCode = t2.KOCD Collate database_default or t1.MachineID  Collate database_default = t2.KONAM where t2.KOCD is null and LEN(t1.MachineID)<=10
 union 
 SELECT
	  'RRC' as [FCOMPANYCD] 
      ,TRIM(MachineID)  as [FSIGENCD]  -- Mã tài nguyên
      ,cast('1900/01/01'as nvarchar(20)) as [FVALIDYMD] -- Giới hạn ngày hợp lê
      ,'en' as [FLNGKB] -- ngôn ngữ
      ,cast('2999/12/31'as nvarchar(20)) as[FINVALYMD] -- giới hạn ngyaf hợp lệ
      ,TRIM(MachineID) collate database_default as[FSIGENMEI] -- tên tài nguyên
      ,'0242' as[FSIGENCLASSCD] -- Mã lớp tài nguyên
	  ,0 as FCHARGE
	  ,0 AS FKANSETUCHARGE
	  ,'*' AS FGENKAYOSOCD
	  ,'' aS FKEIHICHARGE -- NULL
	  , '' AS FKEIHIGENKAYOSOCD -- NULL
	  ,'' AS FTANTOCD
	  ,'*' AS FSIGENGRPCD
	  ,Upper(MachineID)  collate database_default  AS FSUMSIGENCD
	  ,'' AS FCRPKB -- NULL
	  ,1 AS FYOTEIFLG
	  ,1 AS FJSKFLG
      ,1 as [FJORITU] --Hệ số nhân =1 khi không được chỉ định
  FROM 
(Select distinct upper(t1.MachineID) as MachineID from rrc_database.dbo.[242_OptionData] t1  
	left join rrc_database.dbo.[222_Machine] t2 on t1.MachineID = t2.MachineID
	left join openquery(as400_mputest,'Select * from ZRFLIB.ZRKO00 where KOBCD != ''9999''') t02 on t1.MachineID  Collate database_default = t02.KOCD  or t1.MachineID  Collate database_default = t02.KONAM
	where t2.MachineID is null and t02.KOCD is null and t1.MachineID is not null and t1.MachineID !='' and t1.MachineID not like '%,%' and t1.MachineID not like '%000' ) as OPTIONMACHINE
	union  select * from V_SMSIGENBONUS


CREATE view [dbo].[V1644_SMUSERMEI] as (
SELECT t1.[FCOMPANYCD]
      ,t1.[FUSERCD]
      ,format(t1.[FVALIDYMD],'yyyy/MM/dd') as [FVALIDYMD]
      ,t1.[FLNGKB]
      ,trim(t1.[FUSERRMEI]) as [FUSERRMEI]
      ,t1.[FUSERMEI]
      ,t1.[FKANAMEI]
   FROM [scaw_db].[dbo].[SMUSERMEI] t1
   inner join V1644_SMUSER t2 
   on t1.FUSERCD=t2.FUSERCD
   )

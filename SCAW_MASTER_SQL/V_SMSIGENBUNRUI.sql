CREATE View [dbo].[V_SMSIGENBUNRUI]
as 

Select 'RRC' as FCOMPANYCD, DepartmentID as FSIGENCLASSCD,'en' as FLNGKB,case when DepartmentID ='0281' then 'Maintenance' else ENGLISHNAME end as FSIGENCLASSMEI  from openquery(as400_mputest,'Select * from RORZE_ERP.G211_Department')

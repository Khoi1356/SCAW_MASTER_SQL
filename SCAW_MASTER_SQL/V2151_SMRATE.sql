﻿CREATE VIEW [dbo].[V2151_SMRATE]
AS
WITH TB1 AS (SELECT  DLYYMD AS [DATE]
					, CUR 
					,  CAST(ROUND(1 / DLTR,6) AS decimal(18,6)) AS Rate
				FROM OPENQUERY(AS400_MPUTEST, 'SELECT * FROM RORZE_ERP.V_Material_DS_EXRATE WHERE DLTR > 0')) 
	, TB2 AS (	SELECT DISTINCT CUR, SUBSTRING(CAST([DATE] AS nvarchar(8)),1,6) AS MON
				FROM TB1) 
	, TB01 AS (	SELECT DISTINCT CUR 
				FROM OPENQUERY(AS400_MPUTEST, 'SELECT * FROM RORZE_ERP.V_Material_DS_EXRATE WHERE DLTR > 0'))
	, TB02 AS (	SELECT * FROM [rrc_database].[dbo].[222_Calendar]
				WHERE CASYMD >= 20190201 AND CASYMD <= 20201231) 
	, TB03 AS ( SELECT  CUR , SUBSTRING(CAST(CASYMD AS nvarchar(8)),1,6) AS MON, CASYMD
				FROM TB01, TB02) 
	, TB3 AS (	SELECT TB2.*, T1.CASYMD 
				FROM TB2,[rrc_database].[dbo].[222_Calendar] AS T1
				WHERE TB2.MON = SUBSTRING(CAST(CASYMD AS nvarchar(8)),1,6)
				UNION 
				SELECT * FROM TB03) 
	, TB4 AS (	SELECT TB3.CUR, CASYMD, MON, TB1.Rate
				FROM TB3
				LEFT JOIN TB1 
				ON TB1.CUR = TB3.CUR AND TB1.[DATE] = TB3.CASYMD) 
	, TB5 AS (	SELECT T1.CUR
					, CONVERT(date, CONVERT(varchar(8), T1.CASYMD)) AS FDATE
					, CASE WHEN T1.Rate IS NULL 
						THEN (SELECT TOP 1 Rate FROM TB4 AS T0 
							  WHERE T0.CASYMD < T1.CASYMD		
							  AND T0.Rate IS NOT NULL
							  AND T0.CUR = T1.CUR)
						ELSE T1.Rate
						END AS Rate1
				FROM TB4 AS T1)
SELECT 'RRC' AS  FCOMPANYCD 
	, FORMAT(FDATE,'yyyy/MM/dd') AS FDATE
	, CUR AS FFROMTUKACD
	, 'USD' AS FTOTUKACD
	, '' AS FTTSRATE
	, Rate1 AS FTTBRATE
	, '' AS FTTMRATE
	, AVG(Rate1) OVER (PARTITION BY FORMAT(FDATE,'yyyyMM'), CUR) AS FSHANAIRATE
	, '' AS FENTDT
	, '' AS FENTPRG
	, '' AS FENTUSR
	, '' AS FUPDTEDT
	, '' AS FUPDTEPRG
	, '' AS FUPDTEUSR
FROM TB5
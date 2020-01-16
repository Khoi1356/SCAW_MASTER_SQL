﻿CREATE VIEW [dbo].[V2151_SMKOJUN_Temp]
AS
WITH TB1 AS (	SELECT  'RRC' AS FCOMPANYCD
						, TRIM(T2.PartNo) COLLATE DATABASE_DEFAULT  AS FKOJUNHINCD
						, 'RRC' AS FKYOTENCD
						, '*' AS FSEZOPTCD
						, ROW_NUMBER() OVER (PARTITION BY T1.PartID ORDER BY T1.PartID, T1.OptionID) AS FKOJUN
						--, PartType AS FKOJUNTYP
						, 'M' AS FKOJUNTYP
						--, UPPER(T1.OptionID) AS FKOTEICD
						, UPPER(TRIM(T1.OptionID)) AS FKOTEICD
						, UPPER(TRIM(T1.OptionID)) AS FSAGYOCD
						, '' AS Work3ID
						, CASE WHEN ISNULL(CEILING(T1.LeadTime / 3600),0) <= 0 THEN 1 ELSE CEILING(T1.LeadTime / 3600) END AS FKOJUNLT
						, 0 AS FOFFSET
						, CASE WHEN ISNULL(CEILING(T1.LeadTime / 3600),0) <= 0 THEN 1 ELSE CEILING(T1.LeadTime / 3600) END AS FTOKKYUKOJUNLT
						, 0 AS FTOKKYUOFFSET
						, CASE WHEN ISNULL(UPPER(SUBSTRING(TRIM(JigID), 1, 20)), '') NOT IN ('', 'FALSE') THEN 1 ELSE 0 END AS FJIGUFLG
						, CASE WHEN ISNULL(UPPER(SUBSTRING(TRIM(JigID), 1, 20)), '') NOT IN ('', 'FALSE') THEN ISNULL(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TRIM([dbo].[fChuyenCoDauThanhKhongDau](JigID)), N'Ф', ''), N'Φ', ''),N'Ø',''),N'∅',''), 1, 20), '') ELSE '' END AS FJIGUNO
						, 0 AS Col
				FROM (SELECT * FROM (SELECT PartID,T1.OptionID,JigID, ISNULL(ProTime,0) + ISNULL(ClampTime,0) AS LeadTime,ROW_NUMBER()OVER(PARTITION BY PartID,T1.OptionID ORDER BY inputDate DESC) RN FROM [rrc_database].[dbo].[242_OptionData] T1 INNER JOIN [rrc_database].[dbo].[242_Option] T2 ON t1.OptionID = T2.OptionID)TT WHERE RN = 1) AS T1 
				INNER JOIN OPENQUERY(AS400_MPUTEST,'WITH TB1 AS (	SELECT  T1.ITHNBN, T1.ITSICD 
																			, CASE WHEN T1.ITHNTP = ''P'' AND T2.ITHNTP = ''M'' THEN ''M''
																				ELSE T1.ITHNTP END AS ITHNTP
																			, SUBSTRING(T1.ITFILL, 16, 4) AS ITFILL
																		FROM MPIT00 AS T1
																		LEFT JOIN MPIT00 AS T2
																		ON T1.ITSHBN = T2.ITHNBN
																		WHERE T1.ITHNTP != ''F'')
														, TB2 AS (SELECT ITHNBN AS PartNo
															, ITSICD AS SupplierID
															, CASE WHEN ITHNTP = ''P'' AND ITFILL = ''0242'' THEN ''S''
																ELSE ITHNTP END AS PartType
														FROM TB1)
														SELECT * FROM TB2 
														WHERE PartType = ''M''') AS T2
				ON T1.PartID COLLATE DATABASE_DEFAULT = T2.PartNo
				WHERE ISNULL(PartID, '') <> '' AND ISNULL(T1.OptionID,'') NOT IN ('','GT','WIRE1') 

				UNION ALL
								SELECT  'RRC' AS FCOMPANYCD
						, TRIM(T1.CompID) AS FKOJUNHINCD
						, 'RRC' AS FKYOTENCD
						, '*' AS FSEZOPTCD
						, FORMAT(ROW_NUMBER() OVER (PARTITION BY TRIM(T1.CompID)	ORDER BY CASE WHEN WORKTYPE = 'WIRE' THEN 1 WHEN WORKTYPE = 'WICK' THEN 2 WHEN WORKTYPE = 'ASSY' THEN 3 WHEN WORKTYPE = 'ASCK' THEN 4 ELSE 5 END), '000') AS FKOJUN
						, 'M' AS FKOJUNTYP
						, T2.WorkType AS FKOTEICD
						, T2.WorkType AS FSAGYOCD
						, '' Work3ID
						, ROUND(SUM(T1.STD) / 480, 0) AS FKOJUNLT
						, 0 AS FOFFSET
						, ROUND(SUM(T1.STD) / 480, 0) AS FTOKKYUKOJUNLT
						, 0 AS FTOKKYUOFFSET
						, 0 AS FJIGUFLG
						, '' AS FJIGUNO
						, 1 AS Col
				FROM    rrc_database.dbo.[231_PLAN_WIDSTD] T1 
				INNER JOIN rrc_database.dbo.[231_TimeWork] T2 
				ON T1.Work3ID = T2.TimeWorkID 
				INNER JOIN rrc_database.dbo.[231_Comp] T3 
				ON T1.CompID = T3.CompID
			    INNER JOIN rrc_database.dbo.[231_WorkGroupDefine] T4 ON T4.CompGroup = T3.CompGroup AND T4.WorkID = WorkType
				WHERE LEN(T1.CompID) <= 20 GROUP BY TRIM(T1.CompID),T2.WorkType)
SELECT [FCOMPANYCD]
      ,[FKOJUNHINCD]
      ,[FKYOTENCD]
      ,[FSEZOPTCD]
      ,FORMAT(ROW_NUMBER() OVER (PARTITION BY [FKOJUNHINCD] ORDER BY [FKOJUNHINCD], [FKOJUN], Col),'00')+'0' AS [FKOJUN]
      ,[FKOJUNTYP]
      ,[FKOTEICD]
      ,[FSAGYOCD]
      ,CASE WHEN [FKOJUNLT] <= 0 THEN 1 ELSE [FKOJUNLT] END AS [FKOJUNLT]
      ,[FOFFSET]
      ,[FTOKKYUKOJUNLT]
      ,[FTOKKYUOFFSET]
      ,[FJIGUFLG]
      ,[FJIGUNO]
FROM TB1
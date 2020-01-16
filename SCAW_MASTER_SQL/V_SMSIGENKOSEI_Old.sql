



CREATE view [dbo].[V_SMSIGENKOSEI_Old] as   
-- WITH TB1 AS (SELECT  'RRC' AS FCOMPANYCD
--						, TRIM(T4.PartNo) COLLATE DATABASE_DEFAULT  AS FKOJUNHINCD
--						, 'RRC' AS FKYOTENCD
--						, '*' AS FSEZOPTCD
--						, ROW_NUMBER() OVER (PARTITION BY PartID ORDER BY PartID, T1.OptionID) AS FKOJUN,
--						t1.MachineID,
--						T1.ProTime,
--						t1.OptionID
						
--				FROM [rrc_database].[dbo].[242_OptionData] AS T1 
--				inner JOIN [2151_OptionID] AS T2 ON UPPER(T1.OptionID) = T2.OptionID
				
--				--INNER JOIN V_SMHIN AS T4
--				--ON T1.PartID COLLATE DATABASE_DEFAULT = T4.FHINCD
--				--WHERE ISNULL(PartID, '') <> '' AND ISNULL(T1.OptionID,'') NOT IN ('','GT','WIRE1')  AND T4.FHINTYP='M'
--				INNER JOIN OPENQUERY(AS400_MPUTEST,'WITH TB1 AS (	SELECT  T1.ITHNBN, T1.ITSICD 
--																			, CASE WHEN T1.ITHNTP = ''P'' AND T2.ITHNTP = ''M'' THEN ''M''
--																				ELSE T1.ITHNTP END AS ITHNTP
--																			, SUBSTRING(T1.ITFILL, 16, 4) AS ITFILL
--																		FROM MPFLIB.MPIT00 AS T1
--																		LEFT JOIN MPFLIB.MPIT00 AS T2
--																		ON T1.ITSHBN = T2.ITHNBN
--																		WHERE T1.ITHNTP != ''F'')
--														, TB2 AS (SELECT ITHNBN AS PartNo
--															, ITSICD AS SupplierID
--															, CASE WHEN ITHNTP = ''P'' AND ITFILL = ''0242'' THEN ''S''
--																ELSE ITHNTP END AS PartType
--														FROM TB1)
--														SELECT * FROM TB2 
--														WHERE PartType = ''M''') AS T4
--				ON T1.PartID COLLATE DATABASE_DEFAULT = T4.PartNo
--				WHERE ISNULL(PartID, '') <> '' AND ISNULL(T1.OptionID,'') NOT IN ('','GT','WIRE1')

--				)
			
--				,TB2 AS(
--SELECT TB1.[FCOMPANYCD]
--      ,TB1.[FKOJUNHINCD]
--      ,TB1.[FKYOTENCD]
--      ,TB1.[FSEZOPTCD]
--      ,FORMAT(ROW_NUMBER() OVER (PARTITION BY [FKOJUNHINCD] ORDER BY [FKOJUNHINCD], [FKOJUN]),'00')+'0' AS [FKOJUN],

--	  TB2.FSIGENCD,
--	  '1990/01/01' AS FVALIDYMD,
--	  CASE WHEN TB1.ProTime IS NULL THEN '' ELSE TB1.ProTime END AS FSTDHOUR,
--	   --TB4.FSAGYOKB,
--	   'V' AS FSAGYOKB,
--	    '2999/12/31' as FINVALYMD,
--		 '' as  FENTDT,
--		 '' as FENTPRG,
--		 '' as FENTUSR,
--		 '' as FUPDTEDT,
--		 '' as FUPDTEPRG,
--		 '' as FUPDTEUSR
		
--FROM TB1
--left join [V_SMSIGEN] AS TB2 ON TB1.MachineID=TB2.FSIGENMEI 
--left join dbo.[1802_Department] AS TB3 ON TB2.FSIGENCD = TB3.OptionID 
--left join dbo.V1965_SMSAGYOKB AS TB4 ON TB3.FSAGYOKBMEI = TB4.FSAGYOKBMEI collate database_default)
--SELECT * FROM TB2 WHERE  TB2.FSIGENCD IS NOT NULL  

SELECT GETDATE() TT

﻿CREATE VIEW [dbo].[V2151_SMBUSHO_C_Supplier]
AS
SELECT 'RRC' AS FCOMPANYCD
		,TRIM(Supplier_Code) COLLATE DATABASE_DEFAULT AS FBUSHOCD
		,'en' AS FLNGKB
		,'1900/01/01' AS FVALIDYMD
		,'2999/12/31' AS FINVALYMD
		,'C' AS FBUSHOTYP
		,0 AS FKOKYAKUFLG
		,1 AS FSIREFLG
		,ISNULL(TRIM(Supplier_ShortName),'*') COLLATE DATABASE_DEFAULT AS FBUSHORMEI
		,dbo.fChuyenCoDauThanhKhongDau(TRIM(Supplier_FullName)) COLLATE DATABASE_DEFAULT AS FBUSHOMEI
		,ISNULL(TRIM(Supplier_Katahana),'*') COLLATE DATABASE_DEFAULT AS FBUSHOKANAMEI
		,Country_Code COLLATE DATABASE_DEFAULT AS FKUNICD
		,'' AS FAREACD
		,Currency COLLATE DATABASE_DEFAULT AS FTUKACD
		,TRIM(Supplier_Code) COLLATE DATABASE_DEFAULT AS FSIHARAISAKICD
		,0 AS FSIHARAIGAKHASUSHORIKB
		,3 AS FFAXSENDKB1
		,1 AS FTOKUSOKUFLG
		,'' AS FBOEKIJOKEN
		,'' AS FSHIHARAIJOKEN1
		,'' AS FSHIHARAIJOKEN2
		,'' AS FYUBINNO
		,dbo.fChuyenCoDauThanhKhongDau(ISNULL(REPLACE(TRIM([Address]),'"',''),'')) COLLATE DATABASE_DEFAULT AS FJUSHO1
		,'' AS FJUSHO2
		,'' AS FJUSHO3
		,'' AS FTELNO
		,'' AS FBIKO
		,ISNULL(TRIM(FAX),'') COLLATE DATABASE_DEFAULT AS FFAXNO
		,'' AS FFAXNO2
		,'' AS FFAXNO3
		,ISNULL(TRIM(PICEMAIL),'') COLLATE DATABASE_DEFAULT AS FMAIL1
		,'' AS FMAIL2
		,CASE WHEN ISNULL(T2.PIC,'') = '' THEN 'chi@robotech.com.vn' ELSE T2.PIC END AS FMAIL3
		,'00532' AS FTANTOCD
FROM [scaw_db].[dbo].[2151_Supplier] AS T1
LEFT JOIN [V_2151_SupplierEmail] AS T2
ON T1.Supplier_Code = T2.SupplierID

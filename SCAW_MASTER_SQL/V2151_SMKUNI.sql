﻿CREATE VIEW [dbo].[V2151_SMKUNI]
AS
SELECT  'RRC' AS FCOMPANYCD, 
		UPPER(TRIM(CountryCode)) AS FKUNICD, 
		'en' AS FLNGKB, 
		UPPER(TRIM(CountryName)) AS FKUNIMEI,
		'' AS FBODYKAKERITU,
		'' AS FSERVICEKAKERITU,
		'' AS FETCKAKERITU,
		Currency AS FTUKACD
FROM    [2151_Country] INNEr JOIN (SELECT FTUKACD CD FROM SMTUKA) TT ON Currency = CD
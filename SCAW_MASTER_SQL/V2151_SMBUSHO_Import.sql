CREATE VIEW V2151_SMBUSHO_Import
AS
SELECT '' AS Comment			--1
, FLNGKB						--2
, FBUSHOTYP						--3
, FBUSHOCD						--4	
, FBUSHOMEI						--5
, FBUSHORMEI					--6
, '' AS FBUSHOKANAMEI			--7
, FJOIBUSHOCD					--8
, '' AS Level_Below				--9
, FSHOZOKUKB AS FFLDID			--10
, '' AS Purchase_Code			--11
, '' AS Purchase_Name			--12
, 1 AS Rate						--13
, '' AS Lan						--14
, '' AS LTD						--15
, '' AS ProjectType				--16
, '' AS Start1					--17
, '' AS Finish1					--18	
, 0 AS Dept						--19
, 1 AS Flag						--20
, '' AS Agency_Code				--21
, '' AS Agency_Name				--22
, '*' AS Tax_Code				--23
, '1900/01/01' AS Start2		--24
, '' AS PostOffice				--25
, '' AS Add1					--26
, '' AS Add2					--27
, '' AS Add3					--28
, '' AS Tel						--29
, '' AS Fax1					--30
, '' AS Fax2					--31
, '' AS Fax3					--32
, '' AS Mail1					--33
, '' AS Mail2					--34
, '' AS Mail3					--35
, '' AS Pre1					--36
, '' AS Pre2					--37
, '' AS Pre3					--38
, '' AS Sym1					--39
, '' AS Sym2					--40
, '' AS Sym3					--41
, '' AS Remark					--42
, '' AS Point					--43
, CASE WHEN FBUSHOCD IN ('0231','0232') OR FBUSHOCD LIKE 'AS%' THEN '1' ELSE '' END AS StartFlag 		  --44
, CASE WHEN FBUSHOCD IN ('0231','0232') OR FBUSHOCD LIKE 'AS%' THEN '1' ELSE '' END AS FinishFlag		  --45
FROM V2151_SMBUSHO_A 

UNION ALL

SELECT '' AS Comment					--1
	, FLNGKB							--2
	, FBUSHOTYP							--3
	, FBUSHOCD							--4
	, FBUSHOMEI							--5
	, FBUSHORMEI						--6
	, '' AS FBUSHOKANAMEI				--7
	, FJOIBUSHOCD						--8
	, '' AS Level_Below					--9
	, FSHOZOKUKB AS FFLDID				--10
	, '' AS Purchase_Code				--11
	, '' AS Purchase_Name				--12
	, '' AS Rate						--13
	, '' AS Lan							--14
	, '' AS LTD							--15
	, '' AS ProjectType					--16
	, '' AS Start1						--17
	, '' AS Finish1						--18
	, 0 AS Dept							--19
	, 1 AS Flag							--20
	, '' AS Agency_Code					--21
	, '' AS Agency_Name					--22
	, '' AS Tax_Code					--23
	, '1900/01/01' AS Start2			--24
	, '' AS PostOffice					--25
	, '' AS Add1						--26
	, '' AS Add2						--27
	, '' AS Add3						--28
	, '' AS Tel							--29
	, '' AS Fax1						--30
	, '' AS Fax2						--31
	, '' AS Fax3						--32
	, '' AS Mail1						--33
	, '' AS Mail2						--34
	, '' AS Mail3						--35
	, '' AS Pre1						--36
	, '' AS Pre2						--37
	, '' AS Pre3						--38
	, '' AS Sym1						--39
	, '' AS Sym2						--40
	, '' AS Sym3						--41
	, '' AS Remark						--42
	, '' AS Point				--43
	, '' AS StartFlag					--44
	, '' AS FinishFlag					--45
FROM V2151_SMBUSHO_M

CREATE VIEW V2151_Group_SMBUSHO
AS
with t01 as (SELECT row_number() over(partition by Name order by Name desc) as row,Id_BoPhan, Name
			 FROM [rrc_database].[dbo].[242_NC_DKNC] where Name not like 'STG%' )
  select T01.Name AS OptionID, T02.Name AS [Group] , T03.Group_SMBUSHO
  from t01
  left join [rrc_database].[dbo].[242_BoPhan_DKNC] as t02 on t01.Id_BoPhan=t02.Id
  INNER JOIN [scaw_db].[dbo].[2151_GroupDefine] AS T03
  ON T03.Group_DKNC = T02.Name
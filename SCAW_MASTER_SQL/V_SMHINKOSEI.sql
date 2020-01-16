CREATE view V_SMHINKOSEI
as 
Select 
'RRC' as FCOMPANYCD
,TRIM(ISNULL(T2.DummyPart, HSTOHBN)) AS FOYAHINCD -- chi tiết cha
,'RRC' as FOYAKYOTENCD
,TRIM(ISNULL(T3.DummyPart, HSTBHBN)) AS FKOHINCD -- chi tiết con
,'RRC' as FKOKYOTENCD
,0 as FNARABISEQ
,STKOSU as FKOSEISU
,cast('1900/01/01'as nvarchar(20)) as FVALIDYMD
,cast('2999/12/31'as nvarchar(20)) FINVALYMD
,0 as FKOSEILT -- Leadtime để tạo lên cấu hình cha
,'' as FBIKO -- ghi chú
,1 as FYUKOFLG -- Mục xác nhận cấu hình có được hợp lệ để giao hàng hay không
,0 as FDELFLG -- cờ xóa
,'' as FDELYMD -- Ngày xóa NULL
,iSNULL(t4.FKOJUN,'') as FHARAIKOJUN  --Case when  HITHNTP = 'F'  then '' else '010' end as FHARAIKOJUN -- "A work order code that does not exist in the work order M of the parent item is set in the" Delivery work order (FHARAIKOJUN) ". ※ Mainly 0 is set. Please correct it. "
,'0' as FSEIBANTEHAIKB -- Case when t4.FHINTYP in ('M','F') then  0 else 1 end as FSEIBANTEHAIKB -- Phân loại sắp xếp số sản xuấtChỉ định có quản lý bằng cách liên kết với số sản xuất[0: Mục tiêu chuẩn, 1: Mục đặt hàng số nhà sản xuất]※ Đặt số thứ tự cho mục con
,2 as FSHUKKOKB -- phân loại giao hàng: 1 cố dịnh 2: thủ công mặc định là 2
,Case when  HITHNTP = 'F'  then '0' else '1' end  as FSIZE --Cờ đặt hàng sản xuất Đánh dấu xem có đặt hàng tiêu chuẩn hay không※ "1" nếu mục con là mục thứ tự số sản phẩm hoặc phân loại chính sách sắp xếp mục con là M (MRP), "0" trong các trường hợp khác
from OPENQUERY(as400_mputest, 
                         'With T1 as (
							 SELECT CAST(CAST(STOHBN as char(40) CCSID 65535) as char(40) CCSID 930) AS HSTOHBN,CAST(CAST(STBHBN as char(40) CCSID 65535) as char(40) CCSID 930) AS HSTBHBN,STKOSU,ITHNTP,ITFILL 
							 FROM MPST00 
									 inner join MPIT00 on STBHBN = ITHNBN
							 UNION ALL SELECT TRIM(ITHNBN) HSTOHBN,CAST(CAST(STBHBN as char(40) CCSID 65535) as char(40) CCSID 930) AS HSTBHBN,STKOSU,ITHNTP,ITFILL 
							 FROM MPST00 
								INNER JOIN MPIT00 ON ITSHBN = STOHBN WHERE ITHNTP = ''P''),
							T2 as (SELECT T1.ITHNBN PPART,''M'' PTP FROM MPIT00 T1 INNER JOIN MPIT00 T2 ON T1.ITSHBN = T2.ITHNBN AND T2.ITHNTP = ''M'' AND T1.ITHNTP = ''P'')
							Select HSTOHBN,HSTBHBN,STKOSU,COALESCE(PTP,ITHNTP) as HITHNTP,ITFILL  from T1 left join T2 ON HSTBHBN = PPART')
                          AS T1 LEFT OUTER JOIN
                         dbo.SMHINDUMMY T2 ON T1.HSTOHBN = T2.DSPartNo COLLATE DATABASE_DEFAULT
						 LEFT OUTER JOIN
                         dbo.SMHINDUMMY T3 ON T1.HSTBHBN = T3.DSPartNo COLLATE DATABASE_DEFAULT 
						 left join SMKOJUN t4 on t4.FKOJUNHINCD = TRIM(ISNULL(T2.DummyPart, HSTOHBN)) and t4.FKOJUN = '010'
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SMHINDUMMY"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_SMHINKOSEI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_SMHINKOSEI';


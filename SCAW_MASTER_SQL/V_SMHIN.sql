


CREATE View [dbo].[V_SMHIN] as

Select   'RRC' as FCOMPANYCD,
 trim(ISNULL(dbo.SMHINDUMMY.DummyPart, t1.ITHNBN)) AS FHINCD,
'en' as FLNGKB,
trim(ITNAM1) as FHINRMEI, 
trim(ITNAM1) as FHINMEI, -- MR TASO xác nhận ngày 20-3-2019
trim(ITSHBN+ITNAM2) as FMEKERHINCD, -- MPIT00.ITSHBN+MPIT00.ITNAM2
REPLACE(trim(Isnull(GASINM,'')),'\t','')  as FMEKERMEI, -- ITSICD (Search MPGA00 from MPIT00.ITMCOD)
isnull(trim(I4PNAM),'') as FHINENGMEI, -- tên tiếng anh
CASE WHEN HITHNTP = 'F' THEN 'C' ELSE CASE WHEN substring(ITFILL, 16, 4) = '0242' AND HITHNTP = 'P' THEN 'S' ELSE HITHNTP END END AS FHINTYP,
'' as FKISHUG, -- mã nhóm model trim(ITKTGR)
Trim(Isnull(t2.RRC_Unit,ITTNI1)) as FTANICD, -- đơn vị tiêu hao  
Case when HITHNTP in ('M','F') then  Trim(Isnull(t2.RRC_Unit,ITTNI1)) else Trim(ISNULL(t3.RRC_Unit,Isnull(ITHTAN,ITTNI1))) end as FHACHUTANICD, -- đơn vị đi mua 
'' as FZAICD -- mã loại vật liệu (ITSHSR) (NUll or Blank)
,'' as FKIKAKU-- kích thước chi tiết MSG1 (nhieu hon 40 ký tự)
,Case when  HITHNTP ='P' or HITHNTP ='M' then 1 else 0 end as FZFLG --'Đặt 1  nếu muỗn quản lý vị trí'
,trim(SUBSTRING(ITFILL,53,40)) as FBIKO1 -- ghi chú (MPIT00.ITBICO)
,trim(ITBICO) as FBIKO2 --SUBSTRing(ITFILL,73,20) ghi chú 2 (SUBSTR(MPIT00.ITFILL,53,40)：注文書の備考)
,'0' as FSEIBANTEHAIKB -- Case when  HITHNTP ='F' or HITHNTP ='M' then 0 else 1 end  as FSEIBANTEHAIKB --Mr Khoi 20190801 -- quản lý với số lượng sản xuất Case when  HITHNTP ='F' or HITHNTP ='M' then 1 else case when  ITHNTP='P' then 0 else  1 end end mrKhoi 20190613
,cast('1900/01/01' as nvarchar(20)) as FVALIDYMD -- mặc định
,cast('2999/01/01'as nvarchar(20)) as FINVALYMD -- mặc định
,2 as FSHUKKOKB -- Phân loại hàng hóa 2 giao thủ công
,0 as FJIDOUKAKUTEIKB --Xác nhận tự động (0: xác nhận thủ công;1 Xác nhận tự động)
, 0 as FAZUKARIHINFLG --"đanh dấu nếu là hàng ký gửi(1 là hàng ký gửi: 0 là loại khác) (Xác nhận lại vs mr CHung)
,trim(ISNULL(dbo.SMHINDUMMY.DummyPart, t1.ITHNBN)) as FZHINCD -- Mã chi tiết danh cho kiểm kê
,Case when HITHNTP = 'F' or HITHNTP ='M' then 1 else case  when ITKANZ = 0 then 1 else ITKANZ end end as FKANZANRATE -- Hệ số chuyển đổi sang đơn vị mua
,0 as FMATOMEKANKB -- MATOME
,0 as FNYURYOKUKB -- Phân loại xem có nên tự nhập tên chi tiết theo cách sắp xếp hay không. 0: không, 1: Có NTT xác nhạn
,0 as FKARIENTFLG -- đăng ký chính thức hay đăng ký tạm thời
,'' as FBUHINTYP -- Component type
,'' as FTEHAITYP -- Loại order
, 'RRC' as  FKYOTENCD --  Mã xác định vị trí sản xuất
--,'' as FTXTYOBI01
--,'' as FTXTYOBI02
--,'' as FTXTYOBI03
--,'' as FTXTYOBI04
--,'' as FTXTYOBI05
--,'' as FTXTYOBI06
--,'' as FTXTYOBI07
--,'' as FTXTYOBI08
--,'' as FTXTYOBI09
--,'' as FTXTYOBI10
--,'' as FCDYOBI01
--,'' as FCDYOBI02
--,'' as FCDYOBI03
--,'' as FCDYOBI04
--,'' as FCDYOBI05
--,'' as FCDYOBI06
--,'' as FCDYOBI07
--,'' as FCDYOBI08
--,'' as FCDYOBI09
--,'' as FCDYOBI10
,trim(SUBSTRING(ITFILL,15,1)) as FSEIHINKB -- Danh mục sản phẩm
, Case when  HITHNTP = 'M' and substring(ITFILL, 16, 4) in ('0232')     then '5314'  else '5312' end as FHINAREACD-- Case when (substring(ITFILL, 16, 4) in ('0232','0231') and ITHNTP = 'M')   then '5314' else '5312' end as FHINAREACD --20191002 tất cả các con loại M phải gắn cờ lắp ráp --FB28 chi tiết nếu của lắp ráp loại M set khu vực kho lắp ráp;  Mã vùng 
,'PL04' as FHINGROUPCD -- Mã nhóm
,0 as FSETSUDANFLG -- đánh dấu loại bỏ NTT xác nhận -- CÓ CẮT HAY KHÔNG
,isnull(trim(I3HONM),'') as FHOJOMEI -- tên phụ NTT xác nhận
,isnull(trim(ITECNO),'') as FSEKKEITANTOSHA -- tên nhà thiết kế (ITKTGR)
,isnull(trim(I8BKBN),'') as FBOKANKB -- Phân loại kiểm soát thương mại
,isnull(trim(I3CD8+SUBSTRING(I3AFIL,21,2)),'') as FTORIATUKAI -- 'Xử lý(handling)' + +MPIT30.I3CD9
,trim(SUBSTRING(ITFILL,32,1)) as FHYOMENKB1 -- 'Phần bề mặt 1'
,trim(SUBSTRING(ITFILL,93,1)) as FHYOMENKB2 -- 'Phần bề mặt 2'
,trim(SUBSTRING(ITFILL,48,1)) as FHYOMENKB3 -- 'Phần bề mặt 3' MPIT30.I3HKB3
,trim(SUBSTRING(ITFILL,46,1)) as FHYOMENKB4 -- 'Phần bề mặt 4' MPIT30.I3HKB4
,trim(SUBSTRING(ITFILL,47,1)) as FHYOMENKB5 -- 'Phần bề mặt 5' MPIT30.I3HKB5
,trim(ITSHSR) as  FZAIHYOMENSHORI -- Xử lý bề mặt
,trim(SUBSTRING(ITFILL,33,1)) as FKEIKOKUKB -- chỉ xuất cảnh báo
,isnull(trim(SUBSTRING(I3AFIL,9,11)),'') as FTRACEBACKCD1 -- Mã truy xuất 1 I3MANO
,isnull(trim(SUBSTRING(I3FILL,32,4)),'') as FTRACEBACKCD2 -- Mã truy xuất 2 I3INDX 
,isnull(trim(SUBSTRING(I3FILL,36,9)),'') as FTRACEBACKCD3 -- Mã truy xuất 3 I3SANO
,trim(Isnull(I9TEX1,'')) as FKIGENTEXT1 -- Thời hạn 1
,trim(Isnull(I9NOK1,'')) as FNOKITEXT1 --Ngày giao hàng 1
,trim(Isnull(I9TEX2,'')) as FKIGENTEXT2 -- Thời hạn 2
,trim(Isnull(I9NOK2,'')) as FNOKITEXT2 --Ngày giao hàng 2
,trim(Isnull(I9TEX3,'')) as FKIGENTEXT3 -- Thời hạn 3
,trim(Isnull(I9NOK3,'')) as FNOKITEXT3 --Ngày giao hàng 3
,trim(Isnull(I9TEX4,'')) as FKIGENTEXT4 -- Thời hạn 4
,trim(Isnull(I9NOK4,'')) as FNOKITEXT4 --Ngày giao hàng 4
,trim(Isnull(I9TEX5,'')) as FKIGENTEXT5 -- Thời hạn 5
,trim(Isnull(I9NOK5,'')) as FNOKITEXT5 --Ngày giao hàng 5
,trim(Isnull(I9TEX6,'')) as FKIGENTEXT6 -- Thời hạn 6
,trim(Isnull(I9NOK6,'')) as FNOKITEXT6 --Ngày giao hàng 6
,trim(Isnull(I9TEX7,'')) as FKIGENTEXT7 -- Thời hạn 7
,trim(Isnull(I9NOK7,'')) as FNOKITEXT7 --Ngày giao hàng 7
,trim(Isnull(I9TEX8,'')) as FKIGENTEXT8 -- Thời hạn 8
,trim(Isnull(I9NOK8,'')) as FNOKITEXT8 --Ngày giao hàng 8
,trim(Isnull(I3IQNO,'')) as FIQ -- IQ#
,trim(Isnull(I3ROHS,'')) as FROHS -- RoHS
,Isnull(case when ISDATE(I3CYBI) !=1 then '' else REPLACE(CONVERT(varchar,convert(date,convert(varchar,I3CYBI))),'-','/') end,'')  as FCHOSAYMD --  Ngày khảo sát
,Isnull(trim(sUBSTRING(I3AFIL,48,1)),'') as FHINBUNRUI -- Phân loại (ITHNCL) // RJ I3BKBN
,Isnull(trim(I8ZCD1),'') as FZAISHITSUCD1 -- Mã vật liệu 1
,Isnull(trim(I8ZCD2),'') as FZAISHITSUCD2 -- Mã vật liệu 2
,'' as FZAISIZE -- Kích thước vật liệu
,trim(ISNULL(dbo.SMHINDUMMY.DummyPart, t1.ITHNBN)) as FRJHINCD -- Mã chi tiết RJ
,Case when t4.CompID is null then case when HITHNTP ='M' and SUBSTRING(ITFILL,16,4)='0231' and ITHNBN not like 'ASZ%' then '1' else  '0' end else '1' end  as FSERIALFLG -- Xác nhận có serial
,'\\192.168.0.5\Drawing\Original' as FHINPATH -- đường dẫn thông tin liên quan
,Case when (substring(ITFILL, 16, 4) = '0232' and ITHNTP = 'P')   then 1 else 0 end  as FHIMOZUKEFLG --Sửa HITHNTP -> ITHNTP Mr.Khoi xac nhAN 20191212; 20190912 chỉ lấy toàn bộ hàng lắp ráp loại P xác nhận chốt phục vụ đảo yoyaku, quy tắc đường chéo không có 2 cờ
,Isnull(trim(SUBSTRING(I8FILL,39,1)),'')  as FTORIATUKAI2 -- Xử lý 2(Nhãn chân không) I8TRI2
,Isnull(trim(SUBSTRING(I9FILL,1,20)),'') AS FHINSHUBETU -- LOẠI CHI TIẾT I9HSYU
,Isnull(trim(I8BUKB),'') AS FBUHINKB -- PHÂN LOẠI THÀNH PHẦN
,Isnull(trim(I9SMEI),'') AS FANZENSHOMEI -- CHỨNG NHẬN AN TOÀN
,Isnull(trim(I4PNAM),'') AS FPARTNAME -- PART NAME
,isnull(convert(varchar,I3GRAM),'') AS FJURYO -- CÂN NẶNG
,isnull(convert(varchar,I8ZAIG),'') AS FZAIJURYO -- CÂN NẶNG VẬT LIỆU
,isnull(convert(varchar,I8KANG),'') AS FKANJURYO -- CÂN NẶNG SAU KHI HOÀN THIỆN
--, substring(ITFILL, 16, 4) as ITFILL
 from openquery(as400_mputest,'select MPIT00.*,COALESCE(PTP,ITHNTP) HITHNTP,PPART,MPMN00.*,MPIT90.*,MPGA00.*,CAST(CAST(I8FILL as char(100) CCSID 65535) as char(100) CCSID 930) as I8FILL,I8ZCD2,I8BKBN,I8ZCD1,I8ZAIG,I8KANG
 ,CAST(CAST(I8BUKB as char(100) CCSID 65535) as char(100) CCSID 930) as I8BUKB,
 CAST(CAST(I3HONM as char(100) CCSID 65535) as char(100) CCSID 930) as I3HONM,CAST(CAST(I3AFIL as char(100) CCSID 65535) as char(100) CCSID 930) as I3AFIL,CAST(CAST(I3FILL as char(100) CCSID 65535) as char(100) CCSID 930) as I3FILL,
 I3IQNO,I3ROHS,I3CYBI,I3GRAM,I3CD8,HNBN(MPIT30.I3PNAM) as I4PNAM from MPIT00 
 left join MPIT30 on ITHNBN = CAST(CAST(I3HNBN as char(40) CCSID 65535) as char(40) CCSID 930) 
 left join MPIT80 on ITHNBN = CAST(CAST(I8HNBN as char(40) CCSID 65535) as char(40) CCSID 930) 
 left join MPIT90 on ITHNBN = CAST(CAST(I9HNBN as char(40) CCSID 65535) as char(40) CCSID 930) 
 LEFT join MPGA00 on ITMCOD = GASICD
left join MPMN00 on ITHNBN = CAST(CAST(MNHNBN as char(40) CCSID 65535) as char(40) CCSID 930) 
left join (SELECT T1.ITHNBN PPART,''M'' PTP FROM MPIT00 T1 INNER JOIN MPIT00 T2 ON T1.ITSHBN = T2.ITHNBN AND T2.ITHNTP = ''M'' AND T1.ITHNTP = ''P'') TT ON ITHNBN = PPART 
') as t1
left join DB2_Unit t2 on upper(trim(t1.ITTNI1)) = upper(trim(t2.DS_Unit))  collate database_default
left join DB2_Unit t3 on  upper(trim(Isnull(ITHTAN,ITTNI1))) = upper(trim(t3.DS_Unit))  collate database_default
LEFT OUTER JOIN scaw_db.dbo.SMHINDUMMY ON t1.ITHNBN  = dbo.SMHINDUMMY.DSPartNo COLLATE DATABASE_DEFAULT
left join rrc_database.dbo.[231_Comp] t4 on t1.ITHNBN =t4.CompID collate database_default 

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
         Begin Table = "t2"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 102
               Left = 246
               Bottom = 198
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SMHINDUMMY"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 119
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_SMHIN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_SMHIN';


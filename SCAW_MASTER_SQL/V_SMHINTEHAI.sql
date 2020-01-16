


CREATE View [dbo].[V_SMHINTEHAI] as 
with t1 as (SELECT  [FCOMPANYCD]
      ,[FLNGKB]
      ,[FZCD]
      ,[FHOKANCD]
      ,[FHOKANMEI]
      ,[FYUKOFLG]
	  ,ROW_NUMBER() over(order by FZCD) as rn
  FROM [scaw_db].[dbo].[SMHOKAN]),
  t2 as(
SELECT 'RRC' as [FCOMPANYCD]
      ,trim(ITHNBN) as [FHINCD]
      ,'RRC' as [FKYOTENCD]
      ,'xyzw' as [FZCD] -- 'xyzw' với y(1-7) tương ứng với z(A-G),z floor, w là số kho trong tầng mặc định là 0
      ,'x0001-01-0' as [FHOKANCD]-- 'A0001-01-0' với A tương ứng với nhà xưởng, 0001 số giá, -01 là số tầng của giá, 0 số ngăn mặc địnk là 0 
      ,trim(ITSICD) as  [FKIHONSIRECD]
      ,0 as  [FKENSAFLG] -- xác nhận đã kiểm tra 1: đã kiểm tra 0:chưa kiểm tra
      ,'' as [FKENSAKB] -- S kiểm tra mẫu, Z kiểm tra toàn bộ Mr.Khôi dữ liệu tesst set S
      ,1 as [FKENSALT] --Leadtime phòng kiểm tra leadtime mua hàng (PKD xác nhận)
      ,trim(ITHNBN) as [FKOJUNHINCD] -- hinban 
      ,Case when HITHNTP = 'M' then  '*' else '' end  as [FSEZOPTCD] -- 2 ký tự cần keermtra lại Mẫu sản xuất thứ tự xử lý-- Since it is used for exception work, it is not used basically.Fixed value (character) is OK.
      ,Case when HITHNTP = 'F'  then ''  ELSE Convert(varchar,ITSFST) END as [FANZENZSU] --20190912 "or (HITHNTP = 'P' and substring(ITFILL, 16, 4) = '0242')"  Số lượng tồn kho an toàn (nẾU LÀ STANDARD Product và MRP mới có dữ liệu FB23)
      ,Case when  HITHNTP = 'F'   then 'N' else 'M' end as [FTEHAIKB] --20190912 "or (HITHNTP = 'P' and substring(ITFILL, 16, 4) = '0242')" Quy tắc tạo đơn hàng
      ,Case when ITLDTM = 0 then case  when HITHNTP ='F' then '' else case  when HITHNTP in ('P','S') then '30' else  '1' end end else  case  when HITHNTP  in ('P','S') then  convert(varchar,ITLDTM+30) else  convert(varchar,ITLDTM) end end  as [FTOKHINLT] -- giới hạn thời gian vận chuyển //ITLDTM
      ,Case when ITLDTM = 0 then case  when HITHNTP ='F' then '' else case  when HITHNTP in ('P','S') then '30' else  '1' end end else  case  when HITHNTP  in ('P','S') then  convert(varchar,ITLDTM+30) else  convert(varchar,ITLDTM) end end as  [FHINLT] --ITLDTM 
      ,'' as [FDEFKOSEILT] --thời gian hoàn thành chi tiết cha từ các chi tiết con 0(dữ liệu bảng kosei) NULL
      ,'' as  [FPICKINGLT] -- thowig ghian nhặt hàng NULL
      ,'' as [FMATOMEKK] -- tổng thời gian
      ,Case when  Convert(int,SUBSTRING(I3AFIL,40,8))<= ITMRYO then  Case when ITMRYO =0 then '1' else Convert(varchar,ITMRYO) end else  trim(SUBSTRING(I3AFIL,40,8)) end  as [FMINTEHAISU] -- Số lượng nhỏ nhất MoQ ITKANZ＊ITMRYO
      ,Case when ITMAXQ =0 or ITMAXQ is null then ''  when  ITMAXQ < (Case when  Convert(int,SUBSTRING(I3AFIL,40,8))<= ITMRYO then Case when ITMRYO =0 then 1 else ITMRYO end else  trim(SUBSTRING(I3AFIL,40,8)) end)
																		then Cast(Case when Convert(int,SUBSTRING(I3AFIL,40,8))<= ITMRYO then  
																		Case when ITMRYO =0 then 1 else ITMRYO end else  trim(SUBSTRING(I3AFIL,40,8)) end as varchar) else cast(ITMAXQ as varchar) end as [FMAXTEHAISU]
      ,Case when  HITHNTP = 'F' then '' else   convert(varchar,Case when ITMRYO =0 then 1 else ITMRYO end) end as [FMARUMESU] -- 20190912 "or (HITHNTP = 'P' and substring(ITFILL, 16, 4) = '0242')" 
      ,'' as  [FHACHUTENSU]-- Case when  HITHNTP ='P' or HITHNTP ='M' then   Case when ITSFST =0 or ITSFST is null then '1' else Cast(ITSFST as varchar) end else '' end as [FHACHUTENSU] -- FB13 nếu là MRP thì mới có ITSFST 
      ,HITHNTP
	  ,'' as [FHACHUTENHACHUSU]
      ,Case when  HITHNTP = 'F'  then '' else '010' end as [FHARAIKOJUN] --FB28 không set nếu Ftehai =M  -- Basically, the parts are removed at the beginning of each process, so please enter a fixed values  or blanks. (Không đc set nếu là loauj F)
      ,CAST('2019/06/30' as nvarchar(50)) as [FZENKAITANAYMD]
      ,0 as [FSEIBANMATOMEFLG]
	  ,FLOOR(Cast(CAST(NEWID() AS VARBINARY) AS tinyint)/40+1) as rd
from openquery(as400_mputest,'Select COALESCE(PTP,ITHNTP) HITHNTP,PPART,MPIT00.*,MPIT30.*,MPIT80.*,MPIT90.* from MPIT00 left join MPIT30 on ITHNBN = CAST(CAST(I3HNBN as char(40) CCSID 65535) as char(40) CCSID 930) left join MPIT80 on ITHNBN = CAST(CAST(I8HNBN as char(40) CCSID 65535) as char(40) CCSID 930) left join MPIT90 on ITHNBN = CAST(CAST(I9HNBN as char(40) CCSID 65535) as char(40) CCSID 930) 
left join (SELECT T1.ITHNBN PPART,''M'' PTP FROM MPIT00 T1 INNER JOIN MPIT00 T2 ON T1.ITSHBN = T2.ITHNBN AND T2.ITHNTP = ''M'' AND T1.ITHNTP = ''P'') TT ON ITHNBN = PPART'))

Select  t2.[FCOMPANYCD],
trim(ISNULL(dbo.SMHINDUMMY.DummyPart, t2.[FHINCD])) AS FHINCD,
[FKYOTENCD],
Case when HITHNTP ='F' then '**********' else  t1.[FZCD] end FZCD,
Case when HITHNTP ='F' then '**********' else  t1.[FHOKANCD] end FHOKANCD,
Case when HITHNTP in ('M','F') then '' else case when   ([FKIHONSIRECD] ='' and HITHNTP ='P') or ([FKIHONSIRECD]!='' and SUBSTRING([FKIHONSIRECD],1,1)!='B')   then 'B00000' else  [FKIHONSIRECD] end  end as [FKIHONSIRECD], -- Tạm thời bỏ nhà cung cấp của loại F,M chờ RJ xác nhận
case when t4.TypeInspection is null then 0 else 1 end [FKENSAFLG] ,
ISNULL(t4.TypeInspection,'') [FKENSAKB],
isnull(t4.LeadTime,1) [FKENSALT],
trim(ISNULL(dbo.SMHINDUMMY.DummyPart, t2.[FHINCD])) as FKOJUNHINCD,
[FSEZOPTCD],
[FANZENZSU],
[FTEHAIKB],
case when Isnull(t3.LeadTime,[FTOKHINLT]) =0 then '1' else Isnull(t3.LeadTime,[FTOKHINLT]) end as [FTOKHINLT],
case when Isnull(t3.LeadTime,[FHINLT]) =0 then '1' else Isnull(t3.LeadTime,[FHINLT]) end  as [FHINLT],
[FDEFKOSEILT],
[FPICKINGLT],
[FMATOMEKK],
-- Nếu FTEHAIKB = N hoặc H FMINTEHAISU và FMAXTEHAISU không được set
Case when [FHACHUTENSU] !='' or FTEHAIKB = 'N' then '' else Convert(varchar, Case when  [FMARUMESU]!=''  then Case when (CONVERT(int,[FMINTEHAISU])%CONVERT(int,[FMARUMESU]))!=0 then Convert(varchar, CONVERT(int,[FMINTEHAISU]) - (CONVERT(int,[FMINTEHAISU])%CONVERT(int,[FMARUMESU]))) else [FMINTEHAISU] end else  [FMINTEHAISU] end) end AS [FMINTEHAISU],
Case when [FHACHUTENSU] !='' or FTEHAIKB = 'N' then '' else  Convert(varchar, Case when [FMAXTEHAISU]!='' and [FMARUMESU]!=''  then Convert(varchar, CONVERT(int,[FMAXTEHAISU]) - (CONVERT(int,[FMAXTEHAISU])%CONVERT(int,[FMARUMESU]))) else  [FMAXTEHAISU] end) end  AS [FMAXTEHAISU],
Case when [FHACHUTENSU] !='' or FTEHAIKB = 'N' then '' else   Convert(varchar,FMARUMESU) end as [FMARUMESU],
[FHACHUTENSU],
[FHACHUTENHACHUSU],
CASE WHEN T3.LeadTime IS NULL THEN '' ELSE '010' END AS [FHARAIKOJUN],
[FZENKAITANAYMD],
[FSEIBANMATOMEFLG]
 from t2 left join t1 on t2.rd = t1.rn	
LEFT OUTER JOIN scaw_db.dbo.SMHINDUMMY ON t2.[FHINCD]  = dbo.SMHINDUMMY.DSPartNo COLLATE DATABASE_DEFAULT 
left join InspectionLeadTime t4 on t2.FHINCD = t4.FHINCD collate database_default and HITHNTP ='P'
Left join 
( Select SUm(FKOJUNLT) as LeadTime,FKOJUNHINCD from SMKOJUN  group by FKOJUNHINCD )as T3 on t2.FHINCD = t3.FKOJUNHINCD collate database_default

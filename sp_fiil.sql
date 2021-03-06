USE [chatbot]
GO
/****** Object:  StoredProcedure [dbo].[sp_fiil]    Script Date: 04/16/2018 20:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[sp_fiil] (
@fiil varchar(50)='yayıl', @kip  varchar(50)='emir', @zaman varchar(50)='basit zaman', @sahis varchar(50)='onlar'  )
--@fiil varchar(50)='random', @kip  varchar(50)='random', @zaman varchar(50)='random', @sahis varchar(50)='random'  )
as 

--siz bak|ır||
 
-- [sp_fiil] 'random','şimdiki zaman','basit zaman','random' 
 
declare @kural1 varchar(150)='';
declare @kural2 varchar(150)='';
declare @kural3 varchar(150)='';

declare @mastar varchar(50)='';
 
  if @fiil='random'   
begin 
SELECT  TOP 1 @fiil=fiil ,@mastar=mastar
FROM tbl_fiil  
 where 1=1
  --and fiil like '%o%'
  --and LEN(fiil) =3
--and  right(fiil,2 ) ='et'
--and  left(right(fiil,1),1) ='t'-- in ('ç','f','t','h','s','k','p','ş') 
 --and  left(right(fiil,1),1) not in ('i','e','ı','i','a','u','ü','o','ö') 
 ORDER BY NEWID()  ;
end 
else
begin 
SELECT  TOP 1 @fiil=fiil ,@mastar=mastar
FROM tbl_fiil  
 where 1=1
 and fiil=@fiil
--and  right(fiil,2 ) ='et'
--and  left(right(fiil,1),1) ='t'-- in ('ç','f','t','h','s','k','p','ş') 
 --and  left(right(fiil,1),1) not in ('i','e','ı','i','a','u','ü','o','ö') 
 ORDER BY NEWID()  ;
end 


 if @kip='random'   
begin 
SELECT    TOP 1  @kip=kip
 FROM  CHATBOT.DBO.tbl_fiil_kip  
   ORDER BY NEWID() ;-- Invalid use of a side-effecting operator 'newid' within a function.
end 
else
begin 
SELECT    TOP 1 @kip=kip
 FROM CHATBOT.DBO.tbl_fiil_kip  
 where kip =@kip
 ORDER BY NEWID() ; -- Invalid use of a side-effecting operator 'newid' within a function.
  end
  
   

 set @kural1 = case when @kip in('görülmüş geçmiş zaman','emir') then 'rivayet' else ' ' end;
 set @kural2 = case when @kip in('dilek şart','emir','gereklilik','istek') then 'şart' else ' ' end;
 set @kural3= case when @kip in('emir') then 'hikaye' else ' ' end;
 
  

 if @zaman='random'   
begin 
SELECT   TOP 1 @zaman=zaman 
FROM tbl_fiil_zaman 
 where zaman not in(@kural1,@kural2,@kural3) 
 
 ORDER BY NEWID()  ;
end 
else
begin 
SELECT   TOP 1 @zaman=zaman 
FROM tbl_fiil_zaman 
 where zaman not in(@kural1,@kural2,@kural3) 
--and zaman  = 'rivayet'
and zaman  = @zaman
 ORDER BY NEWID()  ;
   end
   
   
 if @sahis='random'   
begin    
 
SELECT  TOP 1  @sahis=sahis
 FROM tbl_fiil_sahis
where case when @kip in('emir') and  sahis in ('ben','biz') then 1 else 0 end =0
   ORDER BY NEWID()  ;
end 
else
begin 
 SELECT  TOP 1  @sahis=sahis
 FROM tbl_fiil_sahis
where case when @kip in('emir') and  sahis in ('ben','biz') then 1 else 0 end =0
  and sahis = @sahis
  ORDER BY NEWID()  ;
end 

print '@zaman='''+@zaman+'''';
  
    print '@sahis='''+@sahis+'''';
  
  --sp_fiil
exec sp_fiil_cekim @sahis,@fiil,@kip,@zaman  

 --  print @sahis+' '+@fiil +'|'+@kip   +'|'+@zaman  

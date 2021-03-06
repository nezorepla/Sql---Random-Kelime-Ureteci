USE [chatbot]
GO
/****** Object:  UserDefinedFunction [dbo].[fx_fiil_kipler]    Script Date: 04/16/2018 22:47:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  FUNCTION [dbo].[fx_fiil_kipler]
(
  @fiil varchar(50) ,
  @kip varchar(50) ,
  @SonSesli varchar(1),
	@SonHarf varchar(1),
	@SessizIleBitiyorFlg bit,
	@SertSessizIleBitiyorFlg bit,
	@DuzGenisSesliHarf varchar(1),
	@DarSesliHarf varchar(1)
)
RETURNS 
  @Table_Var  TABLE
( 
--	fiil varchar(50) ,
	kip varchar(50) ,
	kip_eki varchar(10) 
) --  with schemabinding
AS
BEGIN
 

declare @kip_eki varchar(10)='';
  
  -- select * from dbo.tbl_fiil_kip
  if  @kip='geniş zaman' 
  begin 
set @DarSesliHarf =case when  LEN(@fiil)=3 /*  @SonSesli  ='e' */ then @DuzGenisSesliHarf  
 else @DarSesliHarf end

 end
 /*  select * from  [fx_fiil_detay]('ayır')
*/

  
 
 
 set @kip_eki=case 
 when @kip= 'görülmüş geçmiş zaman' then 'd'+@DarSesliHarf
 when @kip= 'öğrenilmiş geçmiş zaman' then 'm'+@DarSesliHarf+'ş'
 when @kip= 'şimdiki zaman' and @SessizIleBitiyorFlg= 1 then @DarSesliHarf+'yor'
 when @kip= 'şimdiki zaman' and @SessizIleBitiyorFlg= 0 then 'yor'
  when @kip='gelecek zaman' and @SessizIleBitiyorFlg= 1  then @DuzGenisSesliHarf+'c'+@DuzGenisSesliHarf+'k'
  when @kip='gelecek zaman' and @SessizIleBitiyorFlg= 0  then 'y'+@DuzGenisSesliHarf+'c'+@DuzGenisSesliHarf+'k'
  when @kip='geniş zaman' and @SessizIleBitiyorFlg= 1 then /*@DarSesliHarf*/ @DarSesliHarf+'r'
  when @kip='geniş zaman' and @SessizIleBitiyorFlg= 0 then 'r'
  when @kip='gereklilik' then 'm'+@DuzGenisSesliHarf+'l'+case
   when @DuzGenisSesliHarf ='a' then 'ı' 
   when @DuzGenisSesliHarf ='e' then 'i' 
   else @DarSesliHarf end
  when @kip='dilek şart' then 's'+@DuzGenisSesliHarf
 when @kip='istek' and @SessizIleBitiyorFlg= 0 then 'y'+@DuzGenisSesliHarf
 when @kip='istek' and @SessizIleBitiyorFlg= 1 then @DuzGenisSesliHarf
 else ''
end
 
 insert into @Table_Var values (@kip,@kip_eki)	
	RETURN  
 end 
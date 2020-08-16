GO
ALTER PROCEDURE [dbo].[Ksp_Relatorio_Prescricao_Completa_ITEM_APRAZAMENTO]
@PRESC_CODIGO CHAR (12)=NULL, @ATENDAMB_CODIGO CHAR (12)=NULL, @Data CHAR (19)=NULL
AS
SET NOCOUNT ON   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	IF CURSOR_STATUS('global','cursor_obs')>=-1
BEGIN
close cursor_obs
 DEALLOCATE cursor_obs
END

  CREATE TABLE #tListaMedicamentos
	(		
		data_iniciar_em datetime,
		FrequenciaFormatada int,
		item_prescricao_id uniqueidentifier
	)

	CREATE TABLE #tListaMedicamentosAprazados
	(
		data_iniciar_em datetime,
		FrequenciaFormatada int,
		item_prescricao_id uniqueidentifier
	)

IF(@PRESC_CODIGO IS NOT NULL)            
 BEGIN
       insert into  #tListaMedicamentos    
	SELECT
	  itpm.data_iniciar_em,
	 ITPM.itpresc_frequencia,
	  itpm.item_prescricao_id
      from PRESCRICAO p                 
     join ITEM_PRESCRICAO itpr on p.presc_codigo = itpr.presc_codigo                  
     left join Item_Prescricao_Medicamento itpm on itpr.itpresc_codigo = itpm.itpresc_codigo and itpr.presc_codigo = itpm.presc_codigo                  
     left join Item_Prescricao_Sinais_Vitais itps on(itps.presc_codigo = Isnull(@presc_codigo, itps.presc_codigo) and itpr.itpresc_codigo = itps.itpresc_codigo and itpr.presc_codigo = itps.presc_codigo)                                    
     left join Item_Prescricao_Cuidados_Especiais itce on(itce.presc_codigo = Isnull(@presc_codigo, itce.presc_codigo) and itpr.itpresc_codigo = itce.itpresc_codigo and itpr.presc_codigo = itce.presc_codigo)                                  
     left join Item_Prescricao_Dieta itd on(itd.presc_codigo = Isnull(@presc_codigo, itd.presc_codigo) and itpr.itpresc_codigo = itd.itpresc_codigo and itpr.presc_codigo = itd.presc_codigo)                                    
     left join Cuidados_Especiais ce on (itce.cues_codigo = ce.cues_codigo)                                    
     left join Item_Prescricao_Oxigenoterapia itpo on (itpo.presc_codigo = Isnull(@presc_codigo, itpo.presc_codigo) and itpr.itpresc_codigo = itpo.itpresc_codigo and itpr.presc_codigo = itpo.presc_codigo)                                    
     left join Oxigenoterapia ox on (itpo.oxi_codigo = ox.oxi_codigo)  
	 left join item_prescricao_procedimento ipp on (ipp.presc_codigo = Isnull(@presc_codigo, ipp.presc_codigo) and itpr.itpresc_codigo = ipp.itpresc_codigo and itpr.presc_codigo = ipp.presc_codigo)                                       
	 left join tb_procedimento tbp on (ipp.co_procedimento = tbp.co_procedimento)                                  
     join unidade u on u.unid_codigo = p.unid_codigo                  
     join paciente pa on p.pac_codigo = pa.pac_codigo                  
     left join vwlocal_unidade v on p.locatend_codigo = v.locatend_codigo                  
     left join profissional_rede pr on p.prof_codigo = pr.prof_codigo      
     left join profissional_lotacao pl ON p.prof_codigo = pl.prof_codigo and p.locatend_codigo = pl.locatend_codigo    
     left join internacao_pep ip on ip.inter_codigo = p.inter_codigo
     left join atendimento ate on ate.atend_codigo = p.atend_codigo

   where p.presc_codigo = @presc_codigo   
     --and itpm.item_prescricao_id = isnull(@item_prescricao_id, itpm.item_prescricao_id )

	 
END            
ELSE            
 BEGIN                               
	insert into  #tListaMedicamentos        
	SELECT itpm.data_iniciar_em,
	 ITPM.itpresc_frequencia,
	 itpm.item_prescricao_id 
   from PRESCRICAO p                 
     join ITEM_PRESCRICAO itpr on p.presc_codigo = itpr.presc_codigo                  
     left join Item_Prescricao_Medicamento itpm on itpr.itpresc_codigo = itpm.itpresc_codigo and itpr.presc_codigo = itpm.presc_codigo                  
     left join Item_Prescricao_Sinais_Vitais itps on(itps.presc_codigo = Isnull(p.presc_codigo , itps.presc_codigo) and itpr.itpresc_codigo = itps.itpresc_codigo and itpr.presc_codigo = itps.presc_codigo)                                    
     left join Item_Prescricao_Cuidados_Especiais itce on(itce.presc_codigo = Isnull(p.presc_codigo , itce.presc_codigo) and itpr.itpresc_codigo = itce.itpresc_codigo and itpr.presc_codigo = itce.presc_codigo)                                  
     left join Item_Prescricao_Dieta itd on(itd.presc_codigo = Isnull(p.presc_codigo , itd.presc_codigo) and itpr.itpresc_codigo = itd.itpresc_codigo and itpr.presc_codigo = itd.presc_codigo)                                    
     left join Cuidados_Especiais ce on (itce.cues_codigo = ce.cues_codigo)                                    
     left join Item_Prescricao_Oxigenoterapia itpo on (itpo.presc_codigo = Isnull(p.presc_codigo , itpo.presc_codigo) and itpr.itpresc_codigo = itpo.itpresc_codigo and itpr.presc_codigo = itpo.presc_codigo)                                    
     left join Oxigenoterapia ox on (ox.oxi_codigo = itpo.oxi_codigo)  
	 left join item_prescricao_procedimento ipp on (ipp.presc_codigo = Isnull(p.presc_codigo , ipp.presc_codigo) and itpr.itpresc_codigo = ipp.itpresc_codigo and itpr.presc_codigo = ipp.presc_codigo)                                       
	 left join tb_procedimento tbp on (ipp.co_procedimento = tbp.co_procedimento)                                  
     join unidade u on u.unid_codigo = p.unid_codigo                  
     join paciente pa on p.pac_codigo = pa.pac_codigo                  
     left join vwlocal_unidade v on p.locatend_codigo = v.locatend_codigo                  
     left join profissional_rede pr on p.prof_codigo = pr.prof_codigo      
     left join profissional_lotacao pl ON p.prof_codigo = pl.prof_codigo and p.locatend_codigo = pl.locatend_codigo    
     left join internacao_pep ip on ip.inter_codigo = p.inter_codigo
     left join atendimento ate on ate.atend_codigo = p.atend_codigo
                          
   where (P.ATENDAMB_CODIGO = @ATENDAMB_CODIGO OR P.INTER_CODIGO = @ATENDAMB_CODIGO) 
 END        

 declare @dt datetime
 declare @ff int
 declare @ip uniqueidentifier

DECLARE cursor_obs CURSOR FOR  
  SELECT data_iniciar_em, FrequenciaFormatada, item_prescricao_id  FROM #tListaMedicamentos
OPEN cursor_obs
                      
FETCH NEXT FROM cursor_obs                       
INTO @dt, @ff, @ip
  
WHILE @@FETCH_STATUS = 0                      
BEGIN  

	IF (@ff > 0)
	BEGIN
  		insert into #tListaMedicamentosAprazados
			select data_formatada, @FF, Item_Prescricao_id from DBO.FCN_INTERVALO_DATA_APRAZAMENTO(@dt, @ff, @ip)
	END
	ELSE
	BEGIN
		IF (@ff = -60)
		BEGIN
			insert into #tListaMedicamentosAprazados VALUES (null, @FF, @ip)
		END
		ELSE IF (@ff = -120)
		BEGIN
			insert into #tListaMedicamentosAprazados VALUES (null, @FF, @ip)
		END
		ELSE IF (@ff = 0)
		BEGIN
			insert into #tListaMedicamentosAprazados VALUES (@dt, @FF, @ip)
		END
	END

 FETCH NEXT FROM cursor_obs                       
 INTO @dt, @ff, @ip 
END  
  
CLOSE cursor_obs    

   SELECT data_iniciar_em as data_iniciar_em, FrequenciaFormatada as itpresc_frequencia, item_prescricao_id  FROM #tListaMedicamentosAprazados
   
   DROP TABLE #tListaMedicamentos
   DROP TABLE #tListaMedicamentosAprazados          

SET NOCOUNT OFF
GO
CREATE FUNCTION FCN_INTERVALO_DATA (@DATA DATETIME,@INTERVALO INT)     
RETURNS @resultado1 table(DATA_FORMATADA datetime)    
as    
begin    
 declare @datameianoite datetime    
 set @datameianoite = dateadd(day, 1, @data)    
    WHILE (@data)<@datameianoite    
 BEGIN    
    INSERT INTO  @resultado1    
  SELECT @DATA --CONVERT(VARCHAR(50),@DATA,103) + ' ' + CONVERT(VARCHAR(5),@DATA,108)    
    
  SET @DATA=  DATEADD(HOUR, (@INTERVALO/60), @DATA)    
      
    
 END    
    
    RETURN        
end
GO
CREATE FUNCTION FCN_INTERVALO_DATA_APRAZAMENTO (@DATA DATETIME,@INTERVALO INT, @item_prescricao_id uniqueidentifier)     
RETURNS @resultado1 table(DATA_FORMATADA datetime, item_prescricao_id uniqueidentifier)    
as    
begin    
 declare @datameianoite datetime    
 set @datameianoite = dateadd(day, 1, @data)    
    WHILE (@data)<@datameianoite    
 BEGIN    
    INSERT INTO  @resultado1    
  SELECT @DATA, @item_prescricao_id  --CONVERT(VARCHAR(50),@DATA,103) + ' ' + CONVERT(VARCHAR(5),@DATA,108)    
    
  SET @DATA=  DATEADD(HOUR, (@INTERVALO/60), @DATA)    
      
    
 END    
    
    RETURN        
end
GO
ALTER PROCEDURE [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_Noturno] @inter_codigo char(12) = null, @evouti_codigo int = null
as
begin
select	convert(varchar(10), eun.DataInclusao, 103) as data,
		convert(varchar(5), eun.DataInclusao, 114) as hora,
		i.inter_codigo as internacao,
		p.pac_nome as nome,
		p.pac_idade	as idade,
		l.locint_descricao as leito,
		i.inter_datainter as dtinternacao,
		eun.Diurese as Diurese,
		eun.TAxMax as TAxMax,
		eun.Hgt as Hgt,
		eun.Hd as Hd,
		eun.Insulina as Insulina,
		eun.FuncaoIntestinal as FuncaoIntestinal,
		eun.Bh as Bh,
		eun.Intercorrencia as Intercorrencia,
		eun.Conduta as Conduta,
		isnull(eun.rascunho,0) as Rascunho,
		prof.prof_nome
from EvolucaoUtiNoturna eun
inner join internacao i on eun.inter_codigo = i.inter_codigo
inner join VWLEITO_COMPLETO l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
inner join paciente p on p.pac_codigo = i.pac_codigo 
inner join Profissional prof on prof.prof_codigo = eun.prof_codigo and prof.locatend_codigo = eun.locatend_codigo
where eun.evouti_codigo = isnull(@evouti_codigo, eun.evouti_codigo)
and   eun.inter_codigo = isnull(@inter_codigo, eun.inter_codigo)

end
GO
CREATE PROCEDURE [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA] @inter_codigo char(12) = null, @evouti_codigo int = null
as
begin
select	convert(varchar(10), eud.DataInclusao, 103) as data,
		convert(varchar(5), DataInclusao, 114) as hora,
		i.inter_codigo as internacao,
		p.pac_nome as nome,
		p.pac_idade	as idade,
		l.locint_descricao as leito,
		i.inter_datainter as dtinternacao,
		eud.Diagnosticos as Diagnosticos,
		eud.ExamesComplementares as examescomplementares,
		eud.Acessos as acessos,
		eud.Drenos as drenos,
		eud.Dripping as dripping,
		eud.Antibioticos as antibioticos,
		eud.Pas as pas,
		eud.Pad as pad,
		eud.Pam as pam,
		eud.Fc as fc,
		eud.Pic as pic,
		eud.Tax as tax,
		eud.Spo2 as spo2,
		eud.Hgt as hgt,
		eud.Insul as insulina,
		eud.Fr as fr,
		eud.Entradas as entradas,
		eud.saidas as saidas,
		eud.diurese1 as diurese1,
		eud.diurese2 as diurese2,
		eud.hemodialise as hemodialise,
		eud.rg as rg,
		eud.FuncaoIntestinal as funcaoinstestinal,
		eud.outros as outros,
		eud.total as total,
		eud.Modalidade as modalidade,
		eud.PesoPredito as pesopredito,
		eud.PInspPSup as pinsppsup,
		eud.Peep as peep,
		eud.Vc as vc,
		eud.Fio2 as fio2,
		eud.Fr as fr,
		eud.TInsp as tinsp,
		eud.ExameFisico as examefisico,
		eud.Condutas as condutas,
		isnull(eud.Rascunho,0) as Rascunho,
		prof.prof_nome
from EvolucaoUtiDiurna eud
inner join internacao i on eud.inter_codigo = i.inter_codigo
inner join VWLEITO_COMPLETO l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
inner join paciente p on p.pac_codigo = i.pac_codigo 
inner join Profissional prof on prof.prof_codigo = eud.prof_codigo and prof.locatend_codigo = eud.locatend_codigo
where eud.evouti_codigo = isnull(@evouti_codigo, eud.evouti_codigo)
and   eud.inter_codigo = isnull(@inter_codigo, eud.inter_codigo)

end
GO
DECLARE @versao varchar(30)
SET @versao = 'K.2020.06.10.2'

INSERT INTO [dbo].[DATABASE_VERSION_CONTROL]
           ([Id]
           ,[Versao]
           ,[DataAtualizacao]
           ,[Usuario])
     VALUES
           (NEWID()
           ,@versao
           ,GETDATE()
           ,'anderson.souza')

GO
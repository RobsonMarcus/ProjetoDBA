GO
ALTER PROCEDURE [dbo].[Ksp_Relatorio_Prescricao_Completa_ITEM_APRAZAMENTO]
@PRESC_CODIGO CHAR (12)=NULL, @ATENDAMB_CODIGO CHAR (12)=NULL, @Data CHAR (19)=NULL, @item_prescricao_id uniqueidentifier =null
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
ALTER PROCEDURE [dbo].[Ksp_Relatorio_Prescricao_Completa]
@PRESC_CODIGO CHAR (12)=NULL, @ATENDAMB_CODIGO CHAR (12)=NULL, @Data CHAR (19)=NULL, @item_prescricao_id uniqueidentifier =null
AS
SET NOCOUNT ON                      
 
CREATE TABLE #TEMP (              
   seq  int identity(1,1),                
   unid_descricao varchar(50),
   unid_codigo char(4),
   set_descricao varchar(30),                  
   prof_nome varchar(50),                  
   pac_codigo char(12),                  
   pac_nome varchar(50),                  
   pac_prontuario_numero char(10),                  
   locint_descricao varchar(8000),                  
   pac_idade int,                  
   presc_observacao varchar(4000),                  
   presc_codigo char(12),                  
   itpresc_codigo int,                  
   itpresc_quantidade varchar(100),                  
   itpresc_total varchar(100),                  
   itpresc_obs varchar(2000),                  
   TipoItemPrescricao char(1),                  
   Agrupamento char(1),                  
   Intervalo int,                  
   Item varchar(2000),                  
   Detalhe varchar(2000),                  
   cues_codigo int,                  
   oxi_codigo int,                  
   UnidadeTempo char(1),                  
   presc_data smalldatetime,                   
   DataHoraAprazamento smalldatetime,                  
   GeraPedidoPaciente char(1),                  
   cabecalho_report1 varchar(100),                  
   cabecalho_report2 varchar(100),                  
   cabecalho_report3 varchar(100),                  
   pac_nascimento datetime,                  
   pac_sexo varchar(15),                  
   Prof_registro_conselho varchar(20),   
   orgao_emissor_conselho varchar(20),   
   num_atendimento char(12),                  
   Ordem_Discriminacao char(1),                  
   cor_risco varchar(50),                  
   horarios_aprazamento varchar(2000),                  
   observacoes_enfermagem varchar(8000),                  
   atendamb_codigo char(12),    
   itpresc_codigo_issoluvel char(1),    
   item_prescricao_id_solucao uniqueidentifier,
   atendamb_peso numeric(9,1),     
   UnidadeMedida varchar(50)  ,
   inter_codigo varchar(12),
   atend_codigo varchar(12),
   pac_mae varchar(50),
   MedicamentoSuspenso varchar(100),
   DescricaoResumida varchar(1000),
   InformacoesComplementares varchar(8000),
   OrdenacaoTipoItem varchar(100),
   FrequenciaFormatada varchar(100),
   inter_datainter smalldatetime,
   alergias varchar(1000),
   item_prescricao_id uniqueidentifier
)   

CREATE TABLE #PRESCRICAO   
(  
	presc_codigo char(12),  
	locatend_codigo char(4),  
	prof_codigo char(4),  
	spa_codigo char(12),  
	emer_codigo char(12),  
	inter_codigo char(12),  
	atendamb_codigo char(12),  
	presc_observacao varchar(4000),  
	presc_data smalldatetime,  
	pac_codigo char(12),  
	unid_codigo char(4)  ,
	atend_codigo varchar(12)
)  
CREATE TABLE #ITEM_PRESCRICAO   
(  
	presc_codigo char(12),  
	itpresc_codigo int,  
	itpresc_obs varchar(2000)  
)  

CREATE TABLE #INTERNACAO_APRAZAMENTO  
(  
	inter_codigo char(12),  
	spa_codigo char(12),  
	emer_codigo char(12),  
	dose_data smalldatetime,  
	locint_descricao varchar(200),
	inter_datainter smalldatetime
)  
CREATE TABLE #RISCO
(
	risaco_descricao varchar(50)	
)

DECLARE @SPA_CODIGO CHAR(12)   
DECLARE @EMER_CODIGO CHAR(12)  
DECLARE @INTER_CODIGO CHAR(12)  
DECLARE @PAC_PRONTUARIO_NUMERO CHAR(10)  
DECLARE @PAC_CODIGO CHAR(12)  
DECLARE @INTERNACAO_PEP CHAR(12)  
DECLARE @ATEND_CODIGO CHAR(12)  
DECLARE @DataInicio smalldatetime
DECLARE @DataFim smalldatetime	

DECLARE @peso numeric(9,1)
 SET  @peso = 0

set @DataInicio = CONVERT(SMALLDATETIME, @Data, 103) - 1
set @DataFim = CONVERT(SMALLDATETIME, @Data, 103)+ 1

IF(@PRESC_CODIGO IS NOT NULL)            
 BEGIN
   
	SELECT  @peso = A.atendamb_peso FROM atendimento_clinico A
	inner join prescricao P on A.atendamb_codigo = P.atendamb_codigo
	where P.presc_codigo = @presc_codigo	
   
	INSERT INTO #PRESCRICAO  
	SELECT presc_codigo, locatend_codigo , prof_codigo, SPA_CODIGO,EMER_CODIGO,INTER_CODIGO, ATENDAMB_CODIGO, PRESC_OBSERVACAO,PRESC_DATA, PAC_CODIGO, unid_codigo, atend_codigo  
	FROM PRESCRICAO   
	WHERE PRESC_CODIGO = @PRESC_CODIGO  

	INSERT INTO #ITEM_PRESCRICAO  
	SELECT presc_codigo,itpresc_codigo,itpresc_obs  
	FROM ITEM_PRESCRICAO   
	WHERE PRESC_CODIGO = @PRESC_CODIGO  
  
	SELECT @SPA_CODIGO = SPA_CODIGO, @EMER_CODIGO = EMER_CODIGO, @INTER_CODIGO = INTER_CODIGO, @ATEND_CODIGO = atend_codigo FROM #PRESCRICAO 
  
	/*INTERNACAO APRAZAMENTO E INTERNACAO_PEP*/
	IF (@INTER_CODIGO IS NOT NULL)  
	BEGIN  
		INSERT INTO #INTERNACAO_APRAZAMENTO  
		SELECT DISTINCT I.INTER_CODIGO, I.SPA_CODIGO, I.EMER_CODIGO, IA.DOSE_DATA, VWLEITO.LOCINT_DESCRICAO, i.inter_datainter 
		FROM #PRESCRICAO P  
		JOIN #ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO  
		JOIN INTERNACAO I ON P.INTER_CODIGO = I.INTER_CODIGO  
		JOIN VWLEITO ON I.LOCATEND_LEITO = VWLEITO.LOCATEND_CODIGO AND I.LEI_CODIGO = VWLEITO.LEI_CODIGO                  
		LEFT JOIN ITEM_APRAZAMENTO IA ON IA.PRESC_CODIGO = IP.PRESC_CODIGO AND IA.ITPRESC_CODIGO = IP.ITPRESC_CODIGO                  
		WHERE I.INTER_CODIGO = @INTER_CODIGO  
		
		SELECT  @internacao_pep = inter_codigo FROM internacao_pep where inter_codigo = @INTER_CODIGO
		
		IF @internacao_pep IS NOT NULL
		BEGIN
			select @peso = peso from internacao_pep where inter_codigo = @inter_codigo;
		END
	END  
  
	/*RISCO*/  
	IF (@SPA_CODIGO IS NOT NULL OR ( @INTER_CODIGO IS NOT NULL AND @SPA_CODIGO IS NOT NULL ))  
	BEGIN   
		INSERT INTO #RISCO   
		SELECT RISACO_DESCRICAO  
		FROM UPA_ACOLHIMENTO UA   
		INNER JOIN UPA_CLASSIFICACAO_RISCO UCR ON UA.ACO_CODIGO = UCR.ACO_CODIGO  
		INNER JOIN RISCO_ACOLHIMENTO RA ON UCR.RISACO_CODIGO = RA.RISACO_CODIGO  
		WHERE UA.SPA_CODIGO = @SPA_CODIGO  
	END  
  
	IF (@EMER_CODIGO IS NOT NULL OR ( @INTER_CODIGO IS NOT NULL AND @EMER_CODIGO IS NOT NULL ))  
	BEGIN  
		INSERT INTO #RISCO   
		SELECT RISACO_DESCRICAO  
		FROM UPA_ACOLHIMENTO UA   
		INNER JOIN UPA_CLASSIFICACAO_RISCO UCR ON UA.ACO_CODIGO = UCR.ACO_CODIGO  
		INNER JOIN RISCO_ACOLHIMENTO RA ON UCR.RISACO_CODIGO = RA.RISACO_CODIGO  
		WHERE UA.EMER_CODIGO = @EMER_CODIGO  
	END  
   
	SELECT @PAC_CODIGO = PAC_CODIGO FROM #PRESCRICAO  
   
	SELECT @PAC_PRONTUARIO_NUMERO = PAC_PRONTUARIO_NUMERO FROM PACIENTE_PRONTUARIO WHERE PAC_CODIGO = @PAC_CODIGO  
                   
	INSERT INTO #TEMP                  
                     
	SELECT u.unid_descricao, u.unid_codigo, v.set_descricao, pr.prof_nome, pa.pac_codigo, pa.pac_nome, @PAC_PRONTUARIO_NUMERO AS pac_prontuario_numero, 
	ia.locint_descricao,
	case when pa.pac_nascimento is not null then (cast(DateDiff(dd, pa.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pa.pac_nascimento, getdate()) as int) / 4)) / 365                  
	when pa.pac_nascimento is null and p.spa_codigo is not null then (select spa_idade from pronto_atendimento where spa_codigo = p.spa_codigo)                  
	when pa.pac_nascimento is null and p.emer_codigo is not null then (select emer_idade from emergencia where emer_codigo = p.emer_codigo)                                
	end as pac_idade,
	p.presc_observacao, itpr.presc_codigo, itpr.itpresc_codigo,                  
                     
    replace( (convert(varchar,itpm.itpresc_quantidade) + ' ' + RTRIM(itpm.ins_unidade)), '.00', '' ) as itpresc_quantidade  
    ,(convert(varchar,itpm.itpresc_total) + ' ' + RTRIM(itpm.ins_unidade)) as itpresc_total, 
    itpr.itpresc_obs,                                    
                     
    case when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia <> 0 then 'M' -- Medicamento                  
       when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia = 0 then 'M' -- Medicamento       
       when itps.presc_codigo = @presc_codigo then 'S' -- Sinais Vitais                                    
       when itce.presc_codigo = @presc_codigo then 'C' -- Cuidados Especiais                                    
       when itd.presc_codigo  = @presc_codigo then 'D' -- Dieta                                    
       when itpo.presc_codigo = @presc_codigo then 'O' -- Oxigenoterapia         
	   when ipp.presc_codigo IS NOT NULL then 'P' -- Procedimento     
    end as TipoItemPrescricao,                            
                     
    case when itpm.presc_codigo = @presc_codigo then '1'  
       when itps.presc_codigo = @presc_codigo then '0'  
       when itce.presc_codigo = @presc_codigo then '0'  
       when itd.presc_codigo  = @presc_codigo then '0'  
       when itpo.presc_codigo = @presc_codigo then '0'  
    end as Agrupamento,                        
                     
    case when itpm.presc_codigo = @presc_codigo then                           
    case when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'M' then itpm.itpresc_duracao                           
      when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'H' then itpm.itpresc_duracao * 60                          
      when itpm.itpresc_frequencia <> 0 then itpm.itpresc_frequencia / 60 end  
      when itps.presc_codigo = @presc_codigo then itps.ipsv_intervalo  
      when itce.presc_codigo = @presc_codigo then itce.ipce_intervalo  
      when itpo.presc_codigo = @presc_codigo then itpo.ipox_intervalo  
    end as Intervalo,                                                  
                     
    case when itpm.presc_codigo = @presc_codigo then (  
		itpm.ins_descricao + ' - Dose: ' +   
	CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
        WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
        ELSE convert(varchar(10),itpresc_quantidade)   
        END  
	  + ' ' + ins_unidade + ' Via: ' + Viamed_Descricao + ' Intervalo: ' +   
	  case itpresc_frequencia  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h'  
	  end  
	  )  
        
        when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto) + ' - Intervalo: ' +  case itps.ipsv_intervalo  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end                                       
       when itce.presc_codigo = @presc_codigo then (ce.cues_descricao) + ' - Intervalo: ' +  case itce.ipce_intervalo  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end                                                   
       when itd.presc_codigo = @presc_codigo then (itd.ipdi_texto)                                    
       when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao) + ' - Intervalo: ' +  case isnull(itpo.ipox_intervalo, 0)  
		when 0 then 'Contínuo'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end +
		case ox.oxi_tipo 
		when 0 then ' - Unidade: '+ convert(varchar,isnull(itpo.ipox_unidade, 'Não Informado')) + '% FiO2' 
		when 1 then ' - Unidade: '+ convert(varchar,isnull(itpo.ipox_unidade, 'Não Informado')) + ' L/min' end +
		case when itpo.ipox_duracao is not null then   
		' - Durante: ' + convert(varchar,isnull(itpo.ipox_duracao,'')) + ' ' +
		 case when itpo.ipox_tpduracao = 'H' then 'Hora(s)' else 'Minuto(s)' end else '' end  
	   when ipp.presc_codigo = @presc_codigo then tbp.co_procedimento + ' - ' + tbp.no_procedimento             
    end 
	+
	case itpm.itpresc_caracteristica 
		when 1 then ' - SOS'
		when 2 then ' - A critério do médico' 
		else ''
	end 
	as Item,                  
                     
    '' as Detalhe,                                    
                     
     itce.cues_codigo as Codigo,                   
     itpo.oxi_codigo as Codigo,                   
     itpo.ipox_unidade_tempo as UnidadeTempo,                   
     p.presc_data,                   
     ia.dose_data as DataHoraAprazamento,                  
     itpm.GeraPedidoPaciente,                  
     NULL AS cabecalho_report1,       
     NULL AS cabecalho_report2,                  
     NULL AS cabecalho_report3,             
     pa.pac_nascimento,                  
                     
     case when pa.pac_sexo = 'F' then 'Feminino'                 
       when pa.pac_sexo = 'M' then 'Masculino'                  
     end as pac_sexo,                  
     pl.Prof_registro_conselho,   
     (select oec.orgem_descricao from Orgao_Emissor_Conselho oec join Tipo_Profissional tp on oec.orgem_codigo = tp.orgem_codigo  
      where tp.tipprof_codigo = pl.tipprof_codigo) as orgao_emissor_conselho,  
       
     isnull( isnull(p.spa_codigo, iA.spa_codigo) , isnull(p.emer_codigo, iA.emer_codigo) ) as num_atendimento,                  
  
     case when itd.presc_codigo  = @presc_codigo then '0'                  
       when itpm.presc_codigo = @presc_codigo then '1'                  
       when itps.presc_codigo = @presc_codigo then '2'                  
       when itce.presc_codigo = @presc_codigo then '3'                  
       when itpo.presc_codigo = @presc_codigo then '4'         
	   when ipp.presc_codigo = @presc_codigo then '5'
     end as Ordem_Discriminacao,                  
                     
     (SELECT RISACO_DESCRICAO FROM #RISCO) AS cor_risco,  
      NULL as horarios_aprazamento,                  
      NULL as observacoes_enfermagem,                  
      p.atendamb_codigo,    
      itpm.itpresc_codigo_issoluvel,    
      itpm.item_prescricao_id_solucao,
      @peso,
      '',
      ip.inter_codigo,
      ate.atend_codigo,
	  pa.pac_mae,

	  case when itpm.presc_codigo = @presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpm.item_prescricao_id) > 0 then 'MEDICAMENTO SUSPENSO' 
		   when itps.presc_codigo = @presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itps.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itce.presc_codigo = @presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itce.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itd.presc_codigo = @presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itd.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itpo.presc_codigo = @presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpo.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
	  ELSE NULL END AS MedicamentoSuspenso,
	  
	  case when itpm.presc_codigo = @presc_codigo then itpm.ins_descricao_resumida
			when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)
			when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)
			when itd.presc_codigo = @presc_codigo then (itd.ipdi_texto)   
			when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)
		end + 
			case when LEN(ITPM.itpresc_quantidade) > 0 then (  
		' - Dose: ' +   
				CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
				WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
				ELSE convert(varchar(10),itpresc_quantidade)   
			END  
		+ ' ' + ins_unidade + '(s) ') ELSE ' ' END + 
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao_resumida) > 0 THEN ' + ' + ITPM.diluente_ins_descricao_resumida
			    WHEN LEN(ITPM.diluente_ins_descricao) > 0 THEN ' + ' + ITPM.diluente_ins_descricao ELSE ' ' END +
		case when LEN(itpm.diluente_volume) > 0 THEN ' - Volume do Diluente: ' + CONVERT(VARCHAR(10), itpm.diluente_volume) + ' ml ' ELSE '' END 
		AS DescricaoResumida,

		
		case when LEN(itpm.viamed_descricao) > 0 THEN itpm.viamed_descricao ELSE '' END +
		case when LEN(itpm.diluente_volume_total) > 0 THEN ' - Volume Total: ' + CONVERT(VARCHAR(10), itpm.diluente_volume_total) + ' ml' ELSE '' END + 
		case when LEN(itpm.diluente_valor_velocidade) > 0 THEN ' - Velocidade: ' + CONVERT(VARCHAR(10), itpm.diluente_valor_velocidade) + ' ' + itpm.diluente_medida_velocidade ELSE '' END +
		case itpm.itpresc_caracteristica 
				when 1 then ' - SOS'
				when 3 then ' - Urgente' 
			 else ''
			end 
		AS InformacoesComplementares,

	 case when itpm.presc_codigo = @presc_codigo then '5 - Medicamentos'
			when itps.presc_codigo = @presc_codigo then '4 - Sinais Vitais'
			when itce.presc_codigo = @presc_codigo then '3 - Cuidados Especiais'
			when itd.presc_codigo = @presc_codigo then '2 - Dietas'
			when itpo.presc_codigo = @presc_codigo then '1 - Oxigenoterapias'
	END AS OrdenacaoTipoItem,

	 CASE
		WHEN ITPM.itpresc_frequencia = 0 THEN 'Imediato'
		WHEN ITPM.itpresc_frequencia = '-120' THEN 'ACM'
		WHEN ITPM.itpresc_frequencia =  '-60' THEN 'Contínuo'
		WHEN ITPM.itpresc_frequencia = 15 then '15/15 min'
		WHEN ITPM.itpresc_frequencia = 30 then '30/30 min'
		WHEN ITPM.itpresc_frequencia = 60 then '1/1 h'
		WHEN ITPM.itpresc_frequencia = 120 then '2/2 h'
		WHEN ITPM.itpresc_frequencia = 180 then '3/3 h'
		WHEN ITPM.itpresc_frequencia = 240 then '4/4 h'
		WHEN ITPM.itpresc_frequencia = 300 then '5/5 h'
		WHEN ITPM.itpresc_frequencia = 360 then '6/6 h'
		WHEN ITPM.itpresc_frequencia = 480 then '8/8 h'
		WHEN ITPM.itpresc_frequencia = 720 then '12/12 h'
		WHEN ITPM.itpresc_frequencia = 1440 then '1x ao dia'
		ELSE ''
	END AS FrequenciaFormatada,
	ia.inter_datainter,
	(select ISNULL(stuff((select ',' + isnull(a.Descricao, s.DESCRICAO)
	from Paciente_Alergia pacale
	left join Pep_Alergia a on a.Codigo_Alergia = pacale.Codigo_Alergia
	left join Substancia s on s.id = pacale.Id_Substancia
	where pacale.pac_codigo = p.pac_codigo
	For Xml Path('')), 1, 1, ''),'')),
	itpm.item_prescricao_id

   from #PRESCRICAO p                 
     join #ITEM_PRESCRICAO itpr on p.presc_codigo = itpr.presc_codigo                  
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
     left join #internacao_aprazamento ia on ia.inter_codigo = p.inter_codigo
     left join internacao_pep ip on ip.inter_codigo = p.inter_codigo
     left join atendimento ate on ate.atend_codigo = p.atend_codigo
                          
   where p.presc_codigo = @presc_codigo           
   and itpm.item_prescricao_id = isnull(@item_prescricao_id, itpm.item_prescricao_id)
   order by Ordem_Discriminacao      

END            
ELSE            
 BEGIN            

	SET  @peso = null

	INSERT INTO #PRESCRICAO  
	SELECT presc_codigo, locatend_codigo , prof_codigo, SPA_CODIGO,EMER_CODIGO,INTER_CODIGO, ATENDAMB_CODIGO, PRESC_OBSERVACAO,PRESC_DATA, PAC_CODIGO, unid_codigo, atend_codigo  
	FROM PRESCRICAO   
	WHERE (PRESCRICAO.ATENDAMB_CODIGO = @ATENDAMB_CODIGO OR PRESCRICAO.INTER_CODIGO = @ATENDAMB_CODIGO)
	and Prescricao.presc_tipo = 'P'
	AND PRESCRICAO.PRESC_DATA > @DataInicio and  PRESCRICAO.PRESC_DATA < @DataFim

   INSERT INTO #ITEM_PRESCRICAO  
	SELECT it.presc_codigo, it.itpresc_codigo, it.itpresc_obs  
	FROM ITEM_PRESCRICAO IT
	JOIN #PRESCRICAO P on IT.PRESC_CODIGO = P.PRESC_CODIGO
	WHERE (P.ATENDAMB_CODIGO = @ATENDAMB_CODIGO OR P.INTER_CODIGO = @ATENDAMB_CODIGO)		
	  
  
	SELECT @SPA_CODIGO = SPA_CODIGO, @EMER_CODIGO = EMER_CODIGO, @INTER_CODIGO = INTER_CODIGO, @ATEND_CODIGO = atend_codigo FROM #PRESCRICAO 
  
	/*INTERNACAO APRAZAMENTO E INTERNACAO_PEP*/
	IF (@INTER_CODIGO IS NOT NULL)  
	BEGIN  
		INSERT INTO #INTERNACAO_APRAZAMENTO  
		SELECT DISTINCT I.INTER_CODIGO, I.SPA_CODIGO, I.EMER_CODIGO, IA.DOSE_DATA, VWLEITO.LOCINT_DESCRICAO, i.inter_datainter  
		FROM #PRESCRICAO P  
		JOIN #ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO  
		JOIN INTERNACAO I ON P.INTER_CODIGO = I.INTER_CODIGO  
		JOIN VWLEITO ON I.LOCATEND_LEITO = VWLEITO.LOCATEND_CODIGO AND I.LEI_CODIGO = VWLEITO.LEI_CODIGO                  
		LEFT JOIN ITEM_APRAZAMENTO IA ON IA.PRESC_CODIGO = IP.PRESC_CODIGO AND IA.ITPRESC_CODIGO = IP.ITPRESC_CODIGO                  
		WHERE I.INTER_CODIGO = @INTER_CODIGO  
		
		SELECT  @internacao_pep = inter_codigo FROM internacao_pep where inter_codigo = @INTER_CODIGO
		
		IF @internacao_pep IS NOT NULL
		BEGIN
			select @peso = peso from internacao_pep where inter_codigo = @inter_codigo;
		END
	END  
  
	/*RISCO*/  
	IF (@SPA_CODIGO IS NOT NULL OR ( @INTER_CODIGO IS NOT NULL AND @SPA_CODIGO IS NOT NULL ))  
	BEGIN   
		INSERT INTO #RISCO   
		SELECT RISACO_DESCRICAO  
		FROM UPA_ACOLHIMENTO UA   
		INNER JOIN UPA_CLASSIFICACAO_RISCO UCR ON UA.ACO_CODIGO = UCR.ACO_CODIGO  
		INNER JOIN RISCO_ACOLHIMENTO RA ON UCR.RISACO_CODIGO = RA.RISACO_CODIGO  
		WHERE UA.SPA_CODIGO = @SPA_CODIGO  
	END  
  
	IF (@EMER_CODIGO IS NOT NULL OR ( @INTER_CODIGO IS NOT NULL AND @EMER_CODIGO IS NOT NULL ))  
	BEGIN  
		INSERT INTO #RISCO   
		SELECT RISACO_DESCRICAO  
		FROM UPA_ACOLHIMENTO UA   
		INNER JOIN UPA_CLASSIFICACAO_RISCO UCR ON UA.ACO_CODIGO = UCR.ACO_CODIGO  
		INNER JOIN RISCO_ACOLHIMENTO RA ON UCR.RISACO_CODIGO = RA.RISACO_CODIGO  
		WHERE UA.EMER_CODIGO = @EMER_CODIGO  
	END  
   
	SELECT @PAC_CODIGO = PAC_CODIGO FROM #PRESCRICAO  
   
	SELECT @PAC_PRONTUARIO_NUMERO = PAC_PRONTUARIO_NUMERO FROM PACIENTE_PRONTUARIO WHERE PAC_CODIGO = @PAC_CODIGO  
                   
	INSERT INTO #TEMP                  
                     
	SELECT u.unid_descricao, u.unid_codigo, v.set_descricao, pr.prof_nome, pa.pac_codigo, pa.pac_nome, @PAC_PRONTUARIO_NUMERO AS pac_prontuario_numero, 
	ia.locint_descricao, 
	case when pa.pac_nascimento is not null then (cast(DateDiff(dd, pa.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pa.pac_nascimento, getdate()) as int) / 4)) / 365                  
	when pa.pac_nascimento is null and p.spa_codigo is not null then (select spa_idade from pronto_atendimento where spa_codigo = p.spa_codigo)                  
	when pa.pac_nascimento is null and p.emer_codigo is not null then (select emer_idade from emergencia where emer_codigo = p.emer_codigo)                                
	end as pac_idade,
	p.presc_observacao, itpr.presc_codigo, itpr.itpresc_codigo,                  
                     
    replace( (convert(varchar,itpm.itpresc_quantidade) + ' ' + RTRIM(itpm.ins_unidade)), '.00', '' ) as itpresc_quantidade  
    ,(convert(varchar,itpm.itpresc_total) + ' ' + RTRIM(itpm.ins_unidade)) as itpresc_total, 
    itpr.itpresc_obs,                                    
                     
    case when itpm.presc_codigo =  p.presc_codigo  and itpm.itpresc_frequencia <> 0 then 'M' -- Medicamento                  
       when itpm.presc_codigo =  p.presc_codigo  and itpm.itpresc_frequencia = 0 then 'M' -- Medicamento       
       when itps.presc_codigo =  p.presc_codigo  then 'S' -- Sinais Vitais                                    
       when itce.presc_codigo =  p.presc_codigo  then 'C' -- Cuidados Especiais                                    
       when itd.presc_codigo  =  p.presc_codigo  then 'D' -- Dieta                                    
       when itpo.presc_codigo =  p.presc_codigo  then 'O' -- Oxigenoterapia         
	   when ipp.presc_codigo IS NOT NULL then 'P' -- Procedimento     
    end as TipoItemPrescricao,                            
                     
    case when itpm.presc_codigo =  p.presc_codigo  then '1'  
       when itps.presc_codigo =  p.presc_codigo  then '0'  
       when itce.presc_codigo =  p.presc_codigo  then '0'  
       when itd.presc_codigo  =  p.presc_codigo  then '0'  
       when itpo.presc_codigo =  p.presc_codigo  then '0'  
    end as Agrupamento,                        
                     
    case when itpm.presc_codigo =  p.presc_codigo  then                           
    case when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'M' then itpm.itpresc_duracao                           
      when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'H' then itpm.itpresc_duracao * 60                          
      when itpm.itpresc_frequencia <> 0 then itpm.itpresc_frequencia / 60 end  
      when itps.presc_codigo =  p.presc_codigo  then itps.ipsv_intervalo  
      when itce.presc_codigo =  p.presc_codigo  then itce.ipce_intervalo  
      when itpo.presc_codigo =  p.presc_codigo  then itpo.ipox_intervalo  
    end as Intervalo,                                                  
                     
    case when itpm.presc_codigo =  p.presc_codigo  then (  
		itpm.ins_descricao + ' - Dose: ' +   
	CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
        WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
        ELSE convert(varchar(10),itpresc_quantidade)   
        END  
	  + ' ' + ins_unidade + ' Via: ' + Viamed_Descricao + ' Intervalo: ' +   
	  case itpresc_frequencia  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h'  
	  end  
	  )  
        
        when itps.presc_codigo =  p.presc_codigo  then (itps.ipsv_texto) + ' - Intervalo: ' +  case itps.ipsv_intervalo  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end                                       
       when itce.presc_codigo =  p.presc_codigo  then (ce.cues_descricao) + ' - Intervalo: ' +  case itce.ipce_intervalo  
		when 0 then 'Imediato'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end                                                   
       when itd.presc_codigo =  p.presc_codigo  then (itd.ipdi_texto)                                    
       when itpo.presc_codigo = p.presc_codigo then (ox.oxi_descricao) + ' - Intervalo: ' +  case isnull(itpo.ipox_intervalo, 0)  
		when 0 then 'Contínuo'  
		when 15 then '15/15 min '  
		when 30 then '30/30 min '  
		when 60 then ' 1/1 h'  
		when 120 then ' 2/2 h'  
		when 180 then ' 3/3 h'  
		when 240  then ' 4/4 h'  
		when 300 then ' 5/5 h'  
		when 360  then ' 6/6 h'  
		when 480 then ' 8/8 h'  
		when 720 then ' 12/12 h'  
		when 1440 then ' 24/24 h' end +
		case ox.oxi_tipo 
		when 0 then ' - Unidade: '+ convert(varchar,isnull(itpo.ipox_unidade, 'Não Informado')) + '% FiO2' 
		when 1 then ' - Unidade: '+ convert(varchar,isnull(itpo.ipox_unidade, 'Não Informado')) + ' L/min' end +
		case when itpo.ipox_duracao is not null then   
		' - Durante: ' + convert(varchar,isnull(itpo.ipox_duracao,'')) + ' ' +
		 case when itpo.ipox_tpduracao = 'H' then 'Hora(s)' else 'Minuto(s)' end else '' end 
	   when ipp.presc_codigo =  p.presc_codigo  then tbp.co_procedimento + ' - ' + tbp.no_procedimento             
    end 
	+
	case itpm.itpresc_caracteristica 
		when 1 then ' - SOS'
		when 2 then ' - A critério do médico' 
		else ''
	end 
	as Item,                  
                     
    '' as Detalhe,                                    
                     
     itce.cues_codigo as Codigo,                   
     itpo.oxi_codigo as Codigo,                   
     itpo.ipox_unidade_tempo as UnidadeTempo,                   
     p.presc_data,                   
     ia.dose_data as DataHoraAprazamento,                  
     itpm.GeraPedidoPaciente,                  
     NULL AS cabecalho_report1,       
     NULL AS cabecalho_report2,                  
     NULL AS cabecalho_report3,             
     pa.pac_nascimento,                  
                     
     case when pa.pac_sexo = 'F' then 'Feminino'                 
       when pa.pac_sexo = 'M' then 'Masculino'                  
     end as pac_sexo,                  
     pl.Prof_registro_conselho,   
     (select oec.orgem_descricao from Orgao_Emissor_Conselho oec join Tipo_Profissional tp on oec.orgem_codigo = tp.orgem_codigo  
      where tp.tipprof_codigo = pl.tipprof_codigo) as orgao_emissor_conselho,  
       
     isnull( isnull(p.spa_codigo, iA.spa_codigo) , isnull(p.emer_codigo, iA.emer_codigo) ) as num_atendimento,                  
  
     case when itd.presc_codigo  =  p.presc_codigo  then '0'                  
       when itpm.presc_codigo =  p.presc_codigo  then '1'                  
       when itps.presc_codigo =  p.presc_codigo  then '2'                  
       when itce.presc_codigo =  p.presc_codigo  then '3'                  
       when itpo.presc_codigo =  p.presc_codigo  then '4'         
	   when ipp.presc_codigo =  p.presc_codigo  then '5'
     end as Ordem_Discriminacao,                  
                     
     (SELECT RISACO_DESCRICAO FROM #RISCO) AS cor_risco,  
      NULL as horarios_aprazamento,                  
      NULL as observacoes_enfermagem,                  
      p.atendamb_codigo,    
      itpm.itpresc_codigo_issoluvel,    
      itpm.item_prescricao_id_solucao,
      @peso,
      '',
      ip.inter_codigo,
      ate.atend_codigo,
	  pa.pac_mae,
	
	case when itpm.presc_codigo = p.presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpm.item_prescricao_id) > 0 then 'MEDICAMENTO SUSPENSO' 
		   when itps.presc_codigo = p.presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itps.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itce.presc_codigo = p.presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itce.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itd.presc_codigo = p.presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itd.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
		   when itpo.presc_codigo = p.presc_codigo AND (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpo.item_prescricao_id) > 0 then 'ITEM SUSPENSO' 
	  ELSE NULL END AS MedicamentoSuspenso,

case when itpm.presc_codigo = p.presc_codigo then itpm.ins_descricao_resumida
			when itps.presc_codigo = p.presc_codigo then (itps.ipsv_texto)
			when itce.presc_codigo = p.presc_codigo then (ce.cues_descricao)
			when itd.presc_codigo = p.presc_codigo then (itd.ipdi_texto)   
			when itpo.presc_codigo = p.presc_codigo then (ox.oxi_descricao)
		end + 
			case when LEN(ITPM.itpresc_quantidade) > 0 then (  
		' - Dose: ' +   
				CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
				WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
				ELSE convert(varchar(10),itpresc_quantidade)   
			END  
		+ ' ' + ins_unidade + '(s) ') ELSE ' ' END + 
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao_resumida) > 0 THEN ' + ' + ITPM.diluente_ins_descricao_resumida 
			   WHEN LEN(ITPM.diluente_ins_descricao) > 0 THEN ' + ' + ITPM.diluente_ins_descricao ELSE ' ' END +
		case when LEN(itpm.diluente_volume) > 0 THEN ' - Volume do Diluente: ' + CONVERT(VARCHAR(10), itpm.diluente_volume) + ' ml ' ELSE '' END 
		AS DescricaoResumida,

		case when LEN(itpm.viamed_descricao) > 0 THEN itpm.viamed_descricao ELSE '' END +
		case when LEN(itpm.diluente_volume_total) > 0 THEN ' - Volume Total: ' + CONVERT(VARCHAR(10), itpm.diluente_volume_total) + ' ml' ELSE '' END + 
		case when LEN(itpm.diluente_valor_velocidade) > 0 THEN ' - Velocidade: ' + CONVERT(VARCHAR(10), itpm.diluente_valor_velocidade) + ' ' + itpm.diluente_medida_velocidade ELSE '' END +
		case itpm.itpresc_caracteristica 
				when 1 then ' - SOS'
				when 3 then ' - Urgente' 
			 else ''
			end 
		AS InformacoesComplementares,

	case when itpm.presc_codigo = p.presc_codigo then '5 - Medicamentos'
		when itps.presc_codigo = p.presc_codigo then '4 - Sinais Vitais'
		when itce.presc_codigo = p.presc_codigo then '3 - Cuidados Especiais'
		when itd.presc_codigo = p.presc_codigo then '2 - Dietas'
		when itpo.presc_codigo = p.presc_codigo then '1 - Oxigenoterapias'
	END AS OrdenacaoTipoItem,

	 CASE
		WHEN ITPM.itpresc_frequencia = 0 THEN 'Imediato'
		WHEN ITPM.itpresc_frequencia = '-120' THEN 'A critério médico'
		WHEN ITPM.itpresc_frequencia =  '-60' THEN 'Contínuo'
		WHEN ITPM.itpresc_frequencia = 15 then '15/15 min'
		WHEN ITPM.itpresc_frequencia = 30 then '30/30 min'
		WHEN ITPM.itpresc_frequencia = 60 then '1/1 h'
		WHEN ITPM.itpresc_frequencia = 120 then '2/2 h'
		WHEN ITPM.itpresc_frequencia = 180 then '3/3 h'
		WHEN ITPM.itpresc_frequencia = 240 then '4/4 h'
		WHEN ITPM.itpresc_frequencia = 300 then '5/5 h'
		WHEN ITPM.itpresc_frequencia = 360 then '6/6 h'
		WHEN ITPM.itpresc_frequencia = 480 then '8/8 h'
		WHEN ITPM.itpresc_frequencia = 720 then '12/12 h'
		WHEN ITPM.itpresc_frequencia = 1440 then '1x ao dia'
		ELSE ''
	END AS FrequenciaFormatada,
	ia.inter_datainter,
	(select ISNULL(stuff((select ',' + isnull(a.Descricao, s.DESCRICAO)
	from Paciente_Alergia pacale
	left join Pep_Alergia a on a.Codigo_Alergia = pacale.Codigo_Alergia
	left join Substancia s on s.id = pacale.Id_Substancia
	where pacale.pac_codigo = p.pac_codigo
	For Xml Path('')), 1, 1, ''),''))
	,itpm.item_prescricao_id
   from #PRESCRICAO p                 
     join #ITEM_PRESCRICAO itpr on p.presc_codigo = itpr.presc_codigo                  
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
     left join #internacao_aprazamento ia on ia.inter_codigo = p.inter_codigo
     left join internacao_pep ip on ip.inter_codigo = p.inter_codigo
     left join atendimento ate on ate.atend_codigo = p.atend_codigo
                          
   where (P.ATENDAMB_CODIGO = @ATENDAMB_CODIGO OR P.INTER_CODIGO = @ATENDAMB_CODIGO)               
   order by Ordem_Discriminacao      

 END  

-- Atualiza o Campo OBSERVACOES_ENFERMAGEM                  
create table #OBSENFERMAGEM  
(  
 observacoes_enfermagem varchar(8000) null  
)  
  
DECLARE @Obs varchar(8000)  
DECLARE @ObsAux varchar(1000)  
  
Set @Obs = ''  
Set @ObsAux = ''  
  
DECLARE cursor_obs CURSOR FOR  
  
  select convert(char(5), apt.ANPT_DT_ANOTACAO, 103) + ' ' + convert(char(5), apt.ANPT_DT_ANOTACAO, 108) + ' - ' +   
 pr.prof_nome + ' - ' +   
 apt.ANPT_TX_ANOTACAO + CHAR(13) + CHAR(10) as Obs                     
  from Anotacao_Plano_Terapeutico apt, profissional_rede pr                      
  where apt.prof_codigo = pr.prof_codigo                      
  and apt.atendamb_codigo = ( select top 1 atendamb_codigo from #TEMP )  
  order by ANPT_DT_ANOTACAO desc  
  
OPEN cursor_obs                      
                      
FETCH NEXT FROM cursor_obs                       
INTO @ObsAux  
  
WHILE @@FETCH_STATUS = 0                      
BEGIN  
  
 if (len(@Obs) + len(@ObsAux) < 8000)  
    Set @Obs = @Obs + @ObsAux  
  
 FETCH NEXT FROM cursor_obs                       
 INTO @ObsAux  
END  
  
CLOSE cursor_obs                      
DEALLOCATE cursor_obs                      
  
insert into #OBSENFERMAGEM values (@Obs)  
  
-- Atualiza o Campo HORARIOS_APRAZAMENTO  
    
DECLARE @PrescCodigo char(12), @ItprescCodigo int, @Item varchar(2000), @PrescData smalldatetime, @DataHoraAprazamento smalldatetime, @HorariosAprazamento varchar(2000),@Itpresc_codigo_issoluvel CHAR(1),@item_prescricao_id_solucao uniqueidentifier  
DECLARE @valor varchar(2000)         
DECLARE @PRESC_CODIGO_AUX CHAR(12)          
DECLARE cursor_aprazamento CURSOR FOR                   
            
SELECT presc_codigo, itpresc_codigo, Item, presc_data, DataHoraAprazamento, horarios_aprazamento, itpresc_codigo_issoluvel, item_prescricao_id_solucao            
FROM #TEMP            
                  
OPEN cursor_aprazamento                  
                  
FETCH NEXT FROM cursor_aprazamento                   
INTO @PrescCodigo, @ItprescCodigo, @Item, @PrescData, @DataHoraAprazamento, @HorariosAprazamento, @Itpresc_codigo_issoluvel, @item_prescricao_id_solucao    
    
    
WHILE @@FETCH_STATUS = 0                  
BEGIN                  
   SET @valor = ''                   
   IF((@itpresc_codigo_issoluvel = 'S') AND (@item_prescricao_id_solucao IS NOT NULL))    
  BEGIN      
     SELECT @valor = @valor + ' - ' + convert(char(5), ia.dose_data, 103) + ' ' + convert(char(5), ia.dose_data, 108) + ' ' + isnull(ia.dose_adm, '')                  
     FROM item_aprazamento ia join item_prescricao_medicamento itpm on ia.item_prescricao_id = itpm.item_prescricao_id    
     WHERE itpm.item_prescricao_id = @item_prescricao_id_solucao                  
     ORDER BY ia.itpresc_codigo, ia.dose_data               
        END       
   ELSE        
  BEGIN    
     SELECT @valor = @valor + ' - ' + convert(char(5), ia.dose_data, 103) + ' ' + convert(char(5), ia.dose_data, 108) + ' ' + isnull(ia.dose_adm, '')                  
     FROM item_aprazamento ia                  
     WHERE ia.presc_codigo = @PrescCodigo and ia.itpresc_codigo = @ItprescCodigo                  
     ORDER BY ia.itpresc_codigo, ia.dose_data      
  END    
    
       
   UPDATE  #TEMP                    
   SET     #TEMP.horarios_aprazamento = @valor                  
   FROM    #TEMP                  
   WHERE   #TEMP.PRESC_CODIGO = @PrescCodigo AND #TEMP.ITPRESC_CODIGO = @ItprescCodigo                  
            
   FETCH NEXT FROM cursor_aprazamento                   
   INTO @PrescCodigo, @ItprescCodigo, @Item, @PrescData, @DataHoraAprazamento, @HorariosAprazamento, @Itpresc_codigo_issoluvel, @item_prescricao_id_solucao           
END                  
    
CLOSE cursor_aprazamento                  
DEALLOCATE cursor_aprazamento                  
  
CREATE TABLE #TEMP3 (         
   unid_descricao varchar(50),
   unid_codigo char(4),                  
   set_descricao varchar(30),                  
   prof_nome varchar(50),                  
   pac_codigo char(12),                  
   pac_nome varchar(50),                  
   pac_prontuario_numero char(10),                  
   locint_descricao varchar(8000),                  
   pac_idade int,                  
   presc_observacao varchar(4000),                  
   presc_codigo char(12),                  
   itpresc_codigo int,                  
   itpresc_quantidade varchar(100),                  
   itpresc_total varchar(100),                  
   itpresc_obs varchar(2000),                  
   TipoItemPrescricao char(1),                  
   Agrupamento char(1),                  
   Intervalo int,                  
   Item varchar(2000),                  
   Detalhe varchar(2000),                  
   cues_codigo int,                  
   oxi_codigo int,                  
   UnidadeTempo char(1),                  
   presc_data smalldatetime,                   
   DataHoraAprazamento smalldatetime,                  
   GeraPedidoPaciente char(1),                  
   cabecalho_report1 varchar(100),                  
   cabecalho_report2 varchar(100),                  
   cabecalho_report3 varchar(100),                  
   pac_nascimento datetime,                  
   pac_sexo varchar(15),                  
   Prof_registro_conselho varchar(20),    
   orgao_emissor_conselho varchar(20),    
   num_atendimento char(12),                  
   Ordem_Discriminacao char(1),                  
   cor_risco varchar(50),                  
  horarios_aprazamento varchar(2000),                  
   atendamb_codigo char(12),
   atendamb_peso numeric(9,1),  
   UnidadeMedida  varchar(50)      ,
   inter_codigo varchar(12),
   atend_codigo varchar(12),
   pac_mae varchar(50),
   MedicamentoSuspenso varchar(100),
   DescricaoResumida varchar(1000),
   InformacoesComplementares varchar(8000),
   OrdenacaoTipoItem varchar(100),
   FrequenciaFormatada varchar(100),
   inter_datainter smalldatetime,
   alergias varchar(1000),
   item_prescricao_id uniqueidentifier
                
)             
          
insert into #TEMP3          
   SELECT DISTINCT        
      unid_descricao,
	  unid_codigo,                  
      set_descricao,                  
      prof_nome,                  
      pac_codigo,                  
      pac_nome,                  
      pac_prontuario_numero,                  
      locint_descricao,                  
      pac_idade,                  
      presc_observacao,                  
      presc_codigo,                  
      itpresc_codigo,                  
      itpresc_quantidade,                  
      itpresc_total,                  
      itpresc_obs,                  
      TipoItemPrescricao,                  
      Agrupamento,                  
      Intervalo,                  
      Item,                  
      Detalhe,                  
      cues_codigo,                  
      oxi_codigo,                  
      UnidadeTempo,                  
      presc_data,                   
      null as DataHoraAprazamento,                  
      GeraPedidoPaciente,                  
      null AS cabecalho_report1,                  
      null AS cabecalho_report2,            
      null AS cabecalho_report3,                
      pac_nascimento,                  
      pac_sexo,                  
      Prof_registro_conselho,   
      orgao_emissor_conselho,   
      num_atendimento,                  
      Ordem_Discriminacao,                  
      cor_risco,                  
      horarios_aprazamento,                  
      atendamb_codigo,
	  atendamb_peso,
	  UnidadeMedida,
	  inter_codigo,
	  atend_codigo,
	  pac_mae,
	  MedicamentoSuspenso,
	  DescricaoResumida, 
	  InformacoesComplementares, 
	  OrdenacaoTipoItem,
	  FrequenciaFormatada,
	  inter_datainter,
	  alergias,
	  item_prescricao_id
   FROM #TEMP            
   --ORDER BY #TEMP.Ordem_Discriminacao             
          
if(@PRESC_CODIGO IS NOT NULL)            
BEGIN             
 SELECT        
       unid_descricao,             
       set_descricao,                  
       prof_nome,                  
       pac_codigo,     
       pac_nome,                  
       pac_prontuario_numero,                  
       locint_descricao,      
       pac_idade,                  
       presc_observacao,                  
       presc_codigo,                  
       itpresc_codigo,                  
       itpresc_quantidade,                  
       itpresc_total,                  
       itpresc_obs,                  
       TipoItemPrescricao,                  
       Agrupamento,                  
       Intervalo,                  
       Item,                  
       Detalhe,                  
       cues_codigo,                  
       oxi_codigo,                  
       UnidadeTempo,                  
       presc_data,                   
       null as DataHoraAprazamento,                  
       GeraPedidoPaciente,               
       pac_nascimento,                  
       pac_sexo,                  
       Prof_registro_conselho,   
       orgao_emissor_conselho,   
       num_atendimento,              
       Ordem_Discriminacao,                  
       cor_risco,                  
       horarios_aprazamento,                  
       (select top 1 observacoes_enfermagem from #OBSENFERMAGEM) as observacoes_enfermagem,                       
       atendamb_codigo,
	   atendamb_peso,
	   UnidadeMedida,
	   inter_codigo,
	   atend_codigo,
	   pac_mae,
	   MedicamentoSuspenso,
	   DescricaoResumida,
	   InformacoesComplementares,
	   OrdenacaoTipoItem,
	   FrequenciaFormatada,
	   ROW_NUMBER() OVER (ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo) as NumeracaoItem,
	   inter_datainter,
	   alergias,
	   item_prescricao_id
 FROM #TEMP3
 ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo

  END          

ELSE          
  BEGIN          
 SELECT          
       unid_descricao,             
       set_descricao,                  
       prof_nome,                  
       pac_codigo,                 
       pac_nome,                  
       pac_prontuario_numero,                  
       locint_descricao,                  
       pac_idade,                  
       presc_observacao,                  
       presc_codigo,                  
       itpresc_codigo,                  
       itpresc_quantidade,                  
       itpresc_total,                  
       itpresc_obs,                  
       TipoItemPrescricao,                  
       Agrupamento,                  
       Intervalo,                
       Item,                  
       Detalhe,                  
       cues_codigo,                  
       oxi_codigo,                  
       UnidadeTempo,                  
       presc_data,                   
       null as DataHoraAprazamento,                  
       GeraPedidoPaciente,               
       pac_nascimento,                  
       pac_sexo,                  
       Prof_registro_conselho,   
       orgao_emissor_conselho,   
       num_atendimento,              
       Ordem_Discriminacao,                  
       cor_risco,                  
       horarios_aprazamento,                  
       (select top 1 observacoes_enfermagem from #OBSENFERMAGEM) as observacoes_enfermagem,            
       atendamb_codigo,
	   atendamb_peso,
	   UnidadeMedida,
	   inter_codigo,
	   atend_codigo,
	   pac_mae,
	   MedicamentoSuspenso,
	   DescricaoResumida,
	   InformacoesComplementares,
	   OrdenacaoTipoItem,
	   FrequenciaFormatada,
	   ROW_NUMBER() OVER (ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo) as NumeracaoItem,
	   inter_datainter,
	   alergias,
	   item_prescricao_id
 FROM #TEMP3
 ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo
    
  END           

SET NOCOUNT OFF

GO
CREATE FUNCTION [dbo].[FCN_FORMATA_IN](@STRING VARCHAR(MAX)) 
RETURNS VARCHAR(MAX) AS
BEGIN	
	DECLARE @VARIN VARCHAR(MAX)=''
	DECLARE @POS INT =1	
	WHILE(CHARINDEX(',',@STRING ,@POS)>0)
	BEGin
		SET @VARIN = @VARIN+     REPLACE(SUBSTRING(@STRING,@POS,CHARINDEX(',',@STRING ,@POS)),' ' ,'')
		SET @STRING = SUBSTRING(@STRING,CHARINDEX(',',@STRING ,@POS)+1,LEN(@STRING))		
	END
	--SET @VARIN = @VARIN+  ','
	SET @VARIN = 'IN(' + CHAR(39)+ REPLACE(@VARIN+CHAR(39)+ @STRING+CHAR(39),',',''',''')+')'	
	SET @VARIN = REPLACE(@VARIN, '''''', '''')
	RETURN @VARIN
END

GO
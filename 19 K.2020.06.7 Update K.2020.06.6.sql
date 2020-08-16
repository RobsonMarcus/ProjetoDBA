GO
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[Internacao_Pep]...';


GO
ALTER TABLE [dbo].[Internacao_Pep]
    ADD [data_sintoma] DATETIME NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[ksp_prontuario_internacao_impresso]...';


GO
ALTER PROCEDURE [dbo].[ksp_prontuario_internacao_impresso]
@inter_codigo CHAR (12)=null, @unid_codigo CHAR (4)=null
AS
select	p.pac_nome, 
			pp.Pac_Prontuario_Numero,
			CONVERT(VARCHAR, dbo.CalculaIdade(GETDATE(), p.pac_nascimento)) + ' anos' as idade,
			p.pac_nascimento,
			CASE WHEN P.pac_sexo = 'M' THEN 'MASC' ELSE 'FEM' END as sexo,
			r.Raca_Desc,
			p.pac_cartao_nsaude,
			p.pac_mae,
			p.pac_telefone,
			p.pac_telefone2,
			p.pac_celular,
			case	when p.pac_nacionalidade = '0001' then '01. Brasileiro'
					when p.pac_nacionalidade = '0002' then '02. Estrangeiro' end as nacionalidade,
			case when mn.mun_descricao is not null then mn.mun_descricao + ' / ' + ufn.uf_descricao end as naturalidade,
			p.pac_cpf,
			p.pac_numero_documento,
			pc.paccns_identidade_numero,
			c.cep_logradouro 
				+ case when p.pac_endereco_num is not null and p.pac_endereco_num != '' then ', ' + p.pac_endereco_num else '' end
				+ case when p.pac_endereco_compl is not null and p.pac_endereco_compl != '' then ', ' + p.pac_endereco_num else '' end
				as cep_logradouro,
			p.pac_endereco_num,
			p.pac_endereco_compl,
			be.bai_descricao,
			me.mun_descricao,
			ufe.uf_descricao,
			c.cep_cep,
			i.inter_codigo,
			i.inter_datainter,
			la.LocAtend_descricao,
			ip.queixa_principal,
			ip.anamnese,
			ip.exame_fisico,
			ip.peso,
			ip.pa, 
			ip.pulso, 
			ip.temperatura,
			ip.freq_resp, 
			ip.hgt, 
			ip.saturacaoo2,
			ip.suspeita_diagnostica,
			ip.conduta_procedimento_proposto,
			ip.data_sintoma,
			m.med_nome,
			c1.cid_codigo + ' - ' + c1.cid_descricao as cid_primario,
			c2.cid_codigo + ' - ' + c2.cid_descricao as cid_secundario,
			pr.proc_descricao,
			ci.carint_descricao,
			i.inter_dtalta,
			DATEDIFF(day,i.inter_datainter,i.inter_dtalta) AS dias_internacao,
			mca.motcob_descricao,
			ma.med_nome,
			vma.LocAtend_descricao,
			c1.cid_codigo + ' - ' + c1.cid_descricao as cid_primario_alta,
			c2.cid_codigo + ' - ' + c2.cid_descricao as cid_secundario_alta,
			pr.proc_descricao as proc_descricao_alta,
			prof.prof_nome as profissional_admissao,
			lc.LOCINT_DESCRICAO as leito,
			upr.LOGO,
   			upr.cabecalho_report1,                                        
   			upr.cabecalho_report2,  
   			upr.cabecalho_report3,
   			u.unid_descricao,
   			(select count(*) from upa_evolucao ue where ue.inter_codigo = @inter_codigo) as count_evolucao
	from internacao i
		inner join pedido_internacao pi on i.pedint_sequencial = pi.pedint_sequencial
		inner join internacao_pep ip on i.inter_codigo = ip.inter_codigo
		inner join paciente p on i.pac_codigo = p.pac_codigo
		inner join vwLocal_Unidade la on i.locatend_codigo = la.locatend_codigo
		left join Paciente_Prontuario pp on p.pac_codigo = pp.pac_codigo and la.unid_codigo = pp.unid_codigo
		left join raca r on p.pac_raca = r.Raca_Codigo
		left join profissional prof on ip.prof_codigo = prof.prof_codigo and ip.locatend_codigo = prof.locatend_codigo
		left join municipio mn on p.pac_naturalidade = mn.mun_codigo
		left join unidade_federativa ufn on mn.uf_codigo = ufn.uf_codigo
		left join Paciente_CNS pc on p.pac_codigo = pc.pac_codigo
		left join cep c on p.cep_sequencial = c.cep_sequencial
		left join municipio me on c.mun_codigo = me.mun_codigo
		left join bairro be on me.mun_codigo = be.mun_codigo and be.bai_codigo = c.bai_codigo
		left join unidade_federativa ufe on me.uf_codigo = ufe.uf_codigo
		left join medico m on i.prof_codigo = m.prof_codigo and i.locatend_codigo = m.locatend_codigo
		left join cid_10 c1 on pi.cid_codigo = c1.cid_codigo
		left join cid_10 c2 on pi.cid_secundario = c2.cid_codigo
		left join procedimento pr on pi.proc_codigo = pr.proc_codigo
		left join carater_internacao ci on pi.carint_codigo = ci.carint_codigo
		left join motivo_cobranca_aih mca on i.inter_motivo_alta = mca.motcob_codigo
		left join medico ma on i.prof_codigo_resp = ma.prof_codigo and i.locatend_codigo_resp = ma.locatend_codigo
		left join vwLocal_Unidade vma on i.locatend_codigo_resp = vma.locatend_codigo
		left join vwleito_completo lc on i.locatend_leito = lc.LOCATEND_CODIGO and i.lei_codigo = lc.lei_codigo,
		unidade u inner join unidade_parametro_relatorio upr on u.unid_codigo = upr.unid_codigo
	where i.inter_codigo = @inter_codigo
		and u.unid_codigo = @unid_codigo
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[ksp_internacao_pep]...';


GO
ALTER PROCEDURE [dbo].[ksp_internacao_pep]
@inter_codigo CHAR (12)=null, @queixa_principal VARCHAR (1000)=null, @anamnese VARCHAR (1000)=null, @exame_fisico VARCHAR (1000)=null, @pa CHAR (10)=NULL, @pulso CHAR (10)=NULL, @temperatura CHAR (4)=NULL, @freq_resp CHAR (3)=NULL, @saturacaoO2 VARCHAR (10)=NULL, @peso NUMERIC (9, 1)=NULL, @imc NUMERIC (10, 2)=NULL, @altura NUMERIC (10, 2)=NULL, @suspeita_diagnostica VARCHAR (1000)=null, @conduta_procedimento_proposto VARCHAR (1000)=null, @data DATETIME=null, @hgt VARCHAR (10)=null, @locatend_codigo CHAR (4)=null, @prof_codigo CHAR (4)=null, @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @dataSintoma DATETIME=null
AS
DECLARE @SQL VARCHAR(8000)
DECLARE @PAR VARCHAR(500)
DECLARE @VAR VARCHAR(500)

IF (@OPCAO = 0) /* LIST */
   
BEGIN

   SET @SQL =        ' SELECT ' 
   SET @SQL = @SQL + '   p.inter_codigo, 
						 p.queixa_principal, 
						 p.anamnese, 
						 p.exame_fisico, 
						 p.pa, 
						 p.pulso, 
						 p.temperatura, 
						 p.freq_resp,
						 p.saturacaoo2,
						 p.peso,
						 p.imc,
						 p.altura,
						 p.suspeita_diagnostica,
						 pi.cid_codigo as cid_codigo_primario,
						 pi.cid_secundario as cid_codigo_secundario,
						 pi.proc_codigo,
						 p.conduta_procedimento_proposto,
						 c1.cid_descricao as cid_descricao_primario,
						 c2.cid_descricao as cid_descricao_secundario,
						 p.data,
						 p.hgt,
						 p.prof_codigo,
						 p.locatend_codigo,
						 p.data_sintoma' 
   SET @SQL = @SQL + ' FROM ' 
   SET @SQL = @SQL + '   Internacao_Pep p inner join internacao i on p.inter_codigo = i.inter_codigo
							 inner join pedido_internacao pi on i.pedint_sequencial =  pi.pedint_sequencial
							 left join cid_10 c1 on pi.cid_codigo = c1.cid_codigo
							 left join cid_10 c2 on pi.cid_secundario = c2.cid_codigo' 
   SET @SQL = @SQL + ' WHERE '
 IF @inter_codigo IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @inter_codigo) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "p.inter_codigo", @TP_PESQ, "T", @PAR OUTPUT 
   SET @SQL = (@SQL + @PAR)
 END	
EXEC (@SQL)
END
IF (@OPCAO = 1)  /* INCLUSAO */
 
BEGIN

   INSERT INTO Internacao_Pep (inter_codigo, 
						 queixa_principal, 
						 anamnese, 
						 exame_fisico, 
						 pa, 
						 pulso, 
						 temperatura, 
						 freq_resp,
						 saturacaoo2,
						 peso,
						 imc,
						 altura,
						 suspeita_diagnostica,
						 conduta_procedimento_proposto,
						 data,
						 hgt,
						 prof_codigo,
						 locatend_codigo,
						 data_sintoma)
        VALUES (		 @inter_codigo, 
						 @queixa_principal, 
						 @anamnese, 
						 @exame_fisico, 
						 @pa, 
						 @pulso, 
						 @temperatura, 
						 @freq_resp,
						 @saturacaoo2,
						 @peso,
						 @imc,
						 @altura,
						 @suspeita_diagnostica,
						 @conduta_procedimento_proposto,
						 @data,
						 @hgt,
						 @prof_codigo,
						 @locatend_codigo,
						 @dataSintoma)

SELECT scope_identity()

END

IF (@OPCAO = 2)  /* ALTERACAO */
 
BEGIN

   UPDATE
     Internacao_pep
   SET 
	queixa_principal = @queixa_principal, 
	anamnese = @anamnese, 
	exame_fisico = @exame_fisico, 
	pa = @pa, 
	pulso = @pulso, 
	temperatura = @temperatura, 
	freq_resp = @freq_resp,
	saturacaoo2 = @saturacaoo2,
	peso = @peso,
	imc = @imc,
	altura = @altura,
	suspeita_diagnostica = @suspeita_diagnostica,
	conduta_procedimento_proposto = @conduta_procedimento_proposto,
	data = @data,
	hgt = @hgt,
	prof_codigo = @prof_codigo,
	locatend_codigo = @locatend_codigo,
	data_sintoma = @dataSintoma
   WHERE
     inter_codigo = @inter_codigo

END

IF (@OPCAO= 3) /* EXCLUSAO */

BEGIN
          
   DELETE FROM Internacao_Pep
   WHERE
     inter_codigo = @inter_codigo
      
END

IF (@OPCAO= 4) /* PROCURA POR CHAVE */

BEGIN
          
   SELECT
	p.inter_codigo, 
	p.queixa_principal, 
	p.anamnese, 
	p.exame_fisico, 
	p.pa, 
	p.pulso, 
	p.temperatura, 
	p.freq_resp,
	p.saturacaoo2,
	p.peso,
	p.imc,
	p.altura,
	p.suspeita_diagnostica,
	 pi.cid_codigo as cid_codigo_primario,
	pi.cid_secundario as cid_codigo_secundario,
	pi.proc_codigo,
	p.conduta_procedimento_proposto,
	c1.cid_descricao as cid_descricao_primario,
	c2.cid_descricao as cid_descricao_secundario,
	p.data,
	p.hgt,
	p.prof_codigo,
	p.locatend_codigo,
	p.data_sintoma
   FROM
     Internacao_Pep p inner join internacao i on p.inter_codigo = i.inter_codigo
							 inner join pedido_internacao pi on i.pedint_sequencial =  pi.pedint_sequencial
							 left join cid_10 c1 on pi.cid_codigo = c1.cid_codigo
							 left join cid_10 c2 on pi.cid_secundario = c2.cid_codigo
   WHERE
     p.inter_codigo = @inter_codigo
      
END


IF (@OPCAO = 5) /* LISTA TODOS */

BEGIN
          
   SELECT
    p.inter_codigo, 
	p.queixa_principal, 
	p.anamnese, 
	p.exame_fisico, 
	p.pa, 
	p.pulso, 
	p.temperatura, 
	p.freq_resp,
	p.saturacaoo2,
	p.peso,
	p.imc,
	p.altura,
	p.suspeita_diagnostica,
	 pi.cid_codigo as cid_codigo_primario,
	pi.cid_secundario as cid_codigo_secundario,
	pi.proc_codigo,
	p.conduta_procedimento_proposto,
	c1.cid_descricao as cid_descricao_primario,
	c2.cid_descricao as cid_descricao_secundario,
	p.data,
	p.hgt,
	p.prof_codigo,
	p.locatend_codigo,
	p.data_sintoma
   FROM
     Internacao_Pep p inner join internacao i on p.inter_codigo = i.inter_codigo
							 inner join pedido_internacao pi on i.pedint_sequencial =  pi.pedint_sequencial
							 left join cid_10 c1 on pi.cid_codigo = c1.cid_codigo
							 left join cid_10 c2 on pi.cid_secundario = c2.cid_codigo

      
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[Ksp_Relatorio_Prescricao_Completa]...';


GO
ALTER PROCEDURE [dbo].[Ksp_Relatorio_Prescricao_Completa]
@PRESC_CODIGO CHAR (12)=NULL, @ATENDAMB_CODIGO CHAR (12)=NULL, @Data CHAR (19)=NULL
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
   FrequenciaFormatada varchar(100)
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
	locint_descricao varchar(200)  
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
		SELECT DISTINCT I.INTER_CODIGO, I.SPA_CODIGO, I.EMER_CODIGO, IA.DOSE_DATA, VWLEITO.LOCINT_DESCRICAO  
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
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao_resumida) > 0 THEN ' + ' + ITPM.diluente_ins_descricao_resumida ELSE ' ' END +
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
	END AS FrequenciaFormatada

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
		SELECT DISTINCT I.INTER_CODIGO, I.SPA_CODIGO, I.EMER_CODIGO, IA.DOSE_DATA, VWLEITO.LOCINT_DESCRICAO  
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
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao_resumida) > 0 THEN ' + ' + ITPM.diluente_ins_descricao_resumida ELSE ' ' END +
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
	END AS FrequenciaFormatada

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
   FrequenciaFormatada varchar(100)
                
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
	  FrequenciaFormatada
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
	   ROW_NUMBER() OVER (ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo) as NumeracaoItem      
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
	   ROW_NUMBER() OVER (ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo) as NumeracaoItem
 FROM #TEMP3
 ORDER BY #TEMP3.OrdenacaoTipoItem, #TEMP3.itpresc_codigo
    
  END           

SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[KSP_ATENDIMENTO_AMBULATORIAL]...';


GO

ALTER PROCEDURE [dbo].[KSP_ATENDIMENTO_AMBULATORIAL]
@atendamb_codigo CHAR (12), @PAC_NOME VARCHAR (50), @local_atendimento VARCHAR (50), @atendamb_datainicio VARCHAR (20), @prof_codigo CHAR (4), @locatend_codigo CHAR (4), @atend_codigo CHAR (12), @pac_codigo CHAR (12), @atendamb_datafinal SMALLDATETIME, @emer_codigo CHAR (12), @spa_codigo CHAR (12), @TP_PESQ SMALLINT, @OPC SMALLINT, @unid_codigo CHAR (4)=null, @idResposta INT=0, @agd_sequencial CHAR (12)=null, @usu_codigo CHAR (4)=null, @ageexa_codigo CHAR (12)=null, @cid_codigo CHAR (9)=null
AS
DECLARE @sql varchar(8000)    
DECLARE @csql varchar(8000)    
DECLARE @par varchar(500)    
DECLARE @par1 varchar(500)    
DECLARE @par2 varchar(500)    
DECLARE @par3 varchar(500)    
DECLARE @var varchar(500)    
    
declare @IdRespostaAtendimentoAmbulatorialCHAR VARCHAR(12)    
declare @codigo as char(12)    
    
set nocount on    
-- selecao --    
if @opc = 0    
   BEGIN    
       
    declare @SQL2 VARCHAR(8000)    
       
    ---cria a #temp vazia    
    SELECT  top 0 a.pac_codigo,isnull(Pac.pac_nome, isnull(E.emer_nome, PA.spa_nome)) pac_nome, isnull(Pac.pac_nome_Social, isnull(E.emer_nome_Social, PA.spa_nome_Social)) pac_nome_social, 
			A.ATEND_CODIGO,loc.locatend_descricao,p.prof_nome,    
            A.ATENDAMB_DATAINICIO,A.ATENDAMB_DATAFINAL,A.LOCATEND_CODIGO,A.PROF_CODIGO,A.emer_codigo,A.spa_codigo,    
            space(10)  proc_codigo,space(250) proc_descricao, a.atendamb_codigo, 0 IdResposta, numero_be.Emer_Numero_BE, numero_pa.spa_numero_pa,    
            isnull(Pac.pac_sexo, isnull(E.emer_sexo, PA.spa_sexo)) sexo,    
            convert(varchar, isnull(Pac.pac_idade, isnull(E.emer_idade, PA.spa_idade))) idade,    
            isnull(Pac.pac_nascimento, isnull(E.emer_nascimento, PA.spa_nascimento)) nascimento, isnull(ac.agd_datahora, isnull(ae.AgeExa_DataHora,isnull(e.emer_chegada, pa.spa_chegada))) chegada,    
     ac.agd_sequencial, ae.ageexa_codigo ,isnull(E.unid_codigo, isnull(Pa.unid_codigo, PAC.unid_codigo)) as 'unid_codigo', a.cid_codigo
    INTO #temp     
    
    FROM ATENDIMENTO_AMBULATORIAL A    
    LEFT JOIN Paciente pac    
      ON a.pac_codigo = pac.pac_codigo    
    LEFT JOIN Emergencia E    
      ON a.emer_codigo = E.emer_codigo    
    LEFT JOIN Pronto_Atendimento PA    
      ON a.spa_codigo = PA.spa_codigo    
    LEFT JOIN Atendimento Atend    
      ON A.atend_codigo = Atend.atend_codigo    
    left JOIN profissional p    
      ON a.prof_codigo = p.prof_codigo     
     AND p.locatend_codigo = a.locatend_codigo    
    left JOIN vwlocal_unidade loc    
      ON a.locatend_codigo = loc.locatend_codigo    
    LEFT JOIN numero_be    
      ON numero_be.emer_codigo = E.emer_codigo    
    LEFT JOIN numero_pa    
      ON numero_pa.spa_codigo = PA.spa_codigo    
    LEFT JOIN agenda_consulta ac 
	  On ac.atend_codigo = a.atend_codigo    
    LEFT JOIN agenda_exame ae 
	  On ae.atend_codigo = a.atend_codigo
    
    SET @SQL =        ' insert into #temp  '    
    SET @SQL = @SQL + ' SELECT  a.pac_codigo,isnull(Pac.pac_nome, isnull(E.emer_nome, PA.spa_nome)) pac_nome, isnull(Pac.pac_nome_social, isnull(E.emer_nome_social, PA.spa_nome_social)) pac_nome_social,'
	SET @SQL = @SQL + ' A.ATEND_CODIGO,loc.locatend_descricao,p.prof_nome,'    
    SET @SQL = @SQL + '  A.ATENDAMB_DATAINICIO,A.ATENDAMB_DATAFINAL,A.LOCATEND_CODIGO,A.PROF_CODIGO,A.emer_codigo,A.spa_codigo,'    
    SET @SQL = @SQL + '  space(7)  proc_codigo,space(75) proc_descricao, a.atendamb_codigo, 0 IdResposta, numero_be.Emer_Numero_BE, numero_pa.spa_numero_pa,'    
    SET @SQL = @SQL + '     isnull(Pac.pac_sexo, isnull(E.emer_sexo, PA.spa_sexo)) sexo,'    
    SET @SQL = @SQL + '     isnull(Pac.pac_idade, isnull(E.emer_idade, PA.spa_idade)) idade,'    
    SET @SQL = @SQL + '     isnull(Pac.pac_nascimento, isnull(E.emer_nascimento, PA.spa_nascimento)) nascimento, isnull(ac.agd_datahora, isnull(ae.AgeExa_DataHora,isnull(e.emer_chegada, pa.spa_chegada))) chegada, ac.agd_sequencial, ae.ageexa_codigo,'    




    SET @SQL = @SQL + '     isnull(E.unid_codigo, isnull(Pa.unid_codigo, PAC.unid_codigo)) unid_codigo, a.cid_codigo'
   
    SET @SQL = @SQL + ' FROM ATENDIMENTO_AMBULATORIAL A'    
    SET @SQL = @SQL + ' LEFT JOIN Paciente pac'    
    SET @SQL = @SQL + '   ON a.pac_codigo = pac.pac_codigo'    
    SET @SQL = @SQL + ' left JOIN Emergencia E'    
    SET @SQL = @SQL + '   ON a.emer_codigo = E.emer_codigo'    
    SET @SQL = @SQL + ' left JOIN Pronto_Atendimento PA'    
    SET @SQL = @SQL + '   ON a.spa_codigo = PA.spa_codigo'    
    SET @SQL = @SQL + ' left JOIN Atendimento Atend'    
    SET @SQL = @SQL + '   ON A.atend_codigo = Atend.atend_codigo'    
    SET @SQL = @SQL + ' left JOIN profissional p'    
     SET @SQL = @SQL + '   ON p.prof_codigo = a.prof_codigo '    
     SET @SQL = @SQL + '  and p.locatend_codigo = a.locatend_codigo'    
    SET @SQL = @SQL + ' LEFT JOIN vwlocal_unidade loc'    
    SET @SQL = @SQL + '   ON a.locatend_codigo = loc.locatend_codigo AND loc.unid_codigo = ''' + @unid_codigo + ''' '    
    SET @SQL = @SQL + ' LEFT JOIN numero_be'    
    SET @SQL = @SQL + '   ON numero_be.emer_codigo = E.emer_codigo'    
    SET @SQL = @SQL + ' LEFT JOIN numero_pa'    
    SET @SQL = @SQL + '   ON numero_pa.spa_codigo = PA.spa_codigo'    
    SET @SQL = @SQL + ' left join agenda_consulta ac on ac.atend_codigo = a.atend_codigo'   
	SET @SQL = @SQL + ' left join agenda_exame ae on ae.atend_codigo = a.atend_codigo'   
	 
    SET @SQL = @SQL + ' where 1 = 1 '    
    
 SET @SQL2 = ''      
    if @emer_codigo is not null    
        SET @SQL2 = @SQL2 + '  and a.emer_codigo is not null'    
    if @spa_codigo is not null    
        SET @SQL2 = @SQL2 + '  and a.spa_codigo is not null'    
    if @atend_codigo is not null    
        SET @SQL2 = @SQL2 + '  and a.atend_codigo is not null'    
    if @agd_sequencial is not null    
        SET @SQL2 = @SQL2 + '  and ac.agd_sequencial = ''' + @agd_sequencial + ''''    
    if @ageexa_codigo is not null    
        SET @SQL2 = @SQL2 + '  and ae.ageexa_codigo = ''' + @ageexa_codigo + ''''    
    if @atendamb_codigo is not null        
      begin                    
        SET @SQL2 = @SQL2 + '  and A.ATENDAMB_CODIGO = ' + '''' + @atendamb_codigo + ''''
		SET @SQL2 = @SQL2 + '  DECLARE @p_cod CHAR(10) '
		SET @SQL2 = @SQL2 + '  DECLARE @p_desc VARCHAR(250) '
		SET @SQL2 = @SQL2 + ' select @p_cod = procamb_codigo from procedimento_ambulatorial_real where atendamb_codigo = ' + '''' + @atendamb_codigo + ''''
        SET @SQL2 = @SQL2 + ' UPDATE #temp set '    
        SET @SQL2 = @SQL2 + '  proc_codigo = t.procamb_codigo, '    
        SET @SQL2 = @SQL2 + '  proc_descricao = t.procamb_descricao'    
        SET @SQL2 = @SQL2 + ' FROM ( SELECT TOP 1 a.procamb_codigo,a.procamb_descricao '    
        SET @SQL2 = @SQL2 + '   FROM procedimento_ambulatorial a  '   
        SET @SQL2 = @SQL2 + '   WHERE a.procamb_codigo = ' + '''' + @atendamb_codigo + '''' + ') t'      
      end    
    else       
      begin        
        if @emer_codigo is not null    
          begin    
            if len(@emer_codigo) < 12    
                SET @SQL2 = @SQL2 + ' and numero_be.Emer_Numero_BE = ' + '''' + rtrim(ltrim(@emer_codigo))+ ''''                 
            else    
            SET @SQL2 = @SQL2 + '  and e.emer_codigo = ' + '''' + @emer_codigo + ''''    
          end    
        if @spa_codigo is not null    
          begin    
            if len(@spa_codigo) < 12    
                SET @SQL2 = @SQL2 + '  and numero_pa.spa_numero_pa = ' + '''' + rtrim(ltrim(@spa_codigo)) + ''''      
            else    
                SET @SQL2 = @SQL2 + '  and pa.spa_codigo = ' + '''' + @spa_codigo + ''''      
          end    
        if @atend_codigo is not null    
          begin    
                SET @SQL2 = @SQL2 + '  and Atend.atend_codigo = ' + '''' + @atend_codigo + ''''      
          end    
      end    
          
    IF (@SQL2 <> '')    
    BEGIN    
    
	SET @SQL = @SQL + @SQL2  
	 print(@sql)       
     exec(@sql)      
    
	END    
    
    SELECT * FROM #temp    
    DROP TABLE #temp    
   END    
    
---------------------------------------- Inclusao ----------------------------------------------    
if @opc = 1    
   BEGIN    
    
  if @emer_codigo is not null    
          begin    
            if len(@emer_codigo) < 12    
                select @emer_codigo = emer_codigo from numero_be where Emer_Numero_BE =  rtrim(ltrim(@emer_codigo))    
          end    
        if @spa_codigo is not null    
          begin    
            if len(@spa_codigo) < 12    
    select @spa_codigo = spa_codigo from numero_pa where spa_Numero_pa =  rtrim(ltrim(@spa_codigo))    
          end    
              
 declare @data varchar(10)    
 set @data = Convert (varchar, getdate (), 103)    
    
 EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,     
         @Chave      = 'ATENDAMB' ,     
         @data       = @data,     
         @NovoCodigo = @atendamb_codigo OUTPUT    
     
 INSERT INTO atendimento_ambulatorial     
  (atendamb_codigo,prof_codigo,locatend_codigo,atend_codigo,pac_codigo,atendamb_datainicio,    
  atendamb_datafinal,emer_codigo,spa_codigo,usu_codigo,usu_dt_hora_baixa, cid_codigo)     
 VALUES     
  (@atendamb_codigo,@prof_codigo,@locatend_codigo,@atend_codigo,@pac_codigo,convert(smalldatetime, @atendamb_datainicio, 101),    
  @atendamb_datafinal,@emer_codigo,@spa_codigo,@usu_codigo,GETDATE(), @cid_codigo) 
  
  if (@atendamb_datafinal is not null)    
  Begin    
       
 exec ksp_sos_emergencia_servico   
 null, --@ACO_CODIGO  
 @SPA_Codigo, --@SPA_Codigo  
 @EMER_CODIGO, --@EMER_CODIGO  
 null, --@upaclaris_codigo  
 @atendamb_codigo, --@Atendamb_Codigo  
 null, --@Atendamb_Observacao   
 null, --@Atendamb_TipSai  
 0,    --@OPCAO  
 null  --@TP_PESQ    
  End    
  
    
    
 if @idResposta > 0    
    begin    
    
   /* Busca o Código */    
   EXEC ksp_controle_sequencial @Unidade    = '0000' ,     
           @Chave      = 'Resposta_Atendimento_Ambulatorial' ,     
           @data       = '01/01/1900',     
           @Opcao      = 1,    
           @NovoCodigo = @IdRespostaAtendimentoAmbulatorialCHAR OUTPUT    
    
    
   Insert into Resposta_Atendimento_Ambulatorial    
    (IdRespostaAtendimentoAmbulatorial,atendamb_codigo,IdResposta)    
   values ( CAST(@IdRespostaAtendimentoAmbulatorialCHAR AS INT), @atendamb_codigo,@idResposta)    
    end    
    
 SELECT @atendamb_codigo    
    
   END    
    
--------------------------------------- Alteracao ------------------------------------------------    
if @opc = 2    
   BEGIN    
 UPDATE atendimento_ambulatorial SET      
  prof_codigo  = @prof_codigo,    
  locatend_codigo  = @locatend_codigo,    
  atend_codigo  = @atend_codigo,    
  atendamb_datainicio = convert(smalldatetime, @atendamb_datainicio, 101),    
  atendamb_datafinal = @atendamb_datafinal,
  cid_codigo = @cid_codigo              
 WHERE atendamb_codigo  =       @atendamb_codigo   
 
 if (@atendamb_datafinal is not null)    
  Begin    
       
 exec ksp_sos_emergencia_servico   
 null, --@ACO_CODIGO  
 @SPA_Codigo, --@SPA_Codigo  
 @EMER_CODIGO, --@EMER_CODIGO  
 null, --@upaclaris_codigo  
 @atendamb_codigo, --@Atendamb_Codigo  
 null, --@Atendamb_Observacao   
 null, --@Atendamb_TipSai  
 0,    --@OPCAO  
 null  --@TP_PESQ    
  End    
    
 if @idResposta > 0    
    begin    
   /* Busca o Código */    
   EXEC ksp_controle_sequencial @Unidade    = '0000' ,     
           @Chave      = 'Resposta_Atendimento_Ambulatorial' ,     
           @data       = '01/01/1900',     
           @Opcao      = 1,    
           @NovoCodigo = @IdRespostaAtendimentoAmbulatorialCHAR OUTPUT    
    
   Insert into Resposta_Atendimento_Ambulatorial    
    (IdRespostaAtendimentoAmbulatorial,atendamb_codigo,IdResposta)    
   values ( CAST(@IdRespostaAtendimentoAmbulatorialCHAR AS INT), @atendamb_codigo,@idResposta)    
    end    
    
    
   END    
    
----------------------------------------- exclusao -------------------------------------------------    
if @opc = 3    
   BEGIN    
 declare @Erro int    
 set @Erro = 0    
    
 DELETE from PROCEDIMENTO_AMBULATORIAL_REAL     
  WHERE atendamb_codigo = @atendamb_codigo      
 set @Erro = @Erro + @@error    
    
 DELETE from META_PROCEDIMENTO_AMBULATORIAL_REAL     
  WHERE atendamb_codigo = @atendamb_codigo      
 set @Erro = @Erro + @@error    
    
 DELETE FROM Resposta_Atendimento_Ambulatorial     
  WHERE atendamb_codigo = @atendamb_codigo      
 set @Erro = @Erro + @@error    
    
    
 if exists ( select 1 from upa_obito where     
   emer_codigo in (select emer_codigo from atendimento_ambulatorial    
      WHERE atendamb_codigo = @atendamb_codigo)    
   or     
   spa_codigo in (select spa_codigo from atendimento_ambulatorial    
      WHERE atendamb_codigo = @atendamb_codigo)     
   or     
   atend_codigo in (select atend_codigo from atendimento_ambulatorial    
      WHERE atendamb_codigo = @atendamb_codigo)    
  ) begin    
    
  --Chamado 5393: Se teve óbito no atendimento, e desde que o paciente não tenha ALTA por óbito, ou declaracao de óbito, retirar o óbito.    
  update paciente    
   set pac_dtobito = null    
  where pac_codigo in (  select e.pac_codigo from emergencia e --paciente no BE    
     inner join atendimento_ambulatorial a on a.emer_codigo = e.emer_codigo    
     WHERE a.atendamb_codigo = @atendamb_codigo    
     union    
     select p.pac_codigo from pronto_atendimento p --paciente no PA    
     inner join atendimento_ambulatorial a on a.spa_codigo = p.spa_codigo    
     WHERE a.atendamb_codigo = @atendamb_codigo    
     union    
     select ate.pac_codigo from atendimento ate  --paciente no CHECKIN    
     inner join atendimento_ambulatorial a on a.atend_codigo = ate.atend_codigo    
     WHERE a.atendamb_codigo = @atendamb_codigo    
     )    
  and pac_codigo not in ( select i.pac_codigo from internacao i  --Sem internacao com saída OBITO    
     inner join motivo_cobranca_aih m on m.motcob_codigo = i.inter_motivo_alta    
     where m.motcob_tipo = 'O' )    
    
  and pac_codigo not in ( select O.pac_codigo from OBITO O where pac_codigo is not null)  --Sem DECLARACAO DE OBITO    
  set @Erro = @Erro + @@error    
 end    
    
 DELETE FROM upa_obito where     
  emer_codigo in (select emer_codigo from atendimento_ambulatorial    
     WHERE atendamb_codigo = @atendamb_codigo)    
  or    
    
  spa_codigo in (select spa_codigo from atendimento_ambulatorial    
     WHERE atendamb_codigo = @atendamb_codigo)    
    
  or    
    
  atend_codigo in (select atend_codigo from atendimento_ambulatorial    
     WHERE atendamb_codigo = @atendamb_codigo)    
 set @Erro = @Erro + @@error    
    
 DELETE FROM atendimento_clinico     
  WHERE atendamb_codigo = @atendamb_codigo    
 set @Erro = @Erro + @@error    
     
  DELETE FROM UPA_Atendimento_Medico     
  WHERE atendamb_codigo = @atendamb_codigo    
 set @Erro = @Erro + @@error    
        
 -- EXCLUSAO DA INTENACAO    
 declare @inter_codigo char(12)    
 declare @LOGIN_USUARIO varchar(50)    
 declare @Lei_Codigo char(04)    
 declare @Cid_Codigo_I char(09)    
 declare @Inter_DataInter smalldatetime    
 declare @Inter_DtAlta smalldatetime    
 declare @Inter_Motivo_Alta char(02)    
     
     
 select @LOGIN_USUARIO = usu_login     
  from usuario     
  where usu_codigo = @usu_codigo    
        
        
 select @inter_codigo = inter_codigo, @Inter_DataInter = Inter_DataInter    
  from internacao     
  where emer_codigo in (select emer_codigo from atendimento_ambulatorial    
    WHERE atendamb_codigo = @atendamb_codigo)    
  or spa_codigo in (select spa_codigo from atendimento_ambulatorial    
    WHERE atendamb_codigo = @atendamb_codigo)    
    
 if @inter_codigo is not null    
 begin    
  exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'EXCLUSAO', '2' /* exclusao */, null, null, 'Exclusao da Baixa de Boletim', @unid_codigo    
  set @Erro = @Erro + @@error    
    
  SELECT     
   @LocAtend_Codigo = locatend_leito,     
   @Lei_Codigo  = lei_codigo,    
   @Inter_DtAlta  = inter_dtalta,    
   @Cid_Codigo_I = P.cid_codigo,    
   @Inter_Motivo_Alta = inter_motivo_alta,    
   @pac_codigo = internacao.pac_codigo    
  FROM  internacao
	LEFT JOIN PEDIDO_INTERNACAO P ON internacao.PEDINT_SEQUENCIAL = P.PEDINT_SEQUENCIAL 
  WHERE  inter_codigo = @Inter_Codigo
    
  delete from NOTIFICACAO_COMPULSORIA where pac_codigo = @pac_codigo and cid_codigo = @Cid_Codigo_I    
  set @Erro = @Erro + @@error    
    
  DELETE FROM movimentacao_paciente WHERE inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM auditor_procedimento    
  FROM  espelho_aih, auditor_procedimento    
   WHERE  auditor_procedimento.aih_sequencial = espelho_aih.aih_sequencial    
   AND  espelho_aih.inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM paciente_aih FROM  espelho_aih, paciente_aih WHERE  paciente_aih.aih_sequencial = espelho_aih.aih_sequencial     
  AND  espelho_aih.inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM atos_profissionais FROM  espelho_aih, atos_profissionais WHERE  atos_profissionais.aih_sequencial = espelho_aih.aih_sequencial     
  AND  espelho_aih.inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM previsao_faturamento FROM  espelho_aih, previsao_faturamento    
  WHERE  previsao_faturamento.aih_sequencial = espelho_aih.aih_sequencial    
  AND  espelho_aih.inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM Cartao_Visita    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM restricao_visita    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM espelho_aih    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM resumo_alta_procedimento    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM resumo_alta    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM procedimentos_realizados    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM internacao_parto    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM evolucao    
  WHERE inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM INTERNACAO_CLINICA_ATUAL    
  WHERE inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DELETE FROM INTERNACAO_PID    
  WHERE inter_codigo =  @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  SELECT @LocAtend_Codigo = locatend_codigo    
  FROM  internacao    
  WHERE  inter_codigo = @Inter_Codigo    
    
    
  DELETE from internacao_procedimento_cid    
  WHERE INTER_CODIGO = @Inter_Codigo    
  set @Erro = @Erro + @@error    
    
  DECLARE @mov char(12)    
  if exists( select 1 from movimentacao_prontuario     
  where pac_codigo = @Pac_Codigo     
  and convert(char(10),mov_data_prevista,120) = convert(char(10),@Inter_DataInter,120)    
  and locatend_codigo = @LocAtend_Codigo    
  and prof_codigo = @Prof_Codigo    
  and MovProntStat_Codigo = 0 )    
  begin    
   select @mov = mov_sequencial    
   from movimentacao_prontuario     
   where pac_codigo = @Pac_Codigo     
   and convert(char(10),mov_data_prevista,120) = convert(char(10),@Inter_DataInter,120)    
   and locatend_codigo = @LocAtend_Codigo    
   and prof_codigo = @Prof_Codigo    
   and MovProntStat_Codigo = 0    
    
   delete from registro_movimentacao_prontuario where mov_sequencial = @mov    
   delete from movimentacao_prontuario where mov_sequencial = @mov    
    
  end    
      
      
  DELETE FROM internacao    
  WHERE  inter_codigo = @Inter_Codigo    
  set @Erro = @Erro + @@error     
    
  UPDATE LEITO                              
  SET lei_status = 'L'                              
  WHERE lei_status = 'O'                               
  and  not exists                              
  (select 1                               
  from internacao                               
  where inter_dtalta is null                              
  and leito.locatend_codigo = internacao.locatend_LEITO                              
  and leito.lei_codigo = internacao.lei_codigo)                              
  set @Erro = @Erro + @@error                              
  UPDATE LEITO                              
  SET lei_status = 'O'                              
  WHERE exists                              
  (select 1                              
  from internacao                               
  where inter_dtalta is null                              
  and leito.locatend_codigo = internacao.locatend_LEITO                              
  and leito.lei_codigo = internacao.lei_codigo)                              
  set @Erro = @Erro + @@error               
    
 end    
 DELETE FROM atendimento_ambulatorial     
  WHERE atendamb_codigo = @atendamb_codigo      
    set @Erro = @Erro + @@error      
      
 set @Erro = @Erro + @@error    
    
 IF (@Erro <> 0)BEGIN    
  RAISERROR('ERRO !!!  - Ksp_Atendimento_Ambulatorial - ',1,1)    
  RETURN    
 END    
    
   END    
    
--------------------------------------------------------------------------------------------------    
IF @OPC = 4    
   BEGIN    
    
 IF @SPA_CODIGO is not Null    
    BEGIN    
  SET @SQL =    ' SELECT A.ATENDAMB_CODIGO ATENDCOD,LA.locatend_descricao CLINICA, p.spa_NOME  PACNOME, '    
  SET @SQL = @SQL + ' CONVERT(VARCHAR,A.ATENDAMB_DATAINICIO,103) + '' '' + CONVERT(VARCHAR,ATENDAMB_DATAINICIO,108) DATAATEND,'    
  SET @SQL = @SQL + ' A.pac_codigo paccod, a.atend_codigo,a.emer_codigo,a.spa_codigo, A.ATENDAMB_DATAFINAL, A.prof_codigo, A.locatend_codigo,'    
  SET @SQL = @SQL + ' p.spa_idade idade, p.spa_sexo sexo, A.cid_codigo'    
  SET @SQL = @SQL + ' FROM (ATENDIMENTO_AMBULATORIAL A LEFT JOIN pronto_Atendimento P ON '    
  SET @SQL = @SQL + '  A.spa_codigo = P.spa_codigo),vwlocal_unidade LA  '    
  SET @SQL = @SQL + ' WHERE LA.LOCATEND_CODIGO = A.LOCATEND_CODIGO '    
  SET @SQL = @SQL + '   AND A.ATENDAMB_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''    
    
  IF @spa_codigo  is not null    
    begin    
   set @var = convert(varchar,@spa_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.spa_codigo ",@tp_pesq,"T" ,@par output      
   end     
    
  IF @pac_nome is not null    
    begin    
   set @var = convert(varchar,@pac_nome)    
   Exec ksp_ParametroPesquisa @pac_nome,"AND P.SPA_nome",@tp_pesq,"T" ,@par output    
    end    
    
  SET @SQL = (@sql + ' ' + @par)    
    
  SET @SQL = @SQL + ' AND P.SPA_nome IS NOT NULL '    
    
     END    
    
    
 IF @EMER_CODIGO is not Null    
    BEGIN    
  SET @SQL =    ' SELECT A.ATENDAMB_CODIGO ATENDCOD,LA.locatend_descricao CLINICA, e.emer_NOME  PACNOME, '    
  SET @SQL = @SQL + ' CONVERT(VARCHAR,A.ATENDAMB_DATAINICIO,103) + '' '' + CONVERT(VARCHAR,ATENDAMB_DATAINICIO,108) DATAATEND,'    
  SET @SQL = @SQL + ' A.pac_codigo paccod, a.atend_codigo, a.emer_codigo, a.spa_codigo, a.prof_codigo, a.locatend_codigo, a.atendamb_datafinal, A.cid_codigo '    
  SET @SQL = @SQL + ' FROM (ATENDIMENTO_AMBULATORIAL A LEFT JOIN emergencia e ON '    
  SET @SQL = @SQL + '  A.emer_codigo = e.emer_codigo),vwlocal_unidade LA  '    
  SET @SQL = @SQL + ' WHERE LA.LOCATEND_CODIGO = A.LOCATEND_CODIGO '    
  SET @SQL = @SQL + '   AND A.ATENDAMB_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''    
      
  IF @EMER_codigo is not null    
    begin    
   set @var = convert(varchar,@emer_codigo)    
     
   Exec ksp_ParametroPesquisa @var,"AND e.emer_codigo",@tp_pesq,"T" ,@par output      
    End    
    
  IF @pac_nome is not null    
    begin    
   set @var = convert(varchar,@pac_nome)    
   Exec ksp_ParametroPesquisa @pac_nome,"AND E.EMER_nome",@tp_pesq,"T" ,@par output    
    end    
    
  SET @SQL = (@sql + ' ' + @par)    
     END    
    
 IF @SPA_CODIGO is Null AND @EMER_CODIGO is Null    
       BEGIN    
  SET @SQL =    ' SELECT A.ATENDAMB_CODIGO ATENDCOD,LA.locatend_descricao CLINICA, PAC.PAC_NOME PACNOME, '    
  SET @SQL = @SQL + ' CONVERT(VARCHAR,A.ATENDAMB_DATAINICIO,103) + '' '' + CONVERT(VARCHAR,ATENDAMB_DATAINICIO,108) DATAATEND,'     
  SET @SQL = @SQL + ' A.pac_codigo paccod,a.atend_codigo,a.emer_codigo,a.spa_codigo, a.prof_codigo, a.locatend_codigo, a.atendamb_datafinal,'    
  SET @SQL = @SQL + ' convert(varchar,pac.pac_idade) idade, pac.pac_sexo sexo, A.cid_codigo'    
  SET @SQL = @SQL + ' FROM ATENDIMENTO_AMBULATORIAL A, PACIENTE PAC, '    
  SET @SQL = @SQL + '   vwlocal_unidade LA '    
  SET @sql = @sql + ' WHERE LA.LOCATEND_CODIGO = A.LOCATEND_CODIGO '    
  SET @sql = @sql + '   AND A.PAC_CODIGO = PAC.PAC_CODIGO '    
  SET @SQL = @SQL + '   AND A.ATENDAMB_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''    
        
     
  IF @pac_nome is not null    
    begin    
   set @var = convert(varchar,@pac_nome)    
   Exec ksp_ParametroPesquisa @pac_nome,"AND pac.pac_nome",@tp_pesq,"T" ,@par output      
    end    
     
  IF @atendamb_codigo is not null    
    begin    
   set @var = convert(varchar,@atendamb_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND a.atendamb_codigo",@tp_pesq,"T" ,@par output      
    End    
     
  IF @atendamb_datainicio  is not null    
    begin    
   set @var = @atendamb_datainicio    
   Exec ksp_ParametroPesquisa @var,"AND convert(char(10),a.atendamb_datainicio,103)",@tp_pesq,"T" ,@par output      
    end    
         
  IF @local_atendimento  is not null    
    begin    
   set @var = convert(varchar,@local_atendimento)    
   Exec ksp_ParametroPesquisa @var,"AND LA.locatend_descricao ",@tp_pesq,"T" ,@par output      
   end    
      
  IF @Atend_codigo  is not null    
    begin    
   set @var = convert(varchar,@Atend_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.Atend_codigo ",@tp_pesq,"T" ,@par output      
   end    
    
  IF @pac_codigo  is not null    
    begin    
   set @var = convert(varchar,@pac_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.pac_codigo",@tp_pesq,"T" ,@par output      
   end    
    
  SET @SQL = (@sql + ' ' + @par)    
      
  SET @SQL = @SQL + ' UNION '    
      
  SET @SQL = @SQL + ' SELECT A.ATENDAMB_CODIGO ATENDCOD,LA.locatend_descricao CLINICA, E.EMER_NOME PACNOME, '    
  SET @SQL = @SQL + ' CONVERT(VARCHAR,A.ATENDAMB_DATAINICIO,103) + '' '' + CONVERT(VARCHAR,ATENDAMB_DATAINICIO,108) DATAATEND,'     
  SET @SQL = @SQL + ' A.pac_codigo paccod,a.atend_codigo,a.emer_codigo,a.spa_codigo, a.prof_codigo, a.locatend_codigo, a.atendamb_datafinal,'    
  SET @SQL = @SQL + ' e.emer_idade idade, e.emer_sexo sexo, A.cid_codigo'    
  SET @SQL = @SQL + ' FROM ATENDIMENTO_AMBULATORIAL A, EMERGENCIA E, '    
  SET @SQL = @SQL + '   vwlocal_unidade LA '    
  SET @sql = @sql + ' WHERE LA.LOCATEND_CODIGO = A.LOCATEND_CODIGO '    
  SET @sql = @sql + '   AND A.EMER_CODIGO = E.EMER_CODIGO '      
  SET @SQL = @SQL + '   AND A.ATENDAMB_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''    
        
     
  IF @pac_nome is not null    
    begin    
   set @var = convert(varchar,@pac_nome)    
   Exec ksp_ParametroPesquisa @pac_nome,"AND e.emer_nome",@tp_pesq,"T" ,@par output      
    end    
     
  IF @atendamb_codigo is not null    
    begin    
   set @var = convert(varchar,@atendamb_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND a.atendamb_codigo",@tp_pesq,"T" ,@par output      
    End    
     
  IF @atendamb_datainicio  is not null    
    begin    
   set @var = @atendamb_datainicio    
   Exec ksp_ParametroPesquisa @var,"AND convert(char(10),a.atendamb_datainicio,103)",@tp_pesq,"T" ,@par output      
    end    
         
  IF @local_atendimento  is not null    
    begin    
   set @var = convert(varchar,@local_atendimento)    
   Exec ksp_ParametroPesquisa @var,"AND LA.locatend_descricao ",@tp_pesq,"T" ,@par output      
   end    
      
  IF @Atend_codigo  is not null    
    begin    
   set @var = convert(varchar,@Atend_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.Atend_codigo ",@tp_pesq,"T" ,@par output      
   end    
    
  IF @pac_codigo  is not null    
    begin    
   set @var = convert(varchar,@pac_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.pac_codigo",@tp_pesq,"T" ,@par output      
   end    
    
    
  SET @SQL = (@sql + ' ' + @par)    
      
  SET @SQL = @SQL + ' UNION '    
      
  SET @SQL = @SQL + ' SELECT A.ATENDAMB_CODIGO ATENDCOD,LA.locatend_descricao CLINICA, PA.SPA_NOME PACNOME, '    
  SET @SQL = @SQL + ' CONVERT(VARCHAR,A.ATENDAMB_DATAINICIO,103) + '' '' + CONVERT(VARCHAR,ATENDAMB_DATAINICIO,108) DATAATEND,'     
  SET @SQL = @SQL + ' A.pac_codigo paccod,a.atend_codigo,a.emer_codigo,a.spa_codigo, a.prof_codigo, a.locatend_codigo, a.atendamb_datafinal, '    
  SET @SQL = @SQL + ' pa.spa_idade idade, pa.spa_sexo sexo, A.cid_codigo'    
  SET @SQL = @SQL + ' FROM ATENDIMENTO_AMBULATORIAL A, PRONTO_ATENDIMENTO PA, '    
  SET @SQL = @SQL + '   vwlocal_unidade LA '    
  SET @sql = @sql + ' WHERE LA.LOCATEND_CODIGO = A.LOCATEND_CODIGO '    
  SET @sql = @sql + '   AND A.SPA_CODIGO = PA.SPA_CODIGO '      
  SET @SQL = @SQL + '   AND A.ATENDAMB_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''    
        
     
  IF @pac_nome is not null    
    begin    
   set @var = convert(varchar,@pac_nome)    
   Exec ksp_ParametroPesquisa @pac_nome,"AND pa.spa_nome",@tp_pesq,"T" ,@par output      
    end    
     
  IF @atendamb_codigo is not null    
    begin    
   set @var = convert(varchar,@atendamb_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND a.atendamb_codigo",@tp_pesq,"T" ,@par output      
    End    
     
 IF @atendamb_datainicio  is not null    
    begin    
   set @var = @atendamb_datainicio    
   Exec ksp_ParametroPesquisa @var,"AND convert(char(10),a.atendamb_datainicio,103)",@tp_pesq,"T" ,@par output      
    end    
         
  IF @local_atendimento  is not null    
    begin    
   set @var = convert(varchar,@local_atendimento)    
   Exec ksp_ParametroPesquisa @var,"AND LA.locatend_descricao ",@tp_pesq,"T" ,@par output      
   end    
      
  IF @Atend_codigo  is not null    
    begin    
   set @var = convert(varchar,@Atend_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.Atend_codigo ",@tp_pesq,"T" ,@par output      
   end    
    
  IF @pac_codigo  is not null    
    begin    
   set @var = convert(varchar,@pac_codigo)    
   Exec ksp_ParametroPesquisa @var,"AND A.pac_codigo",@tp_pesq,"T" ,@par output      
   end    
    
   SET @SQL = (@sql + ' ' + @par)    
    END      
    
 Exec (@sql)    
     
end        
    
------------------------------------------------------------------------------------------------    
IF @OPC = 5    
   BEGIN    
 SELECT VW.LOCATEND_DESCRICAO  CLINICA,    
  PROF.PROF_NOME   PROFISSIONAL,    
  AA.ATENDAMB_DATAINICIO  INICIO,    
  AA.ATENDAMB_DATAFINAL  FIM,    
  AC.ATENDAMB_MOTIVO  MOTIVO_ATENDIMENTO,    
  AC.ATENDAMB_EXAME_FISICO EXAME_FISICO,    
  CID_PRINCIPAL.CID_DESCRICAO DIAGNOSTICO_PRINCIPAL,    
  CID_SECUNDARIO.CID_DESCRICAO DIAGNOSTICO_SECUNDARIO,    
  ENCAMINHAMENTO =     
  Case AC.ATENDAMB_ENCAMINHAMENTO    
   WHEN '1' THEN 'Exame'    
   WHEN '2' THEN 'Terapia'    
   WHEN '3' THEN 'Serviço'    
   WHEN '4' THEN 'Internação'    
   WHEN '5' THEN 'Remoção'    
   WHEN '6' THEN 'Emergência'    
  End,    
  AA.ATENDAMB_CODIGO  ATENDAMB_CODIGO    
     
 FROM ATENDIMENTO_AMBULATORIAL AA,    
  ATENDIMENTO_CLINICO  AC,    
  vwlocal_unidade  VW,    
  PROFISSIONAL   PROF,    
  CID_10    CID_PRINCIPAL,    
  CID_10    CID_SECUNDARIO    
 WHERE   AA.PAC_CODIGO = @pac_codigo    
 AND AA.ATENDAMB_CODIGO = AC.ATENDAMB_CODIGO    
 AND AA.LOCATEND_CODIGO = PROF.LOCATEND_CODIGO    
 AND AA.PROF_CODIGO = PROF.PROF_CODIGO    
 AND AA.LOCATEND_CODIGO = VW.LOCATEND_CODIGO    
 AND AC.CID_CODIGO = CID_PRINCIPAL.CID_CODIGO    
 AND AC.CID_SECUNDARIO = CID_SECUNDARIO.CID_CODIGO    
 AND VW.UNID_CODIGO = ISNULL(@UNID_CODIGO, VW.UNID_CODIGO)    
    
 UNION ALL    
    
 SELECT VW.LOCATEND_DESCRICAO  CLINICA,    
  PROF.PROF_NOME   PROFISSIONAL,    
  AA.ATENDAMB_DATAINICIO  INICIO,    
  AA.ATENDAMB_DATAFINAL  FIM,    
  AC.ATENDAMB_MOTIVO  MOTIVO_ATENDIMENTO,    
  AC.ATENDAMB_EXAME_FISICO EXAME_FISICO,    
  NULL    DIAGNOSTICO_PRINCIPAL,    
  NULL    DIAGNOSTICO_SECUNDARIO,    
  ENCAMINHAMENTO =     
  Case AC.ATENDAMB_ENCAMINHAMENTO    
   WHEN '1' THEN 'Exame'    
   WHEN '2' THEN 'Terapia'    
   WHEN '3' THEN 'Serviço'    
   WHEN '4' THEN 'Internação'    
   WHEN '5' THEN 'Remoção'    
   WHEN '6' THEN 'Emergência'    
  End,    
  AA.ATENDAMB_CODIGO  ATENDAMB_CODIGO    
     
 FROM ATENDIMENTO_AMBULATORIAL AA
	LEFT JOIN ATENDIMENTO_CLINICO  AC ON AA.ATENDAMB_CODIGO = AC.ATENDAMB_CODIGO
	INNER JOIN vwlocal_unidade  VW ON AA.LOCATEND_CODIGO = VW.LOCATEND_CODIGO 
	INNER JOIN PROFISSIONAL   PROF ON AA.LOCATEND_CODIGO = PROF.LOCATEND_CODIGO AND AA.PROF_CODIGO = PROF.PROF_CODIGO
    
 WHERE   AA.PAC_CODIGO = @pac_codigo 
 AND  AA.ATENDAMB_CODIGO NOT IN (    
  SELECT AA.ATENDAMB_CODIGO  ATENDAMB_CODIGO    
     
  FROM ATENDIMENTO_AMBULATORIAL AA,    
   ATENDIMENTO_CLINICO  AC,    
   vwlocal_unidade  VW,    
   PROFISSIONAL   PROF,    
   CID_10    CID_PRINCIPAL,    
   CID_10    CID_SECUNDARIO    
    
  WHERE   AA.PAC_CODIGO = @pac_codigo    
  AND AA.ATENDAMB_CODIGO = AC.ATENDAMB_CODIGO    
  AND AA.LOCATEND_CODIGO = PROF.LOCATEND_CODIGO    
  AND AA.PROF_CODIGO = PROF.PROF_CODIGO    
  AND AA.LOCATEND_CODIGO = VW.LOCATEND_CODIGO    
  AND AC.CID_CODIGO = CID_PRINCIPAL.CID_CODIGO    
  AND AC.CID_SECUNDARIO = CID_SECUNDARIO.CID_CODIGO    
  AND VW.UNID_CODIGO = ISNULL(@UNID_CODIGO, VW.UNID_CODIGO)    
     )    
   END        
    
-----------------------------------------------------------------------------------------    
    
If @OPC = 7    
   -- Seleciona os dados de Chekin selecionado para o Atendimento Ambulatorial    
   BEGIN    
 SELECT  A.atend_codigo,    
  A.atend_data,    
  A.locatend_codigo,    
  VW.locatend_descricao,    
  A.pac_codigo,    
  A.atend_queixa,    
  ac.agd_sequencial    
 FROM  atendimento A inner join  vwlocal_unidade VW on A.locatend_codigo = VW.locatend_codigo    
  left join agenda_consulta ac on ac.atend_codigo = a.atend_codigo    
 WHERE  A.atend_codigo = @AtendAmb_codigo    
      
    
   END    
    
-----------------------------------------------------------------------------------------    
    
If @OPC = 8    
   BEGIN     
    
 SELECT  ED.emer_codigo,    
  ED.emer_chegada,    
  ED.locatend_codigo,    
  VW.locatend_descricao,    
  ED.pac_codigo,    
  ED.emer_nome,    
        ED.emer_sexo,    
        ED.emer_idade,    
        ED.emer_nascimento    
 FROM atendimento_ambulatorial aa,    
  emergencia ED,    
  vwlocal_unidade VW    
 WHERE aa.atendamb_codigo = @atendamb_codigo    
 AND ED.emer_codigo = aa.emer_codigo    
 AND ED.locatend_codigo = VW.locatend_codigo    
    
   END    
    
-----------------------------------------------------------------------------------------    
    
If @OPC = 9    
   BEGIN    
 SELECT  PA.spa_codigo,    
  PA.spa_chegada,    
  PA.locatend_codigo,    
  VW.locatend_descricao,    
  PA.pac_codigo,    
  PA.spa_nome    
 FROM atendimento_ambulatorial aa,    
  pronto_atendimento pa ,    
  vwlocal_unidade VW    
 WHERE aa.atendamb_codigo = @AtendAmb_codigo    
 AND PA.spa_codigo = aa.spa_codigo    
 AND  PA.locatend_codigo = VW.locatend_codigo    
    
    
   END    
    
-----------------------------------------------------------------------------------------    
    
IF @OPC = 10    
   -- Seleciona o codigo do paciente da Emergencia    
   BEGIN    
 SELECT pac_codigo    
  FROM emergencia    
  WHERE emer_codigo = @Emer_codigo     
   END    
    
-----------------------------------------------------------------------------------------    
    
IF @OPC = 11    
   -- Seleciona o codigo do paciente da Pronto Atendimento    
   BEGIN    
 SELECT pac_codigo    
  FROM pronto_Atendimento    
  WHERE spa_codigo = @Spa_codigo    
     
   END    
    
-----------------------------------------------------------------------------------------    
    
-- SELECIONA OS ATENDIMENTO DE SPA, EMERGENCIA E ATENDIMENTO QUE NÃO TENHA ATENDIMENTO_AMBULATORIAL    
-- UTILIZADO PARA PREENCHER A COMBO DE ATENDIMENTOS DO PEP.    
if (@OPC = 12)    
BEGIN    
 SELECT     
  spa.spa_chegada AS DATA_CHEGADA,    
  spa.spa_codigo AS CODIGO,    
  l.set_descricao AS ESPECIALIDADE,    
  aa.atendamb_codigo,    
  'PRONTO_ATENDIMENTO' AS ORIGEM,    
  5 AS ORIPAC_CODIGO    
 FROM    
  PRONTO_ATENDIMENTO SPA    
  LEFT OUTER JOIN ATENDIMENTO_AMBULATORIAL AA ON SPA.SPA_CODIGO = AA.SPA_CODIGO    
  INNER JOIN VWLOCAL_UNIDADE L ON SPA.LOCATEND_CODIGO = L.LOCATEND_CODIGO    
 WHERE  SPA.PAC_CODIGO = @PAC_CODIGO    
    
 union all    
 SELECT     
  E.EMER_chegada AS DATA_CHEGADA,    
  E.EMER_codigo AS CODIGO,    
  l.set_descricao AS ESPECIALIDADE,    
  aa.atendamb_codigo,    
  'EMERGÊNCIA' AS ORIGEM,    
  3 AS ORIPAC_CODIGO      
 FROM    
  EMERGENCIA E    
  LEFT OUTER JOIN ATENDIMENTO_AMBULATORIAL AA ON E.EMER_CODIGO = AA.EMER_CODIGO    
  INNER JOIN VWLOCAL_UNIDADE L ON E.LOCATEND_CODIGO = L.LOCATEND_CODIGO    
 WHERE E.PAC_CODIGO = @PAC_CODIGO    
    
 union all    
 SELECT     
  A.atend_data AS DATA_CHEGADA,    
  A.atend_codigo AS CODIGO,    
  L.set_descricao AS ESPECIALIDADE,    
  AA.atendamb_codigo,    
  'ATENDIMENTO' AS ORIGEM,    
  0 AS ORIPAC_CODIGO      
 FROM    
  ATENDIMENTO A    
  LEFT OUTER JOIN ATENDIMENTO_AMBULATORIAL AA ON A.ATEND_CODIGO = AA.ATEND_CODIGO    
  INNER JOIN VWLOCAL_UNIDADE L ON A.LOCATEND_CODIGO = L.LOCATEND_CODIGO    
 WHERE A.PAC_CODIGO = @PAC_CODIGO    
END    
    
-----------------------------------------------------------------------------------------------    
    
if (@OPC = 13)    
    begin    
     if @emer_codigo is not null    
          begin    
    
            CREATE TABLE #temp_emer (
				pac_codigo	CHAR(12),
				pac_nome	VARCHAR(70),
				codigo	CHAR(12),
				boletim	NUMERIC(5),
				sexo	CHAR(1),
				idade	CHAR(3),
				nascimento	DATETIME,
				locatend_codigo	CHAR(4),
				LocAtend_descricao	VARCHAR(30)
			)    
    
            SET @csql =         ' insert into #temp_emer  '    
            SET @csql = @csql + ' SELECT  E.pac_codigo, E.emer_nome pac_nome, E.emer_codigo codigo, numero_be.Emer_Numero_BE boletim, E.emer_sexo sexo, '    
            SET @csql = @csql + '  E.emer_idade idade, E.emer_nascimento nascimento, E.locatend_codigo, loc.LocAtend_descricao '    
    
            SET @csql = @csql + ' from Emergencia E'    
            SET @csql = @csql + ' LEFT JOIN numero_be'    
            SET @csql = @csql + '   ON numero_be.emer_codigo = E.emer_codigo'      
            SET @csql = @csql + ' LEFT JOIN vwlocal_unidade loc '    
            SET @csql = @csql + '  ON E.locatend_codigo = loc.locatend_codigo '    
    
            SET @csql = @csql + '  where E.emer_codigo is not null'    
    
            if len(@emer_codigo) < 12    
              SET @csql = @csql + ' and numero_be.Emer_Numero_BE = ' + '''' + rtrim(ltrim(@emer_codigo))+ ''''                 
            else    
           SET @csql = @csql + '  and e.emer_codigo = ' + '''' + @emer_codigo + ''''    
        
            execute(@csql)    
    
            SELECT * FROM #temp_emer    
            DROP TABLE #temp_emer    
    
          end        
    
        if @spa_codigo is not null    
          begin        
    
			CREATE TABLE #temp_spa (
				pac_codigo	CHAR(12),
				pac_nome	VARCHAR(50),
				codigo	CHAR(12),
				boletim	NUMERIC(5),
				sexo	CHAR(1),
				idade	CHAR(3),
				nascimento	DATETIME,
				locatend_codigo	CHAR(4),
				LocAtend_descricao	VARCHAR(30)
			)  
    
    
            SET @csql =         'insert into #temp_spa '    
            SET @csql = @csql + ' SELECT  PA.pac_codigo,PA.spa_nome pac_nome, PA.spa_codigo codigo, numero_pa.spa_numero_pa boletim, PA.spa_sexo sexo, '    
            SET @csql = @csql + ' PA.spa_idade idade, PA.spa_nascimento nascimento, PA.locatend_codigo, loc.LocAtend_descricao '      
        
            SET @csql = @csql + ' from Pronto_Atendimento PA'    
            SET @csql = @csql + ' LEFT JOIN numero_pa'    
            SET @csql = @csql + '   ON numero_pa.spa_codigo = PA.spa_codigo'      
            SET @csql = @csql + ' LEFT JOIN vwlocal_unidade loc '    
            SET @csql = @csql + '   ON PA.locatend_codigo = loc.locatend_codigo '    
            SET @csql = @csql + '  where PA.spa_codigo is not null'    
    
            if len(@spa_codigo) < 12    
              SET @csql = @csql + '  and numero_pa.spa_numero_pa = ' + '''' + rtrim(ltrim(@spa_codigo)) + ''''      
            else    
              SET @csql = @csql + '  and pa.spa_codigo = ' + '''' + @spa_codigo + ''''      
    
    
            execute(@csql)    
    
            SELECT * FROM #temp_spa    
            DROP TABLE #temp_spa    
    
          end    
    end    
    
-----------------------------------------------------------------------------------------    
    
-- #####################################################################    
-- UTILIZADO PELA MODULO DE KLINIKOWEB NO MODULO DE ATENDIMENTO DO SEAP    
-- #####################################################################    
if (@OPC = 14)    
BEGIN    
    
 SELECT     
  AA.*    
 FROM    
  ATENDIMENTO_AMBULATORIAL AA    
 WHERE    
  AA.SPA_CODIGO = @SPA_CODIGO    
END    
    
    
SET NOCOUNT OFF    
-----------------------------------------------------------------------------------------------------------    
IF(@OPC = 15)    
BEGIN    
    
SELECT VW.LOCATEND_DESCRICAO   CLINICA,    
 PROF.PROF_NOME      PROFISSIONAL,    
 AA.ATENDAMB_DATAINICIO    INICIO,    
 AA.ATENDAMB_DATAFINAL    FIM,    
 AC.ATENDAMB_MOTIVO     MOTIVO_ATENDIMENTO,    
 AC.ATENDAMB_EXAME_FISICO   EXAME_FISICO,    
 CID_PRINCIPAL.CID_DESCRICAO   DIAGNOSTICO_PRINCIPAL,    
 CID_SECUNDARIO.CID_DESCRICAO  DIAGNOSTICO_SECUNDARIO,    
 UAM.TIPSAI_CODIGO     TIPO_SAIDA,    
 
 -- antes tinha um case when que marretava as descrições de saída - e no caso do tipo saída ser null, exibimos baixa Admnistrativa    
 isnull(substring(TS.tipsai_descricao,charindex('-',TS.tipsai_descricao) + 1,LEN(TS.tipsai_descricao)),'Baixa Administrativa') DESC_TIPO_SAIDA , 
     
 ENCAMINHAMENTO =     
 Case UAM.TIPSAI_CODIGOENCAMINHAMENTO    
  WHEN '1' THEN 'Exame'    
  WHEN '2' THEN 'Terapia'    
  WHEN '3' THEN 'Serviço'    
  WHEN '4' THEN 'Internação'    
  WHEN '5' THEN 'Remoção'    
  WHEN '6' THEN 'Emergência'    
 End,    
 AA.ATENDAMB_CODIGO     ATENDAMB_CODIGO    ,
 SOAP.SoapId
    
FROM ATENDIMENTO_AMBULATORIAL AA    
 INNER JOIN ATENDIMENTO_CLINICO AC ON (AA.ATENDAMB_CODIGO = AC.ATENDAMB_CODIGO)    
 left JOIN UPA_ATENDIMENTO_MEDICO UAM ON (AA.ATENDAMB_CODIGO = UAM.ATENDAMB_CODIGO)    
 INNER JOIN vwlocal_unidade VW ON (AA.LOCATEND_CODIGO = VW.LOCATEND_CODIGO AND VW.UNID_CODIGO = ISNULL(@UNID_CODIGO, VW.UNID_CODIGO))    
 INNER JOIN PROFISSIONAL PROF ON (AA.LOCATEND_CODIGO = PROF.LOCATEND_CODIGO AND AA.PROF_CODIGO = PROF.PROF_CODIGO)    
 LEFT JOIN CID_10 CID_PRINCIPAL ON (AC.CID_CODIGO = CID_PRINCIPAL.CID_CODIGO)    
 LEFT JOIN CID_10 CID_SECUNDARIO ON (AC.CID_SECUNDARIO = CID_SECUNDARIO.CID_CODIGO)    
 LEFT JOIN SOAP ON AA.ATENDAMB_CODIGO = SOAP.ATENDAMB_CODIGO
 LEFT JOIN TIPO_SAIDA TS on UAM.tipsai_codigo = TS.tipsai_codigo
WHERE AA.PAC_CODIGO = @PAC_CODIGO 
AND AA.spa_codigo IS NULL AND AA.emer_codigo IS NULL   
    
END    
-- Busca recidivas    
IF(@OPC = 16)      
BEGIN      
 if @emer_codigo is not null    
 begin    
  select atendamb_datafinal, * from atendimento_ambulatorial aa, unidade u where     
  u.unid_codigo = @unid_codigo and     
  aa.pac_codigo = @pac_codigo and     
  aa.emer_codigo <> @emer_codigo and       
  datediff(mi,aa.atendamb_datafinal, getdate()) <= (60*u.recidiva)    
 end    
 else    
 begin    
  select atendamb_datafinal, * from atendimento_ambulatorial aa, unidade u where     
  u.unid_codigo = @unid_codigo and     
  aa.pac_codigo = @pac_codigo and     
  aa.spa_codigo <> @spa_codigo and         
  datediff(mi,aa.atendamb_datafinal, getdate()) <= (60*u.recidiva)    
 end    
END    
IF(@OPC = 17)
BEGIN      
 SELECT * FROM ATENDIMENTO_AMBULATORIAL WHERE PAC_CODIGO= @PAC_CODIGO 
END

IF (@OPC = 18)      
BEGIN      
 IF (@pac_codigo IS NOT NULL)      
  SELECT TOP 5 aa.atendamb_datainicio,      
   AA.spa_codigo,      
   AA.emer_codigo,      
   AA.atendamb_datafinal,
   aa.atend_codigo      
  FROM ATENDIMENTO_AMBULATORIAL aa      
  INNER JOIN upa_atendimento_medico uam ON uam.atendamb_codigo = aa.atendamb_codigo      
  LEFT JOIN pronto_atendimento pa ON pa.spa_codigo = aa.spa_codigo      
  LEFT JOIN emergencia e ON e.emer_codigo = aa.emer_codigo      
  WHERE AA.PAC_CODIGO = @pac_codigo      
   AND aa.locatend_codigo = @locatend_codigo      
   AND (      
    uam.tipsai_codigo IS NULL      
    OR uam.tipsai_codigo <> 12      
    )      
  ORDER BY atendamb_datainicio DESC      
END 

IF (@OPC = 19)
BEGIN      
	if @spa_codigo is not null
	begin
		SELECT  aa.atendamb_codigo, aa.prof_codigo, aa.grpatend_codigo, aa.tpatend_codigo, aa.pac_codigo, aa.locatend_codigo, aa.atend_codigo, 
		aa.atendamb_datainicio, aa.atendamb_datafinal, 
		aa.motcobamb_codigo, aa.spa_codigo, aa.emer_codigo, aa.usu_codigo, aa.ATENDAMB_TEMPO_ATENDIMENTO, aa.atendamb_cod_SINAN, 
		aa.atendamb_contingencia, aa.atendamb_presc_fat, p.pac_nome
		FROM atendimento_ambulatorial aa
		inner join paciente p on p.pac_codigo = aa.pac_codigo
		WHERE aa.spa_codigo = @spa_codigo
	end
	else if @emer_codigo is not null
	begin
		SELECT aa.atendamb_codigo, aa.prof_codigo, aa.grpatend_codigo, aa.tpatend_codigo, aa.pac_codigo, aa.locatend_codigo, aa.atend_codigo, 
		aa.atendamb_datainicio, aa.atendamb_datafinal,
		aa.motcobamb_codigo, aa.spa_codigo, aa.emer_codigo, aa.usu_codigo, aa.ATENDAMB_TEMPO_ATENDIMENTO, aa.atendamb_cod_SINAN, 
		aa.atendamb_contingencia, aa.atendamb_presc_fat, p.pac_nome
		FROM atendimento_ambulatorial aa
		inner join paciente p on p.pac_codigo = aa.pac_codigo
		WHERE aa.emer_codigo = @emer_codigo
	end
END     

IF (@OPC = 20)      
BEGIN      
 INSERT INTO atendimento_ambulatorial_log (      
  atendlog_data,      
  atendamb_codigo,      
  locatend_codigo,      
  prof_codigo      
  )      
 VALUES (      
  GETDATE(),      
  @ATENDAMB_CODIGO,      
  @LOCATEND_CODIGO,      
  @PROF_CODIGO      
  )      
END

IF(@OPC = 21)
BEGIN      
  --SELECT * FROM ATENDIMENTO_AMBULATORIAL WHERE PAC_CODIGO= @PAC_CODIGO
 
   SELECT 
	PAC_NOME,
	ATEND_CODIGO,
	SET_DESCRICAO,
	PROF_NOME,
	ATENDAMB_DATAINICIO
	FROM ATENDIMENTO_AMBULATORIAL AA
	INNER JOIN VWLOCAL_ATENDIMENTO LA   ON AA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO  
	LEFT JOIN PROFISSIONAL PROF ON (PROF.PROF_CODIGO = AA.PROF_CODIGO AND PROF.LOCATEND_CODIGO = AA.LOCATEND_CODIGO)  
	LEFT JOIN PACIENTE PAC ON AA.PAC_CODIGO = PAC.PAC_CODIGO
	 WHERE AA.PAC_CODIGO= @PAC_CODIGO
  
END
-----------------------------------------------------------------------------------------------------------    
IF (@@ERROR <> 0)    
   BEGIN    
 RAISERROR('ERRO !!!  - Ksp_Atendimento_Ambulatorial - ',1,1)     
   END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[KSP_RELATORIO_IDENTIFICACAO_PACIENTE_LEITO]...';


GO
ALTER PROCEDURE [dbo].[KSP_RELATORIO_IDENTIFICACAO_PACIENTE_LEITO]
 @UNID_CODIGO	CHAR (4)	= NULL
,@INTER_CODIGO	CHAR(12)	= NULL
,@PAC_CODIGO	CHAR(12)	= NULL
,@USU_CODIGO	CHAR (4)	= NULL

AS
SET NOCOUNT ON

	DECLARE @PAC_NASCIMENTO DATETIME	= NULL 
	DECLARE @USU_NOME VARCHAR(50)		= NULL
	DECLARE @DT_IMPRESSAO CHAR (10)                            
    SET @DT_IMPRESSAO = CONVERT (VARCHAR, GETDATE (), 103)
	
	IF (OBJECT_ID('TEMPDB..#RELATORIO') IS NOT NULL)
	BEGIN
				DROP TABLE #REALTORIO
	END 

	SELECT	@USU_NOME	= USU_NOME                        
	FROM	USUARIO                            
	WHERE	USU_CODIGO	= @USU_CODIGO  

			
SELECT  
	UPPER(CASE WHEN  P.PAC_NOME_SOCIAL IS NULL THEN P.PAC_NOME  
        ELSE RTRIM(P.PAC_NOME_SOCIAL) +' ('+RTRIM(P.PAC_NOME)+')' 
   END) AS PAC_NOME
	,CONVERT (VARCHAR, P.PAC_NASCIMENTO, 103) AS PAC_NASCIMENTO
	,CONVERT (VARCHAR, I.INTER_DATAINTER, 103) AS INTER_DATAINTER  
	,I.INTER_DEOBSERVACAO
	,I.INTER_CODIGO, I.PROF_CODIGO ,I.LOCATEND_CODIGO
	,P.PAC_CODIGO, P.pac_idade
	,pep.peso, pep.data_sintoma
	,(CASE WHEN I.SPA_CODIGO IS NULL THEN I.EMER_CODIGO  ELSE I.SPA_CODIGO END) AS COD_SPA_EMER
	,ISNULL(stuff(( select ', '+ Dietas_Cuidados from (select 'Dieta: '+ PD.ipdi_texto + ' '+ case when PD.presc_codigo  IS NOT NULL then convert(varchar,pd.ipdi_kcal) + ' Kcal' end 'Dietas_Cuidados'
	from  Item_Prescricao_Dieta PD 
	INNER JOIN (SELECT TOP 1 PRESCRICAO.inter_codigo, PRESCRICAO.presc_codigo FROM PRESCRICAO ORDER BY PRESC_CODIGO DESC ) P ON P.PRESC_CODIGO = PD.presc_codigo
	
	WHERE P.inter_codigo = I.Inter_Codigo) PRES For Xml Path('')), 1, 1, ''),'') AS ITEM_PRESCRICAO
	,ISNULL(stuff((SELECT  ', '+ isnull(a.Descricao, s.Descricao)
		FROM 
		  Paciente_Alergia pa 
		  left join Pep_Alergia a on a.Codigo_Alergia = pa.Codigo_Alergia
		  left join Substancia s on s.id = pa.Id_Substancia 
		WHERE pa.pac_codigo = i.pac_codigo For Xml Path('')), 1, 1, ''),'') AS ALERGIAS

	, (VWLEI.ENF_CODIGO  + '/' +VWLEI.LEI_CODIGO) AS ENFERMARIA 
	,ISNULL(stuff(( select ', '+ Dietas_Cuidados from (select  CUE.cues_descricao +' '+ 
	case when CE.presc_codigo IS NOT NULL and (ipce_intervalo = 15 or ipce_intervalo = 30) then convert(varchar,CE.ipce_intervalo) + '/' + convert(varchar,CE.ipce_intervalo) + ' minuto(s)'                        
        when CE.presc_codigo IS NOT NULL and ipce_intervalo <> 15 and ipce_intervalo <> 30 then convert(varchar,CE.ipce_intervalo/60) + '/' + convert(varchar,CE.ipce_intervalo/60) + ' horas(s)'  end 'Dietas_Cuidados'
	from   Item_Prescricao_Cuidados_Especiais CE 
	INNER JOIN (SELECT TOP 1 PRESCRICAO.inter_codigo, PRESCRICAO.presc_codigo FROM PRESCRICAO ORDER BY PRESC_CODIGO DESC ) P ON P.PRESC_CODIGO = CE.presc_codigo
	inner join  Cuidados_Especiais CUE on ce.cues_codigo = CUE.cues_codigo
	WHERE p.inter_codigo = I.Inter_Codigo) PRES For Xml Path('')), 1, 1, ''),'') AS PRESCRICAO
	
	into #RELATORIO

FROM  INTERNACAO I 
	JOIN	PACIENTE P ON  (P.PAC_CODIGO = I.PAC_CODIGO)  AND	I.Inter_Codigo  = @INTER_CODIGO  AND I.PAC_CODIGO  =  @PAC_CODIGO
	JOIN	vwLocal_Atendimento l On	i.locatend_codigo = l.locatend_codigo
	left JOIN	PACIENTE_PRONTUARIO PP ON L.UNID_CODIGO = PP.UNID_CODIGO AND P.PAC_CODIGO = PP.PAC_CODIGO
	LEFT JOIN 	VWLEITO VWLEI ON I.LOCATEND_LEITO = VWLEI.LOCATEND_CODIGO AND I.LEI_CODIGO = VWLEI.LEI_CODIGO	
	Inner Join Internacao_pep pep on pep.inter_codigo = I.inter_codigo
	WHERE 	L.UNID_CODIGO = @UNID_CODIGO
	AND		I.INTER_CODIGO = @INTER_CODIGO


	SELECT R.*
		,@USU_NOME			AS NOME_USUARIO 
		,null as CABECALHO_REPORT1
		,null as CABECALHO_REPORT2
		,null as CABECALHO_REPORT3
		,null as LOGO                 
	FROM  #RELATORIO R
	
 --------------------------------------------------------------------------------------
IF (@@ERROR <> 0)
BEGIN
          RAISERROR('ERRO - ',1,1)
END
 
SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[ksp_relatorio_laboratorio_ComprovanteColeta]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_laboratorio_ComprovanteColeta]
@requisicao CHAR (12)
AS
SET NOCOUNT ON

---------------------------------------------------------------------------------------------------------------------------------------------
-- Cria Legenda
---------------------------------------------------------------------------------------------------------------------------------------------
declare @legenda as varchar(100)
set @legenda='Legenda: '
select @legenda= @legenda + SituExa_Sigla + ' - ' + SituExa_Descricao + ', ' from coleta_situacao_exame
---------------------------------------------------------------------------------------------------------------------------------------------

	/* calcula o maior Tempo maximo dos exames */ 
	DECLARE @MaiorHorario as integer

	select @MaiorHorario = max(el.exalab_tempo_maximo) from 
	exame_laboratorio el 
	inner join exame_solicitado_laboratorio esl on (esl.exalab_codigo=el.exalab_codigo)
	where esl.pedexalab_codigo=@requisicao

-- PACIENTE

	SELECT	Case pe.pedexalab_urgencia
			WHEN 'U' THEN pe.esmeralda_codigo + '-U'
			ELSE pe.esmeralda_codigo + '-R'
		End Amostra,

		CASE 
		  WHEN ur.unidref_descricao IS NULL
		  THEN unid.unid_descricao
		  ELSE ur.unidref_descricao
		End as Unidade, 
		pr.prof_nome Medico, 
		
		CASE 
		WHEN es.exasollab_data_coleta IS NULL     
			THEN es.exasollab_data_coleta
		WHEN es.exasollab_data_coleta IS NOT NULL     
			and es.exasollab_data_coleta <= DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data)
			THEN es.exasollab_data_coleta
		END as DataColeta, 

		getdate() Recebimento, 
		DATEADD(hh, isnull(@MaiorHorario,7),pe.pedexalab_data) as Entrega, 
		
		CASE 
		  WHEN es.exasollab_situacao_exame <> ''
		  THEN el.exalab_mneumonico + ' (' + cse.situexa_sigla + ') '
		  ELSE el.exalab_mneumonico
		End as exalab_mneumonico,

		el.exalab_descricao

		, pe.pedexalab_codigo as Requisicao,
		 case when pa.pac_nome_social is null then pa.pac_nome else rtrim(pa.pac_nome_social) +' ['+rtrim(pa.pac_nome)+']' end  as paciente,
			isnull (((cast(DateDiff(dd,pa.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pa.pac_nascimento, getdate()) as int) / 4)) / 365 ), pa.pac_idade) as idade,
		--CASE  
		   --WHEN ((cast(DateDiff(yyyy, pa.pac_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(dd, pa.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pa.pac_nascimento, getdate()) as int) / 4)) / 365)) + '(A)'
		   --WHEN ((cast(DateDiff(m, pa.pac_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(m, pa.pac_nascimento, getdate()) as int)))) + '(M)'
		   --WHEN ((cast(DateDiff(d, pa.pac_nascimento, getdate()) as int))) >= 0 
			 --THEN convert(char(3), ((cast(DateDiff(d, pa.pac_nascimento, getdate()) as int)))) + '(D)'
		  --End AS IDADE,

		pa.pac_sexo as Sexo, pa.pac_nascimento Nascimento,
		pa.pac_telefone as Telefone, unid.unid_descricao, unid.unid_sigla, unid.unid_cgc, unid.unid_telefone
		,@LEGENDA AS LEGENDA,
		pe.pedexalab_data DataRequisicao,
		unid.unid_codigo,
		v.set_descricao clinica,
		lc.loccollab_descricao
		

	FROM	pedido_exame_laboratorio pe 
			INNER JOIN 	exame_solicitado_laboratorio es ON pe.pedexalab_codigo	= es.pedexalab_codigo
			INNER JOIN	exame_laboratorio el 		ON es.exalab_codigo	= el.exalab_codigo
			LEFT  JOIN	unidade_referencia ur		ON pe.unidref_codigo    = ur.unidref_codigo 
			INNER JOIN 	profissional pr			ON pe.prof_codigo	= pr.prof_codigo
			INNER JOIN	paciente pa			ON pe.pac_codigo	= pa.pac_codigo
			INNER JOIN 	Unidade unid			ON pe.unid_codigo	= unid.unid_codigo
			LEFT  JOIN  coleta_situacao_exame cse	ON es.exasollab_situacao_exame = cse.situexa_codigo
			LEFT join  vwLocal_Unidade v on pe.locatend_codigo = v.locatend_codigo
			Inner Join Local_Coleta_laboratorio lc on lc.loccollab_codigo = pe.loccollab_codigo

	WHERE	pe.pedexalab_codigo 	= @Requisicao
	AND rtrim(ltrim(es.exasollab_status))<>'E'
	AND 	pe.pac_codigo is not null
	

-- EMERGENCIA
	UNION
	SELECT	Case pe.pedexalab_urgencia
			WHEN 'S' THEN pe.esmeralda_codigo + '-U'
			ELSE pe.esmeralda_codigo + '-R'
		End Amostra,
		ur.unidref_descricao Unidade, 
		pr.prof_nome Medico, 

		CASE 
		WHEN es.exasollab_data_coleta IS NULL     
			THEN es.exasollab_data_coleta
		WHEN es.exasollab_data_coleta IS NOT NULL 
			and es.exasollab_data_coleta <= DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data)
			THEN es.exasollab_data_coleta
		END as DataColeta, 

		getdate() Recebimento,
		DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data) as Entrega, 

		CASE 
		  WHEN es.exasollab_situacao_exame <> ''
		  THEN el.exalab_mneumonico + ' (' + cse.situexa_sigla + ') '
		  ELSE el.exalab_mneumonico
		End as exalab_mneumonico,

		el.exalab_descricao
		,pe.pedexalab_codigo as Requisicao,
		 case when em.emer_nome_social is null then em.emer_nome else rtrim(em.emer_nome_social) +' ['+rtrim(em.emer_nome)+']' end as paciente,

		
		  isnull (((cast(DateDiff(dd,em.emer_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, em.emer_nascimento, getdate()) as int) / 4)) / 365),em.emer_idade) as idade,
		--CASE  
		   --WHEN ((cast(DateDiff(yyyy, em.emer_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(dd, em.emer_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, em.emer_nascimento, getdate()) as int) / 4)) / 365)) + '(A)'
		   --WHEN ((cast(DateDiff(m, em.emer_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(m, em.emer_nascimento, getdate()) as int)))) + '(M)'
		   --WHEN ((cast(DateDiff(d, em.emer_nascimento, getdate()) as int))) >= 0 
			 --THEN convert(char(3), ((cast(DateDiff(d, em.emer_nascimento, getdate()) as int)))) + '(D)'
		  --End AS IDADE,

		em.emer_sexo as Sexo,em.emer_nascimento as Nascimento,
		em.emer_telefone as Telefone,unid.unid_descricao,unid.unid_sigla,unid.unid_cgc,unid.unid_telefone
		,@LEGENDA AS LEGENDA,
		pe.pedexalab_data DataRequisicao,
		unid.unid_codigo,
		v.set_descricao clinica,
		lc.loccollab_descricao

	FROM	pedido_exame_laboratorio pe 
			INNER JOIN 	exame_solicitado_laboratorio es ON pe.pedexalab_codigo	= es.pedexalab_codigo
			INNER JOIN	exame_laboratorio el 	ON es.exalab_codigo	= el.exalab_codigo
			LEFT  JOIN	unidade_referencia ur	ON pe.unidref_codigo    = ur.unidref_codigo 
			INNER JOIN 	profissional pr			ON pe.prof_codigo	= pr.prof_codigo
			INNER JOIN  Emergencia em			ON pe.emer_codigo	= em.emer_codigo
			INNER JOIN 	Unidade unid			ON pe.unid_codigo	= unid.unid_codigo
			LEFT  JOIN  coleta_situacao_exame cse	ON es.exasollab_situacao_exame = cse.situexa_codigo
			LEFT join  vwLocal_Unidade v on pe.locatend_codigo = v.locatend_codigo
			Inner Join Local_Coleta_laboratorio lc on lc.loccollab_codigo = pe.loccollab_codigo

	WHERE	pe.pedexalab_codigo 	= @Requisicao
	AND rtrim(ltrim(es.exasollab_status))<>'E'
	AND 	pe.pac_codigo is null

-- PRONTO ATENDIMENTO
	UNION
	SELECT	Case pe.pedexalab_urgencia
			WHEN 'U' THEN pe.esmeralda_codigo + '-U'
			ELSE pe.esmeralda_codigo + '-R'
		End Amostra,
		ur.unidref_descricao Unidade, 
		pr.prof_nome Medico, 

		CASE 
		WHEN es.exasollab_data_coleta IS NULL     
			THEN es.exasollab_data_coleta
		WHEN es.exasollab_data_coleta IS NOT NULL  AND  es.exasollab_data_coleta <= DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data)
			THEN es.exasollab_data_coleta
		END as DataColeta, 

		getdate() Recebimento,
		DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data) as Entrega, 

		CASE 
		  WHEN es.exasollab_situacao_exame <> '' THEN el.exalab_mneumonico + ' (' + cse.situexa_sigla + ') '
		  ELSE el.exalab_mneumonico
		End as exalab_mneumonico,

		el.exalab_descricao
		,pe.pedexalab_codigo as Requisicao,
		case when sp.spa_nome_social is null then sp.spa_nome else rtrim(sp.spa_nome_social) +' ['+rtrim(sp.spa_nome)+']' end as paciente,
		isnull(((cast(DateDiff(dd,sp.spa_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, sp.spa_nascimento, getdate()) as int) / 4)) / 365),sp.spa_idade) as idade,
		--CASE  
		   --WHEN ((cast(DateDiff(yyyy, sp.spa_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(dd, sp.spa_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, sp.spa_nascimento, getdate()) as int) / 4)) / 365)) + '(A)'
		   --WHEN ((cast(DateDiff(m, sp.spa_nascimento, getdate()) as int))) > 0 
			 --THEN convert(char(3), ((cast(DateDiff(m, sp.spa_nascimento, getdate()) as int)))) + '(M)'
		   --WHEN ((cast(DateDiff(d, sp.spa_nascimento, getdate()) as int))) >= 0 
			 --THEN convert(char(3), ((cast(DateDiff(d, sp.spa_nascimento, getdate()) as int)))) + '(D)'
		  --End AS IDADE,

		sp.spa_sexo as Sexo,sp.spa_nascimento as Nascimento,
		sp.spa_telefone as Telefone,unid.unid_descricao,unid.unid_sigla,unid.unid_cgc,unid.unid_telefone
		,@LEGENDA AS LEGENDA,
		pe.pedexalab_data DataRequisicao,
		unid.unid_codigo,
		v.set_descricao clinica,
		lc.loccollab_descricao

	FROM	pedido_exame_laboratorio pe 
			INNER JOIN 	exame_solicitado_laboratorio es ON pe.pedexalab_codigo	= es.pedexalab_codigo
			INNER JOIN	exame_laboratorio el 	ON es.exalab_codigo	= el.exalab_codigo
			LEFT  JOIN	unidade_referencia ur	ON pe.unidref_codigo    = ur.unidref_codigo 
			INNER JOIN 	profissional pr			ON pe.prof_codigo	= pr.prof_codigo
			INNER JOIN	Pronto_Atendimento sp	ON pe.spa_codigo 	= sp.spa_codigo
			INNER JOIN 	Unidade unid			ON pe.unid_codigo	= unid.unid_codigo
			LEFT  JOIN  coleta_situacao_exame cse	ON es.exasollab_situacao_exame = cse.situexa_codigo
			LEFT join  vwLocal_Unidade v on pe.locatend_codigo = v.locatend_codigo
			Inner Join Local_Coleta_laboratorio lc on lc.loccollab_codigo = pe.loccollab_codigo

	WHERE	pe.pedexalab_codigo 	= @Requisicao
	AND 	pe.pac_codigo is null

-- PACIENTE EXTERNO
	UNION
	SELECT	Case pe.pedexalab_urgencia
			WHEN 'U' THEN pe.esmeralda_codigo + '-U'
			ELSE pe.esmeralda_codigo + '-R'
		End Amostra,
		ur.unidref_descricao Unidade, 
		pr.profref_nome Medico, 

		CASE 
		WHEN es.exasollab_data_coleta IS NULL     
			THEN es.exasollab_data_coleta
		WHEN es.exasollab_data_coleta IS NOT NULL 
			and es.exasollab_data_coleta <= DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data)
			THEN es.exasollab_data_coleta
		END as DataColeta, 

		getdate() Recebimento,
		DATEADD(hh, isnull(@MaiorHorario,7), pe.pedexalab_data) as Entrega, 

		CASE 
		  WHEN es.exasollab_situacao_exame <> ''
		  THEN el.exalab_mneumonico + ' (' + cse.situexa_sigla + ') '
		  ELSE el.exalab_mneumonico
		End as exalab_mneumonico,

		el.exalab_descricao

		,pe.pedexalab_codigo as Requisicao, pext.pext_nome as paciente,
		
		isnull(((cast(DateDiff(dd,pext.pext_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pext.pext_nascimento, getdate()) as int) / 4)) / 365),pext.pext_idade) as idade,

		--CASE  
		--   WHEN ((cast(DateDiff(yyyy, pext.pext_nascimento, getdate()) as int))) > 0 
		--	 THEN convert(char(3), ((cast(DateDiff(dd, pext.pext_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pext.pext_nascimento, getdate()) as int) / 4)) / 365)) + '(A)'
		--   WHEN ((cast(DateDiff(m, pext.pext_nascimento, getdate()) as int))) > 0 
		--	 THEN convert(char(3), ((cast(DateDiff(m, pext.pext_nascimento, getdate()) as int)))) + '(M)'
		--   WHEN ((cast(DateDiff(d, pext.pext_nascimento, getdate()) as int))) >= 0 
		--	 THEN convert(char(3), ((cast(DateDiff(d, pext.pext_nascimento, getdate()) as int)))) + '(D)'
		--  End AS IDADE,
		
		pext.pext_sexo as Sexo,pext.pext_Nascimento as Nascimento,pext.pext_telefone as Telefone,
		unid.unid_descricao,unid.unid_sigla,unid.unid_cgc,unid.unid_telefone
		,@LEGENDA AS LEGENDA,
		pe.pedexalab_data DataRequisicao,
		unid.unid_codigo,
		v.set_descricao clinica,
		lc.loccollab_descricao

	FROM	pedido_exame_laboratorio pe 
			INNER JOIN 	exame_solicitado_laboratorio es ON pe.pedexalab_codigo	= es.pedexalab_codigo
			INNER JOIN	exame_laboratorio el 		ON es.exalab_codigo	= el.exalab_codigo
			LEFT  JOIN	unidade_referencia ur		ON pe.unidref_codigo    = ur.unidref_codigo 
			INNER JOIN	paciente_externo pext		ON pe.pext_codigo	= pext.pext_codigo
			LEFT  JOIN 	profissional_referencia pr	ON pext.profref_codigo  = pr.profref_codigo
			INNER JOIN 	Unidade unid			ON pe.unid_codigo	= unid.unid_codigo
			LEFT  JOIN  coleta_situacao_exame cse	ON es.exasollab_situacao_exame = cse.situexa_codigo
			LEFT join  vwLocal_Unidade v on pe.locatend_codigo = v.locatend_codigo
			Inner Join Local_Coleta_laboratorio lc on lc.loccollab_codigo = pe.loccollab_codigo

	WHERE	pe.pedexalab_codigo 	= @Requisicao
	AND rtrim(ltrim(es.exasollab_status))<>'E'
	AND 	pe.pac_codigo is null

/*--------------------------------------------------------------------------------------------*/
 
IF (@@ERROR <> 0)
   BEGIN
      	RAISERROR('ERRO !! - ksp_relatorio_laboratorio_ComprovanteColeta',1,1)
   END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_sumario_alta_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_sumario_alta_impresso]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_Controle_Sinais_Vitais_Balanco_Hidrico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Controle_Sinais_Vitais_Balanco_Hidrico]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_Internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Internacao]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_PEP_Solicitacao_Pedido_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Solicitacao_Pedido_Impresso]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_UPA_Evolucao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Evolucao]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Refreshing [dbo].[ksp_upa_fila_pep]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_upa_fila_pep]';


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';
GO
DECLARE @versao varchar(30)
SET @versao = 'K.2020.06.7'

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
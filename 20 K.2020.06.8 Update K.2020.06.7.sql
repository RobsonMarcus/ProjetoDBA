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
PRINT N'Altering [dbo].[PEP_Exame_Fisico]...';


GO
ALTER TABLE [dbo].[PEP_Exame_Fisico]
    ADD [exafis_saturacao] DECIMAL (18)     NULL,
        [atenf_codigo]     UNIQUEIDENTIFIER NULL;


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
PRINT  N'Altering KSP_RELATORIO_IDENTIFICACAO_PACIENTE_LEITO';
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
	,P.PAC_CODIGO, dbo.CalcularIdade(P.PAC_NASCIMENTO, getdate()) as  pac_idade
	,pep.peso, pep.data_sintoma
	,(CASE WHEN I.SPA_CODIGO IS NULL THEN I.EMER_CODIGO  ELSE I.SPA_CODIGO END) AS COD_SPA_EMER
	,ISNULL(stuff(( select ', '+ Dietas_Cuidados from (select 'Dieta: '+ PD.ipdi_texto as 'Dietas_Cuidados'
	from  Item_Prescricao_Dieta PD 
	INNER JOIN (SELECT PRESCRICAO.inter_codigo, PRESCRICAO.presc_codigo FROM PRESCRICAO  ) P ON P.PRESC_CODIGO = PD.presc_codigo
	
	WHERE P.inter_codigo = I.Inter_Codigo) PRES For Xml Path('')), 1, 1, ''),'') AS ITEM_PRESCRICAO
	,ISNULL(stuff((SELECT  ', '+ isnull(a.Descricao, s.Descricao)
		FROM 
		  Paciente_Alergia pa 
		  left join Pep_Alergia a on a.Codigo_Alergia = pa.Codigo_Alergia
		  left join Substancia s on s.id = pa.Id_Substancia 
		WHERE pa.pac_codigo = i.pac_codigo For Xml Path('')), 1, 1, ''),'') AS ALERGIAS

	, (VWLEI.ENF_CODIGO  + '/' +VWLEI.LEI_CODIGO) AS ENFERMARIA 
	,ISNULL(stuff(( select ', '+ Cuidados from (select  CUE.cues_descricao as 'Cuidados'
	from   Item_Prescricao_Cuidados_Especiais CE 
	INNER JOIN (SELECT PRESCRICAO.inter_codigo, PRESCRICAO.presc_codigo FROM PRESCRICAO) P ON P.PRESC_CODIGO = CE.presc_codigo
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
PRINT N'Creating [dbo].[Atendimento_Enfermagem]...';


GO
CREATE TABLE [dbo].[Atendimento_Enfermagem] (
    [atenf_codigo]       UNIQUEIDENTIFIER NOT NULL,
    [atenf_data]         DATETIME         NULL,
    [agd_sequencial]     CHAR (12)        NULL,
    [atenf_preconsulta]  VARCHAR (2000)   NULL,
    [atenf_hipertensao]  CHAR (1)         NULL,
    [atenf_diabetes]     CHAR (1)         NULL,
    [atenf_dpoc]         CHAR (1)         NULL,
    [atenf_cardiopatia]  CHAR (1)         NULL,
    [atenf_renalcronico] CHAR (1)         NULL,
    [atenf_outros]       VARCHAR (200)    NULL,
    [atenf_posconsulta]  VARCHAR (2000)   NULL,
    CONSTRAINT [PK_Atendimento_Enfermagem] PRIMARY KEY CLUSTERED ([atenf_codigo] ASC)
);


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
PRINT N'Creating [dbo].[FK_PEP_Exame_Fisico_Atendimento_Enfermagem]...';


GO
ALTER TABLE [dbo].[PEP_Exame_Fisico] WITH NOCHECK
    ADD CONSTRAINT [FK_PEP_Exame_Fisico_Atendimento_Enfermagem] FOREIGN KEY ([atenf_codigo]) REFERENCES [dbo].[Atendimento_Enfermagem] ([atenf_codigo]);


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
						 p.data_sintoma as DataSintoma' 
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
	p.data_sintoma as DataSintoma
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
	p.data_sintoma as DataSintoma
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
	,P.PAC_CODIGO, dbo.CalcularIdade(P.PAC_NASCIMENTO, getdate()) as  pac_idade
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
PRINT N'Altering [dbo].[ksp_relatorio_radiologia_Laudo_Exame]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_radiologia_Laudo_Exame]  
@codigo VARCHAR (12), @IDADE INT=NULL, @EXARAD_COD CHAR (4)=NULL, @complemento char(1) = null  
AS  
set nocount on   
  
CREATE TABLE #TMP (pedexarad_codigo  CHAR(12),       
 pac_codigo CHAR(12) ,       
 pac_nome  VARCHAR(50) ,       
 prof_codigo CHAR(4) ,       
 pac_prontuario CHAR(8),      
 locatend_codigo CHAR(4) ,        
 pedexarad_datahora  SMALLDATETIME ,       
 pedexarad_entrega SMALLDATETIME  ,      
 EMER_CODIGO CHAR(12),       
 ATENDAMB_CODIGO CHAR(12),       
 INTER_CODIGO CHAR(12),       
 SPA_CODIGO CHAR(12),      
 ORIGEM_DESCRICAO VARCHAR(30),      
 ORIGEM CHAR(2),      
 LOCATEND_DESCRICAO VARCHAR(30),      
 UNID_DESCRICAO VARCHAR(50),      
 PROF_NOME VARCHAR(50),      
 EXARAD_DESCRICAO VARCHAR(250),      
 EXARAD_CODIGO CHAR(4),      
 LAUDO_PROF_NOME VARCHAR(50),      
 LAUDO_LOCATEND_DESCRICAO VARCHAR(50),      
 LAUDO_DATA SMALLDATETIME,      
 PEXT_CODIGO CHAR(12),      
 EXARAD_LAUDO TEXT,      
 IDADE INT,      
 SEXO CHAR(1),    
 prof_numconselho VARCHAR(60),  
 LAUDO_ASSELETRONICA IMAGE,  
 CID_DESCRICAO VARCHAR(100),  
 solpedexa_complemento VARCHAR(20),  
 CBO VARCHAR(50))    
      
-- CARREGA TEMPORÁRIA      
INSERT INTO #TMP (pedexarad_codigo  ,       
   pac_codigo  ,       
   pac_nome   ,       
   prof_codigo ,       
   pac_prontuario,       
   locatend_codigo  ,        
   pedexarad_datahora   ,       
   pedexarad_entrega  ,      
   EMER_CODIGO,       
   ATENDAMB_CODIGO,       
   INTER_CODIGO,       
   SPA_CODIGO,      
   ORIGEM_DESCRICAO,      
   ORIGEM,      
   LOCATEND_DESCRICAO,      
   PROF_NOME,      
   EXARAD_DESCRICAO,      
   EXARAD_CODIGO,      
   PEXT_CODIGO,        
   UNID_DESCRICAO,      
   IDADE,      
   SEXO,    
   prof_numconselho,  
   solpedexa_complemento)      
      
-- EXAME RADIOLOGIO X PACIENTE      
 SELECT PED.pedexarad_codigo  ,       
 PED.pac_codigo  ,       
 CASE WHEN PAC.pac_nome_social IS NULL THEN PAC.pac_nome ELSE RTRIM(PAC.pac_nome_social) + ' [' + RTRIM(PAC.pac_nome_social) + ']' END AS pac_nome,       
 PED.prof_codigo ,       
 PP.pac_prontuario_numero,       
 PED.locatend_codigo  ,        
 PED.pedexarad_datahora   ,       
 PED.pedexarad_entrega  ,      
 PED.EMER_CODIGO,       
 PED.ATENDAMB_CODIGO,       
 PED.INTER_CODIGO,       
 PED.SPA_CODIGO,   
 (      
  SELECT ORIPAC_DESCRICAO      
  FROM ORIGEM_PACIENTE      
  WHERE ORIPAC_CODIGO = ped.origem      
 ) AS ORIGEM_DESCRICAO,      
 PED.ORIGEM,
 CASE WHEN PED.inter_codigo IS NOT NULL THEN VL.LocAtend_descricao
 ELSE      
 LA.LOCATEND_DESCRICAO
 END,      
 P.PROF_NOME,      
 ER.EXARAD_DESCRICAO,      
 ER.EXARAD_CODIGO,      
 PED.PEXT_CODIGO,        
 LA.UNID_DESCRICAO,      
 (cast(DateDiff(dd,pac.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, pac.pac_nascimento, getdate()) as int) / 4)) / 365 as idade,       
 PAC.PAC_SEXO,    
 prof_numconselho,  
    CASE   WHEN ERS.solpedexa_complemento = '1' THEN 'Direito'    
     WHEN ERS.solpedexa_complemento = '2' THEN 'Esquerdo'   END   
    
 FROM PEDIDO_EXAME_RADIOLOGICO PED       
 JOIN EXAME_RADIOLOGICO_SOLICITADO ERS        ON PED.PEDEXARAD_CODIGO = ERS.PEDEXARAD_CODIGO       
 JOIN EXAME_RADIOLOGICO ER        ON ERS.EXARAD_CODIGO = ER.EXARAD_CODIGO       
 JOIN PACIENTE PAC        ON PED.pac_codigo = PAC.pac_codigo      
 JOIN PROFISSIONAL P        ON PED.PROF_CODIGO = P.PROF_CODIGO       AND PED.LOCATEND_CODIGO = P.LOCATEND_CODIGO      
 JOIN VWLOCAL_UNIDADE LA  ON PED.LOCATEND_CODIGO = LA.LOCATEND_CODIGO     
 LEFT JOIN PACIENTE_PRONTUARIO PP        ON PAC.PAC_CODIGO = PP.PAC_CODIGO      
 LEFT JOIN VWLOCAL_UNIDADE VW        ON PP.UNID_CODIGO = VW.UNID_CODIGO 
 LEFT JOIN INTERNACAO I              ON PED.inter_codigo = I.inter_codigo
 LEFT JOIN vwLocal_Atendimento VL				    ON I.locatend_codigo = VL.LOCATEND_CODIGO
   
 WHERE PED.pedexarad_codigo = @Codigo    
 AND   ped.spa_codigo is null  
 AND   ped.emer_codigo is null      
 AND   ERS.EXARAD_STATUS = 'L'       
 AND (@EXARAD_COD IS NULL OR (ERS.EXARAD_CODIGO = @EXARAD_COD))   
 AND ERS.solpedexa_complemento = ISNULL(@complemento, ERS.solpedexa_complemento)     
      
-- EXAME RADIOLOGIO X EMERGENCIA      
UNION      
     SELECT PED.pedexarad_codigo  ,       
  PED.pac_codigo  ,       
  CASE WHEN EMER.emer_nome_social IS NULL THEN EMER.EMER_NOME ELSE RTRIM(EMER.emer_nome_social) + ' [' + RTRIM(EMER.EMER_NOME) + ']' END AS pac_nome   ,       
  PED.prof_codigo ,       
  NULL AS pac_prontuario,      
         PED.locatend_codigo  ,        
  PED.pedexarad_datahora   ,       
  PED.pedexarad_entrega  ,      
      PED.EMER_CODIGO,       
  PED.ATENDAMB_CODIGO,       
  PED.INTER_CODIGO,       
  PED.SPA_CODIGO,        
  (      
   SELECT ORIPAC_DESCRICAO      
   FROM ORIGEM_PACIENTE      
   WHERE ORIPAC_CODIGO = ped.origem      
  ) AS ORIGEM_DESCRICAO,      
  PED.ORIGEM,
  CASE WHEN PED.inter_codigo IS NOT NULL THEN VL.LocAtend_descricao
  ELSE      
  LA.LOCATEND_DESCRICAO
  END,        
  P.PROF_NOME,      
  ER.EXARAD_DESCRICAO,      
  ER.EXARAD_CODIGO,      
         PED.PEXT_CODIGO,      
  LA.UNID_DESCRICAO,      
  @IDADE AS IDADE,      
  emer.emer_SEXO,    
  prof_numconselho,         
  NULL  
      FROM PEDIDO_EXAME_RADIOLOGICO PED,       
  EMERGENCIA EMER,      
  VWLOCAL_UNIDADE LA,      
  PROFISSIONAL P,      
  EXAME_RADIOLOGICO_SOLICITADO ERS,      
  EXAME_RADIOLOGICO ER, 
  vwLocal_Atendimento VL
      
      WHERE PED.pedexarad_codigo = @Codigo       
        AND PED.PEDEXARAD_CODIGO = ERS.PEDEXARAD_CODIGO       
        AND ERS.EXARAD_CODIGO = ER.EXARAD_CODIGO       
        AND PED.EMER_codigo = EMER.EMER_codigo       
     AND PED.PROF_CODIGO = P.PROF_CODIGO      
     AND PED.LOCATEND_CODIGO = P.LOCATEND_CODIGO	    
     AND PED.LOCATEND_CODIGO = LA.LOCATEND_CODIGO	        
 AND PED.EMER_codigo IS NOT NULL      
        AND   ERS.EXARAD_STATUS = 'L'      
  AND (@EXARAD_COD IS NULL OR (ERS.EXARAD_CODIGO = @EXARAD_COD)) 
  AND  VL.LOCATEND_CODIGO = LA.locatend_codigo    
  
-- EXAME RADIOLOGIO X PRONTO ATENDIMENTO      
UNION      
      SELECT PED.pedexarad_codigo  ,       
  PED.pac_codigo  ,       
  CASE WHEN SPA.spa_nome_social IS NULL THEN SPA.SPA_NOME ELSE RTRIM(SPA.spa_nome_social) + ' [' + RTRIM(SPA.SPA_NOME) + ']' END AS pac_nome   ,       
  PED.prof_codigo ,       
  NULL AS pac_prontuario,      
         PED.locatend_codigo  ,        
  PED.pedexarad_datahora   ,       
  PED.pedexarad_entrega  ,      
      PED.EMER_CODIGO,       
  PED.ATENDAMB_CODIGO,       
  PED.INTER_CODIGO,       
  PED.SPA_CODIGO,      
  (      
   SELECT ORIPAC_DESCRICAO      
   FROM ORIGEM_PACIENTE      
   WHERE ORIPAC_CODIGO = ped.origem      
  ) AS ORIGEM_DESCRICAO,      
  PED.ORIGEM,
  CASE WHEN PED.inter_codigo IS NOT NULL THEN VL.LocAtend_descricao
  ELSE      
  LA.LOCATEND_DESCRICAO
  END,      
  P.PROF_NOME,      
  ER.EXARAD_DESCRICAO,      
  ER.EXARAD_CODIGO,      
         PED.PEXT_CODIGO,      
  LA.UNID_DESCRICAO,      
  @IDADE AS IDADE,      
  spa.spa_SEXO,    
  prof_numconselho,        
  NULL  
      FROM PEDIDO_EXAME_RADIOLOGICO PED,       
  PRONTO_ATENDIMENTO SPA,      
  VWLOCAL_UNIDADE LA,      
  PROFISSIONAL P,      
  EXAME_RADIOLOGICO_SOLICITADO ERS,      
  EXAME_RADIOLOGICO ER,
  vwLocal_Atendimento VL	 
      WHERE PED.pedexarad_codigo = @Codigo      
        AND PED.PEDEXARAD_CODIGO = ERS.PEDEXARAD_CODIGO       
        AND ERS.EXARAD_CODIGO = ER.EXARAD_CODIGO       
        AND PED.SPA_codigo = SPA.SPA_codigo       
     AND PED.PROF_CODIGO = P.PROF_CODIGO      
     AND PED.LOCATEND_CODIGO = P.LOCATEND_CODIGO	    
     AND PED.LOCATEND_CODIGO = LA.LOCATEND_CODIGO 	    
     AND  PED.SPA_codigo is not null      
     AND   ERS.EXARAD_STATUS = 'L'      
     AND (@EXARAD_COD IS NULL OR (ERS.EXARAD_CODIGO = @EXARAD_COD)) 
	 AND VL.LOCATEND_CODIGO     = LA.LOCATEND_CODIGO 
UNION      
     SELECT PED.pedexarad_codigo  ,       
  PED.pac_codigo  ,       
  PE.pext_nome AS pac_nome,        
  PED.prof_codigo ,       
  null pac_prontuario_numero,       
         PED.locatend_codigo  ,        
  PED.pedexarad_datahora   ,       
  PED.pedexarad_entrega  ,      
      PED.EMER_CODIGO,       
  PED.ATENDAMB_CODIGO,       
  PED.INTER_CODIGO,       
  PED.SPA_CODIGO,        
  (      
   SELECT ORIPAC_DESCRICAO      
   FROM ORIGEM_PACIENTE      
   WHERE ORIPAC_CODIGO = ped.origem      
  ) AS ORIGEM_DESCRICAO,      
  PED.ORIGEM,
  CASE WHEN PED.inter_codigo IS NOT NULL THEN VL.LocAtend_descricao
  ELSE
  ur.unidref_descricao
  END,     
  P.PROF_NOME,      
  ER.EXARAD_DESCRICAO,      
  ER.EXARAD_CODIGO,      
         PED.PEXT_CODIGO,      
  UNID.UNID_DESCRICAO,      
  @IDADE AS IDADE,      
  PE.PEXT_SEXO,    
  prof_numconselho,       
  NULL    
      FROM PEDIDO_EXAME_RADIOLOGICO PED  JOIN EXAME_RADIOLOGICO_SOLICITADO ERS ON PED.PEDEXARAD_CODIGO = ERS.PEDEXARAD_CODIGO       
      JOIN EXAME_RADIOLOGICO ER             ON ERS.EXARAD_CODIGO = ER.EXARAD_CODIGO       
      LEFT JOIN PACIENTE_EXTERNO PE         ON PED.PEXT_CODIGO = PE.PEXT_CODIGO      
      LEFT JOIN PROFISSIONAL P              ON PE.profref_codigo = P.PROF_CODIGO      
      LEFT JOIN unidade_referencia UR       ON PE.unidref_codigo = UR.unidref_codigo  
      LEFT JOIN Unidade  UNID               ON UR.unid_codigo = UNID.unid_codigo
	  LEFT JOIN INTERNACAO I			    ON PED.inter_codigo = I.inter_codigo
      LEFT JOIN vwLocal_Atendimento VL				    ON I.locatend_codigo = VL.LOCATEND_CODIGO    
	    
  
      WHERE PED.pedexarad_codigo = @Codigo      
      AND   PED.PEXT_CODIGO is not null      
      AND   ERS.EXARAD_STATUS = 'L'      
	  AND (@EXARAD_COD IS NULL OR (ERS.EXARAD_CODIGO = @EXARAD_COD))     
      
  
-- ATUALIZA TEMPORÁRIA  
  UPDATE  #TMP      
 SET EXARAD_LAUDO = RER.EXARAD_LAUDO,      
  LAUDO_PROF_NOME = P.PROF_NOME ,      
  LAUDO_LOCATEND_DESCRICAO = LA.LOCATEND_DESCRICAO ,      
  LAUDO_DATA = RER.EXARAD_DATA_LAUDO,  
  prof_numconselho = isnull(OEC.orgem_descricao,'') + ISNULL(P.prof_numconselho,PL.prof_numconselho) + ' ' +UF.uf_codigo,  
  LAUDO_ASSELETRONICA = pra.prof_asseletronica,  
  CID_DESCRICAO = CID.cid_descricao,  
  CBO = ocu.NO_OCUPACAO  
 FROM #TMP  
  INNER JOIN RESULTADO_EXAME_RADIOLOGICO RER ON #TMP.EXARAD_CODIGO = RER.EXARAD_CODIGO AND #TMP.PEDEXARAD_CODIGO = RER.PEDEXARAD_CODIGO  
  INNER JOIN PROFISSIONAL P ON RER.PROF_CODIGO = P.PROF_CODIGO AND RER.LOCATEND_CODIGO = P.LOCATEND_CODIGO  
  INNER JOIN VWLOCAL_UNIDADE LA ON RER.LOCATEND_CODIGO = LA.LOCATEND_CODIGO  
  INNER JOIN PROFISSIONAL_LOTACAO PL ON RER.PROF_CODIGO = PL.PROF_CODIGO AND RER.LOCATEND_CODIGO = PL.LOCATEND_CODIGO 
  LEFT JOIN unidade_federativa UF ON PL.prof_UF_registro = UF.uf_sigla  
  left JOIN TB_OCUPACAO ocu ON ocu.CO_OCUPACAO = rtrim(ltrim((SELECT SUBSTRING(UNID.CBO_MEDICO_RADIOLOGIA,1,6) FROM UNIDADE UNID WHERE LA.unid_codigo = UNID.unid_codigo)))  
  LEFT JOIN PROFISSIONAL_REDE_ASSINATURA PRA ON P.PROF_CODIGO = PRA.PROF_CODIGO  
  LEFT JOIN Cid_10 CID ON RER.Cid_Possivel = CID.cid_codigo  
  LEFT JOIN Tipo_Profissional tip on tip.tipprof_codigo = pl.tipprof_codigo  
  LEFT JOIN Orgao_Emissor_Conselho OEC on oec.orgem_codigo = tip.orgem_codigo
   
    
   
    
SELECT  #TMP.pac_codigo,       
   pac_nome,       
   #TMP.prof_codigo,       
   pp.Pac_Prontuario_Numero as 'pac_prontuario',       
   #TMP.locatend_codigo,        
   pedexarad_datahora,       
   pedexarad_entrega,
   pedexarad_codigo,      
   #TMP.EMER_CODIGO,       
   ATENDAMB_CODIGO,       
   #TMP.INTER_CODIGO,       
   #TMP.SPA_CODIGO,      
   ORIGEM_DESCRICAO,      
   ORIGEM,      
   LOCATEND_DESCRICAO,      
   PROF_NOME,      
   EXARAD_DESCRICAO,      
   EXARAD_CODIGO,      
   PEXT_CODIGO,        
   UNID_DESCRICAO,      
   IDADE,      
   SEXO,    
   prof_numconselho,  
   solpedexa_complemento,
  CONVERT(VARCHAR(max),EXARAD_LAUDO) AS 'EXARAD_LAUDO',    
 (LAUDO_PROF_NOME),      
  LAUDO_LOCATEND_DESCRICAO,      
  LAUDO_DATA,  
  prof_numconselho,  
  LAUDO_ASSELETRONICA,  
  CID_DESCRICAO,  
  CBO,
  (L.enf_codigo+'/'+L.lei_codigo) AS LEITO  
FROM #TMP   
LEFT JOIN INTERNACAO I ON (I.spa_codigo  = #TMP.SPA_CODIGO or I.emer_codigo = #TMP.EMER_CODIGO or I.inter_codigo= #TMP.INTER_CODIGO) and I.pac_codigo = #TMP.PAC_CODIGO
LEFT JOIN vwleito L ON  L.locatend_codigo = I.locatend_leito and L.lei_codigo = I.lei_codigo   
LEFT JOIN PACIENTE_PRONTUARIO PP        ON  #TMP.pac_codigo = PP.PAC_CODIGO 
      
DROP TABLE #TMP
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
PRINT N'Refreshing [dbo].[Ksp_Ficha_Atendimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_Ficha_Atendimento]';


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
PRINT N'Refreshing [dbo].[ksp_Diagnostico_Sugerido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Diagnostico_Sugerido]';


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
PRINT N'Refreshing [dbo].[ksp_PEP_Boletim_Atendimento_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Boletim_Atendimento_Impresso]';


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
PRINT N'Refreshing [dbo].[ksp_PEP_Relatorio_Boletim_Subreport_Exame_Fisico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Relatorio_Boletim_Subreport_Exame_Fisico]';


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
PRINT N'Checking existing data against newly created constraints';

GO
PRINT N'Update complete.';
GO
DECLARE @versao varchar(30)
SET @versao = 'K.2020.06.8'

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

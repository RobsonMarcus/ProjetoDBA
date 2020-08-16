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
PRINT N'Altering [dbo].[Encaminhamento_Externo_Ser2]...';


GO
ALTER TABLE [dbo].[Encaminhamento_Externo_Ser2]
    ADD [enex_data_encaminhamentofila] DATETIME       NULL,
        [enex_usuario_filacadastro]    VARCHAR (100)  NULL,
        [enex_especialidade_descricao] VARCHAR (1000) NULL,
        [enex_procedimento]            VARCHAR (100)  NULL;


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
PRINT N'Altering [dbo].[Item_Prescricao_Cuidados_Especiais]...';


GO
ALTER TABLE [dbo].[Item_Prescricao_Cuidados_Especiais] ALTER COLUMN [ipce_intervalo] INT NULL;


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
PRINT N'Altering [dbo].[Item_Prescricao_Medicamento]...';


GO
ALTER TABLE [dbo].[Item_Prescricao_Medicamento]
    ADD [IsPassivelDeDiluicao]            CHAR (1)       NULL,
        [IsDiluente]                      CHAR (1)       NULL,
        [diluente_medicamento_id]         INT            NULL,
        [diluente_ins_descricao]          VARCHAR (500)  NULL,
        [diluente_volume]                 NUMERIC (9, 2) NULL,
        [diluente_volume_total]           NUMERIC (9, 2) NULL,
        [diluente_valor_velocidade]       NUMERIC (9, 2) NULL,
        [diluente_medida_velocidade]      VARCHAR (100)  NULL,
        [diluente_ins_descricao_resumida] VARCHAR (200)  NULL,
        [referencia_id]                   INT            NULL,
        [referencia_descricao]            VARCHAR (500)  NULL,
        [diluente_ins_codigo]             INT            NULL,
        [diluente_gera_pedido_paciente]   CHAR (1)       NULL;


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
PRINT N'Altering [dbo].[Item_Prescricao_Sinais_Vitais]...';


GO
ALTER TABLE [dbo].[Item_Prescricao_Sinais_Vitais] ALTER COLUMN [ipsv_intervalo] INT NULL;


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
PRINT N'Altering [dbo].[setor_clinica]...';


GO
ALTER TABLE [dbo].[setor_clinica] DROP COLUMN [LOCAL_USO];


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
PRINT N'Creating [dbo].[Diluente_Medicamento]...';


GO
CREATE TABLE [dbo].[Diluente_Medicamento] (
    [dime_codigo]            UNIQUEIDENTIFIER NOT NULL,
    [dime_diluente]          VARCHAR (200)    NULL,
    [dime_medicamento]       VARCHAR (200)    NULL,
    [usu_codigo]             CHAR (4)         NULL,
    [dime_ativo]             CHAR (1)         NULL,
    [dime_codigodiluente]    VARCHAR (200)    NULL,
    [dime_codigomedicamento] VARCHAR (200)    NULL,
    CONSTRAINT [PK_Diluente_Medicamento] PRIMARY KEY CLUSTERED ([dime_codigo] ASC)
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
PRINT N'Creating [dbo].[Diluente_Medicamento_Historico]...';


GO
CREATE TABLE [dbo].[Diluente_Medicamento_Historico] (
    [dmhi_codigo]            UNIQUEIDENTIFIER NOT NULL,
    [dime_codigo]            UNIQUEIDENTIFIER NOT NULL,
    [usu_codigo]             VARCHAR (200)    NULL,
    [dmhi_medicamento]       VARCHAR (200)    NULL,
    [dmhi_diluente]          VARCHAR (200)    NULL,
    [dmhi_data]              DATETIME         NULL,
    [dmhi_medicamentocodigo] VARCHAR (200)    NULL,
    [dmhi_diluentecodigo]    VARCHAR (200)    NULL,
    [dmhi_tipoacao]          VARCHAR (200)    NULL,
    CONSTRAINT [PK_Diluente_Medicamento_Historico] PRIMARY KEY CLUSTERED ([dmhi_codigo] ASC)
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
PRINT N'Creating [dbo].[IntegracaoSolutiCertificadoDigital]...';


GO
CREATE TABLE [dbo].[IntegracaoSolutiCertificadoDigital] (
    [UrlApiKlinikos] VARCHAR (100) NULL,
    [UrlApiSoluti]   VARCHAR (100) NULL,
    [Ativo]          BIT           NULL,
    [CodigoUnidade]  VARCHAR (4)   NULL
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
PRINT N'Creating [dbo].[RelatorioAssinado]...';


GO
CREATE TABLE [dbo].[RelatorioAssinado] (
    [ArquivoRPT]           VARCHAR (300)   NULL,
    [CodigoRelatorio]      INT             NULL,
    [DataHora]             DATETIME        NULL,
    [ResultadoLink]        VARCHAR (300)   NULL,
    [ResultadoBase64]      VARBINARY (MAX) NULL,
    [CodigoPrescricao]     VARCHAR (12)    NULL,
    [CodigoProfissional]   VARCHAR (4)     NULL,
    [CodigoReceita]        VARCHAR (12)    NULL,
    [AtestadoMedicoCodigo] INT             NULL,
    [AtendCodigo]          VARCHAR (12)    NULL,
    [PacCodigo]            VARCHAR (12)    NULL
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
PRINT N'Creating unnamed constraint on [dbo].[IntegracaoSolutiCertificadoDigital]...';


GO
ALTER TABLE [dbo].[IntegracaoSolutiCertificadoDigital]
    ADD DEFAULT ((0)) FOR [Ativo];


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_CE_emer]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_CE_emer]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_CE_urge]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_CE_urge]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_MED_EMER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_MED_EMER]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_MED_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_MED_URGE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_REC_MED_EMER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_REC_MED_EMER]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_REC_MED_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_REC_MED_URGE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_SV_emer]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_SV_emer]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_SV_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_PRES_OXI_SV_URGE]';


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
PRINT N'Refreshing [dbo].[knvwAgendaConsultaExame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[knvwAgendaConsultaExame]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ACOLHIMENTO_ENTIDADE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ACOLHIMENTO_ENTIDADE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PARECER_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PARECER_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PARECER_URGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PARECER_URGENCIA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PEDIDO_PARECER_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PEDIDO_PARECER_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PEDIDO_PARECER_URGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_ITEM_PEDIDO_PARECER_URGENCIA]';


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
PRINT N'Refreshing [dbo].[vwAgendaConsultaSMS]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwAgendaConsultaSMS]';


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
PRINT N'Refreshing [dbo].[VWCLINICA_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VWCLINICA_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[vwClinica_Internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwClinica_Internacao]';


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
PRINT N'Refreshing [dbo].[VWCLINICA_LEITO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VWCLINICA_LEITO]';


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
PRINT N'Refreshing [dbo].[vwClinica_LeitoInternacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwClinica_LeitoInternacao]';


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
PRINT N'Refreshing [dbo].[vwClinica_Spa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwClinica_Spa]';


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
PRINT N'Refreshing [dbo].[vwClinicaSolicitaCirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwClinicaSolicitaCirurgia]';


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
PRINT N'Refreshing [dbo].[vwClinicaSolicitaInternacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwClinicaSolicitaInternacao]';


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
PRINT N'Refreshing [dbo].[VWENFERMARIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VWENFERMARIA]';


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
PRINT N'Refreshing [dbo].[vwInternacaoOpcao0]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwInternacaoOpcao0]';


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
PRINT N'Refreshing [dbo].[vwleito]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwleito]';


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
PRINT N'Refreshing [dbo].[VWLEITO_COMPLETO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VWLEITO_COMPLETO]';


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
PRINT N'Refreshing [dbo].[vwLocal_Atendimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwLocal_Atendimento]';


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
PRINT N'Refreshing [dbo].[vwLocal_Emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwLocal_Emergencia]';


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
PRINT N'Refreshing [dbo].[vwLocal_Todos_Atendimentos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwLocal_Todos_Atendimentos]';


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
PRINT N'Refreshing [dbo].[vwLocal_Unidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwLocal_Unidade]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_INTERNACAO_E_ALTA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_INTERNACAO_E_ALTA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_INTERNACAO_PEDIDO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_INTERNACAO_PEDIDO]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_INTERNACAO_PEDIDO_ENTIDADE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_INTERNACAO_PEDIDO_ENTIDADE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_INTERNACAO_SAIDA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_INTERNACAO_SAIDA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_SOLICITACAO_CIRURGIA_ITEM]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_SOLICITACAO_CIRURGIA_ITEM]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_SOLICITACAO_CIRURGIA_PROCEDIMENTOS]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_SOLICITACAO_CIRURGIA_PROCEDIMENTOS]';


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
PRINT N'Refreshing [dbo].[VW_BI_Internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_BI_Internacao]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ACOLHIMENTO_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ACOLHIMENTO_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ACOLHIMENTO_URGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ACOLHIMENTO_URGENCIA]';


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
PRINT N'Refreshing [dbo].[VWUrgencia_Emergencia_Internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VWUrgencia_Emergencia_Internacao]';


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
PRINT N'Refreshing [dbo].[VW_BI_Leitos_Ope_Atu]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_BI_Leitos_Ope_Atu]';


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
PRINT N'Refreshing [dbo].[VW_BI_Leitos_Operaci]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_BI_Leitos_Operaci]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_OBSERVACAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_OBSERVACAO]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_DETALHE_EMER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_DETALHE_EMER]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_DETALHE_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_DETALHE_URGE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_EVOL_DETALHE_EMER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_EVOL_DETALHE_EMER]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_EVOL_DETALHE_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_EVOL_DETALHE_URGE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_SVITAL_EMER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_SVITAL_EMER]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_ATEND_MEDICO_SVITAL_URGE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_ATEND_MEDICO_SVITAL_URGE]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_LABORATORIO_PEDIDO_EXAME_ENTIDADE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_LABORATORIO_PEDIDO_EXAME_ENTIDADE]';


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
PRINT N'Refreshing [dbo].[VW_MITRA_PROCEDIMENTOS_REALIZADOS_ENTIDADE_ITEM]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_MITRA_PROCEDIMENTOS_REALIZADOS_ENTIDADE_ITEM]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_EXAME_FILME]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_EXAME_FILME]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_EXAME_LAUDO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_EXAME_LAUDO]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_EXAME_SOLICITADO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_EXAME_SOLICITADO]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ATEND]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ATEND]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ATO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ATO]';


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
PRINT N'Refreshing [dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ENTIDADE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_MITRA_RADIOLOGIA_PEDIDO_EXAME_ENTIDADE]';


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
PRINT N'Refreshing [dbo].[vwAgendaCirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwAgendaCirurgia]';


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
PRINT N'Refreshing [dbo].[vwAtendimentoAmbulatorialOpcao0]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwAtendimentoAmbulatorialOpcao0]';


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
PRINT N'Refreshing [dbo].[vwEmergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwEmergencia]';


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
PRINT N'Refreshing [dbo].[vwEmergenciaOpcao0]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwEmergenciaOpcao0]';


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
PRINT N'Refreshing [dbo].[vwPacienteOpcao0]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwPacienteOpcao0]';


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
PRINT N'Refreshing [dbo].[vwPRESCRICAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwPRESCRICAO]';


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
PRINT N'Refreshing [dbo].[vwPRESCRICAO_MEDICA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwPRESCRICAO_MEDICA]';


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
PRINT N'Refreshing [dbo].[vwProntoAtendimentoOpcao0]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwProntoAtendimentoOpcao0]';


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
PRINT N'Refreshing [dbo].[vwSolicitacaoCirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwSolicitacaoCirurgia]';


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
PRINT N'Refreshing [dbo].[vwSPA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwSPA]';


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
PRINT N'Refreshing [dbo].[vwUPA_Fila_Historico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwUPA_Fila_Historico]';


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
PRINT N'Altering [dbo].[KSP_Encaminhamento_Externo_Ser2]...';


GO
-- DROP PROCEDURE [dbo].[KSP_Encaminhamento_Externo_Ser2]            
ALTER PROCEDURE [dbo].[KSP_Encaminhamento_Externo_Ser2]            
          
@enex_id uniqueidentifier = NULL,          
@atend_id char(12) = NULL,          
@enex_data datetime = NULL,          
@enex_data_atualizacao datetime = NULL,          
@enex_data_final  datetime = NULL,          
@enex_tipovaga varchar(10) = NULL,          
@enex_protocolo varchar(200) = NULL,          
@enex_especialidade varchar(4000) = NULL,          
@enex_situacaoatual varchar(200) = NULL,          
@pac_codigo char(12) = NULL,          
@enex_prioridade varchar(10) = NULL,        
@enex_data_encaminhamentofila datetime = NULL,          
@enex_data_encaminhamentofila_filtro datetime = NULL,    
@enex_usuario_filacadastro char(100) = NULL,          
@enex_especialidade_descricao VARCHAR(1000) = NULL,    
@enex_procedimento VARCHAR(100) = NULL,  
@opcao int = NULL          
          
AS          
      
    
-- --------------------------------------------------------------------------------------------------------------------------------          
-- Consulta Por Id          
-- --------------------------------------------------------------------------------------------------------------------------------          
IF @opcao = 0              
  BEGIN          
          
     SELECT enex_id          
    , atend_id          
    , enex_data          
    , enex_tipovaga          
    , enex_protocolo          
    , enex_especialidade          
    , enex_situacaoatual          
    , enex_data_atualizacao          
    , enex_prioridade        
    , paciente.pac_codigo        
    , paciente.pac_nome        
    , pac_nascimento        
    , pac_sexo        
    , pac_cpf        
    , pac_mae        
    , enex_data_encaminhamentofila      
    , enex_usuario_filacadastro     
 , enex_procedimento  
 , enex_especialidade_descricao     
 FROM Encaminhamento_Externo_Ser2          
INNER JOIN atendimento_ambulatorial        
        ON Encaminhamento_Externo_Ser2.atend_id = atendimento_ambulatorial.atendamb_codigo          
INNER JOIN paciente           
        ON atendimento_ambulatorial.pac_codigo = paciente.pac_codigo          
 WHERE @enex_id = enex_id          
          
END          
-- --------------------------------------------------------------------------------------------------------------------------------          
-- Inclusão          
-- --------------------------------------------------------------------------------------------------------------------------------          
IF @opcao = 1          
  BEGIN          
          
INSERT INTO Encaminhamento_Externo_Ser2          
          ( enex_id          
    , atend_id          
    , enex_data          
    , enex_tipovaga          
    , enex_protocolo          
    , enex_especialidade          
    , enex_situacaoatual          
    , enex_data_atualizacao        
    , enex_data_encaminhamentofila      
    , enex_usuario_filacadastro  
    , enex_especialidade_descricao    
    , enex_prioridade  
 , enex_procedimento)          
    VALUES          
       ( @enex_id          
    , @atend_id          
    , @enex_data          
    , @enex_tipovaga          
    , @enex_protocolo          
    , @enex_especialidade          
    , @enex_situacaoatual          
    , @enex_data_atualizacao        
    , @enex_data_encaminhamentofila      
    , @enex_usuario_filacadastro      
    , @enex_prioridade    
    , @enex_especialidade_descricao  
 , @enex_procedimento)    
          
END          
-- --------------------------------------------------------------------------------------------------------------------------------          
-- Atualização de situação          
-- --------------------------------------------------------------------------------------------------------------------------------          
IF @opcao = 2          
  BEGIN          
          
     UPDATE Encaminhamento_Externo_Ser2          
        SET enex_situacaoatual = @enex_situacaoatual          
      WHERE enex_id = @enex_id          
          
END          
-- --------------------------------------------------------------------------------------------------------------------------------          
-- Consulta em lista          
-- --------------------------------------------------------------------------------------------------------------------------------          
IF @opcao = 3              
  BEGIN          
          
     SELECT enex_id          
       , atend_id          
       , enex_data          
       , enex_tipovaga          
       , enex_protocolo          
       , enex_especialidade          
       , enex_situacaoatual          
       , enex_data_atualizacao          
    , enex_prioridade        
    , paciente.pac_codigo        
    , paciente.pac_nome        
    , pac_nascimento        
    , pac_sexo        
    , pac_cpf        
    , pac_mae        
    , enex_data_encaminhamentofila      
    , enex_usuario_filacadastro      
 , enex_especialidade_descricao    
 , enex_procedimento  
       FROM Encaminhamento_Externo_Ser2          
 INNER JOIN atendimento_ambulatorial        
         ON Encaminhamento_Externo_Ser2.atend_id = atendimento_ambulatorial.atendamb_codigo          
 INNER JOIN paciente           
         ON atendimento_ambulatorial.pac_codigo = paciente.pac_codigo          
      WHERE (enex_especialidade = @enex_especialidade OR @enex_especialidade IS NULL )    
     AND ( atendimento_ambulatorial.pac_codigo = @pac_codigo OR @pac_codigo  IS NULL )          
        AND ( enex_protocolo = @enex_protocolo OR @enex_protocolo IS NULL )          
        AND ( enex_situacaoatual = @enex_situacaoatual OR @enex_situacaoatual IS NULL)          
         AND ( enex_data BETWEEN @enex_data AND @enex_data_final)        
        AND ( enex_especialidade = @enex_especialidade OR @enex_especialidade IS NULL )           
END     
IF @opcao = 4    
BEGIN    
 SELECT enex_id          
       , atend_id          
       , enex_data          
       , enex_tipovaga          
       , enex_protocolo          
       , enex_especialidade          
       , enex_situacaoatual          
       , enex_data_atualizacao          
    , enex_prioridade        
    , paciente.pac_codigo        
    , paciente.pac_nome        
    , pac_nascimento        
    , pac_sexo        
    , pac_cpf        
    , pac_mae        
    , enex_data_encaminhamentofila      
    , enex_usuario_filacadastro      
 , enex_especialidade_descricao    
 , enex_procedimento  
       FROM Encaminhamento_Externo_Ser2          
 INNER JOIN atendimento_ambulatorial        
         ON Encaminhamento_Externo_Ser2.atend_id = atendimento_ambulatorial.atendamb_codigo          
 INNER JOIN paciente           
         ON atendimento_ambulatorial.pac_codigo = paciente.pac_codigo          
      WHERE enex_situacaoatual = 'Pendente de Cadastro'     
        AND (enex_data_encaminhamentofila BETWEEN @enex_data_encaminhamentofila AND @enex_data_encaminhamentofila_filtro  )
        AND (enex_especialidade = @enex_especialidade OR @enex_especialidade IS NULL )    
        AND ( atendimento_ambulatorial.pac_codigo = @pac_codigo OR @pac_codigo  IS NULL )          
          
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Cuidados_Especiais]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Cuidados_Especiais]
@ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @CUES_CODIGO INT, @IPCE_INTERVALO INT, @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @ItemPrescricaoSuspensa CHAR(1)=null
AS
DECLARE @SQL VARCHAR(8000)
DECLARE @PAR VARCHAR(500)
DECLARE @VAR VARCHAR(500)
  
IF (@OPCAO = 0) /* LIST */

BEGIN

   SET @SQL =        ' SELECT '
   SET @SQL = @SQL + '   presc_codigo, itpresc_codigo, cues_codigo, ipce_intervalo, ItemPrescricaoSuspensa '
   SET @SQL = @SQL + ' FROM '
   SET @SQL = @SQL + '   Item_Prescricao_Cuidados_Especiais '
   SET @SQL = @SQL + ' WHERE '
 IF @PRESC_CODIGO IS NOT NULL
 BEGIN
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO)
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT
 END
 IF @ITPRESC_CODIGO IS NOT NULL
 BEGIN
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO)
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT
 END
 IF @CUES_CODIGO IS NOT NULL
 BEGIN
   SET @VAR = CONVERT(VARCHAR, @CUES_CODIGO)
   EXEC KSP_PARAMETROPESQUISA @VAR, "cues_codigo ", @TP_PESQ, "T", @PAR OUTPUT
 END
 IF @IPCE_INTERVALO IS NOT NULL
 BEGIN
   SET @VAR = CONVERT(VARCHAR, @IPCE_INTERVALO)
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipce_intervalo ", @TP_PESQ, "T", @PAR OUTPUT
 END
SET @SQL = (@SQL + @PAR)
EXEC (@SQL)

END

IF (@OPCAO = 1)  /* INCLUSAO */

BEGIN

   INSERT INTO Item_Prescricao_Cuidados_Especiais (ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, cues_codigo, ipce_intervalo, ItemPrescricaoSuspensa)
        VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @ITPRESC_CODIGO, @CUES_CODIGO, @IPCE_INTERVALO, @ItemPrescricaoSuspensa)
END

IF (@OPCAO = 2)  /* ALTERACAO */

BEGIN

   UPDATE
     Item_Prescricao_Cuidados_Especiais
   SET
     ipce_intervalo = @IPCE_INTERVALO
   WHERE
     presc_codigo = @PRESC_CODIGO AND
     itpresc_codigo = @ITPRESC_CODIGO AND
     cues_codigo = @CUES_CODIGO
END

IF (@OPCAO= 3) /* EXCLUSAO */

BEGIN

   DELETE FROM Item_Prescricao_Cuidados_Especiais
   WHERE
	presc_codigo = @PRESC_CODIGO AND
	itpresc_codigo = @ITPRESC_CODIGO AND
	cues_codigo = @CUES_CODIGO
END

IF (@OPCAO= 4) /* PROCURA POR CHAVE */

BEGIN

   SELECT
     presc_codigo, itpresc_codigo, cues_codigo, ipce_intervalo, ItemPrescricaoSuspensa
   FROM
     Item_Prescricao_Cuidados_Especiais
   WHERE
	presc_codigo = @PRESC_CODIGO AND
	itpresc_codigo = @ITPRESC_CODIGO AND
	cues_codigo = @CUES_CODIGO     
END

IF (@OPCAO= 5) /* LISTA TODOS */

BEGIN
   SELECT * FROM Item_Prescricao_Cuidados_Especiais
END

IF (@OPCAO = 6)  /* ALTERACAO SUSPENSAO*/
 
BEGIN

   UPDATE
     Item_Prescricao_Cuidados_Especiais
   SET
     ItemPrescricaoSuspensa = @ItemPrescricaoSuspensa
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END


IF (@OPCAO= 7) /* LISTA TODOS AS PRESCRICOES APRAZADAS */

BEGIN
          
   SELECT  IPCE.presc_codigo, IPCE.itpresc_codigo, IPCE.ItemPrescricaoSuspensa  
    FROM   Item_Prescricao_Cuidados_Especiais IPCE
	 Left Join Item_Aprazamento ITAP ON ITAP.presc_codigo = IPCE.presc_codigo and ITAP.itpresc_codigo = IPCE.itpresc_codigo
	WHERE /*IPCE.presc_codigo = @PRESC_CODIGO
	AND IPCE.itpresc_codigo = @ITPRESC_CODIGO */
	IPCE.item_prescricao_id = @ITEM_PRESCRICAO_ID
	AND ITAP.data_checagem is not null

      
END


-----LISTA ITENS DA PRESCRICAO POR PRESC_CODIGO E/OU ITEM_PRESCRICAO_ID
IF @OPCAO = 8
BEGIN

     SELECT
		ipce.item_prescricao_id,
		ipce.presc_codigo,
		ipce.itpresc_codigo,
		ipce.cues_codigo,
		ipce.ipce_intervalo,
		ipce.ItemPrescricaoSuspensa,
		IPO.itpresc_obs,
		CE.cues_descricao
     FROM Item_Prescricao_Cuidados_Especiais IPCE
	 JOIN Item_Prescricao IPO ON ipce.item_prescricao_id = IPO.item_prescricao_id
	 JOIN Cuidados_Especiais CE ON IPCE.cues_codigo = CE.cues_codigo
     WHERE IPCE.presc_codigo = ISNULL(@PRESC_CODIGO, IPCE.presc_codigo)
     AND ipce.item_prescricao_id = ISNULL(@ITEM_PRESCRICAO_ID, ipce.item_prescricao_id)

END

IF @OPCAO = 18
BEGIN
	update Item_Prescricao_Cuidados_Especiais set ItemPrescricaoSuspensa = 'S' where item_prescricao_id = @ITEM_PRESCRICAO_ID
end
  
IF (@@ERROR <> 0)

BEGIN
         RAISERROR('ERRO: ksp_Item_Prescricao_Cuidados_Especiais',1,1)
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Dto]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Dto]
@PRESC_CODIGO CHAR (15), @ITPRESC_CODIGO INT=0, @data VARCHAR (1000)='', @item VARCHAR (8000)='', @linha INT=0, @i INT=0, @horario VARCHAR (8000)='', @quantidade VARCHAR (8000)='', @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT
AS
DECLARE @SQL VARCHAR(8000)                                                        
DECLARE @PAR VARCHAR(500)                                                        
DECLARE @VAR VARCHAR(500)                                  
                                                        
IF (@OPCAO = 0) /* LIST */                                                        
BEGIN                                                        
                                                         
 --Cria a Tabela Temporária                                                        
 Create table #teste(presc_codigotemp varchar(200), itpresc_codigotemp varchar(20), dosedata varchar(5000), quantidade varchar(8000))                                                        
                                                         
 --Populo a variável linha                                                        
 select  @linha = count(distinct(itpm.itpresc_codigo)) from Item_Prescricao_Medicamento itpm                                                        
    
  where itpm.presc_codigo  = @presc_codigo                                                        
                                                         
 SET @I = 0                                                        
                                                        
 If(@linha >0)                                                        
 begin                                                        
  while(@linha != 0)                              
  begin                                                        
   select  top 1  @i = itpm.itpresc_codigo from Item_Prescricao_Medicamento itpm                                                        
     
   where itpm.presc_codigo  = @presc_codigo                                                        
   and   itpm.itpresc_codigo  > @i                                                        
   group by itpm.itpresc_codigo                                                        
          
                                    
   select                                      
    @DATA = ISNULL(@DATA, '')  + CAST(DATEPART(HH,ITAP.DOSE_DATA)AS VARCHAR) +' / '                                                        
   from ITEM_APRAZAMENTO ITAP                                                   
   where ITAP.presc_codigo = @PRESC_CODIGO and ITAP.itpresc_codigo = @I                                                        
   GROUP BY ITAP.DOSE_DATA                              
                                    
   insert into #teste(presc_codigotemp, itpresc_codigotemp , dosedata, quantidade)values(@presc_codigo, @i, @data, @item)                                                        
 set @data = NULL                                                        
   set @item = ''                                                        
 set @linha = @linha -1                                                        
  end                                                        
 end                                   
                                                         
 select  itpr.presc_codigo,                                                         
    itpr.itpresc_codigo,                              
    itpr.itpresc_obs,                              
                              
  case when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia <> 0 then 'M1' -- Medicamento com intervalo                    
       when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia = 0 then 'M2' -- Medicamento com duração                    
       when itps.presc_codigo = @presc_codigo then 'S' -- Sinais Vitais                              
       when itce.presc_codigo = @presc_codigo then 'C' -- Cuidados Especiais                              
       when itd.presc_codigo  = @presc_codigo then 'D' -- Dieta                              
       when itpo.presc_codigo = @presc_codigo then 'O' -- Oxigenoterapia                              
       when ippr.presc_codigo = @presc_codigo then 'P' -- Procedimento                              
       end as TipoItemPrescricao,                              
                                          
  case when itpm.presc_codigo = @presc_codigo then                     
  case when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'M' then itpm.itpresc_duracao                     
    when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'H' then itpm.itpresc_duracao * 60                    
    when itpm.itpresc_frequencia = 1440 and itpresc_tpduracao = 'I' then itpm.itpresc_duracao * 24      
    when itpm.itpresc_frequencia <> 0 and (itpm.itpresc_frequencia = 15 or itpm.itpresc_frequencia = 30) then itpm.itpresc_frequencia           
    when itpm.itpresc_frequencia <> 0 AND itpm.itpresc_frequencia <> 15 and itpm.itpresc_frequencia <> 30 then itpm.itpresc_frequencia / 60  end          
       when itps.presc_codigo = @presc_codigo then itps.ipsv_intervalo                              
       when itce.presc_codigo = @presc_codigo then itce.ipce_intervalo                              
       when itpo.presc_codigo = @presc_codigo then itpo.ipox_intervalo                    
       when ippr.presc_codigo = @presc_codigo then null           
       end as Intervalo,                                            
                                                          
  case when itpm.presc_codigo = @presc_codigo then (itpm.ins_descricao) + Isnull(itpm.quantidade,'')                              
       when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)                              
       when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)                                          
       when itd.presc_codigo = @presc_codigo then (itd.ipdi_texto)                            
       when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)                              
       when ippr.presc_codigo = @presc_codigo then (pr.no_procedimento)                              
       end as Descricao,                              
                              
   case when itpm.presc_codigo = @presc_codigo then              
    case when itpm.itpresc_frequencia = 15 or itpm.itpresc_frequencia = 30 then convert(varchar,itpm.itpresc_frequencia) + '/' + convert(varchar,itpm.itpresc_frequencia) + ' min'              
 when itpm.itpresc_frequencia = 1440 and itpm.itpresc_tpfrequencia = 'I' then 'Imediato'             
    when itpm.itpresc_frequencia <> 15 and itpm.itpresc_frequencia <> 30 and itpm.itpresc_frequencia <> 0 then convert(varchar,itpm.itpresc_frequencia/60) + '/' + convert(varchar,itpm.itpresc_frequencia/60) + ' hora(s)'    --Boris          
    when itpm.itpresc_frequencia = 0 and itpm.itpresc_tpduracao = 'M' then 'Durante ' + convert(varchar,itpm.itpresc_duracao) + ' minunto(s)'              
    when itpm.itpresc_frequencia = 0 and itpm.itpresc_tpduracao = 'H' then 'Durante ' + convert(varchar,itpm.itpresc_duracao) + ' hora(s)' end              
       when itps.presc_codigo = @presc_codigo then 'Intervalo - ' + convert(varchar,itps.ipsv_intervalo) + '/' + convert(varchar,itps.ipsv_intervalo)                              
       when itce.presc_codigo = @presc_codigo then 'Intervalo - ' + convert(varchar,itce.ipce_intervalo) + '/' + convert(varchar,itce.ipce_intervalo)                              
       when itd.presc_codigo  = @presc_codigo then convert(varchar,itd.ipdi_kcal) + ' Kcal'                              
    when itpo.presc_codigo = @presc_codigo and itpo.ipox_unidade_tempo = 0 and ox.oxi_tipo = 0 then ' (Contínua) ' + convert(varchar,ipox_unidade) + '% FiO2'                                
       when itpo.presc_codigo = @presc_codigo and itpo.ipox_unidade_tempo = 0 and ox.oxi_tipo = 1 then ' (Contínua) ' + convert(varchar,ipox_unidade) + ' L/min'                                
       when itpo.presc_codigo = @presc_codigo and itpo.ipox_unidade_tempo = 1 and ox.oxi_tipo = 0 then                             
  ' (Intervalo - ' + convert(varchar,itpo.ipox_intervalo) + '/' + convert(varchar,itpo.ipox_intervalo) + ') ' + convert(varchar,ipox_unidade) + '% FiO2'                                
       when itpo.presc_codigo = @presc_codigo and itpo.ipox_unidade_tempo = 1 and ox.oxi_tipo = 1 then                             
  ' (Intervalo - ' + convert(varchar,itpo.ipox_intervalo) + '/' + convert(varchar,itpo.ipox_intervalo) + ') ' + convert(varchar,ipox_unidade) + ' L/min'                           
       end as Detalhe,                              
   
    case 
       when itce.presc_codigo = @presc_codigo then itce.cues_codigo
       when itpo.presc_codigo = @presc_codigo then itpo.oxi_codigo                    
       end as Codigo,
  --itce.cues_codigo as Codigo,                                         
  --itpo.oxi_codigo as Codigo,                                          
  itpo.ipox_unidade_tempo as UnidadeTempo,                                          
  itpm.dosedata as Horario,                                  
  itap.ItemAprazado,                        
  itap_checagem.ItemChecado,                        
  p.presc_data,   
  itpm.itpresc_caracteristica,  
  itpm.itpresc_quantidade as Quantidade,  
  itpm.ins_unidade,
  
  case when itpm.presc_codigo = @presc_codigo then itpm.itpresc_frequencia 
       when itps.presc_codigo = @presc_codigo then null
       when itce.presc_codigo = @presc_codigo then null
       when itpo.presc_codigo = @presc_codigo then null               
       when ippr.presc_codigo = @presc_codigo then null           
       end as Frequencia,

	itpr.item_prescricao_id as ID,
	 
	 case when itpm.presc_codigo = @presc_codigo then itpm.medicamento_id
       else null
       end as medicamento_id,
	   case when itpm.presc_codigo = @presc_codigo then itpm.data_iniciar_em
       else null
       end as data_iniciar_em,

  case when itpm.presc_codigo = @presc_codigo then itpm.IsItemPrescricaoSuspensa
       when itps.presc_codigo = @presc_codigo then itps.ItemPrescricaoSuspensa
       when itce.presc_codigo = @presc_codigo then itce.ItemPrescricaoSuspensa
       when itd.presc_codigo = @presc_codigo  then itd.ItemPrescricaoSuspensa
       when itpo.presc_codigo = @presc_codigo then itpo.ItemPrescricaoSuspensa
       when ippr.presc_codigo = @presc_codigo then ippr.ItemPrescricaoSuspensa
       end as IsItemPrescricaoSuspensa,

	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_medicamento_id else null end as diluente_medicamento_id,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_ins_descricao else null end as diluente_ins_descricao,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_volume else null end as diluente_volume,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_volume_total else null end as diluente_volume_total,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_valor_velocidade else null end as diluente_valor_velocidade,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_medida_velocidade else null end as diluente_medida_velocidade,

  case when itpm.presc_codigo = @presc_codigo then itpm.itpresc_total else null end as itpresc_total,

    case when itpm.presc_codigo = @presc_codigo then (itpm.ins_descricao_resumida)                              
       when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)                              
       when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)                                          
       when itd.presc_codigo = @presc_codigo then (itd.ipdi_texto)                            
       when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)                              
       when ippr.presc_codigo = @presc_codigo then (pr.no_procedimento)                              
       end as DescricaoResumida,

	case when itpm.presc_codigo = @presc_codigo then itpm.IsPassivelDeDiluicao else null end as IsPassivelDeDiluicao,
	case when itpm.presc_codigo = @presc_codigo then itpm.viamed_codigo else null end as viamed_codigo,
	case when itpm.presc_codigo = @presc_codigo then itpm.viamed_descricao else null end as viamed_descricao,
	case when itpm.presc_codigo = @presc_codigo then itpm.ins_codigo_unidade else null end as ins_codigo_unidade
                      
  from prescricao p                                   
  join Item_Prescricao itpr on p.presc_codigo = itpr.presc_codigo                                  
  left join                                                         
  (                              
    select presc_codigo, itpresc_codigo, itpresc_quantidade, itpresc_frequencia, itpresc_duracao, itpresc_tpInsumo, ins_codigo, itpresc_total,                              
     itpresc_adm, itped_quantidade, ins_descricao, ins_unidade, codace, itpresc_saldo, itpresc_tpduracao, viamed_codigo, itpresc_qtd_sos, pome_codigo,                              
     forusomed_codigo, ped_codigo, itped_codigo, itpresc_tempedido, idtprescricao_diferenciada, itpresc_tpfrequencia, itpresc_velocidade_infusao,                              
     ( test.quantidade)as Quantidade,                              
     ( test.dosedata )as DoseData,   
	itpresc_caracteristica,
	medicamento_id,	data_iniciar_em, IsItemPrescricaoSuspensa,
	diluente_medicamento_id, diluente_ins_descricao, diluente_volume, diluente_volume_total, diluente_valor_velocidade, diluente_medida_velocidade,
	ins_descricao_resumida, IsPassivelDeDiluicao, viamed_descricao, ins_codigo_unidade
     from item_prescricao_medicamento itpm                              
         left join #teste test on test.presc_codigotemp = itpm.presc_codigo and test.itpresc_codigotemp = itpm.itpresc_codigo                         
     where itpm.presc_codigo = @presc_codigo                              
                                                           
  ) itpm on (itpm.presc_codigo = Isnull(@presc_codigo, itpm.presc_codigo) and itpr.itpresc_codigo = itpm.itpresc_codigo and itpr.presc_codigo = itpm.presc_codigo)                                                        
                                  
  left join Item_Prescricao_Sinais_Vitais itps on(itps.presc_codigo = Isnull(@presc_codigo, itps.presc_codigo) and itpr.itpresc_codigo = itps.itpresc_codigo and itpr.presc_codigo = itps.presc_codigo)                              
  left join Item_Prescricao_Cuidados_Especiais itce on(itce.presc_codigo = Isnull(@presc_codigo, itce.presc_codigo) and itpr.itpresc_codigo = itce.itpresc_codigo and itpr.presc_codigo = itce.presc_codigo)                              
  left join Item_Prescricao_Dieta itd on(itd.presc_codigo = Isnull(@presc_codigo, itd.presc_codigo) and itpr.itpresc_codigo = itd.itpresc_codigo and itpr.presc_codigo = itd.presc_codigo)                              
  left join Cuidados_Especiais ce on (itce.cues_codigo = ce.cues_codigo)                              
  left join Item_Prescricao_Oxigenoterapia itpo on (itpo.presc_codigo = Isnull(@presc_codigo, itpo.presc_codigo) and itpr.itpresc_codigo = itpo.itpresc_codigo and itpr.presc_codigo = itpo.presc_codigo)                              
  left join Oxigenoterapia ox on (ox.oxi_codigo = itpo.oxi_codigo)                              
  left join Item_Prescricao_Procedimento ippr on(ippr.presc_codigo = Isnull(@presc_codigo, ippr.presc_codigo) and itpr.itpresc_codigo = ippr.itpresc_codigo and itpr.presc_codigo = ippr.presc_codigo)                              
  left join TB_Procedimento pr on (pr.co_procedimento = ippr.co_procedimento)                              
                              
  left join                                  
  (                              
 select presc_codigo, itpresc_codigo, count(*) as ItemAprazado                              
 from item_aprazamento                              
 group by presc_codigo, itpresc_codigo                              
  ) itap on itap.presc_codigo = Isnull(@presc_codigo, itpr.presc_codigo) and itap.itpresc_codigo = itpr.itpresc_codigo                                  
                        
  left join                                  
  (                              
 select presc_codigo, itpresc_codigo, count(*) as ItemChecado                        
 from item_aprazamento                        
where dose_adm is not null                        
 group by presc_codigo, itpresc_codigo                              
  ) itap_checagem on itap_checagem.presc_codigo = Isnull(@presc_codigo, itpr.presc_codigo) and itap_checagem.itpresc_codigo = itpr.itpresc_codigo                                  
                        
                                           
  where itpr.presc_codigo =  Isnull(@presc_codigo, itpr.presc_codigo)                              
                                  
 drop Table #teste                                                        
end                                                        
                                                        
                                                        
if(@OPCAO = 1) /* Lista itens para aprazamento de acordo com a prescricao */                              
BEGIN                                                        
 select  itpr.presc_codigo,                                                         
  itpr.itpresc_codigo,                                                         
            
  case when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia <> 0 then 'M1' -- Medicamento com intervalo                    
       when itpm.presc_codigo = @presc_codigo and itpm.itpresc_frequencia = 0 then 'M2' -- Medicamento com duração                    
       when itps.presc_codigo = @presc_codigo then 'S' -- Sinais Vitais                              
       when itce.presc_codigo = @presc_codigo then 'C' -- Cuidados Especiais                              
       when itpd.presc_codigo  = @presc_codigo then 'D' -- Dieta                              
       when itpo.presc_codigo = @presc_codigo then 'O' -- Oxigenoterapia                              
       when ippr.presc_codigo = @presc_codigo then 'P' -- Procedimento                              
                end as TipoItemPrescricao,                 
            
  case when itpm.presc_codigo = @presc_codigo then (itpm.ins_descricao)                              
       when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)                              
       when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)                              
       when itpd.presc_codigo = @presc_codigo then (itpd.ipdi_texto)            
       when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)                              
       when ippr.presc_codigo = @presc_codigo then (pr.no_procedimento)                              
                 end as Descricao,                                                        
              
  case when itpm.presc_codigo = @presc_codigo then (itpm.quantidade)                
       when itps.presc_codigo = @presc_codigo then null                              
       when itpd.presc_codigo = @presc_codigo then null                              
       when itpo.presc_codigo = @presc_codigo then null                              
--       when ippr.presc_codigo = @presc_codigo then null                  
       when ippr.presc_codigo = @presc_codigo then (ippr.ippr_quantidade)                           
                 end as Quantidade,              
  case when itpm.presc_codigo = @presc_codigo then                     
  case when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'M' then itpm.itpresc_duracao                     
    when itpm.itpresc_frequencia = 0 and itpresc_tpduracao = 'H' then itpm.itpresc_duracao * 60                    
    when itpm.itpresc_frequencia <> 0 and (itpm.itpresc_frequencia = 15 or itpm.itpresc_frequencia = 30) then itpm.itpresc_frequencia           
    when itpm.itpresc_frequencia <> 0 AND itpm.itpresc_frequencia <> 15 and itpm.itpresc_frequencia <> 30 then itpm.itpresc_frequencia / 60  end          
       when itps.presc_codigo = @presc_codigo then itps.ipsv_intervalo                              
       when itce.presc_codigo = @presc_codigo then itce.ipce_intervalo                              
       when itpo.presc_codigo = @presc_codigo then itpo.ipox_intervalo                    
       when ippr.presc_codigo = @presc_codigo then null           
       end as Intervalo,             
  presc_quantidade,              
  ins_codigo,        
  p.presc_data,        
  itpm.ins_unidade,
  itpm.itpresc_frequencia,
   itpr.item_prescricao_id as ID,
   	 
	 case when itpm.presc_codigo = @presc_codigo then itpm.medicamento_id else null end as medicamento_id,
	 case when itpm.presc_codigo = @presc_codigo then itpm.data_iniciar_em else null end as data_iniciar_em,

	case when itpm.presc_codigo = @presc_codigo then itpm.IsItemPrescricaoSuspensa
       when itps.presc_codigo = @presc_codigo then itps.ItemPrescricaoSuspensa
       when itce.presc_codigo = @presc_codigo then itce.ItemPrescricaoSuspensa
       when itpd.presc_codigo = @presc_codigo  then itpd.ItemPrescricaoSuspensa
       when itpo.presc_codigo = @presc_codigo then itpo.ItemPrescricaoSuspensa
       when ippr.presc_codigo = @presc_codigo then ippr.ItemPrescricaoSuspensa
       end as IsItemPrescricaoSuspensa,

	  case when itpm.presc_codigo = @presc_codigo then itpm.diluente_medicamento_id else null end as diluente_medicamento_id,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_ins_descricao else null end as diluente_ins_descricao,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_volume else null end as diluente_volume,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_volume_total else null end as diluente_volume_total,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_valor_velocidade else null end as diluente_valor_velocidade,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_medida_velocidade else null end as diluente_medida_velocidade,

	   case when itpm.presc_codigo = @presc_codigo then itpm.itpresc_total else null end as itpresc_total,

	 case when itpm.presc_codigo = @presc_codigo then (itpm.ins_descricao_resumida)                              
       when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)                              
       when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)                                          
       when itpd.presc_codigo = @presc_codigo then (itpd.ipdi_texto)                            
       when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)                              
       when ippr.presc_codigo = @presc_codigo then (pr.no_procedimento)                              
       end as DescricaoResumida,

	   case when itpm.presc_codigo = @presc_codigo then itpm.IsPassivelDeDiluicao else null end as IsPassivelDeDiluicao,
	   case when itpm.presc_codigo = @presc_codigo then itpm.viamed_codigo else null end as viamed_codigo,
	   case when itpm.presc_codigo = @presc_codigo then itpm.viamed_descricao else null end as viamed_descricao,
	   case when itpm.presc_codigo = @presc_codigo then itpm.ins_codigo_unidade else null end as ins_codigo_unidade
  from         
 prescricao p        
 inner join Item_Prescricao itpr on p.presc_codigo = itpr.presc_codigo        
  left join                                                         
   (select presc_codigo, itpresc_codigo, itpresc_frequencia, ins_codigo, ins_descricao,         
 itpresc_quantidade as presc_quantidade, itpresc_total as quantidade,        
 itpresc_duracao, itpresc_tpduracao, ins_unidade, medicamento_id, data_iniciar_em, IsItemPrescricaoSuspensa,
  diluente_medicamento_id, diluente_ins_descricao, diluente_volume, diluente_volume_total, diluente_valor_velocidade, diluente_medida_velocidade,
  itpresc_total, ins_descricao_resumida  , IsPassivelDeDiluicao, viamed_codigo, viamed_descricao, ins_codigo_unidade
    from item_prescricao_medicamento                                                        
    where presc_codigo = @presc_codigo                                                        
    and itpresc_codigo = @itpresc_codigo                                                        
    and itpresc_codigo = @itpresc_codigo                             
      )itpm on (itpm.presc_codigo = Isnull(@presc_codigo, itpm.presc_codigo) and itpr.itpresc_codigo = itpm.itpresc_codigo and itpr.presc_codigo = itpm.presc_codigo)                                                        
          left join Item_Prescricao_Sinais_Vitais itps on(itps.presc_codigo = Isnull(@presc_codigo, itps.presc_codigo) and itpr.itpresc_codigo = itps.itpresc_codigo and itpr.presc_codigo = itpr.presc_codigo)                     
     
        
         
          left join Item_Prescricao_Cuidados_Especiais itce on(itce.presc_codigo = Isnull(@presc_codigo, itce.presc_codigo) and itpr.itpresc_codigo = itce.itpresc_codigo and itpr.presc_codigo = itce.presc_codigo)                                          
  
     
      
        
         
            
              
          left join Cuidados_Especiais ce on (itce.cues_codigo = ce.cues_codigo)                                                        
          left join Item_Prescricao_Dieta itpd on (itpd.presc_codigo = Isnull(@presc_codigo, itpd.presc_codigo) and  itpr.itpresc_codigo = itpd.itpresc_codigo and itpr.presc_codigo = itpd.presc_codigo)                                                      
  
          left join Item_Prescricao_Oxigenoterapia itpo on (itpo.presc_codigo = Isnull(@presc_codigo, itpo.presc_codigo) and itpr.itpresc_codigo = itpo.itpresc_codigo and itpr.presc_codigo = itpo.presc_codigo)                                              
  
    
     
         
          
          left join Oxigenoterapia ox on (ox.oxi_codigo = itpo.oxi_codigo)                              
          left join Item_Prescricao_Procedimento ippr on (ippr.presc_codigo = Isnull(@presc_codigo, ippr.presc_codigo) and itpr.itpresc_codigo = ippr.itpresc_codigo and itpr.presc_codigo = ippr.presc_codigo)                                                
  
    
      
        
          left join TB_Procedimento pr on (pr.co_procedimento = ippr.co_procedimento)                              
     where itpr.presc_codigo =  Isnull(@presc_codigo, itpr.presc_codigo)                              
         and   itpr.itpresc_codigo = Isnull(@itpresc_codigo, itpr.itpresc_codigo)                                                        
END                              
                              
IF (@OPCAO = 2) /* LIST */                                                        
BEGIN                                                        
   SET @SQL =        ' SELECT '                                                         
   SET @SQL = @SQL + '   dose_sequencial, itpresc_codigo, presc_codigo, dose_data, dose_quantidade, dose_obs, dose_adm, prof_codigo, locatend_codigo, usu_codigo, CODINS '                                 
   SET @SQL = @SQL + ' FROM '                                                         
   SET @SQL = @SQL + '   Item_Aprazamento '                                                         
   SET @SQL = @SQL + ' WHERE '                                                         
 IF @ITPRESC_CODIGO IS NOT NULL                                                        
 BEGIN                                                         
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO)                                                         
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                                         
 END                                                         
 IF @PRESC_CODIGO IS NOT NULL                                                        
 BEGIN                                                         
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO)                                                         
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                                         
 END                                                         
 SET @SQL = (@SQL + @PAR)                                                        
 EXEC (@SQL)                         
END                                                        
                                                        
/* Cria Lista Com horarios das doses */                                                        
IF(@OPCAO = 3)                                                         
BEGIN                                                         
                                                        
declare @horarios as SmallDateTime                                                        
declare @total as int                          
                                                        
create table #horario(dosedata SmallDateTime)                                                        
                                                        
select @total = itpresc_total from item_prescricao_medicamento where presc_codigo = @presc_codigo and itpresc_codigo = @itpresc_codigo                                                        
                                                        
if(@total > 0)                                                        
  begin                                          
 while(@total != 0)                                                        
   begin                              
                                                           
   select                                                        
    @horarios = dateAdd(HH, Cast(itpresc_frequencia as int) /60 , Isnull(@horarios,getDate()))                                                        
          from item_prescricao_medicamento                                                        
    where presc_codigo = @presc_codigo and itpresc_codigo = @itpresc_codigo                                                        
                                
           insert into #horario(dosedata) values (@horarios)                                                        
                                                           
       set @total = @total - 1                                                        
    end                                                        
 end                                                        
select dosedata from #horario                                       
drop table #horario                                                        
                                                        
END                                                        
IF(@OPCAO = 4)                                                      
BEGIN                                                      
                                                      
select itpr.presc_codigo,                                                       
       itpr.itpresc_codigo,                                                      
       itpr.itpresc_obs,                                            
   null as Codigo,                                                      
       ipsv.ipsv_texto as Descricao,                                    
     ipsv.ipsv_intervalo as Intervalo,                                    
       null as Unidade,                                          
       null as UnidadeTempo,                                          
       'S' as TipoItemPrescricao,                                
 convert(varchar,ipsv.ipsv_intervalo) + '/' + convert(varchar,ipsv.ipsv_intervalo) as Detalhe                                
 from item_prescricao itpr                                                      
      inner join Item_Prescricao_Sinais_Vitais ipsv on itpr.presc_codigo = ipsv.presc_codigo and itpr.itpresc_codigo = ipsv.itpresc_codigo                                                      
where itpr.presc_codigo = @PRESC_CODIGO                                                     
union all                                            
select itpr.presc_codigo,                                                       
       itpr.itpresc_codigo,                                                      
       itpr.itpresc_obs,                                      
       ce.cues_codigo as Codigo,                                            
       ce.cues_descricao as Descricao,                                 
       ipce.ipce_intervalo as Intervalo,                                    
       null as Unidade,                                          
       null as UnidadeTempo,                                       
       'C' as TipoItemPrescricao,                                
 convert(varchar,ipce.ipce_intervalo) + '/' + convert(varchar,ipce.ipce_intervalo) as Detalhe                                
from item_prescricao itpr                       
     inner join Item_Prescricao_Cuidados_Especiais ipce on itpr.presc_codigo = ipce.presc_codigo and itpr.itpresc_codigo = ipce.itpresc_codigo                                                      
     inner join Cuidados_Especiais ce on ce.cues_codigo = ipce.cues_codigo                                            
where itpr.presc_codigo = @PRESC_CODIGO                                      
union all                                            
select itpr.presc_codigo,                                
   itpr.itpresc_codigo,                                
       itpr.itpresc_obs,                                
       ox.oxi_codigo as Codigo,                                
       ox.oxi_descricao as Descricao,                                
       ipox.ipox_intervalo as Intervalo,                                
       ipox.ipox_unidade as Unidade,                                
       ipox.ipox_unidade_tempo as UnidadeTempo,                                
       'O' as TipoItemPrescricao,                                
 case when ipox.ipox_unidade_tempo = 0 and ox.oxi_tipo = 0 then ' (Contínua) ' + convert(varchar,ipox_unidade) + '% FiO2'                                
             when ipox.ipox_unidade_tempo = 0 and ox.oxi_tipo = 1 then ' (Contínua) ' + convert(varchar,ipox_unidade) + ' L/min'                                
             when ipox.ipox_unidade_tempo = 1 and ox.oxi_tipo = 0 then ' (Intervalo) ' + convert(varchar,ipox_unidade) + '% FiO2'                                
             when ipox.ipox_unidade_tempo = 1 and ox.oxi_tipo = 1 then ' (Intervalo) ' + convert(varchar,ipox_unidade) + ' L/min'                                
 end Detalhe                                
from Item_Prescricao itpr                                                      
     inner join Item_Prescricao_Oxigenoterapia ipox on itpr.presc_codigo = ipox.presc_codigo and itpr.itpresc_codigo = ipox.itpresc_codigo                                                    
     inner join Oxigenoterapia ox on ox.oxi_codigo = ipox.oxi_codigo                                            
where itpr.presc_codigo = @PRESC_CODIGO                                                      
union all                                                      
select itpr.presc_codigo,                                                       
       itpr.itpresc_codigo,                                                      
       itpr.itpresc_obs,                                                      
       null as Codigo,                                            
       ipdi.ipdi_texto as Descricao,                                             
       null as Intervalo,                                        
       ipdi.ipdi_kcal as Unidade,                                
       null as UnidadeTempo,                                          
       'D' as TipoItemPrescricao,                                
 convert(varchar,ipdi.ipdi_kcal) + ' Kcal' as Detalhe                                                       
from Item_Prescricao itpr                                               
     inner join Item_Prescricao_Dieta ipdi on itpr.presc_codigo = ipdi.presc_codigo and itpr.itpresc_codigo = ipdi.itpresc_codigo                                                      
where itpr.presc_codigo = @PRESC_CODIGO                                                      
                                   
END                                            
                                                   
IF (@@ERROR <> 0)                                                    
                                                    
BEGIN                                                    
                                                
   RAISERROR('ERRO: ksp_Item_Prescricao_Dto',1,1)                              
                                                    
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
	  case when (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpm.item_prescricao_id) > 0 then 'MEDICAMENTO SUSPENSO' ELSE NULL END AS MedicamentoSuspenso,
	  
	  case when itpm.presc_codigo = @presc_codigo then itpm.ins_descricao
			when itps.presc_codigo = @presc_codigo then (itps.ipsv_texto)
			when itce.presc_codigo = @presc_codigo then (ce.cues_descricao)
			when itd.presc_codigo = @presc_codigo then (itd.ipdi_texto)   
			when itpo.presc_codigo = @presc_codigo then (ox.oxi_descricao)
		end
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao) > 0 THEN ' + ' + ITPM.diluente_ins_descricao ELSE ' ' END
		AS DescricaoResumida,

			case when LEN(ITPM.itpresc_quantidade) > 0 then (  
		'Dose: ' +   
				CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
				WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
				ELSE convert(varchar(10),itpresc_quantidade)   
			END  
		+ ' ' + ins_unidade + '(s)') END + 
		case when LEN(itpm.viamed_descricao) > 0 THEN ' - ' + itpm.viamed_descricao ELSE '' END +
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
	  case when (select count(1) from PRESCRICAO_SUSPENSA PS where ps.item_prescricao_id = itpm.item_prescricao_id) > 0 then 'MEDICAMENTO SUSPENSO' ELSE NULL END AS MedicamentoSuspenso,

	  	  case when itpm.presc_codigo = p.presc_codigo then itpm.ins_descricao
			when itps.presc_codigo = p.presc_codigo then (itps.ipsv_texto)
			when itce.presc_codigo = p.presc_codigo then (ce.cues_descricao)
			when itd.presc_codigo = p.presc_codigo then (itd.ipdi_texto)   
			when itpo.presc_codigo = p.presc_codigo then (ox.oxi_descricao)
		end
		 + CASE WHEN LEN(ITPM.diluente_ins_descricao) > 0 THEN ' + ' + ITPM.diluente_ins_descricao ELSE ' ' END
		AS DescricaoResumida,

		case when LEN(ITPM.itpresc_quantidade) > 0 then (  
		'Dose: ' +   
				CASE (RIGHT(CONVERT(VARCHAR,ITPRESC_QUANTIDADE),2))   
				WHEN 0 THEN  convert(varchar(10),FLOOR(itpresc_quantidade))   
				ELSE convert(varchar(10),itpresc_quantidade)   
			END  
		+ ' ' + ins_unidade + '(s)') END + 
		case when LEN(itpm.viamed_descricao) > 0 THEN ' - ' + itpm.viamed_descricao ELSE '' END +
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao]
@PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @ITPRESC_OBS VARCHAR (2000), @ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @TempoTratamento CHAR(5)=NULL
AS
DECLARE @SQL VARCHAR(MAX)      
DECLARE @PAR VARCHAR(2000)      
DECLARE @VAR VARCHAR(2000)      
DECLARE @NovoCodigo integer      
      
IF (@OPCAO = 0) /* LIST */      
         
BEGIN      
      
   SET @SQL =        ' SELECT '       
   SET @SQL = @SQL + '   presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento '       
   SET @SQL = @SQL + ' FROM '       
   SET @SQL = @SQL + '   Item_Prescricao '       
   SET @SQL = @SQL + ' WHERE 1 = 1 '       
 IF @PRESC_CODIGO IS NOT NULL      
 BEGIN       
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO)       
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT    
    set @sql = @sql + ' and ' + @PAR     
 END       
 IF @ITPRESC_CODIGO IS NOT NULL      
 BEGIN       
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO)       
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT    
    set @sql = @sql + ' and ' + @PAR     
 END       
 IF @ITPRESC_OBS IS NOT NULL      
 BEGIN       
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_OBS)       
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_obs ", @TP_PESQ, "T", @PAR OUTPUT     
    set @sql = @sql + ' and ' + @PAR    
 END       

EXEC (@SQL)      
      
      
END      
      
IF (@OPCAO = 1)  /* INCLUSAO */      
       
BEGIN      
      
  -- ##################################################      
  -- OBTENDO O CODIGO DO ITEM DA PRESCRICAO      
  -- ##################################################      
 IF ((@ITPRESC_CODIGO IS NULL) or (@ITPRESC_CODIGO = 1)) 
	 BEGIN    
		SELECT @NovoCodigo = MAX(itpresc_codigo) FROM item_prescricao WHERE PRESC_CODIGO = @PRESC_CODIGO      
	        
		IF @NovoCodigo IS null       
			Set @NovoCodigo = 1      
		ELSE      
			Set @NovoCodigo = @NovoCodigo + 1      
			
		INSERT INTO Item_Prescricao(ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento)      
		VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @NovoCodigo, @ITPRESC_OBS, @TempoTratamento)      	
		
		SELECT @NovoCodigo      
		
	 END  
 ELSE -- CODIGO ADICIONADO PARA PERMITIR INFORMAR O ITPRESC_CODIGO A PARTIR DA APLICAÇÃO  
 
  SET @NovoCodigo = @ITPRESC_CODIGO    
  INSERT INTO Item_Prescricao(ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento)      
  VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @NovoCodigo, @ITPRESC_OBS, @TempoTratamento)      
      
  SELECT @NovoCodigo      
      
END   
      
IF (@OPCAO = 2)  /* ALTERACAO */      
       
BEGIN      
      
   UPDATE      
     Item_Prescricao      
   SET      
     itpresc_obs = @ITPRESC_OBS      
   WHERE      
     itpresc_codigo = @ITPRESC_CODIGO AND       
     presc_codigo = @PRESC_CODIGO                                  
      
END      
      
IF (@OPCAO= 3) /* EXCLUSAO */      
      
BEGIN      
                
  -- alteração na exlusao para atender a 2 constraints, deve-se excluir também nas tabelas:
	DELETE Item_Pedido_prescricao 
	WHERE 
		presc_codigo = @PRESC_CODIGO 
		AND itpresc_codigo = @ITPRESC_CODIGO
	
	DELETE item_prescricao_medicamento 
	WHERE 
		presc_codigo = @PRESC_CODIGO 
		AND item_prescricao_id = @ITEM_PRESCRICAO_ID
	            
   DELETE FROM Item_Prescricao      
   WHERE      
		itpresc_codigo = @ITPRESC_CODIGO 
		AND presc_codigo = @PRESC_CODIGO      
            
END      
      
IF (@OPCAO= 4) /* PROCURA POR CHAVE */      
      
BEGIN      
                
   SELECT      
     presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento      
   FROM      
     Item_Prescricao      
   WHERE      
     itpresc_codigo = @ITPRESC_CODIGO AND       
     presc_codigo = @PRESC_CODIGO      
            
END      
      
IF (@OPCAO= 5) /* LISTA TODOS */      
      
BEGIN      
                
   SELECT      
     presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento      
   FROM      
     Item_Prescricao      
            
END      

IF (@OPCAO= 6) /* LISTA POR ITEM_PRESCRICAO_ID */      
      
BEGIN      
                
   SELECT      
     presc_codigo, itpresc_codigo, itpresc_obs, TempoTratamento      
   FROM      
     Item_Prescricao      
	 WHERE item_prescricao_id = @ITEM_PRESCRICAO_ID
            
END    
        
IF (@@ERROR <> 0)      
      
BEGIN      
      
         RAISERROR('ERRO: ksp_Item_Prescricao',1,1)      
      
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Medicamento]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Medicamento]
@ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @ITPRESC_QUANTIDADE NUMERIC (9, 2), @ITPRESC_FREQUENCIA CHAR (5), @ITPRESC_DURACAO INT, @ITPRESC_TPDURACAO CHAR (1), @ITPRESC_TPINSUMO CHAR (1), @ITPRESC_TOTAL NUMERIC (9, 2), @ITPRESC_TOTAL_POSTO NUMERIC (9, 2), @ITPRESC_SALDO INT, @ITPRESC_QTD_SOS CHAR (1), @INS_CODIGO INT, @MEDICAMENTO_ID INT, @ITPRESC_ADM CHAR (1), @PED_CODIGO CHAR (12), @PED_DATA CHAR (10), @ITPED_CODIGO SMALLINT, @ITPRESC_TEMPEDIDO CHAR (1), @IDTPRESCRICAO_DIFERENCIADA CHAR (1), @ITPRESC_DIA INT, @ITPRESC_SOLICITADO INT, @ITPRESC_CANCELADO INT, @INS_DESCRICAO VARCHAR (500), @INS_DESCRICAO_RESUMIDA VARCHAR (200), @INS_CODIGO_UNIDADE INT, @INS_UNIDADE VARCHAR (50), @CODACE CHAR (8), @ITPED_QUANTIDADE NUMERIC (9, 2), @VIAMED_CODIGO INT, @VIAMED_DESCRICAO VARCHAR (255), @FORUSOMED_CODIGO INT, @ITPRESC_TPFREQUENCIA CHAR (1), @POME_CODIGO INT, @PAC_CODIGO CHAR (12), @PROF_CODIGO CHAR (4), @LOCATEND_CODIGO CHAR (4), @UNID_CODIGO CHAR (4)=NULL, @USU_CODIGO CHAR (4), @CODDEP CHAR (2)=NULL, @ITPRESC_VELOCIDADE_INFUSAO CHAR (1), @ITPRESC_UNIDADE_INFUSAO VARCHAR (50), @ITPRESC_DURACAO_INFUSAO INT, @ATENDAMB_CODIGO CHAR (12)=null, @SPA_CODIGO CHAR (12)=null, @EMER_CODIGO CHAR (12)=null, @ATEND_CODIGO CHAR (12)=null, @INTER_CODIGO CHAR (12)=null, @GeraPedidoPaciente CHAR (1)=null, @PodeFazerPedidoStok CHAR (1)=NULL, @itpresc_caracteristica CHAR (1)=NULL, @PST_CODIGO CHAR (4)=NULL, @ITEM_PRESCRICAO_ID_SOLUCAO UNIQUEIDENTIFIER=NULL, @itpresc_codigo_issoluvel CHAR (1)=NULL, @itpresc_codigo_issolucao CHAR (1)=NULL, @itpresc_quantidade_posto NUMERIC (9, 2)=NULL, @data_iniciar_em DATETIME=null, @fracionado CHAR (1)=NULL, @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @DATA_INICIAL DATETIME=NULL, @DATA_FINAL DATETIME=NULL, @PADRONIZADO CHAR (1)=null, @restrito CHAR (1)=NULL, @antimicrobiano CHAR (1)=NULL, @antimicrobiano_tp_prescricao VARCHAR (50)=NULL, @antimicrobiano_detalhe VARCHAR (50)=NULL, @justificativa VARCHAR (200)=NULL, @justificado CHAR (1)=NULL, @kit VARCHAR (100)=NULL, @ColetaPreviaCulturas CHAR (1)=NULL, @TotalUnidadeMedida decimal = null, @QuantidadeAtual decimal = null, @QuantidadeAtendida decimal = null, @QuantidadePorDose decimal = null, @IsAntibiotico char(1)=null, @TempoTratamento CHAR(5)=NULL
,@IsPassivelDeDiluicao CHAR(1) = null,
@IsDiluente CHAR(1) = null,
@diluente_medicamento_id INT = NULL,
@diluente_ins_descricao VARCHAR(500) = null,
@diluente_ins_descricao_resumida VARCHAR(200) = null,
@diluente_volume NUMERIC (9, 2) = NULL,
@diluente_volume_total NUMERIC (9, 2) = NULL,
@diluente_valor_velocidade NUMERIC (9, 2) = NULL,
@diluente_medida_velocidade VARCHAR(100) = null,
@diluente_ins_codigo VARCHAR(100) = null,
@diluente_gera_pedido_paciente CHAR (1)=null
AS
DECLARE @SQL VARCHAR(8000)                                      
DECLARE @PAR VARCHAR(500)                                      
DECLARE @VAR VARCHAR(500)                                      
DECLARE @RETVAL INT                                      
DECLARE @PRESCRICOES VARCHAR(4000)                                      
DECLARE @PROF AS VARCHAR(50)                                      
DECLARE @PACIENTE AS VARCHAR(50)                                      
                                      
SET @RETVAL = 0                                      
                                      
IF (@OPCAO = 0) /* LIST */                                      
                                         
BEGIN                                      
                                      
   SET @SQL =        ' SELECT '                                       
   SET @SQL = @SQL + '   *, IPMS.INS_DESCRICAO AS INS_DESCRICAO_SOLUCAO, '
   SET @SQL = @SQL + '   CASE WHEN Item_Prescricao_Medicamento.TempoTratamento IS NOT NULL THEN ''D'' +  CONVERT(VARCHAR,DATEDIFF(DAY, p.presc_data, GETDATE()))  + ''/'' + Item_Prescricao_Medicamento.TempoTratamento ELSE null END AS ContadorTratamento'                                       
   SET @SQL = @SQL + ' FROM '                                       
   SET @SQL = @SQL + '   Item_Prescricao_Medicamento '                                  
   SET @SQL = @SQL + '   Join Item_Prescricao on Item_Prescricao_Medicamento.presc_codigo = Item_Prescricao.presc_codigo and '                                  
   SET @SQL = @SQL + '   Item_Prescricao_Medicamento.itpresc_codigo = Item_Prescricao.itpresc_codigo '                                  
   SET @SQL = @SQL + '   Left Join Forma_Uso_Medicamento on Item_Prescricao_Medicamento.forusomed_codigo = Forma_Uso_Medicamento.forusomed_codigo '                                      
   SET @SQL = @SQL + '   Left Join Via_Medicamento on Item_Prescricao_Medicamento.viamed_codigo = Via_Medicamento.viamed_codigo '                
   SET @SQL = @SQL + '    Left Join Item_Prescricao_Medicamento IPMS on  Item_Prescricao_Medicamento.item_prescricao_id_solucao = IPMS.item_prescricao_id '
	SET @SQL = @SQL + '   Join Prescricao p on  Item_Prescricao_Medicamento.presc_codigo = p.presc_codigo'                                  
   SET @SQL = @SQL + ' WHERE 1 = 1 '                                       
 IF @PRESC_CODIGO IS NOT NULL                                      
 BEGIN                                       
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO)                                       
   EXEC KSP_PARAMETROPESQUISA @VAR, "Item_Prescricao_Medicamento.presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
   SET @SQL = @SQL + ' AND ' + @PAR                          
 END                                       
 IF @ITPRESC_CODIGO IS NOT NULL                                
 BEGIN                                 
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO)                                       
   EXEC KSP_PARAMETROPESQUISA @VAR, "Item_Prescricao_Medicamento.itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
   SET @SQL = @SQL + ' AND ' + @PAR                          
 END                                       
                           
EXEC (@SQL)                                      
                                      
END                                      
                                      
IF (@OPCAO = 1)  /* INCLUSAO */                                      
                                       
BEGIN                                      
                     
   -- ##################################################                                      
   -- INCLUINDO ITEM DA PRESCRICAO                                      
   -- ##################################################                                    
               
                                      
   INSERT INTO ITEM_PRESCRICAO_MEDICAMENTO (ITEM_PRESCRICAO_ID,                                      
  PRESC_CODIGO,                                      
  ITPRESC_CODIGO,                                      
  ITPRESC_QUANTIDADE,                                      
  ITPRESC_FREQUENCIA,                                      
  ITPRESC_DURACAO,                                      
  ITPRESC_TPDURACAO,                                      
  ITPRESC_TPINSUMO,                                      
  ITPRESC_TOTAL,                                      
  ITPRESC_TOTAL_POSTO,                  
  INS_CODIGO,                                      
  MEDICAMENTO_ID,                          
  ITPRESC_ADM,                                      
  INS_DESCRICAO,                                      
  INS_DESCRICAO_RESUMIDA,
  INS_CODIGO_UNIDADE,                          
  INS_UNIDADE,                                      
  CODACE,                                      
  POME_CODIGO,                                      
  IDTPRESCRICAO_DIFERENCIADA,                                      
  ITPRESC_DIA,                                      
  ITPRESC_SALDO,                                      
  ITPRESC_SOLICITADO,                                      
  VIAMED_CODIGO,                          
  VIAMED_DESCRICAO,                          
  ITPRESC_QTD_SOS,
  FORUSOMED_CODIGO,                                      
  ITPRESC_TPFREQUENCIA,                                    
  itpresc_velocidade_infusao,                                    
  itpresc_unidade_infusao,                                    
  itpresc_duracao_infusao,                              
  itped_quantidade,                          
  PED_CODIGO,                          
  ITPED_CODIGO,                        
  GeraPedidoPaciente,                        
  PodeFazerPedidoStok,                        
  itpresc_caracteristica,                
  [item_prescricao_id_solucao] ,                
  itpresc_codigo_issoluvel ,                
  itpresc_codigo_issolucao,    
  itpresc_quantidade_posto,  
  data_iniciar_em,  
  fracionado,
  padronizado,
  restrito,
  antimicrobiano,
  antimicrobiano_tp_prescricao,
  antimicrobiano_detalhe,
  justificativa,
  justificado,
  kit,
  ColetaPreviaCulturas,
  IsAntibiotico,
  TempoTratamento,
	IsPassivelDeDiluicao,
	IsDiluente,
	diluente_medicamento_id,
	diluente_ins_descricao,
	diluente_ins_descricao_resumida,
	diluente_volume,
	diluente_volume_total,
	diluente_valor_velocidade,
	diluente_medida_velocidade,
	diluente_ins_codigo,
	diluente_gera_pedido_paciente
  )                                      
                                       
   VALUES (@ITEM_PRESCRICAO_ID,            
   @PRESC_CODIGO,                                      
  @ITPRESC_CODIGO,                                      
  @ITPRESC_QUANTIDADE,                                      
  @ITPRESC_FREQUENCIA,                                      
  @ITPRESC_DURACAO,                              
  @ITPRESC_TPDURACAO,                                      
  @ITPRESC_TPINSUMO,                                      
  @ITPRESC_TOTAL,                                      
  @ITPRESC_TOTAL_POSTO,                  
  @INS_CODIGO,                          
  @MEDICAMENTO_ID,                          
  '0',                                       
  @INS_DESCRICAO,        
  @INS_DESCRICAO_RESUMIDA,                              
  @INS_CODIGO_UNIDADE,                        
  @INS_UNIDADE,                                      
  @CODACE,                           
  @POME_CODIGO,               
  @IDTPRESCRICAO_DIFERENCIADA,                                      
  @ITPRESC_DIA,                                      
  @ITPRESC_SOLICITADO,                                      
  @ITPRESC_SOLICITADO,                                      
  @VIAMED_CODIGO,                          
  @VIAMED_DESCRICAO,                          
  @ITPRESC_QTD_SOS,
  @FORUSOMED_CODIGO,                                      
  @ITPRESC_TPFREQUENCIA,                                    
  @ITPRESC_VELOCIDADE_INFUSAO,                                    
  @ITPRESC_UNIDADE_INFUSAO,                                    
  @ITPRESC_DURACAO_INFUSAO,                              
  @ITPED_QUANTIDADE,                          
  @PED_CODIGO,                          
  @ITPED_CODIGO,                        
  @GeraPedidoPaciente,                        
  @PodeFazerPedidoStok,                        
  @itpresc_caracteristica,                
  @ITEM_PRESCRICAO_ID_SOLUCAO,            
  @itpresc_codigo_issoluvel ,                
  @itpresc_codigo_issolucao,    
  @itpresc_quantidade_posto,  
  @data_iniciar_em,  
  @fracionado,
  @PADRONIZADO,
  @restrito,
  @antimicrobiano,
  @antimicrobiano_tp_prescricao,
  @antimicrobiano_detalhe,
  @justificativa,
  @justificado,
  @kit,
  @ColetaPreviaCulturas,
  @IsAntibiotico,
  @TempoTratamento,
  @IsPassivelDeDiluicao,
  @IsDiluente,
  @diluente_medicamento_id,
  @diluente_ins_descricao,
  @diluente_ins_descricao_resumida,
  @diluente_volume,
  @diluente_volume_total,
  @diluente_valor_velocidade,
  @diluente_medida_velocidade,
  @diluente_ins_codigo,
  @diluente_gera_pedido_paciente
  )                      
                                       
   IF (@@ERROR <> 0)                                      
   BEGIN                                      
 RAISERROR('ERRO - KSP_ITEM_PRESCRICAO_MEDICAMENTO. Erro ao incluir o item da prescricao', 1, 1)                                      
                            
 RETURN -1                                      
   END                                      
                                      
                                      
-- #############################################################################################                                      
  -- O INSUMO NÃO É FRACIONADO ENTÃO VERIFICO SE A DISPENSACAO É INDIVIDUALIZADA                                      
  -- CASO SEJA EU POSSO CRIA O PEDIDO, CASO CONTRARIO O PEDIDO SERÁ FEITO                                      
  -- PELO POSTO DE ENFERMAGEM                                      
-- #############################################################################################                                      
  IF (SELECT COUNT(CODINS) FROM CORRELACAO_INSUMO WHERE CODINS = @INS_CODIGO) = 0                                       
  BEGIN                                      
    -- #######################################################                                      
    -- VERIFICANDO SE A DISPENSACAO É INDIVIDUALIZADA                                      
    -- #######################################################                                      
    DECLARE @PRESC_ORIGEM AS VARCHAR(2)                                      
    SELECT @PRESC_ORIGEM = LTRIM(RTRIM(PRESC_ORIGEM)),                                      
    @PAC_CODIGO = PAC_CODIGO                                      
    FROM PRESCRICAO                                
    WHERE PRESC_CODIGO = @PRESC_CODIGO                                      
 END                                        
                                      
                                      
END                                      
                                      
IF (@OPCAO = 2)  /* ALTERACAO */                                      
                                       
BEGIN                                      
            
            
                      
   UPDATE                                      
     Item_Prescricao_Medicamento                                      
   SET                                      
     itpresc_quantidade = @ITPRESC_QUANTIDADE,                                     
     itpresc_frequencia = @ITPRESC_FREQUENCIA,                                      
     itpresc_duracao = @ITPRESC_DURACAO,                                      
     itpresc_tpInsumo = @ITPRESC_TPINSUMO,                                      
     ins_codigo = @INS_CODIGO,                                      
     medicamento_id = @MEDICAMENTO_ID,                          
     itpresc_total = @ITPRESC_TOTAL,                                      
     itpresc_total_posto = @ITPRESC_TOTAL_POSTO,                  
     itpresc_adm = @ITPRESC_ADM,                                      
     itped_quantidade = @ITPED_QUANTIDADE,              
     ins_descricao = @INS_DESCRICAO,                                  
     ins_codigo_unidade = @ins_codigo_unidade,                          
     ins_unidade = @INS_UNIDADE,                                      
     codace = @CODACE,                                      
     itpresc_saldo = @ITPRESC_SALDO,                                      
     itpresc_tpduracao = @ITPRESC_TPDURACAO,                                      
     viamed_codigo = @VIAMED_CODIGO,                                      
     viamed_descricao = @VIAMED_DESCRICAO,                          
     itpresc_qtd_sos = @ITPRESC_QTD_SOS,                                      
     pome_codigo = @POME_CODIGO,                                      
     forusomed_codigo = @FORUSOMED_CODIGO,                                      
     ped_codigo = @PED_CODIGO,                                      
     itped_codigo = @ITPED_CODIGO,                                      
     itpresc_tempedido = @ITPRESC_TEMPEDIDO,                                           
     idtprescricao_diferenciada = @IDTPRESCRICAO_DIFERENCIADA,                                      
     itpresc_dia = @ITPRESC_DIA,                                      
     itpresc_solicitado = @ITPRESC_SOLICITADO,                                      
     itpresc_cancelado = @ITPRESC_CANCELADO,                                      
     itpresc_velocidade_infusao = @ITPRESC_VELOCIDADE_INFUSAO,                                    
     itpresc_unidade_infusao = @ITPRESC_UNIDADE_INFUSAO,                                    
     itpresc_duracao_infusao = @ITPRESC_DURACAO_INFUSAO,                        
     GeraPedidoPaciente = @GeraPedidoPaciente,                        
     PodeFazerPedidoStok = @PodeFazerPedidoStok,                
  ITEM_PRESCRICAO_ID_SOLUCAO = @ITEM_PRESCRICAO_ID_SOLUCAO,                
  itpresc_codigo_issoluvel = @itpresc_codigo_issoluvel,                
  itpresc_codigo_issolucao = @itpresc_codigo_issolucao,    
  itpresc_quantidade_posto = @itpresc_quantidade_posto,  
  data_iniciar_em = @data_iniciar_em,  
  fracionado = @fracionado,
  padronizado = @padronizado,
  restrito = @restrito,
  antimicrobiano = @antimicrobiano,
  antimicrobiano_tp_prescricao = @antimicrobiano_tp_prescricao,
  antimicrobiano_detalhe = @antimicrobiano_detalhe,
  justificativa = @justificativa,
  justificado = @justificado,
  kit = @kit,
  ColetaPreviaCulturas = @ColetaPreviaCulturas,
  IsAntibiotico = @IsAntibiotico, 
	IsPassivelDeDiluicao = @IsPassivelDeDiluicao,
	IsDiluente = @IsDiluente,
	diluente_medicamento_id = @diluente_medicamento_id,
	diluente_ins_descricao = @diluente_ins_descricao,
	diluente_ins_descricao_resumida = @diluente_ins_descricao_resumida,
	diluente_volume = @diluente_volume,
	diluente_volume_total = @diluente_volume_total,
	diluente_valor_velocidade = @diluente_valor_velocidade,
	diluente_medida_velocidade = @diluente_medida_velocidade,
	diluente_ins_codigo = @diluente_ins_codigo,
	diluente_gera_pedido_paciente = @diluente_gera_pedido_paciente
   WHERE                                      
     itpresc_codigo = @ITPRESC_CODIGO AND                                       
     presc_codigo = @PRESC_CODIGO                                 
                                      
END                                      
                                      
IF (@OPCAO= 3) /* EXCLUSAO */                                      
                                      
BEGIN                                      
                                                
   DELETE FROM Item_Prescricao_Medicamento                                      
   WHERE                                      
     itpresc_codigo = @ITPRESC_CODIGO AND                                       
     presc_codigo = @PRESC_CODIGO                                      
                                            
END                                      
                                      
IF (@OPCAO= 4) /* PROCURA POR CHAVE */                  
                                      
BEGIN                          
                                            
   SELECT                                      
     Item_Prescricao_Medicamento.*,                
  IPMS.INS_DESCRICAO AS INS_DESCRICAO_SOLUCAO                                      
   FROM                                      
     Item_Prescricao_Medicamento                
 Left Join Item_Prescricao_Medicamento IPMS on  Item_Prescricao_Medicamento.item_prescricao_id_solucao = IPMS.item_prescricao_id          
   WHERE                                      
     Item_Prescricao_Medicamento.itpresc_codigo = @ITPRESC_CODIGO AND                                       
     Item_Prescricao_Medicamento.presc_codigo = @PRESC_CODIGO                                      
                                            
END                                      
                                      
IF (@OPCAO= 5) /* LISTA TODOS */                                      
                                      
BEGIN                                      
                                                
   SELECT                                      
     *                                      
   FROM                                      
     Item_Prescricao_Medicamento                                      
                                            
END                                      
                   
IF (@OPCAO = 6) /* ATUALIZA QUANTIDADE PEDIDA*/                            
                                      
BEGIN                                      
                            
   UPDATE                           
     Item_Prescricao_Medicamento                                      
   SET                                      
     itped_quantidade = @ITPED_QUANTIDADE                            
 WHERE                                      
     itpresc_codigo = @ITPRESC_CODIGO AND                                       
     presc_codigo = @PRESC_CODIGO                                                
                                            
END                                      
                          
IF (@OPCAO = 7) /* RETORNAR MEDICAMENTOS DE RECEITA PARA UM PACIENTE */                            
                                      
BEGIN                                      
                            
   SELECT ipm.INS_DESCRICAO, convert(varchar,p.presc_data,103) as ped_data                          
   FROM PRESCRICAO P                          
   INNER JOIN ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO                          
   INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON IP.PRESC_CODIGO = IPM.PRESC_CODIGO AND IP.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO                          
   WHERE P.PRESC_TIPO = 'R'                          
   AND PAC_CODIGO = @PAC_CODIGO                                         
END                          
                          
IF (@OPCAO = 8) /* RETORNAR MEDICAMENTOS DE UM ATENDIMENTO */                            
                                      
BEGIN                                      
                             
   IF @INTER_CODIGO IS NULL                          
  BEGIN                          
  SET @SQL =        ' SELECT '                                       
     SET @SQL = @SQL + '   ipm.INS_DESCRICAO, convert(varchar,p.presc_data,103) as ped_data, IPM.* '                                       
     SET @SQL = @SQL + ' FROM '                                       
     SET @SQL = @SQL + ' PRESCRICAO P '                                  
     SET @SQL = @SQL + '   INNER JOIN ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO '                                  
     SET @SQL = @SQL + '   INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON IP.PRESC_CODIGO = IPM.PRESC_CODIGO AND IP.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO '                          
     SET @SQL = @SQL + ' WHERE '                                       
                             
   IF @ATENDAMB_CODIGO IS NOT NULL                                  
   BEGIN                                       
     SET @VAR = CONVERT(VARCHAR, @ATENDAMB_CODIGO)                           
     EXEC KSP_PARAMETROPESQUISA @VAR, "atendamb_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
     SET @SQL = @SQL + @PAR                          
   END                            
   IF @SPA_CODIGO IS NOT NULL                                      
   BEGIN                                       
     SET @VAR = CONVERT(VARCHAR, @SPA_CODIGO)                           
     EXEC KSP_PARAMETROPESQUISA @VAR, "spa_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
     SET @SQL = @SQL + @PAR                          
   END      
   IF @EMER_CODIGO IS NOT NULL                                      
   BEGIN                                       
     SET @VAR = CONVERT(VARCHAR, @EMER_CODIGO)                           
     EXEC KSP_PARAMETROPESQUISA @VAR, "emer_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
     SET @SQL = @SQL + @PAR                          
   END                          
   IF @ATEND_CODIGO IS NOT NULL                             
   BEGIN                                       
     SET @VAR = CONVERT(VARCHAR, @ATEND_CODIGO)                           
     EXEC KSP_PARAMETROPESQUISA @VAR, "atend_codigo ", @TP_PESQ, "T", @PAR OUTPUT                                       
     SET @SQL = @SQL + @PAR                          
   END                            
  END               
 ELSE                          
  BEGIN                          
                          
  SET @SQL =        ' SELECT '                                       
     SET @SQL = @SQL + '   ipm.INS_DESCRICAO, convert(varchar,p.presc_data,103) as ped_data, IPM.* '                               
     SET @SQL = @SQL + ' FROM '                                       
     SET @SQL = @SQL + '   PRESCRICAO P '                                  
     SET @SQL = @SQL + '   INNER JOIN ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO '                                  
     SET @SQL = @SQL + '   INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON IP.PRESC_CODIGO = IPM.PRESC_CODIGO AND IP.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO '                          
     SET @SQL = @SQL + '   INNER JOIN INTERNACAO I ON I.INTER_CODIGO = P.INTER_CODIGO '                          
     SET @SQL = @SQL + ' WHERE p.inter_codigo = ''' + @INTER_CODIGO + ''''                         
                            
  END                           
                           
 EXEC (@SQL)                                      
                                      
END                          
                        
/*LISTA DE PRESCRICOES DE UM DETERMINADO MEDICAMENTO*/                        
IF @OPCAO = 9          
BEGIN          
          
 SELECT                   
  PM.PRESC_CODIGO, PAC_NOME, PROF_NOME, /*RISCO*/PRESC_DATA          
 FROM                  
  PRESCRICAO PM           
  JOIN PROFISSIONAL P ON PM.PROF_CODIGO = P.PROF_CODIGO          
 WHERE          
  EXISTS         
 (SELECT 1 FROM ITEM_PRESCRICAO_MEDICAMENTO IPM WHERE IPM.PRESC_CODIGO = PM.PRESC_CODIGO AND IPM.INS_CODIGO IS NOT NULL AND IPM.itpresc_caracteristica IS NULL AND IPM.MEDICAMENTO_ID = @MEDICAMENTO_ID     
 AND NOT EXISTS (SELECT 1 FROM ITEM_PEDIDO_FARMACIA IPF WHERE IPF.PED_CODIGO = IPM.PED_CODIGO AND IPF.ITPED_CODIGO = IPM.ITPED_CODIGO))        
    
  AND PM.UNID_CODIGO = @UNID_CODIGO  
  AND PM.IDT_FECHADA = 'N'  
 GROUP BY PAC_CODIGO,PM.PRESC_CODIGO, PAC_NOME, PROF_NOME, /*RISCO*/PRESC_DATA          
 ORDER BY PAC_NOME          
END          
              
              
/*LISTA DE MEDICAMENTOS QUE POSSUEM PEDIDO PENDENTE PARA O POSTO DE ENFERMAGEM*/              
IF @OPCAO = 10                
BEGIN          
          
CREATE TABLE #TEMP_MEDICAMENTO_POSTO          
(          
  PRESC_CODIGO CHAR(12),           
  ITPRESC_CODIGO INT,           
  INS_CODIGO INT,           
  MEDICAMENTO_ID INT,          
  INS_DESCRICAO VARCHAR(500),                   
  SPA_CODIGO CHAR(12),          
  EMER_CODIGO CHAR(12),          
  INTER_CODIGO CHAR(12),           
  ATEND_CODIGO CHAR(12),          
  LOCATEND_CODIGO CHAR(4),           
  ITPRESC_TOTAL_POSTO NUMERIC (9,2),                   
  GERAPEDIDOPACIENTE CHAR(1),          
  PODEFAZERPEDIDOSTOK CHAR(1),          
  INS_CODIGO_UNIDADE INT,          
  ATENDAMB_CODIGO CHAR(12),  
  PAC_NOME VARCHAR(50),   
  PROF_NOME VARCHAR(50),   
  PRESC_DATA SMALLDATETIME  
)          
          
INSERT INTO #TEMP_MEDICAMENTO_POSTO          
SELECT                           
  IPM.PRESC_CODIGO, IPM.ITPRESC_CODIGO, INS_CODIGO, MEDICAMENTO_ID, INS_DESCRICAO,                   
  P.SPA_CODIGO, P.EMER_CODIGO, P.INTER_CODIGO, P.ATEND_CODIGO, P.LOCATEND_CODIGO, ITPRESC_TOTAL_POSTO,                   
  GERAPEDIDOPACIENTE, PODEFAZERPEDIDOSTOK, INS_CODIGO_UNIDADE, P.ATENDAMB_CODIGO, P.PAC_NOME, PR.PROF_NOME, P.PRESC_DATA             
 FROM                          
  PRESCRICAO P                  
  JOIN ATENDIMENTO_AMBULATORIAL AA ON P.ATENDAMB_CODIGO = AA.ATENDAMB_CODIGO  
  JOIN PROFISSIONAL PR ON P.PROF_CODIGO = PR.PROF_CODIGO  AND P.LOCATEND_CODIGO = PR.LOCATEND_CODIGO
  JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON P.PRESC_CODIGO = IPM.PRESC_CODIGO                
  where          
  EXISTS         
 (SELECT 1 FROM ITEM_PRESCRICAO_MEDICAMENTO IPM2 WHERE IPM2.PRESC_CODIGO = IPM.PRESC_CODIGO AND IPM2.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO   
  AND IPM.INS_CODIGO IS NOT NULL AND IPM.itpresc_caracteristica IS NULL 
  AND (IPM.padronizado = 'S' or IPM.padronizado is null) 
  AND IPM.PED_CODIGO IS NULL)   
  AND P.PRESC_TIPO = 'P'  
  AND P.UNID_CODIGO = @UNID_CODIGO          
  AND (P.presc_data BETWEEN @DATA_INICIAL AND @DATA_FINAL)
  AND (AA.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))

 SELECT DISTINCT X.PRESC_CODIGO, X.ITPRESC_CODIGO, X.INS_CODIGO, X.MEDICAMENTO_ID, X.INS_DESCRICAO,                   
  X.SPA_CODIGO, X.EMER_CODIGO, X.INTER_CODIGO, X.ATEND_CODIGO, X.LOCATEND_CODIGO, X.ITPRESC_TOTAL_POSTO,                   
  X.GERAPEDIDOPACIENTE, X.PODEFAZERPEDIDOSTOK, X.INS_CODIGO_UNIDADE, X.PAC_NOME, X.PROF_NOME, CONVERT(VARCHAR,X.PRESC_DATA,103) as PED_DATA      
 FROM                 
(          
 SELECT * FROM #TEMP_MEDICAMENTO_POSTO WHERE MEDICAMENTO_ID = ISNULL(@MEDICAMENTO_ID, MEDICAMENTO_ID)  
 )  X          
          
INNER JOIN          
(          
		/*SPA SEM INTERNACAO*/  
		SELECT TMP.ATENDAMB_CODIGO       
		FROM        
		 ATENDIMENTO_AMBULATORIAL P  
		 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo
		 INNER JOIN PRESCRICAO PR ON P.SPA_CODIGO = PR.SPA_CODIGO        
		 LEFT JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
		 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO   
		 LEFT JOIN risco_acolhimento RA ON R.UPACLARIS_RISCO = RA.risaco_gravidade     
		 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO and cdSexo = pac.pac_sexo           
		 INNER JOIN #TEMP_MEDICAMENTO_POSTO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
		WHERE PS.PST_CODIGO = @PST_CODIGO        
		AND PS.TIPOSETOR = '3'        
		AND (PS.RISACO_CODIGO = ISNULL(R.RISACO_CODIGO,RA.RISACO_CODIGO) OR (PS.RISACO_CODIGO IS NULL AND ISNULL(R.RISACO_CODIGO,RA.RISACO_CODIGO) IS NULL))  
		AND TMP.INTER_CODIGO IS NULL  
		AND PR.PRESC_TIPO = 'P'  
		AND (P.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))

		/*SPA COM INTERNAÇÃO*/  
		UNION  
		SELECT TMP.ATENDAMB_CODIGO  
		FROM        
		 ATENDIMENTO_AMBULATORIAL P        
		 LEFT JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
		 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO
		 LEFT JOIN risco_acolhimento RA ON R.UPACLARIS_risco = RA.risaco_gravidade  
		 INNER JOIN  INTERNACAO I ON  I.SPA_CODIGO = P.SPA_CODIGO  
		 INNER JOIN  VWLEITO L ON I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO   
		 INNER JOIN #TEMP_MEDICAMENTO_POSTO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO  
		WHERE L.PST_CODIGO = @PST_CODIGO  
		AND (P.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))

		UNION  
		/*SPA VERMELHO SEM INTERNACAO*/  
		SELECT TMP.ATENDAMB_CODIGO  
		FROM        
		 ATENDIMENTO_AMBULATORIAL P 
		 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo       
		 INNER JOIN PRESCRICAO PR ON P.SPA_CODIGO = PR.SPA_CODIGO  
		 LEFT JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
		 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO   
		 LEFT JOIN risco_acolhimento RA ON R.UPACLARIS_risco = RA.risaco_gravidade     
		 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO AND (ISNULL(R.RISACO_CODIGO,RA.RISACO_CODIGO) = PS.RISACO_CODIGO) and cdSexo =  pac.pac_sexo          
		 INNER JOIN #TEMP_MEDICAMENTO_POSTO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
		WHERE PS.PST_CODIGO = @PST_CODIGO        
		AND PS.TIPOSETOR = '2'  
		AND R.UPACLARIS_RISCO = '6'        
		AND TMP.INTER_CODIGO IS NULL  
		AND PR.PRESC_TIPO = 'P'  
		AND (P.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))

		UNION        
		/*EMERGÊNCIA SEM INTERNAÇÃO*/  
		SELECT TMP.ATENDAMB_CODIGO        
		FROM        
		 ATENDIMENTO_AMBULATORIAL P 
		 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo       
		 INNER JOIN PRESCRICAO PR ON P.EMER_CODIGO = PR.EMER_CODIGO  
		 LEFT JOIN UPA_ACOLHIMENTO A ON P.EMER_CODIGO = A.EMER_CODIGO        
		 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
		 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO and cdSexo =  pac.pac_sexo        
		 INNER JOIN #TEMP_MEDICAMENTO_POSTO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
		WHERE PS.PST_CODIGO = @PST_CODIGO        
		AND PS.TIPOSETOR = '2'        
		AND PS.RISACO_CODIGO IS NOT NULL
		AND TMP.INTER_CODIGO IS NULL        
		AND PR.PRESC_TIPO = 'P'  
		AND (P.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))

		UNION         
  
		/*EMERGÊNCIA COM INTERNAÇÃO*/  
		SELECT TMP.ATENDAMB_CODIGO        
		FROM        
		 ATENDIMENTO_AMBULATORIAL P        
		 LEFT JOIN UPA_ACOLHIMENTO A ON P.EMER_CODIGO = A.EMER_CODIGO        
		 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
		 INNER JOIN  INTERNACAO I ON  I.EMER_CODIGO = P.EMER_CODIGO  
		 INNER JOIN  VWLEITO L ON I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO  
		 INNER JOIN #TEMP_MEDICAMENTO_POSTO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
		WHERE L.PST_CODIGO = @PST_CODIGO        
		AND (P.atendamb_datainicio BETWEEN dateadd(d, -30, @DATA_INICIAL) AND dateadd(d, 1, @DATA_FINAL))
		) Z         
		ON Z.ATENDAMB_CODIGO = X.ATENDAMB_CODIGO  
            
 LEFT JOIN                  
 (                  
 SELECT               
  ia.PRESC_CODIGO, ia.ITPRESC_CODIGO,   
  case when ipm.fracionado = 'N' then  
  SUM(round(DOSE_PEDIDO,0))   
  else  
  SUM(DOSE_PEDIDO)  
  end AS Reservado        
          
 FROM               
  Item_Aprazamento ia  
  inner join item_prescricao_medicamento ipm on ia.PRESC_CODIGO = ipm.PRESC_CODIGO AND ia.ITPRESC_CODIGO = ipm.ITPRESC_CODIGO  
 WHERE DOSE_ADM IS NULL            
 GROUP BY ia.PRESC_CODIGO, ia.ITPRESC_CODIGO, ipm.fracionado                  
 )Y                  
                  
 ON X.PRESC_CODIGO = Y.PRESC_CODIGO AND X.ITPRESC_CODIGO = Y.ITPRESC_CODIGO                  
                  
 ORDER BY X.PRESC_CODIGO, X.ITPRESC_CODIGO, X.INS_DESCRICAO              
                           
 DROP TABLE #TEMP_MEDICAMENTO_POSTO
  
                  
END                           
              
/*ATUALIZACAO DO PEDIDO*/              
IF @OPCAO = 11              
BEGIN              
              
 UPDATE ITEM_PRESCRICAO_MEDICAMENTO              
 SET PED_CODIGO = @PED_CODIGO, ITPED_CODIGO = @ITPED_CODIGO              
 WHERE              
  PRESC_CODIGO = @PRESC_CODIGO              
  AND ITPRESC_CODIGO = @ITPRESC_CODIGO              
END              
      
/*MEDICAMENTOS EM USO*/      
IF @OPCAO = 12  
BEGIN          
  
  
CREATE TABLE #TEMP_MEDICAMENTO_POSTO_EMUSO  
(          
  PRESC_CODIGO CHAR(12),           
  ITPRESC_CODIGO INT,        
  ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER,     
  ATENDAMB_CODIGO CHAR(12),  
  INTER_CODIGO CHAR(12),           
  ATEND_CODIGO CHAR(12),  
  INS_CODIGO INT  
)          
          
INSERT INTO #TEMP_MEDICAMENTO_POSTO_EMUSO  
SELECT IPM.PRESC_CODIGO, IPM.ITPRESC_CODIGO, IPM.ITEM_PRESCRICAO_ID, PM.ATENDAMB_CODIGO, PM.INTER_CODIGO, PM.ATEND_CODIGO, INS_CODIGO  
FROM PRESCRICAO PM               
JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON PM.PRESC_CODIGO = IPM.PRESC_CODIGO            
WHERE      
  PM.IDT_FECHADA = 'N'  
  AND PM.PRESC_TIPO = 'P'        
  AND IPM.INS_CODIGO IS NOT NULL              
  AND IPM.ITPRESC_CARACTERISTICA IS NULL  
  AND PM.UNID_CODIGO = @UNID_CODIGO  
    
    
SELECT X.PRESC_CODIGO, X.ITPRESC_CODIGO, X.ins_codigo, X.ITEM_PRESCRICAO_ID, ISNULL(Y.Reservado,0) AS Reservado, ITEM_PRESCRICAO_ID_SOLUCAO, W.ITPRESC_CODIGO_ISSOLUVEL, W.ITPRESC_QUANTIDADE_POSTO  
 FROM  
(          
 SELECT * FROM #TEMP_MEDICAMENTO_POSTO_EMUSO  
 )  X          
          
INNER JOIN  
(  
/*SPA SEM INTERNACAO*/  
SELECT TMP.ATENDAMB_CODIGO       
FROM        
 ATENDIMENTO_AMBULATORIAL P   
 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo     
 INNER JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
 LEFT JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO and cdSexo =  pac.pac_sexo           
 INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
WHERE PS.PST_CODIGO = @PST_CODIGO        
AND PS.TIPOSETOR = '3'        
AND (PS.RISACO_CODIGO = R.RISACO_CODIGO OR (PS.RISACO_CODIGO IS NULL AND R.RISACO_CODIGO IS NULL))  
AND P.ATENDAMB_DATAFINAL IS NULL  
AND NOT EXISTS (SELECT 1 FROM INTERNACAO I WHERE I.SPA_CODIGO = P.SPA_CODIGO)    
  
/*SPA COM INTERNAÇÃO*/  
UNION  
SELECT TMP.ATENDAMB_CODIGO  
FROM        
 ATENDIMENTO_AMBULATORIAL P        
 INNER JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
 INNER JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO  
 INNER JOIN  INTERNACAO I ON  I.SPA_CODIGO = P.SPA_CODIGO  
 INNER JOIN  VWLEITO L ON I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO   
 INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO  
WHERE L.PST_CODIGO = @PST_CODIGO  
AND P.ATENDAMB_DATAFINAL IS NULL  
  
UNION  
/*SPA VERMELHO SEM INTERNACAO*/  
SELECT TMP.ATENDAMB_CODIGO  
FROM        
 ATENDIMENTO_AMBULATORIAL P   
 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo     
 INNER JOIN UPA_ACOLHIMENTO A ON P.SPA_CODIGO = A.SPA_CODIGO        
 INNER JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO AND (R.RISACO_CODIGO = PS.RISACO_CODIGO) and cdSexo = pac.pac_sexo           
 INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
WHERE PS.PST_CODIGO = @PST_CODIGO        
AND PS.TIPOSETOR = '2'  
AND R.UPACLARIS_RISCO = '6'        
AND P.ATENDAMB_DATAFINAL IS NULL  
AND NOT EXISTS (SELECT 1 FROM INTERNACAO I WHERE I.SPA_CODIGO = P.SPA_CODIGO)  
  
UNION        
/*EMERGÊNCIA SEM INTERNAÇÃO*/  
SELECT TMP.ATENDAMB_CODIGO        
FROM        
 ATENDIMENTO_AMBULATORIAL P     
 INNER JOIN paciente pac on p.pac_codigo = pac.pac_codigo   
 INNER JOIN UPA_ACOLHIMENTO A ON P.EMER_CODIGO = A.EMER_CODIGO        
 INNER JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
 INNER JOIN SETOR_CLINICA_PARAMTETRO_STOK PS ON P.LOCATEND_CODIGO = PS.LOCATENDCODIGO AND (R.RISACO_CODIGO = PS.RISACO_CODIGO) and cdSexo = pac.pac_sexo           
 INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
WHERE PS.PST_CODIGO = @PST_CODIGO        
AND PS.TIPOSETOR = '2'        
AND (PS.RISACO_CODIGO = R.RISACO_CODIGO OR (PS.RISACO_CODIGO IS NULL AND R.RISACO_CODIGO IS NULL))  
AND P.ATENDAMB_DATAFINAL IS NULL  
AND NOT EXISTS (SELECT 1 FROM INTERNACAO I WHERE I.EMER_CODIGO = P.EMER_CODIGO)  
        
UNION         
  
/*EMERGÊNCIA COM INTERNAÇÃO*/  
SELECT TMP.ATENDAMB_CODIGO        
FROM        
 ATENDIMENTO_AMBULATORIAL P        
 INNER JOIN UPA_ACOLHIMENTO A ON P.EMER_CODIGO = A.EMER_CODIGO        
 INNER JOIN UPA_CLASSIFICACAO_RISCO R ON A.ACO_CODIGO = R.ACO_CODIGO        
 INNER JOIN  INTERNACAO I ON  I.EMER_CODIGO = P.EMER_CODIGO  
 INNER JOIN  VWLEITO L ON I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO  
 INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON TMP.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO        
WHERE L.PST_CODIGO = @PST_CODIGO        
AND P.ATENDAMB_DATAFINAL IS NULL  
  
) Z         
ON Z.ATENDAMB_CODIGO = X.ATENDAMB_CODIGO      
  
LEFT JOIN                  
(  
  
SELECT               
  ia.PRESC_CODIGO, ia.ITPRESC_CODIGO,   
  case when ipm.fracionado = 'N' then  
  SUM(round(DOSE_PEDIDO,0))   
  else  
  SUM(DOSE_PEDIDO)  
  end AS Reservado        
          
 FROM               
  Item_Aprazamento ia  
  inner join item_prescricao_medicamento ipm on ia.PRESC_CODIGO = ipm.PRESC_CODIGO AND ia.ITPRESC_CODIGO = ipm.ITPRESC_CODIGO  
 WHERE DOSE_ADM IS NULL            
 GROUP BY ia.PRESC_CODIGO, ia.ITPRESC_CODIGO, ipm.fracionado  
   
 )Y     
 ON X.PRESC_CODIGO = Y.PRESC_CODIGO AND X.ITPRESC_CODIGO = Y.ITPRESC_CODIGO              
  
LEFT JOIN  
(  
 SELECT               
 DISTINCT IPM.PRESC_CODIGO, IPM.ITPRESC_CODIGO, IPM.ITEM_PRESCRICAO_ID_SOLUCAO, IPM.ITPRESC_CODIGO_ISSOLUVEL, IPM.ITPRESC_QUANTIDADE_POSTO  
 FROM               
  ITEM_PRESCRICAO_MEDICAMENTO IPM  
  INNER JOIN #TEMP_MEDICAMENTO_POSTO_EMUSO TMP ON  IPM.PRESC_CODIGO = TMP.PRESC_CODIGO AND IPM.ITPRESC_CODIGO = TMP.ITPRESC_CODIGO  
  LEFT JOIN ITEM_APRAZAMENTO IA ON IPM.PRESC_CODIGO = IA.PRESC_CODIGO  
 ) W  
ON X.PRESC_CODIGO = W.PRESC_CODIGO AND X.ITPRESC_CODIGO = W.ITPRESC_CODIGO  
   
END  
      
if (@OPCAO = 13)          
BEGIN          
          
   SELECT           
 p.presc_codigo, convert(varchar,p.presc_data,103) as PRESC_DATA,  ipm.INS_DESCRICAO, ip.itpresc_obs,          
 p.presc_origem,           
 case when inter_codigo is not null then inter_codigo          
 when spa_codigo is not null then spa_codigo          
 when emer_codigo is not null then emer_codigo          
 when atend_codigo is not null then atend_codigo          
 else atendamb_codigo          
 end as codigo_origem,      
 'Prescrito' as status      
   FROM PRESCRICAO P            
   INNER JOIN ITEM_PRESCRICAO IP ON P.PRESC_CODIGO = IP.PRESC_CODIGO            
   INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON IP.PRESC_CODIGO = IPM.PRESC_CODIGO AND IP.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO            
   WHERE PAC_CODIGO = @PAC_CODIGO         

END     

/*LISTA DE MEDICAMENTOS DE PRESCRICOS DE INTERNACAO QUE POSSUEM PEDIDO PENDENTE PARA O POSTO DE ENFERMAGEM*/                
IF @OPCAO = 14
BEGIN            

CREATE TABLE #TEMP_MEDICAMENTO_POSTO_INTERNACAO            
(            
  PRESC_CODIGO CHAR(12),             
  ITPRESC_CODIGO INT,             
  INS_CODIGO INT,             
  MEDICAMENTO_ID INT,            
  INS_DESCRICAO VARCHAR(500),                     
  SPA_CODIGO CHAR(12),            
  EMER_CODIGO CHAR(12),            
  INTER_CODIGO CHAR(12),             
  ATEND_CODIGO CHAR(12),            
  LOCATEND_CODIGO CHAR(4),             
  ITPRESC_TOTAL_POSTO NUMERIC (9,2),                     
  GERAPEDIDOPACIENTE CHAR(1),            
  PODEFAZERPEDIDOSTOK CHAR(1),            
  INS_CODIGO_UNIDADE INT,            
  ATENDAMB_CODIGO CHAR(12),    
  PAC_NOME VARCHAR(50),     
  PROF_NOME VARCHAR(50),     
  PRESC_DATA SMALLDATETIME    
)            

SELECT * INTO #PRESCRICAO_INTERNACAO
FROM PRESCRICAO WHERE PRESC_TIPO = 'P' AND PRESC_DATA BETWEEN @DATA_INICIAL AND @DATA_FINAL AND UNID_CODIGO = @UNID_CODIGO
            
INSERT INTO #TEMP_MEDICAMENTO_POSTO_INTERNACAO            
SELECT                             
  IPM.PRESC_CODIGO, IPM.ITPRESC_CODIGO, INS_CODIGO, MEDICAMENTO_ID, INS_DESCRICAO,                     
  P.SPA_CODIGO, P.EMER_CODIGO, P.INTER_CODIGO, P.ATEND_CODIGO, P.LOCATEND_CODIGO, ITPRESC_TOTAL_POSTO,                     
  GERAPEDIDOPACIENTE, PODEFAZERPEDIDOSTOK, INS_CODIGO_UNIDADE, P.ATENDAMB_CODIGO, P.PAC_NOME, PR.PROF_NOME, P.PRESC_DATA               
 FROM                            
  #PRESCRICAO_INTERNACAO P                    
  JOIN INTERNACAO I ON I.INTER_CODIGO = P.INTER_CODIGO    
  JOIN PROFISSIONAL PR ON P.PROF_CODIGO = PR.PROF_CODIGO    
  JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON P.PRESC_CODIGO = IPM.PRESC_CODIGO                  
  where            
  EXISTS           
 (SELECT 1 FROM ITEM_PRESCRICAO_MEDICAMENTO IPM2 WHERE IPM2.PRESC_CODIGO = IPM.PRESC_CODIGO AND IPM2.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO     
 AND IPM.INS_CODIGO IS NOT NULL AND IPM.itpresc_caracteristica IS NULL   
 AND (IPM.padronizado = 'S' or IPM.padronizado is null)   
 AND IPM.PED_CODIGO IS NULL)
 AND EXISTS (SELECT 1 FROM SOAP WHERE SOAP.INTER_CODIGO = I.INTER_CODIGO)

 INSERT INTO #TEMP_MEDICAMENTO_POSTO_INTERNACAO            
 SELECT                             
  IPM.PRESC_CODIGO, IPM.ITPRESC_CODIGO, INS_CODIGO, MEDICAMENTO_ID, INS_DESCRICAO,                     
  P.SPA_CODIGO, P.EMER_CODIGO, P.INTER_CODIGO, P.ATEND_CODIGO, P.LOCATEND_CODIGO, ITPRESC_TOTAL_POSTO,                     
  GERAPEDIDOPACIENTE, PODEFAZERPEDIDOSTOK, INS_CODIGO_UNIDADE, P.ATENDAMB_CODIGO, P.PAC_NOME, PR.PROF_NOME, P.PRESC_DATA               
 FROM                            
  #PRESCRICAO_INTERNACAO P                    
  JOIN ATENDIMENTO_AMBULATORIAL AA ON AA.ATENDAMB_CODIGO = P.ATENDAMB_CODIGO    
  JOIN PROFISSIONAL PR ON P.PROF_CODIGO = PR.PROF_CODIGO    
  JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON P.PRESC_CODIGO = IPM.PRESC_CODIGO                  
  where            
  EXISTS           
 (SELECT 1 FROM ITEM_PRESCRICAO_MEDICAMENTO IPM2 WHERE IPM2.PRESC_CODIGO = IPM.PRESC_CODIGO AND IPM2.ITPRESC_CODIGO = IPM.ITPRESC_CODIGO     
 AND IPM.INS_CODIGO IS NOT NULL AND IPM.itpresc_caracteristica IS NULL   
 AND (IPM.padronizado = 'S' or IPM.padronizado is null)   
 AND IPM.PED_CODIGO IS NULL)
 AND EXISTS (SELECT 1 FROM SOAP WHERE SOAP.ATENDAMB_CODIGO = AA.ATENDAMB_CODIGO)

                  
 SELECT DISTINCT X.PRESC_CODIGO, X.ITPRESC_CODIGO, X.INS_CODIGO, X.MEDICAMENTO_ID, X.INS_DESCRICAO,                     
  X.SPA_CODIGO, X.EMER_CODIGO, X.INTER_CODIGO, X.ATEND_CODIGO, X.LOCATEND_CODIGO, X.ITPRESC_TOTAL_POSTO,                     
  X.GERAPEDIDOPACIENTE, X.PODEFAZERPEDIDOSTOK, X.INS_CODIGO_UNIDADE, ISNULL(Y.Reservado,0) AS Reservado,    
  X.PAC_NOME, X.PROF_NOME, CONVERT(VARCHAR,X.PRESC_DATA,103) as PED_DATA        
 FROM                   
(            
 SELECT * FROM #TEMP_MEDICAMENTO_POSTO_INTERNACAO WHERE MEDICAMENTO_ID = ISNULL(@MEDICAMENTO_ID, MEDICAMENTO_ID)    
 )  X            
            
LEFT JOIN            
(            
SELECT TMP.INTER_CODIGO    
FROM          
 #TEMP_MEDICAMENTO_POSTO_INTERNACAO TMP
 INNER JOIN  INTERNACAO I ON TMP.INTER_CODIGO = I.INTER_CODIGO
 INNER JOIN PACIENTE P ON I.pac_codigo = P.pac_codigo
 INNER JOIN  SETOR_CLINICA_PARAMTETRO_STOK L ON I.LOCATEND_CODIGO_ATUAL = L.LOCATENDCODIGO AND TIPOSETOR='1' AND cdSexo = P.pac_sexo 
WHERE L.PST_CODIGO = @PST_CODIGO    
) Z           
ON Z.INTER_CODIGO = X.INTER_CODIGO  
  
LEFT JOIN            
(            
SELECT TMP.ATENDAMB_CODIGO    
FROM          
 #TEMP_MEDICAMENTO_POSTO_INTERNACAO TMP
 INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON TMP.ATENDAMB_CODIGO = AA.ATENDAMB_CODIGO
 INNER JOIN PACIENTE P ON AA.pac_codigo = P.pac_codigo
 INNER JOIN  SETOR_CLINICA_PARAMTETRO_STOK L ON AA.LOCATEND_CODIGO = L.LOCATENDCODIGO AND TIPOSETOR='0' AND cdSexo = P.pac_sexo
WHERE L.PST_CODIGO = @PST_CODIGO    
) A         
ON A.ATENDAMB_CODIGO = X.ATENDAMB_CODIGO 
              
 LEFT JOIN                    
 (                    
 SELECT                 
  ia.PRESC_CODIGO, ia.ITPRESC_CODIGO,     
  case when ipm.fracionado = 'N' then    
  SUM(round(DOSE_PEDIDO,0))     
  else    
  SUM(DOSE_PEDIDO)    
  end AS Reservado          
            
 FROM                 
  Item_Aprazamento ia    
  inner join item_prescricao_medicamento ipm on ia.PRESC_CODIGO = ipm.PRESC_CODIGO AND ia.ITPRESC_CODIGO = ipm.ITPRESC_CODIGO    
 WHERE DOSE_ADM IS NULL              
 GROUP BY ia.PRESC_CODIGO, ia.ITPRESC_CODIGO, ipm.fracionado                    
 )Y                    
                    
 ON X.PRESC_CODIGO = Y.PRESC_CODIGO AND X.ITPRESC_CODIGO = Y.ITPRESC_CODIGO                    
                    
 ORDER BY X.PRESC_CODIGO, X.ITPRESC_CODIGO, X.INS_DESCRICAO
  
 DROP TABLE #PRESCRICAO_INTERNACAO
 DROP TABLE #TEMP_MEDICAMENTO_POSTO_INTERNACAO             
                             
                    
END

IF @OPCAO = 15
BEGIN      
	IF @INTER_CODIGO IS NOT NULL
	BEGIN
		SELECT
			IPM.*
		FROM
			PRESCRICAO P INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON (P.PRESC_CODIGO=IPM.PRESC_CODIGO)
		WHERE
			P.INTER_CODIGO=@INTER_CODIGO
			AND IPM.medicamento_id = @MEDICAMENTO_ID
			AND justificado = 'S'
	END


	IF @ATENDAMB_CODIGO IS NOT NULL
	BEGIN
		SELECT
			IPM.*
		FROM
			PRESCRICAO P INNER JOIN ITEM_PRESCRICAO_MEDICAMENTO IPM ON (P.PRESC_CODIGO=IPM.PRESC_CODIGO)
		WHERE
			P.ATENDAMB_CODIGO=@ATENDAMB_CODIGO
			AND IPM.medicamento_id = @MEDICAMENTO_ID
			AND justificado = 'S'
	END
	
END

-----------------------------------------------------------------
IF @OPCAO = 16
BEGIN
SELECT *, Item_Prescricao_Medicamento.INS_DESCRICAO AS INS_DESCRICAO_SOLUCAO,  
	  CASE WHEN ITAP.data_checagem is null THEN 'Não Realizada' ELSE 'Realizada' END AS "CHECAGEM"  
 FROM    Item_Prescricao_Medicamento    
 Join Item_Prescricao ON Item_Prescricao_Medicamento.presc_codigo = Item_Prescricao.presc_codigo 
                         and Item_Prescricao_Medicamento.itpresc_codigo = Item_Prescricao.itpresc_codigo    
Left Join Forma_Uso_Medicamento ON Item_Prescricao_Medicamento.forusomed_codigo = Forma_Uso_Medicamento.forusomed_codigo    
Left Join Via_Medicamento ON Item_Prescricao_Medicamento.viamed_codigo = Via_Medicamento.viamed_codigo                   
Left Join Item_Aprazamento ITAP ON Item_Prescricao_Medicamento.presc_codigo = ITAP.presc_codigo
WHERE 1 = 1  
AND Item_Prescricao_Medicamento.presc_codigo = @PRESC_CODIGO
END
----------------------------------------------------------------------------------------------------------------------------------

IF @OPCAO = 17
BEGIN
SELECT *, Item_Prescricao_Medicamento.INS_DESCRICAO AS INS_DESCRICAO_SOLUCAO
FROM    Item_Prescricao_Medicamento    
 Join Item_Prescricao ON Item_Prescricao_Medicamento.presc_codigo = Item_Prescricao.presc_codigo 
                         and Item_Prescricao_Medicamento.itpresc_codigo = Item_Prescricao.itpresc_codigo    
 Join Prescricao p ON p. presc_codigo = Item_Prescricao_Medicamento.presc_codigo
WHERE 1 = 1  
AND Item_Prescricao_Medicamento.presc_codigo = @PRESC_CODIGO
AND DATEDIFF(HOUR, p.presc_data, GETDATE()) < '24' AND IsAntibiotico = 'S' AND viamed_codigo in (89, 110)
AND (Item_Prescricao_Medicamento.IsItemPrescricaoSuspensa <> 'S'or Item_Prescricao_Medicamento.IsItemPrescricaoSuspensa is null)
END

IF @OPCAO = 18
BEGIN
	update Item_Prescricao_Medicamento set IsItemPrescricaoSuspensa = 'S' where item_prescricao_id = @ITEM_PRESCRICAO_ID
end

IF @OPCAO = 19
BEGIN
	select i.* 
		from PrescricaoPadrao pp 
		inner join 	Item_Prescricao_medicamento i on pp.presc_codigo = i.presc_codigo 
		where i.presc_codigo = @PRESC_CODIGO
		and pp.Prof_Codigo = @Prof_Codigo
		and pp.Ativo = 1
end

----------------------------------------------------------------------------------------------------------------------------------

IF (@@ERROR <> 0)                            
                            
BEGIN                            
                            
         RAISERROR('ERRO: ksp_Item_Prescricao_Medicamento',1,1)                            
                            
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Sinais_Vitais]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Sinais_Vitais]
@ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @IPSV_TEXTO VARCHAR (2000), @IPSV_INTERVALO INT, @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @ItemPrescricaoSuspensa CHAR(1)=null
AS
DECLARE @SQL VARCHAR(8000)
DECLARE @PAR VARCHAR(500)
DECLARE @VAR VARCHAR(500)

IF (@OPCAO = 0) /* LIST */
   
BEGIN

   SET @SQL =        ' SELECT ' 
   SET @SQL = @SQL + '   presc_codigo, itpresc_codigo, ipsv_texto, ipsv_intervalo, ItemPrescricaoSuspensa ' 
   SET @SQL = @SQL + ' FROM ' 
   SET @SQL = @SQL + '   Item_Prescricao_Sinais_Vitais ' 
   SET @SQL = @SQL + ' WHERE ' 
 IF @PRESC_CODIGO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @ITPRESC_CODIGO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @IPSV_TEXTO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @IPSV_TEXTO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipsv_texto ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @IPSV_INTERVALO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @IPSV_INTERVALO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipsv_intervalo ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
SET @SQL = (@SQL + @PAR)
EXEC (@SQL)


END

IF (@OPCAO = 1)  /* INCLUSAO */
 
BEGIN

   INSERT INTO Item_Prescricao_Sinais_Vitais(ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, ipsv_texto, ipsv_intervalo, ItemPrescricaoSuspensa)
        VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @ITPRESC_CODIGO, @IPSV_TEXTO, @IPSV_INTERVALO, @ItemPrescricaoSuspensa)

END

IF (@OPCAO = 2)  /* ALTERACAO */
 
BEGIN

   UPDATE
     Item_Prescricao_Sinais_Vitais
   SET
     ipsv_texto = @IPSV_TEXTO,
     ipsv_intervalo = @IPSV_INTERVALO,
	 ItemPrescricaoSuspensa = @ItemPrescricaoSuspensa
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END

IF (@OPCAO= 3) /* EXCLUSAO */

BEGIN
          
   DELETE FROM Item_Prescricao_Sinais_Vitais
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO
      
END

IF (@OPCAO= 4) /* PROCURA POR CHAVE */

BEGIN
          
   SELECT
     presc_codigo, itpresc_codigo, ipsv_texto, ipsv_intervalo, ItemPrescricaoSuspensa
   FROM
     Item_Prescricao_Sinais_Vitais
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO
      
END

IF (@OPCAO= 5) /* LISTA TODOS */

BEGIN
          
   SELECT
     presc_codigo, itpresc_codigo, ipsv_texto, ipsv_intervalo, ItemPrescricaoSuspensa
   FROM
     Item_Prescricao_Sinais_Vitais

      
END

IF (@OPCAO = 6)  /* ALTERACAO SUSPENSAO*/
 
BEGIN

   UPDATE
     Item_Prescricao_Sinais_Vitais
   SET
     ItemPrescricaoSuspensa = @ItemPrescricaoSuspensa
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END

IF (@OPCAO= 7) /* LISTA TODOS AS PRESCRICOES APRAZADAS */

BEGIN
          
   SELECT  IPSV.presc_codigo, IPSV.itpresc_codigo, IPSV.ipsv_texto, IPSV.ItemPrescricaoSuspensa  
    FROM   Item_Prescricao_Sinais_Vitais IPSV
	 Left Join Item_Aprazamento ITAP ON ITAP.presc_codigo = IPSV.presc_codigo and ITAP.itpresc_codigo = IPSV.itpresc_codigo
	WHERE IPSV.presc_codigo = @PRESC_CODIGO
	AND IPSV.itpresc_codigo = @ITPRESC_CODIGO 
	AND ITAP.data_checagem is not null

      
END

-----LISTA ITENS DA PRESCRICAO POR PRESC_CODIGO E/OU ITEM_PRESCRICAO_ID
IF @OPCAO = 8
BEGIN

     SELECT
	 IPS.item_prescricao_id,
	 IPS.presc_codigo,
	 IPS.itpresc_codigo,
	 IPS.ipsv_texto,
	 IPS.ipsv_intervalo,
	 IPS.ItemPrescricaoSuspensa,
	 IPO.itpresc_obs
     FROM Item_Prescricao_Sinais_Vitais IPS
	 JOIN Item_Prescricao IPO ON IPS.item_prescricao_id = IPO.item_prescricao_id
     WHERE IPS.presc_codigo = ISNULL(@PRESC_CODIGO, IPS.presc_codigo)
     AND IPS.item_prescricao_id = ISNULL(@ITEM_PRESCRICAO_ID, IPS.item_prescricao_id)

END

  IF @OPCAO = 18
BEGIN
	update Item_Prescricao_Sinais_Vitais set ItemPrescricaoSuspensa = 'S' where item_prescricao_id = @ITEM_PRESCRICAO_ID
end

IF (@@ERROR <> 0)

BEGIN

         RAISERROR('ERRO: ksp_Item_Prescricao_Sinais_Vitais',1,1)

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
PRINT N'Altering [dbo].[ksp_procedimento_ambulatorial]...';


GO
ALTER PROCEDURE [dbo].[ksp_procedimento_ambulatorial]
@CODATENDAMB CHAR (12), @METAPROC CHAR (8), @CODPROCAMB VARCHAR (10), @CODQTD INT, @PROCNEW CHAR (8), @PROCDESC VARCHAR (75), @MOTCOBAMB_CODIGO CHAR (3), @TP_PESQ SMALLINT, @OPCAO INT, @UNID_CODIGO CHAR (4)=NULL, @ATENDAMB_DENTE INT=NULL, @PAC_CODIGO CHAR (12)=NULL, @COD_CBO CHAR (6)=NULL, @PROF_CODIGO CHAR (4)=NULL, @PROF_NOME VARCHAR (50)=NULL, @ATENDAMB_STATUS CHAR (1)=null, @ATENDAMB_LAUDO TEXT=null, @DataInclusao datetime = null, @LocalAdicionarProcedimento varchar(50) = null
AS
declare @sql varchar(3000)  
declare @par varchar(255)    
declare @var varchar(255)  
  
-- selecao -- 
if @opcao = 0
BEGIN 
 SELECT 
	PAR.PROCAMB_CODIGO,
	PA.PROCAMB_DESCRICAO,
	PAR.ATENDAMB_QUANTIDADE,
	PAR.ATENDAMB_CODIGO, 
	PAR.ATENDAMB_DENTE, 
	CASE PAR.ATENDAMB_STATUS
		WHEN 'P' THEN 'PEDIDO SOLICITADO'           				        
		WHEN 'C' THEN 'EXAME CONCLUIDO'          
		WHEN 'L' THEN 'EXAME LIBERADO'          
	ELSE ' '          
   END ATENDAMB_STATUS, 
	PAR.ATENDAMB_LAUDO  
 FROM    PROCEDIMENTO_AMBULATORIAL_REAL PAR,  
        PROCEDIMENTO_AMBULATORIAL PA  
 WHERE PAR.ATENDAMB_CODIGO = @CODATENDAMB  
 AND     PAR.PROCAMB_CODIGO  = PA.PROCAMB_CODIGO  
 AND     PAR.PROCAMB_CODIGO  = ISNULL(@CODPROCAMB,PAR.PROCAMB_CODIGO)  
end  
  
-- inclusao ---  
if @opcao = 1  
   begin  
 If @METAPROC is not Null  
    BEGIN  
  INSERT INTO META_PROCEDIMENTO_AMBULATORIAL_REAL   
   (ATENDAMB_CODIGO, MTPROC_CODIGO, ATENDAMB_QUANTIDADE, UNID_CODIGO)   
  VALUES (@CODATENDAMB, @METAPROC,@CODQTD, @UNID_CODIGO)  
    END  
   
 INSERT INTO PROCEDIMENTO_AMBULATORIAL_REAL   
  (ATENDAMB_CODIGO, PROCAMB_CODIGO, ATENDAMB_QUANTIDADE, MOTCOBAMB_CODIGO, ATENDAMB_DENTE, CBO_CODIGO, PROF_CODIGO, PROF_NOME, ATENDAMB_STATUS, ATENDAMB_LAUDO, data_inclusao, LocalAdicionarProcedimento)  
 VALUES (@CODATENDAMB, @CODPROCAMB,@CODQTD, @MOTCOBAMB_CODIGO, @ATENDAMB_DENTE, @COD_CBO, @PROF_CODIGO, @PROF_NOME, @ATENDAMB_STATUS, @ATENDAMB_LAUDO, isnull(@DataInclusao, getdate()), @LocalAdicionarProcedimento)  
   
   end  
  
-- alteracao ---  
if @opcao = 2  
   begin  
	 UPDATE PROCEDIMENTO_AMBULATORIAL_REAL SET   
			ATENDAMB_QUANTIDADE = @CODQTD,  
			CBO_CODIGO          = @COD_CBO,  
			MOTCOBAMB_CODIGO	= @MOTCOBAMB_CODIGO,  
			ATENDAMB_DENTE		= @ATENDAMB_DENTE,  
			PROF_CODIGO		    = @PROF_CODIGO,
			PROF_NOME		    = @PROF_NOME,
			ATENDAMB_STATUS		= @ATENDAMB_STATUS,
			ATENDAMB_LAUDO		= @ATENDAMB_LAUDO
	 WHERE ATENDAMB_CODIGO		= @CODATENDAMB  
			AND   PROCAMB_CODIGO   = @CODPROCAMB  
  
	 UPDATE META_PROCEDIMENTO_AMBULATORIAL_REAL SET   
			ATENDAMB_QUANTIDADE = @CODQTD  
	 WHERE ATENDAMB_CODIGO  = @CODATENDAMB  
			AND   MTPROC_CODIGO    = @METAPROC    
   end  
  
  
-- exclusao --  
if @opcao = 3  
   BEGIN  
 SET @SQL =' DELETE PROCEDIMENTO_AMBULATORIAL_REAL '  
 SET @SQL = @SQL + ' WHERE ATENDAMB_CODIGO = ''' + RTRIM(LTRIM(@CODATENDAMB)) + ''''  
  
 If @CODPROCAMB is not null  
  SET @SQL = @SQL + ' AND  PROCAMB_CODIGO  = ''' + RTRIM(LTRIM(@CODPROCAMB)) + ''''  
  
 Execute (@SQL)  
  
  
 SET @SQL = ' DELETE META_PROCEDIMENTO_AMBULATORIAL_REAL '  
 SET @SQL = @SQL + ' WHERE ATENDAMB_CODIGO = ''' + RTRIM(LTRIM(@CODATENDAMB)) + ''''  
 IF @METAPROC is not null  
  SET @SQL = @SQL + ' AND  MTPROC_CODIGO = ''' + RTRIM(LTRIM(@METAPROC)) + ''''  
  
 Execute (@SQL)   
   END  
  
  
-- pesquisa --  
if @opcao = 4  
  begin  
    set @sql =   ' SELECT  PROCAMB.PROCAMB_CODIGO,PROCAMB.PROCAMB_DESCRICAO '  
    set @sql = @sql +  ' FROM PROCEDIMENTO_AMBULATORIAL  PROCAMB '  
    set @sql = @sql + ' WHERE 1=1 '  
      
    SET @par=''   
    if @procdesc is not null  
    begin  
 Exec ksp_ParametroPesquisa @procdesc," AND PROCAMB.PROCAMB_DESCRICAO ",@tp_pesq,"T" ,@par output    
    end  
  
    if @CODPROCAMB is not null  
    begin  
 set @var = convert(varchar,@CODPROCAMB)  
 Exec ksp_ParametroPesquisa @var," AND PROCAMB.PROCAMB_CODIGO ",@tp_pesq,"t",@par output    
    end      
  
   Execute (@sql + @par)       
end  
  
---------------- Trazer associaÃƒÂ§ÃƒÂµes --------------------  
if @opcao = 5  
   BEGIN  
  
 IF (@CODATENDAMB IS NULL)  
 BEGIN  
   
  SELECT 0 as sel,mp.mtproc_descricao,mp.mtproc_codigo, mpa.procamb_codigo mtproc_amb_codigo,   
   pa.procamb_descricao mtproc_amb_descricao, mpa.cbo_codigo  
   FROM  meta_procedimento mp,  
    meta_procedimento_ambulatorial mpa,  
    procedimento_ambulatorial pa  
   WHERE  mp.mtproc_codigo = mpa.mtproc_codigo  
   AND mpa.procamb_codigo = pa.procamb_codigo  
   AND mpa.locatend_codigo = @procnew  
 END  
 ELSE  
 BEGIN  
  SELECT 0 as sel,mp.mtproc_descricao,mp.mtproc_codigo, mpa.procamb_codigo mtproc_amb_codigo,   
   pa.procamb_descricao mtproc_amb_descricao, mpa.cbo_codigo  
   FROM  meta_procedimento mp,  
    meta_procedimento_ambulatorial mpa,  
    procedimento_ambulatorial pa  
   WHERE  mp.mtproc_codigo not in (SELECT mtproc_codigo   
        FROM meta_procedimento_ambulatorial_real  
        WHERE atendamb_codigo = @CODATENDAMB)  
   AND  mp.mtproc_codigo = mpa.mtproc_codigo  
   AND mpa.procamb_codigo = pa.procamb_codigo  
   AND mpa.locatend_codigo = @procnew  
  UNION  
  SELECT 1 as sel,mp.mtproc_descricao,mpr.mtproc_codigo, mpa.procamb_codigo mtproc_amb_codigo,   
   pa.procamb_descricao mtproc_amb_descricao, mpa.cbo_codigo  
   FROM  meta_procedimento mp,  
    meta_procedimento_ambulatorial mpa,  
    meta_procedimento_ambulatorial_real mpr,  
    procedimento_ambulatorial pa  
   WHERE  mpr.atendamb_codigo = @CODATENDAMB  
   AND  mp.mtproc_codigo = mpa.mtproc_codigo  
   AND  mpa.mtproc_codigo = mpr.mtproc_codigo    
   AND mpa.procamb_codigo = pa.procamb_codigo  
   ORDER BY mp.mtproc_descricao  
 END  
   END  
  
---------------- Trazer associaÃƒÂ§ÃƒÂµes --------------------  
if @opcao = 6  
   BEGIN  
 SELECT par.procamb_codigo,par.motcobamb_codigo,mca.motcobamb_descricao  
	FROM procedimento_ambulatorial_real par 
		LEFT JOIN motivo_cobranca_ambulatorial mca ON  par.motcobamb_codigo = mca.motcobamb_codigo
  WHERE par.atendamb_codigo = @CODATENDAMB  
  AND par.procamb_codigo = @CODPROCAMB  
   END  
----------------------- Pesquisar Tipo de Atendimento ------------------------------------------------  
If @OPCAO=7  
   BEGIN  
 SELECT s.procamb_codigo_chk procamb_codigo  
  FROM Local_Atendimento l,  
   setor_clinica s  
  WHERE l.locatend_codigo = @PROCNEW  
  AND  l.SETCLI_CODIGO = s.SETCLI_CODIGO  
   END  
  
----------------------- Selecina dados Procedimento  ------------------------------------------------  
If @OPCAO=9  
   BEGIN  
 SELECT mtproc_codigo,procamb_codigo  
  FROM meta_procedimento_ambulatorial  
  WHERE mtproc_codigo = @METAPROC  
   END  
  
------------------------------------------------------------------------------------------------------------------  
-- @OPCAO=13 = Lista todos os Procedimentos vinculados a um paciente  
If @OPCAO=13  
   BEGIN  
 Select  PA.procamb_codigo CODIGO_PROCEDIMENTO  
  ,PA.Procamb_Descricao PROC_DESCRICAO  
  ,PAR.AtendAmb_quantidade QUANTIDADE  
  , ISNULL(CONVERT( CHAR(12), AA.AtendAmb_DataFinal,103),'Sem alta') DATA,  
  PAR.atendamb_dente,  
  AA.pac_codigo,  
  AA.ATENDAMB_CODIGO  
    
    
 From Procedimento_Ambulatorial PA  
 Inner Join Procedimento_Ambulatorial_Real PAR  
  ON PA.procamb_codigo = PAR.procamb_codigo   
 Inner Join Atendimento_Ambulatorial AA  
  ON AA.atendamb_codigo = PAR.atendamb_codigo  
 Where   
  AA.PAC_CODIGO = @Pac_Codigo  
   END  
  
  
IF (@OPCAO=14)  
BEGIN  
  
 SELECT CO_PROCEDIMENTO as procamb_codigo, NO_PROCEDIMENTO as procamb_descricao 
 FROM   
  TB_PROCEDIMENTO  
 WHERE  
  (CO_PROCEDIMENTO LIKE @CODPROCAMB + '%'  
   OR NO_PROCEDIMENTO LIKE '%' + @PROCDESC + '%')  
 ORDER BY  
  PROCAMB_DESCRICAO  
END  
  
IF (@OPCAO=15)  
BEGIN  
  
 SELECT X.PROCAMB_CODIGO,X.PROCAMB_DESCRICAO,X.ATENDAMB_QUANTIDADE,X.ATENDAMB_CODIGO, X.ATENDAMB_DENTE, Y.MTPROC_CODIGO  
 FROM  
 (  
  SELECT PAR.PROCAMB_CODIGO,PA.PROCAMB_DESCRICAO,PAR.ATENDAMB_QUANTIDADE,PAR.ATENDAMB_CODIGO, PAR.ATENDAMB_DENTE  
  FROM    PROCEDIMENTO_AMBULATORIAL_REAL PAR  
         JOIN PROCEDIMENTO_AMBULATORIAL PA ON PAR.PROCAMB_CODIGO  = PA.PROCAMB_CODIGO  
  WHERE PAR.ATENDAMB_CODIGO = @CODATENDAMB) X  
 LEFT JOIN   
 (  
  SELECT MPAR.ATENDAMB_CODIGO, MPA.PROCAMB_CODIGO, MPAR.MTPROC_CODIGO  
  FROM    META_PROCEDIMENTO_AMBULATORIAL_REAL MPAR  
   JOIN META_PROCEDIMENTO_AMBULATORIAL MPA ON MPAR.MTPROC_CODIGO = MPA.MTPROC_CODIGO  
  WHERE MPAR.ATENDAMB_CODIGO = @CODATENDAMB) Y  
 ON X.ATENDAMB_CODIGO = Y.ATENDAMB_CODIGO  
 AND X.PROCAMB_CODIGO = Y.PROCAMB_CODIGO  
  
END  
  
------------------------------------------------------------------------------------------------------------------  
  
If @OPCAO=16  
   BEGIN  
 SET @SQL =    ' SELECT co_ocupacao, no_ocupacao'  
 SET @SQL = @SQL + ' FROM tb_ocupacao '  
 SET @SQL = @SQL + ' WHERE 1 = 1 '  
  
 IF @COD_CBO is not null  
   begin   
  set @var = convert(varchar,@COD_CBO)  
  Exec ksp_ParametroPesquisa @var," AND co_ocupacao ",@tp_pesq,"T" ,@par output   
   end  
  
 IF @PROCDESC is not null  
   begin  
  set @var = convert(varchar,@PROCDESC)  
  Exec ksp_ParametroPesquisa @var," AND no_ocupacao ",@tp_pesq,"T" ,@par output  
   end  
  
 SET @SQL = @SQL + @par  
 Execute (@SQL)  
   END  
  
if @opcao = 17 begin --lista os Procedimentos Realizados (Lista na Baixa BE)  
 SELECT DISTINCT LEFT(PR.CO_PROCEDIMENTO + SPACE(10),10) +  ' - ' + left(left(PR.NO_PROCEDIMENTO,50) + space(50),50)   
  + space(10) + right('0000' + rtrim(cast(atendamb_quantidade as varchar)),4) DESCRICAO ,  
  PAR.PROCAMB_CODIGO,  
  -- selecionando campos separados para carregar grid na tela checkou .net  
  pr.CO_PROCEDIMENTO + ' - ' + pr.NO_PROCEDIMENTO as procamb_descricao,  
  par.atendamb_quantidade,  
  par.cbo_codigo as COD_CBO,
  par.prof_codigo, 
  par.prof_nome,
  	CASE PAR.ATENDAMB_STATUS
		WHEN 'P' THEN 'PEDIDO SOLICITADO'           				        
		WHEN 'C' THEN 'EXAME CONCLUIDO'          
		WHEN 'L' THEN 'EXAME LIBERADO'          
	ELSE ' '          
   END ATENDAMB_STATUS,  
  CAST(PAR.ATENDAMB_LAUDO as VARCHAR(4000)) as ATENDAMB_LAUDO /*TODO: USAR CAST*/
    
 FROM    
	PROCEDIMENTO_AMBULATORIAL_REAL PAR INNER JOIN TB_PROCEDIMENTO PR ON (PAR.PROCAMB_CODIGO  = PR.CO_PROCEDIMENTO)
	LEFT JOIN PROFISSIONAL PROF ON PAR.PROF_CODIGO = PROF.PROF_CODIGO
 WHERE 
     PAR.ATENDAMB_CODIGO = @CODATENDAMB  
  
 ORDER BY PAR.PROCAMB_CODIGO  
end  
  
if @opcao = 18 begin --lista CBO dos Procedimentos Realizados (Lista Separada na Baixa BE)  
 SELECT  LEFT(ISNULL(PAR.CBO_CODIGO,'000000') + SPACE(6),6) +  left(left(ISNULL(CBO.no_ocupacao,''),50) + space(50),50) DESCRICAO ,  
  0 CODIGO  
  
 FROM    PROCEDIMENTO_AMBULATORIAL_REAL PAR  
  LEFT JOIN TB_OCUPACAO CBO ON CBO.CO_OCUPACAO = PAR.CBO_CODIGO  
 WHERE PAR.ATENDAMB_CODIGO = @CODATENDAMB  
  
 ORDER BY PAR.PROCAMB_CODIGO  
end  
  
  
if @opcao = 19 begin --cCarregaMeta_Lista  
 SELECT mr.mtproc_codigo + m.procamb_codigo + cbo_codigo, 0   
 FROM meta_procedimento_ambulatorial_real mr  
  inner join meta_procedimento_ambulatorial m on m.mtproc_codigo = mr.mtproc_codigo  
 WHERE atendamb_codigo = @CODATENDAMB  
end  
  
-- Lista todos os Procedimentos vinculados a um atendimento  
if @opcao=20  
begin  
 Select  PA.procamb_codigo PROCAMB_CODIGO  
  ,PA.Procamb_Descricao PROCAMB_DESCRICAO  
  ,PAR.AtendAmb_quantidade ATENDAMB_QUANTIDADE  
  , ISNULL(CONVERT( CHAR(12), AA.AtendAmb_DataFinal,103),'Sem alta') DATA,  
  AA.pac_codigo,  
  AA.ATENDAMB_CODIGO    
    
 From Procedimento_Ambulatorial PA  
 Inner Join Procedimento_Ambulatorial_Real PAR  
  ON PA.procamb_codigo = PAR.procamb_codigo   
 Inner Join Atendimento_Ambulatorial AA  
  ON AA.atendamb_codigo = PAR.atendamb_codigo  
 Where   
  AA.atendamb_codigo = @CODATENDAMB  
 UNION ALL  
  Select ipm.co_procedimento PROCAMB_CODIGO  
  ,tb.no_procedimento PROCAMB_DESCRICAO  
  ,ipm.ippr_quantidade ATENDAMB_QUANTIDADE  
  , ISNULL(CONVERT( CHAR(12), AA.AtendAmb_DataFinal,103),'Sem alta') DATA,    
  AA.pac_codigo,  
  AA.ATENDAMB_CODIGO    
 From prescricao p  
 Inner Join item_prescricao ip on p.presc_codigo = ip.presc_codigo   
 Inner Join Item_Prescricao_Procedimento ipm on ipm.presc_codigo = ip.presc_codigo and ipm.itpresc_codigo = ip.itpresc_codigo   
 Inner Join tb_procedimento tb on tb.co_procedimento = ipm.co_procedimento  
 Inner Join Atendimento_Ambulatorial AA ON AA.atendamb_codigo = p.atendamb_codigo  
 Where p.atendamb_codigo = @CODATENDAMB  
end  
     
--> Verifica se o procedimento ÃƒÆ’Ã‚Â© principal  
if @opcao=21  
begin  
 select  procamb_codigo  
 from  procedimento_ambulatorial  
 where  procamb_pab = 'S'  
 and  procamb_codigo = @codprocamb  
  
end  
--> atualiza status do procedimento
if @opcao=22
begin
	update procedimento_ambulatorial_real
	set ATENDAMB_STATUS= @ATENDAMB_STATUS
	where procamb_codigo= @codprocamb
end
  
if @OPCAO = 23
begin
	SELECT par.atendamb_codigo, p.co_procedimento as Procamb_Codigo, p.NO_PROCEDIMENTO as PROCAMB_DESCRICAO, sum(par.atendamb_quantidade) as Quantidade
		
	FROM
		procedimento_ambulatorial_real par INNER JOIN TB_PROCEDIMENTO P ON (par.procamb_codigo=P.CO_PROCEDIMENTO)
		LEFT JOIN TB_OCUPACAO O ON (par.cbo_codigo=O.CO_OCUPACAO)
		LEFT JOIN PROFISSIONAL_REDE PR ON (par.PROF_CODIGO=PR.PROF_CODIGO)
	WHERE 
		par.atendamb_codigo = @CODATENDAMB
	and LocalAdicionarProcedimento = 'ADICIONADOPELAEVOLUCAO'

	group by par.atendamb_codigo, p.co_procedimento, p.NO_PROCEDIMENTO
end
------------------------------------------------------------------------------------------------------------------  
  
   
If (@@ERROR <> 0)  
   BEGIN  
 RAISERROR('ERRO !! - KSP_PROCEDIMENTO_AMBULATORIAL .',1,1)   
    
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
PRINT N'Altering [dbo].[ksp_Setor]...';


GO
ALTER PROCEDURE [dbo].[ksp_Setor]
@opcao SMALLINT, @tp_pesq SMALLINT, @codigo CHAR (4), @descricao VARCHAR (30), @setcli_codigo CHAR (4), @setcli_descricao VARCHAR (30), @divisao CHAR (2), @unidade CHAR (4), @setorAmb CHAR (1)=NULL, @setorAdm CHAR (1)=NULL, @setorAlmox CHAR (1)=NULL, @setorLab CHAR (1)=NULL, @setorInter CHAR (1)=NULL, @setorLeitoInter CHAR (1)=NULL, @setorEmerg CHAR (1)=NULL, @setorSpa CHAR (1)=NULL, @setorSolicitaCirurgia CHAR (1)=NULL, @tipo_censo CHAR (1)=NULL, @procambCod_spa CHAR (10)=null, @grpAtendCod_spa CHAR (3)=NULL, @tpAtendCod_spa CHAR (3)=NULL, @atvProfCod_spa CHAR (3)=NULL, @procambCod_eme CHAR (10)=null, @grpAtendCod_eme CHAR (3)=NULL, @tpAtendCod_eme CHAR (3)=NULL, @atvProfCod_eme CHAR (3)=NULL, @procambCod_chk CHAR (10)=null, @grpAtendCod_chk CHAR (3)=NULL, @tpAtendCod_chk CHAR (3)=NULL, @atvProfCod_chk CHAR (3)=NULL, @setcli_usa_autorizacao CHAR (1)=NULL, @setcli_dias_fechamento INT=0, @locatend_codigo CHAR (4)=NULL, @setor_Atualiza_Clinica_Movimentacao CHAR (1)=null, @setor_Padrao_Clinica CHAR (1)=null, @setor_Impede_Fora_Clinica CHAR (1)=null, @procambCod_chk_Sub CHAR (10)=null, @grpAtendCod_chk_Sub CHAR (3)=NULL, @tpAtendCod_chk_Sub CHAR (3)=NULL, @atvProfCod_chk_Sub CHAR (3)=NULL, @procambCod_chk_Extra CHAR (10)=null, @grpAtendCod_chk_Extra CHAR (3)=NULL, @tpAtendCod_chk_Extra CHAR (3)=NULL, @atvProfCod_chk_Extra CHAR (3)=NULL, @procambCod_chk_Triagem CHAR (10)=null, @grpAtendCod_chk_Triagem CHAR (3)=NULL, @tpAtendCod_chk_Triagem CHAR (3)=NULL, @atvProfCod_chk_Triagem CHAR (3)=NULL, @procambCod_chk_Fichar CHAR (10)=null, @grpAtendCod_chk_Fichar CHAR (3)=NULL, @tpAtendCod_chk_Fichar CHAR (3)=NULL, @atvProfCod_chk_Fichar CHAR (3)=NULL, @procambCod_chk_Retorno CHAR (10)=null, @grpAtendCod_chk_Retorno CHAR (3)=NULL, @tpAtendCod_chk_Retorno CHAR (3)=NULL, @atvProfCod_chk_Retorno CHAR (3)=NULL, @setcli_local_emergencia CHAR (1)=null, @setcli_dias_uteis CHAR (1)=null, @setcli_dias_feriados CHAR (1)=null, @codproc CHAR (10)=Null, @idade SMALLINT=Null, @Codigo_CBO_EME CHAR (6)=null, @Codigo_CBO_SPA CHAR (6)=null, @Codigo_CBO_CHK CHAR (6)=null, @Codigo_CBO_CHK_Sub CHAR (6)=null, @Codigo_CBO_CHK_Extra CHAR (6)=null, @Codigo_CBO_CHK_Triagem CHAR (6)=null, @Codigo_CBO_CHK_Fichar CHAR (6)=null, @Codigo_CBO_CHK_Retorno CHAR (6)=null, @Codigo_Setor_Clinica VARCHAR (3000)=null, @Codigo_Setor_CID VARCHAR (3000)=null, @Codigo_Integracao VARCHAR (10)=null, @set_encaminhamento_interno CHAR (1)='N', @setcli_operacional CHAR (1)=null, @procambCod_risco_pressao CHAR (10)=NULL, @grpAtendCod_risco_pressao CHAR (3)=NULL, @tpAtendCod_risco_pressao CHAR (3)=NULL, @atvProfCod_risco_pressao CHAR (3)=NULL, @Codigo_CBO_risco_pressao CHAR (6)=NULL, @procambCod_risco_glicemia CHAR (10)=NULL, @grpAtendCod_risco_glicemia CHAR (3)=NULL, @tpAtendCod_risco_glicemia CHAR (3)=NULL, @atvProfCod_risco_glicemia CHAR (3)=NULL, @Codigo_CBO_risco_glicemia CHAR (6)=NULL, @procambCod_risco_consulta CHAR (10)=NULL, @grpAtendCod_risco_consulta CHAR (3)=NULL, @tpAtendCod_risco_consulta CHAR (3)=NULL, @atvProfCod_risco_consulta CHAR (3)=NULL, @Codigo_CBO_risco_consulta CHAR (6)=NULL, @procamb_codigo_inalacao char(10) = null, @cbo_codigo_inalacao char(6) = null, @procamb_codigo_administracao_medicamento char(10) = null, @cbo_codigo_administracao_medicamento char(6) = null, @procamb_codigo_evolucao_urg_emer char(10) = null, @cbo_codigo_evolucao_urg_emer char(6) = null, @procamb_codigo_evolucao_internacao char(10) = null, @cbo_codigo_evolucao_internacao char(6) = null
AS
set nocount on
	Declare @sql Varchar(8000)
	Declare @par varchar(255)
	Declare @var1 varchar(255)

	declare @local char(4)
	DECLARE @ERROR NUMERIC(6)
	SET @ERROR = 0

	declare @id_setor_clinica char(4)
	DECLARE @S1 VARCHAR(100)
	DECLARE @S2 VARCHAR(100)
	DECLARE @ARRAY1 VARCHAR(3000)
	DECLARE @ARRAY2 VARCHAR(3000)
	DECLARE @DELIMITADOR CHAR(1)

	SELECT @DELIMITADOR = '^'

----------------------------- Selecao para Carga dos Dados ------------------------------------
if @opcao = 0 --PESQUISA SETOR
  begin
	set @Sql = 'SELECT s.set_codigo, s.set_descricao, s.div_codigo, s.set_data, d.div_descricao '
	set @Sql = @Sql + 'From Setor S, Divisao D '
	set @Sql = @Sql + ' Where s.div_codigo *= d.div_codigo And '

	if @codigo is not null
	   begin
	    Set @var1 = convert(varchar,@codigo)
	    Exec ksp_ParametroPesquisa @var1,'s.set_codigo',@tp_pesq, 't', @par output
	   end

	if @descricao is not null
	   begin
	    Set @var1 = @descricao
	    Exec ksp_ParametroPesquisa @var1,'s.set_descricao',@tp_pesq, 't', @par output
	   end

	if @setcli_descricao is not null  --APROVEITA PARA DIVISAO
	   begin
	    Set @var1 = @setcli_descricao
	    Exec ksp_ParametroPesquisa @var1,'D.div_descricao',@tp_pesq, 't', @par output
	   end

	Set @Sql = @Sql + @par + ' Order by s.set_descricao '	

	exec(@Sql)

	IF @@ERROR <> 0 SET @ERROR = @@ERROR
   end
if @opcao = 1 --Inclui SETOR
  begin
	
	EXEC ksp_controle_sequencial @unidade, 'setor', null, 1, 4, null, @codigo output

	insert into Setor (	set_codigo, 
				set_descricao,
				div_codigo,
				set_data) 

		values	(	@codigo, 
				@descricao,
				@divisao,
				GETDATE()) 

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	select @codigo

  END
if @opcao = 2 --Altera SETOR
  begin
	update 	setor 
	set 	set_descricao 	= @descricao,
		div_codigo	= @divisao
	where	set_codigo 	= @codigo

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	update 	local_atendimento
	set 	div_codigo 	= @divisao
	where	set_codigo 	= @codigo

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

  END
if @opcao = 3 --Exclui SETOR
  begin

	delete 	from local_atendimento where set_codigo = @codigo
		and unid_codigo = @unidade

	delete 	from setor where set_codigo = @codigo


  END

if @opcao = 4 --PESQUISA SETOR_CLINICA
  begin
	set @Sql = 'SELECT sc.setcli_operacional,sc.setcli_codigo_local, s.set_data, sc.setcli_descricao, l.div_codigo, d.div_descricao, l.unid_codigo, '+
	'u.unid_descricao,l.locatend_codigo, l.set_codigo set_codigo, s.set_descricao set_descricao, sc.set_ambulatorio,sc.set_administrativo,sc.set_almoxarifado, '+
	'sc.set_laboratorio,sc.set_internacao,sc.set_emergencia,sc.set_spa, sc.set_tipo_censo, sc.set_solicita_cirurgia, ' + 
	'sc.procamb_codigo_eme, p_eme.NO_PROCEDIMENTO procamb_descricao_eme, ' +
	'sc.procamb_codigo_spa, p_spa.NO_PROCEDIMENTO procamb_descricao_spa, ' +
	'sc.procamb_codigo_chk, p_chk.NO_PROCEDIMENTO procamb_descricao_chk, ' +
	'sc.set_leitointernacao, sc.setcli_usa_autorizacao, sc.setcli_dias_fechamento, ' +
	'sc.set_atualiza_clinica_movimentacao, sc.set_padrao_clinica, sc.set_impede_fora_clinica, ' +
	'sc.procamb_codigo_chk_Sub, p_chk_Sub.NO_PROCEDIMENTO procamb_descricao_chk_Sub, ' +
	'sc.procamb_codigo_chk_Extra, p_chk_Extra.NO_PROCEDIMENTO procamb_descricao_chk_Extra, ' +
	'sc.procamb_codigo_chk_Triagem, p_chk_Triagem.NO_PROCEDIMENTO procamb_descricao_chk_Triagem, ' +
	'sc.procamb_codigo_chk_Fichar, p_chk_Fichar.NO_PROCEDIMENTO procamb_descricao_chk_Fichar, ' +
	'sc.procamb_codigo_chk_Retorno, p_chk_Retorno.NO_PROCEDIMENTO procamb_descricao_chk_Retorno, ' +
	'sc.setcli_local_emergencia, sc.setcli_dias_uteis, sc.setcli_dias_feriados, ' +
	'cbo_codigo_EME, sus_cbo_eme.no_ocupacao sus_descricao_eme, ' +
	'cbo_codigo_SPA, sus_cbo_spa.no_ocupacao sus_descricao_spa, ' +
	'cbo_codigo_CHK, sus_cbo_chk.no_ocupacao sus_descricao_chk, ' +
	'cbo_codigo_CHK_Sub, sus_cbo_chk_Sub.no_ocupacao sus_descricao_chk_Sub, ' +
	'cbo_codigo_CHK_Extra, sus_cbo_chk_Extra.no_ocupacao sus_descricao_chk_Extra, ' +
	'cbo_codigo_CHK_Triagem, sus_cbo_chk_Triagem.no_ocupacao sus_descricao_chk_Triagem, ' +
	'cbo_codigo_CHK_Fichar, sus_cbo_chk_Fichar.no_ocupacao sus_descricao_chk_Fichar, ' +
	'cbo_codigo_CHK_Retorno, sus_cbo_chk_Retorno.no_ocupacao sus_descricao_chk_Retorno, ' +
	'sc.Codigo_Integracao, sc.setcli_data, sc.set_encaminhamento_interno, ' +
	'sc.procamb_codigo_RISCO_Pressao, p_risco_pressao.NO_PROCEDIMENTO procamb_descricao_risco_pressao, ' +
	'sc.cbo_codigo_RISCO_Pressao, sus_cbo_risco_pressao.no_ocupacao sus_descricao_RISCO_Pressao, ' +	
	'sc.procamb_codigo_RISCO_Glicemia, p_risco_glicemia.NO_PROCEDIMENTO procamb_descricao_risco_Glicemia, ' +
	'sc.cbo_codigo_RISCO_glicemia, sus_cbo_risco_glicemia.no_ocupacao sus_descricao_RISCO_Glicemia, ' +	
	'sc.procamb_codigo_RISCO_Consulta, p_risco_consulta.NO_PROCEDIMENTO procamb_descricao_risco_Consulta, ' +
	'sc.cbo_codigo_RISCO_Consulta, sus_cbo_risco_consulta.no_ocupacao sus_descricao_RISCO_Consulta, ' +
	'sc.procamb_codigo_inalacao, p_inalacao.NO_PROCEDIMENTO procamb_desc_inalacao,' +
	'sc.cbo_codigo_inalacao, sus_cbo_inalacao.no_ocupacao cbo_desc_inalacao, ' +
	'sc.procamb_codigo_administracao_medicamento, p_adm_medicamento.NO_PROCEDIMENTO procamb_desc_adm_medicamento,' +
	'sc.cbo_codigo_administracao_medicamento, sus_cbo_administracao_medicamento.no_ocupacao cbo_desc_adm_medicamento,  ' +
	'sc.procamb_codigo_evolucao_urg_emer, p_evolucao_urg_emer.NO_PROCEDIMENTO procamb_desc_evolucao_urg_emer,' +
	'sc.cbo_codigo_evolucao_urg_emer, sus_cbo_evolucao_Ugr_Emer.no_ocupacao cbo_desc_evolucao_urg_emer,  ' +
	'sc.procamb_codigo_evolucao_internacao, p_evolucao_internacao.NO_PROCEDIMENTO procamb_desc_evolucao_internacao,' +
	'sc.cbo_codigo_evolucao_internacao, sus_cbo_evolucao_internacao.no_ocupacao cbo_desc_evolucao_internacao  ' +


    'FROM setor s ' +
    'JOIN local_atendimento l ' +
    '  ON s.set_codigo = l.set_codigo ' +
    'JOIN divisao d ' +
    '  ON l.div_codigo = d.div_codigo ' +
    'JOIN unidade u ' +
    '  ON l.unid_codigo = u.unid_codigo ' +
    'JOIN setor_clinica sc ' +
    '  ON l.setcli_codigo = sc.setcli_codigo ' +
    'LEFT JOIN tb_procedimento p_eme ' +
    '  ON sc.procamb_codigo_eme = p_eme.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_spa ' +
    '  ON sc.procamb_codigo_spa = p_spa.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk ' +
    '  ON sc.procamb_codigo_chk = p_chk.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk_Sub ' +
    '  ON sc.procamb_codigo_chk_Sub = p_chk_Sub.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk_Extra ' +
    '  ON sc.procamb_codigo_chk_Extra = p_chk_Extra.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk_Triagem ' +
    '  ON sc.procamb_codigo_chk_Triagem = p_chk_Triagem.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk_Fichar ' +
    '  ON sc.procamb_codigo_chk_Fichar = p_chk_Fichar.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_chk_Retorno ' +
    '  ON sc.procamb_codigo_chk_Retorno = p_chk_Retorno.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_risco_pressao ' +
    '  ON sc.procamb_codigo_risco_pressao = p_risco_pressao.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_risco_glicemia ' +
    '  ON sc.procamb_codigo_risco_glicemia = p_risco_glicemia.CO_PROCEDIMENTO ' +
    'LEFT JOIN tb_procedimento p_risco_consulta ' +
    '  ON sc.procamb_codigo_risco_consulta = p_risco_consulta.CO_PROCEDIMENTO ' +
	'LEFT JOIN tb_procedimento p_inalacao ' +
    '  ON sc.procamb_codigo_inalacao = p_inalacao.CO_PROCEDIMENTO ' +
	'LEFT JOIN tb_procedimento p_adm_medicamento ' +
    '  ON sc.procamb_codigo_administracao_medicamento = p_adm_medicamento.CO_PROCEDIMENTO ' +
	'LEFT JOIN tb_procedimento p_evolucao_urg_emer ' +
    '  ON sc.procamb_codigo_evolucao_urg_emer = p_evolucao_urg_emer.CO_PROCEDIMENTO ' +
	'LEFT JOIN tb_procedimento p_evolucao_internacao ' +
    '  ON sc.procamb_codigo_evolucao_internacao = p_evolucao_internacao.CO_PROCEDIMENTO ' +


    'LEFT JOIN tb_ocupacao sus_cbo_eme ' +
    '  ON sc.cbo_codigo_EME = sus_cbo_eme.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_spa ' +
    '  ON sc.cbo_codigo_SPA = sus_cbo_spa.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk ' +
    '  ON sc.cbo_codigo_CHK = sus_cbo_chk.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk_Sub ' +
    '  ON sc.cbo_codigo_CHK_Sub = sus_cbo_chk_Sub.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk_Extra ' +
    '  ON sc.cbo_codigo_CHK_Extra = sus_cbo_chk_Extra.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk_Triagem ' +
    '  ON sc.cbo_codigo_CHK_Triagem = sus_cbo_chk_Triagem.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk_Fichar ' +
    '  ON sc.cbo_codigo_CHK_Fichar = sus_cbo_chk_Fichar.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_chk_Retorno ' +
    '  ON sc.cbo_codigo_CHK_Retorno = sus_cbo_chk_Retorno.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_risco_pressao ' +
    '  ON sc.cbo_codigo_risco_pressao = sus_cbo_risco_pressao.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_risco_glicemia ' +
    '  ON sc.cbo_codigo_risco_glicemia = sus_cbo_risco_glicemia.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_risco_consulta ' +
    '  ON sc.cbo_codigo_risco_consulta = sus_cbo_risco_consulta.co_ocupacao ' +   
	'LEFT JOIN tb_ocupacao sus_cbo_inalacao ' +
    '  ON sc.cbo_codigo_inalacao = sus_cbo_inalacao.co_ocupacao ' +
    'LEFT JOIN tb_ocupacao sus_cbo_administracao_medicamento ' +
    '  ON sc.cbo_codigo_administracao_medicamento = sus_cbo_administracao_medicamento.co_ocupacao ' +  
	'LEFT JOIN tb_ocupacao sus_cbo_evolucao_Ugr_Emer ' +
    '  ON sc.cbo_codigo_evolucao_urg_emer = sus_cbo_evolucao_Ugr_Emer.co_ocupacao ' +  
	'LEFT JOIN tb_ocupacao sus_cbo_evolucao_internacao ' +
    '  ON sc.cbo_codigo_evolucao_internacao = sus_cbo_evolucao_internacao.co_ocupacao ' +  
        
    'WHERE l.enf_codigo is null ' +
	'AND u.unid_codigo = ''' + @unidade + ''''


	set @par = ' ' 

	if @setcli_codigo is not null
	   begin
	    Set @var1 = convert(varchar,@setcli_codigo)
	    Exec ksp_ParametroPesquisa @var1, 'sc.setcli_codigo_local', @tp_pesq, 't', @par output
	    Set @Sql = @Sql + ' and ' + @par
	   end
	
	set @par = ' ' 

	if @setcli_descricao is not null
	   begin
	    Set @var1 = @setcli_descricao
	    Exec ksp_ParametroPesquisa @var1,'sc.setcli_descricao', @tp_pesq, 't', @par output
	    Set @Sql = @Sql + ' and ' + @par
	   end

	set @par = ' '
	   
	if @locatend_codigo is not null
	   begin
	    Set @var1 = @locatend_codigo
	    Exec ksp_ParametroPesquisa @var1,'l.locatend_codigo', @tp_pesq, 't', @par output
	    Set @Sql = @Sql + ' and ' + @par
	   end


	Set @Sql = @Sql + ' Order by sc.setcli_descricao '	
	
	exec(@Sql)

	IF @@ERROR <> 0 SET @ERROR = @@ERROR
   end

-------------------- Inclusao dos Dados ---------------------------------------
If @opcao = 5
   BEGIN

	select @divisao = div_codigo from setor where set_codigo = @codigo

	--verifica a UNIDADE	
	IF NOT EXISTS (select 1 from local_atendimento where unid_codigo = @unidade and div_codigo is null)
	begin
		-- Inclui Local_Atendimento, referente à UNIDADE
		EXEC ksp_controle_sequencial @unidade, 'local_atendimento', null, 1, 4, null, @local output
		INSERT INTO Local_Atendimento 
			(Locatend_codigo,unid_codigo)
		VALUES			       
			(@local ,@unidade)

		IF @@ERROR <> 0 SET @ERROR = @@ERROR
	end

	--verifica a DIVISAO
	IF NOT EXISTS (	select 1 from local_atendimento 
			where 	unid_codigo = @unidade 
			and 	div_codigo = @divisao
			and 	set_codigo is null)
	begin
		-- Inclui Local_Atendimento, referente à DIVISAO
		EXEC ksp_controle_sequencial @unidade, 'local_atendimento', null, 1, 4, null, @local output
		INSERT INTO Local_Atendimento 
			(Locatend_codigo,unid_codigo,div_codigo)
		VALUES			       
			(@local ,@unidade,@divisao)
		IF @@ERROR <> 0 SET @ERROR = @@ERROR
	end

	--verifica o SETOR
	IF NOT EXISTS ( select 1 from local_atendimento 
			where 	unid_codigo = @unidade 
			and 	div_codigo = @divisao
			and 	set_codigo = @codigo
			and 	setcli_codigo is null)
	begin
		-- Inclui Local_Atendimento, referente à SETOR
		EXEC ksp_controle_sequencial @unidade, 'local_atendimento', null, 1, 4, null, @local output
		INSERT INTO Local_Atendimento 
			(Locatend_codigo,unid_codigo,div_codigo,set_codigo)
		VALUES			       
			(@local ,@unidade,@divisao,@codigo)
		IF @@ERROR <> 0 SET @ERROR = @@ERROR
	end


	EXEC ksp_controle_sequencial @unidade, 'Setor_clinica', null, 1, 4, null, @local output


	if @setcli_codigo is null
	begin
		select  @setcli_codigo = max(sc.setcli_codigo_local) 
					from setor_clinica sc inner join local_atendimento la
					on la.setcli_codigo = sc.setcli_codigo
					and la.enf_codigo is null and isnumeric(sc.setcli_codigo_local) = 1
					and la.unid_codigo = @unidade

		if @setcli_codigo is null
		   begin
			set @setcli_codigo = '0001'
		   end
		else
		begin
			set @setcli_codigo = right('0000' + rtrim(convert(varchar, convert(int, @setcli_codigo) + 1 )),4)
		end
	
		
	end


	INSERT INTO Setor_clinica
		(setcli_codigo, setcli_codigo_local,Setcli_descricao, 
		procamb_Codigo_eme, grpAtend_Codigo_eme, tpAtend_Codigo_eme, 
        procamb_Codigo_spa, grpAtend_Codigo_spa, tpAtend_Codigo_spa, 
        procamb_Codigo_chk, grpAtend_Codigo_chk, tpAtend_Codigo_chk, 
		procamb_Codigo_chk_Sub, grpAtend_Codigo_chk_Sub, tpAtend_Codigo_chk_Sub, 
		procamb_Codigo_chk_Extra, grpAtend_Codigo_chk_Extra, tpAtend_Codigo_chk_Extra, 
		procamb_Codigo_chk_Triagem, grpAtend_Codigo_chk_Triagem, tpAtend_Codigo_chk_Triagem, 
		procamb_Codigo_chk_Fichar, grpAtend_Codigo_chk_Fichar, tpAtend_Codigo_chk_Fichar, 
		procamb_Codigo_chk_Retorno, grpAtend_Codigo_chk_Retorno, tpAtend_Codigo_chk_Retorno, 
		set_ambulatorio, set_administrativo, set_almoxarifado,
		set_laboratorio, set_internacao, set_LeitoInternacao, set_emergencia,
		set_spa, set_solicita_cirurgia, set_tipo_censo, setcli_usa_autorizacao, setcli_dias_fechamento,  
        set_atualiza_clinica_movimentacao, set_padrao_clinica, set_impede_fora_clinica, setcli_local_emergencia,
        setcli_dias_uteis, setcli_dias_feriados,
        atvProf_Codigo_eme, atvProf_Codigo_spa,	atvProf_Codigo_chk, atvProf_Codigo_chk_Sub, atvProf_Codigo_chk_Extra,
        atvProf_Codigo_chk_Triagem, atvProf_Codigo_chk_Fichar, atvProf_Codigo_chk_Retorno,
        cbo_codigo_EME, cbo_codigo_SPA, cbo_codigo_CHK, cbo_codigo_CHK_Sub, cbo_codigo_CHK_Extra,
        cbo_codigo_CHK_Triagem, cbo_codigo_CHK_Fichar, cbo_codigo_CHK_Retorno, Codigo_Integracao,
        set_encaminhamento_interno, setcli_data, setcli_operacional,
        procamb_codigo_RISCO_Pressao, grpatend_codigo_RISCO_Pressao, atvprof_codigo_RISCO_Pressao, tpatend_codigo_RISCO_Pressao, cbo_codigo_RISCO_Pressao,
		procamb_codigo_RISCO_Glicemia, grpatend_codigo_RISCO_Glicemia, atvprof_codigo_RISCO_Glicemia, tpatend_codigo_RISCO_Glicemia, cbo_codigo_RISCO_Glicemia,
		procamb_codigo_RISCO_Consulta, grpatend_codigo_RISCO_Consulta, atvprof_codigo_RISCO_Consulta, tpatend_codigo_RISCO_Consulta, cbo_codigo_RISCO_Consulta,
		procamb_codigo_inalacao, cbo_codigo_inalacao, procamb_codigo_administracao_medicamento, cbo_codigo_administracao_medicamento,
		procamb_codigo_evolucao_urg_emer, cbo_codigo_evolucao_urg_emer, procamb_codigo_evolucao_internacao, cbo_codigo_evolucao_internacao
        )

	VALUES   
		(@local, @setcli_codigo,@setcli_descricao, 
		@procambCod_eme, @grpAtendCod_eme, @tpAtendCod_eme, 
		@procambCod_spa, @grpAtendCod_spa, @tpAtendCod_spa, 
		@procambCod_chk, @grpAtendCod_chk, @tpAtendCod_chk, 
    	@procambCod_chk_Sub, @grpAtendCod_chk_Sub, @tpAtendCod_chk_Sub, 
		@procambCod_chk_Extra, @grpAtendCod_chk_Extra, @tpAtendCod_chk_Extra, 
		@procambCod_chk_Triagem, @grpAtendCod_chk_Triagem, @tpAtendCod_chk_Triagem, 
		@procambCod_chk_Fichar, @grpAtendCod_chk_Fichar, @tpAtendCod_chk_Fichar, 
		@procambCod_chk_Retorno, @grpAtendCod_chk_Retorno, @tpAtendCod_chk_Retorno, 
		@setorAmb, @setorAdm, @setorAlmox,
		@setorLab, @setorInter, @setorLeitoInter, @setorEmerg,
		@setorSpa, @setorSolicitaCirurgia, @tipo_censo, @setcli_usa_autorizacao, @setcli_dias_fechamento,
	    @setor_Atualiza_Clinica_Movimentacao, @setor_Padrao_Clinica, @setor_Impede_Fora_Clinica, @setcli_local_emergencia,
        @setcli_dias_uteis, @setcli_dias_feriados,
        @atvProfCod_eme, @atvProfCod_spa, @atvProfCod_chk, @atvProfCod_chk_Sub, @atvProfCod_chk_Extra, 
        @atvProfCod_chk_Triagem, @atvProfCod_chk_Fichar, @atvProfCod_chk_Retorno,
        @Codigo_CBO_EME, @Codigo_CBO_SPA, @Codigo_CBO_CHK, @Codigo_CBO_CHK_Sub, @Codigo_CBO_CHK_Extra, 
        @Codigo_CBO_CHK_Triagem, @Codigo_CBO_CHK_Fichar, @Codigo_CBO_CHK_Retorno,@Codigo_Integracao,
        @set_encaminhamento_interno, GETDATE(), @setcli_operacional
        ,@procambCod_risco_pressao, @grpAtendCod_risco_pressao, @tpAtendCod_risco_pressao, @atvProfCod_risco_pressao, @Codigo_CBO_risco_pressao
		,@procambCod_risco_glicemia, @grpAtendCod_risco_glicemia, @tpAtendCod_risco_glicemia, @atvProfCod_risco_glicemia, @Codigo_CBO_risco_glicemia
		,@procambCod_risco_consulta, @grpAtendCod_risco_consulta, @tpAtendCod_risco_consulta, @atvProfCod_risco_consulta, @Codigo_CBO_risco_consulta,
		@procamb_codigo_inalacao, @cbo_codigo_inalacao, @procamb_codigo_administracao_medicamento, @cbo_codigo_administracao_medicamento,
		@procamb_codigo_evolucao_urg_emer, @cbo_codigo_evolucao_urg_emer, @procamb_codigo_evolucao_internacao, @cbo_codigo_evolucao_internacao
        )

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

    declare @codigo_local char(4) 

    set @codigo_local = @setcli_codigo 

	SET @setcli_codigo = @LOCAL

	EXEC ksp_controle_sequencial @unidade, 'local_atendimento', null, 1, 4, null, @local output

	-- Insere na tabela Local_Atendimento
	INSERT INTO Local_Atendimento 
		(Locatend_codigo,unid_codigo,div_codigo,set_codigo,setcli_codigo)
	VALUES			       
		(@local ,@unidade,@divisao,@codigo,@setcli_codigo)

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	Select @codigo_local		
   END

-------------------- Alteracao dos Dados ---------------------------------------
if @opcao = 6
   BEGIN


	select @id_setor_clinica = sc.setcli_codigo 
		from 	setor_clinica  sc, local_atendimento la
		where	sc.setcli_codigo = la.setcli_codigo 
		and	sc.setcli_codigo_local = @setcli_codigo
		and	la.unid_codigo = @unidade


	UPDATE Local_Atendimento SET		
		set_codigo	   = @codigo,
		div_codigo 	   = (select div_codigo from setor where set_codigo = @codigo)
	WHERE  	Setcli_codigo      = @id_setor_clinica

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	UPDATE Setor_Clinica SET
		Setcli_descricao 	= @setcli_descricao,

		set_ambulatorio    = isnull(@setorAmb,'N'),
		set_administrativo = isnull(@setorAdm,'N'),
		set_almoxarifado   = isnull(@setorAlmox,'N'),
		set_laboratorio    = isnull(@setorLab,'N'),
		set_internacao     = isnull(@setorInter,'N'),
		set_LeitoInternacao = isnull(@setorLeitoInter,'N'),
		set_emergencia     = isnull(@setorEmerg,'N'),
		set_spa            = isnull(@setorSpa,'N'),
		set_solicita_cirurgia = isnull(@setorSolicitaCirurgia,'N'),
		set_tipo_censo     = @tipo_censo,

		procamb_Codigo_eme	= @procambCod_eme,
		procamb_Codigo_spa	= @procambCod_spa,
		procamb_Codigo_chk	= @procambCod_chk,
		procamb_Codigo_chk_Sub	= @procambCod_chk_Sub,
		procamb_Codigo_chk_Extra	= @procambCod_chk_Extra,
		procamb_Codigo_chk_Triagem	= @procambCod_chk_Triagem,
		procamb_Codigo_chk_Fichar	= @procambCod_chk_Fichar,
		procamb_Codigo_chk_Retorno	= @procambCod_chk_Retorno,
		
		setcli_usa_autorizacao = @setcli_usa_autorizacao,
		setcli_dias_fechamento = @setcli_dias_fechamento,
  		set_atualiza_clinica_movimentacao = @setor_Atualiza_Clinica_Movimentacao,
		set_padrao_clinica = @setor_Padrao_Clinica, 
		set_impede_fora_clinica = @setor_Impede_Fora_Clinica,
		setcli_local_emergencia = @setcli_local_emergencia, 
		setcli_dias_uteis = @setcli_dias_uteis,
		setcli_dias_feriados = @setcli_dias_feriados,

	        cbo_codigo_EME = @Codigo_CBO_EME,
	        cbo_codigo_SPA = @Codigo_CBO_SPA,
	        cbo_codigo_CHK = @Codigo_CBO_CHK,
	        cbo_codigo_CHK_Sub = @Codigo_CBO_CHK_Sub,
	        cbo_codigo_CHK_Extra = @Codigo_CBO_CHK_Extra,
	        cbo_codigo_CHK_Triagem = @Codigo_CBO_CHK_Triagem,
	        cbo_codigo_CHK_Fichar = @Codigo_CBO_CHK_Fichar,
	        cbo_codigo_CHK_Retorno = @Codigo_CBO_CHK_Retorno,

		Codigo_Integracao      = @Codigo_Integracao,
		set_encaminhamento_interno = @set_encaminhamento_interno,
		setcli_operacional = @setcli_operacional,		
		procamb_codigo_RISCO_Pressao = @procambCod_risco_pressao, 
		cbo_codigo_RISCO_Pressao = @Codigo_CBO_risco_pressao,		
		procamb_codigo_RISCO_Glicemia = @procambCod_risco_glicemia,
		cbo_codigo_RISCO_Glicemia = @Codigo_CBO_risco_glicemia,
		procamb_codigo_RISCO_Consulta = @procambCod_risco_consulta,
		cbo_codigo_RISCO_Consulta = @Codigo_CBO_risco_consulta,
		procamb_codigo_inalacao = @procamb_codigo_inalacao, 
		cbo_codigo_inalacao = @cbo_codigo_inalacao, 
		procamb_codigo_administracao_medicamento = @procamb_codigo_administracao_medicamento, 
		cbo_codigo_administracao_medicamento = @cbo_codigo_administracao_medicamento,
		procamb_codigo_evolucao_urg_emer = @procamb_codigo_evolucao_urg_emer,
		cbo_codigo_evolucao_urg_emer = @cbo_codigo_evolucao_urg_emer,
		procamb_codigo_evolucao_internacao = @procamb_codigo_evolucao_internacao,
		cbo_codigo_evolucao_internacao = @cbo_codigo_evolucao_internacao

	WHERE  	Setcli_codigo      = @id_setor_clinica

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

   END

--------------------- Exclusao dos Dados ---------------------------------------
If @opcao = 7
   BEGIN		
	DECLARE @locatend_codigo_cid CHAR(4)

	select @id_setor_clinica = sc.setcli_codigo 
		from 	setor_clinica  sc, local_atendimento la
		where	sc.setcli_codigo = la.setcli_codigo 
		and	sc.setcli_codigo_local = @setcli_codigo
		and	la.unid_codigo = @unidade

	select @locatend_codigo_cid=locatend_codigo 
	from vwlocal_unidade 
	where unid_codigo=@unidade AND SET_CODIGO=@setcli_codigo

	DELETE FROM local_atendimento
	WHERE  	Setcli_codigo      = @id_setor_clinica

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	DELETE FROM setor_clinica
	WHERE  	Setcli_codigo      = @id_setor_clinica

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

	DELETE FROM Setor_Clinica_Cid 
	WHERE  	locatend_codigo      = @locatend_codigo_cid

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

   END

-------------------------------------------------------------------------------------------
if @opcao = 8
   BEGIN
	SELECT  PROCAMB_DESCRICAO 
		FROM PROCEDIMENTO_AMBULATORIAL  
		WHERE PROCAMB_CODIGO = @procambCod_SPA
   END

---Verifica se há referencia de Setor para exclusão ------------------------------------------
If @Opcao = 9 
   BEGIN

	--Se possui clinica para este setor
	select * from local_atendimento where set_codigo = @codigo
	and setcli_codigo is not null	
   end

If @Opcao = 10 
   BEGIN

	select @id_setor_clinica = sc.setcli_codigo 
		from 	setor_clinica  sc, local_atendimento la
		where	sc.setcli_codigo = la.setcli_codigo 
		and	sc.setcli_codigo_local = @setcli_codigo
		and	la.unid_codigo = @unidade


	DECLARE @CONTA INT
	DECLARE @CMD VARCHAR(1000)
	DECLARE @TAB VARCHAR(1000)
	DECLARE @CAM VARCHAR(1000)

	--VERIFICA AS TABELAS QUE POSSUEM O CAMPO....
	create table #temp (TABELA sysname, CAMPO sysname)
	
	insert into #temp
	select 	sysobjects.name TABELA ,upper(syscolumns.name) CAMPO
	from 	sysobjects, syscolumns 
	where 	upper(syscolumns.name) like '%locatend%'
	and 	sysobjects.id = syscolumns.id 
	and 	sysobjects.xtype = 'U'
	order by sysobjects.name

	--DESCARTA AS TABELAS QUE NAO DEVE VERIFICAR (POIS SERAO DELETADAS OU MANTIDAS)
	DELETE FROM #TEMP WHERE TABELA = 'enfermaria_historico'
	DELETE FROM #TEMP WHERE TABELA = 'leito_historico'
	DELETE FROM #TEMP WHERE TABELA = 'local_atendimento_historico'
	DELETE FROM #TEMP WHERE TABELA = 'MONITORACAO_LABORATORIO_MLIMA'
	DELETE FROM #TEMP WHERE TABELA = 'local_atendimento'
	
	SELECT @CONTA = COUNT(0) FROM #TEMP
	
	CREATE TABLE ##VALIDA_SETOR ( PODE_DELETAR VARCHAR(100) )

	WHILE @CONTA > 0 
	BEGIN

		SELECT 	TOP 1
			@TAB = TABELA,
			@CAM = CAMPO
		FROM #TEMP  ORDER BY TABELA, CAMPO
		--VERIFICA EM CADA TABELA SE HÁ REGISTROS
		SET @CMD = 'INSERT INTO ##VALIDA_SETOR SELECT TOP 1 '''  + @TAB + ''' FROM ' + @TAB + ' WHERE ' + @CAM + ' = ''' + @id_setor_clinica  + ''''
		EXEC (@CMD)

		IF @@ROWCOUNT > 0
		BEGIN
			--SE TIVER, NÃO PODE DELETAR
			SELECT 'NAO PODE'
			DROP TABLE ##VALIDA_SETOR
			DROP TABLE #TEMP
			RETURN
		END

		DELETE FROM #TEMP WHERE TABELA = @TAB AND CAMPO = @CAM
		SET @CONTA = @CONTA -1
	END
	drop table #temp

	--PODE DELETAR (NÃO HA REFERENCIAS)

	DROP TABLE ##VALIDA_SETOR


   END
---buca Grupo de Atendimento -----------------------------------------------------------------
if @opcao = 11
   begin
	if @grpAtendCod_eme is not null
	begin
	   select grpatend_codigo, grpatend_descricao from grupo_atendimento where grpatend_codigo= @grpAtendCod_eme
	end
   end 
---buca Grupo de Atendimento -----------------------------------------------------------------
if @opcao = 12
   begin
	if @tpAtendCod_eme is not null
	begin
	   select tpatend_codigo, tpatend_descricao from tipo_atendimento where tpatend_codigo= @tpAtendCod_eme
	end
   end 
---buca Grupo de Atendimento -----------------------------------------------------------------
if @opcao = 13
   begin
	if @atvProfCod_eme is not null
	begin
	   select atvprof_codigo, atvprof_descricao from atividade_profissional 
	   where atvprof_codigo= @atvProfCod_eme
	end
   end 
---busca SETOR_CLINICA pelo Locatend_codigo (da Local_Atendimento)
if @opcao = 14
begin
	select 	s.setCLI_codigo_local, s.setCLI_descricao, l.unid_codigo
	from 	setor_CLINICA s, local_atendimento l
	where 	s.setCLI_codigo = l.setCLI_codigo
	and	l.locatend_codigo = @codigo
end
---Valida existência de Leito em um Local de Internação
if @opcao = 15
begin
	select 	count(1)
	from 	setor_CLINICA s, local_atendimento l
	where 	s.setCLI_codigo = l.setCLI_codigo
	and	l.enf_codigo is not null
        and     s.setcli_codigo_local = @setcli_codigo
	and	l.unid_codigo = @unidade
end

---Carga para a TreeView de Acesso a Agenda
if @opcao = 16
begin
	select 		la.locatend_codigo, la.set_descricao, pr.prof_codigo, pr.prof_nome, s.setcli_codigo  
	from 		vwlocal_atendimento la, profissional_rede pr, profissional_lotacao pl, setor_clinica s
	where 		la.locatend_codigo = pl.locatend_codigo
	and 		pl.prof_codigo = pr.prof_codigo
	and		la.set_codigo = s.setcli_codigo  
	and 		pl.prof_ativo = 'S'
	and 		pl.prof_permite_agenda = 'S'
	and 		la.unid_codigo = @unidade
	order by	la.set_descricao,pr.prof_nome
end

-- busca setor_clinica pelo set_encaminha_classificacao_risco
if @opcao = 17
  begin
	SELECT 	L.locatend_codigo as locatend_codigo, 
		SC.setCLI_descricao as setcli_descricao
	FROM 	Local_Atendimento L, 
		unidade U, 
		setor_clinica SC
	WHERE 	L.unid_codigo =  U.unid_codigo 
	AND 	l.SETCLI_codigo = sc.SETCLI_codigo
	AND 	L.enf_codigo IS NULL    
	AND 	(SC.set_encaminha_classificacao_risco = 'S')
      AND U.unid_codigo = isnull(@unidade, U.unid_codigo )
      ORDER BY setcli_descricao
  end

-- verifica se o procedimento pode ser realizado para a idade do paciente selecionado

if @opcao = 18
begin

	SELECT	count(0)
	FROM	tb_procedimento
	WHERE   co_procedimento = @codproc
	AND	((vl_idade_minima <= (@idade*12) AND vl_idade_maxima >= (@idade*12)) OR vl_idade_maxima = 9999) 

	

end

---buca CBO -----------------------------------------------------------------
if @opcao = 19
   begin
	if @Codigo_CBO_EME is not null
	begin
	   select co_ocupacao as codigo, no_ocupacao as descricao from tb_ocupacao 
	   where co_ocupacao= @Codigo_CBO_EME
	end
   end 


---PESQUISA CLINICA-----------------------------------------------------------------
if @opcao = 20 
  begin
	SET @Sql = 'select V.locatend_descricao,V.locatend_codigo '  
	SET @Sql = @Sql  +  'from vwlocal_unidade V   '
	SET @Sql = @Sql  +  'where V.unid_codigo = ''' + @unidade + '''' + ' AND '

	if @codigo is not null
	   begin
	    Set @var1 = convert(varchar,@codigo)
	    Exec ksp_ParametroPesquisa @var1,'V.locatend_codigo',@tp_pesq, 't', @par output
	   end

	if @descricao is not null
	   begin
	    Set @var1 = @descricao
	    Exec ksp_ParametroPesquisa @var1,'V.locatend_descricao',@tp_pesq, 't', @par output
	   end

	Set @Sql = @Sql + @par + ' Order by V.locatend_descricao '	

	exec(@Sql)
	
	IF @@ERROR <> 0 SET @ERROR = @@ERROR 
  end	
---------- Insere na Tabela Setor_Clinica_Cid--------------------------------
if @opcao = 21
begin

	SET @S1  = NULL
	SET @S2  = NULL

	SELECT @ARRAY1   = @Codigo_Setor_Clinica
	SELECT @ARRAY2   = @Codigo_Setor_CID

	WHILE LEN(@ARRAY1) > 0
	BEGIN
		SELECT @S1  = LTRIM(SUBSTRING(@ARRAY1,  1,  CHARINDEX(@DELIMITADOR, @ARRAY1) - 1))
		SELECT @S2  = LTRIM(SUBSTRING(@ARRAY2,  1,  CHARINDEX(@DELIMITADOR, @ARRAY2) - 1))

		INSERT INTO Setor_Clinica_Cid 
		( 
		Locatend_codigo,
		Cid_codigo
		)   
		VALUES 
		(
		CONVERT(char(4),@S1),
		CONVERT(char(9),@S2)
		)
		
		SELECT @ARRAY1  = SUBSTRING(@ARRAY1, CHARINDEX(@DELIMITADOR, @ARRAY1) + 1, LEN(@ARRAY1))
		SELECT @ARRAY2  = SUBSTRING(@ARRAY2, CHARINDEX(@DELIMITADOR, @ARRAY2) + 1, LEN(@ARRAY2))
	END

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

END

---------- Altera na Tabela Setor_Clinica_Cid--------------------------------
if @opcao = 22
begin
	DECLARE @ULT_S1 CHAR(4)

	SET @S1     = NULL
	SET @S2     = NULL
	SET @ULT_S1 = NULL

	SELECT @ARRAY1   = @Codigo_Setor_Clinica
	SELECT @ARRAY2   = @Codigo_Setor_CID

	WHILE LEN(@ARRAY1) > 0
	BEGIN
		SELECT @S1  = LTRIM(SUBSTRING(@ARRAY1,  1,  CHARINDEX(@DELIMITADOR, @ARRAY1) - 1))
		SELECT @S2  = LTRIM(SUBSTRING(@ARRAY2,  1,  CHARINDEX(@DELIMITADOR, @ARRAY2) - 1))
		
		IF (@ULT_S1 <> @S1)
		BEGIN
			DELETE FROM Setor_Clinica_Cid 
			WHERE  	locatend_codigo  = @S1
			SET @ULT_S1=@S1
		END

		INSERT INTO Setor_Clinica_Cid 
		( 
		Locatend_codigo,
		Cid_codigo
		)   
		VALUES 
		(
		CONVERT(char(4),@S1),
		CONVERT(char(9),@S2)
		)
		
		SELECT @ARRAY1  = SUBSTRING(@ARRAY1, CHARINDEX(@DELIMITADOR, @ARRAY1) + 1, LEN(@ARRAY1))
		SELECT @ARRAY2  = SUBSTRING(@ARRAY2, CHARINDEX(@DELIMITADOR, @ARRAY2) + 1, LEN(@ARRAY2))
	END

	IF @@ERROR <> 0 SET @ERROR = @@ERROR

END

---Lista Setor_Clinica_CID -----------------------------------------------------------------
if @opcao = 24
begin
   select V.locatend_descricao,S.Cid_codigo,S.locatend_codigo 
   from Setor_Clinica_Cid S, vwlocal_unidade V
   where S.locatend_codigo = V.locatend_codigo and
	 S.Locatend_codigo = @setcli_codigo
end


----Verifica Leito Operacional --------------------------------------------------------------

if @opcao = 25 --PESQUISA SETOR_CLINICA
BEGIN
	SELECT *	
    FROM setor s 
		INNER JOIN local_atendimento l  ON s.set_codigo = l.set_codigo 
		INNER JOIN divisao d  ON l.div_codigo = d.div_codigo 
		INNER JOIN unidade u  ON l.unid_codigo = u.unid_codigo 
		INNER JOIN setor_clinica sc ON l.setcli_codigo = sc.setcli_codigo 
		INNER JOIN enfermaria e on (e.enf_codigo = l.enf_codigo)
    WHERE u.unid_codigo = @unidade
	AND sc.setcli_codigo_local = @setcli_codigo
	AND e.enf_operacional = 'S' or l.enf_codigo is null
END	
IF @opcao = 26 -- RETORNA SETOR CLINICA
BEGIN
	select setcli_codigo from local_atendimento where locatend_codigo=@locatend_codigo
END
IF @opcao = 27
BEGIN
		SELECT distinct sc.setCli_descricao 
		FROM setor s 
			INNER JOIN local_atendimento l  ON s.set_codigo = l.set_codigo 
			INNER JOIN divisao d  ON l.div_codigo = d.div_codigo 
			INNER JOIN unidade u  ON l.unid_codigo = u.unid_codigo 
			INNER JOIN setor_clinica sc ON l.setcli_codigo = sc.setcli_codigo 
		WHERE u.unid_codigo = @unidade
END
----------------------------------------------------------------------------------------------
If (@ERROR <> 0)
   BEGIN
	Select @sql = 'ERRO - Tabela de Setor. Opção : ' + convert(varchar,@opcao)
        RAISERROR(@sql,1,1)
         
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
PRINT N'Altering [dbo].[ksp_relatorio_exame_fisico_admitir_leito]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_exame_fisico_admitir_leito]
@intercodigo char(12) = null, @id uniqueidentifier = null

AS

SET NOCOUNT ON
BEGIN
IF (@id is null)
begin
select isnull(i.spa_codigo,i.emer_codigo) as boletim,
		(e.ENF_CODIGO + l.lei_codigo) as ENF_CODIGO , 
		l.set_descricao,
		p.pac_nome, 
		p.pac_nascimento, 
		p.pac_idade, 
		case 
			when p.pac_sexo = 'M' then 'Masculino' 
			when p.pac_sexo = 'F' then 'Feminino' 
			else null 
		end as pac_sexo,
		isnull(em.emer_nome_informante,pa.spa_nome_informante) as nome_informate,
		pc.paccns_ocupacao,
	   ncal.descricao as NivelConsciencia,
	   eeal.descricao as EstadoEmocional,
	   pal.descricao as Pupilas,
	   mal.descricao as Mucosas,
	   efal.MucosasObs,
	   aal.descricao as Alimentacao,
	   ral.descricao as Respiracao,
	   case
		when efal.SuportVentiONasal is not null or efal.SuportVentiMcNbz != null then 'O² Nasal ' + isnull(cast(efal.SuportVentiONasal as varchar),'') + '/Min. McNbz ' + isnull(cast(efal.SuportVentiMcNbz as varchar), '') + '/Min.'		
		when efal.SuportVentiNDiasTranque is not null then  'Tranqueostomia'
		when efal.SuportVentiNDiasProtese is not null then 'Prótese Ventilatório'
		else null
	   end as SuportVent,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiNDiasTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiNDiasProtese
		else null
	   end as SuportVentiNDias,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiSecrecaoTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiSecrecaoProtese
		else null
	   end as SuportVentiSecresao,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiObsTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiObsProtese
		else null
	   end as SuportVentiObs,
	   efal.SuportVentiMcNbz,
	   efal.SuportVentiNDiasTranque,
	   efal.SuportVentiSecrecaoTranque,
	   efal.SuportVentiObsTranque,
	   efal.SuportVentiNDiasProtese,
	   efal.SuportVentiSecrecaoProtese,
	   efal.SuportVentiObsProtese,
	   case when efal.MonitorizacaoCadiaca = 'S' then 'Cardíaca/'
			else ''
	   end +
	   case when efal.MonitorizacaoPni = 'S' then 'PNI/'
			else ''
	   end +
	   case when efal.MonitorizacaoOximetria = 'S' then 'Oximetria de pulso/'
			else ''
	   end +
	   case
		when efal.MonitorizacaoTermica = 'S' then 'Térmica/'
		else ''
	   end as Monitorizacao,
	   efal.AcesVenosoData,
	   case when efal.PerifericoJelcoN is not null then 'Periférico' else '' end PerifericoJelcoNDescricao ,
	   efal.PerifericoJelcoN,
	   case when efal.ProfundoOpcao is not null then 'Profundo' else '' end ProfundoDescricao ,
	   case when efal.profundoOpcao = 1 then 'Duplo Lúmen'
			when efal.profundoOpcao = 2 then 'Intracath'
	   else ''
	   end as ProfundoOpcoes,
	   case
		when efal.EdemaMSD = 'S' then 'MSD/'
		else ''
	   end +
	   case
		when efal.EdemaMSE = 'S' then 'MSE/'
		else ''
	   end +
	   case
		when efal.EdemaMID = 'S' then 'MID/'
		else ''
	   end +
	   case
		when efal.EdemaMIE = 'S' then 'MIE/'
		else ''
	   end +
	   case
		when efal.EdemaAnsarca = 'S' then 'Anasarca/'
		else ''
	   end as Edema,
	   case
		when efal.EdemaDrenando = 'S' then 'Sim'
		when efal.EdemaDrenando = 'N' then 'Nao'
		else null
	   end as EdemaDrenado,
	   peal.descricao as pele,
	   case when efal.PeleLesao = 99 then PeleLesaoOutros
	   else
		plal.descricao 
	   end as pelelesao,
	   efal.PeleUlceraLocal,
	   efal.PeleUlceraEstagio,
	   efal.PeleUlceraTipoTecido,
	   efal.PeleUlceraBordas,
	   efal.PeleUlceraCicatrizacao,
	   case
		when efal.AbdomePlano = 'S' then 'Plano/ '
		else ''
	   end +
	   case
		when efal.abdomeescado = 'S' then 'Escavado/ '
		else ''
	   end +
	   case
		when efal.AbdomeGloboso = 'S' then 'Globoso/ '
		else ''
	   end +
	   case
		when efal.AbdomeDistendido = 'S' then 'Distendido/ '
		else ''
	   end +
	   case
		when efal.AbdomeFlacido = 'S' then 'Flácido/ '
		else ''
	   end +
	   case
		when efal.AbdomeDoloroso = 'S' then 'Doloroso/ '
		else ''
	   end +
	   case
		when efal.AbdomeAscistico = 'S' then 'Ascístico/ '
		else ''
	   end +
	   case
		when efal.AbdomeHernia = 'S' then 'Hérnia/ '
		else ''
	   end +
	   case
		when efal.AbdomePeristalse = 'S' then 'Peristalse/ '
		else ''
	   end+
	   case
		when efal.AbdomeAusente = 'S' then 'Ausente/ '
		else ''
	   end +
	   case
		when efal.AbdomePresente = 'S' then 'Presente/ '
		else ''
	   end +
	   case
		when efal.AbdomeAumentada = 'S' then 'Aumentada/ '
		else ''
	   end +
	   case
		when efal.AbdomeDiminuida = 'S' then 'Diminuída/ '
		else ''
	   end as Abdome,
	   case
		when efal.OrgGeniSemAlteracao = 'S' then 'Sem Alterações/ '
		else ''
	   end +
	   case
		when efal.OrgGeniFimose = 'S' then 'Fimose/ '
		else ''
	   end +
	   case
		when efal.OrgGeniPrurido = 'S' then 'Prurido/ '
		else ''
	   end +
	   case
		when efal.OrgGeniEdemaVulvar = 'S' then 'Edema de Escroto Vulvar/ '
		else ''
	   end +
	   case
		when efal.OrgGeniLeucorreia = 'S' then 'Leucorréia/ '
		else ''
	   end as OrgaosGenitais,
	   efal.OrgGeniOutros,
	   case
		when efal.ElimVesAnuria = 'S' then 'Anúria/ '
		else ''
	   end +
	   case
		when efal.ElimVesPresente = 'S' then 'Presente/ '
		else ''
	   end +
	   case
		when efal.ElimVesFralda = 'S' then 'Fralda/ '
		else ''
	   end +
	   case
		when efal.ElimVesLivre = 'S' then 'Livre/ '
		else ''
	   end as ElimVesical,
	   case
		when efal.ElimVesCateterVisical = 1 then 'Alívio'
		when efal.ElimVesCateterVisical = 2 then 'Demora'
		when efal.ElimVesCateterVisical = 3 then 'Irrigação'
		when efal.ElimVesCateterVisical = 4 then 'Jontex'
		else null
	   end as ElimVesCateterVisical,
	   case
		when efal.ElimVesAspecClaro = 'S' then 'Claro/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecTurvo = 'S' then 'Turvo/'
		else ''
	   end +
	   case
	    when efal.ElimVesAspecColuria = 'S' then 'Colúria/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecGrumus = 'S' then 'Grumus/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecHematuria = 'S' then 'Hematúria/'
		else ''
	   end as ElimVesAspec,
	   case
		when efal.ElimInstAusente = 'S' then 'Ausente/'
		else ''
	   end +
	   case
		when efal.ElimInstPresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efal.ElimInstFralda = 'S' then 'Fralda/'
		else ''
	   end +
	   case
		when efal.ElimInstLivre = 'S' then 'Livre/'
		else ''
	   end +
	   case
		when efal.ElimInstFecaloma = 'S' then 'Fecaloma/'
		else ''
	   end +
	   case
		when efal.ElimInstMelena = 'S' then 'Melena/'
		else ''
	   end as ElimInst,
	   case
		when efal.ElimInstAspecLiquida = 'S' then 'Líquida/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecPastosa = 'S' then 'Pastosa/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecMoldada = 'S' then 'Moldada/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecPresencaf1 = 'S' then 'Presença de F1/'
		else ''
	   end as ElimInstAspe,
	   pr.prof_nome,
	   efal.DataInclusao
into #temp
from ExameFisicoAdmitirLeito efal
inner join Internacao i on efal.InterCodigo = i.inter_codigo
inner join Paciente p on p.pac_codigo = i.pac_codigo
inner join VWLEITO l on i.lei_codigo = l.lei_codigo and i.locatend_leito = l.locatend_codigo
inner join VWENFERMARIA e on e.ENF_CODIGO = l.enf_codigo 
inner join PROFISSIONAL_REDE pr on pr.prof_codigo = efal.profcodigo
left join Pronto_Atendimento pa on pa.spa_codigo = i.spa_codigo
left join Emergencia em on em.emer_codigo = i.emer_codigo 
left join Paciente_CNS pc on pc.pac_codigo = p.pac_codigo
left join nivelconscienciaadimitirleito ncal on ncal.id = efal.nivelconsciencia
left join estadoemocionaladimitirleito eeal on eeal.id = efal.EstadoEmocional
left join pupilasadimitirleito pal on pal.id = efal.Pupilas
left join mucosasadimitirleito mal on mal.id = efal.Mucosas
left join alimentacaoadimitirleito aal on aal.id = efal.Alimentacao
left join respiracaoadimitirleito ral on ral.id = efal.Respiracao
left join peleadimitirleito peal on peal.id = efal.Pele
left join pelelesaoadimitirleito plal on plal.id = efal.PeleLesao

where efal.intercodigo = @intercodigo
end
else 
begin 
		select  isnull(i.spa_codigo,i.emer_codigo) as boletim,
		(e.ENF_CODIGO + l.lei_codigo) as ENF_CODIGO , 
		l.set_descricao,
		p.pac_nome, 
		p.pac_nascimento, 
		p.pac_idade, 
		case 
			when p.pac_sexo = 'M' then 'Masculino' 
			when p.pac_sexo = 'F' then 'Feminino' 
			else null 
		end as pac_sexo,
		isnull(em.emer_nome_informante,pa.spa_nome_informante) as nome_informate,
		pc.paccns_ocupacao,
	   ncal.descricao as NivelConsciencia,
	   eeal.descricao as EstadoEmocional,
	   pal.descricao as Pupilas,
	   mal.descricao as Mucosas,
	   efal.MucosasObs,
	   aal.descricao as Alimentacao,
	   ral.descricao as Respiracao,
	   case
		when efal.SuportVentiONasal is not null or efal.SuportVentiMcNbz != null then 'Nasal ' + isnull(cast(efal.SuportVentiONasal as varchar),'') + '/Min. McNbz ' + isnull(cast(efal.SuportVentiMcNbz as varchar), '') + '/Min.'		
		when efal.SuportVentiNDiasTranque is not null then  'Tranqueostomia'
		when efal.SuportVentiNDiasProtese is not null then 'Prótese Ventilatório'
		else null
	   end as SuportVent,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiNDiasTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiNDiasProtese
		else null
	   end as SuportVentiNDias,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiSecrecaoTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiSecrecaoProtese
		else null
	   end as SuportVentiSecresao,
	   case
		when efal.SuportVentiNDiasTranque is not null then  efal.SuportVentiObsTranque
		when efal.SuportVentiNDiasProtese is not null then efal.SuportVentiObsProtese
		else null
	   end as SuportVentiObs,
	   efal.SuportVentiMcNbz,
	   efal.SuportVentiNDiasTranque,
	   efal.SuportVentiSecrecaoTranque,
	   efal.SuportVentiObsTranque,
	   efal.SuportVentiNDiasProtese,
	   efal.SuportVentiSecrecaoProtese,
	   efal.SuportVentiObsProtese,
	   case when efal.MonitorizacaoCadiaca = 'S' then 'Cardíaca/'
			else ''
	   end +
	   case when efal.MonitorizacaoPni = 'S' then 'PNI/'
			else ''
	   end +
	   case when efal.MonitorizacaoOximetria = 'S' then 'Oximetria de pulso/'
			else ''
	   end +
	   case
		when efal.MonitorizacaoTermica = 'S' then 'Térmica/'
		else ''
	   end as Monitorizacao,
	   efal.AcesVenosoData,
	   case when efal.PerifericoJelcoN is not null then 'Periférico' else '' end PerifericoJelcoNDescricao ,
	   efal.PerifericoJelcoN,
	   case when efal.ProfundoOpcao is not null then 'Profundo' else '' end ProfundoDescricao ,
	   case when efal.profundoOpcao = 1 then 'Duplo Lúmen'
			when efal.profundoOpcao = 2 then 'Itracath'
	   else ''
	   end as ProfundoOpcoes,
	   case
		when efal.EdemaMSD = 'S' then 'MSD/'
		else ''
	   end +
	   case
		when efal.EdemaMSE = 'S' then 'MSE/'
		else ''
	   end +
	   case
		when efal.EdemaMID = 'S' then 'MID/'
		else ''
	   end +
	   case
		when efal.EdemaMIE = 'S' then 'MIE/'
		else ''
	   end +
	   case
		when efal.EdemaAnsarca = 'S' then 'Ansarca/'
		else ''
	   end as Edema,
	   case
		when efal.EdemaDrenando = 'S' then 'Sim'
		when efal.EdemaDrenando = 'N' then 'Nao'
		else null
	   end as EdemaDrenado,
	   peal.descricao as pele,
	   case when efal.PeleLesao = 99 then PeleLesaoOutros
	   else
		plal.descricao 
	   end as pelelesao,
	   efal.PeleUlceraLocal,
	   efal.PeleUlceraEstagio,
	   efal.PeleUlceraTipoTecido,
	   efal.PeleUlceraBordas,
	   efal.PeleUlceraCicatrizacao,
	   case
		when efal.AbdomePlano = 'S' then 'Plano/'
		else ''
	   end +
	   case
		when efal.abdomeescado = 'S' then 'Escado/'
		else ''
	   end +
	   case
		when efal.AbdomeGloboso = 'S' then 'Globoso/'
		else ''
	   end +
	   case
		when efal.AbdomeDistendido = 'S' then 'Distendido/'
		else ''
	   end +
	   case
		when efal.AbdomeFlacido = 'S' then 'Flácido/'
		else ''
	   end +
	   case
		when efal.AbdomeDoloroso = 'S' then 'Doloroso/'
		else ''
	   end +
	   case
		when efal.AbdomeAscistico = 'S' then 'Ascístico/'
		else ''
	   end +
	   case
		when efal.AbdomeHernia = 'S' then 'Hérnia/'
		else ''
	   end +
	   case
		when efal.AbdomePeristalse = 'S' then 'Peristalse/'
		else ''
	   end+
	   case
		when efal.AbdomeAusente = 'S' then 'Ausente/'
		else ''
	   end +
	   case
		when efal.AbdomePresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efal.AbdomeAumentada = 'S' then 'Aumentada/'
		else ''
	   end as Abdome,
	   case
		when efal.OrgGeniSemAlteracao = 'S' then 'Sem Alterações/'
		else ''
	   end +
	   case
		when efal.OrgGeniFimose = 'S' then 'Fimose/'
		else ''
	   end +
	   case
		when efal.OrgGeniPrurido = 'S' then 'Prurido/'
		else ''
	   end +
	   case
		when efal.OrgGeniEdemaVulvar = 'S' then 'Edema de Escroto Vulvar/'
		else ''
	   end +
	   case
		when efal.OrgGeniLeucorreia = 'S' then 'Leucorréia/'
		else ''
	   end as OrgaosGenitais,
	   efal.OrgGeniOutros,
	   case
		when efal.ElimVesAnuria = 'S' then 'Anúria/'
		else ''
	   end +
	   case
		when efal.ElimVesPresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efal.ElimVesFralda = 'S' then 'Fralda/'
		else ''
	   end +
	   case
		when efal.ElimVesLivre = 'S' then 'Livre/'
		else ''
	   end as ElimVesical,
	   case
		when efal.ElimVesCateterVisical = 1 then 'Alívio'
		when efal.ElimVesCateterVisical = 2 then 'Demora'
		when efal.ElimVesCateterVisical = 3 then 'Irrigação'
		when efal.ElimVesCateterVisical = 4 then 'Jontex'
		else null
	   end as ElimVesCateterVisical,
	   case
		when efal.ElimVesAspecClaro = 'S' then 'Claro/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecTurvo = 'S' then 'Turvo/'
		else ''
	   end +
	   case
	    when efal.ElimVesAspecColuria = 'S' then 'Colúria/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecGrumus = 'S' then 'Grumus/'
		else ''
	   end +
	   case
		when efal.ElimVesAspecHematuria = 'S' then 'Hematúria/'
		else ''
	   end as ElimVesAspec,
	   case
		when efal.ElimInstAusente = 'S' then 'Ausente/'
		else ''
	   end +
	   case
		when efal.ElimInstPresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efal.ElimInstFralda = 'S' then 'Fralda/'
		else ''
	   end +
	   case
		when efal.ElimInstLivre = 'S' then 'Livre/'
		else ''
	   end +
	   case
		when efal.ElimInstFecaloma = 'S' then 'Fecaloma/'
		else ''
	   end +
	   case
		when efal.ElimInstMelena = 'S' then 'Melena/'
		else ''
	   end as ElimInst,
	   case
		when efal.ElimInstAspecLiquida = 'S' then 'Líquida/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecPastosa = 'S' then 'Pastosa/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecMoldada = 'S' then 'Moldada/'
		else ''
	   end +
	   case
		when efal.ElimInstAspecPresencaf1 = 'S' then 'Presença de F1/'
		else ''
	   end as ElimInstAspe,
	   pr.prof_nome,
	   efal.DataInclusao
	   into #temp1
from ExameFisicoAdmitirLeito efal
inner join PROFISSIONAL_REDE pr on pr.prof_codigo = efal.profcodigo
left join pronto_atendimento pa on efal.spa_codigo = pa.spa_codigo
left join emergencia em on em.emer_codigo = efal.emer_codigo
left join Internacao i on efal.InterCodigo = i.inter_codigo or efal.spa_codigo = i.emer_codigo or efal.spa_codigo = i.spa_codigo
inner join Paciente p on p.pac_codigo = isnull(i.pac_codigo, isnull(pa.pac_codigo, em.pac_codigo))
left join VWLEITO l on i.lei_codigo = l.lei_codigo and i.locatend_leito = l.locatend_codigo
left join VWENFERMARIA e on e.ENF_CODIGO = l.enf_codigo 
left join Paciente_CNS pc on pc.pac_codigo = p.pac_codigo
left join nivelconscienciaadimitirleito ncal on ncal.id = efal.nivelconsciencia
left join estadoemocionaladimitirleito eeal on eeal.id = efal.EstadoEmocional
left join pupilasadimitirleito pal on pal.id = efal.Pupilas
left join mucosasadimitirleito mal on mal.id = efal.Mucosas
left join alimentacaoadimitirleito aal on aal.id = efal.Alimentacao
left join respiracaoadimitirleito ral on ral.id = efal.Respiracao
left join peleadimitirleito peal on peal.id = efal.Pele
left join pelelesaoadimitirleito plal on plal.id = efal.PeleLesao

where efal.id = @id
union all
select  isnull(i.spa_codigo,i.emer_codigo) as boletim,
		(e.ENF_CODIGO + l.lei_codigo) as ENF_CODIGO , 
		l.set_descricao,
		p.pac_nome, 
		p.pac_nascimento, 
		p.pac_idade, 
		case 
			when p.pac_sexo = 'M' then 'Masculino' 
			when p.pac_sexo = 'F' then 'Feminino' 
			else null 
		end as pac_sexo,
		isnull(em.emer_nome_informante,pa.spa_nome_informante) as nome_informate,
		pc.paccns_ocupacao,
	   ncal.descricao as NivelConsciencia,
	   eeal.descricao as EstadoEmocional,
	   pal.descricao as Pupilas,
	   mal.descricao as Mucosas,
	   efalh.MucosasObs,
	   aal.descricao as Alimentacao,
	   ral.descricao as Respiracao,
	   case
		when efalh.SuportVentiONasal is not null or efalh.SuportVentiMcNbz != null then 'Nasal ' + isnull(cast(efalh.SuportVentiONasal as varchar),'') + '/Min. McNbz ' + isnull(cast(efalh.SuportVentiMcNbz as varchar), '') + '/Min.'		
		when efalh.SuportVentiNDiasTranque is not null then  'Tranqueostomia'
		when efalh.SuportVentiNDiasProtese is not null then 'Prótese Ventilatório'
		else null
	   end as SuportVent,
	   case
		when efalh.SuportVentiNDiasTranque is not null then  efalh.SuportVentiNDiasTranque
		when efalh.SuportVentiNDiasProtese is not null then efalh.SuportVentiNDiasProtese
		else null
	   end as SuportVentiNDias,
	   case
		when efalh.SuportVentiNDiasTranque is not null then  efalh.SuportVentiSecrecaoTranque
		when efalh.SuportVentiNDiasProtese is not null then efalh.SuportVentiSecrecaoProtese
		else null
	   end as SuportVentiSecresao,
	   case
		when efalh.SuportVentiNDiasTranque is not null then  efalh.SuportVentiObsTranque
		when efalh.SuportVentiNDiasProtese is not null then efalh.SuportVentiObsProtese
		else null
	   end as SuportVentiObs,
	   efalh.SuportVentiMcNbz,
	   efalh.SuportVentiNDiasTranque,
	   efalh.SuportVentiSecrecaoTranque,
	   efalh.SuportVentiObsTranque,
	   efalh.SuportVentiNDiasProtese,
	   efalh.SuportVentiSecrecaoProtese,
	   efalh.SuportVentiObsProtese,
	   case when efalh.MonitorizacaoCadiaca = 'S' then 'Cardíaca/'
			else ''
	   end +
	   case when efalh.MonitorizacaoPni = 'S' then 'PNI/'
			else ''
	   end +
	   case when efalh.MonitorizacaoOximetria = 'S' then 'Oximetria de pulso/'
			else ''
	   end +
	   case
		when efalh.MonitorizacaoTermica = 'S' then 'Térmica/'
		else ''
	   end as Monitorizacao,
	   efalh.AcesVenosoData,
	   case when efalh.PerifericoJelcoN is not null then 'Periférico' else '' end PerifericoJelcoNDescricao ,
	   efalh.PerifericoJelcoN,
	   case when efalh.ProfundoOpcao is not null then 'Profundo' else '' end ProfundoDescricao ,
	   case when efalh.profundoOpcao = 1 then 'Duplo Lúmen'
			when efalh.profundoOpcao = 2 then 'Itracath'
	   else ''
	   end as ProfundoOpcoes,
	   case
		when efalh.EdemaMSD = 'S' then 'MSD/'
		else ''
	   end +
	   case
		when efalh.EdemaMSE = 'S' then 'MSE/'
		else ''
	   end +
	   case
		when efalh.EdemaMID = 'S' then 'MID/'
		else ''
	   end +
	   case
		when efalh.EdemaMIE = 'S' then 'MIE/'
		else ''
	   end +
	   case
		when efalh.EdemaAnsarca = 'S' then 'Ansarca/'
		else ''
	   end as Edema,
	   case
		when efalh.EdemaDrenando = 'S' then 'Sim'
		when efalh.EdemaDrenando = 'N' then 'Nao'
		else null
	   end as EdemaDrenado,
	   peal.descricao as pele,
	   case when efalh.PeleLesao = 99 then PeleLesaoOutros
	   else
		plal.descricao 
	   end as pelelesao,
	   efalh.PeleUlceraLocal,
	   efalh.PeleUlceraEstagio,
	   efalh.PeleUlceraTipoTecido,
	   efalh.PeleUlceraBordas,
	   efalh.PeleUlceraCicatrizacao,
	   case
		when efalh.AbdomePlano = 'S' then 'Plano/'
		else ''
	   end +
	   case
		when efalh.abdomeescado = 'S' then 'Escado/'
		else ''
	   end +
	   case
		when efalh.AbdomeGloboso = 'S' then 'Globoso/'
		else ''
	   end +
	   case
		when efalh.AbdomeDistendido = 'S' then 'Distendido/'
		else ''
	   end +
	   case
		when efalh.AbdomeFlacido = 'S' then 'Flácido/'
		else ''
	   end +
	   case
		when efalh.AbdomeDoloroso = 'S' then 'Doloroso/'
		else ''
	   end +
	   case
		when efalh.AbdomeAscistico = 'S' then 'Ascístico/'
		else ''
	   end +
	   case
		when efalh.AbdomeHernia = 'S' then 'Hérnia/'
		else ''
	   end +
	   case
		when efalh.AbdomePeristalse = 'S' then 'Peristalse/'
		else ''
	   end+
	   case
		when efalh.AbdomeAusente = 'S' then 'Ausente/'
		else ''
	   end +
	   case
		when efalh.AbdomePresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efalh.AbdomeAumentada = 'S' then 'Aumentada/'
		else ''
	   end as Abdome,
	   case
		when efalh.OrgGeniSemAlteracao = 'S' then 'Sem Alterações/'
		else ''
	   end +
	   case
		when efalh.OrgGeniFimose = 'S' then 'Fimose/'
		else ''
	   end +
	   case
		when efalh.OrgGeniPrurido = 'S' then 'Prurido/'
		else ''
	   end +
	   case
		when efalh.OrgGeniEdemaVulvar = 'S' then 'Edema de Escroto Vulvar/'
		else ''
	   end +
	   case
		when efalh.OrgGeniLeucorreia = 'S' then 'Leucorréia/'
		else ''
	   end as OrgaosGenitais,
	   efalh.OrgGeniOutros,
	   case
		when efalh.ElimVesAnuria = 'S' then 'Anúria/'
		else ''
	   end +
	   case
		when efalh.ElimVesPresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efalh.ElimVesFralda = 'S' then 'Fralda/'
		else ''
	   end +
	   case
		when efalh.ElimVesLivre = 'S' then 'Livre/'
		else ''
	   end as ElimVesical,
	   case
		when efalh.ElimVesCateterVisical = 1 then 'Alívio'
		when efalh.ElimVesCateterVisical = 2 then 'Demora'
		when efalh.ElimVesCateterVisical = 3 then 'Irrigação'
		when efalh.ElimVesCateterVisical = 4 then 'Jontex'
		else null
	   end as ElimVesCateterVisical,
	   case
		when efalh.ElimVesAspecClaro = 'S' then 'Claro/'
		else ''
	   end +
	   case
		when efalh.ElimVesAspecTurvo = 'S' then 'Turvo/'
		else ''
	   end +
	   case
	    when efalh.ElimVesAspecColuria = 'S' then 'Colúria/'
		else ''
	   end +
	   case
		when efalh.ElimVesAspecGrumus = 'S' then 'Grumus/'
		else ''
	   end +
	   case
		when efalh.ElimVesAspecHematuria = 'S' then 'Hematúria/'
		else ''
	   end as ElimVesAspec,
	   case
		when efalh.ElimInstAusente = 'S' then 'Ausente/'
		else ''
	   end +
	   case
		when efalh.ElimInstPresente = 'S' then 'Presente/'
		else ''
	   end +
	   case
		when efalh.ElimInstFralda = 'S' then 'Fralda/'
		else ''
	   end +
	   case
		when efalh.ElimInstLivre = 'S' then 'Livre/'
		else ''
	   end +
	   case
		when efalh.ElimInstFecaloma = 'S' then 'Fecaloma/'
		else ''
	   end +
	   case
		when efalh.ElimInstMelena = 'S' then 'Melena/'
		else ''
	   end as ElimInst,
	   case
		when efalh.ElimInstAspecLiquida = 'S' then 'Líquida/'
		else ''
	   end +
	   case
		when efalh.ElimInstAspecPastosa = 'S' then 'Pastosa/'
		else ''
	   end +
	   case
		when efalh.ElimInstAspecMoldada = 'S' then 'Moldada/'
		else ''
	   end +
	   case
		when efalh.ElimInstAspecPresencaf1 = 'S' then 'Presença de F1/'
		else ''
	   end as ElimInstAspe,
	   pr.prof_nome,
	   efalh.DataInclusao
from ExameFisicoAdmitirLeitohistorico efalh
inner join PROFISSIONAL_REDE pr on pr.prof_codigo = efalh.profcodigo
left join pronto_atendimento pa on efalh.spa_codigo = pa.spa_codigo
left join emergencia em on em.emer_codigo = efalh.emer_codigo
left join Internacao i on efalh.InterCodigo = i.inter_codigo or efalh.spa_codigo = i.emer_codigo or efalh.spa_codigo = i.spa_codigo
inner join Paciente p on p.pac_codigo = isnull(i.pac_codigo, isnull(pa.pac_codigo, em.pac_codigo))
left join VWLEITO l on i.lei_codigo = l.lei_codigo and i.locatend_leito = l.locatend_codigo
left join VWENFERMARIA e on e.ENF_CODIGO = l.enf_codigo 
left join Paciente_CNS pc on pc.pac_codigo = p.pac_codigo
left join nivelconscienciaadimitirleito ncal on ncal.id = efalh.nivelconsciencia
left join estadoemocionaladimitirleito eeal on eeal.id = efalh.EstadoEmocional
left join pupilasadimitirleito pal on pal.id = efalh.Pupilas
left join mucosasadimitirleito mal on mal.id = efalh.Mucosas
left join alimentacaoadimitirleito aal on aal.id = efalh.Alimentacao
left join respiracaoadimitirleito ral on ral.id = efalh.Respiracao
left join peleadimitirleito peal on peal.id = efalh.Pele
left join pelelesaoadimitirleito plal on plal.id = efalh.PeleLesao

where efalh.id = @id
end
	if (@id is null)
	begin 
	SELECT	boletim, ENF_CODIGO, set_descricao, pac_nome, pac_nascimento, pac_idade, pac_sexo, nome_informate, paccns_ocupacao, NivelConsciencia, EstadoEmocional,
			Pupilas, Mucosas, MucosasObs, Alimentacao, Respiracao, SuportVent, SuportVentiNDias, SuportVentiSecresao, SuportVentiObs, SuportVentiMcNbz, SuportVentiNDiasTranque,
			SuportVentiSecrecaoTranque, SuportVentiObsTranque, SuportVentiNDiasProtese, SuportVentiSecrecaoProtese, SuportVentiObsProtese,
			case when Monitorizacao!= '' then left(Monitorizacao,(len(Monitorizacao)-1)) else '' end as Monitorizacao ,
			CONVERT(varchar(10), AcesVenosoData, 103) as AcesVenosoData,
			PerifericoJelcoNDescricao, PerifericoJelcoN, ProfundoDescricao, ProfundoOpcoes,
			case when Edema != '' then left(Edema,(len(Edema)-1)) else '' end as Edema, EdemaDrenado, pele, pelelesao, PeleUlceraLocal, PeleUlceraEstagio, 
			PeleUlceraTipoTecido, PeleUlceraBordas, PeleUlceraCicatrizacao, 
			case when abdome  != '' then left(Abdome,(len(Abdome)-1)) else '' end as Abdome, 
			case when orgaosGenitais  != '' then left(OrgaosGenitais,(len(OrgaosGenitais)-1)) else '' end as OrgaosGenitais, 
			OrgGeniOutros, 
			case when ElimVesical  != '' then left(ElimVesical,(len(ElimVesical)-1)) else '' end as ElimVesical, ElimVesCateterVisical, 
			case when ElimVesAspec != '' then left(ElimVesAspec,(len(ElimVesAspec)-1)) else '' end as ElimVesAspec,
			case when ElimInst != '' then left(ElimInst,(len(ElimInst)-1)) else '' end as ElimInst, 
			case when eliminstaspe != '' then left(ElimInstAspe,(len(ElimInstAspe)-1)) else '' end as ElimInstAspe, prof_nome, DataInclusao
	from #temp
	end 
	else
	Begin
		SELECT	boletim, ENF_CODIGO, set_descricao, pac_nome, pac_nascimento, pac_idade, pac_sexo, nome_informate, paccns_ocupacao, NivelConsciencia, EstadoEmocional,
			Pupilas, Mucosas, MucosasObs, Alimentacao, Respiracao, SuportVent, SuportVentiNDias, SuportVentiSecresao, SuportVentiObs, SuportVentiMcNbz, SuportVentiNDiasTranque,
			SuportVentiSecrecaoTranque, SuportVentiObsTranque, SuportVentiNDiasProtese, SuportVentiSecrecaoProtese, SuportVentiObsProtese,
			case when Monitorizacao!= '' then left(Monitorizacao,(len(Monitorizacao)-1)) else '' end as Monitorizacao ,
			CONVERT(varchar(10), AcesVenosoData, 103) as AcesVenosoData,
			PerifericoJelcoNDescricao, PerifericoJelcoN, ProfundoDescricao, ProfundoOpcoes,
			case when Edema != '' then left(Edema,(len(Edema)-1)) else '' end as Edema, EdemaDrenado, pele, pelelesao, PeleUlceraLocal, PeleUlceraEstagio, 
			PeleUlceraTipoTecido, PeleUlceraBordas, PeleUlceraCicatrizacao, 
			case when abdome  != '' then left(Abdome,(len(Abdome)-1)) else '' end as Abdome, 
			case when orgaosGenitais  != '' then left(OrgaosGenitais,(len(OrgaosGenitais)-1)) else '' end as OrgaosGenitais, 
			OrgGeniOutros, 
			case when ElimVesical  != '' then left(ElimVesical,(len(ElimVesical)-1)) else '' end as ElimVesical, ElimVesCateterVisical, 
			case when ElimVesAspec != '' then left(ElimVesAspec,(len(ElimVesAspec)-1)) else '' end as ElimVesAspec,
			case when ElimInst != '' then left(ElimInst,(len(ElimInst)-1)) else '' end as ElimInst, 
			case when eliminstaspe != '' then left(ElimInstAspe,(len(ElimInstAspe)-1)) else '' end as ElimInstAspe, prof_nome, DataInclusao
		from #temp1
	end


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
PRINT N'Altering [dbo].[ksp_PEP_Solicitacao_Pedido_Impresso]...';


GO
ALTER PROCEDURE [dbo].[ksp_PEP_Solicitacao_Pedido_Impresso]
@solped_codigo CHAR (12), @solped_tiposolicitacao INT, @unid_codigo CHAR (4), @viim_descricao VARCHAR (200)
AS
SET NOCOUNT ON  
  
 declare @viaimpressao int  
   
 exec ksp_via_impressao @viim_descricao = @viim_descricao, @viim_chave = @solped_codigo, @proximo = @viaimpressao output  
 set @viaimpressao = @viaimpressao /2
  
 --LABORATORIO  
 IF (@solped_tiposolicitacao = 7)   
 BEGIN  
  select sp.solped_datahora as atend_data  
  , p.pac_codigo  
  , case when p.pac_nome_social is null then p.pac_nome else rtrim(p.pac_nome_social) +' ['+rtrim(p.pac_nome)+']' end as pac_nome  
  , pac_prontuario_numero,
  r.Raca_Desc,   
  pac_idade=(cast(DateDiff(dd,  P.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, P.pac_nascimento,getdate()) as int) / 4)) / 365,  
  v.set_descricao as clinica,   
  case pac_sexo  
   when 'M' then 'Masculino'  
   when 'F' then 'Feminino' end as sexo,
   pa.spa_etnia as etinia,
   c.cep_cep as cep,
   c.cep_logradouro as logradouro,
   m.mun_descricao as municipio,
   m.uf_codigo,
   b.bai_descricao as bairro,    
  isnull(pac_cartao_nsaude,pac_cartao_nsaude_provisorio) as cns,    
  el.exalab_descricao exame,  
  el.proc_codigo as procedimento,
  el.cbo_codigo, 
  (select prof_nome from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo) as medico,  
  (select prof_numconselho from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo) as crm,  
  tipo_solicitacao = 7,  
  @viaimpressao viaimpressao  
  , convert(char(10),p.pac_nascimento,103) as pac_nascimento 
  , p.pac_telefone  
  , spe.solpedexa_codigo  
  , sp.solped_CodigoOrigem  
  , Oripac_descricao  
  , upr.LOGO  
  , upr.cabecalho_report1                                          
  , upr.cabecalho_report2    
  , upr.cabecalho_report3  
  , u.unid_descricao
  , u.unid_codigoCNES   
  , '' as complemento, '' as Incidencia  
  , lei.locint_descricao   
	, p.pac_celular
	, e.etnia_desc
	, m.cod_ibge
	, isnull(uam.upaatemed_Anamnese, pep.anamnese) as 'upaatemed_Anamnese'
	, spe.solpedexa_observacao

  from vwsolicitacao_pedido sp   
  join solicitacao_pedido_exame spe on sp.[ped_codigo] = spe.[ped_codigo]  
  join exame_laboratorio el on spe.solpedexa_codigo_exame = el.exalab_codigo  
  join vwlocal_unidade v on v.locatend_codigo = sp.locatend_codigo  
  join Paciente p on p.pac_codigo = sp.pac_codigo  
  left join Paciente_Prontuario pp on p.pac_codigo = pp.pac_codigo and pp.unid_codigo = @unid_codigo  
  inner join origem_paciente op    on sp.Oripac_Codigo = op.Oripac_Codigo   
  left  join unidade_parametro_relatorio upr  on upr.unid_codigo = sp.unid_codigo  
  inner join unidade u on sp.unid_codigo = u.unid_codigo  
  left join internacao i on (i.spa_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 5) or (i.emer_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 3) or (i.inter_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 4)   
  left join vwleito lei on i.locatend_leito = lei.locatend_codigo and i.lei_codigo = lei.lei_codigo
  left join atendimento_ambulatorial aa on sp.solped_CodigoOrigem = aa.spa_codigo
  left JOIN Pronto_Atendimento pa on pa.spa_codigo = aa.spa_codigo
  left JOIN etnias e on p.etnia_codigo = e.etnia_codigo
  left JOIN Raca r ON r.Raca_Codigo = p.raca_codigo
  left JOIN cep c ON c.cep_sequencial = p.cep_sequencial 
  left JOIN municipio m ON m.mun_codigo = c.mun_codigo
  left JOIN bairro b ON b.bai_codigo = c.bai_codigo and b.mun_codigo = c.mun_codigo  
  left join internacao_pep pep on i.inter_codigo = pep.inter_codigo
  left join UPA_Atendimento_Medico uam on aa.atendamb_codigo = uam.atendamb_codigo 

  where solped_tiposolicitacao = @solped_tiposolicitacao  
  and sp.[solped_codigo] = @solped_codigo  
 END  
   
 --RADIOLOGICO  
 ELSE IF(@solped_tiposolicitacao = 8)  
 BEGIN   
   
 declare @incidencia  as nvarchar(500)  
 declare @exainc_codigo as int  
 declare @incidenciadescricao  as nvarchar(500)  
 declare @solpedexa_codigo as char(18)  
  
 create table #tmp_incidencia  
 (  
 solpedexa_codigo char(18) null,  
 atend_data datetime null,  
 pac_nome varchar(50) null,  
 pac_codigo char(12) null,  
 pac_prontuario_numero char(10) null,  
 Raca_Desc varchar(30) null,
 pac_idade int null,  
 clinica varchar(30) null,  
 sexo varchar(10) null,  
 etnia char(4) null,
 cep char(12) null,
 logradouro char(200) null,
 municipio char(200) null,
 uf_codigo char(2) null, 
 bairro char(200) null,
 cns char(15) null,  
 exame varchar(75) null,  
 medico varchar(50) null,  
 crm char(15) null,  
 tipo_solicitacao int null,  
 viaimpressao int null,  
 complemento varchar(10) null,  
 Incidencia varchar(500) null  
 , pac_nascimento char(10) null  
 , solped_CodigoOrigem varchar(12) null  
 , Oripac_descricao varchar(30) null  
 , LOGO image null  
 , cabecalho_report1 varchar(100) null                                           
 , cabecalho_report2 varchar(100) null    
 , cabecalho_report3 varchar(100) null  
 , unid_descricao varchar(50) null  
 , unid_codigoCNES varchar(30) null
 , locint_descricao varchar(100) null  
 , pac_telefone char(20)
 , pac_celular char(20)
 , etnia_desc varchar(30)
 , cod_ibge varchar(100)
 , upaatemed_Anamnese varchar(2000)
 , solpedexa_observacao varchar(200)
 )   
  
 insert into #tmp_incidencia  
 (solpedexa_codigo, atend_data, pac_nome, pac_codigo, pac_prontuario_numero, Raca_Desc,    
 pac_idade, clinica, sexo, etnia, cep, logradouro, municipio, uf_codigo, bairro, cns, exame, medico, crm, tipo_solicitacao, viaimpressao, complemento, Incidencia  
      , pac_nascimento, solped_CodigoOrigem, Oripac_descricao, LOGO, cabecalho_report1, cabecalho_report2, cabecalho_report3  
      , unid_descricao, unid_codigoCNES, locint_descricao, pac_telefone, pac_celular, etnia_desc,  cod_ibge, upaatemed_Anamnese, solpedexa_observacao)         
  
 select spe.solpedexa_codigo, 
 sp.solped_datahora, 
  case when p.pac_nome_social is null then p.pac_nome else rtrim(p.pac_nome_social) +' ['+rtrim(p.pac_nome)+']' end as pac_nome,  
  p.pac_codigo,  
 pac_prontuario_numero,
 r.Raca_Desc,   
 pac_idade=(cast(DateDiff(dd,  P.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, P.pac_nascimento,getdate()) as int) / 4)) / 365,  
 v.set_descricao as clinica,   
  case pac_sexo  
   when 'M' then 'Masculino'  
   when 'F' then 'Feminino' end as sexo,
   p.etnia_codigo as etinia,
   c.cep_cep as cep,
   c.cep_logradouro as logradouro,
   m.mun_descricao as municipio,
   m.uf_codigo,
   b.bai_descricao as bairro,    
  isnull(pac_cartao_nsaude,pac_cartao_nsaude_provisorio) as cns,     
  er.exarad_descricao,  
  (select prof_nome from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo),  
  (select prof_numconselho from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo),  
  8,  
  @viaimpressao,  
  case  
  when solpedexa_complemento = '1' then 'Direito'  
  when solpedexa_complemento = '2' then 'Esquerdo'  
  when solpedexa_complemento = '3' then 'Bilateral'  
  end      
  , Null  
  , convert(char(10),p.pac_nascimento,103) as pac_nascimento  
  , sp.solped_CodigoOrigem  
  , op.Oripac_descricao  
      , upr.LOGO  
  , upr.cabecalho_report1                                          
  , upr.cabecalho_report2    
  , upr.cabecalho_report3  
  , u.unid_descricao  
  , u.unid_codigoCNES
  , lei.locint_descricao   
  , p.pac_telefone  
  , p.pac_celular
  , e.etnia_desc
  , m.cod_ibge
  , isnull(uam.upaatemed_Anamnese, pep.anamnese) as 'upaatemed_Anamnese'
  , spe.solpedexa_observacao
  from vwsolicitacao_pedido sp  
  join solicitacao_pedido_exame spe on sp.ped_codigo = spe.ped_codigo  
  join exame_radiologico er on spe.solpedexa_codigo_exame = er.exarad_codigo  
  join vwlocal_unidade v on v.locatend_codigo = sp.locatend_codigo  
  join Paciente p on p.pac_codigo = sp.pac_codigo  
  left join Paciente_Prontuario pp on p.pac_codigo = pp.pac_codigo and pp.unid_codigo = @unid_codigo 
  left JOIN Raca r ON r.Raca_Codigo = p.raca_codigo
  left JOIN cep c ON c.cep_sequencial = p.cep_sequencial 
  left JOIN municipio m ON m.mun_codigo = c.mun_codigo
  left JOIN bairro b ON b.bai_codigo = c.bai_codigo and b.mun_codigo = c.mun_codigo  
  left join origem_paciente op    on sp.Oripac_Codigo = op.Oripac_Codigo   
  left join unidade_parametro_relatorio upr  on upr.unid_codigo = sp.unid_codigo   
  inner join unidade u on sp.unid_codigo = u.unid_codigo  
  left join internacao i on (i.spa_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 5) or (i.emer_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 3) or (i.inter_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 4)   
  left join vwleito lei on i.locatend_leito = lei.locatend_codigo and i.lei_codigo = lei.lei_codigo  
  left JOIN etnias e on p.etnia_codigo = e.etnia_codigo
  left join atendimento_ambulatorial aa on sp.solped_CodigoOrigem = aa.spa_codigo
  left join UPA_Atendimento_Medico uam on aa.atendamb_codigo = uam.atendamb_codigo 
  left join internacao_pep pep on i.inter_codigo = pep.inter_codigo
  where solped_tiposolicitacao = @solped_tiposolicitacao  
  and sp.solped_codigo = @solped_codigo  
  order by solpedexa_codigo  
    
  select top 1 @solpedexa_codigo = solpedexa_codigo from #tmp_incidencia  
    
  while (@@rowcount > 0)  
   begin       
  
  select a.exainc_codigo, exainc_descricao  
  into #incidencia  
  from #tmp_incidencia tmp  
    JOIN Solicitacao_Pedido_Exame_Incidencia a ON tmp.solpedexa_codigo = a.solpedexa_codigo  
    JOIN Exame_Incidencia b       on a.exainc_codigo = b.exainc_codigo   
  where tmp.solpedexa_codigo = @solpedexa_codigo  
      
  set @incidenciaDescricao = ''  
  select top 1 @exainc_codigo = exainc_codigo, @incidencia = exainc_descricao from #incidencia    
     
  while (@@rowcount > 0)    
   begin  
   set @incidenciaDescricao = @incidenciaDescricao + @incidencia + ' - '  
   delete from #incidencia where exainc_codigo = @exainc_codigo  
   select top 1 @exainc_codigo = exainc_codigo, @incidencia = exainc_descricao from #incidencia where exainc_codigo > @exainc_codigo    
   end  
     
   if (len(@incidenciaDescricao) > 0)  
    begin   
    update #tmp_incidencia set incidencia = substring(@incidenciaDescricao, 0, len(@incidenciaDescricao))  
    where solpedexa_codigo = @solpedexa_codigo  
    end  
      
    drop table #incidencia  
  
    select top 1 @solpedexa_codigo = solpedexa_codigo from #tmp_incidencia where solpedexa_codigo > @solpedexa_codigo  
       
   end  
   select * from #tmp_incidencia  
 END
  --DIAGNOSE  
 ELSE IF(@solped_tiposolicitacao = 9)  
 BEGIN   
   
 --declare @incidencia  as nvarchar(500)  
 --declare @exainc_codigo as int  
 --declare @incidenciadescricao  as nvarchar(500)  
 --declare @solpedexa_codigo as char(18)  
  
 create table #tmp_incidencia_Diagnose  
 (  
 solpedexa_codigo char(18) null,  
 atend_data datetime null,  
 pac_nome varchar(50) null,  
 pac_codigo char(12) null,  
 pac_prontuario_numero char(10) null,  
 Raca_Desc varchar(30) null,
 pac_idade int null,  
 clinica varchar(30) null,  
 sexo varchar(10) null,  
 etnia char(4) null,
 cep char(12) null,
 logradouro char(200) null,
 municipio char(200) null,
 uf_codigo char(2) null, 
 bairro char(200) null,
 cns char(15) null,  
 exame varchar(75) null,  
 medico varchar(50) null,  
 crm char(15) null,  
 tipo_solicitacao int null,  
 viaimpressao int null,  
 complemento varchar(10) null,  
 Incidencia varchar(500) null  
 , pac_nascimento char(10) null  
 , solped_CodigoOrigem varchar(12) null  
 , Oripac_descricao varchar(30) null  
 , LOGO image null  
 , cabecalho_report1 varchar(100) null                                           
 , cabecalho_report2 varchar(100) null    
 , cabecalho_report3 varchar(100) null  
 , unid_descricao varchar(50) null  
 , unid_codigoCNES varchar(30) null
 , locint_descricao varchar(100) null  
 , pac_telefone char(20)
 , pac_celular char(20)
 , etnia_desc varchar(30)
 , cod_ibge varchar(100)
 , upaatemed_Anamnese varchar(2000)
 , solpedexa_observacao varchar(200)
 )   
  
 insert into #tmp_incidencia_Diagnose  
 (solpedexa_codigo, atend_data, pac_nome, pac_codigo, pac_prontuario_numero, Raca_Desc,    
 pac_idade, clinica, sexo, etnia, cep, logradouro, municipio, uf_codigo, bairro, cns, exame, medico, crm, tipo_solicitacao, viaimpressao, complemento, Incidencia  
      , pac_nascimento, solped_CodigoOrigem, Oripac_descricao, LOGO, cabecalho_report1, cabecalho_report2, cabecalho_report3  
      , unid_descricao, unid_codigoCNES, locint_descricao, pac_telefone, pac_celular, etnia_desc,  cod_ibge, upaatemed_Anamnese, solpedexa_observacao)         
  
 select spe.solpedexa_codigo, 
 sp.solped_datahora, 
  case when p.pac_nome_social is null then p.pac_nome else rtrim(p.pac_nome_social) +' ['+rtrim(p.pac_nome)+']' end as pac_nome,  
  p.pac_codigo,  
 pac_prontuario_numero,
 r.Raca_Desc,   
 pac_idade=(cast(DateDiff(dd,  P.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, P.pac_nascimento,getdate()) as int) / 4)) / 365,  
 v.set_descricao as clinica,   
  case pac_sexo  
   when 'M' then 'Masculino'  
   when 'F' then 'Feminino' end as sexo,
   p.etnia_codigo as etinia,
   c.cep_cep as cep,
   c.cep_logradouro as logradouro,
   m.mun_descricao as municipio,
   m.uf_codigo,
   b.bai_descricao as bairro,    
  isnull(pac_cartao_nsaude,pac_cartao_nsaude_provisorio) as cns,     
  spe.solpedexa_descricao,  
  (select prof_nome from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo),  
  (select prof_numconselho from profissional prof where prof.prof_codigo=sp.prof_codigo and prof.locatend_codigo=sp.locatend_codigo),  
  9,  
  @viaimpressao,  
  '' as complemento, '' as Incidencia  
  , convert(char(10),p.pac_nascimento,103) as pac_nascimento  
  , sp.solped_CodigoOrigem  
  , op.Oripac_descricao  
      , upr.LOGO  
  , upr.cabecalho_report1                                          
  , upr.cabecalho_report2    
  , upr.cabecalho_report3  
  , u.unid_descricao  
  , u.unid_codigoCNES
  , lei.locint_descricao   
  , p.pac_telefone  
  , p.pac_celular
  , e.etnia_desc
  , m.cod_ibge
  , isnull(uam.upaatemed_Anamnese, pep.anamnese) as 'upaatemed_Anamnese'
  ,spe.solpedexa_observacao
  from vwsolicitacao_pedido sp  
  join solicitacao_pedido_exame spe on sp.ped_codigo = spe.ped_codigo  
  --join exame_diagnose er on spe.solpedexa_codigo_exame = er.exared_codigo  
  join vwlocal_unidade v on v.locatend_codigo = sp.locatend_codigo  
  join Paciente p on p.pac_codigo = sp.pac_codigo  
  left join Paciente_Prontuario pp on p.pac_codigo = pp.pac_codigo and pp.unid_codigo = @unid_codigo 
  left JOIN Raca r ON r.Raca_Codigo = p.raca_codigo
  left JOIN cep c ON c.cep_sequencial = p.cep_sequencial 
  left JOIN municipio m ON m.mun_codigo = c.mun_codigo
  left JOIN bairro b ON b.bai_codigo = c.bai_codigo and b.mun_codigo = c.mun_codigo  
  left join origem_paciente op    on sp.Oripac_Codigo = op.Oripac_Codigo   
  left join unidade_parametro_relatorio upr  on upr.unid_codigo = sp.unid_codigo   
  inner join unidade u on sp.unid_codigo = u.unid_codigo  
  left join internacao i on (i.spa_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 5) or (i.emer_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 3) or (i.inter_codigo = sp.solped_CodigoOrigem and sp.oripac_codigo = 4)   
  left join vwleito lei on i.locatend_leito = lei.locatend_codigo and i.lei_codigo = lei.lei_codigo  
  left JOIN etnias e on p.etnia_codigo = e.etnia_codigo
  left join atendimento_ambulatorial aa on sp.solped_CodigoOrigem = aa.spa_codigo
  left join UPA_Atendimento_Medico uam on aa.atendamb_codigo = uam.atendamb_codigo 
   left join internacao_pep pep on i.inter_codigo = pep.inter_codigo
  where 1 = 1
  --solped_tiposolicitacao = @solped_tiposolicitacao  
  and sp.solped_codigo = @solped_codigo  
  order by solpedexa_codigo  
    
   
   select * from #tmp_incidencia_Diagnose  
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
PRINT N'Altering [dbo].[ksp_relatorio_laboratorio_laudo_Consolidado]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_laboratorio_laudo_Consolidado]
@ped_cod CHAR (12), @exa_cod CHAR (4) = null
AS
set nocount on

--Cria a Tabela Tempor?ria----------------------------------------------------------------------    
create table #temp_LAUDO (
-- SAMIR.15/10/2003
		UNID_DESCRICAO		VARCHAR(50),
		UNID_CGC		CHAR(14),
		UNID_ENDERECO		VARCHAR(200),
		UNID_TELEFONE		VARCHAR(50),
		Paciente		Varchar(100) null,
		Idade			char(3) null,	
		TipoIdade		Varchar(50) null,
		Medico			Varchar(100) null,
		LocalColeta		Varchar(100) null,
		Clinica			Varchar(100) null,
		Origem			Varchar(50) null,
		Enfermeira		Varchar(20) null,
		Data			char(10) null,	
		HoraColeta		char(10) null,
		Destino			Varchar(100) null,
		Exame 			Varchar(255),
		Requisicao		char(12) null,
		Codigo_Exame		char(4) null,
		Codigo_Elemento		char(4) null,
		Elemento_Descricao 	varchar(80) null,
		Resultado 		varchar(255) null,
		Observacao 		varchar(255) null,
      	VlrReferencia 		Varchar(5000) null,
		Unidade_codigo 		char(4) null,
		Unidade_descricao 	varchar(12) null,
		Codigo_Secao 		char(4) null,
		Descricao_Secao 	char(30) null,
		codmat			char(4),
		material 		Varchar(200),
		codmet 			char(4),
		metodo			Varchar(200),
		codequip		char(4),
		equipamento		Varchar(50),
		locatend		char(4),
		Enfermaria_Leito varchar (10),
		Sexo             char(1), -- LFSMP 17/12/2004
		classificacao VARCHAR(40),
		Ordem_classificacao_Exame varchar(2))

-- LFSMP 17/12/2004 = INICIO
	-- VERIFICA O STATUS DO EXAME
	IF EXISTS (
			SELECT
				EXASOLLAB_STATUS
			FROM
				EXAME_SOLICITADO_LABORATORIO with(nolock)
			WHERE
				PEDEXALAB_CODIGO = @PED_COD		AND
				EXALAB_CODIGO = isnull(@EXA_COD, EXALAB_CODIGO)		AND
				EXASOLLAB_STATUS IN ('LA', 'LI')
		)
	BEGIN
-- LFSMP 17/12/2004 = FIM

		--Insere o C?digo do Exame e seus Elementos-----------------------------------------------------  
		insert into #temp_LAUDO (codigo_exame,codigo_elemento,codmat,codmet,codequip, Exame, Unidade_codigo, Unidade_descricao, classificacao, Ordem_classificacao_Exame)
		select distinct e.exalab_codigo,esl.elelab_codigo,eel.matlab_codigo,eel.metlab_codigo,null, exalab_descricao, eel.undmed_codigo, undmed_descricao, CEL.claexalab_descricao,claexalab_ordem
				from	Exame_Laboratorio e WITH(NOLOCK)
				inner join LAUDO_EXAME_SOLICITADO_LABORATORIO esl WITH(NOLOCK) on esl.EXALAB_CODIGO = e.exalab_codigo
				LEFT JOIN elemento_exame_laboratorio eel WITH(NOLOCK)	ON (esl.exalab_codigo=eel.exalab_codigo and esl.elelab_codigo = eel.elelab_codigo 
				and (esl.laueleexalab_codigo=eel.eleexalab_codigo or esl.laueleexalab_codigo=null))
				LEFT JOIN metodo_laboratorio mlt WITH(NOLOCK)			ON (mlt.metlab_codigo = eel.metlab_codigo)    
				LEFT JOIN unidade_medida um WITH(NOLOCK)				ON (eel.undmed_codigo = um.undmed_codigo)  
		        LEFT JOIN Classificacao_Elemento_Exame CEE WITH(NOLOCK) ON (eel.eleexalab_codigo = CEE.eleexalab_codigo)
				LEFT JOIN Classificacao_Exame_Laboratorio CEL WITH(NOLOCK) ON (CEE.CLAEXALAB_CODIGO = CEL.CLAEXALAB_CODIGO)

				where	e.exalab_codigo = isnull(@exa_cod, esl.EXALAB_CODIGO)
				AND ESL.PEDEXALAB_CODIGO = @PED_COD	
	            order by claexalab_ordem
		--Atualiza a Tabela com o C?digo da Requisi??o--------------------------------------------------  
		update #temp_laudo set 
			requisicao = @ped_cod
	
		--Atualiza a Tabela com o Local de Atendimento
		update #temp_laudo set 
			locatend = (select locatend_codigo
			from pedido_exame_laboratorio WITH(NOLOCK)
			where pedexalab_codigo = @ped_cod)
	
    	--Atualiza a Tabela com a Descri??o dos Elementos-----------------------------------------------  
		update #temp_laudo set
			elemento_descricao = a.elelab_descricao
			from #temp_laudo, elemento_laboratorio a
			where #temp_laudo.codigo_elemento = a.elelab_codigo
	
		--Atualiza a Tabela com o Resultado-------------------------------------------------------------  
		update #temp_laudo set 
			resultado = b.lauexalab_resultado
			from #temp_laudo, laudo_exame_solicitado_laboratorio b WITH(NOLOCK)
			where #temp_laudo.requisicao = b.pedexalab_codigo and
			      #temp_laudo.codigo_exame = b.exalab_codigo and
			      #temp_laudo.codigo_elemento = b.elelab_codigo
	
		--Atualiza a Tabela com as Observa??es----------------------------------------------------------  
		update #temp_laudo set 
			observacao = c.lauexamelab_observacao
			from #temp_laudo, laudo_exame_solicitado_laboratorio c WITH(NOLOCK)
			where #temp_laudo.requisicao = c.pedexalab_codigo and
			      #temp_laudo.codigo_exame = c.exalab_codigo 
	
	------------------------------------Atualiza a Tabela com o Resultado-----------------------------    
    
DECLARE @PROCAMB AS VARCHAR(10)    
DECLARE @PROC AS VARCHAR(10)    
DECLARE @LEUCOCITOS AS VARCHAR(255)    
     
SELECT @PROC = PROC_CODIGO, @PROCAMB = PROCAMB_CODIGO    
FROM EXAME_LABORATORIO WITH(NOLOCK) 
INNER JOIN #temp_LAUDO ON  #temp_LAUDO.codigo_exame = EXALAB_CODIGO  
WHERE (PROC_CODIGO = '17018030' OR PROCAMB_CODIGO = '1104320' or PROCAMB_CODIGO='0202020380' or PROC_CODIGO = '0202020380' or EXALAB_CODIGO ='0001')   
     
IF (@PROC = '17018030' OR @PROCAMB = '1104320' or @PROCAMB='0202020380' or @PROC = '0202020380' or @exa_cod='0001')  
BEGIN    
 SELECT @LEUCOCITOS = isnull(RESULTADO,'0')    
 FROM #temp_LAUDO WITH(NOLOCK)     
 WHERE #temp_LAUDO.codigo_elemento IN (  
select el.elelab_codigo from elemento_exame_laboratorio eel WITH(NOLOCK)
inner join elemento_laboratorio el WITH(NOLOCK) on (el.elelab_codigo=eel.elelab_codigo)   
where upper(el.elelab_descricao) LIKE ('LEUC%') AND eel.EXALAB_CODIGO='0001' --AND eel.UNID_CODIGO=@UNID_CODIGO  
)  
    
--  Chamado 10203    
 UPDATE #temp_LAUDO     
 SET #temp_LAUDO.resultado = SPACE(7 - LEN(ltrim(rtrim(#temp_LAUDO.RESULTADO)))) + ltrim(rtrim(#temp_LAUDO.RESULTADO)) + space(10)    
 WHERE #temp_LAUDO.codigo_exame = '0001'    
  AND #temp_LAUDO.codigo_elemento IN ('0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018')    
    
 UPDATE #temp_LAUDO     
 SET #temp_LAUDO.RESULTADO = rtrim(#temp_LAUDO.RESULTADO) + SPACE(7 - LEN(rtrim(#temp_LAUDO.RESULTADO))) + ' %' +    
  SPACE(9 - LEN(convert(varchar, CONVERT(NUMERIC(10), Convert(numeric, REPLACE(#temp_LAUDO.RESULTADO, ',', '.'))* Convert(numeric,REPLACE(@LEUCOCITOS, ',', '.'))/100)))) +    
  convert(varchar, CONVERT(NUMERIC(10), Convert(numeric, REPLACE(#temp_LAUDO.RESULTADO, ',', '.'))* Convert(numeric,REPLACE(@LEUCOCITOS, ',', '.'))/100))    
 WHERE #temp_LAUDO.codigo_exame = '0001'    
   AND #temp_LAUDO.codigo_elemento IN ('0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018')    
    
END  


-- SAMIR.15/10/2003
		-- CARREGA OS DADOS DA UNIDADE
		UPDATE #temp_laudo
		SET
			UNID_DESCRICAO	= U.UNID_DESCRICAO,
			UNID_CGC	= U.UNID_CGC,
			UNID_ENDERECO	= rtrim(c.cep_logradouro) + ', ' + rtrim(U.unid_endereco_num) 
							+ ' - ' + rtrim(Isnull(U.unid_endereco_compl, ' ')) + ' - CEP: ' 
							+ C.CEP_CEP + ' - ' + C.BAI_DESCRICAO + ' - ' + C.MUN_DESCRICAO + ' - ' + C.UF_CODIGO ,
			UNID_TELEFONE	= U.UNID_TELEFONE
		FROM 	#temp_laudo, 
			Unidade			U WITH(NOLOCK),
			Local_Atendimento	LA WITH(NOLOCK),
			VWENDERECO		C WITH(NOLOCK)
	
		Where	U.Unid_Codigo		= LA.Unid_Codigo 
		 And    LA.LOCATEND_CODIGO	= #temp_laudo.Locatend 
		 And	C.CEP_SEQUENCIAL 	= U.CEP_SEQUENCIAL
	
		--Dados do Paciente
		SELECT pa.pac_nome as paciente, Isnull(DateDiff(yy,pa.pac_nascimento,getdate()), pa.pac_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, pa.pac_sexo as Sexo
			INTO #TEMP
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				paciente pa WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.pac_codigo 		= pa.pac_codigo		
			AND 	pe.pac_codigo is not null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo
		UNION
		SELECT em.emer_nome as paciente, Isnull(DateDiff(yy,em.emer_nascimento,getdate()), em.emer_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, em.emer_sexo as Sexo
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				Emergencia em WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.emer_codigo 		= em.emer_codigo
			AND 	pe.pac_codigo is null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo
		UNION
		SELECT sp.spa_nome as paciente, Isnull(DateDiff(yy,sp.spa_nascimento,getdate()), sp.spa_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, sp.spa_sexo as Sexo
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				Pronto_Atendimento sp WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.spa_codigo 		= sp.spa_codigo
			AND 	pe.pac_codigo is null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo

		UPDATE #temp_laudo SET
			Paciente = #TEMP.Paciente,
			Idade	 = #TEMP.Idade,
			TipoIdade= #TEMP.Tipo,
			Origem   = #TEMP.Origem,
			Medico	 = #TEMP.prof_nome,
			Clinica  = #TEMP.locatend_descricao,
			Sexo     = #TEMP.Sexo
			FROM #TEMP

		DROP TABLE #TEMP		
		
		update #temp_laudo set 
			vlrReferencia = isnull(lesl.lauvalref_descricao,EEL.referencia_descricao)
		from #temp_laudo, LAUDO_EXAME_SOLICITADO_LABORATORIO lesl WITH(NOLOCK)
		LEFT JOIN elemento_exame_laboratorio eel WITH(NOLOCK) 	ON (lesl.exalab_codigo=eel.exalab_codigo and lesl.elelab_codigo = eel.elelab_codigo and (lesl.laueleexalab_codigo=eel.eleexalab_codigo or lesl.laueleexalab_codigo=null))  
		where	lesl.exalab_codigo = #temp_laudo.Codigo_Exame 
		    and  lesl.elelab_codigo = #temp_laudo.Codigo_Elemento
			AND LESL.PEDEXALAB_CODIGO = @ped_cod

		--Dados Destino
		UPDATE #temp_laudo SET
			Destino = u.dest_descricao
			FROM	pedido_exame_laboratorio pe WITH(NOLOCK),
				destino u
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.dest_codigo 		= u.dest_codigo

		--Dados Local Coleta
		UPDATE #temp_laudo SET
			LocalColeta = u.loccollab_descricao
			FROM	pedido_exame_laboratorio pe WITH(NOLOCK),
				Local_coleta_Laboratorio u WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.unidref_codigo 	= u.unidref_codigo
			AND 	pe.loccollab_codigo 	= u.loccollab_codigo

		--Dados da Coleta
		UPDATE #temp_laudo SET
			Data	= Convert(char(10),pe.exasollab_data_coleta,103),
			HoraColeta = Convert(char(10),pe.exasollab_data_coleta,108)
			FROM	exame_solicitado_laboratorio pe WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod

		--Dados Exame
		UPDATE #temp_laudo SET
			Material= ma.matlab_descricao,
			Metodo	= me.metlab_descricao
			FROM	material_laboratorio ma WITH(NOLOCK),
				metodo_laboratorio me
			WHERE 	#temp_laudo.codmat = ma.matlab_codigo
			AND 	#temp_laudo.codmet = me.metlab_codigo

-- LFSMP 17/12/2004 = INICIO
		-- Enfermaria / Leito 
		update
			#temp_laudo
		set
			Enfermaria_Leito = V.enf_codigo + '/' + V.lei_codigo
		from
			vwleito as V WITH(NOLOCK),
			internacao as I WITH(NOLOCK),
			pedido_exame_laboratorio as P WITH(NOLOCK)
		where
		 	v.locatend_codigo = i.locatend_leito and
			v.lei_codigo = i.lei_codigo and
			i.inter_codigo = P.inter_codigo and
			P.pedexalab_codigo = @ped_cod
	END
	
-- LFSMP 17/12/2004 = FIM

--Seleciona Todos os Dados da Tabela Tempor?ria-------------------------------------------------
select  UNID_DESCRICAO		
		,UNID_CGC		
		,UNID_ENDERECO	
		,UNID_TELEFONE	
		,Paciente		
		,Idade			
		,TipoIdade		
		,Medico			
		,LocalColeta		
		,Clinica			
		,Origem			
		,Enfermeira		
		,Data			
		,HoraColeta		
		,Destino			
		,Exame 			
		,Requisicao		
		,Codigo_Exame	
		,Codigo_Elemento		
		,Elemento_Descricao 	
		,ltrim(rtrim(Resultado)) as 'Resultado'
		,Observacao 		
      	,ltrim(rtrim(VlrReferencia)) as 'VlrReferencia' 		
		,Unidade_codigo 		
		,Unidade_descricao 	
		,Codigo_Secao 		
		,Descricao_Secao 	
		,codmat			 
		,material 		 
		,codmet 			 
		,metodo			 
		,codequip		 
		,equipamento		 
		,locatend		 
		,Enfermaria_Leito 
		,Sexo   
		,Classificacao   
		,Ordem_classificacao_Exame       
	 from #temp_laudo where #temp_laudo.resultado is not null
	

--Apaga a Tabela Tempor?ria---------------------------------------------------------------------  
drop table #temp_LAUDO

set nocount off

--FIM DA PROCEDURE------------------------------------------------------------------------------

IF(@@ERROR <> 0)
BEGIN
	RAISERROR('ERRO !! - ksp_relatorio_laboratorio_laudo_Consolidado',1,1)
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
PRINT N'Altering [dbo].[ksp_relatorio_laboratorio_laudo_Consolidado_Unificado]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_laboratorio_laudo_Consolidado_Unificado]
@ped_cod CHAR (12), @exa_cod CHAR (4) = null
AS
set nocount on

--Cria a Tabela Tempor?ria----------------------------------------------------------------------    
create table #temp_LAUDO (
-- SAMIR.15/10/2003
		UNID_DESCRICAO		VARCHAR(50),
		UNID_CGC		CHAR(14),
		UNID_ENDERECO		VARCHAR(200),
		UNID_TELEFONE		VARCHAR(50),
		Paciente		Varchar(100) null,
		Idade			char(3) null,	
		TipoIdade		Varchar(50) null,
		Medico			Varchar(100) null,
		LocalColeta		Varchar(100) null,
		Clinica			Varchar(100) null,
		Origem			Varchar(50) null,
		Enfermeira		Varchar(20) null,
		Data			char(10) null,	
		HoraColeta		char(10) null,
		Destino			Varchar(100) null,
		Exame 			Varchar(255),
		Requisicao		char(12) null,
		Codigo_Exame		char(4) null,
		Codigo_Elemento		char(4) null,
		Elemento_Descricao 	varchar(80) null,
		Resultado 		varchar(255) null,
		Observacao 		varchar(255) null,
      	VlrReferencia 		Varchar(5000) null,
		Unidade_codigo 		char(4) null,
		Unidade_descricao 	varchar(12) null,
		Codigo_Secao 		char(4) null,
		Descricao_Secao 	char(30) null,
		codmat			char(4),
		material 		Varchar(200),
		codmet 			char(4),
		metodo			Varchar(200),
		codequip		char(4),
		equipamento		Varchar(50),
		locatend		char(4),
		Enfermaria_Leito varchar (10),
		Sexo             char(1), -- LFSMP 17/12/2004
		classificacao VARCHAR(40),
		Ordem_classificacao_Exame varchar(2))

-- LFSMP 17/12/2004 = INICIO
	-- VERIFICA O STATUS DO EXAME
	IF EXISTS (
			SELECT
				EXASOLLAB_STATUS
			FROM
				EXAME_SOLICITADO_LABORATORIO with(nolock)
			WHERE
				PEDEXALAB_CODIGO = @PED_COD		AND
				EXALAB_CODIGO = isnull(@EXA_COD, EXALAB_CODIGO)		AND
				EXASOLLAB_STATUS IN ('LA', 'LI')
		)
	BEGIN
-- LFSMP 17/12/2004 = FIM

		--Insere o C?digo do Exame e seus Elementos-----------------------------------------------------  
		insert into #temp_LAUDO (codigo_exame,codigo_elemento,codmat,codmet,codequip, Exame, Unidade_codigo, Unidade_descricao, classificacao, Ordem_classificacao_Exame)
		select distinct e.exalab_codigo,esl.elelab_codigo,eel.matlab_codigo,eel.metlab_codigo,null, exalab_descricao, eel.undmed_codigo, undmed_descricao, CEL.claexalab_descricao,claexalab_ordem
				from	Exame_Laboratorio e WITH(NOLOCK)
				inner join LAUDO_EXAME_SOLICITADO_LABORATORIO esl WITH(NOLOCK) on esl.EXALAB_CODIGO = e.exalab_codigo
				LEFT JOIN elemento_exame_laboratorio eel WITH(NOLOCK)	ON (esl.exalab_codigo=eel.exalab_codigo and esl.elelab_codigo = eel.elelab_codigo 
				and (esl.laueleexalab_codigo=eel.eleexalab_codigo or esl.laueleexalab_codigo=null))
				LEFT JOIN metodo_laboratorio mlt WITH(NOLOCK)			ON (mlt.metlab_codigo = eel.metlab_codigo)    
				LEFT JOIN unidade_medida um WITH(NOLOCK)				ON (eel.undmed_codigo = um.undmed_codigo)  
		        LEFT JOIN Classificacao_Elemento_Exame CEE WITH(NOLOCK) ON (eel.eleexalab_codigo = CEE.eleexalab_codigo)
				LEFT JOIN Classificacao_Exame_Laboratorio CEL WITH(NOLOCK) ON (CEE.CLAEXALAB_CODIGO = CEL.CLAEXALAB_CODIGO)

				where	e.exalab_codigo = isnull(@exa_cod, esl.EXALAB_CODIGO)
				AND ESL.PEDEXALAB_CODIGO = @PED_COD	
	            order by claexalab_ordem
		--Atualiza a Tabela com o C?digo da Requisi??o--------------------------------------------------  
		update #temp_laudo set 
			requisicao = @ped_cod
	
		--Atualiza a Tabela com o Local de Atendimento
		update #temp_laudo set 
			locatend = (select locatend_codigo
			from pedido_exame_laboratorio WITH(NOLOCK)
			where pedexalab_codigo = @ped_cod)
	
    	--Atualiza a Tabela com a Descri??o dos Elementos-----------------------------------------------  
		update #temp_laudo set
			elemento_descricao = a.elelab_descricao
			from #temp_laudo, elemento_laboratorio a
			where #temp_laudo.codigo_elemento = a.elelab_codigo
	
		--Atualiza a Tabela com o Resultado-------------------------------------------------------------  
		update #temp_laudo set 
			resultado = b.lauexalab_resultado
			from #temp_laudo, laudo_exame_solicitado_laboratorio b WITH(NOLOCK)
			where #temp_laudo.requisicao = b.pedexalab_codigo and
			      #temp_laudo.codigo_exame = b.exalab_codigo and
			      #temp_laudo.codigo_elemento = b.elelab_codigo
	
		--Atualiza a Tabela com as Observa??es----------------------------------------------------------  
		update #temp_laudo set 
			observacao = c.lauexamelab_observacao
			from #temp_laudo, laudo_exame_solicitado_laboratorio c WITH(NOLOCK)
			where #temp_laudo.requisicao = c.pedexalab_codigo and
			      #temp_laudo.codigo_exame = c.exalab_codigo 
	
	------------------------------------Atualiza a Tabela com o Resultado-----------------------------    
    
DECLARE @PROCAMB AS VARCHAR(10)    
DECLARE @PROC AS VARCHAR(10)    
DECLARE @LEUCOCITOS AS VARCHAR(255)    
     
SELECT @PROC = PROC_CODIGO, @PROCAMB = PROCAMB_CODIGO    
FROM EXAME_LABORATORIO WITH(NOLOCK) 
INNER JOIN #temp_LAUDO ON  #temp_LAUDO.codigo_exame = EXALAB_CODIGO  
WHERE (PROC_CODIGO = '17018030' OR PROCAMB_CODIGO = '1104320' or PROCAMB_CODIGO='0202020380' or PROC_CODIGO = '0202020380' or EXALAB_CODIGO ='0001')   
     
IF (@PROC = '17018030' OR @PROCAMB = '1104320' or @PROCAMB='0202020380' or @PROC = '0202020380' or @exa_cod='0001')  
BEGIN    
 SELECT @LEUCOCITOS = isnull(RESULTADO,'0')    
 FROM #temp_LAUDO WITH(NOLOCK)     
 WHERE #temp_LAUDO.codigo_elemento IN (  
select el.elelab_codigo from elemento_exame_laboratorio eel WITH(NOLOCK)
inner join elemento_laboratorio el WITH(NOLOCK) on (el.elelab_codigo=eel.elelab_codigo)   
where upper(el.elelab_descricao) LIKE ('LEUC%') AND eel.EXALAB_CODIGO='0001' --AND eel.UNID_CODIGO=@UNID_CODIGO  
)  
    
--  Chamado 10203    
 UPDATE #temp_LAUDO     
 SET #temp_LAUDO.resultado = SPACE(7 - LEN(ltrim(rtrim(#temp_LAUDO.RESULTADO)))) + ltrim(rtrim(#temp_LAUDO.RESULTADO)) + space(10)    
 WHERE #temp_LAUDO.codigo_exame = '0001'    
  AND #temp_LAUDO.codigo_elemento IN ('0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018')    
    
 UPDATE #temp_LAUDO     
 SET #temp_LAUDO.RESULTADO = rtrim(#temp_LAUDO.RESULTADO) + SPACE(7 - LEN(rtrim(#temp_LAUDO.RESULTADO))) + ' %' +    
  SPACE(9 - LEN(convert(varchar, CONVERT(NUMERIC(10), Convert(numeric, REPLACE(#temp_LAUDO.RESULTADO, ',', '.'))* Convert(numeric,REPLACE(@LEUCOCITOS, ',', '.'))/100)))) +    
  convert(varchar, CONVERT(NUMERIC(10), Convert(numeric, REPLACE(#temp_LAUDO.RESULTADO, ',', '.'))* Convert(numeric,REPLACE(@LEUCOCITOS, ',', '.'))/100))    
 WHERE #temp_LAUDO.codigo_exame = '0001'    
   AND #temp_LAUDO.codigo_elemento IN ('0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018')    
    
END  


-- SAMIR.15/10/2003
		-- CARREGA OS DADOS DA UNIDADE
		UPDATE #temp_laudo
		SET
			UNID_DESCRICAO	= U.UNID_DESCRICAO + 'Uni',
			UNID_CGC	= U.UNID_CGC,
			UNID_ENDERECO	= rtrim(c.cep_logradouro) + ', ' + rtrim(U.unid_endereco_num) 
							+ ' - ' + rtrim(Isnull(U.unid_endereco_compl, ' ')) + ' - CEP: ' 
							+ C.CEP_CEP + ' - ' + C.BAI_DESCRICAO + ' - ' + C.MUN_DESCRICAO + ' - ' + C.UF_CODIGO ,
			UNID_TELEFONE	= U.UNID_TELEFONE
		FROM 	#temp_laudo, 
			Unidade			U WITH(NOLOCK),
			Local_Atendimento	LA WITH(NOLOCK),
			VWENDERECO		C WITH(NOLOCK)
	
		Where	U.Unid_Codigo		= LA.Unid_Codigo 
		 And    LA.LOCATEND_CODIGO	= #temp_laudo.Locatend 
		 And	C.CEP_SEQUENCIAL 	= U.CEP_SEQUENCIAL
	
		--Dados do Paciente
		SELECT pa.pac_nome as paciente, Isnull(DateDiff(yy,pa.pac_nascimento,getdate()), pa.pac_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, pa.pac_sexo as Sexo
			INTO #TEMP
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				paciente pa WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.pac_codigo 		= pa.pac_codigo		
			AND 	pe.pac_codigo is not null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo
		UNION
		SELECT em.emer_nome as paciente, Isnull(DateDiff(yy,em.emer_nascimento,getdate()), em.emer_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, em.emer_sexo as Sexo
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				Emergencia em WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.emer_codigo 		= em.emer_codigo
			AND 	pe.pac_codigo is null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo
		UNION
		SELECT sp.spa_nome as paciente, Isnull(DateDiff(yy,sp.spa_nascimento,getdate()), sp.spa_idade) as idade, 
			'ANOS' as Tipo, op.Oripac_Descricao as Origem,
			pe.pedexalab_codigo,pr.prof_nome,vw.locatend_descricao,space(10) as enfermeira, sp.spa_sexo as Sexo
			FROM	Pedido_exame_Laboratorio pe WITH(NOLOCK),
				Pronto_Atendimento sp WITH(NOLOCK),
				profissional pr WITH(NOLOCK),
				vwlocal_atendimento vw WITH(NOLOCK),
				Origem_Paciente op WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.spa_codigo 		= sp.spa_codigo
			AND 	pe.pac_codigo is null
			AND 	pe.prof_codigo = pr.prof_codigo
			AND 	pe.orilab_codigo = op.oripac_codigo
			AND 	pe.locatend_codigo = vw.locatend_codigo

		UPDATE #temp_laudo SET
			Paciente = #TEMP.Paciente,
			Idade	 = #TEMP.Idade,
			TipoIdade= #TEMP.Tipo,
			Origem   = #TEMP.Origem,
			Medico	 = #TEMP.prof_nome,
			Clinica  = #TEMP.locatend_descricao,
			Sexo     = #TEMP.Sexo
			FROM #TEMP

		DROP TABLE #TEMP		
		
		update #temp_laudo set 
			vlrReferencia = isnull(lesl.lauvalref_descricao,EEL.referencia_descricao)
		from #temp_laudo, LAUDO_EXAME_SOLICITADO_LABORATORIO lesl WITH(NOLOCK)
		LEFT JOIN elemento_exame_laboratorio eel WITH(NOLOCK) 	ON (lesl.exalab_codigo=eel.exalab_codigo and lesl.elelab_codigo = eel.elelab_codigo and (lesl.laueleexalab_codigo=eel.eleexalab_codigo or lesl.laueleexalab_codigo=null))  
		where	lesl.exalab_codigo = #temp_laudo.Codigo_Exame 
		    and  lesl.elelab_codigo = #temp_laudo.Codigo_Elemento
			AND LESL.PEDEXALAB_CODIGO = @ped_cod

		--Dados Destino
		UPDATE #temp_laudo SET
			Destino = u.dest_descricao
			FROM	pedido_exame_laboratorio pe WITH(NOLOCK),
				destino u
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.dest_codigo 		= u.dest_codigo

		--Dados Local Coleta
		UPDATE #temp_laudo SET
			LocalColeta = u.loccollab_descricao
			FROM	pedido_exame_laboratorio pe WITH(NOLOCK),
				Local_coleta_Laboratorio u WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod
			AND 	pe.unidref_codigo 	= u.unidref_codigo
			AND 	pe.loccollab_codigo 	= u.loccollab_codigo

		--Dados da Coleta
		UPDATE #temp_laudo SET
			Data	= Convert(char(10),pe.exasollab_data_coleta,103),
			HoraColeta = Convert(char(10),pe.exasollab_data_coleta,108)
			FROM	exame_solicitado_laboratorio pe WITH(NOLOCK)
			WHERE 	pe.pedexalab_codigo	= @ped_cod

		--Dados Exame
		UPDATE #temp_laudo SET
			Material= ma.matlab_descricao,
			Metodo	= me.metlab_descricao
			FROM	material_laboratorio ma WITH(NOLOCK),
				metodo_laboratorio me
			WHERE 	#temp_laudo.codmat = ma.matlab_codigo
			AND 	#temp_laudo.codmet = me.metlab_codigo

-- LFSMP 17/12/2004 = INICIO
		-- Enfermaria / Leito 
		update
			#temp_laudo
		set
			Enfermaria_Leito = V.enf_codigo + '/' + V.lei_codigo
		from
			vwleito as V WITH(NOLOCK),
			internacao as I WITH(NOLOCK),
			pedido_exame_laboratorio as P WITH(NOLOCK)
		where
		 	v.locatend_codigo = i.locatend_leito and
			v.lei_codigo = i.lei_codigo and
			i.inter_codigo = P.inter_codigo and
			P.pedexalab_codigo = @ped_cod
	END
	
-- LFSMP 17/12/2004 = FIM

--Seleciona Todos os Dados da Tabela Tempor?ria-------------------------------------------------
select  UNID_DESCRICAO		
		,UNID_CGC		
		,UNID_ENDERECO	
		,UNID_TELEFONE	
		,Paciente		
		,Idade			
		,TipoIdade		
		,Medico			
		,LocalColeta		
		,Clinica			
		,Origem			
		,Enfermeira		
		,Data			
		,HoraColeta		
		,Destino			
		,Exame 			
		,Requisicao		
		,Codigo_Exame	
		,Codigo_Elemento		
		,Elemento_Descricao 	
		,ltrim(rtrim(Resultado)) as 'Resultado'
		,Observacao 		
      	,ltrim(rtrim(VlrReferencia)) as 'VlrReferencia' 		
		,Unidade_codigo 		
		,Unidade_descricao 	
		,Codigo_Secao 		
		,Descricao_Secao 	
		,codmat			 
		,material 		 
		,codmet 			 
		,rtrim(ltrim(metodo)) as 'metodo'			 
		,codequip		 
		,equipamento		 
		,locatend		 
		,Enfermaria_Leito 
		,Sexo   
		,Classificacao   
		,Ordem_classificacao_Exame       
	 from #temp_laudo where #temp_laudo.resultado is not null
	

--Apaga a Tabela Tempor?ria---------------------------------------------------------------------  
drop table #temp_LAUDO

set nocount off

--FIM DA PROCEDURE------------------------------------------------------------------------------

IF(@@ERROR <> 0)
BEGIN
	RAISERROR('ERRO !! - ksp_relatorio_laboratorio_laudo_Consolidado',1,1)
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
  UPPER(CONVERT(VARCHAR(max),EXARAD_LAUDO)) AS 'EXARAD_LAUDO',    
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
PRINT N'Altering [dbo].[ksp_profissional_lotacao]...';


GO
ALTER PROCEDURE [dbo].[ksp_profissional_lotacao]
@unid_codigo CHAR (4), @prof_codigo CHAR (4), @prof_nome VARCHAR (50)=NULL, @tipprof_codigo CHAR (4), @tipprof_descricao VARCHAR (50)=NULL, @locatend_codigo CHAR (4), @locatend_descricao VARCHAR (50)=NULL, @cbo_codigo CHAR (6), @prof_medauditor CHAR (1), @profatvamb CHAR (1), @profatvcirurgica CHAR (1), @funcir_codigo CHAR (4), @prof_ativo CHAR (1), @tp_pesq SMALLINT, @opcao SMALLINT, @profmovprontuario CHAR (1)='N', @profpermiteagenda CHAR (1)='N', @profchefeclinica CHAR (1)='N', @profatendclinico CHAR (1)='N', @prof_cpf CHAR (11)=Null, @prof_SMS_envio INT=null, @ProfEnfermeiroChefe CHAR (1)=null, @Prof_registro_conselho VARCHAR (20)=null, @prof_UF_registro CHAR (2)=null, @chefe_laboratorio CHAR (1)=NULL
AS
Declare @sql Varchar(2000)  
   Declare @par varchar(255)  
   Declare @var1 varchar(255)  
   Declare @NomeProfissional VarChar(50)  
   Declare @IdSUS_CBO int  
    
IF @opcao = 0  -- Consulta  
  
     BEGIN  
        SET @SQL = 'SELECT pl.prof_codigo, ' +  
                   '       pl.unid_codigo, ' +  
                   '       pr.prof_nome, ' +  
                   '       pl.tipprof_codigo, ' +  
                   '       t.tipprof_descricao, ' +  
                   '       pl.locatend_codigo, ' +  
                   '       l.locatend_descricao,  ' +  
                   '       pl.prof_registro_conselho AS prof_numconselho, ' +   
                   '       pl.prof_cirurgia, ' +  
                   '       pl.prof_ambulatorio, ' +  
				   '       pl.chefe_laboratorio, ' +  
                   '       pl.prof_ativo, ' +  
                   '       pl.prof_medAuditor, ' +  
				   '       pl.funcir_codigo, ' +  
				   '       pl.prof_movimenta_prontuario, ' +  
				   '       pl.prof_permite_agenda, ' +  
				   '       fc.funcir_descricao, ' +  
				   '       pl.profchefeclinica, ' +  
				   '       pl.prof_atend_clinico, ' +  
                   '       pl.CBO_codigo, ' +  
                   '       a.no_ocupacao AS CBO_descricao, ' +  
                   '       pr.usu_codigo, pl.prof_SMS_envio, ' +  
                   '	   pl.ProfEnfermeiroChefe,  ' +
                   '	   pl.Prof_registro_conselho,  ' +
                   '	   pr.Prof_cns,  ' + 
                   '       la.setcli_codigo,  ' +        
				   '	   (select oec.orgem_descricao from Orgao_Emissor_Conselho oec join Tipo_Profissional tp on oec.orgem_codigo = tp.orgem_codigo
							where tp.tipprof_codigo = pl.tipprof_codigo) as orgao_emissor_conselho, ' + 
                   '	   pl.prof_UF_registro,  la.set_codigo, la.setcli_codigo ' +
                   '  FROM profissional_rede pr ' +  
                   '       inner join profissional_lotacao pl on pl.prof_codigo = pr.prof_codigo ' +  
                   '       inner join vwlocal_unidade l on pl.locatend_codigo = l.locatend_codigo ' +  
                   '       inner join tipo_profissional t on pl.tipprof_codigo = t.tipprof_codigo ' +  
                   '       left join tb_ocupacao a on pl.cbo_codigo = a.co_ocupacao ' +  
                   '       left join funcao_cirurgica fc on fc.funcir_codigo = pl.funcir_codigo ' +  
  				   '	   left join local_atendimento la on la.locatend_codigo = l.locatend_codigo ' +					
				   '	   AND la.unid_codigo = l.unid_codigo ' +
                   ' WHERE  pl.unid_codigo = ''' + @unid_codigo + ''''  
                     
  
   
 IF @prof_codigo IS NOT NULL    
    BEGIN    
     SET @var1 = @prof_codigo    
     EXEC ksp_ParametroPesquisa @var1, ' pl.prof_codigo', @tp_pesq, 't', @par OUTPUT    
     SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END  
    
 IF @prof_nome IS NOT NULL    
    BEGIN
		SET @Sql = @Sql + ' and  pr.prof_nome like ''' + @prof_nome + '%'' '
     --SET @var1 = @prof_nome    
            --EXEC ksp_ParametroPesquisa @var1,'pr.prof_nome' ,@tp_pesq, 't', @par OUTPUT    
     --SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END    
    
 IF @tipprof_descricao IS NOT NULL    
    BEGIN    
     SET @var1 = @tipprof_descricao    
     EXEC ksp_ParametroPesquisa @var1,'t.tipprof_descricao' ,@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END    
    
 IF @locatend_descricao IS NOT NULL    
    BEGIN    
     SET @var1 = @locatend_descricao    
     EXEC ksp_ParametroPesquisa @var1,'l.locatend_descricao',@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END    
    
 IF @locatend_codigo IS NOT NULL    
    BEGIN    
     SET @var1 = @locatend_codigo    
     EXEC ksp_ParametroPesquisa @var1,'pl.locatend_codigo',@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END    
 IF @prof_registro_conselho IS NOT NULL    
    BEGIN							  -- PEGA O CRM EM PROFISSIONAL_REDE
     SET @var1 = @prof_registro_conselho    -- POIS O CRM NÃO APARECE NA ABA DE LOTAÇÃO
     EXEC ksp_ParametroPesquisa @var1,'pl.prof_registro_conselho',@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'') + ' and pl.prof_registro_conselho IS NOT NULL '       
    END
    
 IF @profatvamb IS NOT NULL      
    BEGIN      
       SET @Sql = @Sql + ' and prof_ambulatorio=''' + @profatvamb + ''''         
    END         

IF @cbo_codigo IS NOT NULL  
    BEGIN    
     SET @var1 = @cbo_codigo    
     EXEC ksp_ParametroPesquisa @var1,'pl.cbo_codigo',@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END     

IF @prof_ativo IS NOT NULL  
    BEGIN    
     SET @var1 = @prof_ativo    
     EXEC ksp_ParametroPesquisa @var1,'pl.prof_ativo',@tp_pesq, 't', @par OUTPUT    
       SET @Sql = @Sql + ' and ' + isnull(@par,'')       
    END     
   
 SET @SQL=@SQL + ' order by pr.prof_nome'  
 
 EXEC(@Sql)  
     END  
  
ELSE IF (@opcao = 1) -- Inclusao  
  
     BEGIN  
  
-- select @IdSUS_CBO = id from sus_cbo where codigo = @cbo_codigo  
   
 INSERT INTO Profissional_Lotacao  
            (prof_codigo,  
            tipprof_codigo,  
            locatend_codigo,  
            unid_codigo,  
            atvprof_codigo,  
            prof_ativo,  
            prof_ambulatorio,  			
            prof_medAuditor,  
            prof_cirurgia,  
		    funcir_codigo,  
		    prof_movimenta_prontuario,  
		    prof_permite_agenda,  
		    profchefeclinica,  
		    prof_atend_clinico, 
		    cbo_codigo,  
		    prof_SMS_envio,  
			ProfEnfermeiroChefe,
			Prof_registro_conselho, 			
			prof_UF_registro,
			chefe_laboratorio  		
      )  
            VALUES (@prof_codigo,  
                    @tipprof_codigo,  
                    @locatend_codigo,  
                    @unid_codigo,  
                    null,  
                    @prof_ativo,  
                    @profatvamb,  
                    @prof_medauditor,  
                    @profatvcirurgica,  
					@funcir_codigo,  
					@profmovprontuario,  
					@profpermiteagenda,  
					@profchefeclinica,					 
 					@profatendclinico,
					@cbo_codigo,  
					@prof_SMS_envio,  
					@ProfEnfermeiroChefe,
					@Prof_registro_conselho,					
					@prof_UF_registro,
					@chefe_laboratorio 		
      )   
 select @NomeProfissional = prof_nome  
 from profissional_rede  
 where prof_codigo = @prof_codigo  
  
     END  
  
ELSE IF (@opcao = 2) -- Exclusao Logica (Ativa ou Desativa)  
  
     BEGIN  
 UPDATE profissional_lotacao  
    SET prof_ativo = CASE WHEN @prof_ativo = 'S' THEN 'N'  
                                 WHEN @prof_ativo = 'N' THEN 'S'  
                            END   
         WHERE unid_codigo = @unid_codigo  
           AND prof_codigo = @prof_codigo  
           AND locatend_codigo = @locatend_codigo  
     END  
  
ELSE IF (@opcao = 3) -- Alteracao  
     -- Somente executada se nao houver ocorrencia do Profissional,   
     -- conforme opcao 4 executada pela aplicacao antes desta  
     BEGIN  
       
 --select @IdSUS_CBO = id from sus_cbo where codigo = @cbo_codigo  
       
 UPDATE Profissional_Lotacao  
    SET tipprof_codigo = @tipprof_codigo,  
        cbo_codigo = @cbo_codigo,  
        prof_cirurgia = @profatvcirurgica,                 
        prof_ambulatorio = @profatvamb,  		
        prof_medAuditor = @prof_medAuditor,  
        funcir_codigo = @funcir_codigo,  
        prof_movimenta_prontuario = @profmovprontuario,  
        prof_permite_agenda = @profpermiteagenda,  
        profchefeclinica = @profchefeclinica,
        prof_atend_clinico = @profatendclinico,
        prof_SMS_envio = @prof_SMS_envio,  
		ProfEnfermeiroChefe =	@ProfEnfermeiroChefe,
		Prof_registro_conselho = @Prof_registro_conselho,		
		prof_UF_registro = @prof_UF_registro,
		chefe_laboratorio = @chefe_laboratorio  	
		
     WHERE prof_codigo = @prof_codigo  
     AND locatend_codigo = @locatend_codigo  
  
     END  
  
ELSE IF (@opcao = 4) -- Verifica Existencia de Profissional + Local_Atnedimento  
  
     BEGIN  
  
        DECLARE @existe CHAR(1)  
        SELECT @existe = 'S'  
  
        SELECT @existe = 'N'  
          FROM PROFISSIONAL P  
         WHERE P.PROF_CODIGO = @prof_codigo  
           AND P.LOCATEND_CODIGO = @locatend_codigo  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM AGENDA_PROGRAMACAO A  
                           WHERE A.PROF_CODIGO = P.PROF_CODIGO  
                             AND A.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PEDIDO_INTERNACAO PD  
                           WHERE PD.PROF_CODIGO = P.PROF_CODIGO  
                             AND PD.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM AGENDA_MEDICA AM  
                           WHERE AM.PROF_CODIGO = P.PROF_CODIGO  
                             AND AM.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM AGENDA_CONSULTA AC  
                           WHERE AC.PROF_CODIGO = P.PROF_CODIGO  
                             AND AC.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM AGENDA_CONSULTA_HISTORICO AH  
                           WHERE AH.PROF_CODIGO = P.PROF_CODIGO  
                             AND AH.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM ANATOMIA_PATOLOGICA AP  
                           WHERE AP.PROF_CODIGO = P.PROF_CODIGO  
                             AND AP.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM APAC_ATENDIMENTO AA  
                           WHERE AA.PROF_CODIGO = P.PROF_CODIGO  
                             AND AA.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM APRAZAMENTO AZ  
                           WHERE AZ.PROF_CODIGO = P.PROF_CODIGO  
                             AND AZ.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM ATENDIMENTO_AMBULATORIAL ATA  
                           WHERE ATA.PROF_CODIGO = P.PROF_CODIGO  
                             AND ATA.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM ATENDIMENTO_EMERGENCIA AE  
                           WHERE AE.PROF_CODIGO = P.PROF_CODIGO  
                             AND AE.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM CITOLOGIA_GERAL CG  
                           WHERE CG.PROF_CODIGO = P.PROF_CODIGO  
                             AND CG.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM EQUIPE_CIRURGICA EC  
               WHERE EC.PROF_CODIGO = P.PROF_CODIGO  
                             AND EC.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM EVOLUCAO EV  
                           WHERE EV.PROF_CODIGO = P.PROF_CODIGO  
                             AND EV.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM FILME_UTILIZADO FU  
                           WHERE FU.PROF_CODIGO = P.PROF_CODIGO  
                             AND FU.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PEDIDO_ANATOMIA_PATOLOGICA PAP  
                           WHERE PAP.PROF_CODIGO = P.PROF_CODIGO  
                             AND PAP.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PEDIDO_EXAME_RADIOLOGICO PER  
                           WHERE PER.PROF_CODIGO = P.PROF_CODIGO  
                             AND PER.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PRE_ANESTESIA_AVALIACAO PAA  
                           WHERE PAA.PROF_CODIGO = P.PROF_CODIGO  
                             AND PAA.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PRE_ANESTESIA_PRESCRICAO PAN  
                           WHERE PAN.PROF_CODIGO = P.PROF_CODIGO  
                             AND PAN.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PRESCRICAO_MEDICA PM  
                           WHERE PM.PROF_CODIGO = P.PROF_CODIGO  
                             AND PM.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM PROCEDIMENTOS_REALIZADOS PR  
                           WHERE PR.PROF_CODIGO = P.PROF_CODIGO  
                             AND PR.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM RESULTADO_EXAME_PATOLOGICO REP  
                           WHERE REP.PROF_CODIGO = P.PROF_CODIGO  
                             AND REP.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM RESULTADO_EXAME_RADIOLOGICO RER  
                           WHERE RER.PROF_CODIGO = P.PROF_CODIGO  
                             AND RER.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM RESUMO_ALTA RA  
                           WHERE RA.PROF_CODIGO = P.PROF_CODIGO  
                             AND RA.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
           AND NOT EXISTS(SELECT PROF_CODIGO  
                            FROM SOLICITACAO_CIRURGIA SC  
                           WHERE SC.PROF_CODIGO = P.PROF_CODIGO  
                             AND SC.LOCATEND_CODIGO = P.LOCATEND_CODIGO)  
  
        SELECT @existe EXISTE  
          
     END  
  
ELSE IF (@opcao = 5) -- Lista de profissionais lotados que possuem atendimento ambulatorial  
  
     BEGIN  
  
		 SELECT DISTINCT pl.prof_codigo, pr.prof_nome  
		 FROM    
		  profissional_rede pr,   
		  profissional_lotacao pl,   
		  vwlocal_unidade l  
		 WHERE   
		  pl.prof_codigo = pr.prof_codigo   
		  AND pl.locatend_codigo = l.locatend_codigo  
		  AND pl.unid_codigo = @unid_codigo  
		  and exists (SELECT TOP 1 *   
			FROM atendimento_ambulatorial aa   
			WHERE aa.prof_codigo = pr.prof_codigo and aa.locatend_codigo = pl.locatend_codigo)  
		 order by pr.prof_nome  
  
     END  
  
ELSE IF (@opcao = 6) -- Lista de profissionais lotados que possuem atendimento com internacao  
  
     BEGIN  
  
		 SELECT DISTINCT pl.prof_codigo, pr.prof_nome  
		 FROM    
		  profissional_rede pr,   
		  profissional_lotacao pl,   
		  vwlocal_unidade l  
		 WHERE   
		  pl.prof_codigo = pr.prof_codigo   
		  AND pl.locatend_codigo = l.locatend_codigo  
		  AND pl.unid_codigo = @unid_codigo  
		 and exists (SELECT TOP 1 *   
		   FROM internacao i   
		   WHERE i.prof_codigo = pr.prof_codigo and i.locatend_codigo = pl.locatend_codigo)  
		  
		 order by pr.prof_nome  
  
     END   
  
  
-- eLocaliza Medico Auditor ou Chefe Clinica ---------------------------------------------------------------------------  
  
ELSE IF (@opcao = 7)   
begin  
        SET @SQL = ' SELECT  PR.prof_codigo, ' +   
                   '  PR.prof_nome, ' +   
                   '  PR.prof_cpf ' +   
  
                   ' FROM profissional_rede PR' +   
                   ' WHERE   exists (SELECT  1' +  
                   '   FROM  profissional_lotacao PL ' +  
                   '   WHERE  PR.prof_codigo      = PL.prof_codigo ' +   
                   '   AND  PL.prof_ativo       = ''S''' +  
                   '   AND PL.tipprof_codigo   = ''0001'''   
  
  
 IF @prof_medAuditor IS NOT NULL    
  SET @SQL = @SQL + ' AND PL.prof_medAuditor  = ''' + @prof_medAuditor + ''')'  
  
 IF @profchefeclinica IS NOT NULL    
  SET @SQL = @SQL + ' AND PL.profchefeclinica  = ''' + @profchefeclinica + ''')'  
  
 IF @prof_medAuditor IS NULL AND @profchefeclinica IS NULL   
  SET @SQL = @SQL + ')'  
  
 IF @prof_codigo IS NOT NULL  
 begin  
  SET @var1 = @prof_codigo  
      EXEC ksp_ParametroPesquisa @var1, 'PR.prof_codigo', @tp_pesq, 't', @par OUTPUT  
  SET @Sql = @Sql + ' AND ' + @par  
 end  
  
 IF @prof_nome IS NOT NULL  
 begin  
  SET @var1 = @prof_nome  
         EXEC ksp_ParametroPesquisa @var1,'PR.prof_nome' ,@tp_pesq, 't', @par OUTPUT  
  SET @Sql = @Sql + ' AND ' + @par  
 end  
  
 IF @prof_cpf IS NOT NULL  
 begin  
  SET @var1 = @prof_cpf  
         EXEC ksp_ParametroPesquisa @var1,'PR.prof_cpf' ,@tp_pesq, 't', @par OUTPUT  
  SET @Sql = @Sql + ' AND ' + @par  
 end  
  
 EXEC(@Sql)  
end  
  
else IF @opcao = 8  -- Consulta Profissional Por Numero do conselho ou Nome  
  
     BEGIN  
        SET @SQL = 'SELECT pl.prof_codigo, ' +  
                   '       pl.unid_codigo, ' +  
                   '       pr.prof_nome, ' +  
                   '       pl.tipprof_codigo, ' +  
                   '       t.tipprof_descricao, ' +  
                   '       pl.locatend_codigo, ' +  
                   '       l.locatend_descricao,  ' +  
                   '       pl.prof_registro_conselho as prof_num_conselho, ' +  
                   '       pr.usu_codigo, pl.prof_SMS_envio ' +  
                   '  FROM profissional_rede pr ' +  
                   '       inner join profissional_lotacao pl on pl.prof_codigo = pr.prof_codigo ' +  
                   '       inner join vwlocal_unidade l on pl.locatend_codigo = l.locatend_codigo ' +  
                   '       inner join tipo_profissional t on pl.tipprof_codigo = t.tipprof_codigo ' +  
                   '       left join tb_ocupacao a on pl.cbo_codigo = a.co_ocupacao ' +  
                   '       left join funcao_cirurgica fc on fc.funcir_codigo = pl.funcir_codigo ' +  
  
                   ' WHERE  pl.unid_codigo = ''' + @unid_codigo + ''''  
  
 IF @prof_nome IS NOT NULL  
    BEGIN  
     SET @var1 = @prof_nome  
            EXEC ksp_ParametroPesquisa @var1,' and pr.prof_nome' ,@tp_pesq, 't', @par OUTPUT  
     SET @Sql = @Sql + isnull(@par,'')  
    END  
  
 IF @locatend_codigo IS NOT NULL  
    BEGIN  
     SET @var1 = @locatend_codigo  
     EXEC ksp_ParametroPesquisa @var1,' and pl.locatend_codigo',@tp_pesq, 't', @par OUTPUT  
     SET @Sql = @Sql + isnull(@par,'')  
    END  
  
 IF @prof_registro_conselho IS NOT NULL  
    BEGIN  
     SET @var1 = @prof_registro_conselho  
     EXEC ksp_ParametroPesquisa @var1,' and pl.prof_registro_conselho',@tp_pesq, 't', @par OUTPUT  
     SET @Sql = @Sql + isnull(@par,'')  
    END  
  
 EXEC(@Sql)  
     END  
  
else IF @opcao = 9  -- Consulta Profissional com usuário  
     BEGIN  
  
		  SELECT DISTINCT pl.prof_codigo, pr.prof_nome  
		  FROM    
		   profissional_rede pr,   
		   profissional_lotacao pl,   
		   vwlocal_unidade l  
		  WHERE   
		   pl.prof_codigo = pr.prof_codigo   
		   AND pl.locatend_codigo = l.locatend_codigo  
		   AND pl.unid_codigo = @unid_codigo  
		   AND pr.usu_codigo is not null  
		  
		  order by pr.prof_nome  
  
     END

else IF @opcao in (10,11)
BEGIN
	SELECT distinct pl.prof_codigo,   
		pr.prof_nome
	FROM profissional_rede pr   
		inner join profissional_lotacao pl on pl.prof_codigo = pr.prof_codigo   
		inner join vwlocal_unidade l on pl.locatend_codigo = l.locatend_codigo   
		inner join tipo_profissional t on pl.tipprof_codigo = t.tipprof_codigo   
		left join tb_ocupacao a on pl.cbo_codigo = a.co_ocupacao   
		left join funcao_cirurgica fc on fc.funcir_codigo = pl.funcir_codigo   
  		left join local_atendimento la on la.locatend_codigo = l.locatend_codigo 					
			AND la.unid_codigo = l.unid_codigo 
	WHERE  pl.unid_codigo =  @unid_codigo
	
		and (@prof_codigo is null or pl.prof_codigo like '%' + rtrim(@prof_codigo) + '%')
		and (@prof_nome is null or pr.prof_nome like '%' + rtrim(@prof_nome) + '%')
		and (@tipprof_descricao is null or t.tipprof_descricao like '%' + rtrim(@tipprof_descricao) + '%')
		and (@locatend_descricao is null or l.locatend_descricao like '%' + rtrim(@locatend_descricao) + '%')
		and (@locatend_codigo is null or pl.locatend_codigo like '%' + rtrim(@locatend_codigo) + '%')
		and (@prof_registro_conselho is null or (pl.prof_registro_conselho like '%' + rtrim(@prof_registro_conselho) + '%' and pl.prof_registro_conselho IS NOT NULL))
		and (@profatvamb is null or prof_ambulatorio = @profatvamb)
		and (@cbo_codigo is null or pl.cbo_codigo like '%' + rtrim(@cbo_codigo) + '%')
		and (@prof_ativo is null or pl.prof_ativo = @prof_ativo)
	order by pr.prof_nome
END 
else if @opcao = 12
BEGIN
	SELECT distinct pr.prof_nome, 
	   pr.prof_codigo, pr.prof_cns 		
	from
		profissional_rede pr join profissional_lotacao pl on pr.prof_codigo = pl.prof_codigo
	where
		pl.unid_codigo = @unid_codigo 
		and (@prof_nome is null or pr.prof_nome like rtrim(@prof_nome) + '%')
		and pl.prof_medAuditor = 'S' 	
END
else if @opcao = 13
BEGIN
	select locatend_codigo, locatend_descricao from
	vwLocal_Atendimento vla where
	vla.locatend_codigo in (
		select locatend_codigo from agenda_consulta  
		where CONVERT(VARCHAR(10),agd_datahora ,103) = CONVERT(VARCHAR(10),GETDATE(),103)
		group by locatend_codigo)
	order by locatend_descricao
END
else if @opcao = 14
Begin
	SELECT distinct pl.prof_codigo, pl.unid_codigo, pr.prof_nome, pl.tipprof_codigo, t.tipprof_descricao, pl.locatend_codigo, l.locatend_descricao,pl.prof_registro_conselho AS prof_numconselho,
	       pl.prof_cirurgia, pl.prof_ambulatorio, pl.chefe_laboratorio, pl.prof_ativo, pl.prof_medAuditor, pl.funcir_codigo, pl.prof_movimenta_prontuario, pl.prof_permite_agenda,
		   fc.funcir_descricao, pl.profchefeclinica, pl.prof_atend_clinico, pl.CBO_codigo, a.no_ocupacao AS CBO_descricao, pr.usu_codigo, pl.prof_SMS_envio, pl.ProfEnfermeiroChefe,
		   pl.Prof_registro_conselho, pr.Prof_cns, la.setcli_codigo,
	      (select oec.orgem_descricao from Orgao_Emissor_Conselho oec join Tipo_Profissional tp on oec.orgem_codigo = tp.orgem_codigo where tp.tipprof_codigo = pl.tipprof_codigo) as orgao_emissor_conselho, 
	       pl.prof_UF_registro,  la.set_codigo, la.setcli_codigo
	FROM profissional_rede pr 
	inner join profissional_lotacao pl on pl.prof_codigo = pr.prof_codigo 
	inner join vwlocal_unidade l on pl.locatend_codigo = l.locatend_codigo 
	inner join tipo_profissional t on pl.tipprof_codigo = t.tipprof_codigo 
	inner join ParametroCboRadiologia pcr on pcr.CodigoCbo = pl.cbo_codigo
	left join tb_ocupacao a on pl.cbo_codigo = a.co_ocupacao   
	left join funcao_cirurgica fc on fc.funcir_codigo = pl.funcir_codigo
	left join local_atendimento la on la.locatend_codigo = l.locatend_codigo AND la.unid_codigo = l.unid_codigo
	WHERE  pl.unid_codigo = @unid_codigo 
	and	   pl.prof_codigo = @prof_codigo
end
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
PRINT N'Altering [dbo].[ksp_evolucao_impresso]...';


GO
ALTER PROCEDURE [dbo].[ksp_evolucao_impresso]
@inter_codigo CHAR (12), @upa_evo_codigo VARCHAR (20)=null
AS
SELECT 
		E.UPAEVO_CODIGO	
		,E.UPAEVO_DATAHORA	
		,E.UPAEVO_DESCRICAO	
		,ltrim(rtrim(P.PROF_NOME)) +' - '+ tp.tipprof_descricao as PROF_NOME 		
		,la.LocAtend_descricao
		, LTRIM(RTRIM(E.CID_CODIGO_PRIMARIO)) + ' - ' + CID1.CID_DESCRICAO AS CID_PRIMARIO
	    , LTRIM(RTRIM(E.CID_CODIGO_SECUNDARIO)) + ' - '+ CID2.CID_DESCRICAO AS CID_SECUNDARIO
		,upaevo_pa
		,upaevo_pulso
		,upaevo_frequencia_respiratoria
		,upaevo_temperatura
		,upaevo_satO2
		,upaevo_hgt
		,pr.no_procedimento
		,DATEDIFF(day,i.inter_datainter,E.UPAEVO_DATAHORA) AS dias_internacao
		,tp.tipprof_descricao
		,p.prof_numconselho
		, case when e.cid_codigo_primario <> (select top 1 e1.cid_codigo_primario
			from upa_evolucao e1 
			where e1.inter_codigo = e.inter_codigo and e1.upaevo_codigo < e.upaevo_codigo
			order by e1.upaevo_codigo desc)
		  or (e.upaevo_codigo = (select min(upaevo_codigo) from upa_evolucao e1 where e1.inter_codigo = e.inter_codigo)	
				and e.cid_codigo_primario <> (select top 1 cidpri_codigo from internacao_procedimento_cid ip where ip.inter_codigo = e.inter_codigo and upaevo_codigo is null order by procid_datahora desc))
		  then 1 else 0 end as mudou_cid
		  ,isnull(E.Rascunho,0) as Rascunho
	FROM 
		UPA_EVOLUCAO E
		inner join internacao i on e.inter_codigo = i.inter_codigo
		left JOIN PROFISSIONAL P ON (P.PROF_CODIGO = E.PROF_CODIGO AND P.LOCATEND_CODIGO = E.LOCATEND_CODIGO)
		left JOIN vwLocal_Unidade la ON (la.LOCATEND_CODIGO = P.LOCATEND_CODIGO)
		LEFT JOIN CID_10 CID1 ON (CID1.CID_CODIGO = E.CID_CODIGO_PRIMARIO)
		LEFT JOIN CID_10 CID2 ON (CID2.CID_CODIGO = E.CID_CODIGO_SECUNDARIO)
		left join tb_procedimento pr on (pr.co_procedimento = e.proc_codigo)
		left join tipo_profissional tp on (p.tipprof_codigo = tp.tipprof_codigo)
	WHERE
		(@inter_codigo is not null and (@upa_evo_codigo is null or @upa_evo_codigo = '') and E.INTER_CODIGO = @INTER_CODIGO) or (@upa_evo_codigo is not null and @upa_evo_codigo <> '' and e.upaevo_codigo = convert(int, @upa_evo_codigo))
	ORDER BY e.UPAEVO_DATAHORA desc

------------------------------------------------------------------------------------------

if (@@ERROR <> 0)
      	BEGIN
         	RAISERROR('ERRO - ksp_Evolucao_Historico',1,1)
         	
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
PRINT N'Altering [dbo].[ksp_Paciente]...';


GO
  
ALTER PROCEDURE [dbo].[ksp_Paciente]    
@Opcao INT, @Pac_Codigo CHAR (12)=null, @Unid_Codigo CHAR (4), @Pac_Nome VARCHAR (50)=null, @Rel_Codigo CHAR (4), @Cep_Sequencial CHAR (6), @Pac_Nacionalidade CHAR (4), @Pac_Pai CHAR (50), @Pac_Mae VARCHAR (50)=null, @Pac_Nascimento CHAR (10)=null, @Pac_Sexo CHAR (1),  
 @Pac_Raca INT, @Pac_Etnia CHAR (4)=null, @Pac_Naturalidade CHAR (7), @Pac_Telefone CHAR (20), @Pac_Tipo_Documento CHAR (1), @Pac_Numero_Documento CHAR (15), @Pac_Orgao_Emissor CHAR (20), @Pac_Emissao_Documento CHAR (10),  
 @Pac_Escolaridade VARCHAR (50), @Pac_Prontuario CHAR (10)=null, @Pac_Responsavel CHAR (50), @Pac_Telefone_Responsavel CHAR (20), @Pac_Email CHAR (30), @Pac_Observacao TEXT, @Pac_Local_Posse CHAR (4), @Pac_Ativo CHAR (1), @Pac_Data_Matricula CHAR (10), @Pac_Endereco_Num CHAR (5), @Pac_Endereco_Compl CHAR (20), @Pac_CPF CHAR (11)=null, @Pac_Foto CHAR (25), @Pac_DtMatricula CHAR (10), @Pac_Esmeralda CHAR (8), @Pac_Idade INT, @Tp_pesq INT, @Pac_Cartao_NSaude CHAR (15)=NULL, @Pac_Cartao_NDSTAIDS CHAR (20)=NULL,   
@PAC_STATUS CHAR (1)=NULL, @Pac_Numero_PID VARCHAR (8)=NULL, @EstCivil INT=NULL, @PAC_ULTIMAALTEARACAO CHAR (50)=NULL, @usu_codigo CHAR (4)=null, @PAC_CertidaoNascimento CHAR (1)=NULL, @dt_obito SMALLDATETIME=null, @Pac_Cartao_NSaude_Provisorio CHAR (15)=NULL,  
 @Pac_Unidref_Codigo CHAR (4)=NULL, @Prof_origem_codigo CHAR (4)=NULL, @Pac_Causa_Mortis VARCHAR (50)=null, @Pac_Celular CHAR (20)=NULL, @Pac_Tipo_Idade CHAR (1)=NULL, @Pac_CNES CHAR (7)=null, @PAC_SIS_PRENATAL VARCHAR (12)=NULL,   
 @Pac_Paccns_Identidade_Numero VARCHAR (13)=null, @Pac_CMS CHAR (15)=null, @Pac_DT_UltimaAlteracao SMALLDATETIME=null, @Pac_Telefone2 CHAR (20)=null, @Pac_Gestante CHAR (1)=NULL, @Pac_Fator_Rh CHAR (1)=NULL, @Pac_Possui_Documento CHAR (1)=NULl, @Pac_Grupo_Sanguineo VARCHAR (2)=NULL,   
 @Pac_obito CHAR (1)=NULL, @Pesquisa_dt_inicial DATETIME=null, @Pesquisa_dt_final DATETIME=null, @DATA_RETROATIVA SMALLDATETIME=null, @pac_justificativa CHAR (40)=NULL, @pac_obs_telefone VARCHAR (100)=NULL, @pac_justificativa_resp VARCHAR (60)=NULL,   
 @Pac_CPF_Responsavel CHAR (11)=null, @Pac_Nome_Social VARCHAR (70)=null    
AS    
set nocount on      
              
DECLARE @Data CHAR(8)              
DECLARE @UltCodigo CHAR(12)              
Declare @lSql varchar(2048)              
DECLARE @PAC_PRONTUARIO_MAX INT              
DECLARE @UsuarioUltimaAlteracao varchar(100)              
DECLARE @par  Varchar(2055)              
      
DECLARE @UNID_GESTORA CHAR(4)              
DECLARE @CADASTROPROVISORIO CHAR(1)              
DECLARE @CADASTROPROPRIO CHAR(1)              
DECLARE @ENVIO CHAR(1)              
DECLARE @Pac_Cartao_NSaude_Provisorio_Data SMALLDATETIME              
          
if @usu_codigo is not null          
 select @PAC_ULTIMAALTEARACAO = usu_nome from usuario where usu_codigo = @usu_codigo              
----------------------------- Selecao para Carga dos Dados ------------------------------------              
              
If @Opcao = 0              
 Begin              
              
  SELECT  TOP 1 P.Pac_Codigo, P.Unid_Codigo, P.Pac_Nome, P.pac_nome_social,P.Rel_Codigo,P.Cep_Sequencial,               
   P.Pac_Nacionalidade,P.Pac_Pai,P.Pac_Mae,P.Pac_Nascimento,P.Pac_Sexo,               
   P.raca_codigo,P.etnia_codigo, P.Pac_Naturalidade,P.Pac_Telefone,P.Pac_Telefone2, P.Pac_Tipo_Documento,               
   P.Pac_Numero_Documento,P.Pac_Orgao_Emissor,P.Pac_Emissao_Documento,               
   P.Pac_Escolaridade,PP.Pac_Prontuario_Numero Pac_Prontuario,P.Pac_Responsavel,               
   P.Pac_Telefone_Responsavel,P.Pac_Email,P.Pac_Observacao,               
   P.Pac_Local_Posse,P.Pac_Ativo,P.Pac_Data_Matricula,               
   P.Pac_Endereco_Num,P.Pac_Endereco_Compl,P.Pac_CPF,P.Pac_Foto,               
   P.Pac_DtMatricula,P.Pac_Esmeralda,P.Pac_Idade,               
   Re.Rel_Descricao,               
   M.Mun_Descricao,             
   M.cod_ibge,  
   UF.Uf_Codigo,                
   UF.Uf_Descricao,               
   PA.Pai_Descricao,                  UN.Unid_Descricao,               
   la.locatend_descricao LocAtend_Descricao,              
   P.Pac_DtObito,              
   R.raca_desc,              
   P.pac_cartao_nsaude,              
   P.pac_cartao_ndstaids,              
   P.Pac_Numero_PID,              
   P.PAC_ULTIMAALTEARACAO UltimoAlteracao,              
   P.estcivil_codigo,              
   P.PAC_CertidaoNascimento,              
   P.PAC_STATUS_CADASTRO,              
   P.pac_cartao_nsaude_provisorio,          
   P.pac_cartao_nsaude_provisorio_data,          
   P.Pac_Unidref_Codigo,               
   Ur.UnidRef_Descricao,              
   P.Pac_Causa_Mortis,              
   P.Prof_origem_codigo,            
   P.Pac_Celular,          
   P.usu_codigo,        
   P.Pac_tipo_Idade,        
   PAC_SIS_PRENATAL,        
   PACCNS.paccns_identidade_numero as Paccns_Identidade_Numero,                    
   p.Pac_Possui_Documento,                     
   P.Pac_Grupo_Sanguineo,                    
   p.Pac_Gestante,                    
   p.Pac_Fator_Rh    ,                  
   p.pac_obito  ,                
   PIM.PacIdMun_Codigo,    
   p.pac_justificativa  ,    
   p.pac_obs_telefone  ,    
   p.pac_justificativa_resp,    
   p.Pac_CPF_Responsavel,
   B.bai_codigo,
   B.bai_descricao
  FROM  ((((((((Paciente p LEFT JOIN Unidade un ON un.unid_codigo = IsNUll(@UNID_CODIGO,p.unid_codigo) AND p.unid_codigo = un.unid_codigo)              
   LEFT JOIN vwLocal_unidade LA ON p.pac_local_Posse = La.locatend_Codigo))              
   LEFT JOIN Municipio M ON p.pac_naturalidade = m.mun_codigo)              
   LEFT JOIN Bairro B ON M.mun_codigo = B.mun_codigo )              
   LEFT JOIN unidade_federativa UF ON m.uf_codigo = Uf.uf_codigo)              
   LEFT JOIN Pais Pa ON P.Pac_Nacionalidade = PA.Pai_Codigo)              
   LEFT JOIN raca r ON p.raca_codigo = r.raca_codigo)              
   LEFT JOIN Religiao Re ON p.rel_codigo = re.rel_codigo              
   LEFT JOIN Paciente_Prontuario pp ON p.pac_codigo = pp.pac_codigo and pp.unid_codigo = @unid_codigo              
   LEFT JOIN EstadoCivil estcivil ON p.estcivil_codigo = estcivil.estcivil_codigo              
                        LEFT JOIN Unidade_referencia Ur ON  Ur.Unidref_Codigo = P.Pac_Unidref_Codigo               
   LEFT JOIN PACIENTE_CNS PACCNS ON PACCNS.PAC_CODIGO = P.PAC_CODIGO        
   LEFT JOIN Paciente_Identificacao_Municipio PIM ON PIM.Pac_Codigo = P.Pac_Codigo                           
  WHERE  p.pac_codigo = @pac_codigo    
 AND P.UNID_CODIGO = ISNULL(@UNID_CODIGO, P.UNID_CODIGO)              
 End              
              
------------------------------------ Inclusao dos Dados ---------------------------------------              
              
If @Opcao = 1              
              
 Begin              
  if (@Pac_Cartao_NSaude_Provisorio IS NOT NULL)              
     begin              
   set @Pac_Cartao_NSaude_Provisorio_Data = getdate()              
     end              
             
  set @Pac_DT_UltimaAlteracao = getdate()          
          
  IF @pac_nome is not null       
  begin      
     set @pac_nome = ltrim(rtrim(@pac_nome))      
  while charindex('  ',@pac_nome  ) > 0       
  begin          
   set @pac_nome = replace(@pac_nome, '  ', ' ')       
  end       
  end      
          
  IF @Pac_Mae is not null       
  begin      
     set @Pac_Mae = ltrim(rtrim(@Pac_Mae))      
  while charindex('  ',@Pac_Mae  ) > 0       
  begin          
   set @Pac_Mae = replace(@Pac_Mae, '  ', ' ')       
  end       
  end      
      
  INSERT INTO Paciente              
   (Pac_Codigo,Unid_Codigo,Pac_Nome,Rel_Codigo,Cep_Sequencial,              
   Pac_Nacionalidade,Pac_Pai,Pac_Mae,Pac_Nascimento,Pac_Sexo,              
   raca_codigo,etnia_codigo, Pac_Naturalidade,Pac_Telefone,Pac_Telefone2, Pac_Celular,Pac_Tipo_Documento,              
   Pac_Numero_Documento,Pac_Orgao_Emissor,Pac_Emissao_Documento,              
   Pac_Escolaridade,Pac_Responsavel,Pac_Telefone_Responsavel,              
   Pac_Email,Pac_Observacao,Pac_Local_Posse,Pac_Ativo,Pac_Data_Matricula,              
   Pac_Endereco_Num,Pac_Endereco_Compl,Pac_CPF,Pac_Foto,Pac_DtMatricula,              
   Pac_Esmeralda,Pac_Idade,Pac_Cartao_NSaude,Pac_Cartao_NDSTAIDS, estcivil_codigo,               
   PAC_STATUS_CADASTRO, PAC_ULTIMAALTEARACAO, PAC_CertidaoNascimento, pac_datahora, Pac_Cartao_NSaude_Provisorio,              
   Pac_Cartao_NSaude_Provisorio_Data, Pac_Unidref_Codigo,Prof_origem_codigo, usu_codigo, Pac_Tipo_Idade,PAC_SIS_PRENATAL, pac_gestante,                
   pac_fator_rh,pac_grupo_sanguineo, Pac_Possui_Documento, pac_obito, pac_dt_ultima_alteracao, p.pac_justificativa, p.pac_obs_telefone, p.pac_justificativa_resp,    
   Pac_CPF_Responsavel, pac_nome_social)                 
  VALUES               
   (@Pac_Codigo,@Unid_Codigo,@Pac_Nome,@Rel_Codigo,@Cep_Sequencial,              
   @Pac_Nacionalidade,@Pac_Pai,@Pac_Mae,@Pac_Nascimento,@Pac_Sexo,              
   @Pac_Raca,@Pac_Etnia, @Pac_Naturalidade,@Pac_Telefone,@Pac_Telefone2,@Pac_Celular,@Pac_Tipo_Documento,              
   @Pac_Numero_Documento,@Pac_Orgao_Emissor,@Pac_Emissao_Documento,              
   @Pac_Escolaridade,@Pac_Responsavel,@Pac_Telefone_Responsavel,              
   @Pac_Email,@Pac_Observacao,@Pac_Local_Posse,@Pac_Ativo,@Pac_Data_Matricula,              
   @Pac_Endereco_Num,@Pac_Endereco_Compl,@Pac_CPF,@Pac_Foto,@Pac_DtMatricula,              
   @Pac_Esmeralda,@Pac_Idade,@Pac_Cartao_NSaude,@Pac_Cartao_NDSTAIDS, @EstCivil,               
   @PAC_STATUS, @PAC_ULTIMAALTEARACAO, @PAC_CertidaoNascimento, GETDATE(), @Pac_Cartao_NSaude_Provisorio,              
   @Pac_Cartao_NSaude_Provisorio_Data, @Pac_Unidref_Codigo,@Prof_origem_codigo, @usu_codigo,  @Pac_Tipo_Idade, @PAC_SIS_PRENATAL, @pac_gestante,                
   @pac_fator_rh,@pac_grupo_sanguineo,@Pac_Possui_Documento, @pac_obito, @Pac_DT_UltimaAlteracao, @pac_justificativa, @pac_obs_telefone, @pac_justificativa_resp,    
   @Pac_CPF_Responsavel, @Pac_Nome_Social)    
      
if (@Pac_CMS is not null)      
   begin      
    declare @COD_IBGE_CMS varchar(7)       
    set @COD_IBGE_CMS = (select mun_codigo from cep      
            inner join unidade      
             on unidade.cep_sequencial = cep.cep_sequencial      
           where unid_codigo = @Unid_Codigo);      
    IF (@COD_IBGE_CMS IS NOT NULL)      
  INSERT INTO Paciente_Identificacao_Municipio (PacIdMun_Codigo,pac_codigo,cod_ibge) VALUES (@Pac_CMS, @PAC_CODIGO, @COD_IBGE_CMS);       
   end      
       
 IF(@PAC_PRONTUARIO IS NOT NULL)              
   BEGIN              
     INSERT INTO Paciente_Prontuario (Pac_Codigo,Unid_Codigo,Pac_Prontuario_Numero, usu_codigo)              
     VALUES (@PAC_CODIGO,@UNID_CODIGO,@PAC_PRONTUARIO, @usu_codigo)              
   END              
            
 END              
              
------------------------------------ Alteracao dos Dados ---------------------------------------              
              
If @Opcao = 2              
              
Begin              
 IF (@Pac_Cartao_NSaude_Provisorio IS NOT NULL)              
 BEGIN              
        SELECT Pac_Cartao_NSaude_Provisorio              
        FROM PACIENTE              
        WHERE Pac_Cartao_NSaude_Provisorio_Data is null              
           AND PAC_CODIGO=@Pac_Codigo              
           AND UNID_CODIGO=@unid_codigo              
               
        if(@@rowcount>0)              
           begin              
              set @Pac_Cartao_NSaude_Provisorio_Data = getdate()              
           end              
 END              
       set @Pac_DT_UltimaAlteracao = getdate()             
      
      
  IF @pac_nome is not null       
  begin      
     set @pac_nome = ltrim(rtrim(@pac_nome))      
  while charindex('  ',@pac_nome  ) > 0       
  begin          
   set @pac_nome = replace(@pac_nome, '  ', ' ')       
  end       
  end      
               
  IF @Pac_Mae is not null       
  begin      
     set @Pac_Mae = ltrim(rtrim(@Pac_Mae))      
  while charindex('  ',@Pac_Mae  ) > 0       
  begin          
   set @Pac_Mae = replace(@Pac_Mae, '  ', ' ')       
  end       
  end      
      
 UPDATE  Paciente SET    
 Pac_Nome = @Pac_Nome,Rel_Codigo = @Rel_Codigo,              
 Cep_Sequencial = @Cep_Sequencial,      
 Pac_Nacionalidade = @Pac_Nacionalidade,              
 Pac_Pai = @Pac_Pai,      
 Pac_Mae = @Pac_Mae,Pac_Nascimento = @Pac_Nascimento,              
 Pac_Sexo = @Pac_Sexo,      
 raca_codigo = @Pac_Raca,              
 etnia_codigo = @Pac_Etnia,       
 Pac_Naturalidade = @Pac_Naturalidade,              
 Pac_Telefone = @Pac_Telefone,      
 Pac_Celular = @Pac_Celular,            
 Pac_Telefone2 = @Pac_Telefone2,        
 Pac_Tipo_Documento = @Pac_Tipo_Documento,              
 Pac_Numero_Documento = @Pac_Numero_Documento,              
 Pac_Orgao_Emissor = @Pac_Orgao_Emissor,              
 Pac_Emissao_Documento = @Pac_Emissao_Documento,              
 Pac_Escolaridade = @Pac_Escolaridade,      
 --Pac_Prontuario = @Pac_Prontuario,              
 Pac_Responsavel = @Pac_Responsavel,      
 Pac_Telefone_Responsavel = @Pac_Telefone_Responsavel,              
 Pac_Email = @Pac_Email,       
 Pac_Observacao = @Pac_Observacao,              
 Pac_Local_Posse = @Pac_Local_Posse,      
 Pac_Ativo = @Pac_Ativo,              
 Pac_Data_Matricula = @Pac_Data_Matricula,              
 Pac_Endereco_Num = @Pac_Endereco_Num,              
 Pac_Endereco_Compl = @Pac_Endereco_Compl,      
 Pac_CPF = @Pac_CPF,              
 Pac_Foto = @Pac_Foto,Pac_DtMatricula = @Pac_DtMatricula,              
 Pac_Esmeralda = @Pac_Esmeralda,      
 Pac_Idade = @Pac_Idade,              
 Pac_Cartao_NSaude = @Pac_Cartao_NSaude,              
 Pac_Cartao_NDSTAIDS = @Pac_Cartao_NDSTAIDS,              
 Pac_Numero_PID = @Pac_Numero_PID,              
 Estcivil_codigo = @EstCivil,              
 PAC_ULTIMAALTEARACAO = @PAC_ULTIMAALTEARACAO,              
 PAC_CertidaoNascimento = @PAC_CertidaoNascimento,              
 Pac_Cartao_NSaude_Provisorio = @Pac_Cartao_NSaude_Provisorio,              
 Pac_Unidref_Codigo = @Pac_Unidref_Codigo,               
 Pac_Cartao_NSaude_Provisorio_Data = @Pac_Cartao_NSaude_Provisorio_Data,             
 Prof_origem_codigo=@Prof_origem_codigo  ,          
 usu_codigo   = @usu_codigo  ,        
 Pac_Tipo_Idade =  @Pac_Tipo_Idade,        
 PAC_SIS_PRENATAL=@PAC_SIS_PRENATAL,        
 Pac_Possui_Documento = @Pac_Possui_Documento,      
 pac_obito = @pac_obito,                    
 pac_gestante=@pac_gestante,                   
 pac_fator_rh=@pac_fator_rh,                
 pac_grupo_sanguineo=@pac_grupo_sanguineo,              
 pac_dt_ultima_alteracao = @Pac_DT_UltimaAlteracao,    
 pac_justificativa = @pac_justificativa,     
 pac_obs_telefone = @pac_obs_telefone,     
 pac_justificativa_resp = @pac_justificativa_resp,    
 Pac_CPF_Responsavel = @Pac_CPF_Responsavel,    
 pac_nome_social = @Pac_Nome_Social    
 WHERE Pac_Codigo = @Pac_Codigo              
              
        IF(@PAC_PRONTUARIO IS NOT NULL)              
           BEGIN              
              SELECT PAC_PRONTUARIO_NUMERO              
              FROM   PACIENTE_PRONTUARIO              
              WHERE PAC_CODIGO=@Pac_Codigo              
                 AND UNID_CODIGO=@unid_codigo              
          
              if(@@rowcount>0)              
                 begin              
                   UPDATE PACIENTE_PRONTUARIO SET PAC_PRONTUARIO_NUMERO=@PAC_PRONTUARIO              
                   WHERE PAC_CODIGO=@Pac_Codigo              
                    AND UNID_CODIGO=@unid_codigo              
                end              
               else              
                 begin              
                    INSERT INTO Paciente_Prontuario (Pac_Codigo,Unid_Codigo,Pac_Prontuario_Numero, usu_codigo)              
                       VALUES (@PAC_CODIGO,@UNID_CODIGO,@PAC_PRONTUARIO, @usu_codigo)              
                 end              
           END              
        ELSE              
          BEGIN              
              SELECT PAC_PRONTUARIO_NUMERO              
              FROM   PACIENTE_PRONTUARIO              
              WHERE PAC_CODIGO=@Pac_Codigo              
       AND UNID_CODIGO=@unid_codigo              
                     
              if(@@rowcount>0)              
                 begin              
                    DELETE FROM PACIENTE_PRONTUARIO              
                    WHERE PAC_CODIGO=@Pac_Codigo              
                      AND UNID_CODIGO=@unid_codigo              
                 end            
          END              
END              
              
------------------------------------ Exclusao dos Dados ---------------------------------------              
--NAO HA EXCLUSAO DE PACIENTE              
--------------------------------------- Dados da Mpe ------------------------------------------              
If @Opcao = 4              
 Begin              
              
 SELECT  P.pac_codigo,      
   P.pac_nome,      
   P.rel_codigo,      
   P.cep_sequencial,      
   P.pac_nacionalidade,      
   P.pac_pai,      
   P.pac_mae,      
   P.pac_nascimento,      
   P.pac_sexo,      
   P.pac_raca,      
   P.pac_naturalidade,      
   P.pac_telefone,      
   P.pac_tipo_documento,      
   P.pac_numero_documento,      
   P.pac_orgao_emissor,      
   P.pac_emissao_documento,      
   P.pac_escolaridade,      
   P.pac_responsavel,      
   P.pac_telefone_responsavel,      
   P.pac_email,      
   P.pac_observacao,      
   P.pac_local_posse,      
   P.pac_ativo,      
   P.pac_data_matricula,      
   P.pac_endereco_num,      
   P.pac_endereco_compl,      
   P.pac_cpf,      
   P.pac_dtobito,      
   P.pac_foto,      
   P.pac_dtmatricula,      
   P.pac_esmeralda,      
   P.pac_idade,      
   P.raca_codigo,      
   P.etnia_codigo,      
   P.pac_cartao_nsaude,      
   P.pac_cartao_nDSTAIDS,      
   P.Pac_Numero_PID,      
   P.PAC_STATUS_CADASTRO,      
   P.estcivil_codigo,      
   P.PAC_ULTIMAALTEARACAO,      
   P.PAC_CertidaoNascimento,      
   P.pac_datahora,      
   P.pac_cartao_nsaude_provisorio,      
   P.pac_cartao_nsaude_provisorio_data,      
   P.pac_unidref_codigo,      
   P.prof_origem_codigo,      
   P.Pac_Causa_Mortis,      
   P.pac_celular,      
   P.usu_codigo,      
   P.pac_tipo_idade,      
   P.PAC_SIS_PRENATAL,      
   P.pac_gestante,      
   P.pac_fator_rh,      
   P.pac_possui_documento,      
   P.pac_grupo_sanguineo,      
   P.pac_telefone2,      
   P.pac_obito,      
   P.pac_dt_ultima_alteracao,      
   space(50) cep_logradouro ,              
   space(8) cep_cep,              
   space(8) bai_codigo,              
   space(8) mun_codigo,              
   space(2) uf_codigo,              
   pp.pac_prontuario_numero pac_prontuario,              
   space(50) mun_descricao,              
   space(50) bai_descricao,      
   space(10) cep_tiplogr,              
   pp.unid_codigo,              
   U.unid_descricao              
              
  INTO #TEMP              
              
  FROM  paciente P              
   inner join paciente_prontuario pp on pp.pac_codigo=P.pac_codigo              
   inner join unidade u on u.unid_codigo =  ISNULL(@UNID_CODIGO,pp.Unid_Codigo)              
                
              
  WHERE  pp.pac_codigo = isnull(@Pac_Codigo, pp.pac_codigo)    
   and   pp.Pac_Prontuario_Numero = isnull(@Pac_Prontuario, pp.Pac_Prontuario_Numero)          
--WEB e MULTI-UNIDADE              
  AND pp.Unid_Codigo   = ISNULL(@UNID_CODIGO,pp.Unid_Codigo)              
--SAMIR.HOMOLOGACAO.05/08/2003              
  AND P.PAC_SEXO = 'F'              
              
              
  UPDATE #TEMP              
   SET cep_logradouro = cep.cep_logradouro,              
    cep_cep= cep.cep_cep,              
    bai_codigo = cep.bai_codigo,              
    mun_codigo = cep.mun_codigo,              
    uf_codigo = municipio.uf_codigo,              
    mun_descricao = municipio.mun_descricao,              
    bai_descricao = bairro.bai_descricao,      
    cep_tiplogr = cep.cep_tiplogr               
              
  FROM  paciente , cep , municipio, bairro , paciente_prontuario              
              
  WHERE  cep.cep_sequencial = PACIENTE.cep_sequencial              
  AND municipio.mun_codigo = cep.mun_codigo              
  AND bairro.mun_codigo = cep.mun_codigo              
  AND bairro.bai_codigo = cep.bai_codigo              
  AND paciente.pac_codigo = paciente_prontuario.pac_codigo              
  AND paciente_prontuario.unid_codigo = @unid_codigo              
  and paciente_prontuario.pac_codigo = isnull(@Pac_Codigo, paciente_prontuario.pac_codigo)    
  and paciente_prontuario.Pac_Prontuario_Numero = isnull(@Pac_Prontuario, paciente_prontuario.Pac_Prontuario_Numero)             
--WEB e MULTI-UNIDADE              
  AND #temp.Unid_Codigo  = ISNULL(@UNID_CODIGO,#temp.Unid_Codigo)              
      
  select * from #Temp order by pac_nome              
              
  drop table #temp              
              
 End              
              
------------------------------- NÃƒâ‚¬mero do Pr=ximo C=digo --------------------------------------              
              
If @Opcao = 5              
 Begin              
              
  DECLARE @datahoje CHAR (10)              
              
  SET @UNID_GESTORA = NULL              
                
  SELECT @UNID_GESTORA = UNID_CODIGO_GESTOR_CADASTRO,              
      @CADASTROPROPRIO = IDTCADASTROPROPRIO,              
         @CADASTROPROVISORIO = IDTCADASTROPROVISORIO              
  FROM PARAMETRO_UNIDADE_REDE              
  WHERE UNID_CODIGO = @UNID_CODIGO              
                
  SET @datahoje = Convert (varchar, getdate (), 103)              
                  
  -- Este caso verifica se a uniade utiliza cadastro prÃ³prio, ou nÃ£o possui cadastro prÃ³prio              
  -- mas com cadastro provisÃ³rio. Para este caso, o pac_codigo gerado serÃ¡ com o cÃ³digo da prÃ³pria unidade              
  IF (@UNID_GESTORA IS NULL) OR (@CADASTROPROPRIO = 'S' OR (@CADASTROPROPRIO = 'N' AND @CADASTROPROVISORIO = 'S'))              
   EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,              
       @Chave      = 'paciente',              
       @data       = @datahoje,              
       @NovoCodigo = @UltCodigo OUTPUT              
  ELSE              
   EXEC ksp_controle_sequencial @Unidade    = @UNID_GESTORA ,              
       @Chave      = 'paciente',              
       @data       = @datahoje,              
       @NovoCodigo = @UltCodigo OUTPUT              
  select @UltCodigo              
                
              
       End              
------------------------------- HOMONIMOS: NOME + MAE + DT NASAC ------------------------------              
If @Opcao = 6              
 Begin              
  SELECT  Count(Pac_Codigo)              
  FROM  PACIENTE              
  WHERE Pac_nome  = @Pac_Nome              
  AND  Pac_Nascimento  = @Pac_Nascimento              
  AND     Pac_Mae  = @Pac_Mae              
  AND     UNID_CODIGO = @UNID_CODIGO              
              
 End              
------------------------------- HOMONIMOS: NOME + DT NASAC ------------------------------------              
If @Opcao = 7              
 Begin              
  SELECT  Count(Pac_Codigo)              
  FROM  PACIENTE              
  WHERE Pac_nome  = @Pac_Nome              
  AND  Pac_Nascimento  = @Pac_Nascimento              
  AND     UNID_CODIGO = @UNID_CODIGO              
              
 End              
------------------------------- HOMONIMOS: NOME -----------------------------------------------              
If @Opcao = 8              
 Begin              
   /*  SELECT  Count(Pac_Codigo)              
  FROM  PACIENTE              
     WHERE Pac_nome  = @Pac_Nome              
  AND   UNID_CODIGO = @UNID_CODIGO        
  */       
        
  set @lsql = 'SELECT Count(Pac_Codigo)' +             
 'FROM  PACIENTE '+              
 'WHERE Pac_nome = ''' + @pac_nome + ''''        
            
                  
   select @unid_gestora = unid_codigo_gestor_cadastro,              
    @cadastroproprio = idtcadastroproprio,              
    @cadastroprovisorio = idtcadastroprovisorio              
   from   parametro_unidade_rede              
   where  unid_codigo = @unid_codigo          
            
   if @unid_gestora is not null              
    begin              
      if @cadastroprovisorio = 'S'              
       begin              
       set @lSql = @lSql + ' And (pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
       set @lSql = @lSql + ' Or pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + '''' + ') '              
       end              
      else              
       set @lSql = @lSql + ' And pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + ''''              
    end              
   else              
   begin              
    set @lSql = @lSql + ' And pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
   end        
      
 exec (@lSql)                 
 End               
------------------------------- REMOVER PRONTUARIOS DUPLICADOS---------------------------------              
If @Opcao = 9              
 Begin              
  DELETE FROM PACIENTE_PRONTUARIO              
  WHERE Pac_Codigo  <> @Pac_Codigo              
  AND Pac_Prontuario_Numero = @Pac_Prontuario              
  AND     UNID_CODIGO=@UNID_CODIGO              
              
 End              
------------------------------- MAIOR PRONTUARIO COM MAX --------------------------------------              
If @Opcao = 10              
 Begin              
/*              
  SELECT MAX(PAC_PRONTUARIO_NUMERO)              
  FROM   PACIENTE_PRONTUARIO              
  WHERE  PAC_PRONTUARIO_NUMERO IS NOT NULL              
  AND    Unid_Codigo = ISNULL(@UNID_CODIGO,Unid_Codigo)              
*/              
  SELECT CTRLSEQ_PROXIMO              
  FROM CONTROLE_SEQUENCIAL              
  WHERE CTRLSEQ_CHAVE = 'PRONTUARIO'              
    AND UNID_CODIGO = ISNULL(@UNID_CODIGO,Unid_Codigo)              
              
 End              
------------------------------- MAIOR PRONTUARIO COM TOP 100 --------------------------------------              
If @Opcao = 11              
 Begin              
              
        SELECT TOP 100  PAC_PRONTUARIO_NUMERO PAC_PRONTUARIO              
  FROM  PACIENTE_PRONTUARIO              
  WHERE   Unid_Codigo = ISNULL(@UNID_CODIGO,Unid_Codigo)              
                AND     PAC_PRONTUARIO_NUMERO IS NOT NULL              
  GROUP BY PAC_PRONTUARIO_NUMERO              
  HAVING MAX(LEN(RTRIM(PAC_PRONTUARIO_NUMERO)))=LEN(RTRIM(PAC_PRONTUARIO_NUMERO))              
  ORDER BY PAC_PRONTUARIO_NUMERO DESC              
              
 End              
------------------------------- PRONTU-RIOS REPETIDOS --- --------------------------------------              
If @Opcao = 12              
 Begin              
              
              
        SELECT SUM(campo1)              
        from              
        (              
        SELECT COUNT(PAC_PRONTUARIO_NUMERO) AS CAMPO1              
        FROM PACIENTE_PRONTUARIO              
        WHERE UNID_CODIGO=ISNULL(@UNID_Codigo,UNID_CODIGO)              
        AND PAC_PRONTUARIO_NUMERO IS NOT NULL              
        AND PAC_PRONTUARIO_NUMERO=ISNULL(rtrim(ltrim(@Pac_Prontuario)),PAC_PRONTUARIO_NUMERO)                
  AND PAC_CODIGO <> ISNULL(@PAC_CODIGO, '')              
--      GROUP BY PAC_PRONTUARIO_NUMERO              
--      HAVING COUNT(PAC_PRONTUARIO_NUMERO)>1              
        ) as TABELA              
              
 End              
------------------------------- GERA PRONTU-RIO -----------------------------------------------              
If @Opcao = 13             -- ver esta logica com sergio              
 Begin              
              
        DECLARE @NovoProntuario char(10)              
        DECLARE @CONT AS INT              
 DECLARE @SAI AS INT              
              
 SET @SAI = 0              
              
 WHILE @SAI = 0              
 BEGIN                       
         EXEC ksp_controle_sequencial @Unidade    = @Unid_Codigo,              
          @Chave      = 'PRONTUARIO',              
          @data       = NULL,              
          @NovoCodigo = @NovoProntuario OUTPUT,              
               @opcao=1              
              
  SET @NovoProntuario = CONVERT(VARCHAR, CONVERT(INT, @NovoProntuario))            
              
  SELECT @CONT = COUNT(1)              
  FROM PACIENTE_PRONTUARIO              
  WHERE PAC_PRONTUARIO_NUMERO = @NovoProntuario              
    AND UNID_CODIGO = @UNID_CODIGO              
              
  IF @CONT = 0              
   SET @SAI = 1              
              
 END               
              
              
 SELECT @CONT = COUNT(1)              
 FROM PACIENTE_PRONTUARIO              
 WHERE PAC_CODIGO = @PAC_CODIGO              
   AND UNID_CODIGO = @UNID_CODIGO              
                
 IF @CONT > 0              
  UPDATE PACIENTE_PRONTUARIO              
  SET PAC_PRONTUARIO_NUMERO = @NovoProntuario              
  WHERE PAC_CODIGO = @PAC_CODIGO              
    AND UNID_CODIGO = @UNID_CODIGO              
 ELSE              
  INSERT INTO Paciente_Prontuario (Pac_Codigo,Unid_Codigo,Pac_Prontuario_Numero,usu_codigo)              
  VALUES (@PAC_CODIGO,@UNID_CODIGO,@NovoProntuario,@usu_codigo)              
              
 select @NovoProntuario              
              
 End              
------------------------------- LOCALIZAR -----------------------------------------------------              
if @opcao = 14 or @opcao = 19 -- pesquisar do central              
begin              
 --> retorna o codigo do municipio da unidade              
 declare @var_cod_ibge varchar(7)              
              
 select @var_cod_ibge = m.cod_ibge              
              
 from  unidade u              
              
 inner join cep c              
 on u.cep_sequencial = c.cep_sequencial              
              
 inner join municipio m on (c.mun_codigo = m.mun_codigo)              
 where u.unid_codigo = @unid_codigo              
 -----------------------------------------------------------              
              
 declare @var1  varchar(255)              
              
 if Len(rtrim(ltrim(@Pac_Cartao_NDSTAIDS))) = 14              
  Set @Pac_Cartao_NDSTAIDS = right(rtrim(ltrim(@Pac_Cartao_NDSTAIDS)), 7)              
                 
 if @opcao = 19              
  Set @lSql = 'Select p.pac_nome, p.pac_mae, p.pac_nascimento, p.pac_Codigo, pp.Pac_Prontuario_Numero pac_prontuario, p.pac_pai, p.pac_local_posse, pp.unid_codigo, p.pac_cartao_nsaude, pim.PacIdMun_Codigo, cast(p.pac_observacao as varchar), p.pac_possui_
d  
ocumento, p.pac_dtobito, '              
 else              
  Set @lSql = 'Select p.pac_Codigo, p.pac_nome, pp.Pac_Prontuario_Numero pac_prontuario, p.pac_pai, p.pac_mae, p.pac_nascimento, p.pac_local_posse, cast(p.pac_observacao as varchar), p.pac_possui_documento, p.pac_dtobito, '              
              
 Set @lSql = @lSql + 'isnull((Select top 1 ' + '''' + 'S' + '''' + ' from internacao i '              
 Set @lSql = @lSql + 'where i.pac_codigo = p.pac_codigo '              
 Set @lSql = @lSql + 'and i.inter_dtalta is null), ' + '''' + 'N' + '''' + '), p.pac_cartao_nsaude, pim.PacIdMun_Codigo, p.pac_sexo, p.pac_raca, p.pac_idade, p.pac_justificativa_resp, pac_justificativa, pac_obs_telefone, '              
 Set @lSql = @lSql + 'PACCNS.paccns_identidade_numero as Paccns_Identidade_Numero '              
 Set @lSql = @lSql + ',Pac_CPF_Responsavel '    
 Set @lSql = @lSql + ' From Paciente P '              
 Set @lSql = @lSql + ' LEFT JOIN Paciente_Militar pm ON p.pac_codigo = pm.pac_codigo '              
 Set @lSql = @lSql + ' LEFT JOIN Paciente_Identificacao_Municipio PIM  ON p.pac_codigo = pim.pac_codigo and pim.cod_ibge = ''' + @var_cod_ibge + '''' -- + ' and (PIM.cod_ibge + PIM.pacidmun_codigo) = ''' + @Pac_CMS + ''''             
 Set @lSql = @lSql + ' LEFT JOIN Paciente_Prontuario pp ON (p.pac_codigo = pp.pac_codigo  And pp.unid_codigo = ''' + @unid_codigo + '''' + ') '              
 Set @lSql = @lSql + ' LEFT JOIN PACIENTE_CNS PACCNS ON PACCNS.PAC_CODIGO = P.PAC_CODIGO '        
 Set @lSql = @lSql + ' WHERE 1 = 1 '              
                
              
 set @unid_gestora = null              
                
 select  @unid_gestora = unid_codigo_gestor_cadastro,              
     @cadastroproprio = idtcadastroproprio,              
  @cadastroprovisorio = idtcadastroprovisorio              
 from  parametro_unidade_rede              
 where  unid_codigo = @unid_codigo              
          
 if @unid_gestora is not null              
 begin              
  if @cadastroprovisorio = 'S'              
  begin              
   set @lSql = @lSql + ' And (p.pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
   set @lSql = @lSql + ' Or p.pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + '''' + ') '              
  end              
  else              
   set @lSql = @lSql + ' And p.pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + ''''              
 end              
 else              
 begin              
  set @lSql = @lSql + ' And p.pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
 end              
              
 if @tp_pesq is not null              
 begin              
  -- Pesquisa por CODIGO              
  If @Pac_Codigo is Not Null              
  Begin              
          Set @var1 =  convert(varchar,@Pac_Codigo)              
          Exec ksp_ParametroPesquisa @var1,"p.pac_codigo", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End              
              
  If @Pac_Observacao is Not Null              
  Begin              
          Set @var1 =  convert(varchar, @Pac_Observacao)              
          Exec ksp_ParametroPesquisa @var1,"p.pac_observacao", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End              
              
  -- Pesquisa por NOME              
  If @Pac_Nome is Not Null              
  Begin              
   Set @var1 =  convert(varchar,@Pac_Nome)              
   Exec ksp_ParametroPesquisa @var1,"p.pac_nome",@tp_pesq, "T", @par output              
   set @lSql = @lSql + ' and ' + @par              
  End              
              
 -- Pesquisa por PRONTUARIO             
  If @Pac_Prontuario is Not Null              
  Begin              
  set @lSql = @lSql + ' and CHARINDEX('''+ LTRIM(RTRIM(@Pac_Prontuario)) + ''',pp.Pac_Prontuario_Numero) > 0 '    
     end              
              
  -- NOME DO PAI              
  If @Pac_Pai is Not Null              
  Begin              
              Set @var1 =  convert(varchar,@Pac_Pai)              
              Exec ksp_ParametroPesquisa @var1,"p.pac_pai",@tp_pesq,"T", @par output              
   set @lSql = @lSql + ' and ' + @par              
  End              
      
  -- CPF      
  If @Pac_Cpf is Not Null              
  Begin              
              Set @var1 =  convert(varchar,@Pac_Cpf)              
              Exec ksp_ParametroPesquisa @var1,"p.Pac_Cpf",@tp_pesq,"T", @par output              
 set @lSql = @lSql + ' and ' + @par              
  End           
              
  --NOME DA MAE              
  If @Pac_Mae is Not Null              
  Begin              
              Set @var1 =  convert(varchar,@Pac_Mae)              
              Exec ksp_ParametroPesquisa @var1,"p.pac_mae",@tp_pesq,"T", @par output              
   set @lSql = @lSql + ' and ' + @par              
End        
  --NOME DA MAE              
  If @Pac_Cpf is Not Null              
  Begin              
              Set @var1 =  convert(varchar,@Pac_Cpf)              
              Exec ksp_ParametroPesquisa @var1,"p.Pac_Cpf",@tp_pesq,"T", @par output              
 set @lSql = @lSql + ' and ' + @par              
  End              
              
  --DATA DE NASCIMENTO              
  If @Pac_Nascimento is Not Null              
  Begin              
   declare @Inicio as smalldatetime              
   declare @Fim as smalldatetime              
              
   set @Inicio = convert(smalldatetime, convert(char(10), @Pac_Nascimento, 103), 120)              
   set @Fim = dateadd(dd, 1, convert(smalldatetime, convert(char(10), @Pac_Nascimento, 103), 120))              
   set @lSql = @lSql + ' and p.pac_nascimento >= ' + '''' + convert(varchar, @Inicio) + ''''              
   set @lSql = @lSql + ' and p.pac_nascimento < ' + '''' + convert(varchar, @Fim) + ''''              
  End              
              
  -- Pesquisa por RG (militar)              
  If @Pac_Numero_Documento is Not Null              
  Begin              
          Set @var1 =  convert(varchar,@Pac_Numero_Documento)              
          Exec ksp_ParametroPesquisa @var1,"pm.mil_documento", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End              
              
  -- Pesquisa por CNS              
  If @Pac_Cartao_NSaude is Not Null              
  Begin              
          Set @var1 =  convert(varchar,@Pac_Cartao_NSaude)              
          Exec ksp_ParametroPesquisa @var1,"p.pac_cartao_nsaude", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End              
              
  -- Pesquisa por ID do municipio (Paciente_Identificacao_Municipio)              
  If @Pac_Cartao_NDSTAIDS is Not Null              
  Begin              
          Set @var1 =  convert(varchar,@Pac_Cartao_NDSTAIDS)              
          Exec ksp_ParametroPesquisa @var1,"pim.PacIdMun_Codigo", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End        
          
  --identidade / Central de Cadastro             
  If @Pac_Paccns_Identidade_Numero is Not Null              
  Begin              
          Set @var1 =  convert(varchar,@Pac_Paccns_Identidade_Numero)              
          Exec ksp_ParametroPesquisa @var1,"PACCNS.paccns_identidade_numero", @tp_pesq, "T", @par output              
          set @lSql = @lSql + ' and ' + @par              
  End        
          
 IF @PAC_CMS IS NOT NULL        
 BEGIN         
    Set @var1 =  convert(varchar,@PAC_CMS)              
    Exec ksp_ParametroPesquisa @var1,"PIM.PacIdMun_Codigo ", @tp_pesq, "T", @par output              
    set @lSql = @lSql + ' and ' + @par                  
 END        
              
              
 End              
--   print (@lSql)          
 exec (@lSql)              
end              
              
------------------------------ LOCALIZAR (tela Principal)--------------------------------------              
If @Opcao = 15              
              
 Begin              
              
  if Len(rtrim(ltrim(@Pac_Cartao_NDSTAIDS))) = 14              
   Set @Pac_Cartao_NDSTAIDS = right(rtrim(ltrim(@Pac_Cartao_NDSTAIDS)), 7)              
               
  set @lSql = 'SELECT '              
  set @lSql = @lSql + 'P.Pac_Codigo, P.Pac_Nome,ppr.Pac_Prontuario_numero as pac_prontuario, p.pac_telefone,c.con_descricao, Pac_Cartao_NSaude, pim.PacIdMun_Codigo, P.Pac_Nascimento,ppr.unid_codigo, p.pac_dtobito, P.Pac_Sexo, '              
  set @lSql = @lSql + 'P.Pac_Mae, P.Pac_Pai, p.pac_dtObito, P.Pac_dtmatricula, P.Pac_Responsavel, p.pac_cpf, u.unid_descricao, p.Pac_CPF_Responsavel  '              
  set @lSql = @lSql + 'FROM  Paciente P LEFT JOIN paciente_plano pp ON p.pac_codigo = pp.pac_codigo '              
  set @lSql = @lSql + ' LEFT JOIN Plano_saude pl ON pp.plan_codigo = pl.plan_codigo '              
  set @lSql = @lSql + ' LEFT JOIN Convenio c ON pl.con_codigo = c.con_codigo '              
  set @lSql = @lSql + ' LEFT JOIN Paciente_Identificacao_Municipio PIM ON PIM.pac_codigo = p.pac_codigo '              
  set @lSql = @lSql + ' LEFT join paciente_prontuario ppr on (p.pac_codigo = ppr.pac_codigo And ppr.unid_codigo = ''' + @unid_codigo + '''' + ') '              
  set @lSql = @lSql + ' LEFT join unidade u on right(u.unid_codigo,2) = left(p.pac_codigo,2) '              
  set @lSql = @lSql + 'WHERE 1 = 1 '              
              
  SET @UNID_GESTORA = NULL              
                
  SELECT @UNID_GESTORA = UNID_CODIGO_GESTOR_CADASTRO,              
      @CADASTROPROPRIO = IDTCADASTROPROPRIO,              
         @CADASTROPROVISORIO = IDTCADASTROPROVISORIO              
  FROM PARAMETRO_UNIDADE_REDE              
  WHERE UNID_CODIGO = @UNID_CODIGO              
              
  IF @UNID_GESTORA IS NOT NULL              
  BEGIN              
   IF @CADASTROPROVISORIO = 'S'              
   BEGIN              
    set @lSql = @lSql + ' And (p.pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
    set @lSql = @lSql + ' Or p.pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + '''' + ') '              
   END              
   ELSE              
    set @lSql = @lSql + ' And p.pac_codigo like ' + '''' + right(@unid_gestora, 2) + '%' + ''''              
  END              
  ELSE              
  BEGIN              
   IF @unid_codigo <> '    '              
   BEGIN              
    set @lSql = @lSql + ' And p.pac_codigo like ' + '''' + right(@unid_codigo, 2) + '%' + ''''              
   END              
  END                 
                 
                 
                 
--WEB e MULTI-UNIDADE              
 /* If @unid_Codigo is Not Null              
  Begin              
   Set @lSql = @lSql + ' And (p.unid_codigo = ' + @unid_Codigo + ') '              
  End*/              
              
  if @pac_codigo is not null              
  begin              
   set @lSql = @lSql + ' And p.pac_codigo = ''' + @pac_codigo + ''''              
  end              
  if @pac_nome is not null              
  begin              
   set @lSql = @lSql + ' And p.pac_nome LIKE ''' + ltrim(rtrim(@pac_nome)) + '%'''              
  end              
  if @pac_prontuario is not null              
  begin              
   -- ALTERAÂª+O EFETUADA PELO MARCOS LIMA EM VIRTUDE DE PERFORMACE DO BANCO              
   -- PARA ESTE OPCAO FUNCIONAR CORRETAMENTE + NECESS-RIO QUE TODOS OS              
   -- NR DE PRONTU-RIO ESTEJA COM 7 DIGITOS              
   set @lSql = @lSql + ' And ppr.Pac_Prontuario_Numero = ''' + @pac_prontuario + ''''              
              
  end              
  if @Pac_Cartao_NSaude is not null              
  begin              
   set @lSql = @lSql + ' And p.Pac_Cartao_NSaude = ''' + @Pac_Cartao_NSaude + ''''              
  end              
              
  if @Pac_Cartao_NDSTAIDS is not null              
  begin              
   set @lSql = @lSql + ' And pim.PacIdMun_Codigo = ''' + @Pac_Cartao_NDSTAIDS + ''''              
  end              
              
  set @lSql = @lSql + ' order by p.pac_nome '              
              
  Exec (@lSql)              
              
 End              
------------------------------- PEDIDO DE ITERNACAO ABERTO -------------------------------------              
If @Opcao = 16              
 Begin              
  SELECT  PD.Pedint_sequencial,              
   NULL INTER_PEDINT_SEQUENCIAL              
              
  FROM  Pedido_Internacao PD              
              
  WHERE  PD.pac_codigo = @PAC_CODIGO              
  AND PD.pedint_sequencial NOT IN (SELECT pedint_sequencial FROM INTERNACAO              
       WHERE pac_codigo = @PAC_CODIGO)              
              
 End              
------------------------------------------------------------------------------------------------              
If @Opcao = 17 --Internacoes do Paciente              
 Begin              
  declare @JaEsteveInternado  CHAR(01)              
  declare @EstaInternado   CHAR(01)              
              
  Set @JaEsteveInternado = 'N'              
  Set @EstaInternado = 'N'              
              
  Select @JaEsteveInternado = 'S'              
  From Internacao              
  Where Pac_Codigo = @Pac_Codigo              
  And Inter_DtAlta is not null              
              
  Select @EstaInternado = 'S'              
  From Internacao              
  Where Pac_Codigo = @Pac_Codigo              
  And Inter_DtAlta is null              
              
  Select  @Pac_Codigo   PAC_CODIGO,              
   @JaEsteveInternado  INTERNACAO_ANTERIOR,              
   @EstaInternado  INTERNACAO_ATUAL              
              
              
              
 End              
          If @Opcao = 18 --Cep no DAIH070              
 Begin              
  Select  D.Cep              
              
  From  Daih070 D              
              
  Where D.Cep = @Pac_Codigo -- reaproveitamento de paramentro (rece o nÃ€mero do cep)              
 End              
              
--If @Opcao = 19 -- Pesquisar do Central: c=digo na optpo 14.... pr=xima optpo se3rÂ¯ a 20              
              
if @opcao = 20 --Verificar NÃºmero do CartÃ£o Municipal              
begin              
 select  pm.pacidmun_codigo, m.cod_ibge, m.mun_descricao              
 from unidade u               
 inner join cep c on c.cep_sequencial = u.cep_sequencial              
 inner join municipio m on m.mun_codigo = c.mun_codigo              
 left join paciente_identificacao_municipio pm on pm.cod_ibge = m.cod_ibge  and pm.pac_codigo = @Pac_Codigo              
 where  u.unid_codigo = @Unid_Codigo              
              
End              
              
if @opcao = 21 --Gerar NÃºmero do CartÃ£o Municipal              
begin              
              
 declare @pacidmun_codigo char(7)              
 declare @cod_ibge char(7)              
              
 select @cod_ibge = m.cod_ibge               
 from unidade u               
 inner join cep c on c.cep_sequencial = u.cep_sequencial              
 inner join municipio m on m.mun_codigo = c.mun_codigo              
 where u.unid_codigo = @Unid_Codigo              
              
              
 select @pacidmun_codigo = right('0000000' + ltrim(rtrim(cast(cast(max(pacidmun_codigo) as bigint) + 1 as varchar))),7)              
  from paciente_identificacao_municipio              
  where cod_ibge = @cod_ibge              
               
 Insert into paciente_identificacao_municipio (pacidmun_codigo,pac_codigo,cod_ibge)              
  values ( @pacidmun_codigo, @Pac_Codigo, @cod_ibge)              
              
 select @pacidmun_codigo pacidmun_codigo              
              
end              
              
------------------------------------------------------------------------------------------------              
              
if @opcao = 22              
    begin              
        UPDATE  Paciente               
        SET pac_dtobito = @dt_obito              
  WHERE Pac_Codigo = @Pac_Codigo              
  IF (@Pac_Causa_Mortis IS NOT NULL AND LTRIM(RTRIM(@Pac_Causa_Mortis)) <> '')              
  BEGIN              
    UPDATE Paciente              
            SET pac_causa_mortis = @pac_causa_mortis              
    WHERE Pac_Codigo = @Pac_Codigo              
  END              
    end              
              
------------------------------------------------------------------------------------------------              
If @Opcao = 23 --Altera o Status do cadastro              
 Begin              
  UPDATE PACIENTE              
  SET PAC_STATUS_CADASTRO = @PAC_STATUS              
  WHERE PAC_CODIGO = @PAC_CODIGO              
 End              
              
-- VERIFICA HOMONIMOS DO PACIENTE PELO NOME, NOME DA MÃƒE E DATA NASCIMENTO              
-- SE NÃƒO ENCONTRA VERIFICA SE HÃ PACIENTE COM O MESMO NOME DE MÃƒE E DATA NASCIMENTO              
-- ESTA OPÃ‡ÃƒO Ã‰ UTILIZADA PELA VERIFICAÃ‡ÃƒO DE HOMONOMINOS DO PRONTUÃRIO MÃ‰DICO USPri DA SEAP              
if @Opcao=24              
BEGIN              
              
 SELECT  P.*, U.UNID_DESCRICAO              
 FROM  PACIENTE P              
  LEFT OUTER JOIN UNIDADE U ON P.UNID_CODIGO = U.UNID_CODIGO              
 WHERE Pac_nome  LIKE @Pac_Nome + '%'              
 AND  Pac_Nascimento  = @Pac_Nascimento              
 AND     Pac_Mae  = @Pac_Mae              
               
IF (@@ROWCOUNT = 0)              
 BEGIN              
  SELECT  P.*, U.UNID_DESCRICAO              
  FROM  PACIENTE P              
   LEFT OUTER JOIN UNIDADE U ON P.UNID_CODIGO = U.UNID_CODIGO              
              
               
  WHERE  Pac_Nascimento  = @Pac_Nascimento              
  AND     Pac_Mae  = @Pac_Mae              
 END               
              
END           
IF @OPCAO = 25 --BUSCA PACIENTE PELO CODIGO DO CARTAO PROVISORIO OU DEFINITIVO          
BEGIN          
          
 SELECT PAC_CODIGO, PAC_NOME, PAC_MAE, PAC_NASCIMENTO, PAC_CARTAO_NSAUDE, PAC_CARTAO_NSAUDE_PROVISORIO,           
  PAC_CARTAO_NSAUDE_PROVISORIO_DATA, CEP_SEQUENCIAL, PAC_NACIONALIDADE, PAC_SEXO, PAC_NATURALIDADE, PAC_TELEFONE,           
  PAC_ENDERECO_NUM, PAC_ENDERECO_COMPL, UNID_CODIGO, PAC_RACA, PAC_IDADE, PAC_CERTIDAONASCIMENTO           
 FROM PACIENTE          
 WHERE (PAC_CARTAO_NSAUDE = @PAC_CARTAO_NSAUDE          
  OR PAC_CARTAO_NSAUDE_PROVISORIO = @PAC_CARTAO_NSAUDE_PROVISORIO)          
  AND UNID_CODIGO = @UNID_CODIGO           
          
END         
        
--> Consulta do Servico Java        
        
if (@opcao = 26)          
begin          
          
 declare @sql varchar(8000)          
          
 set @sql =   'select top 100 p.pac_codigo, ' +           
   ' p.pac_nome, ' +          
   ' p.pac_mae, ' +          
   ' p.pac_pai, ' +          
   ' p.pac_sexo, ' +          
   ' p.pac_nascimento, ' +           
   ' p.pac_cpf, ' +           
   ' p.pac_cartao_nsaude, ' +          
   ' pp.pac_prontuario_numero as pac_prontuario, ' +           
   ' pp.unid_codigo, ' +           
   ' u.unid_sigla, ' +          
   ' r.raca_desc, ' +          
   ' p.pac_naturalidade, ' +          
   ' p.pac_responsavel, ' +          
   ' ec.estcivil_descricao, ' +    
   ' p.Pac_CPF_Responsavel ' +    
           
   ' from paciente p ' +           
   ' inner join unidade uu on uu.unid_codigo = p.unid_codigo ' +          
   ' left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo ' +          
   ' left join unidade u on pp.unid_codigo = u.unid_codigo ' +          
   ' left join raca r on p.raca_codigo = r.raca_codigo ' +        
   ' left join estadocivil ec on ec.estcivil_codigo = p.estcivil_codigo ' +      
   ' where 1 =1 '           
           
 if @pac_cnes is not null          
 begin        
  set @sql = @sql + ' and (uu.unid_CodigoCNES = ''' + ltrim(rtrim(@pac_cnes)) + ''' or uu.unid_codigo = ''' + ltrim (rtrim(@pac_cnes)) + ''')'        
 end        
           
 if @pac_codigo is not null          
  set @sql = @sql + ' and p.pac_codigo like ' + '''' + ltrim(rtrim(@pac_codigo)) + '%'''          
           
 if @pac_nome is not null          
  set @sql = @sql + ' and p.pac_nome like ' + '''' + ltrim(rtrim(@pac_nome)) + '%'''          
           
 if @pac_prontuario is not null          
  set @sql = @sql + ' and pp.pac_prontuario_numero like ' + '''' + ltrim(rtrim(@pac_prontuario)) + '%'''          
            
 if @Pac_Mae is not null          
  set @sql = @sql + ' and p.pac_mae like ' + '''' + ltrim(rtrim(@Pac_Mae)) + '%'''          
            
 if @Pac_Nascimento is not null          
  set @sql = @sql + ' and p.Pac_Nascimento = ' + '''' + ltrim(rtrim(@Pac_Nascimento)) + ''''          
            
 if @Pac_CPF is not null          
  set @sql = @sql + ' and p.Pac_CPF like ' + '''' + ltrim(rtrim(@Pac_CPF)) + '%'''          
            
 set @sql = @sql + ' order by p.pac_nome '          
           
 --print(@sql)           
           
 exec(@sql)          
          
end          
------------------------------- NUMERO DO PROXIMO CODIGO - DATA RETROATIVA --------------------------------------                
                
If @Opcao = 28      
Begin                
                
  DECLARE @dtHoje CHAR (10)                
                
  SET @UNID_GESTORA = NULL                
                  
  SELECT @UNID_GESTORA = UNID_CODIGO_GESTOR_CADASTRO,                
      @CADASTROPROPRIO = IDTCADASTROPROPRIO,                
         @CADASTROPROVISORIO = IDTCADASTROPROVISORIO                
  FROM PARAMETRO_UNIDADE_REDE                
  WHERE UNID_CODIGO = @UNID_CODIGO                
                  
  SET @dtHoje = Convert (varchar, @DATA_RETROATIVA,103)      
                    
  -- Este caso verifica se a uniade utiliza cadastro prÃƒÂ³prio, ou nÃƒÂ£o possui cadastro prÃƒÂ³prio                
  -- mas com cadastro provisÃƒÂ³rio. Para este caso, o pac_codigo gerado serÃƒÂ¡ com o cÃƒÂ³digo da prÃƒÂ³pria unidade                
  IF (@UNID_GESTORA IS NULL) OR (@CADASTROPROPRIO = 'S' OR (@CADASTROPROPRIO = 'N' AND @CADASTROPROVISORIO = 'S'))                
   EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,                
       @Chave      = 'paciente',                
       @data       = @dtHoje,                
       @NovoCodigo = @UltCodigo OUTPUT                
  ELSE                
   EXEC ksp_controle_sequencial @Unidade    = @UNID_GESTORA ,                
       @Chave      = 'paciente',                
       @data       = @dtHoje,                
       @NovoCodigo = @UltCodigo OUTPUT                
  select @UltCodigo                
                  
                
End                
        
        
If @Opcao = 29      
Begin       
      
 SELECT       
  P.*      
 FROM      
  PACIENTE P      
  INNER JOIN homonimo_processamento H ON P.PAC_CODIGO = H.pac_codigo_destino      
 WHERE      
  H.pac_codigo_Origem = @PAC_CODIGO      
end      
      
If @Opcao = 30      
Begin       
      
    
 declare @homonimo_processamento_id as bigint       
 declare @pac_codigo_origem as CHAR(12)       
 declare @pac_codigo_destino as CHAR(12)      
 declare @pac_codigo_pesquisa as CHAR(12)       
 declare @fim_pesq as int      
 declare @existe_pac as int      
 declare @pacientes_pesquisados as varchar(1000);    
 set @pacientes_pesquisados ='';    
 set @existe_pac = 0      
 set @pac_codigo_pesquisa = @Pac_Codigo    
 set @fim_pesq=0;      
 while (@fim_pesq = 0 )      
 BEGIN    
  SELECT top 1  @homonimo_processamento_id = homonimo_processamento_id,     
   @pac_codigo_origem =pac_codigo_origem,    @pac_codigo_destino = pac_codigo_destino        
   FROM homonimo_processamento     where pac_codigo_origem =  @pac_codigo_pesquisa     
   IF @homonimo_processamento_id IS NULL       
     set @fim_pesq =1;       
   else       
    begin    
        SELECT @existe_pac =count(*) FROM paciente  WHERE pac_codigo = @pac_codigo_destino       
        IF @existe_pac >0     
      BEGIN     
       select top 1 * from paciente where pac_codigo =@pac_codigo_destino;          
       break;        
      END     
     ELSE       
      IF @pac_codigo_destino IS NOT NULL          
       begin    
        if CHARINDEX(@pac_codigo_destino, @pacientes_pesquisados) =0    
         begin    
          SET @pac_codigo_pesquisa= @pac_codigo_destino;       
          set @pacientes_pesquisados =@pacientes_pesquisados +';' + @pac_codigo_pesquisa;    
         end    
        else    
         begin    
          set @fim_pesq =1;    
         end    
       end    
      else    
       set @fim_pesq =1;       
      end    
     END       
    
    
    
end      
    
 IF @OPCAO = 31    
 BEGIN    
  SELECT top 10 p.pac_codigo,    
    p.pac_nome as "Nome",     
    CASE     
     WHEN p.pac_sexo = 'M' THEN 'Masculino'    
     WHEN p.pac_sexo = 'F' THEN 'Feminino'    
    END as "Sexo",     
    p.pac_nascimento as "DataNascimento",     
    p.pac_idade as "Idade",     
    p.pac_mae as "NomeMae",     
    p.pac_telefone as "Telefone",     
    p.pac_dtobito as "DataObito",    
    pp.Pac_Prontuario_Numero as Prontuario    
   FROM paciente p    
  left join Paciente_Prontuario pp on pp.pac_codigo = p.pac_codigo    
  WHERE p.pac_nome like RTRIM(@Pac_Nome) + '%'     
  and p.unid_codigo = @Unid_Codigo    
  order by 2    
 END    
    
 IF @OPCAO = 32    
 BEGIN    
 if @Pac_CPF is not null    
  begin    
  SELECT pac_cpf, pac_cartao_nsaude, pac_codigo, pac_nome    
   FROM paciente     
  WHERE pac_cpf = @Pac_CPF    
  and unid_codigo = @Unid_Codigo     
 end    
 else if @Pac_Cartao_NSaude is not null or @Pac_Cartao_NSaude_Provisorio is not null    
  begin     
  SELECT pac_cpf, pac_cartao_nsaude, pac_codigo, pac_nome    
   FROM paciente     
  WHERE pac_cartao_nsaude = @pac_cartao_nsaude    
  or pac_cartao_nsaude_provisorio = @Pac_Cartao_NSaude_Provisorio    
  and unid_codigo = @Unid_Codigo    
 end     END    
    
 IF @OPCAO = 33    
 BEGIN    
  SELECT top 10 pac_codigo,    
    pac_nome_social as "Nome",     
    CASE     
     WHEN pac_sexo = 'M' THEN 'Masculino'    
     WHEN pac_sexo = 'F' THEN 'Feminino'    
    END as "Sexo",     
    pac_nascimento as "DataNascimento",     
    pac_idade as "Idade",     
    pac_mae as "NomeMae",     
    pac_telefone as "Telefone",     
    pac_obito as "DataObito"    
   FROM paciente     
  WHERE pac_nome_social like RTRIM(@Pac_Nome_Social) + '%'     
  and unid_codigo = @Unid_Codigo    
  order by 2    
 END    
    
IF @OPCAO = 34  
 BEGIN    
  
   UPDATE paciente  
      SET pac_cpf = @pac_cpf  
     , pac_cartao_nsaude = @Pac_Cartao_NSaude  
  , pac_mae = @Pac_Mae  
  , pac_nascimento = @Pac_Nascimento  
  , pac_sexo = @Pac_Sexo  
  , pac_raca = @Pac_Raca  
  , Cep_Sequencial = @Cep_Sequencial  
  , pac_pai = @pac_pai
  , pac_telefone = @pac_Telefone
  , pac_celular = @Pac_Celular
  , pac_email = @pac_email
    WHERE pac_codigo = @pac_codigo  
  
 END  
  
        
--if (@opcao = 26)        
--begin      
        
 --declare @sql varchar(8000)        
        
 --set @sql =   'select top 100 p.pac_codigo, ' +         
   --' p.pac_nome, ' +        
   --' p.pac_mae, ' +        
   --' p.pac_pai, ' +        
   --' p.pac_sexo, ' +        
   --' p.pac_nascimento, ' +         
   --' p.pac_cpf, ' +         
   --' p.pac_cartao_nsaude, ' +        
   --' pp.pac_prontuario_numero as pac_prontuario, ' +         
   --' pp.unid_codigo, ' +         
   --' u.unid_sigla, ' +        
   --' r.raca_desc ' +        
         
   --' from paciente p ' +         
   --' inner join unidade uu on uu.unid_codigo = p.unid_codigo ' +        
   --' left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo ' +        
   --' left join unidade u on pp.unid_codigo = u.unid_codigo ' +        
   --' left join raca r on p.raca_codigo = r.raca_codigo ' +        
   --' where 1 =1 '         
         
 --if @pac_cnes is not null        
  --set @sql = @sql + ' and uu.unid_CodigoCNES = ' + '''' + ltrim(rtrim(@pac_cnes)) + ''''        
         
 --if @pac_codigo is not null        
  --set @sql = @sql + ' and p.pac_codigo like ' + '''' + ltrim(rtrim(@pac_codigo)) + '%'''        
         
 --if @pac_nome is not null        
  --set @sql = @sql + ' and p.pac_nome like ' + '''' + ltrim(rtrim(@pac_nome)) + '%'''        
         
 --if @pac_prontuario is not null        
  --set @sql = @sql + ' and pp.pac_prontuario_numero like ' + '''' + ltrim(rtrim(@pac_prontuario)) + '%'''        
          
 --if @Pac_Mae is not null        
  --set @sql = @sql + ' and p.pac_mae like ' + '''' + ltrim(rtrim(@Pac_Mae)) + '%'''        
          
 --if @Pac_Nascimento is not null        
  --set @sql = @sql + ' and p.Pac_Nascimento = ' + '''' + ltrim(rtrim(@Pac_Nascimento)) + ''''        
          
 --if @Pac_CPF is not null        
  --set @sql = @sql + ' and p.Pac_CPF like ' + '''' + ltrim(rtrim(@Pac_CPF)) + '%'''        
          
 --set @sql = @sql + ' order by p.pac_nome '        
         
 --print(@sql)         
         
 --exec(@sql)        
        
--end        
------------------------------------------------------------------------------------------------            
set nocount off            
              
If (@@ERROR <> 0)              
       Begin              
          RAISERROR('ERRO - Tabela de Paciente.',1,1)              
                         
       End
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
PRINT N'Altering [dbo].[ksp_radiologia_Pedido_Exame]...';


GO
ALTER PROCEDURE [dbo].[ksp_radiologia_Pedido_Exame]
@UNID_CODIGO CHAR (4), @PEDEXARADCODIGO CHAR (12), @PACCODIGO CHAR (12), @PACNOME VARCHAR (50)
, @PROFCODIGO CHAR (4), @LOCATENDCODIGO CHAR (4), @PEDEXARADTHR SMALLDATETIME
, @PEDEXARADENTRDTHR SMALLDATETIME, @EXARADCODIGO CHAR (4)
, @EXARADESCR VARCHAR (100), @EMERGENCIA CHAR (12), @ATEND_AMB CHAR (12), @INTERNACAO CHAR (12)
, @SPA_CODIGO CHAR (12), @ORIGEM CHAR (2), @TP_PESQ SMALLINT, @OPCAO INT
, @DATA_AGENDAMENTO SMALLDATETIME=NULL, @STATUS_AGENDA CHAR (1)=NULL
, @AGDCHA_CODIGO CHAR (12)=NULL, @PEXT_CODIGO CHAR (12)=NULL
, @CODIGO_SOLICITACAO CHAR (12)=NULL, @atend_codigo CHAR (12)=null
, @pedexarad_datahora DATETIME=null, @solpedexa_complemento CHAR (1)=null
AS
SET NOCOUNT ON          
          
DECLARE @LINHAS NUMERIC          
DECLARE @VAR1 VARCHAR(100)          
DECLARE @PAR VARCHAR(100)          
DECLARE @lSQL  VARCHAR(5000)        
  
  
-- ---------------------------------------------------------------------------------------------------------------  
-- Chamado 19376  26/08/2010  
  
DECLARE @DATAINIAUX datetime  
DECLARE @DATAFIMAUX datetime
  
IF @pedexarad_datahora IS NULL
	BEGIN
		SET @pedexarad_datahora = convert(datetime, convert(varchar,getdate(),112))		
	END
	
SET @DATAINIAUX = @pedexarad_datahora 
SET @DATAFIMAUX =  dateadd(day,1,@DATAINIAUX)
        
IF( @OPCAO = 0 ) /* GERA CODIGO SEQUENCIAL */          
            
     BEGIN          
         SELECT  @LINHAS = (SELECT MAX(PEDEXARAD_CODIGO) FROM PEDIDO_EXAME_RADIOLOGICO           
         WHERE LEFT(PEDEXARAD_CODIGO,8) = CONVERT(CHAR(10),GETDATE(),112))          
            
         IF( @LINHAS IS NULL)          
           BEGIN           
              SELECT @LINHAS = RTRIM(CONVERT(CHAR(10),GETDATE(),112)) + '0001'          
           END                     
        ELSE          
             BEGIN                        
     SELECT @LINHAS = @LINHAS + 1          
             END            
          
  SELECT @LINHAS          
          
    END          
             
          
IF( @OPCAO = 1 )  /* INCLUSAO */          
BEGIN          
          
          
 IF NOT EXISTS (SELECT PEDEXARAD_CODIGO  FROM PEDIDO_EXAME_RADIOLOGICO WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO )          
           
 BEGIN           
          
  DECLARE @DATAHOJE CHAR (10)          
  SET @DATAHOJE = CONVERT(VARCHAR, GETDATE(), 103)          
          
  EXEC KSP_CONTROLE_SEQUENCIAL @UNIDADE    = @UNID_CODIGO,           
     @CHAVE      = 'PEDIDO_EXAME_RADIOLOGICO',          
         @DATA       = @DATAHOJE,          
         @OPCAO      = 0,           
         @ZEROS      = 4,          
         @PROXIMO    = NULL,          
         @NOVOCODIGO = @PEDEXARADCODIGO OUTPUT          
          
  INSERT INTO PEDIDO_EXAME_RADIOLOGICO          
    (PEDEXARAD_CODIGO,          
   PAC_CODIGO,          
   PROF_CODIGO,           
   LOCATEND_CODIGO,          
   PEDEXARAD_DATAHORA,          
   PEDEXARAD_ENTREGA,          
      EMER_CODIGO,          
      ATENDAMB_CODIGO,          
      INTER_CODIGO,          
      SPA_CODIGO,          
      ORIGEM,          
      AGDCHA_CODIGO,          
      PEXT_CODIGO,          
      STATUS,          
      atend_codigo          
     )          
  VALUES          
   (@PEDEXARADCODIGO,          
   @PACCODIGO,          
   @PROFCODIGO,          
   @LOCATENDCODIGO,          
   @PEDEXARADTHR,          
   @PEDEXARADENTRDTHR,          
   @EMERGENCIA,       
   @ATEND_AMB,          
   @INTERNACAO,          
   @SPA_CODIGO,          
   @ORIGEM,          
   @AGDCHA_CODIGO,          
   @PEXT_CODIGO,          
   'R',  
   @atend_codigo)          
          
   IF (@@ERROR <> 0)          
   BEGIN          
    ROLLBACK           
    RETURN -1          
   END          
       
               END          
                   
 UPDATE SOLICITACAO_PEDIDO SET SOLPED_CODIGOPEDIDO = @PEDEXARADCODIGO WHERE [solped_codigo] = @CODIGO_SOLICITACAO          
          
        SELECT @PEDEXARADCODIGO PEDEXARADCODIGO          
                    
          
END           
          
IF( @OPCAO = 2 )  /*  ALTERACAO */          
           
   BEGIN          
          
 UPDATE PEDIDO_EXAME_RADIOLOGICO          
             SET           
    PAC_CODIGO = @PACCODIGO,          
    PROF_CODIGO = @PROFCODIGO,          
    LOCATEND_CODIGO = @LOCATENDCODIGO,          
    PEDEXARAD_DATAHORA = @PEDEXARADTHR,                    
    PEDEXARAD_ENTREGA = @PEDEXARADENTRDTHR,          
    EMER_CODIGO = @EMERGENCIA,          
    ATENDAMB_CODIGO = @ATEND_AMB,          
    INTER_CODIGO = @INTERNACAO,          
    SPA_CODIGO = @SPA_CODIGO,          
    ORIGEM = @ORIGEM,          
    PEXT_CODIGO = @PEXT_CODIGO,          
    atend_codigo = @atend_codigo
          
 WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
          
 IF EXISTS (SELECT EXARAD_CODIGO FROM EXAME_RADIOLOGICO_SOLICITADO             
       WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO AND           
                    EXARAD_CODIGO = @EXARADCODIGO AND solpedexa_complemento = @solpedexa_complemento)          
                BEGIN          
          
  UPDATE EXAME_RADIOLOGICO_SOLICITADO          
			 SET EXARAD_OBSERVACAO = @EXARADESCR,          
			 solpedexa_complemento = IsNull(@solpedexa_complemento, '0')
          WHERE  PEDEXARAD_CODIGO = @PEDEXARADCODIGO AND           
          EXARAD_CODIGO = @EXARADCODIGO   AND solpedexa_complemento = @solpedexa_complemento       
 END          
 ELSE          
                     BEGIN          
          
              INSERT INTO EXAME_RADIOLOGICO_SOLICITADO          
                          (PEDEXARAD_CODIGO,          
                           EXARAD_CODIGO,          
                           EXARAD_OBSERVACAO,
                           solpedexa_complemento, exarad_status)         
              VALUES               
                        (@PEDEXARADCODIGO,          
      @EXARADCODIGO,                   
      @EXARADESCR,isNull(@solpedexa_complemento,'0'), 'R')                   
          
          END          
                                      
   END          
          
          
IF (@OPCAO = 3 )   /*  EXCLUSAO DO PEDIDO*/          
BEGIN          
  DELETE EXAME_RADIOLOGICO_SOLICITADO          
          WHERE  PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
          
          
 DELETE PEDIDO_EXAME_RADIOLOGICO          
            WHERE  PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
                
END          
            
           
IF (@OPCAO = 4 )  /* CONSULTA POR CODIGO */          
             
 BEGIN          
          
      SELECT DISTINCT PED.PEDEXARAD_CODIGO PEDEXARADCODIGO ,           
  PED.PAC_CODIGO PACCODIGO ,           
  PACNOME = case when PAC.PAC_NOME is not null then PAC.PAC_NOME          
     when EMER.EMER_NOME  is not null then EMER.EMER_NOME          
     when SPA.SPA_NOME is not null then SPA.SPA_NOME          
     when PEXT.PEXT_NOME is not null then PEXT.PEXT_NOME   
            
  end  ,           
  PED.PROF_CODIGO PROFCODIGO,           
  PED.LOCATEND_CODIGO LOCATENDCODIGO ,            
  PED.PEDEXARAD_DATAHORA PEDEXARADATAHORA  ,           
  PED.PEDEXARAD_ENTREGA PEDEXARADENTREGA ,          
  PED.EMER_CODIGO,           
  PED.ATENDAMB_CODIGO,           
  PED.INTER_CODIGO,           
  PED.SPA_CODIGO,          
  PED.ORIGEM,          
  PROF.PROF_NOME,          
  LA.LOCATEND_DESCRICAO,          
  PED.PEDEXARAD_URGENCIA,          
  PED.PEXT_CODIGO,          
  STATUS = CASE PED.STATUS          
   WHEN 'P' THEN 'PEDIDO SOLICITADO'           
   WHEN 'R' THEN 'PEDIDO RECEBIDO'          
   WHEN 'A' THEN 'ANALISE EM ANDAMENTO'          
   WHEN 'C' THEN 'EXAME CONCLUIDO'          
   WHEN 'L' THEN 'EXAME LIBERADO'          
   END,          
  atend_codigo  
  ,P.ped_observacao  EXARADESCR      
      FROM    PEDIDO_EXAME_RADIOLOGICO PED          
  LEFT JOIN VWLOCAL_UNIDADE LA ON  PED.LOCATEND_CODIGO = LA.LOCATEND_CODIGO          
  LEFT JOIN PROFISSIONAL PROF ON PED.PROF_CODIGO = PROF.PROF_CODIGO AND PED.LOCATEND_CODIGO = PROF.LOCATEND_CODIGO          
  LEFT JOIN PACIENTE PAC ON PED.PAC_CODIGO = PAC.PAC_CODIGO           
  LEFT JOIN EMERGENCIA EMER ON PED.EMER_CODIGO = EMER.EMER_CODIGO          
  LEFT JOIN PRONTO_ATENDIMENTO SPA ON PED.SPA_CODIGO = SPA.SPA_CODIGO          
  LEFT JOIN PACIENTE_EXTERNO PEXT ON PED.PEXT_CODIGO = PEXT.PEXT_CODIGO 
  LEFT JOIN  PEDIDO P on P.ped_codigo_origem  = @PEDEXARADCODIGO and IdTipoEvento = 8         
      WHERE   PED.PEDEXARAD_CODIGO = @PEDEXARADCODIGO    

                    
END               
          
          
IF (@OPCAO = 5 )  /* CONSULTA EXAMES SOLICITADOS POR PEDIDO */          
BEGIN          
 SELECT  EXRDSO.EXARAD_CODIGO CODIGO, EXRD.EXARAD_DESCRICAO DESCRICAO, EXRDSO.EXARAD_OBSERVACAO OBSERVACAO, PEDEXARAD_CODIGO          
  ,  EXARAD_STATUS = CASE EXRDSO.EXARAD_STATUS          
   WHEN 'P' THEN 'PEDIDO SOLICITADO'           
   WHEN 'R' THEN 'PEDIDO RECEBIDO'          
   WHEN 'A' THEN 'ANALISE EM ANDAMENTO'          
   WHEN 'C' THEN 'EXAME CONCLUIDO'          
   WHEN 'L' THEN 'EXAME LIBERADO'          
   ELSE ' '          
   END,          
   GRUEXA_CODIGO,
   IsNull(solpedexa_complemento,'0') As solpedexa_complemento         
          
 FROM     EXAME_RADIOLOGICO_SOLICITADO EXRDSO INNER JOIN          
		  EXAME_RADIOLOGICO EXRD ON EXRDSO.EXARAD_CODIGO = EXRD.EXARAD_CODIGO          
          
 WHERE (EXRDSO.PEDEXARAD_CODIGO =  @PEDEXARADCODIGO) AND (EXRD.EXARAD_CODIGO = EXRDSO.EXARAD_CODIGO)          
            
END               
          
IF (@OPCAO = 6 )  /* CONSULTA POR CODIGO SEM C+DIGO DO PACIENTE*/          
BEGIN          
          
      /*SELECT   PED.PEDEXARAD_CODIGO PEDEXARADCODIGO, PED.PAC_CODIGO PACCODIGO, PAC.PAC_NOME PACNOME, PED.PROF_CODIGO PROFCODIGO,           
               PED.LOCATEND_CODIGO LOCATENDCODIGO,  PED.PEDEXARAD_DATAHORA PEDEXARADATAHORA, PED.PEDEXARAD_ENTREGA PEDEXARADENTREGA,          
        PED.EMER_CODIGO, PED.ATENDAMB_CODIGO, PED.INTER_CODIGO, ORIGEM          
      FROM     PEDIDO_EXAME_RADIOLOGICO PED, PACIENTE PAC          
      WHERE    PED.PEDEXARAD_CODIGO = @PEDEXARADCODIGO AND           
               PAC.PAC_CODIGO = PED.PAC_CODIGO          
          
      ORDER BY  PED.PEDEXARAD_CODIGO*/          
          
SET NOCOUNT ON          
 DECLARE @SQL VARCHAR(3000)          
          
 --          
 -- OTIMIZADA POR MARCOS LIMA EM 06/12/2004          
 --          
 SET @SQL =		   'SELECT DISTINCT PED.PEDEXARAD_CODIGO PEDEXARADCODIGO , '          
 SET @SQL = @SQL + ' PED.PAC_CODIGO PACCODIGO , '          
 SET @SQL = @SQL + ' PACNOME = CASE  WHEN PAC.PAC_NOME  IS NOT NULL THEN PAC.PAC_NOME'          
 SET @SQL = @SQL + '   WHEN EMER.EMER_NOME  IS NOT NULL THEN EMER.EMER_NOME'          
 SET @SQL = @SQL + '   WHEN PEXT.PEXT_NOME IS NOT NULL THEN PEXT.PEXT_NOME'          
 SET @SQL = @SQL + '   WHEN SPA.SPA_NOME IS NOT NULL THEN SPA.SPA_NOME END,'          
 SET @SQL = @SQL + ' PED.PROF_CODIGO PROFCODIGO, '          
 SET @SQL = @SQL + ' PED.LOCATEND_CODIGO LOCATENDCODIGO ,  '          
 SET @SQL = @SQL + ' PED.PEDEXARAD_DATAHORA PEDEXARADATAHORA  , '          
 SET @SQL = @SQL + ' PED.PEDEXARAD_ENTREGA PEDEXARADENTREGA ,'          
 SET @SQL = @SQL + ' PED.EMER_CODIGO, '          
 SET @SQL = @SQL + ' PED.ATENDAMB_CODIGO, '          
 SET @SQL = @SQL + ' PED.INTER_CODIGO, '          
 SET @SQL = @SQL + ' PED.SPA_CODIGO,'          
 SET @SQL = @SQL + ' PED.ORIGEM,'          
 SET @SQL = @SQL + ' PED.PEXT_CODIGO,'          
          
 SET @SQL = @SQL + '     STATUS = CASE STATUS '          
 SET @SQL = @SQL + '      WHEN ''P'' THEN ''PEDIDO SOLICITADO'' '           
 SET @SQL = @SQL + '             WHEN ''R'' THEN ''PEDIDO RECEBIDO'' '          
 SET @SQL = @SQL + '     WHEN ''A'' THEN ''ANALISE EM ANDAMENTO'' '          
 SET @SQL = @SQL + '             WHEN ''C'' THEN ''EXAME CONCLUIDO'' '          
 SET @SQL = @SQL + '             WHEN ''L'' THEN ''EXAME LIBERADO''  '          
 SET @SQL = @SQL + '     END, atend_codigo '
 SET @SQL = @SQL + '     ,  ped_observacao EXARADESCR'           
          
 SET @SQL = @SQL + ' FROM    PEDIDO_EXAME_RADIOLOGICO PED  LEFT JOIN PACIENTE PAC    ON PED.PAC_CODIGO = PAC.PAC_CODIGO '          
 SET @SQL = @SQL + '      LEFT JOIN EMERGENCIA EMER  ON PED.EMER_CODIGO = EMER.EMER_CODIGO '          
 SET @SQL = @SQL + '      LEFT JOIN PRONTO_ATENDIMENTO SPA ON PED.SPA_CODIGO = SPA.SPA_CODIGO'          
 SET @SQL = @SQL + '      LEFT JOIN PACIENTE_EXTERNO PEXT  ON PED.PEXT_CODIGO = PEXT.PEXT_CODIGO' 
 SET @SQL = @SQL + '      LEFT JOIN PEDIDO PE ON PE.PAC_CODIGO = PAC.PAC_CODIGO'          
 SET @SQL = @SQL + ' WHERE 1=1 '          
          
--1-------------------------- C=DIGO DO PEDIDO ------------------          
          
 IF @TP_PESQ IS NOT NULL          
    BEGIN          
   -- PESQUISA POR CODIGO DA PRESCRITPO          
  IF @PEDEXARADCODIGO IS NOT NULL          
  BEGIN          
             SET @VAR1 =  CONVERT(VARCHAR,@PEDEXARADCODIGO)          
             EXEC KSP_PARAMETROPESQUISA @VAR1,'PEDEXARAD_CODIGO', @TP_PESQ, 'T', @PAR OUTPUT          
          
      SET @SQL =  @SQL + ' AND ' + @PAR          
  END          
             
  -- PESQUISA POR CODIGO DO PACIENTE           
  IF @PACNOME IS NOT NULL          
  BEGIN          
             SET @VAR1 =  CONVERT(VARCHAR,@PACNOME)          
             EXEC KSP_PARAMETROPESQUISA @VAR1,'PAC_NOME', @TP_PESQ, 'T', @PAR OUTPUT          
      SET @SQL =  @SQL + ' AND ( ' + @PAR          
          
          
             SET @VAR1 =  CONVERT(VARCHAR,@PACNOME)          
             EXEC KSP_PARAMETROPESQUISA @VAR1,'EMER_NOME', @TP_PESQ, 'T', @PAR OUTPUT          
      SET @SQL =  @SQL + ' OR ' + @PAR          
          
             SET @VAR1 =  CONVERT(VARCHAR,@PACNOME)          
             EXEC KSP_PARAMETROPESQUISA @VAR1,'PEXT_NOME', @TP_PESQ, 'T', @PAR OUTPUT          
      SET @SQL =  @SQL + ' OR ' + @PAR          
          
             SET @VAR1 =  CONVERT(VARCHAR,@PACNOME)          
             EXEC KSP_PARAMETROPESQUISA @VAR1,'SPA_NOME', @TP_PESQ, 'T', @PAR OUTPUT          
      SET @SQL =  @SQL + ' OR ' + @PAR + ') '           
  END          
            
  SET @SQL = @SQL + ' ORDER BY PEDEXARAD_CODIGO DESC'          
      END          
          
    SET NOCOUNT ON          
     EXECUTE (@SQL)          
    SET NOCOUNT OFF          
          
          
          
END          
          
--------------------------------------------------------------------------------------------------------          
IF @OPCAO = 7          
 BEGIN          
--0---------------------------------------------------------------------------------------------          
/*                                         EQUIPAMENTO                                           */          
  SET NOCOUNT ON          
          
   SELECT EQUIPRAD_CODIGO, EQUIPRAD_DESC          
   FROM EQUIPAMENTO_RADIOLOGICO          
          
  SET NOCOUNT OFF          
          
 END          
/*                                           FIM                                              */          
          
IF @OPCAO = 8          
 BEGIN          
--1---------------------------------------------------------------------------------------------          
/*                                          EXAME                                             */          
  SET NOCOUNT ON          
          
   SELECT EXARAD_CODIGO, EXARAD_DESCRICAO          
   FROM EXAME_RADIOLOGICO          
          
  SET NOCOUNT OFF          
          
 END          
/*                                           FIM                                              */          
          
IF @OPCAO = 9          
 BEGIN          
--2---------------------------------------------------------------------------------------------          
/*                                          FILME                                             */          
  SET NOCOUNT ON          
          
  SELECT FIL_CODIGO, FIL_DESCRICAO          
   FROM FILME_RADIOLOGICO          
       
  SET NOCOUNT OFF          
          
 END          
/*                                           FIM                                              */          
          
IF @OPCAO = 10          
 BEGIN          
--3---------------------------------------------------------------------------------------------          
/*                                          EXAMES                                            */          
  SET NOCOUNT ON          
          
   SELECT EXARAD_CODIGO, PROCAMB_CODIGO,          
                 FIL_CODIGO, PROC_CODIGO, EXARAD_DESCRICAO,          
          EXARAD_QTDFILMES, EXARAD_TIPO          
   FROM EXAME_RADIOLOGICO          
          
  SET NOCOUNT OFF          
          
 END          
/*                                           FIM               */          
          
--11---------------------------------------------------------------------------------------------          
IF (@OPCAO = 11 )  /* CONSULTA POR CODIGO SEM C+DIGO DO PACIENTE*/          
             
 BEGIN          
          
      SELECT PEDEXARAD_CODIGO PEDEXARADCODIGO, --0          
  PAC_CODIGO PACCODIGO,   --1          
  PROF_CODIGO PROFCODIGO,   --2          
  LOCATEND_CODIGO LOCATENDCODIGO,  --3          
  PEDEXARAD_DATAHORA PEDEXARADATAHORA, --4          
  PEDEXARAD_ENTREGA PEDEXARADENTREGA, --5          
  EMER_CODIGO,    --6          
  ATENDAMB_CODIGO,   --7          
  INTER_CODIGO,    --8          
  ORIGEM,     --9          
  PEXT_CODIGO,    --10          
  atend_codigo          
      FROM PEDIDO_EXAME_RADIOLOGICO          
      WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
          
 END          
          
          
IF (@OPCAO= 12 )   /*  EXCLUSAO DE EXAME DO PEDIDO*/          
  BEGIN          
  DELETE EXAME_RADIOLOGICO_SOLICITADO          
         WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
     AND EXARAD_CODIGO = @EXARADCODIGO AND solpedexa_complemento = @solpedexa_complemento          
          
 DECLARE @QTD_EXAME INT          
 SELECT @QTD_EXAME = COUNT (EXARAD_CODIGO)           
 FROM EXAME_RADIOLOGICO_SOLICITADO           
 WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
          
 IF (@QTD_EXAME = 0)          
 BEGIN          
           --DELETE PEDIDO_REFERENCIA WHERE  PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
           DELETE PEDIDO_EXAME_RADIOLOGICO WHERE  PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
 END          
  END          
          
------------------------------------------------------------------------------------------------          
          
If @OPCAO = 13          
   BEGIN          
 select distinct
		spe.solpedexa_Codigo_Exame
	,	e.exarad_codigo
	,	e.exarad_descricao
	,	spe.solpedexa_complemento 
	,	vwsol.solped_Observacao  EXARADESCR 
             
 from EXAME_RADIOLOGICO e           
  inner join solicitacao_pedido_exame spe on (e.exarad_codigo=spe.solpedexa_Codigo_Exame)           
  inner join solicitacao_pedido sp on sp.ped_codigo = spe.ped_codigo 
  left join  vwSolicitacao_Pedido vwsol  on   vwsol.solped_codigo =  sp.solped_codigo           
 where sp.[solped_codigo] = @CODIGO_SOLICITACAO   
 
 END          
          
          
------------------------------------------------------------------------------------------------          
          
IF (@OPCAO = 14 )   /*  EXCLUSAO DE EXAME */          
  BEGIN          
  DELETE EXAME_RADIOLOGICO_SOLICITADO          
         WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO          
  AND EXARAD_CODIGO = @EXARADCODIGO  AND solpedexa_complemento = @solpedexa_complemento           
  END          
          
------------------------------------------------------------------------------------------------          
          
IF (@OPCAO = 15 ) /* Liberacao laudo */          
BEGIN            
          
 -- -------------------------------------------------------------------------------------          
 -- Libera o exame atualizando seu status...          
 -- -------------------------------------------------------------------------------------          
          
 UPDATE EXAME_RADIOLOGICO_SOLICITADO SET EXARAD_STATUS = 'L'           
 WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO           
 AND   EXARAD_CODIGO    = @EXARADCODIGO
  AND   solpedexa_complemento    = isNull(@solpedexa_complemento,'0')
          
 -- -------------------------------------------------------------------------------------          
 -- Se todos os exames de um determinado pedido estiverem liberados entÃ¯Â¿Â½o atualizamos o           
 -- antigo status do pedido. O objetivo Ã¯Â¿Â½ evitar inconsistÃ¯Â¿Â½ncia nas demais consultas hoje          
 -- existente e que sÃ¯Â¿Â½o baseadas no status do pedido e nÃ¯Â¿Â½o dos exames.          
 -- -------------------------------------------------------------------------------------          
           
 DECLARE @CONTADOR INTEGER          
           
 SET @CONTADOR = (SELECT COUNT(1) FROM EXAME_RADIOLOGICO_SOLICITADO           
      WHERE PEDEXARAD_CODIGO = @PEDEXARADCODIGO           
    AND ( EXARAD_STATUS IS NULL OR  EXARAD_STATUS <> 'L'))          
           
 IF @CONTADOR = 0           
  BEGIN          
     UPDATE PEDIDO_EXAME_RADIOLOGICO SET STATUS = 'L'            
     WHERE PEDEXARAD_CODIGO  =  @PEDEXARADCODIGO          
         END          
           
--   UPDATE PEDIDO_EXAME_RADIOLOGICO SET STATUS = 'L'            
--   WHERE PEDEXARAD_CODIGO  =  @PEDEXARADCODIGO          
          
END            
  IF (@OPCAO = 16 )  /* CONSULTA EXAMES SOLICITADOS POR PEDIDO e CODIGO DO EXAME*/          
BEGIN          
 SELECT  EXRDSO.EXARAD_CODIGO CODIGO, EXRD.EXARAD_DESCRICAO DESCRICAO, EXRDSO.EXARAD_OBSERVACAO OBSERVACAO, PEDEXARAD_CODIGO          
  ,  EXARAD_STATUS = CASE EXRDSO.EXARAD_STATUS          
   WHEN 'P' THEN 'PEDIDO SOLICITADO'           
   WHEN 'R' THEN 'PEDIDO RECEBIDO'          
   WHEN 'A' THEN 'ANALISE EM ANDAMENTO'          
   WHEN 'C' THEN 'EXAME CONCLUIDO'          
   WHEN 'L' THEN 'EXAME LIBERADO'          
   ELSE ' '          
   END,      
   exarad_documento_responsavel_paciente,      
   exarad_data_entrega_paciente,    
   exarad_data_protocolo,      
   UE.usu_nome AS usuario_entrega,      
   UE.usu_login AS login_entrega,      
   UP.usu_login AS login_protocolo,      
   UP.usu_nome AS usuario_protocolo,  
   exarad_nome_responsavel_paciente,
   isNull(solpedexa_complemento, '0') AS  solpedexa_complemento             
          
 FROM EXAME_RADIOLOGICO_SOLICITADO EXRDSO INNER JOIN          
 EXAME_RADIOLOGICO EXRD ON EXRDSO.EXARAD_CODIGO = EXRD.EXARAD_CODIGO      
 LEFT JOIN USUARIO UE ON UE.usu_codigo = EXRDSO.usu_codigo_entrega_paciente       
 LEFT JOIN USUARIO UP ON UP.usu_codigo = EXRDSO.usu_codigo_protocolo      
          
 WHERE (EXRDSO.PEDEXARAD_CODIGO =  @PEDEXARADCODIGO) AND (EXRD.EXARAD_CODIGO = @EXARADCODIGO)  AND (isNull(EXRDSO.solpedexa_complemento,0) = isNull(@solpedexa_complemento,isNull(EXRDSO.solpedexa_complemento,0)))
            
END        
        
if (@OPCAO = 17)            
begin        
select distinct  per.pedexarad_codigo,        
   convert(char(10),per.pedexarad_datahora,103) data,        
   convert(char(5),per.pedexarad_datahora,108)  hora,  
   case when p.pac_nome_social is null then isnull(p.pac_nome, pext.pext_nome) 
        else rtrim(p.pac_nome_social) +' ['+ isnull(rtrim(p.pac_nome), rtrim(pext.pext_nome)) + ']' end pac_nome,       
   --case  when p.pac_nome is not null then p.pac_nome        
   --  when emer.emer_nome  is not null then emer.emer_nome        
   --  when pext.pext_nome is not null then pext.pext_nome        
   --  when spa.spa_nome is not null then spa.spa_nome end pac_nome,        
   case per.origem when 4 then 'S' else 'N' end internacao,        
   case op.oripac_codigo          
    when 0 then per.atend_codigo        
    when 2 then per.pac_codigo        
    when 3 then per.emer_codigo        
    when 4 then per.inter_codigo        
    when 5 then per.spa_codigo        
    when 6 then per.atendamb_codigo        
   end codigo_origem,        
   op.oripac_descricao,
   ped.ped_observacao    EXARADESCR     
        
 from  pedido_exame_radiologico per        
 inner join origem_paciente op		on op.oripac_codigo		= per.origem        
 left join paciente p				on per.pac_codigo		= p.pac_codigo        
 left join emergencia emer			on per.emer_codigo		= emer.emer_codigo         
 left join pronto_atendimento spa	on per.spa_codigo		= spa.spa_codigo        
 left join paciente_externo pext	on per.pext_codigo		= pext.pext_codigo 
 left join PEDIDO ped				on ((ped.ped_codigo_origem = per.pac_codigo and 2 = ped.oripac_codigo) 
									or (ped.ped_codigo_origem = per.atend_codigo and 0 = ped.oripac_codigo)  
									or (ped.ped_codigo_origem = per.emer_codigo and 3 = ped.oripac_codigo)  
									or (ped.ped_codigo_origem = per.inter_codigo and 4 = ped.oripac_codigo)  
									or (ped.ped_codigo_origem = per.spa_codigo and 5 = ped.oripac_codigo)  
									or (ped.ped_codigo_origem = per.atendamb_codigo and 6 = ped.oripac_codigo))
									and ped.IdTipoEvento = 8 
  
 where  per.status <> 'L'        
 and  per.pedexarad_codigo like right(@unid_codigo,2) + '%'      
 --and  ped.ped_datahora >= @DATAINIAUX
 --and  ped.ped_datahora <  @DATAFIMAUX  
 and  per.pedexarad_datahora >= @DATAINIAUX  -- Chamado 19376 26/08/2010   
 AND per.pedexarad_datahora < @DATAFIMAUX   -- Chamado 19376 26/08/2010  
  
end               
        
If @OPCAO = 18 --Verifica o status dos exames        
begin            
 set @lsql = 'select  e.exarad_status as status '                 
 set @lsql = @lsql + 'from  pedido_exame_radiologico p '                 
 set @lsql = @lsql + 'inner join  exame_radiologico_solicitado e '            
 set @lsql = @lsql + 'on   p.pedexarad_codigo = e.pedexarad_codigo '                 
 set @lsql = @lsql + 'inner join  exame_radiologico el '            
 set @lsql = @lsql + 'on   e.exarad_codigo=el.exarad_codigo '            
             
 set @lsql = @lsql + 'where   1 = 1 '            
             
 If @PACCODIGO is not null            
  set @lsql = @lsql + 'and p.pac_codigo = ' + '''' + @PACCODIGO + ''''            
             
 If @INTERNACAO is not null            
  set @lsql = @lsql + 'and p.inter_codigo = ' + '''' + @INTERNACAO + ''''            
             
 if @EMERGENCIA is not null            
  set @lsql = @lsql + 'and p.emer_codigo = ' + '''' + @EMERGENCIA + ''''            
             
 if @SPA_CODIGO is not null            
  set @lsql = @lsql + 'and p.spa_codigo = ' + '''' + @SPA_CODIGO + ''''            
             
 if @ATEND_CODIGO is not null            
  set @lsql = @lsql + 'and p.atend_codigo = ' + '''' + @ATEND_CODIGO + ''''            
             
 if @ATEND_AMB is not null            
  set @lsql = @lsql + 'and p.atendamb_codigo = ' + '''' + @ATEND_AMB + ''''            
        
 exec(@lsql)            
end  

-----------------------------------Verifica internação vinculada ao pedido--------------------------------

If @OPCAO = 19
BEGIN
select i.inter_codigo,
	   p.pedexarad_codigo 
from internacao i
	   inner join pedido_exame_radiologico p on p.inter_codigo = i.inter_codigo
where i.inter_codigo = @INTERNACAO       
END   
           
If @OPCAO = 20
BEGIN

INSERT INTO EXAME_RADIOLOGICO_SOLICITADO          
                                (PEDEXARAD_CODIGO,          
                                EXARAD_CODIGO ,          
                                EXARAD_OBSERVACAO,  
								EXARAD_STATUS, solpedexa_complemento)           
              VALUES               
                               (@PEDEXARADCODIGO ,          
        @EXARADCODIGO,                   
        @EXARADESCR,   
        'R', isNull(@solpedexa_complemento,'0'))             
END           
          
IF (@@ERROR <> 0)          
  BEGIN          
    RAISERROR('ERRO !! - KSP_RADIOLOGIA_PEDIDO_EXAME',1,1)          
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
PRINT N'Altering [dbo].[ksp_Relatorio_Central_Boleto]...';


GO
ALTER PROCEDURE [dbo].[ksp_Relatorio_Central_Boleto]
@CODIGO CHAR (12), @AgdEve_TipoEvento CHAR (1)
AS
set nocount on

DECLARE @sql VARCHAR(4000)

	IF @AgdEve_TipoEvento = '1' --CONSULTA
		BEGIN
			SELECT 	RTRIM(UNID_MARC.UNID_DESCRICAO) UNIDADE,
				UNID_MARC.UNID_TELEFONE		UNID_FONE,
				CEP_UNID.CEP_LOGRADOURO + ', '
				+ UNID_MARC.UNID_ENDERECO_NUM	UNID_ENDERECO,

				'C'	TIPO,
				'COMPROVANTE DE AGENDAMENTO DE CONSULTA'  TITULO,

				ac.agd_sequencial 	NUMERO,
				ac.agdcon_senha  	SENHA,
				convert(char(10),ac.agd_datahora,103)	DATA,
				ac.agd_hora_marcada		HORA,
				Usu.USU_login			OPERADOR,
				convert(char(10),ac.agdcon_data_marcacao,103)	DATA_MARCACAO,
				CONVERT(CHAR(5),AC.agdcon_data_marcacao,108)	HORA_MARCACAO,
				CONVERT(CHAR(5),AC.agd_datahora,108) HORA_AGD,

				P.PAC_NOME			PACIENTE,
				CASE 
				  WHEN PIM.PacIdMun_Codigo IS NOT NULL THEN 'NR CARTAO MUNICIPAL:'
				  WHEN P.pac_cartao_nsaude IS NOT NULL THEN 'NR CARTAO NAC.SAUDE:'
				  WHEN P.PAC_CODIGO IS NOT NULL THEN 'NR PROVISORIO      :'
				END 				IDENTIFICACAO,

				case
				  WHEN PIM.PacIdMun_Codigo IS NOT NULL THEN PIM.PacIdMun_Codigo
				  WHEN P.pac_cartao_nsaude IS NOT NULL THEN P.pac_cartao_nsaude
				  WHEN P.PAC_CODIGO IS NOT NULL THEN P.PAC_CODIGO
				END 				CODIGO_PACIENTE,

				LOC.SET_DESCRICAO	CLINICA,
				PROF.PROF_NOME		MEDICO,
				space(50)			EXAME,
				AE.agdeve_Mensagem1,
				AE.agdeve_Mensagem2,
				AE.agdeve_Mensagem3,
				CASE	WHEN AC.AGD_TPHORARIO = 3 THEN '(EXTRA)'
				        ELSE ''
				END TipoHorario,
                cast('' as varchar (1)) as preparo,
				pp.Pac_Prontuario_Numero,
				upr.cabecalho_report1, upr.cabecalho_report2,
				upr.cabecalho_report3, upr.logo

			From	agenda_consulta ac left join profissional prof on prof.locatend_codigo = ac.locatend_codigo and prof.prof_codigo = ac.prof_codigo
			  left join vwlocal_unidade loc on loc.locatend_codigo = ac.locatend_codigo
			  left join usuario usu on usu.usu_codigo = ac.usu_codigo
			  left join unidade UNID_MARC on UNID_MARC.UNID_CODIGO = loc.unid_codigo
			  left join cep CEP_UNID on CEP_UNID.cep_sequencial = UNID_MARC.cep_sequencial
			  left join municipio MUN_UNID on MUN_UNID.mun_codigo = CEP_UNID.mun_codigo
			  LEFT JOIN paciente p on p.pac_codigo = ac.pac_codigo
			  left join PACIENTE_IDENTIFICACAO_MUNICIPIO PIM on PIM.pac_codigo = p.pac_codigo
			  left join AGENDA_EVENTOS AE ON AE.AgdEve_Codigo = AC.AgdEve_Codigo
			  LEFT JOIN Paciente_Prontuario pp ON p.pac_codigo = pp.pac_codigo and pp.unid_codigo = ac.unid_codigo
			  LEFT JOIN unidade_parametro_relatorio upr ON upr.unid_codigo = loc.unid_codigo
				
			WHERE ac.agd_sequencial = @CODIGO
		END
	
	ELSE --Exames
		BEGIN

			SET @sql =   ' SELECT 	RTRIM(UNID_MARC.UNID_DESCRICAO) UNIDADE, '
			SET @sql = @sql +  ' 	UNID_MARC.UNID_TELEFONE		UNID_FONE, '
			SET @sql = @sql +  ' 	CEP_UNID.CEP_LOGRADOURO + '', '' +  UNID_MARC.UNID_ENDERECO_NUM	UNID_ENDERECO, '

			SET @sql = @sql +  ' 	''E''		TIPO, '
			SET @sql = @sql +  ' 	''COMPROVANTE DE AGENDAMENTO DE EXAME''	TITULO, '

			SET @sql = @sql +  ' 	ae.AgeExa_Codigo 	NUMERO, '
			SET @sql = @sql +  ' 	ae.AgeExa_Senha  	SENHA, '

			SET @sql = @sql +  ' 	convert(char(10),ae.AgeExa_DataHora,103)		DATA, '
			--SET @sql = @sql +  ' 	AgeExa_hora_marcada 		HORA, '
			SET @sql = @sql +  ' 	convert(char(10),ae.AgeExa_DataHora,108)  		HORA, '

			SET @sql = @sql +  ' 	Usu.USU_login	OPERADOR, '
			SET @sql = @sql +  ' 	CONVERT(CHAR(10),ae.AgeExa_DataHora_Marcacao,103)	DATA_MARCACAO, '
			SET @sql = @sql +  ' 	CONVERT(CHAR(5),ae.AgeExa_DataHora_Marcacao,108)	HORA_MARCACAO, '

			SET @sql = @sql +  ' 	P.PAC_NOME		PACIENTE, '
			SET @sql = @sql +  ' 	CASE '
			SET @sql = @sql +  ' 	WHEN PIM.PacIdMun_Codigo IS NOT NULL THEN ''NR CARTAO MUNICIPAL:'' '
			SET @sql = @sql +  ' 	WHEN P.pac_cartao_nsaude IS NOT NULL THEN ''NR CARTAO NAC.SAUDE:'' '
			SET @sql = @sql +  ' 	WHEN P.PAC_CODIGO IS NOT NULL THEN ''NR PROVISORIO:      '' '
			SET @sql = @sql +  ' 	END 				IDENTIFICACAO, '

			SET @sql = @sql +  ' 	case '
			SET @sql = @sql +  ' 	WHEN PIM.PacIdMun_Codigo IS NOT NULL THEN PIM.PacIdMun_Codigo '
			SET @sql = @sql +  ' 	WHEN P.pac_cartao_nsaude IS NOT NULL THEN P.pac_cartao_nsaude '
			SET @sql = @sql +  ' 	WHEN P.PAC_CODIGO IS NOT NULL THEN P.PAC_CODIGO '
			SET @sql = @sql +  ' 	END 				CODIGO_PACIENTE, '

			SET @sql = @sql +  ' 	space(50)	CLINICA, '
			SET @sql = @sql +  ' 	space(50)	MEDICO, '
			SET @sql = @sql +  ' 	spe.solpedexa_Codigo_Exame + ''-'' + spe.solpedexa_descricao EXAME, '
			SET @sql = @sql +  ' 	AEV.agdeve_Mensagem1, '
			SET @sql = @sql +  ' 	AEV.agdeve_Mensagem2, '
			SET @sql = @sql +  ' 	AEV.agdeve_Mensagem3, '
			SET @sql = @sql +  ' 	'''' TipoHorario, '


            if @AgdEve_TipoEvento = '7'
                SET @sql = @sql +  ' isnull(el.exalab_Preparo,'''') preparo, '

            if @AgdEve_TipoEvento = '8'
                SET @sql = @sql +  ' case when er.impressaopreparo = ''A'' then isnull(er.preparo, '''')  end preparo, ' 

            if @AgdEve_TipoEvento = '9'
                SET @sql = @sql +  ' '''' as preparo, ' 
  

            if @AgdEve_TipoEvento <> '1' and @AgdEve_TipoEvento <> '7' and @AgdEve_TipoEvento <> '8' and @AgdEve_TipoEvento <> '9'
                SET @sql = @sql +  ' '''' as preparo, ' 

            SET @sql = @sql +  ' 	pp.Pac_Prontuario_Numero, '

			SET @sql = @sql +  ' 	upr.cabecalho_report1, upr.cabecalho_report2, upr.cabecalho_report3, upr.logo '

			SET @sql = @sql +  ' From agenda_exame ae '
			SET @sql = @sql +  ' left join usuario usu on usu.usu_codigo = ae.usu_codigo '
			SET @sql = @sql +  ' left join unidade UNID_MARC on UNID_MARC.unid_codigo = ae.unid_codigo '
			SET @sql = @sql +  ' left join cep CEP_UNID on CEP_UNID.cep_sequencial = UNID_MARC.cep_sequencial '
			SET @sql = @sql +  ' left join municipio MUN_UNID on MUN_UNID.mun_codigo = CEP_UNID.mun_codigo '
			SET @sql = @sql +  ' LEFT JOIN paciente p on p.pac_codigo = ae.pac_codigo '
			SET @sql = @sql +  ' left join PACIENTE_IDENTIFICACAO_MUNICIPIO PIM on PIM.pac_codigo = p.pac_codigo '
			SET @sql = @sql +  ' LEFT JOIN solicitacao_pedido_exame spe on spe.ped_codigo = ae.ped_codigo '

            --if @AgdEve_TipoEvento <> '7'
            --    SET @sql = @sql +  ' and spe.solpedexa_Codigo_Exame = ae.solpedexa_Codigo_Exame '

			SET @sql = @sql +  ' left join AGENDA_EVENTOS AEV ON AEV.AgdEve_Codigo = AE.AgdEve_Codigo '
			SET @sql = @sql +  ' LEFT JOIN Paciente_Prontuario pp ON p.pac_codigo = pp.pac_codigo and pp.unid_codigo = ae.unid_codigo '

            if @AgdEve_TipoEvento = '7'
                SET @sql = @sql +  ' join exame_laboratorio el on el.exalab_codigo = spe.solpedexa_Codigo_Exame '

            if @AgdEve_TipoEvento = '8'
                SET @sql = @sql +  ' join exame_radiologico er on er.exarad_codigo = spe.solpedexa_Codigo_Exame '

			SET @sql = @sql +  ' LEFT JOIN unidade_parametro_relatorio upr ON upr.unid_codigo = UNID_MARC.unid_codigo  '

			SET @sql = @sql +  ' WHERE ae.AgeExa_Codigo = ''' + @CODIGO + ''''
			
			print(@sql)

            execute (@sql)
		END


If (@@ERROR <> 0)
   BEGIN
	RAISERROR('ERRO - ksp_Relatorio_Central_Boleto.',1,1)
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
PRINT N'Altering [dbo].[ksp_relatorio_geoestatistico_spa]...';


GO
ALTER PROCEDURE [dbo].[ksp_relatorio_geoestatistico_spa]
@unid_codigo VARCHAR (4000), @data_inicial CHAR (10), @data_final CHAR (10), @municipio CHAR (7), @bairro CHAR (7), @clinica CHAR (4), @psaude CHAR (4), @opcao CHAR (1)
AS
declare @dtInicial smalldatetime, 
	@dtFinal   smalldatetime

set  @dtInicial = convert(smalldatetime,@data_inicial,103)
set  @dtFinal   = convert(smalldatetime,@data_final,103)
set  @dtFinal   = dateadd(dd, 1, @dtFinal)

set nocount on

	-- **************************

if( @opcao <> 5)
begin 

	declare @lSql varchar(3055)

	create table #spa (spa_hora int,
                           spa_dia int,
			   spa_mes int,
			   spa_ano int,
			   spa_faixa_etaria char(3),
			   locatend_codigo char(4),   
			   bai_codigo char(7),
			   mun_codigo char(7),
			   pac_codigo char(12))

        insert into #spa 
	select p.spa_hora,p.spa_dia,p.spa_mes,p.spa_ano,p.spa_faixa_etaria,p.locatend_codigo, 
	       p.bai_codigo, p.mun_codigo, pa.pac_codigo 
         from producao_spa p 
              inner join pronto_atendimento  pa on (p.spa_codigo = pa.spa_codigo) 
              inner join vwLocal_unidade l  on (p.locatend_codigo = l.locatend_codigo)
              left  join paciente pc on (pa.pac_codigo = pc.pac_codigo) 
        where p.spa_data >= @dtInicial
          and p.spa_data <  @dtFinal
          and (p.locatend_codigo = @clinica or @clinica is null)
          and (p.mun_codigo = @municipio or @municipio is null)
          and (p.bai_codigo = @bairro or @bairro is null)
          and charindex(l.unid_codigo, @unid_codigo, 1) <> 0          

		-- ************************** 

	create table #temp (  unid_codigo char(4), unid_descricao varchar(50),
				spa_hora int,
				spa_dia int,
				spa_mes int,
				spa_ano int,
				locatend_descricao varchar(50),   
				bairro_descricao char(45),
				municipio_descricao varchar(50),
				Total int,
				Crianca int,
				Adulto int,
				faixa_1 int,	faixa_2 int,	faixa_3 int,	faixa_4 int,
				faixa_5 int,	faixa_6 int,	faixa_7 int,	faixa_8 int,
				faixa_9 int,	faixa_10 int,	faixa_11 int,	faixa_12 int)

	        insert into #temp
		select	cl.unid_codigo, cl.unid_descricao,
			p.spa_hora,
			p.spa_dia,
			p.spa_mes,
			p.spa_ano,
			cl.locatend_descricao,
			case when b.bai_descricao is NULL then 'NAO INFORMADO' else b.bai_descricao end bairro_descricao,
			m.mun_descricao,
			count(*) Total,
			case when convert(int,p.spa_faixa_etaria) >= 1 	and  convert(int,p.spa_faixa_etaria) <= 4 then count(*) else 0 end Crianca,
			case when convert(int,p.spa_faixa_etaria) >= 5  then count(*) else 0 end Adulto ,
			case when convert(int,p.spa_faixa_etaria) = 1 	then count(*) else 0 end faixa_1,
			case when convert(int,p.spa_faixa_etaria) = 2 	then count(*) else 0 end faixa_2,
			case when convert(int,p.spa_faixa_etaria) = 3 	then count(*) else 0 end faixa_3,
			case when convert(int,p.spa_faixa_etaria) = 4 	then count(*) else 0 end faixa_4,
			case when convert(int,p.spa_faixa_etaria) = 5 	then count(*) else 0 end faixa_5,
			case when convert(int,p.spa_faixa_etaria) = 6 	then count(*) else 0 end faixa_6,
			case when convert(int,p.spa_faixa_etaria) = 7 	then count(*) else 0 end faixa_7,
			case when convert(int,p.spa_faixa_etaria) = 8 	then count(*) else 0 end faixa_8,
			case when convert(int,p.spa_faixa_etaria) = 9 	then count(*) else 0 end faixa_9,
			case when convert(int,p.spa_faixa_etaria) = 10 	then count(*) else 0 end faixa_10,
			case when convert(int,p.spa_faixa_etaria) = 11 	then count(*) else 0 end faixa_11,
			case when convert(int,p.spa_faixa_etaria) = 12 	then count(*) else 0 end faixa_12
		   from	#spa p 
			left join municipio m on p.mun_codigo = m.mun_codigo
			left join bairro b on p.mun_codigo = b.mun_codigo and p.bai_codigo = b.bai_codigo
			inner join vwlocal_unidade cl on p.locatend_codigo = cl.locatend_codigo
		group by cl.unid_codigo, cl.unid_descricao, 
			 m.mun_descricao, 
			 b.bai_descricao, 
			 p.spa_ano, 
			 p.spa_mes, 
			 p.spa_dia, 
			 p.spa_hora,
			 cl.locatend_descricao,
			 p.spa_faixa_etaria

end


	--	Detalhe por Municipio e Bairro

if( @opcao = '1')
begin

	select	unid_descricao, spa_dia, spa_mes, spa_ano, locatend_descricao, municipio_descricao,
		bairro_descricao, sum(Total) Total, sum(Crianca) Crianca, sum(Adulto) Adulto,  
		sum(faixa_1) faixa_1, sum(faixa_2) faixa_2, sum(faixa_3) faixa_3, sum(faixa_4) faixa_4, 
                sum(faixa_5) faixa_5, sum(faixa_6) faixa_6, sum(faixa_7) faixa_7, sum(faixa_8) faixa_8, 
		sum(faixa_9) faixa_9, sum(faixa_10) faixa_10, sum(faixa_11) faixa_11, @data_inicial DataInicial, 
		@data_final DataFinal, sum(faixa_12) faixa_12
	   from #temp
  	  group by unid_descricao, municipio_descricao,	bairro_descricao, spa_ano, spa_mes,
		   spa_dia, locatend_descricao
  	  order by unid_descricao asc, municipio_descricao asc,	bairro_descricao asc, spa_ano asc,
		   spa_mes asc,	spa_dia asc, locatend_descricao asc

	drop table #temp

end


	-- Linha de Total Diario por Municipio e Bairro 

if( @opcao = '2')
	begin

		select	unid_descricao,	municipio_descricao,	
                        sum(Total) Total, sum(Crianca) Crianca,	sum(Adulto) Adulto, sum(faixa_1) faixa_1, sum(faixa_2) faixa_2,
			sum(faixa_3) faixa_3, sum(faixa_4) faixa_4, sum(faixa_5) faixa_5, sum(faixa_6) faixa_6,	sum(faixa_7) faixa_7,
			sum(faixa_8) faixa_8, sum(faixa_9) faixa_9, sum(faixa_10) faixa_10, sum(faixa_11) faixa_11, @data_inicial DataInicial,
			@data_Final DataFinal, sum(faixa_12) faixa_12
		from #temp
		group by unid_descricao, municipio_descricao
		order by unid_descricao, municipio_descricao
    
		drop table #temp

	end

	--	Detalhe por Municipio e Bairro Di�rio

if( @opcao = '3')
begin

		create table #temp_dia 
                       (unid_descricao 	varchar(50),
                        spa_dia 		int,
                        spa_mes         int,
                        spa_ano         int,
						mun_descricao   varchar(50),
						bai_descricao   char(45),
                        dia_1 			int,
                        dia_2           int,
                        dia_3 			int,
                        dia_4           int,
                        dia_5 	        int,
                        dia_6           int,
                        dia_7           int,
                        dia_8           int,
                        dia_9 	        int,
                        dia_10 	        int,
                        dia_11 			int,					
                        dia_12 			int,					
                        dia_13          int,
                        dia_14          int,
                        dia_15          int,
                        dia_16          int,
                        dia_17          int,
                        dia_18          int,
                        dia_19          int,
                        dia_20          int,
                        dia_21          int,
                        dia_22          int,
                        dia_23          int,
                        dia_24          int,
                        dia_25          int,
                        dia_26          int,
                        dia_27          int,
                        dia_28          int,
                        dia_29          int,
                      	dia_30          int,
						dia_31          int,
                        mes_descricao varchar(10))

		insert into #temp_dia
		select 	unid_descricao,	
			spa_dia, 
			spa_mes,
            spa_ano, 
            municipio_descricao,
            bairro_descricao,
			case 	when spa_dia = 1  then sum(Total) else 0 end dia_1,
			case 	when spa_dia = 2  then sum(Total) else 0 end dia_2,
			case 	when spa_dia = 3  then sum(Total) else 0 end dia_3,
			case 	when spa_dia = 4  then sum(Total) else 0 end dia_4,
			case 	when spa_dia = 5  then sum(Total) else 0 end dia_5,
			case 	when spa_dia = 6  then sum(Total) else 0 end dia_6,
			case 	when spa_dia = 7  then sum(Total) else 0 end dia_7,
			case 	when spa_dia = 8  then sum(Total) else 0 end dia_8,
			case 	when spa_dia = 9  then sum(Total) else 0 end dia_9,
			case 	when spa_dia = 10 then sum(Total) else 0 end dia_10,
			case 	when spa_dia = 11 then sum(Total) else 0 end dia_11,
			case 	when spa_dia = 12 then sum(Total) else 0 end dia_12,
			case 	when spa_dia = 13 then sum(Total) else 0 end dia_13,
			case 	when spa_dia = 14 then sum(Total) else 0 end dia_14,
			case 	when spa_dia = 15 then sum(Total) else 0 end dia_15,
			case 	when spa_dia = 16 then sum(Total) else 0 end dia_16,
			case 	when spa_dia = 17 then sum(Total) else 0 end dia_17,
			case 	when spa_dia = 18 then sum(Total) else 0 end dia_18,
			case 	when spa_dia = 19 then sum(Total) else 0 end dia_19,
			case 	when spa_dia = 20 then sum(Total) else 0 end dia_20,
			case 	when spa_dia = 21 then sum(Total) else 0 end dia_21,
			case 	when spa_dia = 22 then sum(Total) else 0 end dia_22,
			case 	when spa_dia = 23 then sum(Total) else 0 end dia_23,
			case 	when spa_dia = 24 then sum(Total) else 0 end dia_24,
			case 	when spa_dia = 25 then sum(Total) else 0 end dia_25,
			case 	when spa_dia = 26 then sum(Total) else 0 end dia_26,
			case 	when spa_dia = 27 then sum(Total) else 0 end dia_27,
			case 	when spa_dia = 28 then sum(Total) else 0 end dia_28,
			case 	when spa_dia = 29 then sum(Total) else 0 end dia_29,
			case 	when spa_dia = 30 then sum(Total) else 0 end dia_30,
			case 	when spa_dia = 31 then sum(Total) else 0 end dia_31,
			case 	when spa_mes = 1  then 'JANEIRO' 
			        when spa_mes = 2  then 'FEVEREIRO' 
				when spa_mes = 3  then 'MAR�O' 
				when spa_mes = 4  then 'ABRIL' 
				when spa_mes = 5  then 'MAIO' 
		 	        when spa_mes = 6  then 'JUNHO' 
		 	        when spa_mes = 7  then 'JULHO' 
		 	        when spa_mes = 8  then 'AGOSTO' 
			        when spa_mes = 9  then 'SETEMBRO' 
		 	        when spa_mes = 10 then 'OUTUBRO' 
			        when spa_mes = 11 then 'NOVEMBRO' 
		 	        when spa_mes = 12 then 'DEZEMBRO' 
                        end mes_descricao
  		   from #temp
  		  group by unid_descricao, municipio_descricao, bairro_descricao,
			spa_dia, spa_mes, spa_ano 

		-- *************************** 

		select	unid_descricao,	mun_descricao, bai_descricao, spa_ano, spa_mes, mes_descricao,	
			sum(dia_1 + dia_2 + dia_3 + dia_4 + dia_5 + dia_6 + dia_7 + dia_8 + dia_9 + dia_10 + 
			    dia_11 + dia_12 + dia_13 + dia_14 + dia_15 + dia_16 + dia_17 + dia_18 + dia_19 + 
                            dia_20 + dia_21 + dia_22 + dia_23 + dia_24 + dia_25 + dia_26 + dia_27 + dia_28 +
                            dia_29 + dia_30 + dia_31 ) Total,	
			sum(dia_1) dia_1, sum(dia_2) dia_2, sum(dia_3) dia_3, sum(dia_4) dia_4,	sum(dia_5) dia_5, sum(dia_6) dia_6,	
			sum(dia_7) dia_7, sum(dia_8) dia_8, sum(dia_9) dia_9, sum(dia_10) dia_10, sum(dia_11) dia_11, sum(dia_12) dia_12,	
			sum(dia_13) dia_13, sum(dia_14) dia_14,	sum(dia_15) dia_15, sum(dia_16) dia_16,	sum(dia_17) dia_17, sum(dia_18) dia_18,	
			sum(dia_19) dia_19, sum(dia_20) dia_20,	sum(dia_21) dia_21, sum(dia_22) dia_22,	sum(dia_23) dia_23, sum(dia_24) dia_24,	
			sum(dia_25) dia_25, sum(dia_26) dia_26,	sum(dia_27) dia_27, sum(dia_28) dia_28,	sum(dia_29) dia_29, sum(dia_30) dia_30,	
			@data_inicial DataInicial, @data_Final DataFinal, sum(dia_31) dia_31
		   from #temp_dia
		group by unid_descricao, mun_descricao, bai_descricao, spa_ano, spa_mes, mes_descricao
		order by unid_descricao, spa_mes, mun_descricao, bai_descricao	

		drop table #temp_dia
		drop table #temp

end

	-- Detalhe por Munic�pio, Bairro e Faixa Et�ria 

if( @opcao = '4' )
begin

create table #temp4 (
		unid_codigo char(4),
		unid_descricao varchar(50),
		municipio_descricao varchar(50),
		bairro_descricao char(45),
		locatend_descricao varchar(50),   
		Total int,
		Crianca int,
		Adulto int,
		faixa_1 int,	faixa_2 int,	faixa_3 int,
		faixa_4 int,	faixa_5 int,	faixa_6 int,
		faixa_7 int,	faixa_8 int,	faixa_9 int,
		faixa_10 int,	faixa_11 int,
		DataInicial char(10),
		DataFinal char(10),
		faixa_12 int  
		)
		
INSERT INTO #temp4

		select unid_codigo, unid_descricao,	municipio_descricao, bairro_descricao, null,
			sum(Total) Total, sum(Crianca) Crianca,	sum(Adulto) Adulto, sum(faixa_1) faixa_1,
			sum(faixa_2) faixa_2, sum(faixa_3) faixa_3, sum(faixa_4) faixa_4, sum(faixa_5) faixa_5,
			sum(faixa_6) faixa_6, sum(faixa_7) faixa_7, sum(faixa_8) faixa_8, sum(faixa_9) faixa_9,
			sum(faixa_10) faixa_10,	sum(faixa_11) faixa_11,	@data_inicial DataInicial,
			@data_Final DataFinal, 	sum(faixa_12) faixa_12
		   from #temp
		  group by unid_codigo, unid_descricao, municipio_descricao, bairro_descricao
		  order by unid_descricao, municipio_descricao,	bairro_descricao

SELECT * FROM #temp4
	INNER JOIN unidade_parametro_relatorio upr ON upr.unid_codigo = #temp4.unid_codigo

DROP TABLE #temp4

		drop table #temp

end

	--	Detalhe por Municipio, Bairro e Grupo de Diagnostico

if( @opcao = '5')
begin

create table #temp_diagnostico (
        unid_descricao varchar(50),
	spa_dia int,
	spa_mes int,
	spa_ano int,
	bai_descricao char(45),
	mun_descricao varchar(50),
	Total int,
	grupo_1 int,
	grupo_2 int,
	grupo_3 int,
	grupo_4 int,
	grupo_5 int,
	grupo_6 int,
	grupo_7 int,
	grupo_8 int,
	grupo_9 int,
	grupo_10 int,
	grupo_11 int,
	grupo_12 int,
	grupo_13 int,
	grupo_14 int,
	grupo_15 int,
	grupo_16 int,
	grupo_17 int,
	grupo_18 int,
	grupo_19 int,
	grupo_20 int,
	grupo_21 int,
	grupo_nulo int)

	insert into #temp_diagnostico
	select	cl.unid_descricao,
		p.spa_dia,
		p.spa_mes,
		p.spa_ano,
		case when b.bai_descricao is NULL then 'NAO INFORMADO' else b.bai_descricao end bairro_descricao,
		m.mun_descricao,
		count(*) total,
		case when p.grupo_cid = 1 		then count(*) else 0 end grupo_1,
		case when p.grupo_cid = 2 		then count(*) else 0 end grupo_2,
		case when p.grupo_cid = 3 		then count(*) else 0 end grupo_3,
		case when p.grupo_cid = 4 		then count(*) else 0 end grupo_4,
		case when p.grupo_cid = 5 		then count(*) else 0 end grupo_5,
		case when p.grupo_cid = 6 		then count(*) else 0 end grupo_6,	
		case when p.grupo_cid = 7 		then count(*) else 0 end grupo_7,
		case when p.grupo_cid = 8 		then count(*) else 0 end grupo_8,
		case when p.grupo_cid = 9 		then count(*) else 0 end grupo_9,
		case when p.grupo_cid = 10 		then count(*) else 0 end grupo_10,
		case when p.grupo_cid = 11 		then count(*) else 0 end grupo_11,
		case when p.grupo_cid = 12 		then count(*) else 0 end grupo_12,
		case when p.grupo_cid = 13 		then count(*) else 0 end grupo_13,
		case when p.grupo_cid = 14 		then count(*) else 0 end grupo_14,
		case when p.grupo_cid = 15 		then count(*) else 0 end grupo_15,	
		case when p.grupo_cid = 16 		then count(*) else 0 end grupo_16,
		case when p.grupo_cid = 17 		then count(*) else 0 end grupo_17,
		case when p.grupo_cid = 18 		then count(*) else 0 end grupo_18,
		case when p.grupo_cid = 19 		then count(*) else 0 end grupo_19,
		case when p.grupo_cid = 20 		then count(*) else 0 end grupo_20,
		case when p.grupo_cid = 21 		then count(*) else 0 end grupo_21,
		case when p.grupo_cid is null then count(*)else 0 end nulos
	from	producao_spa p 
                left  join municipio m      on p.mun_codigo = m.mun_codigo
		left  join bairro b         on p.mun_codigo = b.mun_codigo and p.bai_codigo = b.bai_codigo
		inner join vwlocal_unidade cl on p.locatend_codigo = cl.locatend_codigo
	where	p.spa_data >= @dtInicial and p.spa_data < @dtfinal
	  and   (p.mun_codigo = @municipio or @municipio is null)
	  and   (p.bai_codigo = @bairro or @bairro is null)
          and charindex(cl.unid_codigo, @unid_codigo, 1) <> 0          
	group   by cl.unid_descricao, m.mun_descricao, b.bai_descricao, p.grupo_cid,	
                   p.spa_ano, p.spa_mes, p.spa_dia

	/* ************************** */

	select	unid_descricao,	bai_descricao,	mun_descricao,
		sum(total)total,
		sum(grupo_1)  grupo_1,  sum(grupo_2)  grupo_2,  sum(grupo_3)  grupo_3,
		sum(grupo_4)  grupo_4,  sum(grupo_5)  grupo_5,  sum(grupo_6)  grupo_6,
		sum(grupo_7)  grupo_7,  sum(grupo_8)  grupo_8,  sum(grupo_9)  grupo_9,
		sum(grupo_10) grupo_10,	sum(grupo_11) grupo_11, sum(grupo_12) grupo_12,
		sum(grupo_13) grupo_13,	sum(grupo_14) grupo_14,	sum(grupo_15) grupo_15,
		sum(grupo_16) grupo_16,	sum(grupo_17) grupo_17,	sum(grupo_18) grupo_18,
		sum(grupo_19) grupo_19,	sum(grupo_20) grupo_20, sum(grupo_21) grupo_21,	
		@data_inicial as DataInicial, @data_Final as DataFinal,
		sum(grupo_nulo) grupo_nao_informado
	from	#temp_diagnostico
	group   by unid_descricao, mun_descricao, bai_descricao

	drop table #temp_diagnostico

end


If( @OPCAO = '6' )
begin

	create table #temp_psaude (	
	DataInicial 		char(10),
	DataFinal 		char(10),			
	unid_descricao		varchar(50),
	spa_hora		int,
	spa_dia    		int,
	spa_mes    		int,
	spa_ano    		int,
	locatend_descricao	varchar(50),   
	bairro_descricao	char(45),
	municipio_descricao	varchar(50),
	plan_descricao		char(50),
	plan_codigo		char(4),
	Total       		int,
	Crianca     		int,
	Adulto      		int,
	faixa_1     		int,
	faixa_2     		int,
	faixa_3     		int,
	faixa_4     		int,
	faixa_5     		int,
	faixa_6     		int,
	faixa_7     		int,
	faixa_8     		int,
	faixa_9     		int,
	faixa_10    		int,
	faixa_11    		int,
	faixa_12		int)

	insert into #temp_psaude
	select	@data_inicial DataInicial, 
		@data_final 				DataFinal,
		cl.unid_descricao,
		p.spa_hora,
		p.spa_dia,	
		p.spa_mes,
		p.spa_ano,
		cl.locatend_descricao,
		case when b.bai_descricao is NULL then 'NAO INFORMADO' else b.bai_descricao end bairro_descricao,
		m.mun_descricao,
		case when ps.plan_descricao is NULL then 'NAO INFORMADO' else ps.plan_descricao end plan_descricao,
		ps.plan_codigo,
		count(*) Total,
		case when convert(int,p.spa_faixa_etaria) >= 1 	and  convert(int,p.spa_faixa_etaria) <= 4 then count(*) else 0 end Crianca,
		case when convert(int,p.spa_faixa_etaria) >= 5  then count(*) else 0 end Adulto ,
		case when convert(int,p.spa_faixa_etaria) = 1 	then count(*) else 0 end faixa_1,
		case when convert(int,p.spa_faixa_etaria) = 2 	then count(*) else 0 end faixa_2,
		case when convert(int,p.spa_faixa_etaria) = 3 	then count(*) else 0 end faixa_3,
		case when convert(int,p.spa_faixa_etaria) = 4 	then count(*) else 0 end faixa_4,
		case when convert(int,p.spa_faixa_etaria) = 5 	then count(*) else 0 end faixa_5,
		case when convert(int,p.spa_faixa_etaria) = 6 	then count(*) else 0 end faixa_6,
		case when convert(int,p.spa_faixa_etaria) = 7 	then count(*) else 0 end faixa_7,
		case when convert(int,p.spa_faixa_etaria) = 8 	then count(*) else 0 end faixa_8,
		case when convert(int,p.spa_faixa_etaria) = 9 	then count(*) else 0 end faixa_9,
		case when convert(int,p.spa_faixa_etaria) = 10 	then count(*) else 0 end faixa_10,
		case when convert(int,p.spa_faixa_etaria) = 11 	then count(*) else 0 end faixa_11,
		case when convert(int,p.spa_faixa_etaria) = 12 	then count(*) else 0 end faixa_12
	from	plano_saude ps 
		inner join paciente_plano pp on ps.plan_codigo = pp.plan_codigo  
		right join #spa p            on pp.pac_codigo = p.pac_codigo 
		left  join municipio m       on p.mun_codigo = m.mun_codigo
		left  join bairro b          on p.mun_codigo = b.mun_codigo and p.bai_codigo = b.bai_codigo
		inner join vwlocal_unidade cl  on p.locatend_codigo = cl.locatend_codigo
	group   by cl.unid_descricao, m.mun_descricao, b.bai_descricao, p.spa_ano, 
                   p.spa_mes, p.spa_dia, p.spa_hora, cl.locatend_descricao, 
                   p.spa_faixa_etaria, ps.plan_descricao, ps.plan_codigo

	if(@psaude <> '0000' and @psaude <> '' and @psaude is not null)
		begin
			select * 
                          from #temp_saude 
                         where plan_codigo = @psaude				
		end
	else
		begin
			select *
                          from #temp_psaude
		end

	drop table #temp_psaude

end

if (@@error <> 0)
   begin
		raiserror('ERRO - ',1,1)
   end

set nocount off
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
PRINT N'Altering [dbo].[ksp_espelho_aih]...';


GO
ALTER PROCEDURE [dbo].[ksp_espelho_aih]
@aih_sequencial CHAR (12), @aih_numero CHAR (13), @aih_identificacao CHAR (1), @inter_codigo CHAR (12), @aih_dtemissao SMALLDATETIME, @cid_inicial CHAR (9), @cid_secundario CHAR (9), @proc_solicitado CHAR (10), @proc_realizado CHAR (10), @esp_codigo CHAR (2), @aih_cat CHAR (10), @aih_cgc_empregador CHAR (14), @aih_anterior CHAR (13), @aih_proxima CHAR (13), @aih_uti_mes_inicial INT, @aih_uti_mes_anterior INT, @aih_uti_mes_alta INT, @motivo_cobranca CHAR (2), @aih_data_internacao SMALLDATETIME, @aih_data_alta SMALLDATETIME, @aih_dcih CHAR (7), @carater_internacao CHAR (2), @aih_critica CHAR (1), @aih_nascido_vivo INT, @aih_obito_fetal INT, @aih_alta INT, @aih_transferencia INT, @aih_obito_neoparto INT, @aih_medico_solicitante CHAR (11), @medico_responsavel CHAR (4), @locatend_medresp CHAR (4), @cod_atividade_economica CHAR (5), @cod_cbor CHAR (6), @aih_cod_vinculo INT, @pac_codigo CHAR (12), @opcao INT, @tp_pesq INT, @pac_nome VARCHAR (50), @pac_prontuario VARCHAR (10), @unid_codigo CHAR (4), @hospdia_codigo CHAR (12), @aih_conta_5 INT=null, @cid_obito CHAR (4)=null, @cid_associados CHAR (4)=null, @aih_cpf_gestor VARCHAR (11)=null, @aih_gestor_data DATETIME=null, @aih_gestor_codigo_autorizacao VARCHAR (5)=null, @usu_codigo CHAR (4)=null, @aih_numero_sisprenatal CHAR (12)=null, @aih_modalidade CHAR (2)='02', @aih_medico_responsavel CHAR (4)=null, @aih_locatend_codigo_medico_responsavel CHAR (4)=null, @aih_cpf_medresp CHAR (11)=null, @aih_medico_autorizador CHAR (4)=null, @aih_cpf_medauto CHAR (11)=null, @aih_qtde_filhos INT=null, @aih_cid_laq_vas CHAR (4)=null, @aih_grau_instrucao INT=null, @aih_contraceptivo1 INT=null, @aih_contraceptivo2 INT=null, @aih_gest_risco CHAR (1)=null, @aih_peso_nascer INT=null, @aih_mes_gestacional INT=null, @aih_saida_uti INT=null, @valor_procedimento REAL=0, @EhAIH_Provisoria CHAR (1)=null, @AIH_NUMERO_PROVISORIO CHAR (13)=NULL, @aih_CNS_medsolici CHAR (15)=null, @aih_CNS_medresp CHAR (15)=null, @aih_CNS_medauto CHAR (15)=null, @cns_justificativa VARCHAR (50)=null, @cid_secundario1 CHAR (4)=null, @cid_secundario2 CHAR (4)=null, @cid_secundario3 CHAR (4)=null, @cid_secundario4 CHAR (4)=null, @cid_secundario5 CHAR (4)=null, @cid_secundario6 CHAR (4)=null, @cid_secundario7 CHAR (4)=null, @cid_secundario8 CHAR (4)=null, @cid_secundario9 CHAR (4)=null, @cid_secundario_caracteristica1 INT=null, @cid_secundario_caracteristica2 INT=null, @cid_secundario_caracteristica3 INT=null, @cid_secundario_caracteristica4 INT=null, @cid_secundario_caracteristica5 INT=null, @cid_secundario_caracteristica6 INT=null, @cid_secundario_caracteristica7 INT=null, @cid_secundario_caracteristica8 INT=null, @cid_secundario_caracteristica9 INT=null
AS
set nocount on


declare @unid_codigo_int char(3)
set 	@unid_codigo_int = right(@unid_codigo,2) + '%'



-- CARGA DOS DADOS -----------------------------------------------------------------------------------------------------    
if @opcao = 0    
begin    
    
 select ea.aih_sequencial,   -- 0    
   ea.aih_numero,    -- 1    
   ea.aih_identificacao,    -- 2    
   isnull(ea.inter_codigo,ea.hospdia_codigo) as inter_codigo, -- 3    
   ea.aih_dtemissao,   -- 4    
   ea.cid_codigo,    -- 5    
   cid_10.cid_descricao,   -- 6    
   ea.cid_secundario,   -- 7    
   cid_secundario.cid_descricao as cid_secundario_descricao,  -- 8    
   ea.proc_codigo,    -- 9    
   procedimento.proc_descricao,  --10    
   ea.aih_proc_realizado,   --11    
   procedimento_real.proc_descricao as procreal_descricao,    --12    
   ea.esp_codigo,           --13    
   especialidade_aih.esp_descricao, --14    
   ea.aih_cat,    --15    
   ea.aih_cgc_empregador,      --16    
   ea.aih_anterior,   --17    
   ea.aih_proxima,       --18    
   null,-- ea.locatend_codigo,   --19 -- dados do mÃƒÂ©dico auditor    
   null,-- vwlocal_unidade.locatend_descricao, --20 -- dados do mÃƒÂ©dico auditor    
   null,-- ea.prof_codigo,    --21 -- dados do mÃƒÂ©dico auditor    
   null,-- prof.prof_nome,           --22 -- dados do mÃƒÂ©dico auditor    
   ea.aih_uti_mesinicial,   --23    
   ea.aih_uti_mesanterior,   --24    
   ea.aih_uti_mesalta,   --25    
   ea.aih_diaria_acomp,      --26    
     ea.motcob_codigo,   --27    
   motivo_cobranca_aih.motcob_descricao,   --28    
   ea.aih_dtinternacao,   --29    
   ea.aih_dtalta,       --30    
   ea.aih_dcih,    --31    
   paih.pac_codigo,   --32    
   paih.pac_nome,                --33    
   ea.carint_codigo,    --34    
   ci.carint_descricao,    --35    
   ea.aih_nascido_vivo,    --36    
   ea.aih_obito_fetal,    --37    
   ea.aih_alta,     --38    
   ea.aih_transferido,    --39    
   ea.aih_obito_neoparto,    --40    
      ea.aih_autorizacao_auditor,   --41    
      ea.aih_medico_solicitante,   --42    
   '' as prof_nome,    --43    
   ea.medico_responsavel,                  --44    
   ea.locatend_cod_med_resp,  --45    
            ea.cod_cnaer,    --46    
            ea.cod_cbor,    --47    
            ea.aih_cod_vinculo,   --48    
   isnull(ea.aih_critica,'0') critica, --49    
   oc.descricao as ocu_descricao,  --50    
   ae.descricao as atveco_descricao, --51    
   convert(char(10),convert(smalldatetime,ap.apres + '01' ,112),103) apres, --52    
   isnull(i.inter_dtalta,hd.hospdia_datafim) inter_dtalta, --53    
   case when ea.hospdia_codigo is null then 0 else -1 end ehhospitaldia, --54 (apenas para testar se a aih ÃƒÂ© hd)    
   ea.aih_conta_7,   --55    
   ea.cid_obito,   --56    
   cid_obito.cid_descricao as cid_Obito_descricao, --57    
   ea.cid_associados,  --58    
   cid_associados.cid_descricao as cid_associados_Descricao, --59    
   ea.aih_cpf_gestor,  --60    
   ea.aih_gestor_data,  --61    
   ea.aih_gestor_codigo_autorizacao, --62    
   ea.aih_numero_sisprenatal, --63    
   ea.aih_modalidade,  --64    
   ea.aih_medico_responsavel, --65    
   ea.aih_locatend_codigo_medico_responsavel, --66    
   ea.aih_cpf_medresp, --67    
   ea.aih_medico_autorizador, --68    
   ea.aih_cpf_medauto, -- 69    
   ea.aih_qtde_filhos, -- 70    
   ea.aih_cid_laq_vas, -- 71    
   ea.aih_grau_instrucao, -- 72    
   ea.aih_contraceptivo1, -- 73    
   ea.aih_contraceptivo2, -- 74    
   ea.aih_gest_risco, --75    
   ea.aih_peso_nascer, -- 76    
   ea.aih_mes_gestacional, --77    
   ea.aih_saida_uti, --78    
   ea.hospdia_codigo, --79    
   FA.faiaih_inicial, --80    
   FA.faiaih_final, --81    
   @unid_codigo unid_codigo,  --82    
   (procedimento.proc_serv_prof + procedimento.proc_serv_hosp + procedimento.proc_serv_sadt) AS valor_procedimento,    
   ea.ehaih_provisoria,    
   ea.aih_CNS_medsolici,    
   ea.aih_CNS_medresp,    
   ea.aih_CNS_medauto,  
   ea.cns_justificativa,
   ea.Aih_Numero_SisPreNatal,
   ea.cid_secundario1,
   ea.cid_secundario2,
   ea.cid_secundario3,
   ea.cid_secundario4,
   ea.cid_secundario5,
   ea.cid_secundario6,
   ea.cid_secundario7,
   ea.cid_secundario8,
   ea.cid_secundario9,
   ea.cid_secundario_caracteristica1,
   ea.cid_secundario_caracteristica2,
   ea.cid_secundario_caracteristica3,
   ea.cid_secundario_caracteristica4,
   ea.cid_secundario_caracteristica5,
   ea.cid_secundario_caracteristica6,
   ea.cid_secundario_caracteristica7,
   ea.cid_secundario_caracteristica8,
   ea.cid_secundario_caracteristica9                                
    
 from   espelho_aih  ea    
    
 inner join  cid_10    
  on   ea.cid_codigo = cid_10.cid_codigo    
    
 inner join  especialidade_aih     
 on   ea.esp_codigo = especialidade_aih.esp_codigo    
    
 inner join  paciente_aih paih     
 on   ea.aih_sequencial = paih.aih_sequencial    
    
 inner join  carater_internacao ci    
 on   ea.carint_codigo = ci.carint_codigo    
    
 left join  procedimento    
 on   ea.proc_codigo = procedimento.proc_codigo    
    
 left join  procedimento procedimento_real    
 on   ea.aih_proc_realizado = procedimento_real.proc_codigo    
    
 left join  cid_10 cid_secundario    
 on   ea.cid_secundario = cid_secundario.cid_codigo    
    
 left join  cid_10 cid_obito    
 on   ea.cid_obito = cid_obito.cid_codigo    
    
 left join  cid_10 cid_associados    
 on   ea.cid_associados = cid_associados.cid_codigo    
    
 left join  motivo_cobranca_aih     
 on   ea.motcob_codigo = motivo_cobranca_aih.motcob_codigo    
    
 left join  ocupacoes oc    
 on   ea.cod_cbor = oc.cod_cbor    
    
 left join  atividade_economica ae    
 on   ea.cod_cnaer = ae.cod_cnaer    
    
 left join  previsao_faturamento ap    
 on   ea.aih_sequencial = ap.aih_sequencial    
    
 left join  internacao i    
 on  ea.inter_codigo = i.inter_codigo    
    
 left join  hospitaldia hd    
 on   ea.hospdia_codigo = hd.hospdia_codigo    
    
    
 LEFT JOIN  faixa_aih fa    
 on  fa.unid_codigo = @unid_codigo and fa.faiaih_final >= fa.faiaih_inicial    
 where    rtrim(ea.aih_numero) = rtrim(@aih_numero)    
 and  ea.aih_identificacao    = @aih_identificacao    
 and  isnull(ea.aih_conta_7,'') = isnull(@aih_conta_5,'')    
 and  ea.aih_sequencial like  @unid_codigo_int    
end    
    
    
    
-- INCLUSAO DOS DADOS --------------------------------------------------------------------------------------------------    
if(@opcao = 1)    
begin    
    
 declare @datahoje char (10)    
 set @datahoje = convert (varchar, getdate (), 103)    
    
 exec ksp_controle_sequencial @unidade    = @unid_codigo ,     
         @chave      = 'espelho_aih' ,     
         @data       = @datahoje,     
         @novocodigo = @aih_sequencial output    
             
 select @aih_medico_solicitante = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medsolici    
 select @aih_cpf_medresp = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medresp    
 select @aih_cpf_medauto = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medauto    
    
 insert into espelho_aih     
         (aih_sequencial,    
                aih_numero,    
             aih_identificacao,    
             inter_codigo,    
             aih_dtemissao,    
             cid_codigo,    
             cid_secundario,    
             proc_codigo,    
             aih_proc_realizado,    
             esp_codigo,    
             aih_cat,    
             aih_cgc_empregador,    
             aih_anterior,    
             aih_proxima,    
             aih_uti_mesinicial,    
             aih_uti_mesanterior,    
             aih_uti_mesalta,    
             motcob_codigo,    
             aih_dtinternacao,    
             aih_dtalta,    
             aih_dcih,     
    carint_codigo,     
    aih_critica,     
    aih_nascido_vivo,     
    aih_obito_fetal,     
    aih_alta,     
    aih_transferido,     
    aih_obito_neoparto,     
    aih_medico_solicitante,     
    medico_responsavel,     
    locatend_cod_med_resp,    
    cod_cnaer,    
    cod_cbor,    
    aih_cod_vinculo,    
    hospdia_codigo,    
    aih_conta_7,    
    cid_obito,    
    cid_associados,    
    aih_cpf_gestor,    
    aih_gestor_data,    
    aih_gestor_codigo_autorizacao,    
    datahoje,    
    usu_codigo,    
    aih_numero_sisprenatal,    
    aih_modalidade,    
    aih_nova,    
    aih_medico_responsavel,    
    aih_locatend_codigo_medico_responsavel,    
    aih_cpf_medresp,    
    aih_medico_autorizador,     
    aih_cpf_medauto,    
    aih_qtde_filhos,    
    aih_cid_laq_vas,    
    aih_grau_instrucao,    
    aih_contraceptivo1,    
    aih_contraceptivo2,    
    aih_gest_risco,    
    aih_peso_nascer,    
    aih_mes_gestacional,    
    aih_saida_uti,    
    ehaih_provisoria,    
    aih_CNS_medsolici,    
    aih_CNS_medresp,    
    aih_CNS_medauto,  
    cns_justificativa,
	cid_secundario1,
	cid_secundario2,
	cid_secundario3,
	cid_secundario4,
	cid_secundario5,
	cid_secundario6,
	cid_secundario7,
	cid_secundario8,
	cid_secundario9,
	cid_secundario_caracteristica1,
	cid_secundario_caracteristica2,
	cid_secundario_caracteristica3,
	cid_secundario_caracteristica4,
	cid_secundario_caracteristica5,
	cid_secundario_caracteristica6,
	cid_secundario_caracteristica7,
	cid_secundario_caracteristica8,
	cid_secundario_caracteristica9)
    
 values      (@aih_sequencial,    
    @aih_numero,    
    @aih_identificacao,        
    @inter_codigo,    
    @aih_dtemissao,    
    @cid_inicial,    
    @cid_secundario,    
    @proc_solicitado,    
    @proc_realizado,        
    @esp_codigo,            
    @aih_cat,    
    @aih_cgc_empregador,        
    @aih_anterior,    
    @aih_proxima,        
    @aih_uti_mes_inicial,    
    @aih_uti_mes_anterior,    
    @aih_uti_mes_alta,         
    @motivo_cobranca,            
    @aih_data_internacao,    
    @aih_data_alta,        
    @aih_dcih,     
    @carater_internacao,     
    @aih_critica,    
    @aih_nascido_vivo,     
    @aih_obito_fetal,    
     @aih_alta,     
    @aih_transferencia,    
    @aih_obito_neoparto,     
    @aih_medico_solicitante,     
    @medico_responsavel,     
    @locatend_medresp,    
                @cod_atividade_economica,    
                @cod_cbor,    
                @aih_cod_vinculo,    
    @hospdia_codigo,    
    @aih_conta_5,    
    @cid_obito,    
    @cid_associados,    
    @aih_cpf_gestor,    
    @aih_gestor_data,    
    @aih_gestor_codigo_autorizacao,    
    getdate(),    
    @usu_codigo,    
    @aih_numero_sisprenatal,    
    @aih_modalidade,    
    'S',    
    @aih_medico_responsavel,    
    @aih_locatend_codigo_medico_responsavel,    
    @aih_cpf_medresp,    
    @aih_medico_autorizador,    
    @aih_cpf_medauto,    
    @aih_qtde_filhos,    
    @aih_cid_laq_vas,    
    @aih_grau_instrucao,    
    @aih_contraceptivo1,    
    @aih_contraceptivo2,    
    @aih_gest_risco,    
    @aih_peso_nascer,    
    @aih_mes_gestacional,    
    @aih_saida_uti,    
    @EhAIH_Provisoria,    
    @aih_CNS_medsolici,    
    @aih_CNS_medresp,    
    @aih_CNS_medauto,  
    @cns_justificativa,
	@cid_secundario1,
	@cid_secundario2,
	@cid_secundario3,
	@cid_secundario4,
	@cid_secundario5,
	@cid_secundario6,
	@cid_secundario7,
	@cid_secundario8,
	@cid_secundario9,
	@cid_secundario_caracteristica1,
	@cid_secundario_caracteristica2,
	@cid_secundario_caracteristica3,
	@cid_secundario_caracteristica4,
	@cid_secundario_caracteristica5,
	@cid_secundario_caracteristica6,
	@cid_secundario_caracteristica7,
	@cid_secundario_caracteristica8,
	@cid_secundario_caracteristica9)    
    
    
 if (@@error <> 0) goto trataerro    
    
 select   @aih_sequencial aih_sequencia    
end    
    
    
    
-- ALTERACAO DOS DADOS -------------------------------------------------------------------------------------------------    
if @opcao = 2    
begin    
    
 select @aih_medico_solicitante = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medsolici    
 select @aih_cpf_medresp = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medresp    
 select @aih_cpf_medauto = prof_cpf from profissional_rede where prof_cns = @aih_CNS_medauto    
    
 update espelho_aih set     
            aih_numero             = @aih_numero,    
            aih_identificacao      = @aih_identificacao,    
            inter_codigo           = @inter_codigo,    
          aih_dtemissao          = @aih_dtemissao,    
            cid_codigo             = @cid_inicial,    
            cid_secundario         = @cid_secundario,    
            proc_codigo            = @proc_solicitado,    
            aih_proc_realizado        = @proc_realizado,        
            esp_codigo             = @esp_codigo,            
            aih_cat                = @aih_cat,    
            aih_cgc_empregador     = @aih_cgc_empregador,        
            aih_anterior           = @aih_anterior,    
            aih_proxima            = @aih_proxima,        
            aih_uti_mesinicial     = @aih_uti_mes_inicial,    
            aih_uti_mesanterior    = @aih_uti_mes_anterior,    
            aih_uti_mesalta        = @aih_uti_mes_alta,     
            motcob_codigo          = @motivo_cobranca,            
            aih_dtinternacao       = @aih_data_internacao,    
            aih_dtalta             = @aih_data_alta,        
            aih_dcih               = @aih_dcih,     
   carint_codigo          = @carater_internacao,     
   aih_critica            = @aih_critica,     
   aih_nascido_vivo       = @aih_nascido_vivo,     
   aih_obito_fetal        = @aih_obito_fetal,     
   aih_alta               = @aih_alta,     
   aih_transferido        = @aih_transferencia,     
   aih_obito_neoparto     = @aih_obito_neoparto,     
   aih_medico_solicitante    = @aih_medico_solicitante,     
   medico_responsavel     = @medico_responsavel,    
   locatend_cod_med_resp     = @locatend_medresp,    
            cod_cnaer                 = @cod_atividade_economica,    
            cod_cbor                  = @cod_cbor,    
            aih_cod_vinculo           = @aih_cod_vinculo,    
   hospdia_codigo     = @hospdia_codigo,    
   cid_obito      = @cid_obito,    
   cid_associados     = @cid_associados,    
   aih_cpf_gestor      = @aih_cpf_gestor ,    
   aih_gestor_data     = @aih_gestor_data ,    
   aih_gestor_codigo_autorizacao  = @aih_gestor_codigo_autorizacao,    
   aih_numero_sisprenatal    = @aih_numero_sisprenatal,    
   aih_modalidade     = @aih_modalidade,     
   aih_nova      = 's',    
   aih_medico_responsavel    = @aih_medico_responsavel,    
   aih_locatend_codigo_medico_responsavel  = @aih_locatend_codigo_medico_responsavel,    
   aih_cpf_medresp     = @aih_cpf_medresp,    
   aih_medico_autorizador   = @aih_medico_autorizador,    
   aih_cpf_medauto     = @aih_cpf_medauto,    
   aih_qtde_filhos     = @aih_qtde_filhos,    
   aih_cid_laq_vas     = @aih_cid_laq_vas,    
   aih_grau_instrucao    = @aih_grau_instrucao,    
   aih_contraceptivo1    = @aih_contraceptivo1,    
   aih_contraceptivo2    = @aih_contraceptivo2,    
   aih_gest_risco     = @aih_gest_risco,    
   aih_peso_nascer     = @aih_peso_nascer,    
   aih_mes_gestacional    = @aih_mes_gestacional,    
   aih_saida_uti     = @aih_saida_uti,    
   ehaih_provisoria    = @EhAIH_Provisoria,    
   aih_CNS_medsolici    = @aih_CNS_medsolici,    
   aih_CNS_medresp     = @aih_CNS_medresp,    
   aih_CNS_medauto     = @aih_CNS_medauto,  
   cns_justificativa   = @cns_justificativa,
   usu_codigo		   = @usu_codigo,
   cid_secundario1 = @cid_secundario1,
   cid_secundario2 = @cid_secundario2,
   cid_secundario3 = @cid_secundario3,
   cid_secundario4 = @cid_secundario4,
   cid_secundario5 = @cid_secundario5,
   cid_secundario6 = @cid_secundario6,
   cid_secundario7 = @cid_secundario7,
   cid_secundario8 = @cid_secundario8,
   cid_secundario9 = @cid_secundario9,
   cid_secundario_caracteristica1 = @cid_secundario_caracteristica1,
   cid_secundario_caracteristica2 = @cid_secundario_caracteristica2,
   cid_secundario_caracteristica3 = @cid_secundario_caracteristica3,
   cid_secundario_caracteristica4 = @cid_secundario_caracteristica4,
   cid_secundario_caracteristica5 = @cid_secundario_caracteristica5,
   cid_secundario_caracteristica6 = @cid_secundario_caracteristica6,
   cid_secundario_caracteristica7 = @cid_secundario_caracteristica7,
   cid_secundario_caracteristica8 = @cid_secundario_caracteristica8,
   cid_secundario_caracteristica9 = @cid_secundario_caracteristica9
    
 where espelho_aih.aih_sequencial   = @aih_sequencial    
    
    
 if (@@error <> 0) goto trataerro        
    
 delete from  erro_aih    
 where  aih_sequencial = @aih_sequencial    
 and (   (@aih_gestor_codigo_autorizacao = '001' and criaih_codigo = '933' )    
  or  (@aih_gestor_codigo_autorizacao = '002' and criaih_codigo = '937' )    
  or  (@aih_gestor_codigo_autorizacao = '003' and criaih_codigo = '9371' )    
  )    
    
 if (@@error <> 0) goto trataerro        
end    
    
    
    
-- EXCLUSAO DOS DADOS --------------------------------------------------------------------------------------------------    
if @opcao = 3    
begin    
    
 select  @aih_numero = aih_numero,    
  @aih_identificacao = aih_identificacao    
    
 from  espelho_aih     
 where  aih_sequencial = @aih_sequencial    
    
 while isnull(@aih_sequencial,'') <> ''    
 begin    
  delete  from erro_aih    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  delete  previsao_faturamento    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  delete  from atos_profissionais    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  delete  from auditor_procedimento    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  delete  from paciente_aih    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  delete from espelho_aih_nascidos    
  where aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
  
  
  delete AIH_Internacao_Consolidada
  where AIH_Internacao_Consolidada.aih_sequencial = @aih_sequencial

  if (@@error <> 0) goto trataerro   
    
  delete  espelho_aih    
  where espelho_aih.aih_sequencial = @aih_sequencial    
    
  if (@@error <> 0) goto trataerro        
    
  select  @aih_sequencial = ''    
    
  select  @aih_sequencial = aih_sequencial     
    
  from  espelho_aih     
    
  where aih_numero = @aih_numero    
  and  aih_identificacao = '5'    
  and  @aih_identificacao = '1'    
 end    
end    
    
    
    
-- SELECAO DOS DADOS DA INTERNACAO  -----------------------------------------------------------------------------------    
if @opcao = 5    
begin    
    
 set nocount on    
    
	SELECT  null Aih_Sequencial,         
		null Aih_Numero,         
		'1'  Aih_Identificacao,         
		internacao.inter_codigo     Inter_Codigo,         
		internacao.inter_datainter    Aih_DtEmissao,         
		pedido_internacao.cid_codigo ,      
		cid_10.cid_descricao as cid_descricao ,       
		pedido_internacao.cid_secundario ,     
		cid_secundario.cid_descricao as cid_secundario_descricao,      
		pedido_internacao.proc_codigo proc_codigo,      
		procedimento.proc_descricao proc_descricao,      
		pedido_internacao.proc_codigo as aih_proc_realizado,      
		procedimento.proc_descricao procreal_descricao,      
		case when datediff(day,pac_nascimento, getdate()) > 5110 -- 14 anos
			then (SELECT TOP 1 CO_TIPO_LEITO FROM rl_procedimento_leito WHERE CO_PROCEDIMENTO = pedido_internacao.proc_codigo)
			else '07'
		end as 'Esp_Codigo',                
		null Esp_Descricao,         
		null Aih_Cat,         
		null Aih_Cgc_Empregador,         
		null Aih_Anterior,         
		null Aih_Proxima,         
		null Locatend_Codigo,         
		null locatend_descricao,         
		null prof_codigo,         
		null prof_nome1,               
		null Aih_Uti_MesInicial,    
		null Aih_Uti_MesAnterior,    
		null Aih_Uti_MesAlta,    
		null Aih_Diaria_Acomp,    
		--ECO.07/03/2003    
		internacao.inter_motivo_alta MotCob_Codigo,         
		mc.motcob_descricao    MotCob_Descricao,    
		internacao.inter_datainter     aih_dtinternacao,      
		internacao.inter_dtalta      aih_dtalta,      
		null                            Aih_Dcih,         
		paciente.pac_codigo,       
		paciente.pac_nome,        
		ci.carint_codigo,    
		ci.carint_descricao,         
		ip.intpart_nasc_vivo      aih_nascido_vivo,        
		ip.intpart_obito_fetal      aih_obito_fetal,       
		ip.intpar_alta_neoparto     aih_alta,    
		ip.intpar_transf_neoparto    aih_transferido,     
		ip.intpart_obito_neoparto     aih_obito_neoparto,    
		pedido_internacao.prof_codigo      as medico_responsavel, --medico solicitante    
		isnull(internacao.prof_codigo_resp, internacao.prof_codigo) as aih_medico_responsavel,    
		p.prof_nome    as prof_nome,    
		'0'    critica,    
		-- NULL     Aih_Numero_SisPreNatal,    
		paciente.PAC_SIS_PRENATAL       Aih_Numero_SisPreNatal,    -- Chamado 20432 - 04/04/2011     
    
		case when Internacao_Pid.Inter_Codigo is not null 
			then '04'    
			else '02'    
		END aih_modalidade,    
		p.prof_cpf   as aih_cpf_medresp,    
		FA.faiaih_inicial,     
		FA.faiaih_final,    
		@unid_codigo unid_codigo,    
		null   aih_medico_solicitante ,    
		null   aih_medico_autorizador,    
		null   aih_cpf_medauto    
    
	FROM DBO.internacao with(nolock)     
		inner join DBO.pedido_internacao with(nolock) on internacao.pedint_sequencial = pedido_internacao.pedint_sequencial    
		inner join DBO.cid_10 with(nolock) on pedido_internacao.cid_codigo = cid_10.cid_codigo    
		left join DBO.cid_10 cid_secundario with(nolock)  on pedido_internacao.cid_secundario = cid_secundario.cid_codigo    
		inner join DBO.procedimento with(nolock) on pedido_internacao.proc_codigo = procedimento.proc_codigo    
		inner join DBO.paciente with(nolock) on internacao.pac_codigo = paciente.pac_codigo    
		inner join DBO.carater_internacao ci with(nolock) on pedido_internacao.carint_codigo = ci.carint_codigo    
		left join DBO.internacao_parto ip with(nolock) on internacao.inter_codigo = ip.inter_codigo    
		left join dbo.profissional_rede p with(nolock) on Internacao.PROF_CODIGO_RESP = P.PROF_CODIGO    
		left join dbo.motivo_cobranca_aih mc with(nolock) on internacao.inter_motivo_alta = mc.motcob_codigo    
		LEFT JOIN DBO.Internacao_Pid with(nolock) ON Internacao_Pid.Inter_Codigo = internacao.Inter_Codigo    
		LEFT JOIN faixa_aih fa on fa.unid_codigo = @unid_codigo and fa.faiaih_final >= fa.faiaih_inicial    
    
	WHERE  internacao.inter_codigo    = @Inter_codigo    
		and internacao.inter_codigo    like  @unid_codigo_int    
    
 SET NOCOUNT OFF    
    
END    
    
    
    
-------    
if @opcao = 52    
    
    BEGIN    
 SET NOCOUNT ON    
    
 SELECT  null    Aih_Sequencial,         
  null    Aih_Numero,         
  null    Aih_Identificacao,         
  HospitalDia.hospdia_codigo,      
  HospitalDia.hospdia_DataInicio Aih_DtEmissao,         
  HospitalDia.cid_codigo,      
  cid_10.cid_descricao   cid_descricao ,       
  null    cid_secundario,     
  null    cid_secundario_descricao,      
  HospitalDia.proc_codigo  proc_codigo,      
  procedimento.proc_descricao  proc_descricao,      
  HospitalDia.proc_codigo  aih_proc_realizado,      
  procedimento.proc_descricao procreal_descricao,      
  null       Esp_Codigo,                
  null       Esp_Descricao,         
  null       Aih_Cat,         
  null       Aih_Cgc_Empregador,         
      null       Aih_Anterior,         
  null       Aih_Proxima,         
      null       Locatend_Codigo,         
  null       locatend_descricao,         
  null       prof_codigo,         
  null       prof_nome1,    
  null       Aih_Uti_MesInicial,    
  null       Aih_Uti_MesAnterior,    
  null       Aih_Uti_MesAlta,    
      null       Aih_Diaria_Acomp,    
      null          MotCob_Codigo,         
  null          MotCob_Descricao,         
    
         HospitalDia.hospdia_DataInicio aih_dtinternacao,      
  HospitalDia.hospdia_DataFim aih_dtalta,      
      null                               Aih_Dcih,         
  paciente.pac_codigo,       
  paciente.pac_nome,        
  null carint_codigo,    
  null carint_descricao,         
    
  null  aih_nascido_vivo,        
  null  aih_obito_fetal,       
  null  aih_alta,    
  null aih_transferido,    
  null  aih_obito_neoparto,    
  hospitaldia.prof_codigo  as aih_medico_responsavel,     
  p.prof_nome    as prof_nome,    
  '0'    critica,    
  null    Aih_Numero_SisPreNatal,    
  '03' aih_modalidade,    
  p.prof_cpf   as  aih_cpf_medresp,    
  FA.faiaih_inicial,     
  FA.faiaih_final,    
  @unid_codigo unid_codigo,    
  null   aih_medico_solicitante,    
  null   aih_medico_autorizador,    
  null   aih_cpf_medauto,    
  -1    ehhospitaldia    
    
    
 FROM DBO.HospitalDia     
  inner join DBO.cid_10 on HospitalDia.cid_codigo = cid_10.cid_codigo    
  inner join DBO.procedimento on HospitalDia.proc_codigo = procedimento.proc_codigo    
  inner join DBO.paciente on HospitalDia.pac_codigo = paciente.pac_codigo    
  inner join dbo.profissional_rede p on HospitalDia.PROF_CODIGO = P.PROF_CODIGO     
  LEFT JOIN faixa_aih fa on fa.unid_codigo = @unid_codigo and fa.faiaih_final >= fa.faiaih_inicial    
 WHERE  HospitalDia.hospdia_codigo    = @HospDia_Codigo    
 and HospitalDia.hospdia_codigo    like  @unid_codigo_int    
    
 SET NOCOUNT OFF    
    
END    
    
    
-- ***************************************************    
    
IF(@OPCAO = 6)    
    
/*    
   Regra para arquivamento do espelho da Aih    
    
   Se( Procedimento Solicitado = 39.000.001 Or = 31.000.000 Or = 70.000.000)    
      Atualizar o Procedimento Realizado na Tabela do Espelho da Aih     
      com o Procedimento Solicitado.           
    
      Buscar a Linha 1 do Campo Medico Auditor na Tabela Auditor Procedimento     
      na clausula Where da query obter o Audproc_codigo = 1,00 que corresponderÃƒÂ¡    
      a linha 1 do Medico Auditor.    
    
      Se( O Procedimento da Linha 1 Medico Auditor >= 31.000.000     
     And <= 92.000.000 And Not Eof)Then        
  O Procedimento Realizado deverÃƒÂ¡ ser o Procedimento da Linha 1 do Medico Auditor    
    
      Senao     
    
 O Procedimento Realizado deverÃƒÂ¡ ser o Procedimento Solicitado do Espelho da Aih    
    
      Fim Se    
    
   Fim Se      
    
   Obs.: SerÃƒÂ¡ retornado o Procedimento Realizado para Atualizacao no Form do Espelho    
  da Aih     
    
*/    
    
 BEGIN       
    
    -- Obtem a Linha 1 do Medico Auditor    
    
    DECLARE @PROCEDIMENTO_COD CHAR(8),     
           @PROCEDIMENTO_DESC VARCHAR(50)     
    
    SELECT   @PROCEDIMENTO_COD  = PROCED.PROC_CODIGO,     
             @PROCEDIMENTO_DESC = PROCED.PROC_DESCRICAO    
    
    FROM     DBO.ESPELHO_AIH           EA,     
             DBO.AUDITOR_PROCEDIMENTO  AP,     
             DBO.PROCEDIMENTO          PROCED                         
    
    WHERE    EA.AIH_SEQUENCIAL    =    @AIH_SEQUENCIAL    
    AND      EA.AIH_SEQUENCIAL    =    AP.AIH_SEQUENCIAL    
    AND      AP.PROC_CODIGO       =    PROCED.PROC_CODIGO       
    AND      AP.AUDPROC_CODIGO    =    '1'       
    
    IF( @PROCEDIMENTO_COD BETWEEN '31000000' AND '92000000' OR @PROCEDIMENTO_COD IS NULL)         
    
      BEGIN       
    
       SELECT @PROCEDIMENTO_COD, @PROCEDIMENTO_DESC        
    
      END    
    
    ELSE    
    
      BEGIN    
/*      
 SELECT @PROCEDIMENTO_COD   = EA.PROC_CODIGO,     
  @PROCEDIMENTO_DESC  = PROCED.PROC_DESCRICAO    
    
 FROM DBO.ESPELHO_AIH     EA,     
  DBO.PROCEDIMENTO    PROCED     
    
 WHERE   EA.AIH_SEQUENCIAL = @AIH_SEQUENCIAL    
 AND EA.PROC_CODIGO    = PROCED.PROC_CODIGO    
    
       SELECT @PROCEDIMENTO_COD, @PROCEDIMENTO_DESC        
*/    
 SELECT NULL, NULL    
      END     
    
 END    
    
-- ***************************************************    
    
IF(@OPCAO = 7)    
 BEGIN       
    
  if @aih_critica = '0'     
  begin    
   UPDATE  ESPELHO_AIH     
   SET  AIH_CRITICA = '1',    
    AIH_DCIH = NULL    
   WHERE   AIH_SEQUENCIAL  = @AIH_SEQUENCIAL      
    
   if (@@error <> 0) goto trataerro        
    
   delete from previsao_faturamento where AIH_SEQUENCIAL  = @AIH_SEQUENCIAL    
    
   if (@@error <> 0) goto trataerro        
  end    
  else    
  begin    
   UPDATE  ESPELHO_AIH     
   SET    AIH_CRITICA     = '0',    
    AIH_DCIH = NULL    
   WHERE   AIH_SEQUENCIAL  = @AIH_SEQUENCIAL      
    
   if (@@error <> 0) goto trataerro        
    
   delete from previsao_faturamento where AIH_SEQUENCIAL  = @AIH_SEQUENCIAL    
    
   if (@@error <> 0) goto trataerro        
  end     
END     
    
    
if @opcao = 8    
begin    
    
 select faiaih_inicial, faiaih_final from faixa_aih    
 where unid_codigo = @unid_codigo    
 and  faiaih_final >= faiaih_inicial    
    
end    
    
    
if @opcao = 9    
begin    
 SELECT TOP 1 MAX(EA.AIH_NUMERO) AS AIH_NUMERO,    
 MAX(SUBSTRING(CONVERT(CHAR(10),CONVERT(SMALLDATETIME,ISNULL( ISNULL(SPACE(3)     
 + AP.APRES + '01', SPACE(3) + '20' + LEFT(EA.AIH_DCIH,4) + '01' ),    
 DATEADD(MONTH,1,GETDATE())) ,112),103),4,7)) APRES    
 FROM ESPELHO_AIH EA     
  INNER JOIN INTERNACAO I ON (I.INTER_CODIGO = EA.INTER_CODIGO)
  LEFT JOIN AIH_Internacao_Consolidada AIC ON (EA.aih_sequencial =AIC.AIH_SEQUENCIAL)     
  LEFT JOIN PREVISAO_FATURAMENTO AP ON (EA.AIH_SEQUENCIAL = AP.AIH_SEQUENCIAL)    
 WHERE EA.INTER_CODIGO LIKE @unid_codigo_int  AND (EA.INTER_CODIGO =  @INTER_CODIGO OR AIC.INTER_CODIGO=@INTER_CODIGO)
   GROUP BY AIH_DCIH,APRES    
end    
    
if @opcao = 92 --OS 7816    
begin    
 SELECT  TOP 1 MAX(EA.AIH_NUMERO) AS AIH_NUMERO,    
  MAX(SUBSTRING(CONVERT(CHAR(10),CONVERT(SMALLDATETIME,ISNULL( ISNULL(SPACE(3)     
  + AP.APRES + '01', SPACE(3) + '20' + LEFT(EA.AIH_DCIH,4) + '01' ),    
  DATEADD(MONTH,1,GETDATE())) ,112),103),4,7)) APRES    
 FROM ESPELHO_AIH EA     
  INNER JOIN HospitalDia H ON (H.HospDia_Codigo = EA.HospDia_Codigo)    
  LEFT JOIN PREVISAO_FATURAMENTO AP ON (EA.AIH_SEQUENCIAL = AP.AIH_SEQUENCIAL)    
 WHERE  H.HospDia_Codigo like @unid_codigo_int and EA.HospDia_Codigo =  @HospDia_Codigo    
   GROUP BY AIH_DCIH,APRES    
end    
    
    
---carrega as diarias de uti    
if @opcao = 10    
begin    
    
 select top 3 month(c.data),year(c.data),count(*),i.inter_motivo_alta from censo_hospitalar c,internacao i    
 where     
 c.lei_tipo = '2' -- leito de uti    
 and c.inter_codigo = @inter_codigo    
 and c.data between @aih_data_internacao and @aih_data_alta    
 and c.inter_codigo = i.inter_codigo    
 group by month(c.data) ,year(c.data),i.inter_motivo_alta    
 order by year(c.data) desc,month(c.data) desc    
    
end     
    
    
    
-- BUSCA TODAS AS AIHS DE UMA INTERNACAO -------------------------------------------------------------------------------    
if @opcao = 11    
begin    
 DECLARE @sql VARCHAR (1000)    
    
 SET @sql = '  SELECT  EA.AIH_SEQUENCIAL,'    
 SET @sql = @sql + ' SUBSTRING(CONVERT(CHAR(10),CONVERT(SMALLDATETIME,ISNULL( ISNULL(SPACE(3) + AP.APRES + ''01'', SPACE(3) + ''20'' + LEFT(EA.AIH_DCIH,4) + ''01'' ),DATEADD(MONTH,1,GETDATE())) ,112),103),4,7) APRES,'    
 SET @sql = @sql + ' EA.AIH_NUMERO,'    
 SET @sql = @sql + ' EA.AIH_IDENTIFICACAO,'    
 SET @sql = @sql + ' EA.AIH_CONTA_7 AIH_CONTA_5,'    
 SET @sql = @sql + ' EA.AIH_DCIH,'    
 SET @sql = @sql + ' EA.AIH_DTINTERNACAO,'    
 SET @sql = @sql + ' EA.AIH_DTALTA,'    
 SET @sql = @sql + ' P.PROC_DESCRICAO,'    
 SET @sql = @sql + ' PAC.PAC_NOME'    
    
 SET @sql = @sql + ' FROM  ESPELHO_AIH  EA'    
 SET @sql = @sql + ' INNER JOIN  PACIENTE_AIH  PAC ON EA.AIH_SEQUENCIAL = PAC.AIH_SEQUENCIAL'    
 SET @sql = @sql + ' INNER JOIN PROCEDIMENTO  P ON EA.AIH_PROC_REALIZADO = P.PROC_CODIGO'    
 SET @sql = @sql + ' LEFT JOIN PREVISAO_FATURAMENTO AP ON EA.AIH_SEQUENCIAL = AP.AIH_SEQUENCIAL'    
    
 SET @sql = @sql + ' WHERE      ea.aih_sequencial like ' + '''' + @unid_codigo_int + ''''    
    
 IF @INTER_CODIGO IS NOT NULL    
  SET @sql = @sql + '  AND EA.INTER_CODIGO   = ''' + @INTER_CODIGO + ''''    
-- OS 7816 (+ retirado Join com Internacao)    
 IF @HospDia_Codigo IS NOT NULL    
  SET @sql = @sql + '  AND EA.HospDia_Codigo   = ''' + @HospDia_Codigo + ''''    
    
 IF @PAC_CODIGO IS NOT NULL    
  SET @sql = @sql + '  AND PAC.PAC_CODIGO   = ''' + @PAC_CODIGO + ''''    
    
   SET @sql = @sql + ' ORDER BY EA.AIH_SEQUENCIAL DESC'    
    
 EXEC (@sql)    
    
end    
    
    
    
-- RETORNA O CPF DO DIRETOR DA UNIDADE ---------------------------------------------------------------------------------    
if @opcao = 12    
begin    
 select  u.unid_diretor_cpf    
 from  unidade u    
 where  u.unid_codigo = @unid_codigo           
end    
    
    
    
--     
if @opcao = 13    
begin    
 Begin    
    
  Declare @var1  varchar(255)      
  Declare @par  varchar(255)    
  Declare @lSql varchar(2048)    
    
  Set @lSql = 'Select E.Aih_Numero + ''-'' + E.Aih_Identificacao Aih_Numero, E.aih_conta_7, E.Aih_dtEmissao, E.Inter_Codigo, P.Pac_Codigo, P.Pac_Nome, P.Pac_Prontuario '    
  Set @lSql = @lSql + 'From Espelho_Aih E, Paciente_Aih P '    
  Set @lSql = @lSql + 'Where E.Aih_Sequencial = P.Aih_Sequencial And E.aih_sequencial like ''' +  @unid_codigo_int + ''''    
    
  If @Tp_pesq is not null    
  Begin    
   -- Pesquisa por NUMERO DA AIH    
   If @aih_numero is Not Null    
   Begin    
              Set @var1 =  convert(varchar,@aih_numero)    
              Exec ksp_ParametroPesquisa @var1,' and e.aih_numero', @tp_pesq, 'T', @par output    
   End    
    
   -- Pesquisa por INTERNACAO    
   If @inter_codigo is Not Null    
   Begin    
              Set @var1 =  convert(varchar,@inter_codigo)    
              Exec ksp_ParametroPesquisa @var1,' and e.inter_codigo', @tp_pesq, 'T', @par output    
   End    
    
   -- Pesquisa por CÃƒâ€œDIGO DO PACIENTE    
   If @pac_codigo is Not Null    
   Begin    
              Set @var1 =  convert(varchar,@pac_codigo)    
              Exec ksp_ParametroPesquisa @var1,' and p.pac_codigo',@tp_pesq, 'T', @par output    
   End    
    
   -- Pesquisa por NOME    
   If @pac_nome is Not Null    
   Begin    
              Set @var1 =  convert(varchar,@pac_nome)    
              Exec ksp_ParametroPesquisa @var1,' and p.pac_nome',@tp_pesq, 'T', @par output    
   End    
    
   -- Pesquisa por PRONTUARIO    
   If @pac_prontuario is Not Null    
   Begin    
              Set @var1 =  convert(varchar,@pac_prontuario)    
              Exec ksp_ParametroPesquisa @var1,' and p.pac_prontuario',@tp_pesq, 'T', @par output    
   End    
    
    
   set @lSql =  @lSql  + @par    
  End    
    
    SET @lSql = @lSql + ' ORDER BY E.AIH_SEQUENCIAL DESC'    
    
  Execute (@lSql)    
    
 End    
    
    
    
end    
    
if @opcao = 14    
begin    
 update  faixa_aih     
 set  faiaih_inicial = convert(char(12),convert(bigint,faiaih_inicial) + 1)
 where  Unid_codigo = @Unid_codigo    
    
 if (@@error <> 0) goto trataerro        
end    
    
if @opcao = 15 --diarias de UTI    
begin    
 -- carrega as internacoes do censo    
    
 -- Chamado 19557 --------------------------------------------------------------------------------------------    
--  select  count(data)  Dias,    
--   LEI_TIPO_UTI Tipo_UTI    
--     
--  from  censo_hospitalar    
--  where  inter_codigo = @inter_codigo    
--  and  lei_tipo = 2    
--  group by  LEI_TIPO_UTI    
    
    
 select  count(data)  QtdDiasUti,    
  LEI_TIPO_UTI Lei_Tipo_UTI, lei_tipo    
    
  , ( substring(convert(char(10), data, 103),7,4) + substring(convert(char(10), data, 103),4,2) ) Competencia    
    
 from  censo_hospitalar    
 where  inter_codigo = @inter_codigo    
 and  (lei_tipo = 2  OR lei_tipo = 8)    
 group by  LEI_TIPO_UTI , lei_tipo,( substring(convert(char(10), data, 103),7,4) + substring(convert(char(10), data, 103),4,2) )     
 -- ---------------------------------------------------------------------------------------------------------    
    
    
end    
--------------------------------------------------------------------------    
--If @opcao = 16    
/*  Begin    
    
   Select a.Aih_Numero,    
          a.Proc_Codigo,    
          p.proc_descricao,     
          a.Aih_DtInternacao,    
          a.Aih_DtAlta    
     From Espelho_Aih a,    
          Procedimento p,    
          Paciente_Aih h    
    Where a.Proc_Codigo = p.proc_codigo    
      And a.aih_sequencial = h.aih_sequencial    
      And h.Pac_Codigo = @pac_codigo    
    
  End    
*/    
    
--------------------------------------------------------------------------    
if @opcao = 17    
begin    
    
 select  daih.cep cep_sisaih,    
  daih.uf  uf,    
  m.mun_descricao municipio, daih.cod_mun    
 from daih070  daih,    
  municipio m    
 where daih.cep  = @proc_solicitado -- recebe o cep    
   and left(m.cod_ibge,6) = daih.cod_mun    
end    
    
    
    
-- RETORNA AIH 5 -------------------------------------------------------------------------------------------------------    
If @opcao = 18    
begin    
    
 select  aih_numero    
 from espelho_aih    
 where cast(aih_numero as numeric) = cast(@aih_numero as numeric)    
 and aih_identificacao = '5'    
 and aih_sequencial like  @unid_codigo_int    
 and  (@aih_identificacao = '1' or (@aih_identificacao = '5' and aih_conta_7 > @aih_conta_5))      
    
end    
    
-- NUMERO DE AIH EM OUTRA UNIDADE -------------------------------------------------------------------------------------------------------    
If @opcao = 19    
begin    
    
 select  unidade.unid_codigo + '-' + unidade.unid_descricao    
 from espelho_aih, unidade    
 where cast(aih_numero as numeric) = cast(@aih_numero as numeric)    
 and right(unidade.unid_codigo,2) = left(aih_sequencial,2)    
 and left(aih_sequencial,2) <> right(@unid_codigo,2)    
    
    
end    
    
if @opcao = 20    
begin    
 update  espelho_aih     
 set  aih_numero    = @aih_numero    
 ,  EhAIH_Provisoria = NULL    
 ,  AIH_NUMERO_PROVISORIO = @AIH_NUMERO_PROVISORIO     
    
 where  AIH_NUMERO   = @AIH_NUMERO_PROVISORIO     
 and     AIH_NUMERO_PROVISORIO  is  null     
 AND aih_sequencial   = @aih_sequencial     
 and EhAIH_Provisoria  is not null    
    
 if (@@error <> 0) goto trataerro        
end    
    
    
if @opcao = 21 --diarias de UTI - QUEIMADOS (UTQ = 6)    
begin    
    
 select  count(data)  QtdDiasUti,    
  LEI_TIPO_UTI Lei_Tipo_UTI    
    
  , ( substring(convert(char(10), data, 103),7,4) + substring(convert(char(10), data, 103),4,2) ) Competencia    
    
 from  censo_hospitalar    
 where  inter_codigo = @inter_codigo    
 and  lei_tipo = 6    
 group by  LEI_TIPO_UTI , ( substring(convert(char(10), data, 103),7,4) + substring(convert(char(10), data, 103),4,2) )     
    
end    
    
    
if @opcao = 22 --Carrega internação com AIH    
begin    
    
 set nocount on    
    
 SELECT  Aih_Sequencial,         
   Aih_Numero,         
   '1'  Aih_Identificacao,         
   internacao.inter_codigo     Inter_Codigo,         
   internacao.inter_datainter    Aih_DtEmissao,         
   pedido_internacao.cid_codigo ,      
   cid_10.cid_descricao as cid_descricao ,       
   pedido_internacao.cid_secundario ,     
   cid_secundario.cid_descricao as cid_secundario_descricao,      
   pedido_internacao.proc_codigo proc_codigo,      
   procedimento.proc_descricao proc_descricao,      
   pedido_internacao.proc_codigo as aih_proc_realizado,      
   procedimento.proc_descricao procreal_descricao,      
   especialidade_aih.Esp_Codigo,                
   Esp_Descricao,         
   Aih_Cat,         
   Aih_Cgc_Empregador,         
      Aih_Anterior,         
   Aih_Proxima,         
      null Locatend_Codigo,         
   null locatend_descricao,         
   null prof_codigo,         
   null prof_nome1,               
   Aih_Uti_MesInicial,    
   Aih_Uti_MesAnterior,    
   Aih_Uti_MesAlta,    
      Aih_Diaria_Acomp,    
      isnull(espelho_aih.aih_critica,'0') critica,                
--ECO.07/03/2003    
      internacao.inter_motivo_alta MotCob_Codigo,         
   mc.motcob_descricao    MotCob_Descricao,    
         internacao.inter_datainter     aih_dtinternacao,      
         internacao.inter_dtalta      aih_dtalta,      
                                  Aih_Dcih,         
   paciente.pac_codigo,       
   paciente.pac_nome,        
   ci.carint_codigo,    
   ci.carint_descricao,         
   ip.intpart_nasc_vivo      aih_nascido_vivo,        
   ip.intpart_obito_fetal      aih_obito_fetal,       
   ip.intpar_alta_neoparto     aih_alta,    
   ip.intpar_transf_neoparto    aih_transferido,     
   ip.intpart_obito_neoparto     aih_obito_neoparto,    
   pedido_internacao.prof_codigo      as medico_responsavel, --medico solicitante    
   isnull(internacao.prof_codigo_resp, internacao.prof_codigo) as aih_medico_responsavel,    
   p.prof_nome    as prof_nome,    
   --'0'    critica,    
  -- NULL     Aih_Numero_SisPreNatal,    
   paciente.PAC_SIS_PRENATAL       Aih_Numero_SisPreNatal,    -- Chamado 20432 - 04/04/2011     
    
   case when Internacao_Pid.Inter_Codigo is not null then '04'    
   else '02'    
   END aih_modalidade,    
   p.prof_cpf   as aih_cpf_medresp,    
   FA.faiaih_inicial,     
   FA.faiaih_final,    
   @unid_codigo unid_codigo,    
      aih_medico_solicitante ,    
      aih_medico_autorizador,    
      aih_cpf_medauto    
    
 FROM DBO.internacao     
  inner join DBO.pedido_internacao on internacao.pedint_sequencial = pedido_internacao.pedint_sequencial    
  inner join DBO.cid_10 on pedido_internacao.cid_codigo = cid_10.cid_codigo    
  left join DBO.cid_10 cid_secundario  on pedido_internacao.cid_secundario = cid_secundario.cid_codigo    
  inner join DBO.procedimento on pedido_internacao.proc_codigo = procedimento.proc_codigo    
  inner join DBO.paciente on internacao.pac_codigo = paciente.pac_codigo    
  inner join DBO.carater_internacao ci on pedido_internacao.carint_codigo = ci.carint_codigo    
  left join DBO.internacao_parto ip on internacao.inter_codigo = ip.inter_codigo    
  left join dbo.profissional_rede p on Internacao.PROF_CODIGO_RESP = P.PROF_CODIGO    
  left join dbo.motivo_cobranca_aih mc on internacao.inter_motivo_alta = mc.motcob_codigo    
  LEFT JOIN DBO.Internacao_Pid ON Internacao_Pid.Inter_Codigo = internacao.Inter_Codigo    
  LEFT JOIN faixa_aih fa on fa.unid_codigo = @unid_codigo and fa.faiaih_final >= fa.faiaih_inicial    
  inner join espelho_aih on internacao.inter_codigo = espelho_aih.inter_codigo    
  inner join especialidade_aih on espelho_aih.esp_codigo = especialidade_aih.esp_codigo    
    
 WHERE  internacao.inter_codigo    = @Inter_codigo    
 and internacao.inter_codigo    like  @unid_codigo_int    
    
 SET NOCOUNT OFF    
    
END  
  
IF @opcao = 23 --Carrega internação com AIH    
BEGIN
	SELECT * FROM RL_PROCEDIMENTO_REGISTRO WHERE CO_PROCEDIMENTO=@proc_realizado AND CO_REGISTRO='05'
END    

IF @opcao = 24 --Testo se o procedimento é fisioterapico    
BEGIN
	SELECT CO_PROCEDIMENTO FROM procedimento_fisioterapico WHERE CO_PROCEDIMENTO=@proc_realizado 
END        

IF @opcao = 25 --insere internacoes consolidadas na tabela de relacionamento
BEGIN
	insert into AIH_Internacao_Consolidada(aih_sequencial,inter_codigo,data_atualizacao) values (@aih_sequencial,@inter_codigo,getdate())
END        

IF @opcao = 26 --procuro se uma aih já foi consolidada
BEGIN
	select aih_sequencial,inter_codigo from AIH_Internacao_Consolidada where aih_sequencial = @aih_sequencial
END        

IF @opcao = 27 -- verifica especialidade leito pelo codigo do procedimento
BEGIN
	select CO_TIPO_LEITO from rl_procedimento_leito where CO_PROCEDIMENTO = @proc_realizado
END


-- TRATAMENTO DE ERRO --------------------------------------------------------------------------------------------------    
    
set nocount off    
return    
    
trataerro:    
 raiserror('erro - tabela de procedimentos realizados.',1,1)
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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Dieta]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Dieta]
@ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @IPDI_TEXTO VARCHAR (2000), @IPDI_KCAL DECIMAL (18), @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @ItemPrescricaoSuspensa CHAR(1)=null
AS
DECLARE @SQL VARCHAR(8000)
DECLARE @PAR VARCHAR(500)
DECLARE @VAR VARCHAR(500)

IF (@OPCAO = 0) /* LIST */
   
BEGIN

   SET @SQL =        ' SELECT ' 
   SET @SQL = @SQL + '   presc_codigo, itpresc_codigo, ipdi_texto, ipdi_kcal, ItemPrescricaoSuspensa ' 
   SET @SQL = @SQL + ' FROM ' 
   SET @SQL = @SQL + '   Item_Prescricao_Dieta ' 
   SET @SQL = @SQL + ' WHERE ' 
 IF @PRESC_CODIGO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @ITPRESC_CODIGO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @IPDI_TEXTO IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @IPDI_TEXTO) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipdi_texto ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
 IF @IPDI_KCAL IS NOT NULL
 BEGIN 
   SET @VAR = CONVERT(VARCHAR, @IPDI_KCAL) 
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipdi_kcal ", @TP_PESQ, "T", @PAR OUTPUT 
 END	
SET @SQL = (@SQL + @PAR)
EXEC (@SQL)


END

IF (@OPCAO = 1)  /* INCLUSAO */
 
BEGIN
   
   INSERT INTO Item_Prescricao_Dieta(ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, ipdi_texto, ipdi_kcal, ItemPrescricaoSuspensa)
        VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @ITPRESC_CODIGO, @IPDI_TEXTO, @IPDI_KCAL, @ItemPrescricaoSuspensa)


END

IF (@OPCAO = 2)  /* ALTERACAO */
 
BEGIN

   UPDATE
     Item_Prescricao_Dieta
   SET
     ipdi_texto = @IPDI_TEXTO,
     ipdi_kcal = @IPDI_KCAL
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END

IF (@OPCAO= 3) /* EXCLUSAO */

BEGIN
          
   DELETE FROM Item_Prescricao_Dieta
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO
      
END

IF (@OPCAO= 4) /* PROCURA POR CHAVE */

BEGIN
          
   SELECT
     presc_codigo, itpresc_codigo, ipdi_texto, ipdi_kcal, ItemPrescricaoSuspensa
   FROM
     Item_Prescricao_Dieta
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO
      
END

IF (@OPCAO= 5) /* LISTA TODOS */

BEGIN
          
   SELECT
     presc_codigo, itpresc_codigo, ipdi_texto, ipdi_kcal, ItemPrescricaoSuspensa
   FROM
     Item_Prescricao_Dieta
      
END

IF (@OPCAO = 6)  /* ALTERACAO SUSPENSAO*/
 
BEGIN

   UPDATE
     Item_Prescricao_Dieta
   SET
     ItemPrescricaoSuspensa = @ItemPrescricaoSuspensa
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END

IF (@OPCAO= 7) /* LISTA TODOS AS PRESCRICOES APRAZADAS */

BEGIN
          
   SELECT  IPDI.presc_codigo, IPDI.itpresc_codigo, IPDI.ItemPrescricaoSuspensa  
    FROM   Item_Prescricao_Dieta IPDI
	 Left Join Item_Aprazamento ITAP ON ITAP.presc_codigo = IPDI.presc_codigo and ITAP.itpresc_codigo = IPDI.itpresc_codigo
	WHERE /*IPCE.presc_codigo = @PRESC_CODIGO
	AND IPCE.itpresc_codigo = @ITPRESC_CODIGO */
	IPDI.item_prescricao_id = @ITEM_PRESCRICAO_ID
	AND ITAP.data_checagem is not null

      
END

-----LISTA ITENS DA PRESCRICAO POR PRESC_CODIGO E/OU ITEM_PRESCRICAO_ID
IF @OPCAO = 8
BEGIN

     SELECT
     	IPD.item_prescricao_id,
     	IPD.presc_codigo,
     	IPD.itpresc_codigo,
     	IPD.ipdi_texto,
     	IPD.ipdi_kcal,
     	IPD.ItemPrescricaoSuspensa,
		IPO.itpresc_obs
     FROM Item_Prescricao_Dieta IPD
	 JOIN Item_Prescricao IPO ON IPD.item_prescricao_id = IPO.item_prescricao_id
     WHERE IPD.presc_codigo = ISNULL(@PRESC_CODIGO, IPD.presc_codigo)
     AND IPD.item_prescricao_id = ISNULL(@ITEM_PRESCRICAO_ID, IPD.item_prescricao_id)

END

IF @OPCAO = 18
BEGIN
	update Item_Prescricao_Dieta set ItemPrescricaoSuspensa = 'S' where item_prescricao_id = @ITEM_PRESCRICAO_ID
end

IF (@@ERROR <> 0)

BEGIN

         RAISERROR('ERRO: ksp_Item_Prescricao_Dieta',1,1)

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
PRINT N'Altering [dbo].[ksp_Item_Prescricao_Oxigenoterapia]...';


GO
ALTER PROCEDURE [dbo].[ksp_Item_Prescricao_Oxigenoterapia]
@ITEM_PRESCRICAO_ID UNIQUEIDENTIFIER, @PRESC_CODIGO CHAR (12), @ITPRESC_CODIGO INT, @OXI_CODIGO INT, @IPOX_UNIDADE DECIMAL (18), @IPOX_UNIDADE_TEMPO CHAR (1), @IPOX_INTERVALO INT, @IPOX_DURACAO INT, @IPOX_TPDURACAO CHAR (1), @TP_PESQ SMALLINT=NULL, @OPCAO SMALLINT, @ItemPrescricaoSuspensa CHAR(1)=null
AS
DECLARE @SQL VARCHAR(8000)  
DECLARE @PAR VARCHAR(500)  
DECLARE @VAR VARCHAR(500)  
    
IF (@OPCAO = 0) /* LIST */    
  
BEGIN    
    
   SET @SQL =        ' SELECT '     
   SET @SQL = @SQL + '   presc_codigo, itpresc_codigo, oxi_codigo, ipox_unidade, ipox_unidade_tempo, ipox_intervalo, ipox_duracao, ipox_tpduracao, ItemPrescricaoSuspensa '  
   SET @SQL = @SQL + ' FROM '     
   SET @SQL = @SQL + '   Item_Prescricao_Oxigenoterapia '     
   SET @SQL = @SQL + ' WHERE '     
 IF @PRESC_CODIGO IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @PRESC_CODIGO)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "presc_codigo ", @TP_PESQ, "T", @PAR OUTPUT     
 END     
 IF @ITPRESC_CODIGO IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @ITPRESC_CODIGO)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "itpresc_codigo ", @TP_PESQ, "T", @PAR OUTPUT     
 END     
 IF @OXI_CODIGO IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @OXI_CODIGO)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "oxi_codigo ", @TP_PESQ, "T", @PAR OUTPUT     
 END  
 IF @IPOX_UNIDADE IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @IPOX_UNIDADE)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipox_unidade ", @TP_PESQ, "T", @PAR OUTPUT     
 END  
 IF @IPOX_UNIDADE_TEMPO IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @IPOX_UNIDADE_TEMPO)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipox_unidade_tempo ", @TP_PESQ, "T", @PAR OUTPUT     
 END  
 IF @IPOX_INTERVALO IS NOT NULL    
 BEGIN     
   SET @VAR = CONVERT(VARCHAR, @IPOX_INTERVALO)     
   EXEC KSP_PARAMETROPESQUISA @VAR, "ipox_intervalo ", @TP_PESQ, "T", @PAR OUTPUT     
 END  
SET @SQL = (@SQL + @PAR)    
EXEC (@SQL)  
  
END  
    
IF (@OPCAO = 1)  /* INCLUSAO */    
     
BEGIN    

   INSERT INTO Item_Prescricao_Oxigenoterapia(ITEM_PRESCRICAO_ID, presc_codigo, itpresc_codigo, oxi_codigo, ipox_unidade, ipox_unidade_tempo, ipox_intervalo, ipox_duracao, ipox_tpduracao, ItemPrescricaoSuspensa) 
        VALUES (@ITEM_PRESCRICAO_ID, @PRESC_CODIGO, @ITPRESC_CODIGO, @OXI_CODIGO, @IPOX_UNIDADE, @IPOX_UNIDADE_TEMPO, @IPOX_INTERVALO, @IPOX_DURACAO, @IPOX_TPDURACAO, @ItemPrescricaoSuspensa) 
END    
    
IF (@OPCAO = 2)  /* ALTERACAO */    
     
BEGIN    
   UPDATE    
     Item_Prescricao_Oxigenoterapia    
   SET  
     oxi_codigo = @OXI_CODIGO,  
     ipox_unidade = @IPOX_UNIDADE,  
     ipox_unidade_tempo = @IPOX_UNIDADE_TEMPO,  
     ipox_intervalo = @IPOX_INTERVALO,
     ipox_duracao = @IPOX_DURACAO,
     ipox_tpduracao = @IPOX_TPDURACAO 
   WHERE    
     itpresc_codigo = @ITPRESC_CODIGO AND  
     presc_codigo = @PRESC_CODIGO  
END    
    
IF (@OPCAO= 3) /* EXCLUSAO */    
    
BEGIN    
              
   DELETE FROM Item_Prescricao_Oxigenoterapia    
   WHERE    
     itpresc_codigo = @ITPRESC_CODIGO AND     
     presc_codigo = @PRESC_CODIGO    
END    
    
IF (@OPCAO= 4) /* PROCURA POR CHAVE */    
    
BEGIN    
   SELECT    
     presc_codigo, itpresc_codigo, oxi_codigo, ipox_unidade, ipox_unidade_tempo, ipox_intervalo, ipox_duracao, ipox_tpduracao, ItemPrescricaoSuspensa
   FROM    
     Item_Prescricao_Oxigenoterapia    
   WHERE    
     itpresc_codigo = @ITPRESC_CODIGO AND     
     presc_codigo = @PRESC_CODIGO    
END    
    
IF (@OPCAO= 5) /* LISTA TODOS */    
    
BEGIN    
              
   SELECT    
     presc_codigo, itpresc_codigo, oxi_codigo, ipox_unidade, ipox_unidade_tempo, ipox_intervalo, ipox_duracao, ipox_tpduracao, ItemPrescricaoSuspensa
   FROM    
     Item_Prescricao_Oxigenoterapia    
END    

IF (@OPCAO = 6)  /* ALTERACAO SUSPENSAO*/
 
BEGIN

   UPDATE
     Item_Prescricao_Oxigenoterapia
   SET
     ItemPrescricaoSuspensa = @ItemPrescricaoSuspensa
   WHERE
     itpresc_codigo = @ITPRESC_CODIGO AND 
     presc_codigo = @PRESC_CODIGO                            

END
 
IF (@OPCAO= 7) /* LISTA TODOS AS PRESCRICOES APRAZADAS */

BEGIN
          
   SELECT  IPOX.oxi_codigo, IPOX.presc_codigo, IPOX.itpresc_codigo, IPOX.ItemPrescricaoSuspensa  
    FROM   Item_Prescricao_Oxigenoterapia IPOX
	 Left Join Item_Aprazamento ITAP ON ITAP.presc_codigo = IPOX.presc_codigo and ITAP.itpresc_codigo = IPOX.itpresc_codigo
	WHERE /*IPCE.presc_codigo = @PRESC_CODIGO
	AND IPCE.itpresc_codigo = @ITPRESC_CODIGO */
	IPOX.item_prescricao_id = @ITEM_PRESCRICAO_ID
	AND ITAP.data_checagem is not null

      
END

-----LISTA ITENS DA PRESCRICAO POR PRESC_CODIGO E/OU ITEM_PRESCRICAO_ID
IF @OPCAO = 8
BEGIN

     SELECT
	 IPX.item_prescricao_id,
	 IPX.presc_codigo,
	 IPX.itpresc_codigo,
	 IPX.oxi_codigo,
	 IPX.ipox_unidade,
	 IPX.ipox_unidade_tempo,
	 IPX.ipox_intervalo,
	 IPX.ipox_duracao,
	 IPX.ipox_tpduracao,
	 IPX.ItemPrescricaoSuspensa,
	 IPO.itpresc_obs,
	 OX.oxi_descricao
     FROM Item_Prescricao_Oxigenoterapia IPX
	 JOIN Oxigenoterapia OX ON IPX.oxi_codigo = OX.oxi_codigo
	 JOIN Item_Prescricao IPO ON IPX.item_prescricao_id = IPO.item_prescricao_id
     WHERE IPX.presc_codigo = ISNULL(@PRESC_CODIGO, IPX.presc_codigo)
     AND IPX.item_prescricao_id = ISNULL(@ITEM_PRESCRICAO_ID, IPX.item_prescricao_id)

END
  
  IF @OPCAO = 18
BEGIN
	update Item_Prescricao_Oxigenoterapia set ItemPrescricaoSuspensa = 'S' where item_prescricao_id = @ITEM_PRESCRICAO_ID
end
 
IF (@@ERROR <> 0)    
    
BEGIN    
      RAISERROR('ERRO: ksp_Item_Prescricao_Oxigenoterapia',1,1)    
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
PRINT N'Altering [dbo].[ksp_procedimento ]...';


GO
ALTER PROCEDURE [dbo].[ksp_procedimento ]
  @codigo CHAR (10)
, @descricao VARCHAR (50)
, @opcao INT
, @tp_pesq INT, @cid CHAR (4)=null
, @qtde INT=null, @cbo CHAR (6)=null
, @ProcSexo varchar(1) = null
, @ProfCodigo varchar(6)= null

AS
if @opcao = 0
begin

	select 	procedimento.proc_descricao,
		procedimento.proc_mudanca,
		procedimento.proc_codigo,
		procedimento.proc_permanencia,
		procedimento.proc_tempo
		, procedimento.qt_maxima_execucao

	from 	procedimento

	where 	procedimento.proc_codigo= @codigo
	and	procedimento.proc_ativo = 'S'
end

------------------------------------ Inclusao dos Dados ---------------------------------------
-- if @opcao = 1 

------------------------------------ Alteracao dos Dados ---------------------------------------
-- if @opcao = 2

------------------------------------ Exclusao dos Dados ---------------------------------------
-- if @opcao = 3

------------------------------- Selecao do Proximo Codigo de cid --------------------------
--if @opcao = 4

------------------------------------ PESQUISA -------------------------------------------------
If @Opcao = 5
	Begin

		Declare @lSql varchar(1024)
		declare @par varchar(500)
		declare @var varchar(500)

		Set @lSql = 'Select proc_codigo, proc_descricao '
		Set @lSql = @lSql + 'From procedimento '
		Set @lSql = @lSql + 'Where PROC_ATIVO = ''S'' '


	   if @Codigo is not null
	    begin
		set @var = convert(varchar,@Codigo)
		Exec ksp_ParametroPesquisa @var,"proc_codigo",@tp_pesq,"T" ,@par output		
		set @lSql = @lSql + ' and ' + @par 
	    end

	   if @descricao is not null
	    begin
		Exec ksp_ParametroPesquisa @descricao,"proc_descricao",@tp_pesq,"T" ,@par output		
		set @lSql = @lSql + ' and ' + @par 
	    end


		Execute (@lSql)

	End
------------------------------------------------------------------------------------------------

If @Opcao = 6
	Begin
		DECLARE @textoCodigo varchar(50)
		DECLARE @textoDescricao varchar(50)

		SET @textoCodigo = '%'+RTRIM(LTRIM(@codigo))+'%'
		SET @textoDescricao = '%'+RTRIM(LTRIM(@descricao))+'%'

		SELECT	RTRIM(LTRIM(p.proc_codigo)) as Codigo, RTRIM(LTRIM(p.proc_descricao)) as Descricao, RTRIM(LTRIM(p.proc_codigo)) + ' - ' + RTRIM(LTRIM(p.proc_descricao)) as CodigoDescricao
		FROM	Procedimento p
		WHERE	RTRIM(LTRIM(p.proc_codigo)) LIKE @textoCodigo
		OR	RTRIM(LTRIM(p.proc_descricao)) LIKE @textoDescricao
		ORDER BY RTRIM(LTRIM(p.proc_descricao))


	End


-- RETORNA O REGISTRO, PONTOS e VALOR_SP DO PROCEDIMENTO -----------------------------------------------------------------------------------
if @opcao = 7
begin

	select		p.qt_pontos,
			p.vl_sp,
			pr.co_registro,
			p.CO_PROCEDIMENTO proc_codigo,
			p.NO_PROCEDIMENTO proc_descricao

	from 		tb_procedimento p
	
	inner join 	rl_procedimento_registro pr
	on		p.co_procedimento = pr.co_procedimento

	where 		p.co_procedimento = @codigo
	and		pr.co_registro in ('03','04','05')
end



-- VERIFICA SE O PROCEDIMENTO EXIGE IDADE PARA BPA-C --------------------------------------------------------------------
if @opcao = 8
begin

	select		pd.co_procedimento

	from 		rl_procedimento_detalhe pd
	
	where 		pd.co_procedimento = @codigo
	and		pd.co_detalhe = '012'
end



-- VERIFICA SE O CID É COMPATÍVEL COM O PROCEDIMENTO --------------------------------------------------------------------
if @opcao = 9
begin

	select 		p.co_procedimento
	
	from		tb_procedimento p
	
	where		p.co_procedimento = @codigo
	
	and	(	not exists ( 	select 	1
					from 	rl_procedimento_cid pc
					where 	p.co_procedimento = pc.co_procedimento		)
	
	
	or		exists ( 	select 	1
					from 	rl_procedimento_cid pc
					where 	p.co_procedimento = pc.co_procedimento
					and	pc.co_cid = isnull(@cid, pc.co_cid)	)	)


end



-- VERIFICA SE A QTDE INFORMADA É PERMITIDA -----------------------------------------------------------------------------
if @opcao = 10
begin

	select		p.co_procedimento

	from 		tb_procedimento p
	
	where 		p.co_procedimento = @codigo
	and		p.qt_maxima_execucao >= @qtde
end



-- VERIFICA SE O CBO É COMPATÍVEL COM O PROCEDIMENTO --------------------------------------------------------------------
if @opcao = 11
begin

	select 		p.co_procedimento
	
	from		tb_procedimento p
	
	where		p.co_procedimento = @codigo
	
	and	(	not exists ( 	select 	1
					from 	rl_procedimento_ocupacao po
					where 	p.co_procedimento = po.co_procedimento		)
	
	
	or		exists ( 	select 	1
					from 	rl_procedimento_ocupacao po
					where 	p.co_procedimento = po.co_procedimento
					and	po.co_ocupacao = isnull(@cbo, po.co_ocupacao)	)	)
end



-- VERIFICA SE O PROCEDIMENTO EXIGE CNS DO PACIENTE ---------------------------------------------------------------------
if @opcao = 12
begin

	select		pd.co_procedimento

	from 		rl_procedimento_detalhe pd
	
	where 		pd.co_procedimento = @codigo
	and		pd.co_detalhe = '009'
end



--Lista CID
if @opcao = 13
begin
	select		c.CO_CID, c.NO_CID

	from 		tb_procedimento p
	inner join	rl_procedimento_cid rpc on rpc.CO_PROCEDIMENTO = p.CO_PROCEDIMENTO
	inner join	tb_cid c on c.CO_CID = rpc.CO_CID
	
	where 		p.co_procedimento = @codigo
end

--Instrumento Registro
if @opcao = 14
begin
	select		r.CO_REGISTRO, r.NO_REGISTRO

	from 		tb_procedimento p
	inner join	rl_procedimento_registro rpr on rpr.CO_PROCEDIMENTO = p.CO_PROCEDIMENTO
	inner join	tb_registro r on r.CO_REGISTRO = rpr.CO_REGISTRO
	
	where 		p.co_procedimento = @codigo
end

--Lista CBO
if @opcao = 15
begin
	select		o.CO_OCUPACAO, o.no_ocupacao

	from 		tb_procedimento p
	inner join	rl_procedimento_ocupacao rpo on rpo.CO_PROCEDIMENTO = p.CO_PROCEDIMENTO
	inner join	tb_ocupacao o on o.CO_OCUPACAO = rpo.CO_OCUPACAO
	
	where 		p.co_procedimento = @codigo
end

--Dados Procedimento
if @opcao = 16
begin
	select		p.TP_SEXO, p.VL_IDADE_MINIMA, p.VL_IDADE_MAXIMA, p.QT_MAXIMA_EXECUCAO, p.VL_SH, p.VL_SA, p.VL_SP

	from 		tb_procedimento p
	
	where 		p.co_procedimento = @codigo
end

--Lista CBO
if @opcao = 17
begin
	select		o.CO_OCUPACAO, o.no_ocupacao

	from 		tb_procedimento p
	inner join	rl_procedimento_ocupacao rpo on rpo.CO_PROCEDIMENTO = p.CO_PROCEDIMENTO
	inner join	tb_ocupacao o on o.CO_OCUPACAO = rpo.CO_OCUPACAO
	
	where 		p.co_procedimento = @codigo 
		and (o.no_ocupacao like '%'+ @descricao + '%' or o.co_ocupacao like '%'+ @descricao + '%')
		--and (p.TP_SEXO = @ProcSexo or (p.TP_SEXO = 'I' or p.TP_SEXO = 'N')) or @ProcSexo is null
end


if @opcao = 18
begin
	select tp.CO_PROCEDIMENTO as PROC_CODIGO, tp.NO_PROCEDIMENTO as PROC_DESCRICAO from TB_PROCEDIMENTO TP
	INNER JOIN RL_PROCEDIMENTO_OCUPACAO RPO ON TP.CO_PROCEDIMENTO = RPO.CO_PROCEDIMENTO
	INNER JOIN TB_OCUPACAO TOC ON RPO.CO_OCUPACAO = TOC.CO_OCUPACAO
	join Profissional prof on prof.cbo_codigo = toc.CO_OCUPACAO
	join Tipo_Profissional tpr on tpr.tipprof_codigo = prof.tipprof_codigo
	and prof.prof_codigo = @ProfCodigo and toc.CO_OCUPACAO = @cbo 

	WHERE (tp.CO_PROCEDIMENTO like '%' + @descricao + '%' or tp.NO_PROCEDIMENTO like '%' + @descricao + '%')
	--and (tp.TP_SEXO = @ProcSexo or (tp.TP_SEXO = 'I' or tp.TP_SEXO = 'N')) or @ProcSexo is null
end

-- TRATAMENTO DE ERRO ---------------------------------------------------------------------------------------------------
if (@@error <> 0)
begin
 	raiserror('erro - tabela de procedimentos.',1,1)
 	 
end
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
PRINT N'Altering [dbo].[KSP_UPA_ATESTADOMEDICO]...';


GO
ALTER PROCEDURE [dbo].[KSP_UPA_ATESTADOMEDICO]
@ATESTADO_MEDICO_CODIGO INT=NULL, @ATENDAMB_CODIGO VARCHAR (12)=NULL, @NOME_PROFISSIONAL VARCHAR (100)=NULL, @CODIGO_PROFISSIONAL VARCHAR (50)=NULL, @NUMERO_REGISTRO_PROFISSIONAL VARCHAR (25)=NULL, @NOME_PACIENTE VARCHAR (100)=NULL, @CODIGO_PACIENTE VARCHAR (50)=NULL, @NOME_ACOMPANHANTE VARCHAR (100)=NULL, @ACOMPANHANTE_CPF VARCHAR (11)=NULL, @PACIENTE_CPF VARCHAR (11)=NULL, @PACIENTE_IDENTIDADE VARCHAR (11)=NULL, @AUTORIZACAO_CID CHAR (1)=NULL, @CID_CODIGO VARCHAR (9)=NULL, @CID_DESCRICAO VARCHAR (500)=NULL, @ESPECIALIDADE VARCHAR (50)=NULL, @NUMERO_BAM VARCHAR (12)=NULL, @NUMERO_DIAS_ATESTADO INT=NULL, @NUMERO_DIAS_ATESTADO_EXTENSO VARCHAR (50)=NULL, @OBSERVACOES VARCHAR (500)=NULL, @PACIENTE_MENOR CHAR (1)=NULL, @RESPONSAVEL_MENOR VARCHAR (100)=NULL, @UPA_UNIDADE VARCHAR (50)=NULL, @UPA_MUNICIPIO_UNIDADE VARCHAR (100)=NULL, @DATA_ATENDIMENTO VARCHAR (10)=NULL, @TIPO_ATESTADO CHAR (1)=NULL, @DATA_CRIACAO_ATESTADO VARCHAR (10)=NULL, @DATA_VALIDADE_ATESTADO VARCHAR (10)=NULL, @DATA_ENTRADA_ATESTADO VARCHAR (16)=NULL, @DATA_SAIDA_ATESTADO VARCHAR (16)=NULL, @INTER_CODIGO VARCHAR (12)=NULL, @LOCATEND_CODIGO VARCHAR (4)=NULL, @OPCAO SMALLINT, @TP_PESQ SMALLINT=NULL
AS
BEGIN
	
	SET NOCOUNT ON

	DECLARE @DTATENDIMENTO SMALLDATETIME
	DECLARE @DTCRIACAOATESTADO SMALLDATETIME
	DECLARE @DTVALIDADEATESTADO SMALLDATETIME
	DECLARE @DTENTRADAATESTADO SMALLDATETIME
	DECLARE @DTSAIDAATESTADO SMALLDATETIME
	 	
	SELECT @DTATENDIMENTO = CONVERT(SMALLDATETIME, @DATA_ATENDIMENTO, 103)
	SELECT @DTCRIACAOATESTADO = CONVERT(SMALLDATETIME, @DATA_CRIACAO_ATESTADO, 103)
	SELECT @DTVALIDADEATESTADO = CONVERT(SMALLDATETIME, @DATA_VALIDADE_ATESTADO, 103)

	SELECT @DTENTRADAATESTADO = CONVERT(SMALLDATETIME, @DATA_ENTRADA_ATESTADO, 103)
	SELECT @DTSAIDAATESTADO = CONVERT(SMALLDATETIME, @DATA_SAIDA_ATESTADO, 103)

-- LISTAGEM
	IF(@OPCAO = 0 AND @ATENDAMB_CODIGO IS NOT NULL)
	BEGIN

		SELECT * FROM UPA_ATESTADO_MEDICO AM
		WHERE AM.ATENDAMB_CODIGO = @ATENDAMB_CODIGO

	END
	
	IF(@OPCAO = 0 AND @INTER_CODIGO IS NOT NULL)
	BEGIN

		SELECT * FROM UPA_ATESTADO_MEDICO AM
		WHERE AM.INTER_CODIGO = @INTER_CODIGO

	END

-- INSERÇÃO
	IF(@OPCAO = 1 AND (@ATENDAMB_CODIGO IS NOT NULL OR @INTER_CODIGO IS NOT NULL) AND @TIPO_ATESTADO IS NOT NULL)
	BEGIN

		INSERT INTO UPA_ATESTADO_MEDICO
		
		(ATENDAMB_CODIGO, NOME_PROFISSIONAL, CODIGO_PROFISSIONAL, NUMERO_REGISTRO_PROFISSIONAL, NOME_PACIENTE, CODIGO_PACIENTE, NOME_ACOMPANHANTE, ACOMPANHANTE_CPF, PACIENTE_CPF, PACIENTE_IDENTIDADE, AUTORIZACAO_CID, CID_CODIGO, CID_DESCRICAO, ESPECIALIDADE,
		NUMERO_BAM, NUMERO_DIAS_ATESTADO, NUMERO_DIAS_ATESTADO_EXTENSO, OBSERVACOES, PACIENTE_MENOR, RESPONSAVEL_MENOR, UPA_UNIDADE, UPA_MUNICIPIO_UNIDADE, DATA_ATENDIMENTO, TIPO_ATESTADO, DATA_CRIACAO_ATESTADO, DATA_VALIDADE_ATESTADO, DATA_ENTRADA_ATESTADO, DATA_SAIDA_ATESTADO, INTER_CODIGO, LOCATEND_CODIGO)
		
		VALUES
		
		(@ATENDAMB_CODIGO, @NOME_PROFISSIONAL, @CODIGO_PROFISSIONAL, @NUMERO_REGISTRO_PROFISSIONAL, @NOME_PACIENTE, @CODIGO_PACIENTE, @NOME_ACOMPANHANTE, @ACOMPANHANTE_CPF, @PACIENTE_CPF, @PACIENTE_IDENTIDADE, @AUTORIZACAO_CID, @CID_CODIGO, @CID_DESCRICAO, @ESPECIALIDADE,
		@NUMERO_BAM, @NUMERO_DIAS_ATESTADO, @NUMERO_DIAS_ATESTADO_EXTENSO, @OBSERVACOES, @PACIENTE_MENOR, @RESPONSAVEL_MENOR, @UPA_UNIDADE, @UPA_MUNICIPIO_UNIDADE, @DTATENDIMENTO, @TIPO_ATESTADO, @DTCRIACAOATESTADO, @DTVALIDADEATESTADO, @DTENTRADAATESTADO, @DTSAIDAATESTADO, @INTER_CODIGO, @LOCATEND_CODIGO)

		SELECT convert(int,IDENT_CURRENT('UPA_ATESTADO_MEDICO'))  

	END

--EDIÇÃO
	IF(@OPCAO = 2 AND @ATESTADO_MEDICO_CODIGO IS NOT NULL AND (@ATENDAMB_CODIGO IS NOT NULL OR @INTER_CODIGO IS NOT NULL))
	BEGIN

		UPDATE UPA_ATESTADO_MEDICO

		SET
		NOME_PROFISSIONAL = @NOME_PROFISSIONAL,
		CODIGO_PROFISSIONAL = @CODIGO_PROFISSIONAL,
		NUMERO_REGISTRO_PROFISSIONAL = @NUMERO_REGISTRO_PROFISSIONAL,		
		NOME_PACIENTE =  @NOME_PACIENTE,
		CODIGO_PACIENTE = @CODIGO_PACIENTE,
		ATENDAMB_CODIGO = @ATENDAMB_CODIGO,
		NOME_ACOMPANHANTE = @NOME_ACOMPANHANTE,
		ACOMPANHANTE_CPF = @ACOMPANHANTE_CPF,
		PACIENTE_CPF = @PACIENTE_CPF,
		PACIENTE_IDENTIDADE = @PACIENTE_IDENTIDADE,
		AUTORIZACAO_CID = @AUTORIZACAO_CID,
		CID_CODIGO = @CID_CODIGO,
		CID_DESCRICAO = @CID_DESCRICAO,
		ESPECIALIDADE = @ESPECIALIDADE,
		NUMERO_BAM = @NUMERO_BAM,
		NUMERO_DIAS_ATESTADO = @NUMERO_DIAS_ATESTADO,
		NUMERO_DIAS_ATESTADO_EXTENSO = @NUMERO_DIAS_ATESTADO_EXTENSO,
		OBSERVACOES = @OBSERVACOES,
		PACIENTE_MENOR = @PACIENTE_MENOR,
		RESPONSAVEL_MENOR = @RESPONSAVEL_MENOR,
		UPA_UNIDADE = @UPA_UNIDADE,
		UPA_MUNICIPIO_UNIDADE = @UPA_MUNICIPIO_UNIDADE,
		DATA_ATENDIMENTO = @DTATENDIMENTO,
		TIPO_ATESTADO = @TIPO_ATESTADO,
		DATA_CRIACAO_ATESTADO = @DTCRIACAOATESTADO,
		DATA_VALIDADE_ATESTADO = @DTVALIDADEATESTADO,
		DATA_ENTRADA_ATESTADO = @DTENTRADAATESTADO,
		DATA_SAIDA_ATESTADO = @DTSAIDAATESTADO,
		INTER_CODIGO = @INTER_CODIGO,
		LOCATEND_CODIGO = @LOCATEND_CODIGO

		WHERE ATESTADO_MEDICO_CODIGO = @ATESTADO_MEDICO_CODIGO
		AND ((@ATENDAMB_CODIGO IS NOT NULL AND ATENDAMB_CODIGO = @ATENDAMB_CODIGO) or (@INTER_CODIGO IS NOT NULL AND INTER_CODIGO = @INTER_CODIGO))


	END

	IF(@OPCAO = 4)
	BEGIN

		SELECT * FROM UPA_ATESTADO_MEDICO		

	END


	IF(@OPCAO = 5 AND @CODIGO_PACIENTE IS NOT NULL AND @DATA_CRIACAO_ATESTADO IS NOT NULL)
	BEGIN

		SELECT *,MAX(UAM.DATA_VALIDADE_ATESTADO) FROM UPA_ATESTADO_MEDICO UAM
		WHERE  UAM.CODIGO_PACIENTE = @CODIGO_PACIENTE
		AND UAM.TIPO_ATESTADO = '1'
		AND UAM.DATA_VALIDADE_ATESTADO >= @DTCRIACAOATESTADO
		
		GROUP BY UAM.ATESTADO_MEDICO_CODIGO,
		UAM.CODIGO_PROFISSIONAL,
		UAM.NOME_PROFISSIONAL,
		UAM.NUMERO_REGISTRO_PROFISSIONAL,
		UAM.CODIGO_PACIENTE,
		UAM.ATENDAMB_CODIGO,
		UAM.NOME_PACIENTE,		
		UAM.NOME_ACOMPANHANTE,
		UAM.ACOMPANHANTE_CPF,
		UAM.PACIENTE_CPF,
		UAM.PACIENTE_IDENTIDADE,
		UAM.AUTORIZACAO_CID,
		UAM.CID_CODIGO,
		UAM.CID_DESCRICAO,
		UAM.ESPECIALIDADE,
		UAM.NUMERO_BAM,
		UAM.NUMERO_DIAS_ATESTADO,
		UAM.NUMERO_DIAS_ATESTADO_EXTENSO,
		UAM.OBSERVACOES,
		UAM.PACIENTE_MENOR,
		UAM.RESPONSAVEL_MENOR,
		UAM.UPA_UNIDADE,
		UAM.UPA_MUNICIPIO_UNIDADE,
		UAM.DATA_ATENDIMENTO,
		UAM.TIPO_ATESTADO,
		UAM.DATA_CRIACAO_ATESTADO,
		UAM.DATA_VALIDADE_ATESTADO,
		UAM.DATA_ENTRADA_ATESTADO,
		UAM.DATA_SAIDA_ATESTADO,
		UAM.INTER_CODIGO,
		UAM.LOCATEND_CODIGO

	END

	IF(@OPCAO = 6 AND @ATESTADO_MEDICO_CODIGO IS NOT NULL)
	BEGIN
	
		SELECT * FROM UPA_ATESTADO_MEDICO UAM
		WHERE UAM.ATESTADO_MEDICO_CODIGO = @ATESTADO_MEDICO_CODIGO

	END	

END

IF (@@ERROR <> 0)
BEGIN
	RAISERROR('ERRO: KSP_UPA_ATESTADOMEDICO',1,1)		 
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
PRINT N'Creating [dbo].[KSP_Diluente_Medicamento]...';


GO

CREATE PROCEDURE [dbo].[KSP_Diluente_Medicamento]       
@dime_codigo UNIQUEIDENTIFIER  = NULL,      
@dime_diluente VARCHAR(200) = NULL,      
@dime_medicamento  VARCHAR(200) = NULL,      
@usu_codigo CHAR(4) = NULL,      
@dime_ativo CHAR = NULL,      
@dime_codigomedicamento VARCHAR(200) = NULL,      
@dime_codigodiluente VARCHAR(200) = NULL,      
@opcao INT,    
@tp_pesq INT     
      
AS      
-----------------------------------------------------------------------------------------------------------------------      
-- Consulta todos os registros      
-----------------------------------------------------------------------------------------------------------------------      
IF @opcao = 0      
  BEGIN      
    SELECT dime_codigo      
         , dime_diluente      
         , dime_medicamento      
         , usu_codigo      
         , dime_ativo      
   , dime_codigomedicamento    
       , dime_codigodiluente    
      FROM Diluente_Medicamento      
  END      
-----------------------------------------------------------------------------------------------------------------------      
-- Consulta um registro por Id      
-----------------------------------------------------------------------------------------------------------------------      
IF @opcao = 1      
  BEGIN      
    SELECT dime_codigo      
         , dime_diluente      
         , dime_medicamento      
         , usu_codigo      
         , dime_ativo      
   , dime_codigomedicamento    
   , dime_codigodiluente    
      FROM Diluente_Medicamento      
  WHERE dime_codigo = @dime_codigo      
  END      
-----------------------------------------------------------------------------------------------------------------------      
-- Consulta todos os registros por medicamento      
-----------------------------------------------------------------------------------------------------------------------      
IF @opcao = 2      
  BEGIN      
    SELECT dime_codigo      
         , dime_diluente      
         , dime_medicamento      
         , usu_codigo      
         , dime_ativo      
   , dime_codigomedicamento    
   , dime_codigodiluente    
      FROM Diluente_Medicamento   
  WHERE dime_codigomedicamento = @dime_codigomedicamento      
  END      
-----------------------------------------------------------------------------------------------------------------------      
-- Cria associação de medicamento      
-----------------------------------------------------------------------------------------------------------------------      
IF @opcao = 3      
  BEGIN      
    INSERT INTO Diluente_Medicamento (
		dime_codigo,
		dime_diluente,
		dime_medicamento,
		usu_codigo,
		dime_ativo,
		dime_codigodiluente,
		dime_codigomedicamento)
      VALUES ( @dime_codigo      
    , @dime_diluente      
    , @dime_medicamento      
    , @usu_codigo      
    , 1     
    , @dime_codigodiluente
    , @dime_codigomedicamento)      
  END      
-----------------------------------------------------------------------------------------------------------------------      
-- Ativa ou desativa associação      
-----------------------------------------------------------------------------------------------------------------------      
if @opcao = 4      
  BEGIN      
    UPDATE Diluente_Medicamento      
       SET dime_ativo = @dime_ativo      
         , dime_diluente = @dime_diluente    
         , dime_medicamento  = @dime_medicamento    
   , dime_codigomedicamento = @dime_codigomedicamento    
   , dime_codigodiluente  = @dime_codigodiluente    
  WHERE dime_codigo = @dime_codigo      
  END      
-----------------------------------------------------------------------------------------------------------------------      
-- Exclúi assosicação      
-----------------------------------------------------------------------------------------------------------------------      
if @opcao = 5      
  BEGIN      
    DELETE FROM Diluente_Medicamento WHERE dime_codigo = @dime_codigo      
  END    
-----------------------------------------------------------------------------------------------------------------------      
-- Consulta associaão por ativo e diluente    
-----------------------------------------------------------------------------------------------------------------------      
if @opcao = 6    
  BEGIN    
    SELECT dime_codigo      
         , dime_diluente      
         , dime_medicamento      
         , usu_codigo      
         , dime_ativo      
   , dime_codigomedicamento    
         , dime_codigodiluente    
      FROM Diluente_Medicamento      
     WHERE dime_medicamento = @dime_medicamento      
    AND dime_diluente = @dime_diluente    
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
PRINT N'Creating [dbo].[KSP_Diluente_medicamento_historico]...';


GO
-- DROP PROCEDURE KSP_Diluente_medicamento_historico  
CREATE PROCEDURE KSP_Diluente_medicamento_historico  
  
 @dmhi_codigo    uniqueidentifier = NULL  
,@dime_codigo    uniqueidentifier = NULL  
,@usu_codigo    varchar(200) = NULL  
,@dmhi_medicamento   varchar(200) = NULL  
,@dmhi_medicamentocodigo varchar(200) = NULL  
,@dmhi_diluente    varchar(200) = NULL  
,@dmhi_diluentecodigo  varchar(200) = NULL  
,@dmhi_data     datetime  = NULL 
,@dmhi_tipoacao varchar(200) = NULL
,@opcao      INT  
,@tp_pesq     INT   
  
AS  
  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
-- Incluir registro  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
IF @opcao = 0   
  BEGIN  
  
    INSERT INTO Diluente_medicamento_historico   
      VALUES (@dmhi_codigo
             , @dime_codigo
             , @usu_codigo
             , @dmhi_medicamento
             , @dmhi_diluente
             , @dmhi_data
             , @dmhi_medicamentocodigo
             , @dmhi_diluentecodigo
             , @dmhi_tipoacao)

  
  END  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
---- Consulta todos os registros (top 100)  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--IF @opcao = 1  
--  BEGIN  
  
--  END  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
---- Consulta todos os registros na data por usuário ou não  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--IF @opcao = 2  
--  BEGIN  
  
--  END  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
---- Consulta todos os registros por usuario  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--IF @opcao = 3  
--  BEGIN  
  
--  END  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
---- Consulta por associação de diluente  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--IF @opcao = 4  
--  BEGIN  
  
--  END
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
PRINT N'Creating [dbo].[ksp_IntegracaoSolutiCertificadoDigital]...';


GO
CREATE PROCEDURE [dbo].[ksp_IntegracaoSolutiCertificadoDigital]
@UrlApiKlinikos varchar(100) = null, @UrlApiSoluti varchar(100) = null, @ativo bit = 0, @CodigoUnidade varchar(4) = null, @TP_PESQ SMALLINT=NULL, @CaminhoRelatorioApi varchar(1000) = null, @OPCAO SMALLINT
AS
DECLARE @SQL VARCHAR(255)  
   DECLARE @PAR VARCHAR(255)  
   DECLARE @VAR1 VARCHAR(255)  
  
----------------------------- SELECAO PARA CARGA DOS DADOS ------------------------------------  
  
IF @OPCAO = 0  
  
  BEGIN  
	Select UrlApiKlinikos, UrlApiSoluti, case when Ativo = 1 then 'S' else 'N' end as ativo, CodigoUnidade
	from IntegracaoSolutiCertificadoDigital
	where CodigoUnidade = isnull(@CodigoUnidade, CodigoUnidade)
   END  
  
------------------------------------ INCLUSAO DOS DADOS ---------------------------------------  
IF @OPCAO = 1  
  begin
	IF(not exists(select 1 from IntegracaoSolutiCertificadoDigital where CodigoUnidade = @CodigoUnidade))
	BEGIN
		INSERT into IntegracaoSolutiCertificadoDigital (UrlApiKlinikos, UrlApiSoluti, Ativo, CodigoUnidade)
		VALUES (@UrlApiKlinikos, @UrlApiSoluti, @Ativo, @CodigoUnidade) 
	END
	else
	begin
		update IntegracaoSolutiCertificadoDigital 
		set UrlApiKlinikos = @UrlApiKlinikos,
			UrlApiSoluti = @UrlApiSoluti,
			Ativo = @ativo
		where CodigoUnidade = @CodigoUnidade
	end
  end
  
------------------------------------ ALTERACAO DOS DADOS ---------------------------------------  
------------------------------------------------------------------------------------------------------------------  
  
IF (@@ERROR <> 0)  
       BEGIN  
  SELECT @SQL = 'ERRO - TABELA DE ACESSO. OPCAO : ' + CONVERT(VARCHAR,@OPCAO)  
          RAISERROR(@SQL,1,1)  
             
       END  
  

SET QUOTED_IDENTIFIER ON  
  
SET ANSI_NULLS  ON
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
PRINT N'Creating [dbo].[ksp_Relatorio_Assinado]...';


GO
CREATE PROCEDURE [dbo].[ksp_Relatorio_Assinado]
 @ArquivoRPT varchar(300) = null, @CodigoRelatorio int = null, @DataHora datetime = null, @ResultadoLink varchar(300) = null, 
 @ResultadoBase64 VARBINARY(MAX) = null, @CodigoPrescricao varchar(12) = null, @CodigoProfissional varchar(4) = null, 
 @CodigoReceita varchar(12) = null, @AtestadoMedicoCodigo int = null, @AtendCodigo varchar(12) = null, @PacCodigo varchar(12) = null,
 @opcao int
as 
BEGIN
	IF (@opcao = 0)
	BEGIN 
		select top 1 * from RelatorioAssinado
		where CodigoRelatorio = @CodigoRelatorio 
		and (@CodigoPrescricao is not null and CodigoPrescricao = @CodigoPrescricao)
		     or (@CodigoPrescricao is null and CodigoPrescricao is null)
		and (@CodigoReceita is not null and CodigoReceita = @CodigoReceita)
		     or (@CodigoReceita is null and CodigoReceita is null)
		and (@AtestadoMedicoCodigo is not null and AtestadoMedicoCodigo = @AtestadoMedicoCodigo)
		     or (@AtestadoMedicoCodigo is null and AtestadoMedicoCodigo is null)
		and (@AtendCodigo is not null and AtendCodigo = @AtendCodigo)
		     or (@AtendCodigo is null and AtendCodigo is null)
		and (@PacCodigo is not null and PacCodigo = @PacCodigo)
		     or (@PacCodigo is null and PacCodigo is null)
		order by datahora desc 
	END

	IF (@opcao = 1)
	BEGIN
		if(not exists(
			select top 1 * from RelatorioAssinado
		where CodigoRelatorio = @CodigoRelatorio 
		and (@CodigoPrescricao is not null and CodigoPrescricao = @CodigoPrescricao)
		     or (@CodigoPrescricao is null and CodigoPrescricao is null)
		and (@CodigoReceita is not null and CodigoReceita = @CodigoReceita)
		     or (@CodigoReceita is null and CodigoReceita is null)
		and (@AtestadoMedicoCodigo is not null and AtestadoMedicoCodigo = @AtestadoMedicoCodigo)
		     or (@AtestadoMedicoCodigo is null and AtestadoMedicoCodigo is null)
		and (@AtendCodigo is not null and AtendCodigo = @AtendCodigo)
		     or (@AtendCodigo is null and AtendCodigo is null)
		and (@PacCodigo is not null and PacCodigo = @PacCodigo)
		     or (@PacCodigo is null and PacCodigo is null)
		))
		Begin
			insert into RelatorioAssinado 
			(ArquivoRPT, CodigoRelatorio, DataHora, ResultadoLink, ResultadoBase64, CodigoPrescricao, CodigoProfissional, CodigoReceita, AtestadoMedicoCodigo, AtendCodigo, PacCodigo)
			values 
			(@ArquivoRPT, @CodigoRelatorio, @DataHora, @ResultadoLink, @ResultadoBase64, @CodigoPrescricao, @CodigoProfissional, @CodigoReceita, @AtestadoMedicoCodigo, @AtendCodigo, @PacCodigo)
		END
		ELSE
		BEGIN
			update RelatorioAssinado
			set DataHora = @DataHora, ResultadoLink = @ResultadoLink, ResultadoBase64 = @ResultadoBase64, CodigoProfissional = @CodigoProfissional
			where CodigoRelatorio = @CodigoRelatorio 
			and (@CodigoPrescricao is not null and CodigoPrescricao = @CodigoPrescricao)
				or (@CodigoPrescricao is null and CodigoPrescricao is null)
			and (@CodigoReceita is not null and CodigoReceita = @CodigoReceita)
				or (@CodigoReceita is null and CodigoReceita is null)
			and (@AtestadoMedicoCodigo is not null and AtestadoMedicoCodigo = @AtestadoMedicoCodigo)
				or (@AtestadoMedicoCodigo is null and AtestadoMedicoCodigo is null)
			and (@AtendCodigo is not null and AtendCodigo = @AtendCodigo)
				or (@AtendCodigo is null and AtendCodigo is null)
			and (@PacCodigo is not null and PacCodigo = @PacCodigo)
				or (@PacCodigo is null and PacCodigo is null) 
		END
	END

	IF (@opcao = 2)
	BEGIN
		update RelatorioAssinado
			set DataHora = @DataHora, ResultadoLink = @ResultadoLink, ResultadoBase64 = @ResultadoBase64, CodigoProfissional = @CodigoProfissional
			where CodigoRelatorio = @CodigoRelatorio 
			and (@CodigoPrescricao is not null and CodigoPrescricao = @CodigoPrescricao)
				or (@CodigoPrescricao is null and CodigoPrescricao is null)
			and (@CodigoReceita is not null and CodigoReceita = @CodigoReceita)
				or (@CodigoReceita is null and CodigoReceita is null)
			and (@AtestadoMedicoCodigo is not null and AtestadoMedicoCodigo = @AtestadoMedicoCodigo)
				or (@AtestadoMedicoCodigo is null and AtestadoMedicoCodigo is null)
			and (@AtendCodigo is not null and AtendCodigo = @AtendCodigo)
				or (@AtendCodigo is null and AtendCodigo is null)
			and (@PacCodigo is not null and PacCodigo = @PacCodigo)
				or (@PacCodigo is null and PacCodigo is null) 
	END

	IF (@opcao = 3)
	BEGIN 
		select * from RelatorioAssinado
	END
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
PRINT N'Refreshing [dbo].[ksp_baa_Medicamentos_Prescritos_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_baa_Medicamentos_Prescritos_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_Fila_Usa_Classificacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Fila_Usa_Classificacao]';


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
PRINT N'Refreshing [dbo].[ksp_Item_Aprazamento_Dto]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Item_Aprazamento_Dto]';


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
PRINT N'Refreshing [dbo].[ksp_Item_Aprazamento_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Item_Aprazamento_Impresso]';


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
PRINT N'Refreshing [dbo].[Ksp_Prescricao_Contingencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_Prescricao_Contingencia]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_IDENTIFICACAO_PACIENTE_LEITO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_IDENTIFICACAO_PACIENTE_LEITO]';


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
PRINT N'Refreshing [dbo].[Ksp_SUB_Prescricao_Completa_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_SUB_Prescricao_Completa_Impresso]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_FILA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_FILA]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Medicamentos_Prescritos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Medicamentos_Prescritos]';


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
PRINT N'Refreshing [dbo].[ksp_Pacientes_Observacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Pacientes_Observacao]';


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
PRINT N'Refreshing [dbo].[ksp_Item_Aprazamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Item_Aprazamento]';


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
PRINT N'Refreshing [dbo].[ksp_PEP_Receituario_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Receituario_Impresso]';


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
PRINT N'Refreshing [dbo].[ksp_PEP_Relatorio_Boletim_Subreport_Medicamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Relatorio_Boletim_Subreport_Medicamento]';


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
PRINT N'Refreshing [dbo].[ksp_Prescricao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Prescricao]';


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
PRINT N'Refreshing [dbo].[ksp_procedimentos_faturamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_procedimentos_faturamento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_internacao_paciente_prescricao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_internacao_paciente_prescricao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Medicamento_Saldo_Grupo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Medicamento_Saldo_Grupo]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_prescricao_antimicrobiano]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_prescricao_antimicrobiano]';


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
PRINT N'Refreshing [dbo].[Ksp_SUB_RECEITAS_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_SUB_RECEITAS_Impresso]';


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
PRINT N'Refreshing [dbo].[ksp_Painel_Central]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Painel_Central]';


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
PRINT N'Refreshing [dbo].[ksp_Agenda_Consulta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Agenda_Consulta]';


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
PRINT N'Refreshing [dbo].[ksp_Agenda_Permissao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Agenda_Permissao]';


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
PRINT N'Refreshing [dbo].[ksp_atualizacao_historico_organograma]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atualizacao_historico_organograma]';


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
PRINT N'Refreshing [dbo].[ksp_bpa_importacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_bpa_importacao]';


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
PRINT N'Refreshing [dbo].[ksp_bpa_importacao_OP1]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_bpa_importacao_OP1]';


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
PRINT N'Refreshing [dbo].[ksp_bpa_individualizado_importacao_OP1]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_bpa_individualizado_importacao_OP1]';


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
PRINT N'Refreshing [dbo].[ksp_enfermaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_enfermaria]';


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
PRINT N'Refreshing [dbo].[ksp_INTEGRACAO_INTERNACAO_SER]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_INTEGRACAO_INTERNACAO_SER]';


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
PRINT N'Refreshing [dbo].[ksp_lista_prescricao_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_lista_prescricao_internacao]';


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
PRINT N'Refreshing [dbo].[kSp_Movimentacao_Paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_Movimentacao_Paciente]';


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
PRINT N'Refreshing [dbo].[ksp_pedido_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_pedido_internacao]';


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
PRINT N'Refreshing [dbo].[ksp_procedimento_faturamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_procedimento_faturamento]';


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
PRINT N'Refreshing [dbo].[ksp_Protocolo_Dengue]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Protocolo_Dengue]';


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
PRINT N'Refreshing [dbo].[KSP_REGISTRO_OBITO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_REGISTRO_OBITO]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Agenda_Marcacao_Consulta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Agenda_Marcacao_Consulta]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_AGENDA_PRODUCAO_CLINICA_SALDO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_AGENDA_PRODUCAO_CLINICA_SALDO]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_boletim_movimento_hospitalar]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_boletim_movimento_hospitalar]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_boletim_movimento_hospitalar_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_boletim_movimento_hospitalar_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Cadastro_Obito_Geral_Unidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Cadastro_Obito_Geral_Unidade]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_censo_hospitalar]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_censo_hospitalar]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_anual_internacoes]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_anual_internacoes]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_anual_mortalidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_anual_mortalidade]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_anual_ocupacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_anual_ocupacao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_internacao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_identificacao_prontuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_identificacao_prontuario]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_paciente_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_paciente_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laudo_solicitacao_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laudo_solicitacao_internacao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laudo_solicitacao_internacao_sem_vinculo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laudo_solicitacao_internacao_sem_vinculo]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_oferta_leitos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_oferta_leitos]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ORGANOGRAMA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ORGANOGRAMA]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Pacientes_Ausentes_Atendimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Pacientes_Ausentes_Atendimento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_upa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_upa]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_prontuario_em_ordem]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_prontuario_em_ordem]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_REGISTRO_OBITO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_REGISTRO_OBITO]';


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
PRINT N'Refreshing [dbo].[ksp_Setor_Stok]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Setor_Stok]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_FILA_31]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_FILA_31]';


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
PRINT N'Refreshing [dbo].[ksp_upa_fila_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_upa_fila_internacao]';


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
PRINT N'Refreshing [dbo].[ksp_Usuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Usuario]';


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
PRINT N'Refreshing [dbo].[ksp_portal_medico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_portal_medico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Agenda_Medica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Agenda_Medica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_agenda_producao_medico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_agenda_producao_medico]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_agenda_producao_usuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_agenda_producao_usuario]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Ambulatorio_Marcacao_Consulta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Ambulatorio_Marcacao_Consulta]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Ambulatorio_Marcacao_Consulta_Modulo2]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Ambulatorio_Marcacao_Consulta_Modulo2]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Geo_AgendaPedido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Geo_AgendaPedido]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Marcacao_Exame_Grupo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Marcacao_Exame_Grupo]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Producao_Clinica_Medico_Turno]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Producao_Clinica_Medico_Turno]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Producao_Clinica_Turno]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Producao_Clinica_Turno]';


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
PRINT N'Refreshing [dbo].[Ksp_Clinicas]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_Clinicas]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Emergencia_Pendente_Realizado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Emergencia_Pendente_Realizado]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_emergencia_hora_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_emergencia_hora_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_emergencia_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_emergencia_web]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_FILA_11]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_FILA_11]';


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
PRINT N'Refreshing [dbo].[ksp_procedimentos_realizados]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_procedimentos_realizados]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_diarios]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_diarios]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_diarios_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_diarios_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_por_frequencia_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_por_frequencia_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_por_Municipio_e_Bairro]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_por_Municipio_e_Bairro]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_leitos_apoio]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_leitos_apoio]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_LEITOS_APOIO_WEB]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_LEITOS_APOIO_WEB]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_diagnostico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_diagnostico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_diagnostico_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_diagnostico_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_internados]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_internados]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_internados_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_internados_web]';


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
PRINT N'Refreshing [dbo].[ksp_Resumo_Alta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Resumo_Alta]';


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
PRINT N'Refreshing [dbo].[ksp_Atendimentos_Andamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Atendimentos_Andamento]';


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
PRINT N'Refreshing [dbo].[ksp_Fila_Atendimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Fila_Atendimento]';


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
PRINT N'Refreshing [dbo].[ksp_paciente_andamento_nome]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_paciente_andamento_nome]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_spa_mun_bai_dia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_spa_mun_bai_dia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Urgencia_Pendente_Realizado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Urgencia_Pendente_Realizado]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Atendimento_Historico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Atendimento_Historico]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_CONSOLIDACAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_CONSOLIDACAO]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_ConsultaProfissionalEspecialidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_ConsultaProfissionalEspecialidade]';


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
PRINT N'Refreshing [dbo].[ksp_rel_centro_cirurgico_anestesia_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_centro_cirurgico_anestesia_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_rel_centro_cirurgico_estatistica_mensal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_centro_cirurgico_estatistica_mensal]';


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
PRINT N'Refreshing [dbo].[ksp_rel_centro_cirurgico_motivos_suspensao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_centro_cirurgico_motivos_suspensao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_anestesiologia_tipo_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_anestesiologia_tipo_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_resumo_anestesiologia_clinica_tipo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_resumo_anestesiologia_clinica_tipo]';


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
PRINT N'Refreshing [dbo].[ksp_Checkin]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Checkin]';


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
PRINT N'Refreshing [dbo].[ksp_Estoque]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Estoque]';


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
PRINT N'Refreshing [dbo].[ksp_ficha_notificacao_compulsoria_dengue]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_ficha_notificacao_compulsoria_dengue]';


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
PRINT N'Refreshing [dbo].[ksp_ficha_notificacao_compulsoria_geral]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_ficha_notificacao_compulsoria_geral]';


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
PRINT N'Refreshing [dbo].[ksp_Profissional_Lotacao_Posto_Enfermagem]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Profissional_Lotacao_Posto_Enfermagem]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_central_ficha_notificacao_compulsoria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_central_ficha_notificacao_compulsoria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnostico_prescricao_admitir_leito]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnostico_prescricao_admitir_leito]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_admissao_admitir_leito]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_admissao_admitir_leito]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_notificacao_compulsoria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_notificacao_compulsoria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_notificacao_compulsoria_Dengue]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_notificacao_compulsoria_Dengue]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_observacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_observacao]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_INTERNACAO_PENDENCIA_OBSERVACAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_INTERNACAO_PENDENCIA_OBSERVACAO]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_internados_localizacao_fisica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_internados_localizacao_fisica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_protocolo_risco_queda_admitir_leito]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_protocolo_risco_queda_admitir_leito]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_urgencia_ficha_notificacao_compulsoria_dengue]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_urgencia_ficha_notificacao_compulsoria_dengue]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Laboratorio_Laudo_Exame_Multi]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Laboratorio_Laudo_Exame_Multi]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_mapa_cirurgico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_mapa_cirurgico]';


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
PRINT N'Refreshing [dbo].[ksp_Anotacao_Cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Anotacao_Cirurgia]';


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
PRINT N'Refreshing [dbo].[Ksp_Aprazamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_Aprazamento]';


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
PRINT N'Refreshing [dbo].[ksp_cirurgico_solicitacao_cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_cirurgico_solicitacao_cirurgia]';


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
PRINT N'Refreshing [dbo].[ksp_declaracao_paciente_internado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_declaracao_paciente_internado]';


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
PRINT N'Refreshing [dbo].[ksp_enche_combo_opcao_126]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_enche_combo_opcao_126]';


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
PRINT N'Refreshing [dbo].[kSp_HospitalDia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_HospitalDia]';


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
PRINT N'Refreshing [dbo].[ksp_laboratorio_Controle_Mapa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_laboratorio_Controle_Mapa]';


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
PRINT N'Refreshing [dbo].[ksp_Laboratorio_Folha_Rosto]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Laboratorio_Folha_Rosto]';


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
PRINT N'Refreshing [dbo].[ksp_laboratorio_interface_Elemento_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_laboratorio_interface_Elemento_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_laboratorio_Mapa_Trabalho]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_laboratorio_Mapa_Trabalho]';


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
PRINT N'Refreshing [dbo].[ksp_Leitos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Leitos]';


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
PRINT N'Refreshing [dbo].[ksp_paciente_observacao_nome]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_paciente_observacao_nome]';


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
PRINT N'Refreshing [dbo].[ksp_pedido_cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_pedido_cirurgia]';


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
PRINT N'Refreshing [dbo].[ksp_Pesquisa_Paciente_Web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Pesquisa_Paciente_Web]';


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
PRINT N'Refreshing [dbo].[Ksp_Posto_Enfermagem]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_Posto_Enfermagem]';


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
PRINT N'Refreshing [dbo].[ksp_registro_prontuario_historico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_registro_prontuario_historico]';


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
PRINT N'Refreshing [dbo].[ksp_rel_diario_Internacao_Adoslescente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_diario_Internacao_Adoslescente]';


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
PRINT N'Refreshing [dbo].[ksp_rel_inter_desp_hosp_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_inter_desp_hosp_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_AnatomiaPatologica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_AnatomiaPatologica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_aprazamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_aprazamento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_censo_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_censo_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_censo_hospitalar_paciente_internado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_censo_hospitalar_paciente_internado]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_emergencia_estatistica_censo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_emergencia_estatistica_censo]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_Noturno]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_EVOLUCAO_CTI_Noturno]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_evolucao_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_evolucao_paciente]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_FARMACIA_ANALITICO_MEDICAMENTO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_FARMACIA_ANALITICO_MEDICAMENTO]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_FARMACIA_PACIENTES_NAO_CADASTRADOS]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_FARMACIA_PACIENTES_NAO_CADASTRADOS]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_internacao_hospital_dia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_internacao_hospital_dia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_grade_ocupacao_leito]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_grade_ocupacao_leito]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_despesas_hospitalares]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_despesas_hospitalares]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_despesas_hospitalares_HFM]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_despesas_hospitalares_HFM]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_diaria_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_diaria_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internados_faixa_etaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internados_faixa_etaria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internados_faixa_etaria_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internados_faixa_etaria_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_mapa_individual]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_mapa_individual]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_laboratorio_Mapa_Trabalho_Interface]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_laboratorio_Mapa_Trabalho_Interface]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_laboratorio_Preparo_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_laboratorio_Preparo_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_leitos_operacionais]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_leitos_operacionais]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_mapa_cirurgico_generico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_mapa_cirurgico_generico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_mapa_diario_censo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_mapa_diario_censo]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_obitos_por_municipio]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_obitos_por_municipio]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pedidos_pendentes_x_realizados]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pedidos_pendentes_x_realizados]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_prescricao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_prescricao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Pedido_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Pedido_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Reinternacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Reinternacao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_restricoes_visita]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_restricoes_visita]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_saidas_diaria_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_saidas_diaria_web]';


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
PRINT N'Refreshing [dbo].[ksp_restricoes_visita]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_restricoes_visita]';


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
PRINT N'Refreshing [dbo].[ksp_Solicitacao_Pedido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Solicitacao_Pedido]';


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
PRINT N'Refreshing [dbo].[ksp_SOS_Emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_SOS_Emergencia]';


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
PRINT N'Refreshing [dbo].[KSP_UPA_CONSOLIDACAO_PACIENTE_OBSERVACAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_UPA_CONSOLIDACAO_PACIENTE_OBSERVACAO]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_FILA_8]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_FILA_8]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Relatorio_Coleta_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Relatorio_Coleta_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Requisicao_Externa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Requisicao_Externa]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_WEBSERVICE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_WEBSERVICE]';


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
PRINT N'Refreshing [dbo].[ksp_evolucao_impresso_cabecalho]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_evolucao_impresso_cabecalho]';


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
PRINT N'Refreshing [dbo].[ksp_parecer_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_parecer_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_prontuario_internacao_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_prontuario_internacao_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_AIH_exportacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_AIH_exportacao]';


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
PRINT N'Refreshing [dbo].[ksp_rel_Procedimento_sintetico_Municipio_Bairro]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_Procedimento_sintetico_Municipio_Bairro]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_visitante]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_visitante]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_etiqueta_visitante_acompanhante]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_etiqueta_visitante_acompanhante]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_conta_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_conta_paciente]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_internacao_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_internacao_paciente]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_diaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_diaria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_diaria_Internacao_Alta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_diaria_Internacao_Alta]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_municipio_cid]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_municipio_cid]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_plano]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_plano]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internados_municipio_bairro]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internados_municipio_bairro]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_mapa_trabalho]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_mapa_trabalho]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_movimentacao_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_movimentacao_paciente]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_movimentacao_paciente_int]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_movimentacao_paciente_int]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_obitos_diarios]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_obitos_diarios]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_internados_alfabetica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_internados_alfabetica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_internados_tempo_permanencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_internados_tempo_permanencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_saidas_diaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_saidas_diaria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_visitante_por_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_visitante_por_paciente]';


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
PRINT N'Refreshing [dbo].[ksp_baa_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_baa_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_acesso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_acesso]';


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
PRINT N'Refreshing [dbo].[ksp_Administracao_meta_procedimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Administracao_meta_procedimento]';


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
PRINT N'Refreshing [dbo].[ksp_anatomiapatologica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_anatomiapatologica]';


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
PRINT N'Refreshing [dbo].[ksp_anatomiapatologica_Pedido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_anatomiapatologica_Pedido]';


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
PRINT N'Refreshing [dbo].[ksp_baa_parecer_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_baa_parecer_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_cirurgico_obtem_dados_cirurgico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_cirurgico_obtem_dados_cirurgico]';


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
PRINT N'Refreshing [dbo].[ksp_consulta_pedido_exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_consulta_pedido_exame]';


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
PRINT N'Refreshing [dbo].[ksp_consulta_pedido_exame_anatomiapatologica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_consulta_pedido_exame_anatomiapatologica]';


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
PRINT N'Refreshing [dbo].[ksp_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_evolucaobase_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_evolucaobase_impresso]';


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
PRINT N'Refreshing [dbo].[ksp_internacao_procedimento_cid ]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_internacao_procedimento_cid ]';


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
PRINT N'Refreshing [dbo].[ksp_LocalAtendimento_EspecialidadeSER2]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_LocalAtendimento_EspecialidadeSER2]';


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
PRINT N'Refreshing [dbo].[ksp_paciente_historico_assistencial]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_paciente_historico_assistencial]';


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
PRINT N'Refreshing [dbo].[KSP_PEP_ENCAMINHAMENTO_PACIENTE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_PEP_ENCAMINHAMENTO_PACIENTE]';


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
PRINT N'Refreshing [dbo].[ksp_PEP_Sumario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_PEP_Sumario]';


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
PRINT N'Refreshing [dbo].[ksp_pronto_atendimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_pronto_atendimento]';


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
PRINT N'Refreshing [dbo].[ksp_radiologia_Enche_Combo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_radiologia_Enche_Combo]';


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
PRINT N'Refreshing [dbo].[ksp_radiologia_Executa_Filtros]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_radiologia_Executa_Filtros]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_AGENDAS_MARCADAS_APOS_FECHAMENTO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_AGENDAS_MARCADAS_APOS_FECHAMENTO]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ambulatorio_marcacao_consulta_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ambulatorio_marcacao_consulta_web]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Ambulatorio_Pendente_Realizado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Ambulatorio_Pendente_Realizado]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_AnatomiaPatologica_Pedido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_AnatomiaPatologica_Pedido]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_atendimento_ambulatorial]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_atendimento_ambulatorial]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Boletim_Emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Boletim_Emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Cancelamento_fila]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Cancelamento_fila]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_cirurgia_atendida_natendida]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_cirurgia_atendida_natendida]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Consolidado_Classificacao_Risco_Totalizacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Consolidado_Classificacao_Risco_Totalizacao]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Encaminhamento_Externo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Encaminhamento_Externo]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Encaminhamento_Interno]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Encaminhamento_Interno]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Estatistica_Analitica_Unidade_Referenciada]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Estatistica_Analitica_Unidade_Referenciada]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_checkin]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_checkin]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_emergencia_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_emergencia_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_material]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_material]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_PRODUCAO_PROFISSIONAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_PRODUCAO_PROFISSIONAL]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_sala]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_sala]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_bpa_hosp]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_bpa_hosp]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_spa_mun_bai_clin_psaude]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_spa_mun_bai_clin_psaude]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_entrega_exames_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_entrega_exames_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Marcacao_Mesmo_Paciente_Dia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Marcacao_Mesmo_Paciente_Dia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_sem_prontuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_sem_prontuario]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pos_anestesico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pos_anestesico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pre_anestesico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pre_anestesico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pre_operatorio_completo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pre_operatorio_completo]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pre_operatorio_parcial]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pre_operatorio_parcial]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_checkin]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_checkin]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_checkout]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_checkout]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_profissional]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_profissional]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_profissional_acolhimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_profissional_acolhimento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_profissional_risco]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_profissional_risco]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Agenda_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Agenda_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Estatistica_ClinicaExame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Estatistica_ClinicaExame]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Estatistica_ExameUnidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Estatistica_ExameUnidade]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Estatistica_Pedido_Por_Dia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Estatistica_Pedido_Por_Dia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Estatistica_Pedido_Por_Hora]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Estatistica_Pedido_Por_Hora]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Laudo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Laudo]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_RESUMO_DIARIO_CONSULTAS]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_RESUMO_DIARIO_CONSULTAS]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_sub_estClinicaSala]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_sub_estClinicaSala]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_sub_estMaterialClinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_sub_estMaterialClinica]';


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
PRINT N'Refreshing [dbo].[ksp_Resumo_Atendimentos_Impressso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Resumo_Atendimentos_Impressso]';


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
PRINT N'Refreshing [dbo].[ksp_resumo_diario_consultas_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_resumo_diario_consultas_web]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Acolhimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Acolhimento]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_FILA_12]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_FILA_12]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_RemocoesPorUnidadeDetalhado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_RemocoesPorUnidadeDetalhado]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Consolidado_Classificacao_Risco]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Consolidado_Classificacao_Risco]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_checkin_Profissional]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_checkin_Profissional]';


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
PRINT N'Refreshing [dbo].[ksp_AcessoSeguranca]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_AcessoSeguranca]';


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
PRINT N'Refreshing [dbo].[ksp_Agenda_Ambulatorial_Aberta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Agenda_Ambulatorial_Aberta]';


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
PRINT N'Refreshing [dbo].[kSp_Agenda_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_Agenda_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_Agenda_Historico_Paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Agenda_Historico_Paciente]';


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
PRINT N'Refreshing [dbo].[KSP_ATENDIMENTO_AMBULATORIAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_ATENDIMENTO_AMBULATORIAL]';


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
PRINT N'Refreshing [dbo].[ksp_atendimento_clinico_notificacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atendimento_clinico_notificacao]';


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
PRINT N'Refreshing [dbo].[ksp_atendimento_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atendimento_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_Atendimento_Reavaliacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Atendimento_Reavaliacao]';


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
PRINT N'Refreshing [dbo].[ksp_atos_profissionais]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atos_profissionais]';


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
PRINT N'Refreshing [dbo].[ksp_atualizacao_estatistica_diaria_internacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atualizacao_estatistica_diaria_internacao]';


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
PRINT N'Refreshing [dbo].[ksp_atualizacao_estatistica_diaria_internacao_central]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atualizacao_estatistica_diaria_internacao_central]';


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
PRINT N'Refreshing [dbo].[ksp_baa_todos_itens_prescritos_impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_baa_todos_itens_prescritos_impresso]';


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
PRINT N'Refreshing [dbo].[Ksp_BoletimAtendimentoMedico_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_BoletimAtendimentoMedico_Impresso]';


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
PRINT N'Refreshing [dbo].[Ksp_BoletimClassificacaoRiscoLog_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_BoletimClassificacaoRiscoLog_Impresso]';


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
PRINT N'Refreshing [dbo].[ksp_cirurgico_pre_anestesia_avaliacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_cirurgico_pre_anestesia_avaliacao]';


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
PRINT N'Refreshing [dbo].[ksp_consulta_pedido_exame_laboratorio]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_consulta_pedido_exame_laboratorio]';


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
PRINT N'Refreshing [dbo].[KSP_Dados_Paciente_Agendado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_Dados_Paciente_Agendado]';


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
PRINT N'Refreshing [dbo].[ksp_estatistica_upa_diagnostico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_estatistica_upa_diagnostico]';


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
PRINT N'Refreshing [dbo].[ksp_extracao_quantidade_atendimento_remocao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_extracao_quantidade_atendimento_remocao]';


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
PRINT N'Refreshing [dbo].[ksp_Fila_Espera]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Fila_Espera]';


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
PRINT N'Refreshing [dbo].[ksp_historico_atendimento_clinico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_historico_atendimento_clinico]';


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
PRINT N'Refreshing [dbo].[ksp_Internacao_Clinica_Atual]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Internacao_Clinica_Atual]';


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
PRINT N'Refreshing [dbo].[kSp_ListaAlerta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_ListaAlerta]';


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
PRINT N'Refreshing [dbo].[ksp_listagem_prontuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_listagem_prontuario]';


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
PRINT N'Refreshing [dbo].[ksp_MOVIMENTACAO_PRONTUARIO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_MOVIMENTACAO_PRONTUARIO]';


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
PRINT N'Refreshing [dbo].[ksp_ordem_meta_procedimento_ambulatorial]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_ordem_meta_procedimento_ambulatorial]';


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
PRINT N'Refreshing [dbo].[kSp_Pedido_Agenda]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_Pedido_Agenda]';


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
PRINT N'Refreshing [dbo].[ksp_profissional]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_profissional]';


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
PRINT N'Refreshing [dbo].[kSp_Questionario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[kSp_Questionario]';


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
PRINT N'Refreshing [dbo].[ksp_radiologia_Laudo_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_radiologia_Laudo_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_Reagenda_Consulta_Exame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Reagenda_Consulta_Exame]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_atendimento_clinica_sexo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_atendimento_clinica_sexo]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_marcacao_clinica_idade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_marcacao_clinica_idade]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_marcacao_clinica_idade_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_marcacao_clinica_idade_web]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_municipio_bairro]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_municipio_bairro]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_paciente_externo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_paciente_externo]';


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
PRINT N'Refreshing [dbo].[ksp_rel_pext_paciente_externo_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_rel_pext_paciente_externo_web]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Agenda_Consulta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Agenda_Consulta]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_agenda_profissional_cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_agenda_profissional_cirurgia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_apac_valor_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_apac_valor_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_atendimento_faixa_etaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_atendimento_faixa_etaria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_bpai_valor_clinica_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_bpai_valor_clinica_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_bpai_valor_origem_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_bpai_valor_origem_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_bpai_valor_origem_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_bpai_valor_origem_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_central_bloqueio_agenda]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_central_bloqueio_agenda]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_ComprEntrega_GuiaRef]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_ComprEntrega_GuiaRef]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_central_ficha_notificacao_compulsoria_Dengue]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_central_ficha_notificacao_compulsoria_Dengue]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Posicao_Agenda]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Posicao_Agenda]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Central_Producao_Data_Turno]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Central_Producao_Data_Turno]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_cirurgia_realizada]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_cirurgia_realizada]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_conta_paciente_exames]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_conta_paciente_exames]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_por_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_por_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_diagnosticos_por_frequencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_diagnosticos_por_frequencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Estatistica_Atendimentos_Profissionais]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Estatistica_Atendimentos_Profissionais]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_cirurgia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_classificacao_risco_emer_spa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_classificacao_risco_emer_spa]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_CID]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_CID]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_CID_SEXO_FAIXA_ETARIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_CID_SEXO_FAIXA_ETARIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_OBITO_CID_SEXO_FAIXA_ETARIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_OBITO_CID_SEXO_FAIXA_ETARIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_OBITO_CID_SEXO_PERMANENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_OBITO_CID_SEXO_PERMANENCIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_TEMPO_PERMANENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_TEMPO_PERMANENCIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_TIPO_SAIDA_SEXO_FAIXA_ETARIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_EMERGENCIA_TIPO_SAIDA_SEXO_FAIXA_ETARIA]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_indicadores_hospitalares]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_indicadores_hospitalares]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_procedimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_procedimento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_procedimento_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_procedimento_web]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_OCORRENCIA_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_OCORRENCIA_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_OCORRENCIA_SPA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_OCORRENCIA_SPA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_ESTATISTICA_SPA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_ESTATISTICA_SPA]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_spa_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_spa_web]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Estatistica_upa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Estatistica_upa]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_aih_pendente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_aih_pendente]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_diagnosticos_maior_valor]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_diagnosticos_maior_valor]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_mensal_CLASSIFICACAO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_mensal_CLASSIFICACAO]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_mensal_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_mensal_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_mensal_diagnostico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_mensal_diagnostico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_mensal_procedimento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_mensal_procedimento]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_procedimentos_maior_valor]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_procedimentos_maior_valor]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_producao_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_producao_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_producao_sintetico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_producao_sintetico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_especialidade]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_especialidade]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_motivo_cobranca]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_motivo_cobranca]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_paciente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_paciente]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_paciente_analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_paciente_analitico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_sadt]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_sadt]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_faturamento_valores_sintetico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_faturamento_valores_sintetico]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_ficha_internacao_paciente_evolucao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_ficha_internacao_paciente_evolucao]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_checkin]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_checkin]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_emergencia_novo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_emergencia_novo]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_emergencia_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_emergencia_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_internacao_mensal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_internacao_mensal]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_geoestatistico_spa_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_geoestatistico_spa_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_municipio_bairro]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_municipio_bairro]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_internacao_ocorrencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_internacao_ocorrencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_ComprovanteColeta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_ComprovanteColeta]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_Entrega_Exames]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_Entrega_Exames]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_Estatistica_Secao_Origem]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_Estatistica_Secao_Origem]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_EstatisticaClinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_EstatisticaClinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_Movimentacao_Diaria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_Movimentacao_Diaria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_laboratorio_Notificacao_Compulsoria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_laboratorio_Notificacao_Compulsoria]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_lista_solicitacao_exame_laboratorio]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_lista_solicitacao_exame_laboratorio]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_morbidade_hospitalar]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_morbidade_hospitalar]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_movimentacao_prontuario_excedido]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_movimentacao_prontuario_excedido]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_movimentacao_prontuario_historico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_movimentacao_prontuario_historico]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_NOMINAL_OCORRENCIA_EMERGENCIA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_NOMINAL_OCORRENCIA_EMERGENCIA]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_NOMINAL_OCORRENCIA_SPA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_NOMINAL_OCORRENCIA_SPA]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_nominal_prontuarios_inativos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_nominal_prontuarios_inativos]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_obitos_diarios_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_obitos_diarios_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_origem_criacao_prontuario]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_origem_criacao_prontuario]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_Pacientes_Atendidos_Dia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_Pacientes_Atendidos_Dia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_pacientes_prontuario_aberto]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_pacientes_prontuario_aberto]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Procedimentos_Alterados_AIH]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Procedimentos_Alterados_AIH]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_procedimentos_diarios]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_procedimentos_diarios]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_procedimentos_diarios_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_procedimentos_diarios_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_procedimentos_por_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_procedimentos_por_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_procedimentos_por_frequencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_procedimentos_por_frequencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_procedimentos_por_frequencia_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_procedimentos_por_frequencia_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_emergencia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_emergencia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_emergencia_hora]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_emergencia_hora]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_profissional_cirurgia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_profissional_cirurgia]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_spa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_spa]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_spa_origem_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_spa_origem_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_producao_spa_web]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_producao_spa_web]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_quantidade_obitos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_quantidade_obitos]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_quantidade_obitos_clinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_quantidade_obitos_clinica]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_agenda_central_sub3]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_agenda_central_sub3]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_radiologia_Estatistica_GrupoExame]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_radiologia_Estatistica_GrupoExame]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_registro_aberto]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_registro_aberto]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_resumo_alta]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_resumo_alta]';


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
PRINT N'Refreshing [dbo].[KSP_RELATORIO_RESUMO_DIARIO_CONSULTAS_WEB]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RELATORIO_RESUMO_DIARIO_CONSULTAS_WEB]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_sistema]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_sistema]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_spa]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_spa]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_urgencia_ficha_notificacao_compulsoria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_urgencia_ficha_notificacao_compulsoria]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Valores_Nao_Faturados]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Valores_Nao_Faturados]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Valores_Nao_Faturados_Analitico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Valores_Nao_Faturados_Analitico]';


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
PRINT N'Refreshing [dbo].[KSP_RESUMO_MUNICIPIO_SPA_CLINICA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_RESUMO_MUNICIPIO_SPA_CLINICA]';


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
PRINT N'Refreshing [dbo].[ksp_Setor_Clinica_CID]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Setor_Clinica_CID]';


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
PRINT N'Refreshing [dbo].[ksp_Setor_Clinica_PROCEDIMENTO]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Setor_Clinica_PROCEDIMENTO]';


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
PRINT N'Refreshing [dbo].[ksp_SetorClinica_CID]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_SetorClinica_CID]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Atendimento_Medicamentos_Prescritos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Atendimento_Medicamentos_Prescritos]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_AtendimentosPorClinica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_AtendimentosPorClinica]';


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
PRINT N'Refreshing [dbo].[Ksp_UPA_Evolucao_Historico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_UPA_Evolucao_Historico]';


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
PRINT N'Refreshing [dbo].[Ksp_UPA_Evolucao_Historico_Diagnostico]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_UPA_Evolucao_Historico_Diagnostico]';


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
PRINT N'Refreshing [dbo].[Ksp_UPA_Evolucao_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_UPA_Evolucao_Impresso]';


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
PRINT N'Refreshing [dbo].[Ksp_UPA_Evolucao_Parecer]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_UPA_Evolucao_Parecer]';


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
PRINT N'Refreshing [dbo].[Ksp_UPA_EvolucaoAtendimento_Impresso]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ksp_UPA_EvolucaoAtendimento_Impresso]';


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
PRINT N'Refreshing [dbo].[KSP_UPA_FILA_JOB]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[KSP_UPA_FILA_JOB]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Medicamentos_PrescritosPorAgendamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Medicamentos_PrescritosPorAgendamento]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Todos_Itens_Prescritos]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Todos_Itens_Prescritos]';


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
PRINT N'Refreshing [dbo].[ksp_UPA_Todos_Itens_PrescritosPorAgendamento]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_UPA_Todos_Itens_PrescritosPorAgendamento]';


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
PRINT N'Refreshing [dbo].[ksp_atualizacao_censo_hospitalar]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_atualizacao_censo_hospitalar]';


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
PRINT N'Refreshing [dbo].[ksp_relatorio_estatistica_mensal_internacao_mes]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_relatorio_estatistica_mensal_internacao_mes]';


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
PRINT N'Refreshing [dbo].[ksp_Relatorio_Pacientes_Observacao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Relatorio_Pacientes_Observacao]';


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
PRINT N'Refreshing [dbo].[ksp_Item_Dispensado]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Item_Dispensado]';


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
PRINT N'Refreshing [dbo].[ksp_Pedido_Insumo_Farmacia]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Pedido_Insumo_Farmacia]';


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
PRINT N'Refreshing [dbo].[ksp_item_prescricao_medica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_item_prescricao_medica]';


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
PRINT N'Refreshing [dbo].[ksp_Prescricao_Medica]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_Prescricao_Medica]';


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
PRINT N'Refreshing [dbo].[ksp_evolucao]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ksp_evolucao]';


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
SET @versao = 'K.2020.06.4'

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
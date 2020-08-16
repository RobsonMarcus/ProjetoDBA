GO
insert into tipo_saida values (15,'A.1 - Alta por Decisão Médica - Externa','N','N','N','S',NULL,NULL);
insert into tipo_saida values (16,'A.3 - Alta por Decisão Médica - Interna','N','N','N','S',NULL,NULL);
insert into tipo_saida values (17,'A.4 - Alta com Retorno','N','N','N','S',NULL,NULL);
GO
--B.1 - Alta c/ Enc. Ambulatorial Interno
update tipo_saida set tipsai_Descricao = 'B.1 - (Interconsulta) Encaminhamento Ambulatorial' where tipsai_codigo = 10;
GO
DECLARE @pv binary(16)
BEGIN TRANSACTION
ALTER TABLE [dbo].[acesso_hierarquia] DROP CONSTRAINT [ACESSOHIERARQUIA_ACESSO_RFK]
ALTER TABLE [dbo].[acesso] DROP CONSTRAINT [ACESSO_SISTEMA_RFK]
UPDATE [dbo].[acesso_hierarquia] SET [ace_codigo_pai]=N'165' WHERE [ace_codigo]=N'BS0' AND [sis_codigo]=N'003'
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'NEF', N'003', N'Nefro/HD', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'PP1', N'003', N'Protocolo de Prescrição', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'ZB5', N'003', N'Integração SER2', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'ZB6', N'003', N'Incluir', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'ZB7', N'003', N'Alterar', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'ZB8', N'003', N'Consulta de Enfermagem', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso] ([ace_codigo], [sis_codigo], [ace_descricao], [ace_administrador], [ace_descricao_resumida], [ace_url_site], [ace_imagem_site], [ace_application_name], [ace_nome_item_permissao], [ace_item_menu], [ace_item_menu_order]) VALUES (N'ZB9', N'003', N'Consulta Multiprofissional', NULL, NULL, NULL, NULL, NULL, NULL, N'S', 0)
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'NEF', N'003', N'812', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'PP1', N'003', N'165', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'ZB5', N'003', N'02Z', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'ZB6', N'003', N'ZB5', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'ZB7', N'003', N'ZB5', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'ZB8', N'003', N'812', N'003')
INSERT INTO [dbo].[acesso_hierarquia] ([ace_codigo], [sis_codigo], [ace_codigo_pai], [sis_codigo_pai]) VALUES (N'ZB9', N'003', N'812', N'003')
ALTER TABLE [dbo].[acesso_hierarquia]
    ADD CONSTRAINT [ACESSOHIERARQUIA_ACESSO_RFK] FOREIGN KEY ([ace_codigo], [sis_codigo]) REFERENCES [dbo].[acesso] ([ace_codigo], [sis_codigo])
ALTER TABLE [dbo].[acesso]
    ADD CONSTRAINT [ACESSO_SISTEMA_RFK] FOREIGN KEY ([sis_codigo]) REFERENCES [dbo].[sistema] ([sis_codigo])
COMMIT TRANSACTION
GO

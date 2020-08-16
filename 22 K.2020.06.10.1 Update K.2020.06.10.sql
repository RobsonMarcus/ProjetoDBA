
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
PRINT N'Altering [dbo].[ksp_cid]...';


GO
ALTER PROCEDURE [dbo].[ksp_cid]
@codigo VARCHAR (9), @descricao VARCHAR (100), @sexo CHAR (1), @opcao INT, @tp_pesq INT, @cid_notcomp CHAR (1)=null
,@proc_codigo VARCHAR (10)=null, @unid_codigo CHAR (4)=null, @tp_agravo CHAR (1)=null, @PROF_CODIGO CHAR(4) = null
AS
set nocount on

	DECLARE @textoCodigo varchar(50)
	DECLARE @textoDescricao varchar(50)

	SET @textoCodigo = '%'+RTRIM(LTRIM(@codigo))+'%'
	SET @textoDescricao = '%'+RTRIM(LTRIM(@descricao))+'%'

-- SELECAO PARA CARGA DOS DADOS ----------------------------------------------------------------------------------------
if @opcao = 0
begin
	select 	cid_descricao, cid_sexo, cid_subcat, cid_notcomp
	from 	cid_10
	where 	cid_codigo = @codigo
end



-- PESQUISA -------------------------------------------------------------------------------------------------------------
if @opcao = 5
begin

	declare @lsql varchar(8000)
	declare @par varchar(500)
	declare @var varchar(500)

	Set @lSql = 'Select cid_10.cid_codigo, cid_10.cid_descricao, cid_10.cid_notcomp '
	Set @lSql = @lSql + 'From cid_10 '

	if @proc_codigo is not null
	begin
		Set @lSql = @lSql + 'Inner Join rl_procedimento_cid p_cid '
		Set @lSql = @lSql + 'On p_cid.CO_CID = cid_10.cid_codigo '
		Set @lSql = @lSql + 'Inner Join tb_procedimento p '
		Set @lSql = @lSql + 'On p_cid.co_procedimento =  p.co_procedimento'
	end

	Set @lSql = @lSql + ' Where  1 = 1 '

	if @codigo is not null
	    begin
		set @var = convert(varchar,@codigo)
		Exec ksp_ParametroPesquisa @var,'cid_10.cid_codigo',@tp_pesq,'T' ,@par output		
		set @lSql = @lSql + ' and ' + @par
	    end

	if @descricao is not null
	    begin
		set @var = convert(varchar,@descricao)
		Exec ksp_ParametroPesquisa @var,'cid_10.cid_descricao ',@tp_pesq,'T' ,@par output		
		set @lSql = @lSql + ' and ' + @par
	    end

	if @proc_codigo is not null
	    begin
		set @var = convert(varchar,@proc_codigo)
		Exec ksp_ParametroPesquisa @var,'p.co_procedimento',@tp_pesq,'T' ,@par output		
		set @lSql = @lSql + ' and ' + @par
	    end

	--declare @sexocid10 int = null
	--if @sexo = 'F'
	--begin
	--	set @sexocid10 = 3
	--end
	--else if @sexo = 'M' 
	--begin
	--	set @sexocid10 = 1
	--end
	
	--if @sexocid10 is not null
	--begin	
	--	set @lSql = @lSql + ' AND ((CID_10.cid_sexo = ' + cast(@sexocid10 as varchar(1)) + 'OR CID_10.cid_sexo = 5 or CID_10.cid_sexo is null) or ' + cast(@sexocid10 as varchar(1)) + ' is null)'
	--end 
	--print @lSql
	Execute (@lSql)

end



-- ALTERA TIPO DE AGRAVO ------------------------------------------------------------------------------------------------
if @opcao = 6
begin

	delete 	from cid_unidade where cid_unidade.co_cid = @codigo and cid_unidade.unid_codigo = @unid_codigo

	if (@@error <> 0) goto trataerro

	if @cid_notcomp <> '0'
		insert into cid_unidade (co_cid, unid_codigo, tp_agravo) values (@codigo,@unid_codigo,@cid_notcomp)

	if (@@error <> 0) goto trataerro

	select @codigo
end



-----------------------------------------------------------------------------------------------
if @opcao = 7
begin
		
		SELECT	RTRIM(LTRIM(c.cid_codigo)) as cid_codigo, RTRIM(LTRIM(c.cid_descricao)) as cid_descricao, RTRIM(LTRIM(c.cid_codigo)) + ' - ' + RTRIM(LTRIM(c.cid_descricao)) as CodigoDescricao
		FROM	cid_10 c
		WHERE	RTRIM(LTRIM(c.cid_codigo)) LIKE @textoCodigo
		OR	RTRIM(LTRIM(c.cid_descricao)) LIKE @textoDescricao
		ORDER BY RTRIM(LTRIM(c.cid_descricao))


end

--Selecionar CID_UNIDADE por unidade e CID para KLINIKOS WEB ---------------------------------
if @opcao = 8
begin
	SELECT		c.CO_CID as cid_codigo, 
				c.NO_CID as cid_descricao, 
				c.TP_AGRAVO as cid_notcomp, 
				cu.tp_agravo AS tp_agravo,
				cu.unid_codigo As unid_codigo
	FROM        dbo.TB_CID AS c LEFT OUTER JOIN
                      dbo.cid_unidade AS cu ON c.CO_CID = cu.co_cid
	WHERE     (cu.co_cid = @codigo) AND (cu.unid_codigo = @unid_codigo)
	

end	
--Selecionar CID_UNIDADE por codigo de cid para KLINIKOS WEB  --------------------------------
if @opcao = 9
begin
	SELECT		c.CO_CID as cid_codigo, 
				c.NO_CID as cid_descricao, 
				c.TP_AGRAVO as cid_notcomp
	FROM        dbo.TB_CID as c
	where CO_CID = @codigo
end

-- ALTERA TIPO DE AGRAVO para KLINIKOS WEB ----------------------------------------------------
if @opcao = 10
begin

	delete 	from cid_unidade where cid_unidade.co_cid = @codigo and cid_unidade.unid_codigo = @unid_codigo

	if (@@error <> 0) goto trataerro

 
	if @tp_agravo is not null and @tp_agravo <> '0' 
		insert into cid_unidade (co_cid, unid_codigo, tp_agravo) values (@codigo,@unid_codigo,@tp_agravo)

	if (@@error <> 0) goto trataerro

	select @codigo
end

-- Busca Por cid Bloqueado ----------------------------------------------------  
if @opcao = 11  
begin
	
	SELECT DISTINCT	RTRIM(LTRIM(c.cid_codigo)) as cid_codigo, RTRIM(LTRIM(c.cid_descricao)) as cid_descricao, RTRIM(LTRIM(c.cid_codigo)) + ' - ' + RTRIM(LTRIM(c.cid_descricao)) as CodigoDescricao, c.cid_notcomp
	FROM	cid_10_Bloqueado c
		JOIN TB_CID TCD On c.cid_codigo = tcd.CO_CID 
			AND ((TCD.TP_SEXO = @SEXO OR TCD.TP_SEXO = 'I' or TCD.TP_SEXO is null) or @SEXO is null)
		LEFT JOIN rl_procedimento_cid p_cid On p_cid.CO_CID = c.cid_codigo
		LEFT JOIN tb_procedimento p On p_cid.co_procedimento =  p.co_procedimento
	WHERE	RTRIM(LTRIM(c.cid_codigo)) LIKE @textoCodigo
		OR	RTRIM(LTRIM(c.cid_descricao)) LIKE @textoDescricao
		OR CHARINDEX(@proc_codigo,p.co_procedimento) > 0
	ORDER BY RTRIM(LTRIM(c.cid_descricao))

end

-- lista os cids válidos---------------------------------------------------------------------------------------
if @opcao = 12
begin  
	select tb_cid.CO_CID as cid_secundario into #REGRA46 from tb_cid where tb_cid.CO_CID between 'S00' AND 'T99'          
	union          
	select tb_cid.CO_CID as cid_secundario from tb_cid where tb_cid.CO_CID between 'V01' AND 'Y99'           
	union           
	select 'D66' as cid_secundario          
	union           
	select 'D67' as cid_secundario          
	union          
	select 'D680' as cid_secundario          
	union          
	select 'D681' as cid_secundario          
	union          
	select 'D684' as cid_secundario
	
	select cid_codigo,cid_descricao, cid_sexo, cid_subcat, cid_notcomp from cid_10 c inner join #REGRA46 on   c.cid_codigo =  #REGRA46.cid_secundario
	
	drop table   #REGRA46
end

-- lista os cids mais usados por profissional--------------------------------------------------------------------------------
IF @opcao = 13
BEGIN 
		declare @sexocid_10 int = null

		if @sexo = 'F'
		begin
			set @sexocid_10 = 3
		end
		else if @sexo = 'M' 
		begin
			set @sexocid_10 = 1
		end


		SELECT TOP 10 * FROM(	
			SELECT TOP 5  COUNT(CID_10.CID_CODIGO) AS QTD_CID_CODIGO 
			,ATEMD_CLI.CID_CODIGO
			,CID_10.CID_DESCRICAO
			, CID_10.CID_NOTCOMP
			FROM  ATENDIMENTO_AMBULATORIAL  ATAM
			left JOIN ATENDIMENTO_CLINICO ATEMD_CLI
			ON ATAM.ATENDAMB_CODIGO = ATEMD_CLI.ATENDAMB_CODIGO
			JOIN cid_10
			ON CID_10.CID_CODIGO = ATEMD_CLI.CID_CODIGO
			AND ((CID_10.cid_sexo = @sexocid_10 OR CID_10.cid_sexo = 5 or CID_10.cid_sexo is null) or @sexocid_10 is null)
			GROUP BY CID_10.CID_CODIGO, ATEMD_CLI.CID_CODIGO, CID_10.CID_DESCRICAO , CID_10.CID_NOTCOMP
			
			UNION

			SELECT TOP 10   COUNT(CID_10.CID_CODIGO) AS QTD_CID_CODIGO 
			, ATEMD_CLI.CID_CODIGO
			,CID_10.CID_DESCRICAO
			, CID_10.CID_NOTCOMP
			FROM  ATENDIMENTO_AMBULATORIAL  ATAM
			left JOIN ATENDIMENTO_CLINICO ATEMD_CLI
			ON ATAM.ATENDAMB_CODIGO = ATEMD_CLI.ATENDAMB_CODIGO
			AND ATAM.PROF_CODIGO = @PROF_CODIGO 
			JOIN cid_10
			ON CID_10.CID_CODIGO = ATEMD_CLI.CID_CODIGO
			AND ((CID_10.cid_sexo = @sexocid_10 OR CID_10.cid_sexo = 5 or CID_10.cid_sexo is null) or @sexocid_10 is null)
			GROUP BY CID_10.CID_CODIGO, ATEMD_CLI.CID_CODIGO, CID_10.CID_DESCRICAO , CID_10.CID_NOTCOMP) T

			ORDER bY QTD_CID_CODIGO DESC
END 

-- TRATAMENTO DE ERRO -------------------------------------------------------------------------

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
  itpm.ins_codigo,
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
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_ins_codigo else null end as diluente_ins_codigo,

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
	case when itpm.presc_codigo = @presc_codigo then itpm.ins_codigo_unidade else null end as ins_codigo_unidade,
	case when itpm.presc_codigo = @presc_codigo then itpm.GeraPedidoPaciente else null end as GeraPedidoPaciente,
	case when itpm.presc_codigo = @presc_codigo then itpm.diluente_gera_pedido_paciente else null end as diluente_gera_pedido_paciente

                      
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
	diluente_medicamento_id, diluente_ins_descricao, diluente_volume, diluente_volume_total, diluente_valor_velocidade, diluente_medida_velocidade, diluente_ins_codigo, diluente_gera_pedido_paciente,
	ins_descricao_resumida, IsPassivelDeDiluicao, viamed_descricao, ins_codigo_unidade, GeraPedidoPaciente
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
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_ins_codigo else null end as diluente_ins_codigo,

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
	   case when itpm.presc_codigo = @presc_codigo then itpm.ins_codigo_unidade else null end as ins_codigo_unidade,
	   case when itpm.presc_codigo = @presc_codigo then itpm.GeraPedidoPaciente else null end as GeraPedidoPaciente,
	   case when itpm.presc_codigo = @presc_codigo then itpm.diluente_gera_pedido_paciente else null end as diluente_gera_pedido_paciente
  from         
 prescricao p        
 inner join Item_Prescricao itpr on p.presc_codigo = itpr.presc_codigo        
  left join                                                         
   (select presc_codigo, itpresc_codigo, itpresc_frequencia, ins_codigo, ins_descricao,         
 itpresc_quantidade as presc_quantidade, itpresc_total as quantidade,        
 itpresc_duracao, itpresc_tpduracao, ins_unidade, medicamento_id, data_iniciar_em, IsItemPrescricaoSuspensa,
  diluente_medicamento_id, diluente_ins_descricao, diluente_volume, diluente_volume_total, diluente_valor_velocidade, diluente_medida_velocidade, diluente_ins_codigo, diluente_gera_pedido_paciente, 
  itpresc_total, ins_descricao_resumida  , IsPassivelDeDiluicao, viamed_codigo, viamed_descricao, ins_codigo_unidade, GeraPedidoPaciente
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
PRINT N'Altering [dbo].[ksp_laboratorio_parametro_relatorio]...';


GO
ALTER PROCEDURE [dbo].[ksp_laboratorio_parametro_relatorio]
@opcao INT, @pedexalab_codigo CHAR (12), @exames VARCHAR (5000)=null, @Unidade CHAR (4)=null, @Secao CHAR (4)=null, @Status VARCHAR (2)=null, @Sequencial INT=null
AS
SET NOCOUNT ON  
  
DECLARE @lSQL  VARCHAR(8000)  
  
  
-------------------------------------------------------------        
if (@opcao = 0)  
  
begin  
 SET @lSql = ' select P.unid_codigo,e.exalab_codigo,pr.relatorio_codigo, ex.exalab_consolida, ex.sec_codigo as secao, e.exasollab_Sequencial, e.exasollab_status as status from exame_solicitado_laboratorio e '  
 SET @lSql = @lSql + 'LEFT join parametro_relatorio_laboratorio pr on '  
 SET @lSql = @lSql + '(e.exalab_codigo=pr.exalab_codigo) inner join exame_laboratorio ex on '  
 SET @lSql = @lSql + '(ex.exalab_codigo=e.exalab_codigo) inner join pedido_exame_laboratorio p on '  
 SET @lSql = @lSql + '(e.pedexalab_codigo=p.pedexalab_codigo and p.unid_codigo = pr.unid_codigo) '  
 SET @lSql = @lSql + 'WHERE 1 = 1 '  
  
 IF @pedexalab_codigo IS NOT NULL  
  BEGIN  
   SET @lSql = @lSql + ' AND e.pedexalab_codigo = ''' + @pedexalab_codigo + ''''  
  END  
  
 IF @Unidade IS NOT NULL  
  BEGIN  
   SET @lSql = @lSql + ' AND P.unid_codigo = ''' + @Unidade + ''''  
  END  
  
 IF @Secao IS NOT NULL  
  BEGIN  
   SET @lSql = @lSql + ' AND ex.sec_codigo = ''' + @Secao + ''''  
  END  
  
 IF @Exames IS NOT NULL  
  BEGIN  
  
   SET @lSQL = @lSQL + ' AND RTRIM(E.exasollab_mneumonico) '+ dbo.FCN_FORMATA_IN(@Exames) + ''  
  -- SET @lSql = @lSql + ' AND (charindex(RTRIM(E.exasollab_mneumonico),''' + replace(@Exames,'''','') + ''', 1) = 1 )'  
  END  
  
   
 if @Status is not null  
 begin  
  SET @lSql = @lSql + ' AND e.exasollab_status =''' + @Status + ''''  
 end  
 else  
 begin  
  SET @lSql = @lSql + ' AND e.exasollab_status in (''LA'',''LI'',''LE'',''LD'')'  
 end  

 IF @Sequencial IS NOT NULL  
  BEGIN  
   SET @lSql = @lSql + ' AND e.exasollab_Sequencial = ''' + CONVERT(varchar,@Sequencial) + ''''  
  END  
  
  
 set @lSql = @lSql + ' order by pr.relatorio_codigo '  
 
 print(@lSql) 
 execute (@lSql)  
  
end  
  
set nocount off  
-------------------------------------------------------------     
if (@@ERROR <> 0)  
BEGIN  
          RAISERROR('ERRO !! - ksp_laboratorio_parametro_relatorio',1,1)  
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
PRINT N'Altering [dbo].[kSp_ListaAlerta]...';


GO
ALTER PROCEDURE [dbo].[kSp_ListaAlerta]
@opcao INT, @unid_codigo CHAR (4), @TipoSolicitacao INT=null, @CodigoSolicitacao CHAR (12)=null, @Disponivel CHAR (1)='S', @pedexarad_datahora DATETIME=null
AS
SET NOCOUNT ON

DECLARE @datahoje CHAR (10)
SET @datahoje = Convert (varchar, getdate (), 103)

declare @unid_codigo_int char(3)
set @unid_codigo_int = right(@unid_codigo,2) + '%'

-- ---------------------------------------------------------------------------------------------------------------
-- Chamado 19376  26/08/2010

DECLARE @DATAINIAUX datetime
DECLARE @DATAFIMAUX datetime

IF @pedexarad_datahora IS NULL
	BEGIN
		SET @pedexarad_datahora = convert(datetime, convert(varchar,getdate(),112))		
	END
	
SET @DATAINIAUX = @pedexarad_datahora
SET @DATAFIMAUX = Dateadd(Month,1, Convert(char(08),@DATAINIAUX, 126)+'01')

-- ---------------------------------------------------------------------------------------------------------------

----------------------------- CONSULTA ----------------------------------------------------------
if @opcao = 0 --Verifica o Alerta  (EXAMES)
begin
	/*Do alerta: VERMELHO (solicitaÃ§Ãµes marcadas como URGENTES) 
	AMARELO (solicitaÃ§Ãµes de INTENACAO). 
	A ordem Ã© 1Âº Urgencia/ 2Âº Origem (1Âº internaÃ§Ã£o, depois as demais) / 3Âº Data/Hora. */
if (@CodigoSolicitacao is null)
  begin
	select 	s.solped_Urgencia,
		case s.Oripac_Codigo
		when 4 then 'S' else 'N' end Internacao,
		s.solped_codigo,
		CONVERT(CHAR(10),S.solped_DataHora,103) Data_Solicitacao,
		CONVERT(CHAR(5),S.solped_DataHora,108)  Hora_Solicitacao,
		ori.Oripac_descricao Origem,
		s.solped_CodigoOrigem,
		case s.oripac_codigo
			when 0 then atendimento.Locatend_codigo
			when 3 then vwEmer.LocAtend_Codigo  
			when 4 then vwInte.LocAtend_Codigo  
			when 5 then vwPron.LocAtend_Codigo  
			when 20 then vwAten.LocAtend_Codigo  
			when 2 then S.Locatend_Codigo
		end LocAtend_Codigo ,
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Codigo  
			when 20 then ProfAten.Prof_Codigo  
			else s.prof_codigo
		end Prof_Codigo ,
		case s.oripac_codigo
			when 3 then vwEmer.set_descricao 
			when 4 then vwInte.set_descricao 
			when 5 then vwPron.set_descricao 
			when 20 then vwAten.set_descricao
			when 2 then vwCad.Set_Descricao 
		end set_descricao,  
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Nome  
			when 20 then ProfAten.Prof_Nome  
			when 2 then ProfCad.Prof_Nome  
			else 'NAO INFORMADO'
		end Prof_Nome
		, pac.pac_nome
		, pac.pac_codigo
	from 	vwSolicitacao_Pedido	S
		inner join paciente pac on	S.PAC_CODIGO = pac.PAC_CODIGO
		inner join origem_paciente ori on ori.Oripac_Codigo = s.Oripac_Codigo
		left join emergencia  on emergencia.emer_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 3
		left join internacao  on internacao.inter_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 4
		left join pronto_atendimento on pronto_atendimento.spa_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 5
		left join Atendimento_Ambulatorial on Atendimento_Ambulatorial.atendamb_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 20
		left join atendimento on atendimento.atend_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 0

		left join vwlocal_unidade vwEmer  on vwEmer.locatend_codigo  = emergencia.locatend_codigo 
		left join vwlocal_unidade vwInte  on vwInte.locatend_codigo  = internacao.locatend_codigo
		left join vwlocal_unidade vwPron  on vwPron.locatend_codigo  = pronto_atendimento.locatend_codigo
		left join vwlocal_unidade vwAten  on vwAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo
		left join vwlocal_unidade vwCad   on vwCad.locatend_codigo  = S.locatend_codigo

		left join Profissional ProfInte  on ProfInte.locatend_codigo  = internacao.locatend_codigo and ProfInte.Prof_Codigo  = internacao.Prof_Codigo
		left join Profissional ProfAten  on ProfAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo and ProfAten.Prof_Codigo  = Atendimento_Ambulatorial.Prof_Codigo
		left join Profissional ProfCad   on ProfCad.locatend_codigo  = S.locatend_codigo and ProfCad.Prof_Codigo  = S.Prof_Codigo
	,       unidade u  -- T=31422; C=8664; 12/06/2008

	WHERE 	s.solped_codigo like @unid_codigo_int
	and	s.solped_CodigoPedido is null
	and	s.solped_TipoSolicitacao in (isnull(@TipoSolicitacao,s.solped_TipoSolicitacao))
	and	s.solped_codigo = isnull(@CodigoSolicitacao,s.solped_codigo)
	and	s.solped_Disponivel = @Disponivel 
	and     u.unid_codigo = @unid_codigo    

	and     s.solped_DataHora >= @DATAINIAUX 	 
	AND     s.solped_DataHora < @DATAFIMAUX   	

	order by 
		s.solped_Urgencia desc, 	--S/N
		Internacao Desc, 		--S/N
		S.solped_DataHora 
   end 
     if(@CodigoSolicitacao is not null)
	 begin 
	   select 	s.solped_Urgencia,
		case s.Oripac_Codigo
		when 4 then 'S' else 'N' end Internacao,
		s.solped_codigo,
		CONVERT(CHAR(10),S.solped_DataHora,103) Data_Solicitacao,
		CONVERT(CHAR(5),S.solped_DataHora,108)  Hora_Solicitacao,
		ori.Oripac_descricao Origem,
		s.solped_CodigoOrigem,
		case s.oripac_codigo
			when 0 then atendimento.Locatend_codigo
			when 3 then vwEmer.LocAtend_Codigo  
			when 4 then vwInte.LocAtend_Codigo  
			when 5 then vwPron.LocAtend_Codigo  
			when 20 then vwAten.LocAtend_Codigo  
			when 2 then S.Locatend_Codigo
		end LocAtend_Codigo ,
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Codigo  
			when 20 then ProfAten.Prof_Codigo  
			else s.prof_codigo
		end Prof_Codigo ,
		case s.oripac_codigo
			when 3 then vwEmer.set_descricao 
			when 4 then vwInte.set_descricao 
			when 5 then vwPron.set_descricao 
			when 20 then vwAten.set_descricao
			when 2 then vwCad.Set_Descricao 
		end set_descricao,  
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Nome  
			when 20 then ProfAten.Prof_Nome  
			when 2 then ProfCad.Prof_Nome  
			else 'NAO INFORMADO'
		end Prof_Nome
		, pac.pac_nome
		, pac.pac_codigo
	from 	vwSolicitacao_Pedido	S
		inner join paciente pac on	S.PAC_CODIGO = pac.PAC_CODIGO
		inner join origem_paciente ori on ori.Oripac_Codigo = s.Oripac_Codigo
		left join emergencia  on emergencia.emer_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 3
		left join internacao  on internacao.inter_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 4
		left join pronto_atendimento on pronto_atendimento.spa_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 5
		left join Atendimento_Ambulatorial on Atendimento_Ambulatorial.atendamb_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 20
		left join atendimento on atendimento.atend_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 0

		left join vwlocal_unidade vwEmer  on vwEmer.locatend_codigo  = emergencia.locatend_codigo 
		left join vwlocal_unidade vwInte  on vwInte.locatend_codigo  = internacao.locatend_codigo
		left join vwlocal_unidade vwPron  on vwPron.locatend_codigo  = pronto_atendimento.locatend_codigo
		left join vwlocal_unidade vwAten  on vwAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo
		left join vwlocal_unidade vwCad   on vwCad.locatend_codigo  = S.locatend_codigo

		left join Profissional ProfInte  on ProfInte.locatend_codigo  = internacao.locatend_codigo and ProfInte.Prof_Codigo  = internacao.Prof_Codigo
		left join Profissional ProfAten  on ProfAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo and ProfAten.Prof_Codigo  = Atendimento_Ambulatorial.Prof_Codigo
		left join Profissional ProfCad   on ProfCad.locatend_codigo  = S.locatend_codigo and ProfCad.Prof_Codigo  = S.Prof_Codigo
	,       unidade u  -- T=31422; C=8664; 12/06/2008

	WHERE 	s.solped_codigo like @unid_codigo_int
	and	s.solped_CodigoPedido is null
	and	s.solped_TipoSolicitacao in (isnull(@TipoSolicitacao,s.solped_TipoSolicitacao))
	and	s.solped_codigo = isnull(@CodigoSolicitacao,s.solped_codigo)
	and	s.solped_Disponivel = @Disponivel 
	and     u.unid_codigo = @unid_codigo    

	--and     s.solped_DataHora >= @DATAINIAUX 	 
	--AND     s.solped_DataHora < @DATAFIMAUX   	

	order by 
		s.solped_Urgencia desc, 	--S/N
		Internacao Desc, 		--S/N
		S.solped_DataHora 
	 end 
end

------------------------------------------------------------------------------------------------

If @Opcao= 1 --Lista Exames da Radiologia
   BEGIN
	select 	spe.solpedexa_Codigo_Exame
	from solicitacao_pedido_exame spe
		INNER JOIN solicitacao_pedido sp on sp.ped_codigo = spe.ped_codigo
	where sp.solped_codigo = @CodigoSolicitacao
   END

---- CONSULTA PEDIDOS PENDENTES ORIUNDOS DO PEP E OUTRAS ORIGENS DIFERENTES DE AMBULATORIO ------

if @opcao = 2 
begin
	/*Do alerta: VERMELHO (solicitaÃ§Ãµes marcadas como URGENTES) 
	AMARELO (solicitaÃ§Ãµes de INTENACAO). 
	A ordem Ã© 1Âº Urgencia/ 2Âº Origem (1Âº internaÃ§Ã£o, depois as demais) / 3Âº Data/Hora. */

	select 	s.solped_Urgencia,
		case s.Oripac_Codigo
		when 4 then 'S' else 'N' end Internacao,
		s.solped_codigo,
		CONVERT(CHAR(10),S.solped_DataHora,103) Data_Solicitacao,
		CONVERT(CHAR(5),S.solped_DataHora,108)  Hora_Solicitacao,
		ori.Oripac_descricao Origem,
		s.solped_CodigoOrigem,
		case s.oripac_codigo
			when 0 then atendimento.Locatend_codigo
			when 3 then vwEmer.LocAtend_Codigo  
			when 4 then vwInte.LocAtend_Codigo  
			when 5 then vwPron.LocAtend_Codigo  
			when 20 then vwAten.LocAtend_Codigo  
			when 2 then S.Locatend_Codigo
		end LocAtend_Codigo ,
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Codigo  
			when 20 then ProfAten.Prof_Codigo  
			else s.prof_codigo
		end Prof_Codigo ,
		case s.oripac_codigo
			when 3 then vwEmer.set_descricao 
			when 4 then vwInte.set_descricao 
			when 5 then vwPron.set_descricao 
			when 20 then vwAten.set_descricao
			when 2 then vwCad.Set_Descricao 
		end set_descricao,  
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Nome  
			when 20 then ProfAten.Prof_Nome  
			when 2 then ProfCad.Prof_Nome  
			else 'NAO INFORMADO'
		end Prof_Nome
		, case when pac.pac_nome_social is null then pac.pac_nome 
               else rtrim(pac.pac_nome_social) +' ['+rtrim(pac.pac_nome)+']' end as pac_nome
			   , S.solped_Observacao EXARADESCR

	from 	vwSolicitacao_Pedido	S
		inner join paciente pac on	S.PAC_CODIGO = pac.PAC_CODIGO
		inner join origem_paciente ori on ori.Oripac_Codigo = s.Oripac_Codigo
		left join emergencia  on emergencia.emer_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 3
		left join internacao  on internacao.inter_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 4
		left join pronto_atendimento on pronto_atendimento.spa_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 5
		left join Atendimento_Ambulatorial on Atendimento_Ambulatorial.atendamb_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 20
		left join atendimento on atendimento.atend_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 0

		left join vwlocal_unidade vwEmer  on vwEmer.locatend_codigo  = emergencia.locatend_codigo 
		left join vwlocal_unidade vwInte  on vwInte.locatend_codigo  = internacao.locatend_codigo
		left join vwlocal_unidade vwPron  on vwPron.locatend_codigo  = pronto_atendimento.locatend_codigo
		left join vwlocal_unidade vwAten  on vwAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo
		left join vwlocal_unidade vwCad   on vwCad.locatend_codigo  = S.locatend_codigo

		left join Profissional ProfInte  on ProfInte.locatend_codigo  = internacao.locatend_codigo and ProfInte.Prof_Codigo  = internacao.Prof_Codigo
		left join Profissional ProfAten  on ProfAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo and ProfAten.Prof_Codigo  = Atendimento_Ambulatorial.Prof_Codigo
		left join Profissional ProfCad   on ProfCad.locatend_codigo  = S.locatend_codigo and ProfCad.Prof_Codigo  = S.Prof_Codigo
		,unidade u 

	WHERE 	s.solped_codigo like @unid_codigo_int
	and	s.solped_CodigoPedido is null
	and	s.solped_TipoSolicitacao IN (isnull(@TipoSolicitacao,s.solped_TipoSolicitacao))
	and	s.solped_codigo = isnull(@CodigoSolicitacao,s.solped_codigo)
	and 	s.Oripac_Codigo<>2
	and	s.solped_Disponivel = 'S'
	and     u.unid_codigo = @unid_codigo    
--	and	convert(char(10),s.solped_DataHora,111) between convert(char(10),dateadd(day, - isnull(u.unid_DiasRetroSolic,0), getdate()),111)  and convert(char(10),getdate(),111) -- T=31422; C=8664; 12/06/2008

	and     isnull(s.solped_DataPrevista, s.solped_DataHora) >= dateadd(day,-1,@DATAINIAUX)
	AND     isnull(s.solped_DataPrevista, s.solped_DataHora) < @DATAFIMAUX   	

	order by 
		s.solped_Urgencia desc, 	--S/N
		Internacao Desc, 		--S/N
		S.solped_DataHora 

end

---- CONSULTA PEDIDOS PENDENTES ORIUNDOS DO AMBULATORIO E CENTRAL MARCACAO ------
if @opcao = 3 
begin
	/*Do alerta: VERMELHO (solicitaÃ§Ãµes marcadas como URGENTES) 
	AMARELO (solicitaÃ§Ãµes de INTENACAO). 
	A ordem Ã© 1Âº Urgencia/ 2Âº Origem (1Âº internaÃ§Ã£o, depois as demais) / 3Âº Data/Hora. */

	select 	s.solped_Urgencia,
		case s.Oripac_Codigo
		when 4 then 'S' else 'N' end Internacao,
		s.solped_codigo,
		CONVERT(CHAR(10),S.solped_DataHora,103) Data_Solicitacao,
		CONVERT(CHAR(5),S.solped_DataHora,108)  Hora_Solicitacao,
		ori.Oripac_descricao Origem,
		s.solped_CodigoOrigem,
		case s.oripac_codigo
			when 0 then atendimento.Locatend_codigo
			when 3 then vwEmer.LocAtend_Codigo  
			when 4 then vwInte.LocAtend_Codigo  
			when 5 then vwPron.LocAtend_Codigo  
			when 20 then vwAten.LocAtend_Codigo  
			when 2 then S.Locatend_Codigo
		end LocAtend_Codigo ,
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Codigo  
			when 20 then ProfAten.Prof_Codigo  
			else s.prof_codigo
		end Prof_Codigo ,
		case s.oripac_codigo
			when 3 then vwEmer.set_descricao 
			when 4 then vwInte.set_descricao 
			when 5 then vwPron.set_descricao 
			when 20 then vwAten.set_descricao
			when 2 then vwCad.Set_Descricao 
		end set_descricao,  
		case s.oripac_codigo
			when 4 then ProfInte.Prof_Nome  
			when 20 then ProfAten.Prof_Nome  
			when 2 then ProfCad.Prof_Nome  
			else 'NAO INFORMADO'
		end Prof_Nome
		, case when pac.pac_nome_social is null then pac.pac_nome 
               else rtrim(pac.pac_nome_social) +' ['+rtrim(pac.pac_nome)+']' end as pac_nome

	from 	vwSolicitacao_Pedido	S
		inner join paciente pac on	S.PAC_CODIGO = pac.PAC_CODIGO
		inner join origem_paciente ori on ori.Oripac_Codigo = s.Oripac_Codigo
		left join emergencia  on emergencia.emer_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 3
		left join internacao  on internacao.inter_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 4
		left join pronto_atendimento on pronto_atendimento.spa_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 5
		left join Atendimento_Ambulatorial on Atendimento_Ambulatorial.atendamb_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 20
		left join atendimento on atendimento.atend_codigo = s.solped_CodigoOrigem  and s.oripac_codigo = 0

		left join vwlocal_unidade vwEmer  on vwEmer.locatend_codigo  = emergencia.locatend_codigo 
		left join vwlocal_unidade vwInte  on vwInte.locatend_codigo  = internacao.locatend_codigo
		left join vwlocal_unidade vwPron  on vwPron.locatend_codigo  = pronto_atendimento.locatend_codigo
		left join vwlocal_unidade vwAten  on vwAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo
		left join vwlocal_unidade vwCad   on vwCad.locatend_codigo  = S.locatend_codigo

		left join Profissional ProfInte  on ProfInte.locatend_codigo  = internacao.locatend_codigo and ProfInte.Prof_Codigo  = internacao.Prof_Codigo
		left join Profissional ProfAten  on ProfAten.locatend_codigo  = Atendimento_Ambulatorial.locatend_codigo and ProfAten.Prof_Codigo  = Atendimento_Ambulatorial.Prof_Codigo
		left join Profissional ProfCad   on ProfCad.locatend_codigo  = S.locatend_codigo and ProfCad.Prof_Codigo  = S.Prof_Codigo
	,       unidade u 

	WHERE 	s.solped_codigo like @unid_codigo_int
	and	s.solped_CodigoPedido is null
	and	s.solped_TipoSolicitacao in (@TipoSolicitacao)
	and	s.solped_codigo = isnull(@CodigoSolicitacao,s.solped_codigo)
	and	s.Oripac_Codigo=2
	and	s.solped_Disponivel = 'S'
	and u.unid_codigo = @unid_codigo 
	and isnull(s.solped_DataPrevista,s.solped_DataHora) >= @DATAINIAUX 	 
	and isnull(s.solped_DataPrevista,s.solped_DataHora) < @DATAFIMAUX   	

	order by 
		s.solped_Urgencia desc, 	--S/N
		Internacao Desc, 		--S/N
		S.solped_DataHora 

end

--------------------------------------------------------------------------------------------------------------------

if (@@ERROR <> 0)
      	BEGIN
         	RAISERROR('ERRO - AlertaLaboratorio.',1,1)
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
PRINT N'Altering [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA]...';


GO
ALTER PROCEDURE [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA] @inter_codigo char(12) = null, @evouti_codigo int = null
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
inner join vwleito l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
inner join paciente p on p.pac_codigo = i.pac_codigo 
inner join Profissional prof on prof.prof_codigo = eud.prof_codigo and prof.locatend_codigo = eud.locatend_codigo
where eud.evouti_codigo = isnull(@evouti_codigo, eud.evouti_codigo)
and   eud.inter_codigo = isnull(@inter_codigo, eud.inter_codigo)

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
PRINT N'Altering [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_Noturno]...';


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
inner join vwleito l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
inner join paciente p on p.pac_codigo = i.pac_codigo 
inner join Profissional prof on prof.prof_codigo = eun.prof_codigo and prof.locatend_codigo = eun.locatend_codigo
where eun.evouti_codigo = isnull(@evouti_codigo, eun.evouti_codigo)
and   eun.inter_codigo = isnull(@inter_codigo, eun.inter_codigo)

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
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
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
GO
ALTER PROCEDURE [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA] @inter_codigo char(12) = null, @evouti_codigo int = null
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
ALTER PROCEDURE [dbo].[ksp_Internacao]
@Opcao INT, @Inter_Codigo CHAR (12), @PedInt_Sequencial CHAR (12), @Pac_Codigo CHAR (12), @Inter_DtPrevista SMALLDATETIME, @LocAtend_Leito CHAR (4), @Lei_Codigo CHAR (4), @Inter_DataInter SMALLDATETIME, @EstPac_Codigo CHAR (4), @EstPac_Codigo_Alta CHAR (4), @Inter_DtAlta SMALLDATETIME, @LocAtend_Codigo CHAR (4), @Prof_Codigo CHAR (4), @Inter_Motivo_Alta CHAR (2), @LocAtend_Codigo_Resp CHAR (4), @Prof_Codigo_Resp CHAR (4), @Emer_Codigo CHAR (12), @LocAtend_Codigo_Atual CHAR (4), @EstPac_Codigo_Atual CHAR (4), @Usu_Codigo CHAR (4), @Proc_Codigo CHAR (10), @Cid_Codigo CHAR (9), @Cid_Codigo_Secundario CHAR (9), @CarInt_Codigo CHAR (2), @Set_Codigo CHAR (4), @Pac_Nome VARCHAR (50), @DataAtualClinica SMALLDATETIME, @DataCid SMALLDATETIME, @DataCid2 SMALLDATETIME, @LOGIN_USUARIO VARCHAR (50)=null, @Unid_Codigo CHAR (4)=null, @Hipotese VARCHAR (3000)=null, @Spa_Codigo CHAR (12)=null, @oripac_codigo SMALLINT=null, @inter_DeObservacao CHAR (1)='N', @lei_tipo CHAR (1)=null, @BoletimExtraviado CHAR (1)='N', @pac_prontuario CHAR (10)=null, @Sexo CHAR (12)=null, @Locatend_Codigo_Inicial CHAR (4)=null, @Modalidade INT=null, @Inter_Motivo_Alta_Descricao VARCHAR (3000)=null, @leitoRegulado CHAR (1)=null, @numAutorizacao CHAR (15)=NULL, @pstCodigo CHAR (4)=NULL, @enfCodigo CHAR (4)=NULL, @unidref_codigo_destino CHAR (4)=NULL, @PossuiPendencia INT=null, @principais_sinais_sintomas VARCHAR (500)=NULL, @condicoes_internacao VARCHAR (500)=NULL, @AtendAmb_Codigo CHAR (12)=NULL,
@PacNomeProntuario varchar(100) = null
AS
SET NOCOUNT ON                                    
DECLARE @unid_codigo_int char(3)                            
SET  @unid_codigo_int = right(@unid_codigo,2) + '%'                            
                            
                            
--Tratar erro a cada transatpo                            
DECLARE @Erro int                            
SET  @Erro = 0                            
                            
                            
--Trata erro especÃ­fico de concorrÃªncia de leito na inclusÃ£o da internaÃ§Ã£o. 07/12/2007 T=17295;C=8642                            
DECLARE @ErroConcorrenciaLeito int                            
SET @ErroConcorrenciaLeito = 0                            
                            
/*                        
 Log Diferenciado:                            
  Nas OpÃ§Ãµes de Incluspo e Exclusao: Apenas grava a OperaÃ§Ã£o                            
  Na  OpÃ§Ãµes de Alteracao: Gravar os campos Alterados e o Estorno                            
                            
*/                            
                            
DECLARE @UltCodigo  Char(12)                            
DECLARE @Data  Char(8)                            
DECLARE @Tipo_Alta  char(1)                            
DECLARE @sql   varchar(max)                            
DECLARE @par   varchar(255)                            
DECLARE @var1   varchar(255)                            
DECLARE @tp_pesq smallint                            
DECLARE @datahoje CHAR (10)                            
                            
SET @datahoje = Convert (varchar, getdate (), 103)                            
                            
IF @UNID_CODIGO IS NULL                            
 SELECT  @unid_codigo = unid_codigo FROM local_atendimento WHERE locatend_codigo = @LocAtend_Codigo                            
                            
IF @LOGIN_USUARIO IS NULL                            
 SELECT @LOGIN_USUARIO = USU_LOGIN                            
 FROM USUARIO                            
 WHERE USU_CODIGO = @USU_CODIGO                            
----------------------------- Selecao para Carga dos Dados ------------------------------------                            
If @Opcao = 0                            
 Begin                            
  set @sql =   ' SELECT I.inter_codigo,' -- 0                            
  set @sql = @sql + ' I.inter_datainter,' -- 1                            
  set @sql = @sql + ' I.inter_dtalta,' -- 2                            
  set @sql = @sql + ' I.inter_dtprevista,' -- 3                            
  set @sql = @sql + ' I.inter_motivo_alta,' -- 4                            
  set @sql = @sql + ' ISNULL(MC.motcobunid_descricao,MC_AIH.motcob_descricao) AS MotCob_Descricao,' -- 5                            
  set @sql = @sql + ' I.inter_tipo,' -- 6                            
  set @sql = @sql + ' I.pedint_sequencial,' -- 7                            
  set @sql = @sql + ' I.lei_codigo,' -- 8                            
  set @sql = @sql + ' I.locatend_codigo,' -- 9                            
  set @sql = @sql + ' S.SetCli_Descricao Descricao_LocAtend_Codigo,' -- 10                            
  set @sql = @sql + ' I.locatend_codigo_atual,' -- 11                            
  set @sql = @sql + ' S2.SetCli_Descricao Descricao_LocAtend_Codigo_Atual,' -- 12                            
  set @sql = @sql + ' I.locatend_leito,' -- 13                            
  set @sql = @sql + ' S3.SetCli_Descricao Descricao_LocAtend_Leito,' -- 14                         
  set @sql = @sql + ' I.pac_codigo,' -- 15                            
  set @sql = @sql + ' P.Pac_Nome, ' -- 16                            
  set @sql = @sql + ' PP.Pac_Prontuario_Numero Pac_Prontuario,' -- 17                            
  set @sql = @sql + ' P.Pac_Sexo,' -- 18                            
  set @sql = @sql + ' I.prof_codigo,' -- 19                            
  set @sql = @sql + ' Prof.Prof_Nome,' -- 20                            
  set @sql = @sql + ' I.emer_codigo,' -- 21                            
  set @sql = @sql + ' I.estpac_codigo,' -- 22                           
  set @sql = @sql + ' EP.EstPac_Descricao,' -- 23                            
  set @sql = @sql + ' I.estpac_codigo_atual,' -- 24                            
  set @sql = @sql + ' EP2.EstPac_Descricao EstPac_Descricao_Atual,' -- 25                            
  set @sql = @sql + ' Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + '' '' + E3.enf_codigo_local + ''/'' + L.lei_codigo Clinica_Paciente,' --26                            
  set @sql = @sql + ' I.Inter_Data_Cid,' -- 27                            
  set @sql = @sql + ' I.Inter_Data_Cid_Secundario,' -- 28                          
  set @sql = @sql + ' PID.INTER_PID_CODIGO,' -- 29                            
   set @sql = @sql + ' L.Lei_Tipo,' -- 30                               
  set @sql = @sql + ' I.Inter_hipdiag,' --31                             
  set @sql = @sql + ' I.spa_codigo,' --32                             
  set @sql = @sql + ' BE.emer_numero_be,' --32                            
  set @sql = @sql + ' PA.spa_numero_pa,' --32                            
  set @sql = @sql + ' I.inter_DeObservacao, '                            
  set @sql = @sql + ' I.prof_codigo_Resp, '                            
  set @sql = @sql + ' ProfResp.Prof_Nome Prof_Nome_Resp, ' -- 20                            
  set @sql = @sql + ' I.locatend_codigo_resp, ' -- 21 NÃ£o trazia a clinica responsÃ¡vel pela alta! Boris em 09/02/2009                              
  set @sql = @sql + ' R.resvis_descricao, '                            
  set @sql = @sql + ' I.Locatend_Codigo_Inicial, '                              
  set @sql = @sql + ' i.inter_motivo_alta_descricao,  '                            
  set @sql = @sql + ' PI.leitoRegulado,  '
  set @sql = @sql + ' PI.numAutorizacao, '
  set @sql = @sql + ' E3.pst_codigo, '
  set @sql = @sql + ' E3.enf_codigo, ' 
  set @sql = @sql + ' I.unidref_codigo_destino '                         
                            
  set @sql = @sql +' FROM  Internacao I'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_Unidade MC'                            
  set @sql = @sql +' ON   (MC.MotCob_Codigo=I.Inter_Motivo_Alta)and (MC.unid_codigo = ''' + @Unid_Codigo + ''')'
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_AIH MC_AIH'                            
  set @sql = @sql +' ON   (MC_AIH.MotCob_Codigo=I.Inter_Motivo_Alta)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA'                            
  set @sql = @sql +' ON   (LA.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN  Setor_Clinica S'                             
  set @sql = @sql +' ON   (S.SetCli_Codigo=LA.SetCli_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA2'                            
  set @sql = @sql +' ON   (LA2.LocAtend_Codigo=I.LocAtend_Codigo_Atual)'                            
                            
  set @sql = @sql +' INNER JOIN Setor_Clinica S2'                            
  set @sql = @sql +' ON  (S2.SetCli_Codigo=LA2.SetCli_Codigo)'                
                            
  set @sql = @sql +' LEFT JOIN Local_Atendimento LA3'                            
  set @sql = @sql +' ON  (LA3.LocAtend_Codigo=I.LocAtend_Leito)'                            
                            
  set @sql = @sql +' LEFT JOIN Enfermaria E3'                            
  set @sql = @sql +' ON  (E3.enf_Codigo=LA3.enf_codigo)'                            
                            
 set @sql = @sql +' LEFT JOIN Setor_Clinica S3'                            
  set @sql = @sql +' ON   (S3.SetCli_Codigo=LA3.SetCli_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Setor_Clinica SL'          
  set @sql = @sql +' ON (SL.SetCli_Codigo= La3.SetCli_Codigo)'                            
                            
  set @sql = @sql +'INNER JOIN Paciente P'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=I.Pac_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Paciente_Prontuario PP'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''')'                              
                            
  set @sql = @sql +' INNER JOIN Profissional Prof'                            
  set @sql = @sql +' ON  (Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Profissional_Rede ProfResp'                
  set @sql = @sql +' ON  (ProfResp.Prof_Codigo=I.prof_codigo_Resp)'                            
                              
  set @sql = @sql +' INNER JOIN Estado_Paciente EP'                            
  set @sql = @sql +' ON  (EP.EstPac_Codigo=I.EstPac_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Estado_Paciente EP2'                            
  set @sql = @sql +' ON  (EP2.EstPac_Codigo=I.EstPac_Codigo_Atual)'                            
                            
  set @sql = @sql +' LEFT JOIN Leito L'                            
  set @sql = @sql +' ON   (I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Internacao_Pid PID'                            
  set @sql = @sql +' ON  (PID.Inter_Codigo = I.Inter_Codigo)'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_BE BE'                            
  set @sql = @sql + ' ON  I.emer_codigo = BE.emer_codigo'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_PA PA'                            
  set @sql = @sql + ' ON  I.spa_codigo = PA.spa_codigo'                            
                            
  set @sql = @sql + ' LEFT JOIN Restricao_Visita R'                            
  set @sql = @sql + ' ON  I.inter_codigo = R.inter_codigo'                            
  
  set @sql = @sql + ' LEFT JOIN Pedido_Internacao PI'                            
  set @sql = @sql + ' ON  PI.PedInt_Sequencial = I.PedInt_Sequencial'                                                      
                            
  set @sql = @sql +' WHERE 1=1'                            
              
                            
  if @inter_codigo is not null                            
   set @sql = @sql + ' and I.Inter_Codigo  = ''' + @Inter_Codigo   + ''''
                              
  if @spa_codigo is not null                                 
  begin              
    if len(@SPA_CODIGO) < 12                      
        select  @SPA_CODIGO  = spa_codigo from numero_pa where spa_numero_pa = @SPA_CODIGO               
   set @sql = @sql + ' and I.spa_codigo  = ''' + @Spa_Codigo   + ''''
  end              
                            
  if @emer_codigo is not null                   
  begin                       
    if len(@emer_codigo) < 12                      
        select @emer_codigo = emer_codigo from numero_be where emer_numero_be = @emer_codigo                         
     set @sql = @sql + ' and I.emer_codigo  = ''' + @Emer_Codigo   + ''''
  end              
                              
  if @pedint_sequencial is not null                            
   set @sql = @sql + ' and I.PedInt_Sequencial = ''' + @PedInt_Sequencial  + ''''
                              
  if @Pac_Codigo is not null                            
   set @sql = @sql + ' and I.Pac_Codigo  = ''' + @Pac_Codigo   + ''''
                            
  set @sql = @sql  + ' and LA.UNID_CODIGO  = ''' + @Unid_Codigo   + ''''
                             
  --set @sql = left(@sql, len (@sql)-5)                            

  --set @sql = @sql + ' ORDER BY PID.Inter_Pid_codigo, I.Inter_DataInter DESC'                            
  set @sql = @sql + ' ORDER BY I.inter_codigo desc, I.Inter_DataInter DESC'
                              
  exec (@sql) 
                            
 End         
                            
                            
                            
-- INCLUIR INTERNAÃÃO ---------------------------------------------------------------------------------------------------                            
if @opcao = 1                            
begin                            
              
if @emer_codigo is not null              
begin              
    if len(@emer_codigo) < 12                      
        select @emer_codigo = emer_codigo from numero_be where emer_numero_be = @emer_codigo                         
end              
if @spa_codigo is not null              
begin              
    if len(@SPA_CODIGO) < 12                      
        select  @SPA_CODIGO  = spa_codigo from numero_pa where spa_numero_pa = @SPA_CODIGO               
end              
              
 -------------------------------------------------------------------------------                            
 -- Verifica se o leito estÃ¡ disponÃ­vel para internaÃ§Ã£o...       --                             
 -------------------------------------------------------------------------------                            
  
 if EXISTS(    
 SELECT 1  
 FROM MOVIMENTACAO_PACIENTE M  
 WHERE M.LOCATEND_CODIGO = @LOCATEND_LEITO  
   AND M.LEI_CODIGO = @LEI_CODIGO  
   AND M.MOVPAC_DATA <= ISNULL(@Inter_DtAlta, GETDATE())  
   AND  @Inter_DataInter <= ISNULL(M.MOVPAC_DATA_SAIDA, GETDATE())   
  )    
 BEGIN                             
  
  DECLARE @ERRORMESSAGE VARCHAR(1000)                           
    
  SET @INTER_CODIGO = (SELECT INTER_CODIGO FROM INTERNACAO                
  WHERE LOCATEND_LEITO = @LOCATEND_LEITO                
  AND LEI_CODIGO = @LEI_CODIGO                
  AND INTER_DTALTA IS NULL)                
                 
   IF @INTER_CODIGO IS NOT NULL                
   BEGIN                
  
    SET @ErrorMessage =  'Existe outro paciente internado no leito ' + @Lei_Codigo + ' com a internaÃ§Ã£o de nÃºmero ' + @inter_codigo                
    RAISERROR(@ERRORMESSAGE  ,1,1)                 
    RETURN                           
   END       
  
 end  
  
 update leito_historico  
 set lei_status = 'O'  
 where locatend_codigo = @locatend_leito  
   and lei_codigo = @lei_codigo  
   and data >= convert(smalldatetime, convert(char(10), @Inter_DataInter, 103), 103)  
   and data > convert(smalldatetime, convert(char(10), ISNULL(@Inter_DtAlta, GETDATE()), 103), 103)  
  
  
                
   -------------------------------------------------------------------------------                            
   -- Se necessÃ¡rio, inclui o pedido de internaÃ§Ã£o antes da internaÃ§Ã£o      --                             
   -------------------------------------------------------------------------------         
                               
   IF @PedInt_Sequencial is Null                            
   Begin                            
                               
    create table #tmp (codigo char(12))                       
                               
    insert into #tmp                            
    Execute kSp_pedido_internacao 1,                            
     null,                            
     null,                            
     @CarInt_Codigo,                            
     @cid_codigo,                            
     @Pac_Codigo, @Proc_Codigo, @Prof_Codigo,                            
     @LocAtend_Codigo,                            
     @Cid_Codigo_Secundario, @Inter_DataInter,                             
     null, null, @unid_codigo                            
                               
           set @Erro = @Erro + @@error                            
                               
    SET @datahoje = Convert (varchar, @Inter_DataInter, 103)                            
                               
    select @PedInt_Sequencial = codigo                            
    from #tmp                            
                             
 --select @PedInt_Sequencial   
                               
   End                            
                               
   Else                             
   Begin                            
                                
    update pedido_internacao                             
    set  cid_codigo = @cid_codigo,                            
     cid_secundario = @Cid_Codigo_Secundario,                            
     Proc_Codigo    = @Proc_Codigo,
	 leitoRegulado	= @leitoRegulado, 
	 numAutorizacao	= @numAutorizacao
    where PedInt_Sequencial  = @PedInt_Sequencial                            
                               
           set @Erro = @Erro + @@error                            
                               
   End                                                       
   -------------------------------------------------------------------------------                            
   -------------------------------------------------------------------------------                            
                              
                              
   -- Busca o CÃ³digo                    
   EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,                             
           @Chave      = 'internacao' ,                             
           @data       = @datahoje,                             
           @NovoCodigo = @Inter_Codigo OUTPUT                            
                              
   -- Atualiza Tabela de Internacao                            
   INSERT INTO  INTERNACAO ( inter_codigo,                             
                     pedint_sequencial,                             
                     pac_codigo,                            
                     inter_dtprevista,                             
                        locatend_leito,                             
                        lei_codigo,                             
                        inter_datainter,                      
                        estpac_codigo,                             
                        inter_dtalta,                             
                        locatend_codigo,                            
                        prof_codigo,                             
                        inter_motivo_alta,                             
         locatend_codigo_resp,                             
                        prof_codigo_resp,                            
       locatend_codigo_atual,                            
       estpac_codigo_atual,                            
       inter_data_cid,                            
       inter_data_cid_secundario,                            
       inter_hipdiag,                            
                     inter_deobservacao ,                            
       emer_codigo,                             
       spa_codigo,                          
  Locatend_Codigo_Inicial,   
       inter_motivo_alta_descricao ,
	   unidref_codigo_destino,
	   principais_sinais_sintomas,
        condicoes_internacao )                          
                              
   SELECT  @Inter_Codigo,                             
                        @PedInt_Sequencial,                             
                        @Pac_Codigo,                             
                        @Inter_DtPrevista,                           
                        @LocAtend_Leito,                             
                        @Lei_Codigo,                             
                        @Inter_DataInter,                             
                        @EstPac_Codigo,                             
                        @Inter_DtAlta,                             
                        @LocAtend_Codigo,                             
                        @Prof_Codigo,                            
                        @Inter_Motivo_Alta,                             
                        @LocAtend_Codigo_Resp,                             
                        @Prof_Codigo_Resp,                             
                 @LocAtend_Codigo_atual,                            
              @EstPac_Codigo_Atual,                            
           @DataCid,                            
           @DataCid2,                           @Hipotese,                            
       @inter_DeObservacao,                             
       @emer_codigo,                             
       @spa_codigo,                          
       @Locatend_Codigo_Inicial,  
       @Inter_Motivo_Alta_Descricao,                          
       @unidref_codigo_destino,
	   @principais_sinais_sintomas,
       @condicoes_internacao                       
                              
   set @Erro = @Erro + @@error                            
                              
   -----------------------------------------------------------------------------------------------------------------                            
   -- ALTERAR STATUS E LEITO, SE DIFERENTE DO RESERVO, DA RESERVA DE LEITO CASO EXITE PARA O PEDIDO DE INTERNAÃ?Ã?O --                             
   -----------------------------------------------------------------------------------------------------------------                            
   update  reserva_leito                            
   set reslei_status  = 3,                            
    locatend_codigo = @locatend_leito,                            
    lei_codigo  = @lei_codigo                            
   where pedint_sequencial = @pedint_sequencial                            
                              
   set @erro = @erro + @@error                            
   -----------------------------------------------------------------------------------------------------------------                            
   -----------------------------------------------------------------------------------------------------------------                            
                              
                              
   -- OS: 634 LOG DIFERENCIADO:                            
   DECLARE  @dtint char(35)                             
   set @dtint = 'Inclusao da Internacao em ' + convert(char(11), @Inter_DataInter,103) + convert(char(8), @Inter_DataInter,108)                            
                              
                              
   exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'INTERNACAO', '0' /* inclusao */, null, null, @dtint, @unid_codigo                            
      set @Erro = @Erro + @@error                            
                              
                              
    Execute ksp_Internacao_clinica_atual                             
     1,                             
     @Inter_Codigo,                             
     @LocAtend_Codigo_atual,                            
  @Inter_DataInter,                             
     @Inter_DtAlta, @LOGIN_USUARIO                            
                              
      set @Erro = @Erro + @@error                            
                              
                              
  /*                 
  SAMIR.18/11/2003                            
   Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                            
   a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                            
   os leitos                            
  */                            
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
                              
  -- SAMIR.18/11/2003.FIM                            
                              
    Execute kSp_Movimentacao_Paciente 1,                            
     Null,                            
     @LocAtend_Leito,                            
     @Inter_Codigo,                            
     @EstPac_Codigo,                             
     @Usu_Codigo,                            
     @Lei_Codigo,                            
     'I',                            
     Null,Null,Null,Null,Null,@Inter_DataInter, null, @unid_codigo                            
    
set @Erro = @Erro + @@error                                
    
 IF NOT EXISTS (SELECT 1 FROM MOVIMENTACAO_PACIENTE                            
     WHERE INTER_CODIGO = @INTER_CODIGO)                            
    BEGIN                            
                                  
  RAISERROR('Erro na inclusÃ£o da MovimentaÃ§Ã£o do Paciente.',1,1)                            
  return    
                              
    END                            
                              
  set @Erro = @Erro + @@error                            
  -- SAMIR 25/07/2002                            
                              
   /* EM CASO DE +BITO, GRAVA-O */                            
                              
    select @tipo_Alta = motcob_tipo from motivo_cobranca_aih where motcob_codigo = @Inter_Motivo_Alta                            
                              
    IF @Tipo_Alta = 'O'                            
        BEGIN                            
      Execute ksp_Obito_Paciente                            
      @Pac_Codigo,                            
      @Inter_DtAlta                            
  set @Erro = @Erro + @@error                            
     END                             
                              
                              
    INSERT INTO evolucao (inter_codigo,evo_data,prof_codigo,locatend_codigo,estpac_codigo,evo_evolucao,locatend_codigo_atual)                             
       VALUES              (@Inter_Codigo,@Inter_DataInter,@Prof_Codigo,@LocAtend_Codigo,@EstPac_Codigo_Atual,'INTERNACAO',@LocAtend_Codigo_ATUAL)                     
  set @Erro = @Erro + @@error                            
                              
   /* ALTERA AS DATAS POSTERIORES EXISTENTES, MARCANDO PARA REPROCESSAR O CENSO */                            
    UPDATE Status_Censo                            
    SET stcen_Status = 'R'                            
    WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DataInter,103),103)                            
  set @Erro = @Erro + @@error                            
                              
   /* WEB 04/04/2003  GRAVAR NOTIFICACAO COMPULASORIA*/                            
    DECLARE @CID_NOT CHAR(1)                            
                              
    SELECT @CID_NOT = C.cid_notcomp FROM CID_10 C                            
    WHERE CID_CODIGO = @CID_CODIGO                            
                              
    if @CID_NOT = 'S'                             
    BEGIN                            
     DECLARE @COD_NOTIF CHAR(10)                            
     SELECT @COD_NOTIF = ISNULL(MAX(NOTCOMP_NUMERO), 0) FROM NOTIFICACAO_COMPULSORIA                         SET @COD_NOTIF = RIGHT('0000000000' + RTRIM(CONVERT(INT, @COD_NOTIF) + 1),10)                            
                              
     DECLARE @ENDERECO VARCHAR(200)                            
     DECLARE @BAI_CODIGO CHAR(7)                            
     DECLARE @MUN_CODIGO CHAR(7)                            
                              
     SELECT  @ENDERECO = CEP.CEP_LOGRADOURO + ' - ' + ISNULL(P.pac_endereco_num,'') + ' - ' + ISNULL(p.pac_endereco_compl,''),                            
      @BAI_CODIGO = CEP.MUN_CODIGO,                            
      @MUN_CODIGO = CEP.BAI_CODIGO                            
     FROM PACIENTE P, CEP                             
     WHERE  P.CEP_SEQUENCIAL = CEP.CEP_SEQUENCIAL                            
     AND P.PAC_CODIGO = @PAC_CODIGO                            
                                 
                              
     INSERT INTO NOTIFICACAO_COMPULSORIA                            
     (notcomp_numero, pac_codigo, notcomp_data, cid_codigo, pac_endereco, bai_codigo, mun_codigo, locatend_codigo)                            
     VALUES                            
     (@COD_NOTIF ,@pac_codigo, @datacid, @cid_codigo, @ENDERECO, @BAI_CODIGO, @MUN_CODIGO, @LOCATEND_CODIGO)                            
  set @Erro = @Erro + @@error                            
                              
                              
    END                            
    
 If (@Erro <> 0)                            
            RAISERROR('ERRO - Tabela de Internação.',1,1)                            
 else    
     SELECT @Inter_Codigo as Codigo, @ErroConcorrenciaLeito as ConcorrenciaLeito  
                              
      
  
END                                    
      
                           
        
                             
------------------------------------ Alteracao dos Dados ---------------------------------------                              
If @Opcao = 2                                
Begin                                
 DECLARE @alta      smalldatetime                                
    DECLARE @dt_inter_original    smalldatetime              
    DECLARE @LocAtend_Codigo_Atual_original  char(04)                                
    DECLARE @Inter_Tipo_Alta_original   char(2)                                
    DECLARE @proc_codigo_original   char(10)                                
    DECLARE @cid_codigo_original   char(9)                                
 declare @Leito_original char(4)                                
 declare @LocAtend_Leito_original char(4)                                
                               
    
                
                                
 /*Consulta dados antes de gravar para comparar alterat)es*/                                
    Select                                
		@alta     = i.inter_dtalta,                            
		@dt_inter_original  = i.inter_datainter,                                
		@LocAtend_Codigo_Atual_original = i.locatend_codigo_atual,                                
		@Inter_Tipo_Alta_original = m.motcob_tipo,                                
		@proc_codigo_original  = p.proc_codigo,                                
		@cid_codigo_original  = p.cid_codigo,                  
		@PedInt_Sequencial  = p.pedint_sequencial,        
		@Leito_original = i.lei_codigo,        
		@LocAtend_Leito_original = i.locatend_leito,        
		@INTER_CODIGO =  inter_codigo                       
    From  internacao  i                                
		LEFT JOIN motivo_cobranca_aih  m ON m.motcob_codigo = i.inter_motivo_alta 
		LEFT JOIN pedido_internacao  p ON p.pedint_sequencial = i.pedint_sequencial 
                                
    Where  i.inter_codigo = @Inter_Codigo 
                                
   -- Data de Alta                                
    If (@alta is not null) and (@Inter_DtAlta is not null) and ( @alta <>  @Inter_DtAlta)                                
    Begin                                
     DECLARE  @dt1 char(19)                                
      DECLARE  @dt2 char(19)                                
                                   
      set @dt1 = convert(char(11), @alta,103) + convert(char(8), @alta,108)                                
      set @dt2 = convert(char(11), @Inter_DtAlta,103) + convert(char(8), @Inter_DtAlta,108)                                
                                   
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DT. DE SAIDA', '1' /* alteracao */,@dt1 ,@dt2 , 'Alteracao de Data de Saida', @unid_codigo                                
      set @Erro = @Erro + @@error                                             
 End                                
                                
  -- Data  de Internatpo                                
    If ( @dt_inter_original <>  @Inter_DataInter)                                
    Begin                                
      DECLARE  @dti1 char(19)                                
      DECLARE  @dti2 char(19)                                
                                   
      set @dti1 = convert(char(11), @dt_inter_original,103) + convert(char(8), @dt_inter_original,108)                                
      set @dti2 = convert(char(11), @Inter_DataInter,103) + convert(char(8), @Inter_DataInter,108)                                
                                
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DT. DE INTERNACAO', '1' /* alteracao */, @dti1, @dti2, 'Alteracao de Data de Internatpo', @unid_codigo                                
      set @Erro = @Erro + @@error                                              
    End                                
                                
  -- ClÃ­nica                                
    If ( @LocAtend_Codigo_Atual_original <>  @LocAtend_Codigo_Atual)                                
    Begin                                
     DECLARE @log_set_descricao varchar(50)                                
                                   
      select @log_set_descricao = 'Alteracao da Clinica do Paciente para ' + set_descricao from vwlocal_unidade where locatend_codigo = @LocAtend_Codigo_Atual                                
                                   
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'CLINICA DO PACIENTE', '1' /* alteracao */, @LocAtend_Codigo_Atual_original, @LocAtend_Codigo_Atual,  @log_set_descricao, @unid_codigo                                
      set @Erro = @Erro + @@error                                
    End                                
                                
   -- Motivo de Safda                                
    SELECT @tipo_Alta = motcob_tipo FROM motivo_cobranca_aih WHERE motcob_codigo = @Inter_Motivo_Alta                                
                                
   if ( @Inter_Tipo_Alta_original <>  @tipo_Alta) and ( @Inter_Tipo_Alta_original is not null) and ( @tipo_Alta is not null)                                
   begin                                
     DECLARE @log_motivo_origem varchar(30)            
     DECLARE @log_motivo_atual varchar(30)                                
                                
     if @tipo_Alta = 'A' set @log_motivo_atual = 'ALTA'                                
     if @tipo_Alta = 'O' set @log_motivo_atual = 'OBITO'                                
     if @tipo_Alta = 'P' set @log_motivo_atual = 'PERMANENCIA'                                
     if @tipo_Alta = 'T' set @log_motivo_atual = 'TRANSFERENCIA'                                
                                
    if @Inter_Tipo_Alta_original = 'A' set @log_motivo_origem = 'ALTA'                                
     if @Inter_Tipo_Alta_original = 'O' set @log_motivo_origem = 'OBITO'                                
     if @Inter_Tipo_Alta_original = 'P' set @log_motivo_origem = 'PERMANENCIA'                                
     if @Inter_Tipo_Alta_original = 'T' set @log_motivo_origem = 'TRANSFERENCIA'     
                      
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'MOTIVO DE SAIDA', '1' /* alteracao */, @log_motivo_origem, @log_motivo_atual, 'Alteracao do Motivo de Saida', @unid_codigo                                
     set @Erro = @Erro + @@error                                
                                 
    --Se alterou o motivo de saÃ­da, e era Ã³bito (logo, nÃ£o Ã© mais), retira o Ã³bito do paciente                                
     IF @Inter_Tipo_Alta_original = 'O'                                
     Begin                                
      if not exists (select 1 from obito where pac_codigo = @pac_codigo)                                 
        UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                                
     End                                
     ELSE                                
     Begin                                
        if @tipo_Alta = 'O'                                
        Execute ksp_Obito_Paciente @Pac_Codigo, @Inter_DtAlta --alterou motivo para obito                                
     End                                
 end                                
                                
  -- DIAGNOSTICO                                
   if ( @cid_codigo_original <>  @cid_codigo)                                
   begin                                
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DIAGNOSTICO', '1' /* alteracao */, @cid_codigo_original, @cid_codigo, 'Alteracao de Diagnostico', @unid_codigo                                
    set @Erro = @Erro + @@error                                
   end                                
                                
 -- PROCEDIMETNO                                
   if ( @proc_codigo_original <>  @proc_codigo)                                
   begin                                
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'PROCEDIMENTO', '1' /* alteracao */, @proc_codigo_original, @proc_codigo, 'Alteracao de Procedimento', @unid_codigo                                
    set @Erro = @Erro + @@error                                
   end                                
                                
 /*Altera o Pedido da Internatpo*/                                
    EXECUTE	ksp_pedido_internacao
		@opcao = 2,
		@tp_pesq = NULL,
		@pedint_pedint_sequencial = @PedInt_Sequencial,
		@pedint_carint_codigo = @CarInt_Codigo,
		@pedint_cid_codigo = @cid_codigo,
		@pedint_pac_codigo = @Pac_Codigo,
		@pedint_proc_codigo = @Proc_Codigo,
		@pedint_prof_codigo = @Prof_Codigo,
		@pedint_locatend_codigo = @LocAtend_Codigo,
		@pedint_cid_secundario_codigo = @Cid_Codigo_Secundario,
		@pedint_inter_dtprevista = @Inter_DataInter,
		@pac_nome = NULL,
		@locatend_descricao = NULL,
		@unid_codigo = @unid_codigo,
		@pac_cartao_nsaude = NULL,
		@unid_codigocnes = NULL,
		@tipesplei_codigo = NULL,
		@locatend_codigo = NULL,
		@lei_codigo = NULL,
		@reslei_status = NULL,
		@reslei_dtAutorizacao = NULL,
		@reslei_dtInicial = NULL,
		@reslei_dtFinal = NULL,
		@usu_codigo = NULL,
		@reslei_status_busca = NULL,
		@reslei_motivo = NULL,
		@emer_codigo = NULL,
		@spa_codigo = NULL,
		@atend_codigo = NULL,
		@cod_solicitacao_ser = NULL,
		@leitoRegulado = @leitoRegulado,
		@numAutorizacao = @numAutorizacao
  set @Erro = @Erro + @@error                                
  /* Atualiza Tabela de Internacao */                                
    UPDATE INTERNACAO SET pedInt_sequencial    = @PedInt_Sequencial,                                 
		pac_codigo           = @Pac_Codigo,                            
		inter_dtprevista     = @Inter_DtPrevista,                                
		inter_datainter      = @Inter_DataInter,                                
		estpac_codigo        = @EstPac_Codigo,                                
		inter_dtalta         = @Inter_DtAlta,                                
		locatend_codigo      = @LocAtend_Codigo,                                
		prof_codigo          = @Prof_Codigo,                                
		inter_motivo_alta    = @Inter_Motivo_Alta,                                
		locatend_codigo_resp = @LocAtend_Codigo_Resp,                                
		prof_codigo_resp     = @Prof_Codigo_Resp,                                
		locatend_codigo_atual= @LocAtend_Codigo_Atual,                                
		estpac_codigo_atual  = @EstPac_Codigo_Atual,                               
		Inter_hipdiag        = @Hipotese,                                
		inter_DeObservacao   = @inter_DeObservacao,                                  
		inter_motivo_alta_descricao = @Inter_Motivo_Alta_Descricao,
		unidref_codigo_destino		= @unidref_codigo_destino    
                                
    WHERE inter_codigo         = @Inter_Codigo                                
    set @Erro = @Erro + @@error                         
                        
                        
  /* Se paciente teve alta antes da realiza??o da cirurgia, apagar a solicita??o */                        
                        
   declare @ped_codigo int
   
	if @tipo_Alta = 'O' -- Se for óbito limpa todos os pedidos posteriores a alta
	begin
		DECLARE	@return_value int
		
		EXEC	@return_value = ksp_Apagar_Pedido
				@Unid_Codigo = @unid_codigo,
				@Inter_Codigo = @inter_codigo,
				@Inter_DtAlta = @Inter_DtAlta
		
		set @Erro = @Erro + @@error
	end                         
  /* Se mudor a data de internatpo*/                                
    IF @Inter_DataInter <> @dt_inter_original                                
    Begin                                
     --mudou a data da internacao (inicial)                                
     execute ksp_Internacao_clinica_atual 2,                                
       @Inter_Codigo,                                
       @LocAtend_Codigo_Atual, -- indiferente                                
       @dt_inter_original, -- antiga                                
       @Inter_DataInter, -- nova                                
       @LOGIN_USUARIO                                
    set @Erro = @Erro + @@error                                
  --SAMIR.23/07: ALTERAR A TABELA DE MOVIMENTAÂ¦+O                                
      UPDATE  MOVIMENTACAO_PACIENTE                                
       SET MOVPAC_DATA = @Inter_DataInter                                
      WHERE INTER_CODIGO = @Inter_Codigo                                
      AND MOVPAC_STATUS = 'I'                        
    set @Erro = @Erro + @@error                                
 End                                
  /* Se mudou a Clinica Atual*/                                
    IF @LocAtend_Codigo_Atual <> @LocAtend_Codigo_Atual_original                                
    Begin                                
     -- mudou a clinica. Inclui o novo registro (alternado o outro)                                
     execute ksp_Internacao_clinica_atual 1,                 
       @Inter_Codigo,                                
       @LocAtend_Codigo_Atual,                                
       @DataAtualClinica,                                
       null,                                
       @LOGIN_USUARIO                                
   set @Erro = @Erro + @@error                                
  End                                
  /* Se mudou a Data de Alta */                                
    IF isnull(@Inter_DtAlta,'01/01/1950 00:00:00') <> isnull(@alta,'01/01/1950 00:00:00')                                
    Begin                                
     if @Alta is null                                 
      Begin                                 
      -- ALTA --                  
         execute ksp_Internacao_clinica_atual 4,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
          null,                                
          @Inter_DtAlta,                                
          @LOGIN_USUARIO                                
      set @Erro = @Erro + @@error                      
                   
  Update  MOVIMENTACAO_PACIENTE Set                  
        movpac_data_saida = @Inter_DtAlta                  
       Where inter_codigo = @inter_codigo                  
        and movpac_data_saida is null                  
      set @Erro = @Erro + @@error                                  
      End                                
      Else                                
      Begin                                
      --Mudou a Data de Alta                                
         execute ksp_Internacao_clinica_atual 9,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
         @Alta,  -- antiga                                
          @Inter_DtAlta,  -- nova                                
          @LOGIN_USUARIO                                
      set @Erro = @Erro + @@error                                
    End                                
  End                                
                                
  /* Se estava internado */                                
  IF @alta IS NULL                          
  BEGIN                                
  /* ... e npo estÃ mais: T ALTA */                                
     IF @Inter_DtAlta IS NOT NULL                                
     BEGIN                                
      -- OS: 634 LOG DIFERENCIADO:                                
         DECLARE  @dta char(19)                                
         set @dta = convert(char(11), @Inter_DtAlta,103) + convert(char(8), @Inter_DtAlta,108)                                
         set @log_motivo_atual = ''                                
         if @tipo_Alta = 'A' set @log_motivo_atual = 'Saida por ALTA'                                
         if @tipo_Alta = 'O' set @log_motivo_atual = 'Saida por OBITO'                                
         if @tipo_Alta = 'P' set @log_motivo_atual = 'Saida por PERMANENCIA'                                
         if @tipo_Alta = 'T' set @log_motivo_atual = 'Saida por TRANSFERENCIA'                                
                                  
         exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'SAIDA', '3' /* Alta */, null, @dta, @log_motivo_atual, @unid_codigo                                
      set @Erro = @Erro + @@error                                
      /*                                
      SAMIR.18/11/2003                                
      Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                                
      a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                                
      os leitos                                
      */                                
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
    -- SAMIR.18/11/2003.FIM                                
                                  
    /*EVOLUÂ¦+O, referente a ALTA */                             
      DECLARE @ja_evoluiu char(12)                                
                                    
         select @ja_evoluiu = inter_codigo from evolucao                                
         where inter_codigo = @Inter_Codigo and evo_data = @Inter_DtAlta                                
                  
         if @ja_evoluiu is null                                 
         begin                                
          select @tipo_Alta = motcob_tipo                                 
            from motivo_cobranca_aih                                 
            where motcob_codigo = @Inter_Motivo_Alta                                
             DECLARE @log_motivo_alta varchar(30)                                
             if @tipo_Alta = 'A' set @log_motivo_alta = 'ALTA'                                
            if @tipo_Alta = 'O' set @log_motivo_alta = 'OBITO'                                
            if @tipo_Alta = 'P' set @log_motivo_alta = 'PERMANENCIA'                                
            if @tipo_Alta = 'T' set @log_motivo_alta = 'TRANSFERENCIA'                                
            Execute kSP_Evolucao 1, Null, @Inter_Codigo, @Inter_DtAlta, @Prof_Codigo, @LocAtend_Codigo, @EstPac_Codigo_Atual, @LocAtend_Codigo_Atual, @log_motivo_alta, Null,null                                
       set @Erro = @Erro + @@error                                
      end                                
        /*Se o motivo da alta T +BITO, entpo mata o cara */                                
         select @tipo_Alta = motcob_tipo                                 
         from motivo_cobranca_aih                                 
         where motcob_codigo = @Inter_Motivo_Alta                                
                                  
         IF @TIPO_ALTA = 'O'                                
         BEGIN                                
          Execute ksp_Obito_Paciente                                
             @Pac_Codigo,                                
             @Inter_DtAlta                                
       set @Erro = @Erro + @@error                                
      END                                 
  END                        
  END                          
  ELSE                                
  /* Se npo estÃ internado (jÃ estÃ de alta)*/                                
  BEGIN                                
   /* ... E agora estÃ internado: T ESTORNO de ALTA */                                
     IF @Inter_DtAlta IS NULL                                
     BEGIN                                
      -- OS: 634 LOG DIFERENCIADO:                                
         exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'ESTORNO', '4' /* estorno */, null, null, 'Estorno da Saida da Internacao', @unid_codigo                                
   set @Erro = @Erro + @@error      
                                 
  if (@LocAtend_Leito = @LocAtend_Leito_original     
       and @Leito_original = @Lei_Codigo)    
  BEGIN         
   Update  MOVIMENTACAO_PACIENTE     
   Set movpac_data_saida = null                  
   Where movpac_sequencial = (select max(movpac_sequencial) from MOVIMENTACAO_PACIENTE where inter_codigo = @inter_codigo)                  
   set @Erro = @Erro + @@error                                   
  END        
  ELSE        
  BEGIN        
   declare @MovPac_Sequencial char(12)        
   EXEC ksp_controle_sequencial @Unidade = @unid_codigo ,           
   @Chave      = 'movimentacao_paciente' ,           
   @data       = @datahoje,           
   @NovoCodigo = @MovPac_Sequencial OUTPUT          
   INSERT INTO movimentacao_paciente          
   (movpac_sequencial,          
   locatend_codigo,          
   inter_codigo,          
   estpac_codigo,          
   usu_codigo,          
   lei_codigo,          
   movpac_data,          
   movpac_status)          
            
   VALUES          
   (@MovPac_Sequencial,          
         @LocAtend_Leito,                
       @Inter_Codigo,             
       @EstPac_Codigo,                   
       @Usu_Codigo,           
       @Lei_Codigo,           
       @alta,          
       'M')            
    
 update internacao     
  set locatend_leito = @locatend_leito,     
   lei_codigo = @Lei_Codigo     
 where inter_codigo = @Inter_Codigo       
            
   set @Erro = @Erro + @@error                                   
  End        
          
        
         /*                                
     SAMIR.18/11/2003                                
      Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                                
      a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                                
      os leitos                                
     */                                
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
      -- SAMIR.18/11/2003.FIM                         
                                  
         -- EM CASO DE ESTORNO DE ALTA, SENDO A ALTA UM +BITO, REMOVER O OBITO DO PACIENTE         
    --27/05/2002                                
       IF @Inter_Tipo_Alta_original = 'O'                                 
         Begin                                
          UPDATE  paciente                                 
            SET pac_dtObito = NULL                                
            WHERE  pac_codigo = @Pac_Codigo                                
       set @Erro = @Erro + @@error                                
       End                                
                                  
    /* Exclusao da Evolutpo de Alta, se for estorno de alta */                                
         Execute kSP_Evolucao 3, Null, @Inter_Codigo, @alta, Null, Null, Null, Null, Null, Null,null                                
   set @Erro = @Erro + @@error                                
                                  
    -- LEONARDO LIMA .24/10/2005                                
                                  
         -- EM CASO DE ESTORNO DE ALTA, LIMPAR A DATA FINAL DA CLINICA ATUAL                                
         execute ksp_Internacao_clinica_atual 8,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
          @Alta,  -- antiga                                
 @Inter_DtAlta,  -- nova                                
          @LOGIN_USUARIO                                
                                  
      set @Erro = @Erro + @@error                                
                                   
    --FIM 24/10/200                                
  END                                    
 END                                
                                   
  -- ALTERA AS DATAS POSTERIORES EXISTENTES, MARCANDO PARA REPROCESSAR O CENSO                                
 If @dt_inter_original <> @Inter_DataInter                                
 Begin                                
  If @dt_inter_original < @Inter_DataInter                                
     Begin                                
        UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@dt_inter_original,103),103)                                
      set @Erro = @Erro + @@error                                
    End                                
     Else                                
     Begin                                
      UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DataInter,103),103)                                
      set @Erro = @Erro + @@error                                
  End                                
 End                                
                                  
  /*Marca para reprocessar desde a data: ou de ALTA, ou de ALTA ORIGINAL*/                                
 If @alta <> @Inter_DtAlta                                
 Begin                                
  If @Inter_DtAlta Is Not Null                                
     Begin                                
      UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DtAlta,103),103)                                
      set @Erro = @Erro + @@error                                
     End                                
     If @alta Is Not Null                         
      Begin         
        UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@alta,103),103)                                
      set @Erro = @Erro + @@error                                
  End                                
 End                                
                                
        
                              
End /* Optpo = 2: Alterar */                              
------------------------------------ Exclusao dos Dados ---------------------------------------                            
if @Opcao = 3                            
 Begin                            
                            
  -- OS: 634 LOG DIFERENCIADO:                            
  exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'EXCLUSAO', '2' /* exclusao */, null, null, 'Exclusao da Internacao', @unid_codigo                            
set @Erro = @Erro + @@error                            
  /* verifica os dados */                            
  SELECT               
   @LocAtend_Codigo = locatend_leito,                             
   @Lei_Codigo  = lei_codigo,                            
   @Inter_DtAlta  = inter_dtalta,                            
   @cid_codigo = P.cid_codigo,                            
   @Inter_Motivo_Alta = inter_motivo_alta                            
  FROM  internacao
	LEFT JOIN PEDIDO_INTERNACAO P ON internacao.PEDINT_SEQUENCIAL = P.PEDINT_SEQUENCIAL 
  WHERE  inter_codigo = @Inter_Codigo
                            
                            
  -- 0 deletar NOTIFICACAO_COMPULSORIA                            
                            
  --1 DELETAR movimentacao_paciente                            
  --3 DELETAR espelho_aih                            
   --2 DELETAR auditor_procedimento                            
  --5 DELETAR resumo_alta                            
   --4 DELETAR resumo_alta_procedimento                            
  --6 DELETAR procedimentos_realizados                            
  --7 DELETAR internacao_parto                            
  --8 DELETAR evolucao                       
  --9 DELETAR internacao_clinica_atual                            
  --10 DELETAR internacao                            
  --11 ALTERAR leito = LIVRE                            
  --12 Marcar para reprocessar o CENSO                            
                            
  if not exists (select 1 from obito where pac_codigo = @pac_codigo)                            
   UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                            
                            
                            
 /* ROTINAS DE EXLUSAO */                            
 -- 0 deletar NOTIFICACAO_COMPULSORIA                            
  delete from NOTIFICACAO_COMPULSORIA                            
  where pac_codigo = @pac_codigo                            
  and cid_codigo = @cid_codigo                            
set @Erro = @Erro + @@error                            
 --1- DELETA Evolucao                            
    DELETE FROM                             
   movimentacao_paciente                            
  WHERE inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --2- DELETA auditor_procedimento (PRE-REQUISITO PARA espelho_aih)                            
  DELETE FROM                              
   auditor_procedimento                            
  FROM  espelho_aih, auditor_procedimento                            
  WHERE  auditor_procedimento.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
--SAMIR.23/04.ATOS_PROFISSIONAIS                            
 --21.PACIENTE_AIH   
  DELETE FROM                            
   paciente_aih                            
  FROM  espelho_aih, paciente_aih                            
  WHERE  paciente_aih.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --22.ATOS_PROFISSIONAIS                            
  DELETE FROM                            
   atos_profissionais                            
  FROM  espelho_aih, atos_profissionais                            
  WHERE  atos_profissionais.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
--FIM                            
--SAMIR.19/11/2003 Mais relacionaentos                            
 --23.PREVISAO_FATURAMENTO                            
  DELETE FROM                         
   previsao_faturamento                            
  FROM  espelho_aih, previsao_faturamento                            
  WHERE  previsao_faturamento.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --24.Cartao_Visita                            
  DELETE FROM                            
   Cartao_Visita                            
  WHERE  inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
 --25.restricao_visita                            
  DELETE FROM                            
   restricao_visita                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
--fim                      
 --3- DELETA espelho_aih                            
    DELETE FROM                             
   espelho_aih                            
 WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --4- DELETA resumo_alta_procedimento (PRE-REQUISITO PARA resumo_alta)                            
    DELETE FROM                             
   resumo_alta_procedimento                            
  WHERE  inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
 --5- DELETA resumo_alta                            
    DELETE FROM                             
   resumo_alta                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --6- DELETA procedimentos_realizados                            
    DELETE FROM                             
   procedimentos_realizados                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --7- DELETA internacao_parto                            
    DELETE FROM                             
   internacao_parto                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --8- DELETA evolucao                            
                            
    DELETE FROM                             
   evolucao                            
  WHERE inter_codigo = @Inter_Codigo                         
set @Erro = @Erro + @@error                            
 -- 9 DELETA internacao_clinica_atual                            
  DELETE FROM                             
   INTERNACAO_CLINICA_ATUAL                            
  WHERE inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
-- LEONARDO LIMA 06/10/2005 - PID                              
DELETE FROM                             
   INTERNACAO_PID                            
  WHERE inter_codigo =  @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
-- SolicitaÃ§Ã£o de ProntuÃ¡rio                            
 --Remove a solicitaÃ§Ã£o de prontuÃ¡rio:                            
 SELECT                             
  @LocAtend_Codigo = locatend_codigo                            
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
                            
                              
                            
                            
/*----*/--10- DELETA internacao  (MOTIVO DE TODOS OS DELETEÂ¦S ANTERIORES)                            
                            
    DELETE FROM                             
   internacao                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
/*------------------------------------------------------------*/                            
                            
 --11- Atualizacao na Tabela de Leitos                            
/*                            
SAMIR.18/11/2003                            
 Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                            
 a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                            
 os leitos                            
*/                            
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
                            
-- SAMIR.18/11/2003.FIM                            
                            
 --12 Marca para reprocessar os Censos...                          
  UPDATE                             
   Status_Censo                            
  SET stcen_Status = 'R'                            
  WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DtAlta,103),103)                            
set @Erro = @Erro + @@error                                  
  IF @Inter_Motivo_Alta = 'O'                             
   UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                            
set @Erro = @Erro + @@error                            
                            
 End /*Opcao 3=Excluir*/                            
---------------------------------- NÂ·mero do +ltimo C=digo -----------------------------------                            
If @Opcao = 4                             
 Begin                            
--  Exec  kSp_Novo_Codigo 'internacao','inter_codigo','N', @Inter_Codigo output                            
  EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,                            
          @Chave      = 'internacao' ,                             
          @data       = @datahoje,               
          @NovoCodigo = @inter_codigo OUTPUT                            
                            
 End                            
                            
------------------------------ Internacoes do Mapa de Leitos ----------------------------------                            
If @Opcao = 5                            
 Begin                            
  Select  I.Pac_Codigo,                            
   P.Pac_Nome,                            
   PP.Pac_Prontuario_Numero as Pac_Prontuario,                            
   I.Inter_Codigo,                            
   I.Inter_DataInter,                            
                            
   Enf.Set_Descricao,                            
   L.LocAtend_Codigo,                            
   L.Lei_Codigo,                            
   L.LocInt_Descricao,                            
   L.Enf_Codigo,                            
   L.Lei_Status                            
                            
                            
         From    Internacao I,                            
   vwLeito L,                            
   Estado_Paciente E,                            
   Paciente P,                            
   vwEnfermaria Enf,                            
   Paciente_Prontuario PP                            
                            
  Where   I.EstPac_Codigo  = E.EstPac_Codigo                            
  And  I.Pac_Codigo   = P.Pac_Codigo                            
  And  I.Lei_Codigo   = L.Lei_Codigo                            
  And I.LocAtend_Leito  = L.LocAtend_Codigo                            
  And L.Enf_Codigo   = Enf.Enf_Codigo                            
  And     P.Pac_Codigo            = PP.Pac_Codigo                            
                            
         And  I.Inter_DtAlta Is NULL                            
  And  L.LocAtend_Codigo =  IsNull(@LocAtend_Leito,L.LocAtend_Codigo)                            
  And I.Lei_Codigo = IsNull(@Lei_Codigo,I.Lei_Codigo)                            
  And  L.Set_Codigo = IsNull(@Set_Codigo,L.Set_Codigo)                            
                            
  Order By L.Enf_Codigo, L.Lei_Codigo, I.Inter_DataInter Desc                            
set @Erro = @Erro + @@error                            
 End                            
----------------------------------------- Mapa de Leitos ---------------------------------------                            
If @Opcao = 6                            
 Begin   
                            
                            
  set @sql =   ' Select vwEnf.LocAtend_Descricao,'                            
  set @sql = @sql + '   vwLei.LocAtend_Codigo,'                            
  set @sql = @sql + '   vwLei.Lei_Codigo,'                            
  set @sql = @sql + '   vwLei.LocInt_Descricao,'                            
  set @sql = @sql + '   vwEnf.Enf_Codigo,'                            
  set @sql = @sql + '   vwLei.Lei_Status,'                            
  set @sql = @sql + '   I.Inter_Codigo,'                            
  set @sql = @sql + '   I.Pac_Codigo,'                            
  set @sql = @sql + '   space(50) Pac_Nome,'                            
  set @sql = @sql + '   space(10) Pac_Prontuario,'                            
  set @sql = @sql + '   vwLei.Lei_Tipo,'               
  set @sql = @sql + '   LA.set_descricao Clinica_Paciente,'                            
  set @sql = @sql + '   I.inter_DeObservacao, '                            
  set @sql = @sql + '   I.inter_datainter,'                        
  set @sql = @sql + '   proced.proc_tempo,'
  set @sql = @sql + '   0 as PossuiPendencia,'   
  set @sql = @sql + '  (select case when count(*) = 1 then min(movpac_data)' 
  set @sql = @sql + '              when count(*) > 1 then max(movpac_data)' 
  set @sql = @sql + '  	  else null end'
  set @sql = @sql + '  	  from movimentacao_paciente mp where I.inter_codigo = mp.inter_codigo and I.LocAtend_Leito = mp.LocAtend_Codigo) as TempoLeito '                   
                            
  set @sql = @sql + ' Into  #Temp_Mapa_Leitos'                            
                                
  set @sql = @sql + ' From vwLeito  vwLei'                             
  set @sql = @sql + ' inner join vwEnfermaria vwEnf on VWLEI.LocAtend_Codigo = vwEnf.LocAtend_Codigo'                            
  set @sql = @sql + ' left join Internacao I on I.LocAtend_Leito = vwLei.LocAtend_Codigo and I.Lei_Codigo = vwLei.Lei_Codigo and I.Inter_DtAlta Is Null'                            
  set @sql = @sql + ' left join vwLocal_unidade LA on I.locatend_Codigo_atual = la.LocAtend_Codigo'                            
  set @sql = @sql + ' Left join Pedido_Internacao Ped_Int on I.pedint_sequencial = Ped_int.pedint_sequencial'                      
  set @sql = @sql + ' Left join procedimento proced on Ped_Int.proc_codigo = proced.proc_codigo'                      
                            
  set @sql = @sql + ' Where 1 = 1'                            
                            
  If @Set_Codigo is not null                            
   set @sql = @sql + '  And vwenf.locatend_Codigo_clinica = ' + '''' + @Set_Codigo + ''''                            
                            
                            If @LocAtend_Leito is not null                             
   set @sql = @sql + ' And vwLei.LocAtend_Codigo  = ' + '''' + @LocAtend_Leito + ''''                            
                            
  set @sql = @sql + ' And vwLei.unid_codigo   = ' + '''' + @unid_codigo + ''''                            
  set @sql = @sql + ' And not exists (select 1 from enfermaria e where e.enf_codigo = vwEnf.Codigo_Enfermaria and e.enf_operacional = ' + '''' + 'N' + '''' + ')'                            
                            
  -- Filtro por clÃ­nica ( exibe os leitos livres e ocupados da clinica e pacientes fora da clÃ­nica) --                            
  If @locatend_codigo_atual is not null                            
  begin                            
                            
   set @sql = @sql + ' And ( (I.locatend_codigo_atual = ' + '''' + @locatend_codigo_atual + '''' + ') Or'                            
   set @sql = @sql + '   ((vwEnf.locatend_Codigo_clinica = ' + '''' + @locatend_codigo_atual + '''' + ') And'                                        
   set @sql = @sql + '   (vwLei.lei_status = ' + '''' + 'L' + '''' + ')) )'                            
                            
  end                            
                            
  If @lei_tipo is not null                            
   set @sql = @sql + '  And vwLei.Lei_Tipo = ' + '''' + @lei_tipo + ''''                            
                            
  Else If @lei_tipo <> '5' or @lei_tipo is null                            
   set @sql = @sql + '  And (I.inter_DeObservacao = ''N'' or vwLei.Lei_Tipo <> ''5'')'                            
                        
  set @Erro = @Erro + @@error                            
                             
  set @sql = @sql + ' Update #Temp_Mapa_Leitos'                            
  set @sql = @sql + ' Set  Pac_Nome = Null, Pac_Prontuario = Null'                            
              
  set @Erro = @Erro + @@error                            
                            
  set @sql = @sql + ' Update  #Temp_Mapa_Leitos'                            
  set @sql = @sql + ' Set  #Temp_Mapa_Leitos.Pac_Nome = case when P.pac_nome_social is not null then p.pac_nome_social + ''['' + P.Pac_Nome + '']'' else P.pac_nome end,'                            
  set @sql = @sql + '    #Temp_Mapa_Leitos.Pac_Prontuario = PP.Pac_Prontuario_Numero'                            
  set @sql = @sql + ' From  #Temp_Mapa_Leitos
							INNER JOIN Paciente P ON #Temp_Mapa_Leitos.Pac_Codigo = P.Pac_Codigo
							LEFT JOIN Paciente_Prontuario PP ON P.Pac_Codigo = PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''' '
                            
  set @Erro = @Erro + @@error  
  
  set @sql = @sql + ' Update #Temp_Mapa_Leitos'
  set @sql = @sql + ' Set  PossuiPendencia = 1'
  set @sql = @sql + ' Where  Inter_Codigo in (select inter_codigo from Pendencia_Paciente)'                           
                            
  set @sql = @sql + ' Select LocAtend_Descricao,'                            
  set @sql = @sql + '   LocAtend_Codigo,'                            
  set @sql = @sql + '   Lei_Codigo,'                            
  set @sql = @sql + '   LocInt_Descricao,'                            
  set @sql = @sql + '   Enf_Codigo,'                            
  set @sql = @sql + '   Lei_Status,'                            
  set @sql = @sql + '   Inter_Codigo,'                            
  set @sql = @sql + '   Pac_Codigo,'                            
  set @sql = @sql + '   Pac_Nome,'                            
  set @sql = @sql + '   Pac_Prontuario,'                            
  set @sql = @sql + '   Lei_Tipo,'                            
  set @sql = @sql + '   Clinica_Paciente,'                            
 set @sql = @sql + '    Inter_DeObservacao,'        
  set @sql = @sql + '   inter_datainter,'                            
  set @sql = @sql + '   proc_tempo,'                
  set @sql = @sql + '   PossuiPendencia, '
  set @sql = @sql + '   TempoLeito '
                             
  set @sql = @sql + ' From #Temp_Mapa_Leitos'
  
  if (@PossuiPendencia = 1)
	set @sql = @sql + ' where PossuiPendencia = 1 '              
                  
  set @sql = @sql + ' Order By Enf_Codigo, Lei_Codigo'                            
                            
  set @sql = @sql + ' Drop Table  #Temp_Mapa_Leitos'                            
                            
  set @Erro = @Erro + @@error                            
                            
  Exec(@sql)                       
                            
 End                            
                            
----------------------------------------- Evolutpo ---------------------------------------                            
If @Opcao = 7                            
 Begin                            
  Select                            
   PDI.Pac_Codigo,                            
   P.Pac_Nome,                                
       vwLA.LocAtend_descricao,                            
   M.Med_Nome,                            
   CID.Cid_Descricao,                            
   Proced.Proc_Descricao,                            
   vwL.LocInt_Descricao,                            
   CA.LocAtend_Codigo,                            
   CA.LocAtend_Descricao,                            
   I.Inter_DataInter,                            
   I.Inter_DtAlta,  
   I.inter_motivo_alta_descricao,
   PDI.leitoRegulado,
   PDI.numAutorizacao                             
                            
  From Internacao   I                            
   INNER JOIN Pedido_Internacao PDI ON PDI.PedInt_Sequencial = I.PedInt_Sequencial                            
   LEFT JOIN CID_10 CID ON CID.Cid_Codigo = PDI.Cid_Codigo                            
   LEFT JOIN Medico M ON M.LocAtend_Codigo = PDI.locatend_codigo                            
     AND M.prof_codigo = PDI.Prof_Codigo                            
   LEFT JOIN Procedimento Proced ON Proced.Proc_Codigo = PDI.proc_codigo                           
   LEFT JOIN Paciente P ON P.Pac_Codigo = PDI.Pac_Codigo               
   LEFT JOIN vwLocal_Atendimento vwLA ON vwLA.LocAtend_Codigo = M.LocAtend_Codigo                            
       LEFT JOIN vwLeito vwL ON vwL.LocAtend_Codigo = I.locatend_leito                            
     AND vwL.Lei_Codigo = I.lei_codigo                            
   LEFT JOIN  vwLocal_Atendimento CA ON CA.LocAtend_Codigo = I.locatend_codigo                            
                            
      Where   I.Inter_Codigo          = @Inter_Codigo                            
 End                            
----------------------------------------- Pesquisa ---------------------------------------                            
If @Opcao = 8                            
 Begin                            
                            
  set @tp_pesq = convert(smallint,@carint_codigo)                            
                            
                            
  set @sql =    ' SELECT i.inter_codigo,'                            
  set @sql = @sql + ' convert(char(10),i.inter_datainter,103)    + '' '' +  convert(char(5),i.inter_datainter,108) inter_datainter,'                            
 set @sql = @sql + ' convert(char(10),i.inter_dtalta,103)  + '' '' +  convert(char(5),i.inter_dtalta,108) inter_dtalta,'                            
  set @sql = @sql + ' pp.pac_prontuario_numero as pac_prontuario,'                            
  set @sql = @sql + ' p.pac_nome,'                            
  set @sql = @sql + ' p.pac_codigo,'                            
  set @sql = @sql + ' i.spa_codigo,'                            
  set @sql = @sql + ' i.pedint_sequencial,'                            
  set @sql = @sql + ' i.inter_dtprevista,'                            
  set @sql = @sql + ' i.estpac_codigo,'                            
  set @sql = @sql + ' i.estpac_codigo_atual,'                            
  set @sql = @sql + ' i.locatend_codigo,'                            
  set @sql = @sql + ' i.locatend_leito,'                            
  set @sql = @sql + ' i.lei_codigo,'                            
  set @sql = @sql + ' i.prof_codigo,'                              
  set @sql = @sql + ' i.inter_motivo_alta_descricao,'                            
  set @sql = @sql + ' pi.proc_codigo,'
  set @sql = @sql + ' PI.leitoRegulado,'
  set @sql = @sql + ' PI.numAutorizacao '                            
  set @sql = @sql + ' FROM internacao i, pedido_internacao pi, paciente p, paciente_prontuario pp'                            
  set @sql = @sql + ' WHERE p.pac_codigo = i.pac_codigo and'                            
  set @sql = @sql + ' i.pedint_sequencial = pi.pedint_sequencial and'                            
  set @sql = @sql + ' p.pac_codigo = pp.pac_codigo and'                            
  set @sql = @sql + ' pp.unid_codigo = ''' + @unid_codigo +  ''' and'                
  set @sql = @sql + ' i.inter_codigo like ''' + @unid_codigo_int + ''' and '    
  set @sql = @sql + ' i.inter_DeObservacao = ''N'' and '                            
                            
  if @pac_codigo is not null                            
     begin                            
       Set @var1 = convert(varchar,@pac_codigo)                            
   Exec ksp_ParametroPesquisa @var1,'p.pac_codigo',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_codigo is not null                            
     begin                            
   Set @var1 = convert(varchar,@inter_codigo)                            
       Exec ksp_ParametroPesquisa @var1,'i.inter_codigo',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @pac_nome is not null                            
     begin                            
   Set @var1 = @pac_nome                            
   Exec ksp_ParametroPesquisa @var1,'p.pac_nome',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                
            end                            
                            
  if @proc_codigo is not null                            
     begin                            
   set @var1 = convert(varchar,@proc_codigo)                            
   exec ksp_ParametroPesquisa @var1,'pp.pac_prontuario_numero',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_datainter is not null                            
     begin                            
   set @var1 = convert(char(10),@inter_datainter,103)                            
   exec ksp_ParametroPesquisa @var1,'convert(char(10),i.inter_datainter,103)',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_dtalta is not null                            
     begin                            
   set @var1 = convert(char(10),@inter_dtalta,103)                            
   exec ksp_ParametroPesquisa @var1,'convert(char(10),i.inter_dtalta,103)',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                    
                            
  if @spa_codigo is not null                            
     begin                            
   set @var1 = @spa_codigo                            
   exec ksp_ParametroPesquisa @var1,'i.spa_codigo',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                           
                            
  if @emer_codigo is not null         begin                            
   set @var1 = @emer_codigo                            
   exec ksp_ParametroPesquisa @var1,'i.emer_codigo',@tp_pesq,'t',@par output              
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @pac_prontuario is not null                            
     begin                            
   set @var1 = convert(varchar,@pac_prontuario)                            
   exec ksp_ParametroPesquisa @var1,'pp.pac_prontuario_numero',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
                            
  set @Sql = @Sql + @par + ' Order by convert(smalldatetime,i.inter_datainter) desc'                            
                              
                            
  exec(@sql)                            
                            
  set @Erro = @Erro + @@error                        
 End                            
                            
                            
----------------------------------------- Local da Internatpo ---------------------------------------                            
If @Opcao = 9                            
Begin                            
 DECLARE @LocInt_Descricao CHAR(100)                            
 DECLARE @hospdia_codigo CHAR(12)                            
                             
 Select  @LocInt_Descricao = LocInt_Descricao,                            
   @LEI_TIPO = vw.Lei_Tipo,                            
   @inter_codigo = i.inter_codigo,                            
   @inter_DeObservacao = inter_DeObservacao                            
 From  internacao i, vwLeito vw                            
 Where  i.pac_codigo = @Pac_Codigo                            
 And  i.inter_dtalta is null                            
 And  i.locatend_leito = vw.locatend_codigo                            
 And  i.lei_codigo  = vw.lei_codigo                            
 And   vw.unid_codigo          = @unid_codigo                            
                            
 SELECT @hospdia_codigo = hospdia_codigo                            
 from hospitaldia          
 WHERE pac_codigo = @Pac_Codigo                            
 and hospdia_DataFim is null                            
                            
 if (@inter_codigo is not null)                            
  Select  @LocInt_Descricao  LocInt_Descricao,                             
   @hospdia_codigo  hospdia_codigo,                            
   @LEI_TIPO  Lei_Tipo,                            
   @inter_codigo  inter_codigo,                            
   ISNULL(@inter_DeObservacao, 'N')  inter_DeObservacao                            
                            
End                            
----------------------------------------- Clinica para Carga na Combo ---------------------------------------                       
If @Opcao = 10                            
Begin                            
                            
 Select  S.SET_DESCRICAO,                            
  S.SET_CODIGO                             
                            
 FROM    LOCAL_ATENDIMENTO LA,                             
  SETOR S                            
                            
 WHERE   LA.LOCATEND_CODIGO  = @LocAtend_Leito                            
 AND     S.SET_CODIGO   = LA.SET_CODIGO                            
                            
End                            
----------------------------------------- Internacao de Homonimo --------------------------------                            
If @Opcao = 11                            
Begin                            
                            
 Select i.inter_codigo                      
                            
 From  INTERNACAO I,                             
  Paciente P,                            
  LOCAL_ATENDIMENTO LA                            
                            
 Where  P.pac_nome  = @Pac_Nome                            
 AND  I.PAC_CODIGO  = P.PAC_CODIGO                            
 AND  I.PAC_CODIGO  <> @PAC_CODIGO                            
 AND     I.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                            
 AND     LA.UNID_CODIGO    = @UNID_CODIGO                            
 and  I.inter_dtAlta  Is null                            
                            
End                            
----------------------------------------- Leito Ocupado por outra Internaca --------------------                            
If @Opcao = 12                            
Begin                            
                            
 Select L.LEI_STATUS                            
                            
 From  LEITO L, INTERNACAO I                            
                            
 WHERE  I.LOCATEND_LEITO  = @LocAtend_Leito                            
 AND  I.LEI_CODIGO            = @Lei_Codigo                            
 AND  I.inter_CODIGO          <> @Inter_Codigo                            
 AND  I.inter_dtalta          is null                
 AND  I.LOCATEND_LEITO      = L.LOCATEND_CODIGO                            
 AND  I.LEI_CODIGO            = L.LEI_CODIGO                            
-- And L.Lei_Status  = 'L'                            
End       
                
                            
                            
-- DADOS DA ALTA --------------------------------------------------------------------------------------------------------                            
if @opcao = 13                            
begin                     
                            
 select   i.inter_codigo,                               
   i.inter_dtalta,                               
   i.inter_motivo_alta,                              
   isnull(mc.motcobunid_descricao, mc_aih.motcob_descricao) as motcob_descricao,                           
   i.locatend_codigo_resp,                              
   lu.set_descricao descricao_locatend_codigo_resp,                             
   i.prof_codigo_resp,                              
   prof.prof_nome prof_nome_resp,                             
   null,                             
   null estpac_descricao_alta                             
                 
 from   internacao i                            
                             
 left join motivo_cobranca_unidade mc                            
 on  i.inter_motivo_alta = mc.motcob_codigo                            
                            
 left join motivo_cobranca_aih mc_aih                            
 on  i.inter_motivo_alta = mc_aih.motcob_codigo                            
                            
 inner join local_atendimento la                            
 on  i.locatend_codigo_resp = la.locatend_codigo                            
                            
 inner join setor s                            
 on  la.set_codigo = s.set_codigo                            
                            
 inner join vwlocal_unidade lu                            
 on  la.locatend_codigo      = lu.locatend_codigo                            
                            
 inner join profissional prof                            
 on  i.prof_codigo_resp = prof.prof_codigo                            
 and  i.locatend_codigo_resp = prof.locatend_codigo                            
                            
 where  i.inter_dtalta is not null                            
 and  i.inter_codigo = isnull(@inter_codigo,i.inter_codigo)                            
                            
end                            
                            
                            
                            
----------------------------------- PREVISAO DE INTERNACAO -------------------------------------                            
If @Opcao = 14                            
Begin                            
  Select                              
   Convert(char(10),I.inter_dtprevista,101) Data_Prevista,  -- 0                            
   Convert(char(05),I.inter_dtprevista,108) Hora_Prevista  -- 1                            
                            
  From  Internacao I                            
                            
  --Argumentos                            
  Where Convert(char(10),I.inter_dtprevista,101) = Convert(char(10), getdate() ,101)                            
  And I.Pac_Codigo  = @PAC_Codigo                            
                            
End                            
---------------------------- PROCEDIMENTOS REALIZADOS NA INTERNACAO ----------------------------                            
If @Opcao = 15                            
Begin                            
  Select PR.Proc_Codigo,                             
   P.Proc_Descricao                            
                            
  From Internacao I,                             
   Procedimentos_Realizados PR,            
   Procedimento P                            
                            
  Where I.Pac_Codigo  = @Pac_Codigo                            
  AND  I.Inter_Codigo = @Inter_Codigo                            
  AND  I.Inter_Codigo = PR.Inter_Codigo                            
  AND  PR.Proc_Codigo = P.Proc_Codigo                            
                              
  Order By P.Proc_Descricao                            
                            
                            
End                            
-- DAODS DO MEDICO AUDITOR (P/ TELA DE RESUMO DE ALTA ------------------------------------------                            
If @Opcao = 16                            
Begin                            
                            
 Select  espelho.aih_numero,                             
  espelho.aih_identificacao,                             
  espelho.aih_anterior,                             
  espelho.aih_proxima,                             
  espec.esp_codigo + ' ' + espec.esp_Descricao   ESPECIALIDADE,                             
  medico.med_nome,                     espelho.motcob_codigo + ' ' + motcob.motcob_descricao  MOTIVO,                             
  espelho.aih_uti_mesinicial,                             
  espelho.aih_uti_mesanterior,                             
  espelho.aih_uti_mesalta,                             
  espelho.aih_diaria_acomp,                      
  IntPart.Intpart_nasc_vivo,                             
  IntPart.Intpart_obito_fetal,                             
  IntPart.Intpart_obito_neoparto,                             
  IntPart.Intpar_alta_neoparto,                             
  IntPart.Intpar_transf_neoparto                              
                            
 From  internacao inter                             
  INNER JOIN espelho_aih espelho ON espelho.inter_codigo  = Inter.inter_codigo 
  INNER JOIN motivo_cobranca_aih motcob ON motcob.motcob_codigo  = espelho.motcob_codigo 
  INNER JOIN especialidade_aih espec ON espec.esp_codigo  = espelho.esp_codigo
  LEFT JOIN Internacao_parto IntPart ON intpart.inter_codigo  = espelho.inter_codigo
  INNER JOIN medico medico ON medico.prof_codigo  = espelho.prof_codigo
                            
 where  Inter.inter_codigo = @Inter_Codigo
                            
End                            
-- DAODS DO MEDICO AUDITOR (P/ TELA DE RESUMO DE ALTA ------------------------------------------                            
If @Opcao = 17                            
Begin                            
 SELECT  INTER.INTER_CODIGO COD_INTERNACAO,                            
		 VW.LOCATEND_DESCRICAO CLINICA,                            
         PROF.PROF_NOME  MEDICO,                            
         CID.CID_DESCRICAO DIAGNOSTICO,                            
         P.PROC_DESCRICAO PROCEDIMENTO,                            
         INTER.INTER_DATAINTER DT_INTERNACAO,                            
         VWL.LOCINT_DESCRICAO ENFERMARIA_LEITO,                            
         ET.ESTPAC_DESCRICAO EST_PACIENTE_INTERNACAO,                            
         INTER.INTER_DTALTA DT_ALTA,                            
         MCU.MOTCOBUNID_DESCRICAO MOTIVO_ALTA,                            
         EP.EstPac_Descricao as  EST_PACIENTE_ALTA,                          
		 CARINT.CARINT_DESCRICAO CARATER_INTERNACAO,                            
		 CID.CID_CODIGO,                            
		 P.PROC_CODIGO,
		 INTER.UNIDREF_CODIGO_DESTINO                                                           
                            
 FROM   INTERNACAO INTER                            
                            
 JOIN  VWLOCAL_UNIDADE VW	ON   VW.LOCATEND_CODIGO = INTER.LOCATEND_CODIGO                            
 JOIN  PROFISSIONAL PROF    ON   PROF.LOCATEND_CODIGO = INTER.LOCATEND_CODIGO AND PROF.PROF_CODIGO = INTER.PROF_CODIGO                            
 LEFT JOIN  PEDIDO_INTERNACAO PEDINTER ON   PEDINTER.PEDINT_SEQUENCIAL = INTER.PEDINT_SEQUENCIAL                            
 LEFT JOIN  CARATER_INTERNACAO CARINT  ON   PEDINTER.CARINT_CODIGO = CARINT.CARINT_CODIGO                            
 LEFT JOIN  CID_10 CID		ON  CID.CID_codigo = PEDINTER.cid_codigo                            
 LEFT JOIN  PROCEDIMENTO P  ON   P.proc_CODIGO = PEDINTER.proc_CODIGO                            
 JOIN VWLEITO_COMPLETO VWL  ON  VWL.locatend_CODIGO = INTER.LOCATEND_LEITO AND VWL.LEI_CODIGO = INTER.LEI_CODIGO                            
 JOIN ESTADO_PACIENTE ET    ON ET.ESTPAC_CODIGO = INTER.ESTPAC_CODIGO   
 INNER JOIN ESTADO_PACIENTE EP		  ON  (EP.EstPac_Codigo = INTER.EstPac_Codigo_Atual)                          
 LEFT JOIN MOTIVO_COBRANCA_UNIDADE MCU ON  INTER.INTER_MOTIVO_ALTA = MCU.MOTCOB_CODIGO                            
 
 WHERE   INTER.PAC_CODIGO = @Pac_Codigo
      AND (inter.inter_DeObservacao is null or inter.inter_DeObservacao = 'N')  
End                            
                            
-- 18 - VALIDA SE PODE EXCLUIR ----------------------------------------------------------------------------------                            
If @Opcao = 18                            
Begin                            
                            
  create table #temp_deleta (name sysname)              
  insert into #temp_deleta                            
 select sysobjects.name as tabela                            
  from sysobjects, syscolumns where upper(syscolumns.name) = 'inter_codigo'                            
  and sysobjects.id = syscolumns.id and sysobjects.xtype = 'U'                            
  order by sysobjects.name                              
                            
  delete from #temp_deleta                            
  where tabela in (                            
    'monitoracao_laboratorio',                            
    'movimentacao_paciente',                            
    'espelho_aih',                            
    'evolucao',                            
    'cartao_visita',                            
    'restricao_visita',                            
    'Internacao',                            
    'Resumo_Alta',                            
 'Resumo_Alta_Procedimento',              'internacao_parto',                            
    'procedimentos_realizados',                            
    'internacao_clinica_atual',                            
    'Ultimo_Censo_Hospitalar',                            
    'Censo_Hospitalar',                            
    'Log_Internacao',                            
    'internacao_pid',                            
    'pacientes_internados_central',                            
    'internacao_procedimento_cid')                            
                            
                            
  DECLARE cursor_tabela SCROLL CURSOR                            
  FOR select * from #temp_deleta                            
  DECLARE @tabela varchar(50)                            
  DECLARE @op3Sql varchar(1024)                            
                            
  OPEN cursor_TABELA                            
                            
  FETCH FIRST FROM cursor_tabela INTO @tabela                            
  create table #temp_onde (tabela varchar(50))                            
                            
  WHILE @@FETCH_STATUS = 0                            
  begin                             
   set @op3Sql = 'insert into #temp_onde select ''' + @tabela + ''' Tabela From ' + @tabela                            
     + ' where ' + @tabela + '.inter_codigo = ''' + @Inter_Codigo + ''''                            
                            
   exec(@op3Sql)                            
                               
   FETCH next FROM cursor_tabela INTO @tabela                            
  end                            
  DEALLOCATE cursor_TABELA                            
                            
  drop table #temp_deleta                            
                            
  select * from #temp_onde                            
                            
  drop table #temp_onde                            
                            
end                            
                            
-- 19 - RETORNA PENÃLTIMA INTERNAÃÃO, CASO HAJA ------------------------------------------------                  
If @Opcao = 19                            
Begin                            
                        
                 IF @INTER_CODIGO IS NULL                            
  SELECT *                             
  FROM INTERNACAO                            
  WHERE PAC_CODIGO = @PAC_CODIGO                            
  ORDER BY INTER_DATAINTER DESC                            
 ELSE     
  SELECT *                             
  FROM INTERNACAO           
  WHERE PAC_CODIGO = @PAC_CODIGO                            
    AND INTER_CODIGO <> @INTER_CODIGO                            
  ORDER BY INTER_DATAINTER DESC                            
                            
                            
END                            
                            
-- 20 - VERIFICA SE BOLETIM EM ABERTO ---------------------------------------------------------                            
If @Opcao = 20                            
Begin                            
                            
 SELECT   Case When E.emer_codigo is not null Then                             
    'BE Numero ' + IsNull(Cast(NBE.emer_numero_be As varchar), E.emer_codigo)                             
   Else                             
    Null                            
   End As Boletim                            
                             
 FROM  Emergencia E                            
                             
 inner join  unidade u                            
 on  u.unid_codigo = @Unid_Codigo                            
                             
 LEFT JOIN Atendimento_Ambulatorial AA                            
 ON  E.emer_codigo = AA.emer_codigo                            
                             
 LEFT JOIN Atendimento_Clinico AC                            
 ON  AA.atendamb_codigo = ac.atendamb_codigo                            
                             
LEFT JOIN Numero_BE NBE                            
 ON  AA.emer_codigo = NBE.emer_codigo                 
                             
 WHERE   E.pac_codigo = @pac_codigo                            
 AND  ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) )                            
                            
 and  e.emer_chegada > u.unid_Data_Versao3                            
                            
 UNION                            
                             
 SELECT   Case When PA.spa_codigo is not null Then                             
    'PA Numero ' + IsNull(Cast(NPA.spa_numero_pa As varchar), PA.spa_codigo)                             
   Else                             
    Null                            
   End As Boletim                            
                             
 FROM  Pronto_Atendimento PA                            
                            
 inner join  unidade u                            
 on  u.unid_codigo = @Unid_Codigo                            
                             
 LEFT JOIN Atendimento_Ambulatorial AA                            
 ON  PA.spa_codigo = AA.spa_codigo                            
                             
 LEFT JOIN Atendimento_Clinico AC                            
 ON  AA.atendamb_codigo = ac.atendamb_codigo                            
                             
 LEFT JOIN Numero_PA NPA                            
 ON  AA.spa_codigo = NPA.spa_codigo                            
                             
 WHERE   PA.pac_codigo = @pac_codigo                            
 AND  ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) )                            
                            
 and  pa.spa_chegada > u.unid_Data_Versao3                            
                            
End                            
                            
                             
set @Erro = @Erro + @@error                            
                            
-- 21 - VERIFICA SE BOLETIM EM ABERTO OU EXTRAVIADO ---------------------------------------------------------                            
If @Opcao = 21                            
                    
Begin                          
  if @oripac_codigo = '3'                      
    begin                          
 set @sql =   ' SELECT  TOP 1000 E.emer_codigo codigo, '
 set @sql = @sql + 'nome = case when pac.pac_nome_social is not null or e.emer_nome_social is not null then isnull(pac.pac_nome_social,e.emer_nome_social) + ''['' + isnull(pac.pac_nome, e.emer_nome) + '']'' else isnull(pac.pac_nome, e.emer_nome) end , '
 set @sql = @sql + 'convert(char(10),e.emer_chegada,103) data, '                          
 set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, E.emer_chegada , getdate()) aberto_horas '                          
                          
     set @sql = @sql + ' FROM Emergencia E '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                          
     set @sql = @sql + '   ON E.emer_codigo = AA.emer_codigo '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '              
     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                          
     set @sql = @sql + ' LEFT JOIN Numero_BE NBE '                          
     set @sql = @sql + '   ON AA.emer_codigo = NBE.emer_codigo '                          
     set @sql = @sql + ' LEFT JOIN PACIENTE PAC'                          
     set @sql = @sql + '   ON E.pac_codigo = pac.pac_codigo '                          
        if @BoletimExtraviado = 'S'                          
            set @sql = @sql + '  where (AC.atendamb_encaminhamento = ''09'') '                          
        else                          
            set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
                               
        set @SQL = @SQL + '   AND E.EMER_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                          
     set @SQL = @SQL + '   AND E.usu_codigo IS NOT NULL '                          
     set @sql = @sql + ' order by E.emer_chegada desc '                          
                          
        execute (@sql)                          
 end                          
                          
  if @oripac_codigo = '5'                          
    begin                              
     set @sql =   ' SELECT  TOP 1000 PA.spa_codigo codigo, convert(char(10),pa.spa_chegada,103) data, '  
	 set @sql = @sql + 'NOME = case when pac.pac_nome_social is not null or pa.spa_nome_social is not null then isnull(pac.pac_nome_social,pa.spa_nome_social) + ''['' + isnull(pac.pac_nome, pa.spa_nome) + '']'' else isnull(pac.pac_nome, pa.spa_nome) end , '                        
        set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, PA.spa_chegada , getdate()) aberto_horas '                          
                          
     set @sql = @sql + ' FROM Pronto_Atendimento PA '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                          
     set @sql = @sql + '   ON PA.spa_codigo = AA.spa_codigo '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '                          
     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                          
     set @sql = @sql + ' LEFT JOIN Numero_PA NPA '                          
     set @sql = @sql + '   ON AA.spa_codigo = NPA.spa_codigo '                          
  set @sql = @sql + ' LEFT JOIN PACIENTE PAC'                          
     set @sql = @sql + '   ON PA.pac_codigo = pac.pac_codigo '                          
                          
        if @BoletimExtraviado = 'S'                          
            set @sql = @sql + ' where (AC.atendamb_encaminhamento = ''09'') '                          
        else                          
            set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
                          
     set @SQL = @SQL + '   AND PA.SPA_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                          
     set @SQL = @SQL + '   AND PA.usu_codigo IS NOT NULL '                          
  set @sql = @sql + ' order by PA.spa_chegada desc '                          
                          
        execute (@sql)                          
    end                          
                    
End                          
                           
set @Erro = @Erro + @@error                          
-- // Retirado - chamado 15175 - Aline Lima - Voltar a como era antes. Sem risco em SPA. Aguardando definições.            
-- DECLARE @valor_pesquisa  varchar(80)                      
--                       
-- Begin                            
--      if @Modalidade = 0                      
--         BEGIN                      
--    if @oripac_codigo = 3                      
--     Begin                      
--      set @valor_pesquisa = 'AND (UCR.upaclaris_risco IN (''4'',''6'')) '                      
--     End                      
--    else if @oripac_codigo = 5                      
--     Begin       set @valor_pesquisa = 'AND ((UCR.upaclaris_risco IN (''2'',''3'')) OR (UPACLARIS_RISCO IS NULL)) '                      
--     End                      
--         END                      
--  else                      
--         BEGIN                      
--    if @oripac_codigo = 3                      
--     Begin                      
--      set @valor_pesquisa = 'AND (UCR.upaclaris_risco IN (''3'',''4'',''6'')) '                      
--     End                      
--    else if @oripac_codigo = 5                      
--     Begin                      
--      set @valor_pesquisa = 'AND ((UCR.upaclaris_risco IN (''2'')) OR (UCR.upaclaris_risco IS NULL)) '                      
--     End                      
--         END                      
--                       
--   set @sql = ' SELECT  TOP 1000 PA.spa_codigo codigo, pa.spa_nome nome, pa.spa_chegada data, '                            
--      set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, PA.spa_chegada , getdate()) aberto_horas '                            
--                             
--      set @sql = @sql + ' FROM Pronto_Atendimento PA '                     
--      set @sql = @sql + ' INNER JOIN UPA_ACOLHIMENTO UA '                      
--      set @sql = @sql + '   ON PA.spa_codigo = UA.spa_codigo '                        
--      set @sql = @sql + ' LEFT JOIN UPA_CLASSIFICACAO_RISCO UCR '                      
--      set @sql = @sql + '   ON UA.ACO_CODIGO = UCR.aco_codigo '                        
--      set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                            
--    set @sql = @sql + '   ON PA.spa_codigo = AA.spa_codigo '                            
--      set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '                            
--      set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                            
--      set @sql = @sql + ' LEFT JOIN Numero_PA NPA '                            
--      set @sql = @sql + '   ON AA.spa_codigo = NPA.spa_codigo '                            
--                             
--         if @BoletimExtraviado = 'S'                            
--             set @sql = @sql + ' where (AC.atendamb_encaminhamento = ''09'') AND (PA.spa_codigo = UA.spa_codigo) ' +  @valor_pesquisa                            
--                       
--                     
--             set @sql = @sql + ' WHERE ((AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null)) AND (PA.spa_codigo = UA.spa_codigo) ' +  @valor_pesquisa                        
--                             
--      set @sql = @sql + '   AND PA.SPA_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                            
--      set @sql = @sql + '   AND PA.usu_codigo IS NOT NULL '                            
--                       
--                       
--     if @oripac_codigo = 3                      
--   begin                      
--    set @sql = @sql + ' UNION '                      
--    set @sql = @sql + ' SELECT  TOP 1000 E.emer_codigo codigo, e.emer_nome nome, e.emer_chegada data, '                            
--    set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, E.emer_chegada , getdate()) aberto_horas '                            
--                             
--    set @sql = @sql + ' FROM Emergencia E '                          
--     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                            
--     set @sql = @sql + '   ON E.emer_codigo = AA.emer_codigo '                            
--     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '   
--     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                            
--     set @sql = @sql + ' LEFT JOIN Numero_BE NBE '                            
--     set @sql = @sql + '   ON AA.emer_codigo = NBE.emer_codigo '                            
--                       
--    if @BoletimExtraviado = 'S'                            
--     set @sql = @sql + '  where (AC.atendamb_encaminhamento = ''09'') '                       
--    else                            
--     set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
--                                   
--    set @sql = @sql + '   AND E.EMER_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                            
--    set @sql = @sql + '   AND E.usu_codigo IS NOT NULL '                       
--                            
--         end                      
--                           
--     set @sql = @sql + ' order by data desc '                         
--                        
--  execute (@sql)                       
-- End                            
--                             
--                              
-- set @Erro = @Erro + @@error                            
--         
                            
-- Alta para uma internaÃ§Ã£o -------------------------------------------------------------------                            
If @Opcao = 22                            
  Begin                            
        
 if exists (select 1 from internacao where inter_codigo = @Inter_Codigo and inter_deobservacao = 'S')        
 begin        
         
  update internacao                            
  set inter_dtalta = @Inter_DtAlta,                            
   inter_motivo_alta = @Inter_Motivo_Alta,                            
   locatend_codigo_resp = @LocAtend_Codigo_Resp,                              
   prof_codigo_resp = @Prof_Codigo_Resp                                
  where inter_codigo = @Inter_Codigo                            
                            
  UPDATE LEITO                            
  SET lei_status = 'L'                            
  WHERE lei_status = 'O'                             
  and not exists                            
   (select 1                             
   from internacao                             
   where inter_dtalta is null                            
   and leito.locatend_codigo = internacao.locatend_LEITO                            
   and leito.lei_codigo = internacao.lei_codigo)                            
               
  Update  internacao_clinica_atual Set              
   interclinica_dtfim = @Inter_DtAlta              
  Where inter_codigo = @inter_codigo              
   and interclinica_dtfim is null              
               
  Update  MOVIMENTACAO_PACIENTE Set              
   movpac_data_saida = @Inter_DtAlta              
  Where inter_codigo = @inter_codigo              
   and movpac_data_saida is null              
              
 end                     
end                            
                
                            
-- Lista de pacientes internados sem alta em determinada clÃ­nica                            
if @opcao = 23                            
begin                            
                            
 select inter_codigo, pac_nome, inter_datainter,                            
  Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + ' ' +                             
  E.enf_codigo_local + '/' + L.lei_codigo LocInt_Descricao, Prof.Prof_Nome                            
 from internacao I                            
  INNER JOIN Paciente P on P.Pac_Codigo=I.Pac_Codigo                            
  INNER JOIN Profissional Prof on Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo                            
  LEFT JOIN Local_Atendimento LA on LA.LocAtend_Codigo=I.LocAtend_Leito                            
  LEFT JOIN Setor_Clinica SL on SL.SetCli_Codigo= LA.SetCli_Codigo                            
  LEFT JOIN Enfermaria E on E.enf_Codigo=LA.enf_codigo                  
  LEFT JOIN Leito L on I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo               
 where I.locatend_codigo_atual = @LocAtend_Codigo_Atual                            
  and inter_dtalta is null                            
  and (I.inter_DeObservacao = 'N' OR I.inter_DeObservacao is null)                            
                              
 order by SL.setCli_descricao,E.enf_codigo_local,L.lei_codigo,pac_nome                             
                            
end                            
                            
----------------------------- Selecao para Carga dos Dados da InternaÃ§Ã£o Aberta ------------------------------                            
If @Opcao = 24                            
 Begin                            
  set @sql =   ' SELECT I.inter_codigo,' -- 0                            
  set @sql = @sql + ' I.inter_datainter,' -- 1                            
  set @sql = @sql + ' I.inter_dtalta,' -- 2                            
  set @sql = @sql + ' I.inter_dtprevista,' -- 3                            
  set @sql = @sql + ' I.inter_motivo_alta,' -- 4                            
  set @sql = @sql + ' ISNULL(MC.motcobunid_descricao,MC_AIH.motcob_descricao) AS MotCob_Descricao,' -- 5                            
  set @sql = @sql + ' I.inter_tipo,' -- 6                            
  set @sql = @sql + ' I.pedint_sequencial,' -- 7                           
  set @sql = @sql + ' I.lei_codigo,' -- 8                            
  set @sql = @sql + ' I.locatend_codigo,' -- 9                            
  set @sql = @sql + ' S.SetCli_Descricao Descricao_LocAtend_Codigo,' -- 10                            
  set @sql = @sql + ' I.locatend_codigo_atual,' -- 11                            
  set @sql = @sql + ' S2.SetCli_Descricao Descricao_LocAtend_Codigo_Atual,' -- 12                            
  set @sql = @sql + ' I.locatend_leito,' -- 13                            
  set @sql = @sql + ' S3.SetCli_Descricao Descricao_LocAtend_Leito,' -- 14                            
  set @sql = @sql + ' I.pac_codigo,' -- 15                            
  set @sql = @sql + ' P.Pac_Nome, ' -- 16                            
  set @sql = @sql + ' PP.Pac_Prontuario_Numero Pac_Prontuario,' -- 17                            
  set @sql = @sql + ' P.Pac_Sexo,' -- 18                            
  set @sql = @sql + ' I.prof_codigo,' -- 19                            
  set @sql = @sql + ' Prof.Prof_Nome,' -- 20                            
  set @sql = @sql + ' I.emer_codigo,' -- 21                            
  set @sql = @sql + ' I.estpac_codigo,' -- 22                            
  set @sql = @sql + ' EP.EstPac_Descricao,' -- 23                            
  set @sql = @sql + ' I.estpac_codigo_atual,' -- 24                            
  set @sql = @sql + ' EP2.EstPac_Descricao EstPac_Descricao_Atual,' -- 25                            
  set @sql = @sql + ' Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + '' '' + E3.enf_codigo_local + ''/'' + L.lei_codigo LocInt_Descricao,' --26                            
  set @sql = @sql + ' I.Inter_Data_Cid,' -- 27                            
  set @sql = @sql + ' I.Inter_Data_Cid_Secundario,' -- 28                            
  set @sql = @sql + ' PID.INTER_PID_CODIGO,' -- 29                            
   set @sql = @sql + ' L.Lei_Tipo,' -- 30                               
  set @sql = @sql + ' I.Inter_hipdiag,' --31                             
  set @sql = @sql + ' I.spa_codigo,' --32                             
  set @sql = @sql + ' BE.emer_numero_be,' --32                            
  set @sql = @sql + ' PA.spa_numero_pa,' --32                            
  set @sql = @sql + ' I.inter_DeObservacao, '                            
  set @sql = @sql + ' I.prof_codigo_Resp, '    
  set @sql = @sql + ' i.inter_motivo_alta_descricao, '              
  set @sql = @sql + ' ProfResp.Prof_Nome Prof_Nome_Resp, ' -- 20
  set @sql = @sql + ' PI.leitoRegulado,'
  set @sql = @sql + ' PI.numAutorizacao ' 
                            
  set @sql = @sql +' FROM  Internacao I'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_Unidade MC'                            
  set @sql = @sql +' ON   (MC.MotCob_Codigo=I.Inter_Motivo_Alta)'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_AIH MC_AIH'                            
  set @sql = @sql +' ON   (MC_AIH.MotCob_Codigo=I.Inter_Motivo_Alta)'                           
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA'                            
  set @sql = @sql +' ON   (LA.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN  Setor_Clinica S'                             
  set @sql = @sql +' ON   (S.SetCli_Codigo=LA.SetCli_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA2'                            
  set @sql = @sql +' ON   (LA2.LocAtend_Codigo=I.LocAtend_Codigo_Atual)'                            
                            
  set @sql = @sql +' INNER JOIN Setor_Clinica S2'                            
  set @sql = @sql +' ON  (S2.SetCli_Codigo=LA2.SetCli_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Local_Atendimento LA3'                            
  set @sql = @sql +' ON  (LA3.LocAtend_Codigo=I.LocAtend_Leito)'                            
                            
  set @sql = @sql +' LEFT JOIN Enfermaria E3'                            
  set @sql = @sql +' ON  (E3.enf_Codigo=LA3.enf_codigo)'         
                            
  set @sql = @sql +' LEFT JOIN Setor_Clinica S3'        set @sql = @sql +' ON   (S3.SetCli_Codigo=LA3.SetCli_Codigo)'                            
                            
set @sql = @sql +' LEFT JOIN Setor_Clinica SL'                            
  set @sql = @sql +' ON (SL.SetCli_Codigo= La3.SetCli_Codigo)'                            
                            
  set @sql = @sql +'INNER JOIN Paciente P'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=I.Pac_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Paciente_Prontuario PP'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''')'                              
                            
  set @sql = @sql +' INNER JOIN Profissional Prof'                            
  set @sql = @sql +' ON  (Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Profissional_Rede ProfResp'                            
  set @sql = @sql +' ON  (ProfResp.Prof_Codigo=I.prof_codigo_Resp)'                            
                              
  set @sql = @sql +' INNER JOIN Estado_Paciente EP'                            
  set @sql = @sql +' ON  (EP.EstPac_Codigo=I.EstPac_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Estado_Paciente EP2'                            
  set @sql = @sql +' ON  (EP2.EstPac_Codigo=I.EstPac_Codigo_Atual)'                            
                            
  set @sql = @sql +' LEFT JOIN Leito L'                            
  set @sql = @sql +' ON   (I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Internacao_Pid PID'                            
  set @sql = @sql +' ON  (PID.Inter_Codigo = I.Inter_Codigo)'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_BE BE'                            
  set @sql = @sql + ' ON  I.emer_codigo = BE.emer_codigo'              
                            
  set @sql = @sql + ' LEFT JOIN Numero_PA PA'                            
  set @sql = @sql + ' ON  I.spa_codigo = PA.spa_codigo' 
  
  set @sql = @sql + ' LEFT JOIN Pedido_Internacao PI'                            
  set @sql = @sql + ' ON  PI.PedInt_Sequencial = I.PedInt_Sequencial'                             
                            
                                 
  set @sql = @sql +' WHERE i.inter_dtalta is null and '                            
                            
  if @inter_codigo is not null                      
   set @sql = @sql + ' I.Inter_Codigo  = ''' + @Inter_Codigo   + '''   and'                            
                              
  if @pedint_sequencial is not null                            
   set @sql = @sql + ' I.PedInt_Sequencial = ''' + @PedInt_Sequencial  + '''   and'               
                              
  if @Pac_Codigo is not null                            
   set @sql = @sql + ' I.Pac_Codigo  = ''' + @Pac_Codigo   + '''   and'                            
                      
                            
  set @sql = @sql  + ' LA.UNID_CODIGO  = ''' + @Unid_Codigo   + '''   and'                            
                             
  set @sql = left(@sql, len (@sql)-5)                            
                              
  set @sql = @sql + ' ORDER BY PID.Inter_Pid_codigo, I.Inter_DataInter DESC'                            
                              
  exec (@sql)                            
                            
 End                            
                      
If @Opcao = 25                      
Begin                      
                       
 Select @LocInt_Descricao = LocInt_Descricao,                      
   @LEI_TIPO = vw.Lei_Tipo,                      
   @inter_codigo = i.inter_codigo,                      
   @inter_DeObservacao = inter_DeObservacao,                    
   @LocAtend_Codigo = vw.locatend_codigo,                  
   @Inter_DtAlta = i.inter_DtAlta                  
                  
                   
 From internacao i, vwLeito vw                      
 Where i.pac_codigo = @Pac_Codigo                
 And  I.Inter_DtAlta Is NULL                                  
 And  i.locatend_leito = vw.locatend_codigo                      
 And  i.lei_codigo  = vw.lei_codigo                      
 And  vw.unid_codigo          = @unid_codigo                      
                      
 if (@inter_codigo is not null)                      
  Select  @LocInt_Descricao  LocInt_Descricao,                       
   @LEI_TIPO  Lei_Tipo,                      
   @inter_codigo  inter_codigo,                      
   ISNULL(@inter_DeObservacao, 'N')  inter_DeObservacao,           
   @locatend_codigo locatend_codigo,                     
   @Inter_DtAlta  inter_DtAlta                  
                      
End                            
       
  
IF(@OPCAO = 26)                            
BEGIN  
  
IF(@PROF_CODIGO IS NOT NULL)  
BEGIN  
  select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as PAC_NOME,                                                 
  null as localAtendimento,      
  localInternacao.set_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as PAC_PRONTUARIO,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo and ue.prof_codigo_origem = @PROF_CODIGO) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  ,CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
   CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
   CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
                   
  from                                                                            
   internacao i                                                             
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo  
   LEFT JOIN (    
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
  from vwsolicitacao_pedido vsp2     
   inner join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
  where (esl.exasollab_status  in ('LA','LI')) --and vsp2.oripac_codigo = 5     
  group by solped_CodigoOrigem    
   ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
   
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/ AND VSP.solped_TipoSolicitacao = '8'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/	and VSP.solped_TipoSolicitacao = '9'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
  where                                                                   
   i.inter_dtalta IS NULL                  
   AND profInternacao.prof_codigo = @Prof_Codigo  
   and i.locatend_codigo_atual = @LocAtend_Codigo_Atual  
   --and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo     
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)  
order by PAC_NOME  
END  
ELSE  
BEGIN  
 select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as PAC_NOME,                                                 
  null as localAtendimento,      
  localInternacao.set_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as pac_prontuario,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  ,CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
   CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
   CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
  from                                                                            
   internacao i                                                             
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo
   LEFT JOIN (    
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
  from vwsolicitacao_pedido vsp2     
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
  where (esl.exasollab_status  in ('LA','LI'))     
  group by solped_CodigoOrigem    
   ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
   
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L'  AND VSP.solped_TipoSolicitacao = '8'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' and VSP.solped_TipoSolicitacao = '9'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM      
  where                                                                   
   i.inter_dtalta IS NULL                  
   and i.locatend_codigo_atual = @LocAtend_Codigo_Atual  
   --and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo   
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)       
order by PAC_NOME  
END  
  
END                    

IF(@OPCAO = 27)
IF(@OPCAO = 27)
BEGIN

  Select                            
	I.*,
	L.set_descricao AS Descricao_LocAtend_Codigo,
	P.PROF_NOME,
	e.unid_codigo
  From Internacao   I                            
	INNER JOIN VWLOCAL_UNIDADE L ON I.LOCATEND_CODIGO = L.LOCATEND_CODIGO
	INNER JOIN PROFISSIONAL P ON (I.LOCATEND_CODIGO = P.LOCATEND_CODIGO AND I.PROF_CODIGO = P.PROF_CODIGO)
	LEFT JOIN EMERGENCIA E ON I.EMER_CODIGO = E.EMER_CODIGO
      Where   I.PAC_CODIGO = @PAC_CODIGO
      --AND EXISTS (SELECT 1 FROM SOAP WHERE INTER_CODIGO = I.INTER_CODIGO)
END   

IF(@OPCAO = 28)
BEGIN

	SELECT 
		i.inter_codigo,
		P.pac_nome,
			i.inter_dtalta
	FROM
		Internacao i inner join vwLeito l on I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO  
		INNER JOIN PACIENTE P ON (I.PAC_CODIGO = P.PAC_CODIGO)
	WHERE
		L.PST_CODIGO = isnull(@pstCodigo, L.PST_CODIGO)
		AND L.ENF_CODIGO_CHAVE = ISNULL(@enfCodigo, L.ENF_CODIGO)
	ORDER BY P.pac_nome

END

IF(@OPCAO = 29)
BEGIN

	SELECT 
		i.inter_codigo,
		i.inter_dtalta as DataAlta,
		P.pac_nome as Nome,
		CASE 
			WHEN P.pac_sexo = 'M' THEN 'Masculino'
			WHEN P.pac_sexo = 'F' THEN 'Feminino'
		END Sexo,
		pac_mae as NomeMae,
		pac_nascimento as DataNascimento,
		CONVERT(VARCHAR,ISNULL(((cast(DateDiff(dd,p.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, p.pac_nascimento, getdate()) as int) / 4)) / 365 ), p.pac_idade)) + ' Anos' as idade,
		Pac_Prontuario_Numero as Prontuario,
		DATEDIFF(day, I.inter_datainter, ISNULL(i.inter_dtalta,getdate())) as DiasInternados
	FROM
		Internacao i INNER JOIN PACIENTE P ON (I.PAC_CODIGO = P.PAC_CODIGO) 
		LEFT JOIN PACIENTE_PRONTUARIO PP ON (P.PAC_CODIGO = PP.PAC_CODIGO)
	WHERE
		p.pac_nome like @Pac_Nome + '%'
	ORDER BY P.pac_nome

END

IF(@OPCAO = 30) -- opcao em que procuramos se há internacoes a serem consolidadas (ao se criar a entidade espelho_aih)
BEGIN
	CREATE TABLE #Temp1 ( inter_codigo char(12),inter_datainter smalldatetime, inter_dtalta smalldatetime, pac_codigo char(12),proc_codigo char(10),cid_codigo char(9))

insert into #Temp1 (inter_codigo,inter_datainter,inter_dtalta,pac_codigo,proc_codigo,cid_codigo)
	select i.inter_codigo,i.inter_datainter,i.inter_dtalta,i.pac_codigo,ped.proc_codigo,ped.cid_codigo from internacao i
	inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
	where i.inter_codigo = @Inter_Codigo

	declare @dt_inter as smalldatetime
	declare @dt_inter_ultimo as smalldatetime
	DECLARE @dt_alta as smalldatetime
	
	SELECT @dt_inter = inter_datainter, @dt_inter_ultimo = inter_datainter FROM #Temp1


-- olho se há internacoes pra trás
	WHILE (@dt_inter is not null)
	BEGIN
			select top 1 @dt_inter = i.inter_datainter,@dt_alta = i.inter_dtalta,@Inter_Codigo =i.inter_codigo from internacao i --,@inter_codigo = min(i.inter_codigo)
			inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
			inner join #Temp1 on i.pac_codigo = #Temp1.pac_codigo and ped.proc_codigo = #Temp1.proc_codigo and ped.cid_codigo = #Temp1.cid_codigo
			left join espelho_aih ea on #Temp1.inter_codigo = ea.inter_codigo
			where
			i.inter_dtalta > DATEADD(HH,-@oripac_codigo,@dt_inter) and i.inter_datainter < @dt_inter and i.inter_codigo not in(select t.inter_codigo from #Temp1 as t)
			and isnull(ea.Aih_Status,'') <> '4'  and ea.aih_numero is null
			order by i.inter_datainter desc

		
		IF (@dt_inter <> @dt_inter_ultimo)
		BEGIN
			insert into #Temp1(inter_codigo,inter_datainter,inter_dtalta) select @inter_codigo,@dt_inter,@dt_alta where @inter_codigo not in(select inter_codigo from #Temp1)
			set @dt_inter_ultimo = @dt_inter
		END
		else
		begin
			set @dt_inter = null
		end
	END

	-- agora vou procurar pra frente


	DECLARE @dt_alta_ultimo as smalldatetime

	DECLARE @inter_codigo_alta as char(12)
	SELECT @dt_alta = max(inter_dtalta), @dt_inter = max(inter_datainter),  @dt_alta_ultimo = max(inter_dtalta) FROM #Temp1

	WHILE(@dt_alta is not null)
	BEGIN
			
			select @dt_alta = i.inter_dtalta,@dt_inter = i.inter_datainter,@inter_codigo = i.inter_codigo from internacao i --,@inter_codigo_alta = max(i.inter_codigo)
			inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
			inner join #Temp1 on i.pac_codigo = #Temp1.pac_codigo and ped.proc_codigo = #Temp1.proc_codigo and ped.cid_codigo = #Temp1.cid_codigo
			left join espelho_aih ea on #Temp1.inter_codigo = ea.inter_codigo
			where
			i.inter_datainter < DATEADD(HH,@oripac_codigo,@dt_alta) and i.inter_datainter > @dt_inter and i.inter_codigo not in(select t.inter_codigo from #Temp1 AS t)
			and isnull(ea.Aih_Status,'') <> '4'  and ea.aih_numero is null
			
			
			IF (@dt_alta <> @dt_alta_ultimo)
			BEGIN
				insert into #Temp1(inter_codigo,inter_dtalta,inter_datainter) select @inter_codigo,@dt_alta,@dt_inter 
				set @dt_alta_ultimo = @dt_alta
			END
			ELSE
			BEGIN
				SET @dt_alta = NULL
			END
	END



	SELECT inter_codigo,inter_datainter,inter_dtalta FROM #Temp1 order by inter_codigo
	

	DROP TABLE #Temp1



END

--retorna as ultimas internacoes para exibir na masterpage
IF(@OPCAO = 31)
BEGIN

select top 5	i.inter_codigo, 
				i.inter_datainter, 
				i.inter_dtalta, 
				(select count(1) from internacao_pep ip where i.inter_codigo = ip.inter_codigo) as total_internacao_pep
from internacao i 
where i.pac_codigo = @pac_codigo
order by i.inter_datainter desc

END

IF (@Opcao = 32)
BEGIN 
	select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  p.pac_nome as PAC_NOME,                                                 
  null as localAtendimento,      
  sc.setCli_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as pac_prontuario,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  from                                                                            
   internacao i                                                             
   inner join local_atendimento la on  la.locatend_codigo = i.locatend_leito                                                                    
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   inner join vwenfermaria e on l.locatend_codigo = e.locatend_codigo and l.enf_codigo = e.enf_codigo 
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo     
   inner join setor_clinica sc on la.SETCLI_CODIGO = sc.setCli_Codigo
  where                                                                   
   i.inter_dtalta IS NULL                  
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)       
   and exists (select 1 from Internacao_Pep ip where ip.inter_codigo = i.inter_codigo)
   and e.LOCATEND_CODIGO_CLINICA = isnull(@LocAtend_Codigo, e.LOCATEND_CODIGO_CLINICA)
   and l.enf_codigo_chave = isnull(@enfCodigo, l.enf_codigo_chave)
order by PAC_NOME 
	
END


--######################MAPA_EVOLUÇÃO###########################
IF (@Opcao = 33)
BEGIN
 	set @sql =   ' Select vwEnf.LocAtend_Descricao, '  
    set @sql = @sql +'    vwLei.LocAtend_Codigo, ' 
	set @sql = @sql +'    vwLei.Lei_Codigo, ' 
	set @sql = @sql +'    vwLei.LocInt_Descricao, '  
	set @sql = @sql +'    vwEnf.Enf_Codigo, '  
	set @sql = @sql +'    vwLei.Lei_Status, '  
	set @sql = @sql +'    I.Inter_Codigo, '  
	set @sql = @sql +'    I.Pac_Codigo, '  
	set @sql = @sql +'    case when p.pac_nome_social is null then p.pac_nome else rtrim(p.pac_nome_social) +''[''+rtrim(p.pac_nome)+'']'' end Pac_Nome, '  
	set @sql = @sql +'    PP.Pac_Prontuario_Numero Pac_Prontuario, '   
	set @sql = @sql +'    vwLei.Lei_Tipo, '   
	set @sql = @sql +'    LA.set_descricao Clinica_Paciente,'   
	set @sql = @sql +'    I.inter_DeObservacao, '  
	set @sql = @sql +'    I.inter_datainter, '
	set @sql = @sql + '   proc_tempo, '
	set @sql = @sql +'    I.emer_codigo, '
	set @sql = @sql +'    I.spa_codigo, ' 

	set @sql = @sql +' (select case when (DATEPART(HOUR, max(e.upaevo_datahora)) > 7) then ''R'''
    set @sql = @sql +'          else ''P'' end from UPA_Evolucao e, Profissional_Lotacao pl'
    set @sql = @sql +' where e.atendamb_codigo = AA.atendamb_codigo '
	set @sql = @sql +'     and CONVERT(varchar(12),e.upaevo_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101)'
	set @sql = @sql +'and pl.prof_codigo = e.prof_codigo and pl.tipprof_codigo = ''0001'' and pl.prof_ativo = ''S'') evoMedico, '
	 
	 set @sql = @sql +' (select Case when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr ' 
	 set @sql = @sql +'  left join Prescricao_Procedimento_Complementar ppc on ppc.atendamb_codigo = aa.atendamb_codigo ' 
	 set @sql = @sql +'  where  pr.usu_codigo = ppc.usu_codigo and pr.prof_codigo = pl.prof_codigo and pl.tipprof_codigo = ''0013'' and pl.prof_ativo = ''S'' '
	 set @sql = @sql +' and CONVERT(varchar(12),ppc.data, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +' having (DATEPART(HOUR, max(ppc.data)) > 7)) = 1 then ''R'' ' 
	 set @sql = @sql +' when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr '
	 set @sql = @sql +'  left join Controle_Sinais_Vitais_Balanco_Hidrico csv on (i.inter_codigo = csv.inter_codigo or i.spa_codigo = csv.spa_codigo or i.emer_codigo = csv.emer_codigo) '
	 set @sql = @sql +'  where CONVERT(varchar(12),csv.cosb_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +'  and pl.prof_codigo = csv.codProfissional and pl.tipprof_codigo = ''0013'' and pl.prof_ativo = ''S'' ' 
	 set @sql = @sql +' having (DATEPART(HOUR, max(csv.cosb_datahora)) > 7)) = 1 then ''R'' else ''P''end) evoTecEnf, '
	 	
     set @sql = @sql +' (select Case when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr ' 
	 set @sql = @sql +'  left join Prescricao_Procedimento_Complementar ppc on ppc.atendamb_codigo = aa.atendamb_codigo ' 
	 set @sql = @sql +'  where  pr.usu_codigo = ppc.usu_codigo and pr.prof_codigo = pl.prof_codigo and pl.tipprof_codigo = ''0002'' and pl.prof_ativo = ''S'' '
	 set @sql = @sql +' and CONVERT(varchar(12),ppc.data, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +' having (DATEPART(HOUR, max(ppc.data)) > 7)) = 1 then ''R'' ' 
	 set @sql = @sql +' when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr '
	 set @sql = @sql +'  left join Controle_Sinais_Vitais_Balanco_Hidrico csv on (i.inter_codigo = csv.inter_codigo or i.spa_codigo = csv.spa_codigo or i.emer_codigo = csv.emer_codigo) '
	 set @sql = @sql +'  where CONVERT(varchar(12),csv.cosb_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +'  and pl.prof_codigo = csv.codProfissional and pl.tipprof_codigo = ''0002'' and pl.prof_ativo = ''S'' ' 
	 set @sql = @sql +' having (DATEPART(HOUR, max(csv.cosb_datahora)) > 7)) = 1 then ''R'' else ''P''end)evoEnfe,'
	 
	set @sql = @sql +' (select case when (DATEPART(HOUR, max(ss.upasersoc_DataHora)) > 7) then ''R'''
    set @sql = @sql +'          else ''P'' end from UPA_Servico_Social ss'
    set @sql = @sql +' where isnull(ss.spa_codigo, ss.emer_codigo) = isnull(aa.spa_codigo, aa.emer_codigo) '
	--set @sql = @sql +' where ss.spa_codigo = aa.spa_codigo '
	set @sql = @sql +'     AND CONVERT(varchar(12), ss.upasersoc_DataHora, 101) = CONVERT(varchar(12), GETDATE(), 101)) evoAssisSoc,' 

	set @sql = @sql +'case when aa.atendamb_datafinal is not null then ''R'' else ''P'' end evoNIR,' 

	set @sql = @sql +'   case when datediff(hour, convert(datetime, I.inter_datainter, 120),  convert(datetime, isnull(I.inter_dtalta,getdate()), 120)) > 24'
	set @sql = @sql +'		  then ''SIM'' else ''NÃO'' end obs_dia,'
	set @sql = @sql +'	 AA.atendamb_codigo, '
	set @sql = @sql +' I.locatend_codigo locatend_inter '
	set @sql = @sql +'   From vwLeito  vwLei '
	set @sql = @sql +'   inner join vwEnfermaria vwEnf on VWLEI.LocAtend_Codigo = vwEnf.LocAtend_Codigo '
	set @sql = @sql +'   left join Internacao I on I.LocAtend_Leito = vwLei.LocAtend_Codigo  '
	set @sql = @sql +'             and I.Lei_Codigo = vwLei.Lei_Codigo '
	set @sql = @sql +'			   and I.Inter_DtAlta Is Null '
    set @sql = @sql +'   left join vwLocal_unidade LA on I.locatend_Codigo_atual = la.LocAtend_Codigo '
	set @sql = @sql +'   Left join Pedido_Internacao Ped_Int on I.pedint_sequencial = Ped_int.pedint_sequencial' 
	set @sql = @sql +'   Left join procedimento proced on Ped_Int.proc_codigo = proced.proc_codigo' 
	set @sql = @sql +'   INNER JOIN PACIENTE P ON P.pac_codigo = I.pac_codigo'
	set @sql = @sql + ' LEFT JOIN Paciente_Prontuario PP ON P.Pac_Codigo = PP.Pac_Codigo '
	set @sql = @sql + ' INNER JOIN atendimento_ambulatorial AA ON ISNULL(AA.spa_codigo, AA.emer_codigo) = ISNULL(I.spa_codigo, I.emer_codigo) AND AA.pac_codigo = I.pac_codigo  AND AA.locatend_codigo = I.locatend_codigo'
set @sql = @sql +' Where 1 = 1' 
 set @sql = @sql +'And aa.atendamb_datafinal is null And vwLei.unid_codigo = ' + '''' + @Unid_Codigo + '''' 
 IF @Set_Codigo IS NOT NULL
 BEGIN
  set @sql = @sql +' And vwenf.locatend_Codigo_clinica = ' + '''' + @Set_Codigo + '''' 
 END 
 IF @LocAtend_Leito IS NOT NULL
 BEGIN
	set @sql = @sql + ' And vwLei.LocAtend_Codigo  = ' + '''' + @LocAtend_Leito + ''''
 END
 IF @Spa_Codigo IS NOT NULL
 BEGIN
   set @sql = @sql +' And I.spa_codigo = ' + '''' + @Spa_Codigo +''''
 END
 IF @Emer_Codigo IS NOT NULL
 BEGIN
	set @sql = @sql +' And I.emer_codigo =' + '''' +  @Emer_Codigo +'''' 
 END
 IF @Pac_Codigo IS NOT NULL
 BEGIN
   set @sql = @sql + ' And I.Pac_Codigo = ' + '''' + @Pac_Codigo +''''
 END
 IF @AtendAmb_Codigo IS NOT NULL
 BEGIN
  set @sql = @sql +' And AA.atendamb_codigo = ' + '''' + @AtendAmb_Codigo +''''
 END
  set @sql = @sql +'and inter_DeObservacao = ''S'' And not exists (select 1 from enfermaria e where e.enf_codigo = vwEnf.Codigo_Enfermaria and e.enf_operacional = ''N'') ' 

  set @Erro = @Erro + @@error                        
  --print(@sql)                      
  Exec(@sql) 

END

IF (@Opcao = 34)
BEGIN
	select i.inter_codigo
	from internacao i
	inner join leito l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
	where i.inter_codigo = @Inter_Codigo
	and l.lei_tipo = 2 -- tipo UTI

end

IF (@Opcao = 35)
BEGIN
	if (@PacNomeProntuario is not null or @locatend_codigo_atual is not null)
	begin 
		set @Prof_codigo = null;
	end

	select                          
		l.pst_codigo as POSTO,                                                                    
		null as spa_codigo,          
		null as emer_codigo,                                                                       
		case when p.pac_nome_social is not null 
			then p.pac_nome_social + ' [' + p.pac_nome + '] - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')
			else p.pac_nome + ' - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')
		end as PAC_NOME,                                                 
		null as localAtendimento,      
		localInternacao.set_descricao as localInternacao,                                                                      
		LocInt_Descricao  as leito,                                                                      
		i.inter_codigo as inter_codigo,                                                                      
		null as profAtendimento,       
		profInternacao.prof_nome as profInternacao,                                                                      
		null as upaclaris_risco,                                                                   
		null as tipoSaidaAmbulatorio,                                                      
		null AS SITUACAO,                                                               
		null as upaatemed_encaminhamentoEixo,      
		null as upaclaris_risco,      
		null as atendimentoRealizado,                                                                    
		null as ordenacao,    
		pp.Pac_Prontuario_Numero as PAC_PRONTUARIO,  
		I.inter_datainter, 
		case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo and ue.prof_codigo_origem = isnull(@PROF_CODIGO, ue.prof_codigo_origem)) then 'Parecer' end as Parecer,
		case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
		--case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
		case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr,
		CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
		CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
		CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
                   
	from                                                                            
		internacao i                                                             
		inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
		inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
		inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
		inner join paciente p on i.pac_codigo = p.pac_codigo        
		left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
		inner JOIN unidade u on u.unid_codigo = l.unid_codigo  
		LEFT JOIN (    
		SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
		from vwsolicitacao_pedido vsp2     
		 inner join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
		where (esl.exasollab_status  in ('LA','LI')) --and vsp2.oripac_codigo = 5     
		group by solped_CodigoOrigem    
		 ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
		 
		 LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
				FROM VWSOLICITACAO_PEDIDO VSP
				WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/ AND VSP.solped_TipoSolicitacao = '8'
				GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

		 LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
				FROM VWSOLICITACAO_PEDIDO VSP
				WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/	and VSP.solped_TipoSolicitacao = '9'
				GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
		where                                                                   
		i.inter_dtalta IS NULL                  
		AND profInternacao.prof_codigo = isnull(@Prof_Codigo, profInternacao.prof_codigo)
		and i.locatend_codigo_atual = isnull(@locatend_codigo_atual, i.locatend_codigo_atual) 
		and (@PacNomeProntuario is null
		     or p.pac_nome like '%' + @PacNomeProntuario + '%'
			 or p.pac_nome_social like '%' + @PacNomeProntuario + '%'
			 or pp.Pac_Prontuario_Numero like '%' + @PacNomeProntuario + '%')
		and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)  
	order by PAC_NOME  
END



SET NOCOUNT OFF                            
                            
if (@ErroConcorrenciaLeito = 1)                            
       Begin          
          RAISERROR('ERRO - 9. Tabela de Internacao. O leito nÃ£o estaÂ¡ disponÃ­vel para internaÃ§Ã£o!',1,1)                            
                                       
       End                            
Else                            
 Begin                            
                            
  If (@Erro <> 0)                            
         Begin                            
            RAISERROR('ERRO - Tabela de InternaÃ§Ã£o.',1,1)                            
         End                            
                            
 End
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
ALTER PROCEDURE [dbo].[ksp_UPA_FILA]    
@UNID_CODIGO CHAR (4), @LOCATEND_CODIGO CHAR (4), @PROF_CODIGO CHAR (4), @SPA_CODIGO VARCHAR (12)    
, @EMER_CODIGO VARCHAR (12)=null, @ACO_CODIGO VARCHAR (12), @DESTINO VARCHAR (100), @ORIGEM CHAR (1)    
, @RISCO INT, @OPCAO INT, @DATA_INICIAL VARCHAR (20)=NULL, @DATA_FINAL VARCHAR (20)=NULL    
, @CANCELADOS CHAR (1)='S', @DATA_CANCELAMENTO VARCHAR (20)=NULL    
, @USUARIO_CODIGO CHAR (4)=NULL, @TP_PESQ INT=NULL, @SPA_NOME VARCHAR (50)=NULL    
, @PAC_CODIGO CHAR (12)=null, @periodo INT=1, @ATENDAMB_CODIGO CHAR (12)=NULL    
, @PST_CODIGO CHAR (4)=NULL, @ID_EVENTO INT=11, @ENF_CODIGO CHAR (4)=NULL    
, @ATEND_CODIGO VARCHAR (12)=NULL, @AGD_SEQUENCIAL CHAR (12)=NULL, @FILTRODIAS INT=null    
,  @JUSTIFICATIVA VARCHAR (500)=NULL, @NOMESOCIAL VARCHAR(70) = NULL, @PacNomeProntuario varchar(100) = null    
AS    
if @periodo = 0  OR @periodo = 365                                                     
  set @periodo = 30                                                     
                                       
 DECLARE @SEQUENCIAL_SEMRISCO INT                                                            
 DECLARE @PRIMEIRO_SEQUENCIAL_COM_RISCO_1_2_3 INT                                                            
 DECLARE @PROXIMO_SEQUENCIAL_MESMO_RISCO INT                                                                    
 DECLARE @RISCO_ATUAL CHAR(1)                                                                    
 DECLARE @LOCAL_DESTINO VARCHAR(50)                                                                    
 DECLARE @ESPECIALIDADE_CODIGO VARCHAR(4)                                                                    
 DECLARE @WSPA_CODIGO          VARCHAR(12)                                                                    
 DECLARE @FLUXO_ATENDIMENTO CHAR(1)                                                          
 DECLARE @USA_ACOLHIMENTO CHAR(1)                                                          
 DECLARE @ETAPA_CLASSIFICACAO CHAR(1)                                                          
                                                           
 SELECT @FLUXO_ATENDIMENTO = FLUXO_ATENDIMENTO                                                           
 FROM UNIDADE WHERE UNID_CODIGO = @UNID_CODIGO                                                          
                                                           
 SELECT @USA_ACOLHIMENTO = UNID_USA_ACOLHIMENTO                                                           
 FROM UNIDADE WHERE UNID_CODIGO = @UNID_CODIGO                                                          
                                                           
 SELECT @ETAPA_CLASSIFICACAO = UNID_ETAPA_CLASSIFICACAO                                                           
 FROM UNIDADE WHERE UNID_CODIGO = @UNID_CODIGO                                                          
                                                                     
 -- LOCAL ONDE O PACIENTE ESTÃƒÆ’Ã‚Â SENDO CHAMADO, RECEBIDO OU ATENDIDO                                                                    
 SELECT @LOCAL_DESTINO=DESTINO                                                                    
 FROM UPA_FILA                                                                    
 WHERE ACO_CODIGO = @ACO_CODIGO                                                                    
 IF (@LOCAL_DESTINO IS NULL)                                                                    
 BEGIN                                                                    
  SET @LOCAL_DESTINO = SUBSTRING(@DESTINO, 1, 30)                                                             
 END                                                                    
                                                                     
 -- ESPECIALIDADE MEDICA                                                                    
 IF (@ACO_CODIGO IS NOT NULL)                     
 BEGIN                                                                    
                       
   SELECT @WSPA_CODIGO=SPA_CODIGO                   
   FROM UPA_ACOLHIMENTO                                                                    
   WHERE ACO_CODIGO = @ACO_CODIGO                                                                    
                                                    
   IF (@WSPA_CODIGO IS NOT NULL)               
   BEGIN                                                                    
                                                   
   SELECT @ESPECIALIDADE_CODIGO=L.LOCATEND_CODIGO                                                              
   FROM PRONTO_ATENDIMENTO A                        
    INNER JOIN VWLOCAL_UNIDADE L ON (A.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                         
   WHERE A.SPA_CODIGO = @WSPA_CODIGO                                                       
   END                                                                    
   ELSE                                                              
   BEGIN                                                                    
  SELECT @ESPECIALIDADE_CODIGO=L.LOCATEND_CODIGO                                         
  FROM UPA_ACOLHIMENTO A                                                                    
   INNER JOIN VWLOCAL_UNIDADE L ON (A.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                                    
  WHERE A.ACO_CODIGO = @ACO_CODIGO                                                                
   END                                                                    
 END                                               
 ELSE                                                                    
 BEGIN                            SET @ESPECIALIDADE_CODIGO = NULL                                                                    
 END                                                                    
                                                                     
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- SELECIONA TODA A FILA                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 0                                                               
 BEGIN                                                                    
    SELECT FA.ACO_CODIGO,                                                     
    case when fa.nomesocial is null then FA.NOME    
 else FA.NOMESOCIAL + '[' + FA.NOME + ']'  end as "NOME",                                                                   
    FA.RISCO,                                                                    
    LA.SET_DESCRICAO  AS LOC_DESCRICAO,                                                                    
    FA.ACO_DATAHORA AS DATAHORA,                                                            
    FA.SEQUENCIAL           FROM VWUPA_FILA_ACOLHIMENTO FA                                                                     
  INNER JOIN VWLOCAL_ATENDIMENTO LA   ON FA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                                                            
  WHERE LA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LA.LOCATEND_CODIGO)                                                            
    AND LA.UNID_CODIGO = @Unid_Codigo                                                             
  ORDER BY FA.RISCO DESC, FA.ACO_IDOSO DESC, FA.PRIORIDADE DESC, FA.ACO_CODIGO ASC                                                                     
 END                                                                    
                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                     
 -- SALVAR                                           
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 1                                                                    
 BEGIN                                                              
 -- RECUPERA O PROXIMO SEQUENCIAL DA FILA DOS MESMO RISCO                              
 SELECT  @PROXIMO_SEQUENCIAL_MESMO_RISCO=(ISNULL(MAX(SEQUENCIAL), 0) + 1)                                                                    
 FROM  VWUPA_FILA                                                                    
 WHERE  RISCO = @RISCO                                                                    
                                                           
 -- CORRIGE O PROXIMO SEQUENCIAL DA FILA DOS MESMO RISCO, CASO NAO EXISTA NINGUEM                                                                  
 -- COM O MESMO RISCO, PEGANDO UM RISCO SUPERIOR                      
 IF (@PROXIMO_SEQUENCIAL_MESMO_RISCO = 1)                                                                  
 BEGIN                                                                  
  SELECT  @PROXIMO_SEQUENCIAL_MESMO_RISCO=(ISNULL(MAX(SEQUENCIAL), 0) + 1)                                                                  
  FROM  VWUPA_FILA                                                                  
  WHERE  RISCO > @RISCO                                                                  
 END                                                                  
                                                             
  IF (@ACO_CODIGO IS NOT NULL)                                                                  
  BEGIN                                                                  
                                                            
    SELECT @WSPA_CODIGO=SPA_CODIGO                                              
    FROM UPA_ACOLHIMENTO                                                                  
    WHERE ACO_CODIGO = @ACO_CODIGO                                                                  
                                           
    IF (@WSPA_CODIGO IS NOT NULL)                                                                  
    BEGIN                                                                
   SELECT @RISCO_ATUAL=RISCO                                                                  
   FROM UPA_FILA                                                          
   WHERE ACO_CODIGO = @ACO_CODIGO                                                          
    END                                                                  
  ELSE                                                                  
    BEGIN                                                                 
   SELECT @RISCO_ATUAL=ACO_RISCO                                                                  
   FROM UPA_FILA F                                                              
   INNER JOIN UPA_ACOLHIMENTO A ON F.ACO_CODIGO = A.ACO_CODIGO                                                              
   WHERE A.ACO_CODIGO = @ACO_CODIGO                                                                  
    END                                                          
  END                                                
                                                                    
  -- NAO ENCONTROU O PACIENTE NA FILA                                                             
  IF (@RISCO_ATUAL IS NULL)                                                                  
  BEGIN                                                                  
    -- INCLUI O PACIENTE NA ULTIMA POSICAO DA FILA      
                                                              
  INSERT INTO UPA_FILA (ACO_CODIGO,NOME,NOMESOCIAL,ACO_DATAHORA,ACO_IDOSO,RISCO,SPA_CODIGO,NUM_CHAMADAS,                                                          
  LOCATEND_CODIGO,DESTINO,DATA_CONFIRMACAO,DATA_CANCELAMENTO,ATENDAMB_CODIGO)                                    
  SELECT ACO_CODIGO,ACO_NOME,isnull(isnull(@NOMESOCIAL, ACO_NOME_SOCIAL), pa.spa_nome_social),ACO_DATAHORA,ACO_IDOSO,ACO_RISCO,UPA_ACOLHIMENTO.SPA_CODIGO,0,                                                          
   UPA_ACOLHIMENTO.LOCATEND_CODIGO,NULL,NULL,NULL, @ATENDAMB_CODIGO                                                    
  FROM UPA_ACOLHIMENTO with(nolock)    
  left join Pronto_Atendimento pa with(nolock) on UPA_ACOLHIMENTO.spa_codigo = pa.spa_codigo    
  WHERE ACO_CODIGO = @ACO_CODIGO                            
                                                                   
    INSERT INTO UPA_FILA_SEQUENCIAL (ACO_CODIGO, SEQUENCIAL, PRIORIDADE) VALUES (@ACO_CODIGO, @PROXIMO_SEQUENCIAL_MESMO_RISCO, 0)                                                                   
                                                                    
    -- INCLUI O REGISTRO NO HISTORICO                                                                  
    IF (@ACO_CODIGO IS NOT NULL)                                                                  
    BEGIN                                       
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                  
   VALUES (@ACO_CODIGO, GETDATE(), 1, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                  
    END                                                                  
                                                                     
  END                                             
  ELSE -- ENCONTROU O PACIENTE NA FILA                                                                  
  BEGIN                                                    
                                                                   
   -- ALTERACAO                                                                  
   IF (@RISCO <> @RISCO_ATUAL) -- ALTEROU O RISCO                                                                  
   BEGIN                                                                  
  -- ATUALIZA O REGISTRO NA TABELA DE FILA, MUDANDO A SUA POSICAO                                                                  
   IF (@RISCO_ATUAL = 0 OR @RISCO_ATUAL = 1)                                                          
    BEGIN                                                                 
     UPDATE UPA_FILA SET                                                                  
     SPA_CODIGO = ISNULL(@SPA_CODIGO, SPA_CODIGO),                                                            
     EMER_CODIGO = ISNULL(@EMER_CODIGO, EMER_CODIGO),                                                                
     DATA_CONFIRMACAO = NULL,                                                          
     RISCO = @RISCO,                                                          
     LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO,  LOCATEND_CODIGO),                                                  
     NOME = ISNULL(@SPA_NOME,  NOME),    
     NOMESOCIAL = ISNULL(@NOMESOCIAL, NOMESOCIAL),                                              
     ATENDAMB_CODIGO = ISNULL(@ATENDAMB_CODIGO, ATENDAMB_CODIGO),                  
     ORIGEM  = ISNULL(@ORIGEM, ORIGEM)                  
     WHERE  ACO_CODIGO = @ACO_CODIGO                                                                  
    END                                        
   ELSE                                                          
    BEGIN                                                          
     UPDATE UPA_FILA SET                               
    SPA_CODIGO = ISNULL(@SPA_CODIGO, SPA_CODIGO),                                                          
    EMER_CODIGO = ISNULL(@EMER_CODIGO, EMER_CODIGO),                                                                  
    DATA_CONFIRMACAO = NULL,     
    RISCO = @RISCO,             
    LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO,  LOCATEND_CODIGO),                                                            
    NOME = ISNULL(@SPA_NOME,  NOME),    
    NOMESOCIAL = ISNULL(@NOMESOCIAL, NOMESOCIAL),                                                
    ATENDAMB_CODIGO = ISNULL(@ATENDAMB_CODIGO, ATENDAMB_CODIGO),                  
    ORIGEM  = ISNULL(@ORIGEM, ORIGEM)                    
   WHERE  ACO_CODIGO = @ACO_CODIGO                                                                    
    END                                                          
  -- INCLUI O REGISTRO NO HISTORICO                                                                  
  IF (@ACO_CODIGO IS NOT NULL)                                                                  
  BEGIN                     
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                  
   VALUES (@ACO_CODIGO, GETDATE(), 2, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                              
  END                                                                  
                                                         
  END                                                                  
   ELSE                                                                  
   BEGIN                                                                  
    -- ATUALIZA O REGISTRO NA TABELA DE FILA                                          
    UPDATE UPA_FILA SET                                                                  
    SPA_CODIGO = ISNULL(@SPA_CODIGO, SPA_CODIGO),                                                           
    EMER_CODIGO = ISNULL(@EMER_CODIGO, EMER_CODIGO),                                               
    DATA_CONFIRMACAO = NULL,                               
    LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO,  LOCATEND_CODIGO),                                                          
    NOME = ISNULL(@SPA_NOME,  NOME),    
    NOMESOCIAL = ISNULL(@NOMESOCIAL, NOMESOCIAL),                                                
    ATENDAMB_CODIGO = ISNULL(@ATENDAMB_CODIGO, ATENDAMB_CODIGO),                  
    ORIGEM  = ISNULL(@ORIGEM, ORIGEM)                                   
    WHERE ACO_CODIGO = @ACO_CODIGO                                                          
                                                              
    -- INCLUI O REGISTRO NO HISTORICO                                                                  
    IF (@ACO_CODIGO IS NOT NULL)                                                                  
    BEGIN                                    
  INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                  
  VALUES (@ACO_CODIGO, GETDATE(), 3, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                  
    END                                                                  
   END                                                                  
  END                                                                  
                                                                   
 END                                                                       
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- ALTERACAO / CANCELAMENTO                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 2                                                                    
 BEGIN                                                                    
  IF (@ACO_CODIGO IS NOT NULL)               
  BEGIN                            
   DECLARE @WDATA SMALLDATETIME                                                                    
                                                                       
   SET @WDATA = CONVERT(SMALLDATETIME, @DATA_CANCELAMENTO, 103)                                                                    
    
   -- ATUALIZA A DATA DE CANCELAMENTO                             
   UPDATE UPA_FILA                                       
   SET DATA_CANCELAMENTO = @WDATA,                                                                    
   DATA_CONFIRMACAO = NULL,                                                                    
   NUM_CHAMADAS = 0                                                                    
   WHERE  ACO_CODIGO = @ACO_CODIGO                  
                     
   DELETE FROM UPA_PAINEL WHERE ACO_CODIGO = @ACO_CODIGO                  
                           
   -- INCLUI O REGISTRO NO HISTÃƒÆ’Ã¢â‚¬Å“RICO                                                                    
   IF (@WDATA IS NOT NULL)                                                                    
   BEGIN                                   
    IF (@ACO_CODIGO IS NOT NULL)                                                                    
    BEGIN                                                                      
  INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                  
  VALUES (@ACO_CODIGO, GETDATE(), 4, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
    END                                                                   
   END                                                                    
   ELSE                                                                    
   BEGIN                                                                    
    IF (@ACO_CODIGO IS NOT NULL)                                                                    
    BEGIN                                                        
  INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                    
  VALUES (@ACO_CODIGO, GETDATE(), 5, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
    END                                                                    
   END                        
  END                                        
 END                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- SELECAO DOS ACOLHIDOS SEM REGISTRO DE SPA - FILA DO REGISTRO                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @OPCAO = 3                                              
 BEGIN                                                            
 IF (@USA_ACOLHIMENTO = 'S')                                                          
  BEGIN                                                            
   IF (@ETAPA_CLASSIFICACAO = 0) -- USA ETAPA DE CLASSIFCACAO                                                          
   BEGIN                             
    IF (@FLUXO_ATENDIMENTO = 0)  -- REGISTRA/CLASSIFICA                                                   
    BEGIN                                                          
    SELECT FR.ACO_CODIGO,                                                               
    FR.SPA_CODIGO,                                     
    FR.EMER_CODIGO,                                                              
    case when pd.id is null then     
  case when FR.NOMESOCIAL IS NOT NULL THEN     
   FR.NOMESOCIAL + '[' + FR.NOME + ']'    
  ELSE    
   FR.NOME     
  END    
 ELSE    
  case when FR.NOMESOCIAL IS NOT NULL THEN     
   'DENGUE - ' + FR.NOMESOCIAL + '[' + FR.NOME + ']'    
  ELSE    
   'DENGUE - ' + FR.NOME     
  END    
 END AS NOME,        
    FR.RISCO,                                                              
    vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
    FR.ACO_DATAHORA AS DATAHORA,                                                           
    FR.SEQUENCIAL,                                    
    FR.CHAMADA_ATIVA,                    
    FR.DESTINO,                                                              
    FR.IDOSO,                                            
   FR.CHAMADA_ATIVA2,                                            
   FR.DESTINO2,    
   '' as TEMPOESPERAMINUTOS,    
   '' as TEMPOESPERAATENDIMENTO,    
   '' AS DATAULTIMOATENDIMENTO                                            
    FROM vwUPA_Fila_Registro_UPA FR        
    LEFT JOIN PROTOCOLO_DENGUE PD ON PD.ACO_CODIGO = FR.ACO_CODIGO                                     
    INNER JOIN VWLOCAL_UNIDADE vwLU                                     
      ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                                              
  WHERE     
 vwLU.UNID_CODIGO = @UNID_CODIGO          
 and DATEDIFF(d,FR.ACO_DATAHORA,GETDATE()) <= isnull(@FiltroDias,1)    
    ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                                                    
   END              
   IF (@FLUXO_ATENDIMENTO = 1)  -- CLASSIFICA/REGISTRA                                                          
    /* BEGIN                         
    SELECT FR.ACO_CODIGO,                                                               
    FR.SPA_CODIGO,                                                              
    FR.EMER_CODIGO,                                                              
    FR.NOME,                                                               
    FR.RISCO,                                                              
    vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
    FR.ACO_DATAHORA AS DATAHORA,                                                   
    FR.SEQUENCIAL,                             
    FR.CHAMADA_ATIVA,                                                              
    FR.DESTINO,                                                              
    FR.IDOSO                                                                    
    FROM vwUPA_Fila_Registro FR                                                              
    INNER JOIN VWLOCAL_UNIDADE vwLU                                                              
    ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                                              
    ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                                                    
    END*/                                                          
   BEGIN                                                          
    SELECT FR.ACO_CODIGO,                                                               
  FR.SPA_CODIGO,                                                              
    FR.EMER_CODIGO,                                                              
    CASE WHEN FR.NOMESOCIAL IS NOT NULL THEN     
  FR.NOMESOCIAL + '[' + FR.NOME + ']'    
 ELSE     
  FR.NOME    
 END AS NOME,                                                  
    FR.RISCO,                                                              
    vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
    FR.ACO_DATAHORA AS DATAHORA,                                                              
    FR.SEQUENCIAL,                                                              
    FR.CHAMADA_ATIVA,         
    FR.DESTINO,                                                              
 FR.IDOSO,                                            
   FR.CHAMADA_ATIVA2,                                            
   FR.DESTINO2,    
   '' as TEMPOESPERAMINUTOS,    
   '' as TEMPOESPERAATENDIMENTO,    
   '' AS DATAULTIMOATENDIMENTO                                                                         
    FROM vwFila_Registro_Urgencia FR INNER JOIN VWLOCAL_UNIDADE vwLU ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                                              
 WHERE vwLU.UNID_CODIGO = @UNID_CODIGO     
 and DATEDIFF(d,FR.ACO_DATAHORA,GETDATE()) <= isnull(@FiltroDias,1)       
    ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                                        
   END                                                     
   END                                                          
   IF (@ETAPA_CLASSIFICACAO = 1 OR @ETAPA_CLASSIFICACAO = 2) -- CLASSIFICA NO REGISTRO OU NAO USA ETAPA DE CLASSIFICACAO                                                          
   BEGIN                                                          
   SELECT FR.ACO_CODIGO,                                                               
   FR.SPA_CODIGO,                                                       
   FR.EMER_CODIGO,                                                              
   CASE WHEN FR.NOMESOCIAL IS NOT NULL THEN    
  FR.NOMESOCIAL + '[' + FR.NOME + ']'    
   ELSE    
  FR.NOME    
   END AS NOME,                                                               
   FR.RISCO,                                                              
   vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
   FR.ACO_DATAHORA AS DATAHORA,                                                    
   FR.SEQUENCIAL,                                                              
   FR.CHAMADA_ATIVA,                                                              
   FR.DESTINO,                                                              
   FR.IDOSO,                                            
   FR.CHAMADA_ATIVA2,                                            
   FR.DESTINO2,    
   '' as TEMPOESPERAMINUTOS,    
   '' as TEMPOESPERAATENDIMENTO,    
   '' AS DATAULTIMOATENDIMENTO                                             
   FROM vwUPA_Fila_Registro_UPA FR INNER JOIN VWLOCAL_UNIDADE vwLU                                                              
   ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                    
 WHERE vwLU.UNID_CODIGO = @UNID_CODIGO        
   ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                                                    
  END                                                          
  END                                                                   
  ELSE                                                     
  /*                                                          
  NA0 USA ACOLHIMENTO. O FLUXO INICIA NA URGENCIA OU PELA CLASSIFICACAO DE RISCO                                                          
  NA FILA DO REGISTRO APARECERAO OS PACIENTES QUE ENTRAM PELA CLASSIFICACAO E AINDA NAO FORAM REGISTRADOS                                                        
  NA FILA DA CLASSIFICACAO APARECERAO OS PACIENTES QUE FORAM REGISTRADOS COM RISCO     
  */                                                          
  IF (@ETAPA_CLASSIFICACAO = 0) -- USA ETAPA DE CLASSIFICACAO                                                          
  BEGIN                                                          
   SELECT FR.ACO_CODIGO,                                                               
   FR.SPA_CODIGO,                                                              
   FR.EMER_CODIGO,                                  
   CASE WHEN FR.NOMESOCIAL IS NOT NULL THEN    
  FR.NOMESOCIAL + '[' + FR.NOME + ']'    
   ELSE    
  FR.NOME    
   END AS NOME,           
   FR.RISCO,                                                              
   vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
   FR.ACO_DATAHORA AS DATAHORA,                                                              
   FR.SEQUENCIAL,                                                              
   FR.CHAMADA_ATIVA,                                                              
   FR.DESTINO,                                                              
   FR.IDOSO,                                            
  FR.CHAMADA_ATIVA2,                                  FR.DESTINO2                                             
   FROM vwFila_Registro_Urgencia FR INNER JOIN VWLOCAL_UNIDADE vwLU ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                                           
 WHERE vwLU.UNID_CODIGO = @UNID_CODIGO         
 and DATEDIFF(d,FR.ACO_DATAHORA,GETDATE()) <= isnull(@FiltroDias,1)      
   ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                    
  END                                                          
  ELSE                                                          
  BEGIN                                                          
   SELECT FR.ACO_CODIGO,                                                               
   FR.SPA_CODIGO,                                                              
   FR.EMER_CODIGO,                                                              
   CASE WHEN FR.NOMESOCIAL IS NOT NULL THEN    
  FR.NOMESOCIAL + '[' + FR.NOME + ']'    
   ELSE     
  FR.NOME    
   END AS NOME,                                                               
   FR.RISCO,                                                              
   vwLU.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
   FR.ACO_DATAHORA AS DATAHORA,                                                       
   FR.SEQUENCIAL,                                                              
   FR.CHAMADA_ATIVA,                                                              
   FR.DESTINO,                                                              
   FR.IDOSO,                                            
  FR.CHAMADA_ATIVA2,                                            
  FR.DESTINO2,    
   '' as TEMPOESPERAMINUTOS,    
   '' as TEMPOESPERAATENDIMENTO,    
   '' AS DATAULTIMOATENDIMENTO                                                  
   FROM vwUPA_Fila_Registro FR                                                              
   INNER JOIN VWLOCAL_UNIDADE vwLU ON FR.LOCATEND_CODIGO = vwLU.LOCATEND_CODIGO                                                              
 WHERE vwLU.UNID_CODIGO = @UNID_CODIGO     
 and DATEDIFF(d,FR.ACO_DATAHORA,GETDATE()) <= isnull(@FiltroDias,1)        
   ORDER BY FR.RISCO DESC, FR.IDOSO DESC, FR.PRIORIDADE DESC, FR.ACO_CODIGO ASC                                                          
  END                    
 END                                  
                                                                     
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- PULAR FILA                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 4                                                                    
 BEGIN                                                                    
                                                                   
 -- RECUPERA O PRIMEIRO SEQUENCIAL DA FILA DOS COM RISCO 1 E 2                                                                    
  SELECT  @PRIMEIRO_SEQUENCIAL_COM_RISCO_1_2_3=ISNULL(MIN(SEQUENCIAL), 1)                                                       
  FROM  VWUPA_FILA             
  WHERE  convert(int,RISCO) <= (select risaco_gravidade from vwRisco_Gravidade_Espera)           
                                                                   
  DECLARE @SEQUENCIAL INT                                                            
  DECLARE @PRIORIDADE INT                                                            
                                                                      
  -- RECUPERA O RISCO E O SEQUENCIAL                                                                    
  SELECT  @RISCO=RISCO, @SEQUENCIAL=SEQUENCIAL                                            
  FROM VWUPA_FILA                                                                    
  WHERE ACO_CODIGO=@ACO_CODIGO                                                              
                                                              
                                                                     
  IF (@RISCO >= 1)                                                
  BEGIN                                                                    
   -- COLOCA O REGISTRO COMO PRIMEIRO DA FILA DOS COM RISCO                                                                    
                                                               
   SELECT @PRIORIDADE = (ISNULL(MAX(PRIORIDADE), 0))                                                                    
   FROM VWUPA_FILA                                      
   WHERE convert(int,RISCO) <= (select risaco_gravidade from vwRisco_Gravidade_Espera)                                                          
                                                                     
   -- COLOCA O REGISTRO COMO PRIMEIRO DA FILA DOS SEM RISCO                                                                    
   UPDATE  UPA_FILA_SEQUENCIAL SET                      
  PRIORIDADE = @PRIORIDADE + 1                                                            
   WHERE  ACO_CODIGO = @ACO_CODIGO                                                                    
                                                               
   -- INCLUI O REGISTRO NO HISTÃƒÆ’Ã¢â‚¬Å“RICO                                                                    
   IF (@ACO_CODIGO IS NOT NULL)                                                                    
   BEGIN                                                                      
    INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                    
 VALUES (@ACO_CODIGO, GETDATE(), 6, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
   END                              
  END                                                                    
  ELSE                                                                    
  BEGIN                                                                    
   SELECT @PRIORIDADE = (ISNULL(MAX(PRIORIDADE), 0))                                                                    
   FROM VWUPA_FILA                                                
   WHERE RISCO = '0' OR IDOSO = 1                                                                  
                                                                     
   -- COLOCA O REGISTRO COMO PRIMEIRO DA FILA DOS SEM RISCO                                                                    
   UPDATE  UPA_FILA_SEQUENCIAL SET                                                                    
  PRIORIDADE = @PRIORIDADE + 1                                                            
   WHERE  ACO_CODIGO = @ACO_CODIGO                                                                    
                                                                     
   -- INCLUI O REGISTRO NO HISTÃƒÆ’Ã¢â‚¬Å“RICO                                      
   IF (@ACO_CODIGO IS NOT NULL)                                                                    
   BEGIN                                                                      
    INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                         
    VALUES (@ACO_CODIGO, GETDATE(), 7, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
   END                                      
  END                                                                    
 END                                                                    
                                                                  
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- CHAMAR O PACIENTE                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                             
 IF @OPCAO = 5                               
 BEGIN                 
                                             
  DECLARE @DESTINO_CHAMADO VARCHAR(50)                                            
                                             
  IF ( @ATENDAMB_CODIGO IS NULL )                                            
  BEGIN                                             
    SELECT @DESTINO_CHAMADO = DESTINO                                             
    FROM VWUPA_FILA                                             
    WHERE ACO_CODIGO = @ACO_CODIGO                                            
  AND  ((CHAMADA_ATIVA = 1 OR DATA_CONFIRMACAO IS NOT NULL)        
  OR (@ORIGEM = 'R' AND SPA_CODIGO IS NOT NULL)        
  OR (@ORIGEM = 'C' AND SPA_CODIGO IS NOT NULL AND ORIGEM = 'C')        
  )        
  END                                             
                   
  ELSE                                            
  BEGIN                                              
    SELECT @DESTINO_CHAMADO = DESTINO                                        
    FROM UPA_FILA f                                            
   INNER JOIN UPA_FILA_SEQUENCIAL fs ON f.ACO_CODIGO = fs.ACO_CODIGO                                            
   LEFT OUTER JOIN UPA_PAINEL pn ON pn.ACO_CODIGO = fs.ACO_CODIGO                                            
    WHERE f.ACO_CODIGO = @ACO_CODIGO                                            
   AND f.DATA_CANCELAMENTO IS NULL              
   AND f.ATENDAMB_CODIGO IS NOT NULL                            
   AND ((pn.ACO_CODIGO IS NOT NULL AND f.NUM_CHAMADAS > 0) OR (f.DATA_CONFIRMACAO IS NOT NULL))                            
  END                  
                                             
                                             
  IF (@@ROWCOUNT = 0)                                             
  BEGIN                                             
   -- ***************************************                                                                    
   -- SELECIONA OS PARAMETROS DE CONFIGURACAO                                                                    
   -- ***************************************                                      
   DECLARE @NUM_CHAMADAS INT         
   DECLARE @NUM_REPETICOES INT                                                                    
                                                                       
   SELECT TOP 1                                                                    
    @NUM_REPETICOES = ISNULL(NUMERO_REPETICOES, 1)                                                  
   FROM UPA_FILA_CONFIG                                                                    
                                                                       
   SELECT @NUM_CHAMADAS = NUM_CHAMADAS                                                                    
   FROM UPA_FILA                                              
   WHERE ACO_CODIGO = @ACO_CODIGO                                                                    
                      
   IF (@NUM_CHAMADAS < @NUM_REPETICOES)                                                                    
   BEGIN                                             
    -- INSERE O PACIENTE PARA CHAMA-LO AO PAINEL                                                                    
                                                                     
   DELETE FROM UPA_PAINEL WHERE ACO_CODIGO = @ACO_CODIGO                                                            
                           
   INSERT INTO UPA_PAINEL                                                                    
   (ACO_CODIGO, ORIGEM, DATA_CHAMADA, DATA_PRIMEIRA_EXIBICAO)                                                          
   VALUES                          (@ACO_CODIGO, @ORIGEM, GETDATE(), NULL)                                                            
                                                   
   -- ATUALIZA O NUMERO DE CHAMADAS                                                                    
   UPDATE UPA_FILA SET                                                       
   NUM_CHAMADAS = NUM_CHAMADAS + 1,                                                                    
   DATA_CONFIRMACAO = NULL,                                                            
   DESTINO = @DESTINO                                                                    
   WHERE ACO_CODIGO = @ACO_CODIGO                                       
                                                                           
  -- INCLUI O REGISTRO NO HISTORICO                                                                    
  IF (@ACO_CODIGO IS NOT NULL)                                                      
  BEGIN                                                                      
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                    
   VALUES (@ACO_CODIGO, GETDATE(), 8, @DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
  END                                                  
                                                                        
    -- RETORNO                                                                    
    SELECT ''                            
   END                  
                                                         
   ELSE             
  BEGIN                                                                    
    -- NUMERO DE CHAMADAS NO PAINEL ESGOTADAS                                                                    
    -- ATUALIZA O NUMERO DE CHAMADAS                                                               
 UPDATE UPA_FILA SET                                                                    
 DATA_CANCELAMENTO = GETDATE()                                                                    
 WHERE ACO_CODIGO = @ACO_CODIGO                                              
                                                                
    -- INCLUI O REGISTRO NO HISTORICO                                                                    
    IF (@ACO_CODIGO IS NOT NULL)                                                                    
  BEGIN                                              
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                                    
   VALUES (@ACO_CODIGO, GETDATE(), 9, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
  END                                                            
                                                                           
  -- RETORNO                                                                    
  SELECT 'ESTE PACIENTE FOI RETIRADO DA FILA POIS ATINGIU O NUMERO MAXIMO DE ' + CONVERT(VARCHAR, @NUM_CHAMADAS) + ' CHAMADAS NO PAINEL. UTILIZE A FUNÃƒâ€¡ÃƒÆ’O DE ADMINISTRAÃƒâ€¡ÃƒÆ’O DA FILA PARA RETORNA-LO.'                          
      
                            
 END                                                                    
                   
  END                                                                    
  ELSE                                                                    
 BEGIN                                                                    
  SELECT 'ESTE PACIENTE JA ESTA SENDO CHAMADO POR ' + @DESTINO_CHAMADO + '.'                                                                    
 END                            
  END                                                         
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                  -- ENCERRAR PACIENTE NA FILA                                   
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                          
 IF @OPCAO = 6                                                                    
 BEGIN                                                                    
                                                           
  DELETE FROM UPA_PAINEL                                                                    
  WHERE ACO_CODIGO = @ACO_CODIGO                                                                    
                                                              
  DELETE FROM UPA_FILA_SEQUENCIAL                                                            
  WHERE ACO_CODIGO = @ACO_CODIGO                                                                    
                                                              
  DELETE FROM UPA_FILA                                                                    
  WHERE ACO_CODIGO = @ACO_CODIGO                                                            
                                                              
  -- INCLUI O REGISTRO NO HISTORICO                                                                    
  IF (@ACO_CODIGO IS NOT NULL)                                                                    
  BEGIN                                                                    
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)        
   VALUES (@ACO_CODIGO, GETDATE(), 10, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                                    
    
   IF(@ORIGEM IS NOT NULL AND UPPER(@ORIGEM) = 'D')    
   BEGIN    
      
  DECLARE @WDATA_AUX SMALLDATETIME    
  SET @WDATA_AUX = CONVERT(SMALLDATETIME, @DATA_CANCELAMENTO, 103)    
    
  INSERT INTO FILA_CANCELAMENTO(USU_CODIGO, ACO_CODIGO, JUSTIFICATIVA, DATA_HORA, LOCAL_ORIGEM_EXCLUSAO,EXT_CANCELAMENTO_CODIGO)    
  VALUES(@USUARIO_CODIGO, @ACO_CODIGO, @JUSTIFICATIVA, @WDATA_AUX, 'ADMINISTRACAO DE FILA','0015')    
    
   END    
      
  END                                         
              
 END                                                                    
                                                                     
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- FILA PARA CLASSIFICACAO DE RISCO                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 7                                                         
 BEGIN                                        
 SELECT FC.ACO_CODIGO,                                                                     
  FC.SPA_CODIGO,                                                             
  FC.EMER_CODIGO,                             
  case when pd.id is null then     
   case when fc.nomesocial is not null then fc.nomesocial + '['+ FC.NOME + ']' else FC.NOME end    
  ELSE 'DENGUE - ' + case when fc.nomesocial is not null then fc.nomesocial + '['+ FC.NOME + ']' else FC.NOME end    
  END AS NOME,    
  FC.RISCO,                                                             
  CASE WHEN (LAPA.LOCATEND_CODIGO IS NOT NULL)                                                                    
    THEN LAPA.SET_DESCRICAO                                                                    
    ELSE LAAC.SET_DESCRICAO                                                                    
  END AS LOC_DESCRICAO,                                                                    
  AC.ACO_DATAHORA AS DATAHORA,                                                                    
  FC.SEQUENCIAL,                                                                    
  FC.CHAMADA_ATIVA,                                                                    
  FC.DESTINO,                                                                    
  FC.IDOSO,                                      
  FC.CHAMADA_ATIVA2,                                      
  FC.DESTINO2,    
  '' as TEMPOESPERAMINUTOS,    
  '' as TEMPOESPERAATENDIMENTO,    
  '' AS DATAULTIMOATENDIMENTO                 
 FROM VWUPA_FILA_CLASSIFICACAO_RISCO FC             
  LEFT OUTER JOIN PRONTO_ATENDIMENTO PA ON ( FC.SPA_CODIGO = PA.SPA_CODIGO and pa.spa_chegada > dateadd(d, -@periodo, getdate()) )                                                         
  INNER JOIN UPA_ACOLHIMENTO AC ON ( FC.ACO_CODIGO = AC.ACO_CODIGO  and ac.aco_datahora > dateadd(d, -@periodo, getdate()) )                                                                          
  LEFT JOIN PROTOCOLO_DENGUE PD ON PD.ACO_CODIGO = AC.ACO_CODIGO        
  INNER JOIN VWCLINICA_SPA LAAC ON AC.LOCATEND_CODIGO = LAAC.LOCATEND_CODIGO                                                                         
  LEFT OUTER JOIN VWCLINICA_SPA LAPA ON PA.LOCATEND_CODIGO = LAPA.LOCATEND_CODIGO    
  LEFT JOIN UNIDADE U ON U.UNID_CODIGO = @UNID_CODIGO    
 WHERE (    
   (LAAC.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LAAC.LOCATEND_CODIGO) AND LAPA.LOCATEND_CODIGO IS NULL)     
    OR    
   (LAPA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LAPA.LOCATEND_CODIGO) AND LAPA.LOCATEND_CODIGO IS NOT NULL)    
  )    
  AND  AC.UNID_CODIGO=@UNID_CODIGO    
  --AND (    
   --(U.Fluxo_Atendimento = 0 AND PA.spa_codigo IS NOT NULL) --Registra e Classifica    
   --OR (U.Fluxo_Atendimento = 1 AND PA.spa_codigo IS NULL) --Classifica e Registra    
  --)    
 ORDER BY FC.PRIORIDADE DESC, FC.ACO_CODIGO ASC                                                            
                                                              
 END                                                                    
                                                                     
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                
 -- PACIENTES EM OBSERVACAO E AGUARDANDO LEITO --                                                                    
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- Atender o Paciente                         
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @opcao = 9                                                              
 BEGIN                                                              
                                                             
  -- Remove o paciente do painel                                                            
  DELETE FROM UPA_Painel                                                               
  WHERE ACO_CODIGO = @ACO_CODIGO                            
                                                             
  -- Atualiza o numero de chamadas                                                              
  UPDATE UPA_FILA SET                                                              
   NUM_CHAMADAS = 0,                                                              
   DATA_CONFIRMACAO = GETDATE()                                                              
  WHERE ACO_CODIGO = @ACO_CODIGO                                                            
                     
 -- Inclui o registro no historico                                                              
  IF (@ACO_CODIGO IS NOT NULL)                                                              
  BEGIN                                                               
  IF (@ID_EVENTO IS NULL)                                  
   SET @ID_EVENTO = 11                                  
   INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                              
   VALUES (@ACO_CODIGO, GETDATE(), @ID_EVENTO, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                           
  END                                                              
                                               
 END          
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- PROFISSIONAL/ESPECIALIDADE COM ATENDIMENTOS EM ABERTO                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @opcao = 10                                                              
 BEGIN                                                              
 SELECT X.SPA_CODIGO, X.NOME, X.LOC_DESCRICAO,                                                              
   X.PROF_NOME, X.LOCATEND_CODIGO, X.PROF_CODIGO,                                                               
   Y.TOTALSEMRETORNO, Z.TOTALCOMRETORNO, W.UPAENC_PRIORIDADE, W.UPAENC_DATAENCAMINHADO, '0' AS TIPO,                                                
   X.ATENDAMB_CODIGO,              
   xpto.TOTALPRESCRICAO,                                                               
   xpt.TOTALPRESCFECHADA,                      
   x.LaudoLiberado,    
   X.LAUDOLIBERADO_R as TotalLaudoLiberadoRadiologia,    
   X.LAUDOLIBERADO_D AS TotalLaudoLiberadoDiagnose--,    
   --kl.TOTALLAUDOLABORATORIO AS TotalLaudoLaboratorio                      
                       
 FROM                                                               
   (SELECT  PA.SPA_CODIGO AS [SPA_CODIGO],                                                               
   case when pd.id is null then     
  case when pac.pac_nome_social is not null or pa.spa_nome_social is not null then isnull(pac.pac_nome_social, pa.spa_nome_social) + '[' + ISNULL(PAC.PAC_NOME, PA.SPA_NOME) + ']'    
  else ISNULL(PAC.PAC_NOME, PA.SPA_NOME) end    
 else    
  'DENGUE - ' + case when pac.pac_codigo is not null or pa.spa_nome_social is not null then isnull(pac.pac_nome_social, pa.spa_nome_social) + '[' + ISNULL(PAC.PAC_NOME, PA.SPA_NOME) + ']'    
  else ISNULL(PAC.PAC_NOME, PA.SPA_NOME) end    
 END AS NOME,        
   LA.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
   PROF.PROF_NOME,                                        
   AA.LOCATEND_CODIGO,                                                              
   AA.PROF_CODIGO,                                                
   AA.atendamb_codigo,                      
   LaudoLab.TotalLaudoLiberado as LaudoLiberado,    
   LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS LAUDOLIBERADO_R,    
   LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS LAUDOLIBERADO_D                  
                                                         
  FROM  PRONTO_ATENDIMENTO PA                                      
   INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON PA.SPA_CODIGO = AA.SPA_CODIGO                                                              
   INNER JOIN UPA_Atendimento_Medico AM on AA.atendamb_CODIGO = AM.atendamb_CODIGO                                                              
   INNER JOIN PROFISSIONAL prof on (prof.prof_codigo = AA.prof_codigo and prof.locatend_codigo = AA.locatend_codigo)                                                              
   INNER JOIN VWCLINICA_SPA LA ON PA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                                                                
   LEFT JOIN PROTOCOLO_DENGUE PD ON PD.SPA_CODIGO = PA.SPA_CODIGO        
   LEFT JOIN (        
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado         
  from vwsolicitacao_pedido vsp2         
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido       
  where (esl.exasollab_status  in ('LA','LI')) and vsp2.oripac_codigo = 5         
  group by solped_CodigoOrigem        
   ) LaudoLab on pa.spa_codigo = LaudoLab.solped_CodigoOrigem                  
   left join paciente pac on pac.pac_codigo = pa.pac_codigo     
       
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON PA.SPA_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM    
    
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON PA.SPA_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM             
                     
 WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO <> 5 OR AM.TIPSAI_CODIGO IS NULL) --AM.TIPSAI_CODIGO NOT IN (5)                                                              
   AND (AM.TIPSAI_CODIGOENCAMINHAMENTO <> 5 OR AM.TIPSAI_CODIGOENCAMINHAMENTO  IS NULL)--AM.TIPSAI_CODIGOENCAMINHAMENTO NOT IN (5)                                                              
   AND AA.PROF_CODIGO = @PROF_CODIGO    
   AND PA.unid_codigo = @UNID_CODIGO                                                                                              
   AND NOT EXISTS (SELECT 1 FROM INTERNACAO I                                     
  WHERE I.SPA_CODIGO = PA.SPA_CODIGO)) X      
      
 -- LEFT JOIN    
    
 --(SELECT DISTINCT SOLPED_CODIGOORIGEM, ORIPAC_CODIGO, COUNT(*) AS TOTALLAUDOLABORATORIO    
 --  FROM SOLICITACAO_PEDIDO_EXAME SPE with (nolock)    
 --  INNER JOIN VWSOLICITACAO_PEDIDO SP ON SPE.PED_CODIGO = SP.PED_CODIGO    
 --  INNER JOIN EXAME_SOLICITADO_LABORATORIO EL ON SPE.SOLPEDEXA_CODIGO_EXAME = EL.EXALAB_CODIGO    
 --  AND SP.SOLPED_CODIGOPEDIDO = EL.PEDEXALAB_CODIGO AND SP.SOLPED_TIPOSOLICITACAO = 7 AND (EL.EXASOLLAB_STATUS = 'LA' OR EL.EXASOLLAB_STATUS  = 'LI')    
 --  GROUP BY SOLPED_CODIGOORIGEM, ORIPAC_CODIGO) KL    
 --  ON (KL.SOLPED_CODIGOORIGEM = X.SPA_CODIGO AND KL.ORIPAC_CODIGO = 5)                                                            
                                                             
 LEFT JOIN                                                              
                                                             
 (SELECT SPA_CODIGO, UPAENC_PRIORIDADE, UPAENC_DATAENCAMINHADO                                            
 FROM UPA_ENCAMINHAMENTO                                                              
 WHERE UPATIPENC_CODIGO = 3                                                              
 AND UPAENC_DATARETORNO IS NULL) W                                                              
                 
 ON W.SPA_CODIGO = X.SPA_CODIGO                                                              
                                                             
 LEFT JOIN                                                              
                                                             
 (SELECT SPA_CODIGO, COUNT(*) AS TOTALSEMRETORNO                                                              
 FROM UPA_ENCAMINHAMENTO                     
 WHERE UPAENC_DATARETORNO IS NULL                                                              
 GROUP BY SPA_CODIGO) Y                        
                                                             
 ON X.SPA_CODIGO = Y.SPA_CODIGO                                                              
                                                             
 LEFT JOIN (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALCOMRETORNO                                                      
 FROM UPA_ENCAMINHAMENTO                                                              
 WHERE UPAENC_DATARETORNO IS NOT NULL                                                              
 GROUP BY SPA_CODIGO) Z ON X.SPA_CODIGO = Z.SPA_CODIGO                                                              
                                           
   LEFT JOIN                                        
                                                             
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCRICAO                   
   FROM PRESCRICAO              
   WHERE PRESC_TIPO = 'P'                                                               
   GROUP BY SPA_CODIGO) XPTO ON X.SPA_CODIGO = XPTO.SPA_CODIGO                                                              
                                           
   LEFT JOIN                                                               
                                                             
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCFECHADA                                                               
   FROM PRESCRICAO                                                               
   WHERE idt_fechada = 'S'                 
   and PRESC_TIPO = 'P'                                            
   GROUP BY SPA_CODIGO) XPT ON X.SPA_CODIGO = XPT.SPA_CODIGO                                                              
                                           
                                           
                                                             
 UNION                                                              
                                        
 SELECT X.SPA_CODIGO, X.NOME, X.LOC_DESCRICAO,                                             
   X.PROF_NOME, X.LOCATEND_CODIGO, X.PROF_CODIGO,                                                               
   NULL, NULL, W.UPAENC_PRIORIDADE, W.UPAENC_DATAENCAMINHADO, '1' AS TIPO,                                                
   X.ATENDAMB_CODIGO,                                                   
   xpto.TOTALPRESCRICAO,                                          
   xpt.TOTALPRESCFECHADA,                      
   x.LaudoLiberado,    
   X.LAUDOLIBERADO_R as TotalLaudoLiberadoRadiologia,    
   X.LAUDOLIBERADO_D AS TotalLaudoLiberadoDiagnose--,    
   --kl.TOTALLAUDOLABORATORIO AS TotalLaudoLaboratorio                      
          
  FROM                                                               
 (                                                              
 SELECT  PA.SPA_CODIGO AS [SPA_CODIGO],                                    
   case when pd.id is null then ISNULL(PAC.PAC_NOME, PA.SPA_NOME) ELSE          
   'DENGUE - ' + ISNULL(PAC.PAC_NOME, PA.SPA_NOME) END AS NOME,                                           
   LA.SET_DESCRICAO AS LOC_DESCRICAO,                                                              
   PROF.PROF_NOME,                                                              
   AA.LOCATEND_CODIGO,                                                              
   AA.PROF_CODIGO,                                                 
   AA.ATENDAMB_CODIGO,                      
   LaudoLab.TotalLaudoLiberado as LaudoLiberado,    
   LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS LAUDOLIBERADO_R,    
   LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS LAUDOLIBERADO_D                  
                                                             
  FROM  PRONTO_ATENDIMENTO PA                            
   INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON PA.SPA_CODIGO = AA.SPA_CODIGO                                                              
   INNER JOIN UPA_Atendimento_Medico AM on AA.atendamb_CODIGO = AM.atendamb_codigo                                                              
   INNER JOIN PROFISSIONAL prof on (prof.prof_codigo = AA.prof_codigo and prof.locatend_codigo = AA.locatend_codigo)                                                           
   INNER JOIN VWCLINICA_SPA LA ON PA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                                                                
   LEFT JOIN PROTOCOLO_DENGUE PD ON PD.SPA_CODIGO = PA.SPA_CODIGO        
   LEFT JOIN (        
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado         
  from vwsolicitacao_pedido vsp2         
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido and esl.exasollab_status  in ('LA','LI')        
  where (vsp2.laudoliberado = 'L' or esl.exalab_codigo is not null) and vsp2.oripac_codigo = 5         
  group by solped_CodigoOrigem        
   ) LaudoLab on pa.spa_codigo = LaudoLab.solped_CodigoOrigem                 
   left join paciente pac on pac.pac_codigo = pa.pac_codigo       
       
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON PA.SPA_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM    
    
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON PA.SPA_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM           
                                                             
 WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO <> 5 OR AM.TIPSAI_CODIGO IS NULL) --AM.TIPSAI_CODIGO NOT IN (5)                                 
   AND (AM.TIPSAI_CODIGOENCAMINHAMENTO <> 5 OR AM.TIPSAI_CODIGOENCAMINHAMENTO  IS NULL)--AM.TIPSAI_CODIGOENCAMINHAMENTO NOT IN (5)                                                              
   AND PA.unid_codigo = @UNID_CODIGO                                                              
   AND NOT EXISTS (SELECT 1 FROM INTERNACAO I                                                              
     WHERE I.SPA_CODIGO = PA.SPA_CODIGO)) X                                                              
                                                             
 INNER JOIN                                 
                                                             
 (SELECT Y.SPA_CODIGO, Z.UPAENC_PRIORIDADE, Z.UPAENC_DATAENCAMINHADO                                                              
 FROM                                                               
 (SELECT DISTINCT SPA_CODIGO                                                       
  FROM UPA_ENCAMINHAMENTO                                                              
  WHERE EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WHERE PROF_CODIGO = @PROF_CODIGO AND LOCATEND_CODIGO = LOCATEND_CODIGO_DESTINO)                                                                
   AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                                                              
  AND UPAENC_DATARETORNO IS NULL) Y                                 
 LEFT JOIN                                                               
            
 (SELECT SPA_CODIGO, UPAENC_PRIORIDADE, UPAENC_DATAENCAMINHADO                                                              
 FROM UPA_ENCAMINHAMENTO                                                              
 WHERE UPATIPENC_CODIGO = 3                                         
 AND EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WHERE PROF_CODIGO = @PROF_CODIGO AND LOCATEND_CODIGO = LOCATEND_CODIGO_DESTINO)              
 AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                                                              
 AND UPAENC_DATARETORNO IS NULL) Z                                                              
                                                             
 ON Y.SPA_CODIGO = Z.SPA_CODIGO) W ON X.SPA_CODIGO = W.SPA_CODIGO                                                              
                                           
   LEFT JOIN                                                               
                                                             
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCRICAO                                                               
   FROM PRESCRICAO                               
   GROUP BY SPA_CODIGO) XPTO ON X.SPA_CODIGO = XPTO.SPA_CODIGO                                              
                                           
   LEFT JOIN                                                               
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCFECHADA                                                               
   FROM PRESCRICAO                                                               
   WHERE idt_fechada = 'S'                                               
   GROUP BY SPA_CODIGO) XPT ON X.SPA_CODIGO = XPT.SPA_CODIGO                                                              
                                           
                                                             
 ORDER BY UPAENC_PRIORIDADE DESC, UPAENC_DATAENCAMINHADO, X.SPA_CODIGO DESC                                                             
                                                             
 END                                                              
                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                       
 -- Pegar o proximo da fila                                                              
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- Seleciona os pacientes da fila para Atendimento                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                            
 if @opcao = 12            
 BEGIN                                                              
                                                             
 SELECT  F.SPA_CODIGO,                                                                
  NULL AS EMER_CODIGO,                             
  F.ACO_CODIGO,                                                   
  case when pd.id is null     
   THEN ISNULL(PAC.PAC_NOME, F.NOME)     
   ELSE 'DENGUE - ' + F.NOME END AS NOME,    
  ISNULL(UCR.upaclaris_risco,'0') AS RISCO,    
  LA.LOCATEND_CODIGO AS LOC_CODIGO,    
  LA.SET_DESCRICAO AS LOC_DESCRICAO,    
  F.ACO_DATAHORA AS DATAHORA,    
  F.SEQUENCIAL,    
  F.CHAMADA_ATIVA,    
  F.DESTINO,    
  UE.SPA_CODIGO_DESTINO,    
  CASE WHEN (ISNULL(SPA.SPA_IDADE,0) >= 60) THEN '1' ELSE F.IDOSO END AS IDOSO,    
  F.CHAMADA_ATIVA2,    
  F.DESTINO2,    
  DATEDIFF(MINUTE,F.ACO_DATAHORA,GETDATE()) as TEMPOESPERAMINUTOS, --'' as TEMPOESPERAMINUTOS,    
  CASE    
  when  F.ACO_DATAHORA IS NOT NULL THEN    
   CASE     
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) <> 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) <> 0    
    THEN     
     convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) + ' Dia(s): ' +     
     convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) + ' Hora(s): '+    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) = 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) <> 0    
    THEN    
     convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) + ' Hora(s): '+    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) <> 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) = 0    
    THEN    
     convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) + ' Dia(s): ' +    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) = 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) = 0    
    THEN    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
   END    
  End AS TEMPOESPERAATENDIMENTO,--'' as TEMPOESPERAATENDIMENTO,    
  FPU.DATA_ULTIMO_ATENDIMENTO AS DATAULTIMOATENDIMENTO --'' AS DATAULTIMOATENDIMENTO     
    FROM PRONTO_ATENDIMENTO SPA    
  INNER JOIN VWLOCAL_ATENDIMENTO LA ON SPA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO    
  INNER JOIN vwUPA_FILA_atendimento F ON F.SPA_CODIGO=SPA.SPA_CODIGO    
  LEFT JOIN UPA_CLASSIFICACAO_RISCO UCR ON F.ACO_CODIGO= CONVERT(INT,UCR.ACO_CODIGO)    
  LEFT JOIN UPA_ENCAMINHAMENTO UE ON UE.LOCATEND_CODIGO_DESTINO = SPA.LOCATEND_CODIGO    
  AND UE.SPA_CODIGO_DESTINO = SPA.SPA_CODIGO    
  left join paciente pac on spa.pac_codigo = pac.pac_codigo        
  left join protocolo_dengue pd on pd.spa_codigo = spa.spa_codigo or pd.aco_codigo = f.aco_codigo    
  LEFT JOIN FILA_PACIENTE_ULTIMOATENDIMENTO FPU ON FPU.PAC_CODIGO = PAC.PAC_CODIGO AND FPU.LOCATEND_CODIGO = SPA.LOCATEND_CODIGO                
    WHERE LA.UNID_CODIGO = @UNID_CODIGO AND                
  EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WHERE LOCATEND_CODIGO = LA.LOCATEND_CODIGO AND PROF_CODIGO = @PROF_CODIGO AND PROF_ATIVO = 'S')        
  AND DATEDIFF(d,F.ACO_DATAHORA,GETDATE()) <= isnull(@FiltroDias,1)    
  ORDER BY RISCO DESC, IDOSO DESC, PRIORIDADE DESC, F.ACO_CODIGO ASC                                                         
                  
 END                                                            
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- Seleciona os pacientes da fila sem risco                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @OPCAO = 13                                                                    
 BEGIN                                                             
 SELECT  F.SPA_CODIGO,                                               
  F.EMER_CODIGO,                                                      
  F.ACO_CODIGO,                                                                    
  case when pd.id is null then     
  --existe isnull nos apelidos pac(paciente), pacE(paciente), f(VWUPA_FILA)    
   isnull(case when pac.pac_nome_social is not null then pac.pac_nome_social + '[' + pac.pac_nome + ']' else pac.pac_nome end, -- verificar na pac(paciente)    
     (isnull(case when pacE.pac_nome_social is not null then pacE.pac_nome_social + '[' + pacE.pac_nome + ']' else pacE.pac_nome end, -- verificar na pacE(paciente)     
        case when f.nomesocial is not null then f.nomesocial + '[' + f.nome + ']' else F.NOME end))) -- verificar na f(VWUPA_FILA)    
   ELSE 'DENGUE - ' + isnull(case when pac.pac_nome_social is not null then pac.pac_nome_social + '[' + pac.pac_nome + ']' else pac.pac_nome end, -- verificar na pac(paciente)    
     (isnull(case when pacE.pac_nome_social is not null then pacE.pac_nome_social + '[' + pacE.pac_nome + ']' else pacE.pac_nome end, -- verificar na pacE(paciente)    
        case when f.nomesocial is not null then f.nomesocial + '[' + f.nome + ']' else F.NOME end))) -- verificar na f(VWUPA_FILA)    
  END AS NOME,               
  LA.SET_DESCRICAO AS LOC_DESCRICAO,                                          
  A.ACO_DATAHORA AS DATAHORA,                                               
  F.RISCO,                                                                    
  F.SEQUENCIAL,                                                        
  F.CHAMADA_ATIVA,                                            
  F.DESTINO,                                                                    
  F.IDOSO,                                      
  NULL AS CHAMADA_ATIVA2,                                              
  NULL AS DESTINO2,    
  DATEDIFF(MINUTE,F.ACO_DATAHORA,GETDATE()) as TEMPOESPERAMINUTOS, --'' as TEMPOESPERAMINUTOS,    
     CASE    
  when  F.ACO_DATAHORA IS NOT NULL THEN    
   CASE     
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) <> 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) <> 0    
    THEN     
     convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) + ' Dia(s): ' +     
     convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) + ' Hora(s): '+    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) = 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) <> 0    
    THEN    
     convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) + ' Hora(s): '+    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) <> 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) = 0    
    THEN    
     convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) + ' Dia(s): ' +    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
    
    WHEN convert(varchar(10), ((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))/86400)) = 0    
    AND  convert(varchar(10), (((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)/3600)) = 0    
    THEN    
     convert(varchar(10), ((((DATEDIFF(SECOND,F.ACO_DATAHORA,GETDATE()))%86400)%3600)/60)) + ' Min'    
   END    
  End AS TEMPOESPERAATENDIMENTO,--'' as TEMPOESPERAATENDIMENTO,    
     FPU.DATA_ULTIMO_ATENDIMENTO AS DATAULTIMOATENDIMENTO --'' AS DATAULTIMOATENDIMENTO                                                      
 from    upa_acolhimento A                                                              
  INNER JOIN VWLOCAL_UNIDADE LA ON (A.LOCATEND_CODIGO = LA.LOCATEND_CODIGO)                                                             
  INNER JOIN VWUPA_FILA F ON F.ACO_CODIGO = A.ACO_CODIGO                    
  left join pronto_atendimento pa on a.spa_codigo = pa.spa_codigo              
  left join emergencia emer on a.emer_codigo = emer.emer_codigo              
  left join paciente pac on pac.pac_codigo = pa.pac_codigo              
  left join paciente pacE on pacE.pac_codigo = emer.pac_codigo        
  left join protocolo_dengue pd on pd.aco_codigo = a.aco_codigo                                                          
  LEFT JOIN UNIDADE U ON U.UNID_CODIGO = @UNID_CODIGO    
  LEFT JOIN FILA_PACIENTE_ULTIMOATENDIMENTO FPU ON FPU.PAC_CODIGO = PAC.PAC_CODIGO AND FPU.LOCATEND_CODIGO = A.LOCATEND_CODIGO     
 where  A.LOCATEND_CODIGO = ISNULL(null, A.LOCATEND_CODIGO)                                         
  AND  NOT EXISTS (SELECT 1 FROM UPA_CLASSIFICACAO_RISCO CR                                                              
      WHERE CR.ACO_CODIGO = A.ACO_CODIGO)                                                            
  AND  NOT EXISTS (SELECT 1 FROM ATENDIMENTO_AMBULATORIAL AA                                                              
      WHERE AA.SPA_CODIGO = A.SPA_CODIGO)                                                            
  AND RISCO = 0    
  AND A.UNID_CODIGO=@UNID_CODIGO    
  and a.aco_datahora > dateadd(d, -@periodo, getdate())    
  AND (    
   (U.Fluxo_Atendimento = 0 AND (PA.spa_codigo IS NOT NULL OR EMER.emer_codigo IS NOT NULL))    
   OR (U.Fluxo_Atendimento = 1 AND (PA.spa_codigo IS NULL AND EMER.emer_codigo IS NULL))    
  )    
 ORDER BY IDOSO DESC, PRIORIDADE DESC, F.ACO_CODIGO ASC    
                                                         
 END                                                              
                                                  
 -- PACIENTES AGUARDANDO REMOCAO                                                              
 if @opcao = 14                                     
 BEGIN                                                              
                                                             
  select                                                    
  a.atendamb_codigo,                                                              
  a.spa_codigo as codigo,                                                               
  nome = case when pac.pac_nome_social is not null or p.spa_nome_social is not null then isnull(pac.pac_nome_social, p.spa_nome_social) + '[' + isnull(pac.pac_nome, p.spa_nome) + ']' else isnull(pac.pac_nome, p.spa_nome) end,    
  u.set_descricao,                                                              
  NULL as leito,                                   
  NULL AS inter_codigo,                                                              
  prof.prof_nome,                                                              
  case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco                                                          
  from                                                                
  pronto_atendimento p                                                         
  inner join upa_acolhimento ua on  p.spa_codigo = ua.spa_codigo                             
  left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                
  left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo      
  left join risco_acolhimento rap on rap.risaco_codigo = p.risaco_codigo                                                          
  inner join vwlocal_unidade u on  u.locatend_codigo = p.locatend_codigo         
inner join atendimento_ambulatorial a on  a.spa_codigo = p.spa_codigo         
        
  left join  upa_atendimento_medico am on ( a.atendamb_codigo = am.atendamb_codigo   and  am.tipsai_codigo = 5 )           
  left join  atendimento_clinico ac  on    ( a.atendamb_codigo   = ac.atendamb_codigo )        
        
  inner join  profissional prof on (prof.prof_codigo = a.prof_codigo and prof.locatend_codigo = a.locatend_codigo)                         
  left join paciente pac on pac.pac_codigo = p.pac_codigo              
        
  where  a.atendamb_datafinal is null                                                              
  and not exists (SELECT 1 FROM INTERNACAO I WHERE I.SPA_CODIGO = P.SPA_CODIGO)            
  and (ac.atendamb_encaminhamento = 5 or tipsai_codigoAmbulatorio = 5)        
  and convert(smalldatetime,@DATA_INICIAL, 103) <= am.upaatemed_DataSaida          
  and  DATEADD(DAY,1,convert(smalldatetime,@DATA_FINAL, 103)) > am.upaatemed_DataSaida         
           
                                                             
 union all                                                              
                                                             
   -- INTERNADOS                            
  select                                                               
  a.atendamb_codigo,                                                              
  a.spa_codigo as codigo,                                                               
  nome = case when pac.pac_nome_social is not null or p.spa_nome_social is not null then isnull(pac.pac_nome_social, p.spa_nome_social) + '[' + isnull(pac.pac_nome, p.spa_nome) + ']' else isnull(pac.pac_nome, p.spa_nome) end,                             
  
    
                               
  u.set_descricao,                                            
  LocInt_Descricao as leito,                                                              
  i.inter_codigo,                                                              
  prof.prof_nome,                                                 
  case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco                                                          
  from                                                                
  pronto_atendimento p                                                              
  inner join  upa_acolhimento ua on  p.spa_codigo = ua.spa_codigo                                                                           
  left join upa_classificacao_risco cr on cr.aco_codigo = ua.aco_codigo                                                                       
  left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo                                    
  left join risco_acolhimento rap on rap.risaco_codigo = p.risaco_codigo                                                          
  inner join  vwlocal_unidade u on  u.locatend_codigo = p.locatend_codigo                                                       
  inner join Atendimento_Ambulatorial a on a.spa_Codigo = p.spa_Codigo                                               
  inner join upa_atendimento_medico am on am.atendamb_codigo = a.atendamb_codigo                                               
  inner join  internacao i on  i.spa_codigo = p.spa_codigo                                                                                  
  left join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                              
  inner join  profissional prof on (prof.prof_codigo = i.prof_codigo and prof.locatend_codigo = i.locatend_codigo)                                                              
  left join paciente pac on pac.pac_codigo = p.pac_codigo      
  where                                                          
  tipsai_codigo = 5                                                              
  and i.inter_dtalta is null            
  and convert(smalldatetime,@DATA_INICIAL, 103) <= a.atendamb_datainicio        
  and convert(smalldatetime,@DATA_FINAL, 103) >= a.atendamb_datainicio                                                           
                                                             
  union all                                                   
                                                             
-- EMERGENCIA                                                              
  select                                                               
  a.atendamb_codigo,                                                    
  a.emer_codigo as codigo,                                                              
  nome = case when pac.pac_nome_social is not null or e.emer_nome_social is not null then isnull(pac.pac_nome_social, e.emer_nome_social) + '[' + isnull(pac.pac_nome, e.emer_nome) + ']' else isnull(pac.pac_nome, e.emer_nome) end,             
  u.set_descricao,                          
  NULL as leito,                              
  NULL AS inter_codigo,                                                              
  prof.prof_nome,                                                              
  case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco                                                          
  from                                
  emergencia e                                                              
  left join  upa_acolhimento ua on e.emer_codigo = ua.emer_codigo                                                              
  left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                                                       
  left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo           
  left join risco_acolhimento rap on rap.risaco_codigo = e.risaco_codigo                                                          
  inner join  vwlocal_unidade u on  u.locatend_codigo = e.locatend_codigo                                  
  inner join  atendimento_ambulatorial a on  a.emer_codigo = e.emer_codigo                                                                                  
        
  left join  upa_atendimento_medico am on ( a.atendamb_codigo = am.atendamb_codigo   and  am.tipsai_codigo = 5 )           
  left join  atendimento_clinico ac  on    ( a.atendamb_codigo   = ac.atendamb_codigo )        
        
  inner join  profissional prof on (prof.prof_codigo = a.prof_codigo and prof.locatend_codigo = a.locatend_codigo)                                                         
  left join paciente pac on e.pac_codigo = pac.pac_codigo              
        
  where  a.atendamb_datafinal  is null                                                              
  and not exists (SELECT 1 FROM INTERNACAO I WHERE I.EMER_CODIGO = E.EMER_CODIGO)          
  and (ac.atendamb_encaminhamento = 5 or tipsai_codigoAmbulatorio = 5)        
  and convert(smalldatetime,@DATA_INICIAL, 103) <= a.atendamb_datainicio          
  and convert(smalldatetime,@DATA_FINAL, 103) >= a.atendamb_datainicio         
                                                             
  union all                                                              
                                                             
   -- INTERNADOS                                                              
  select                                                               
  a.atendamb_codigo,                                                              
  a.emer_codigo as codigo,                                                  
  nome = case when pac.pac_nome_social is not null or e.emer_nome_social is not null then isnull(pac.pac_nome_social, e.emer_nome_social) + '[' + isnull(pac.pac_nome, e.emer_nome) + ']' else isnull(pac.pac_nome, e.emer_nome) end,                    
  u.set_descricao,                                                              
  LocInt_Descricao as leito,                                                              
  i.inter_codigo,                                                              
  prof.prof_nome,                                                              
  case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco                                                          
  from                                                                
  emergencia e                                     
  inner join  upa_acolhimento ua on e.emer_codigo = ua.emer_codigo                                                              
  left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                                                 
  left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo                                                          
  left join risco_acolhimento rap on rap.risaco_codigo = e.risaco_codigo                                                          
  inner join  vwlocal_unidade u on  u.locatend_codigo = e.locatend_codigo                                                              
  inner join Atendimento_Ambulatorial a on a.emer_Codigo = e.emer_Codigo                                                              
  inner join upa_atendimento_medico am on am.atendamb_codigo = a.atendamb_codigo                                                              
  inner join  internacao i on i.emer_codigo = e.emer_codigo                                                                                  
  left join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                                              
  inner join  profissional prof on (prof.prof_codigo = i.prof_codigo and prof.locatend_codigo = i.locatend_codigo)                                                        
  left join paciente pac on e.pac_codigo = pac.pac_codigo              
  where                                                                
  tipsai_codigo = 5                                                              
  and i.inter_dtalta is null           
  and convert(smalldatetime,@DATA_INICIAL, 103) <= a.atendamb_datainicio          
  and convert(smalldatetime,@DATA_FINAL, 103) >= a.atendamb_datainicio                                                            
                                                             
  order by upaclaris_risco desc                                                              
                                                             
 END                                       
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- ESPECIALIDADE COM ATENDIMENTOS EM ABERTO                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @opcao = 15                                                 
                                                             
 BEGIN                                                              
                                                       
 SELECT X.SPA_CODIGO, X.NOME, X.NOME_SOCIAL, X.LOC_DESCRICAO,    
    X.PROF_NOME, X.LOCATEND_CODIGO, X.PROF_CODIGO,    
    Y.TOTALSEMRETORNO, Z.TOTALCOMRETORNO, W.UPAENC_PRIORIDADE, W.UPAENC_DATAENCAMINHADO, '0' AS TIPO,    
    X.ATENDAMB_CODIGO,    
    XPTO.TOTALPRESCRICAO,    
    XPT.TOTALPRESCFECHADA,    
 X.LAUDOLIBERADO_R as TotalLaudoLiberadoRadiologia,    
    X.LAUDOLIBERADO_D AS TotalLaudoLiberadoDiagnose,    
    kl.TOTALLAUDOLABORATORIO AS TotalLaudoLaboratorio,    
    ISNULL (X.LAUDOLIBERADO_R,ISNULL(X.LAUDOLIBERADO_D, KL.TOTALLAUDOLABORATORIO)) AS LAUDOLIBERADO,    
    --ISNULL(LAUDOLIBERADO, KL.TOTALLAUDOLABORATORIO) AS LAUDOLIBERADO,    
    X.atendamb_datafinal AS ATENDAMB_DATAFINALIZADO,    
 X.risaco_codigo    
    
  FROM    
   -- MONTA TABELA COM PRONTO_ATENDIMENTO COM SAIDA DIFERENTE DE REMOCAO E OBITO OU SEM TIPO DE SAIDA    
   -- QUE NAO POSSUEM INTERNACAO E ESTAO SEM DATA FINAL (ATENDIMENTO EM ABERTO)    
   -- PODENDO LEVAR EM CONSIDERACAO O LOCAL DE ATENDIMENTO OU PACIENTE    
   (SELECT TOP 100 PA.SPA_CODIGO AS [SPA_CODIGO],    
  (CASE                   
    WHEN ISNULL((ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social)), 'N') = 'N'    
   THEN ''    
   ELSE ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social) + ' ['      
   END  +  ISNULL(PAC.PAC_NOME, PA.SPA_NOME)  +     
   CASE                   
  WHEN ISNULL((ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social)), 'N') = 'N'    
   THEN ''    
   ELSE ']'    
   END)    
  AS NOME,      
  ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social) AS NOME_SOCIAL,    
  LA.SET_DESCRICAO AS LOC_DESCRICAO,    
  PROF.PROF_NOME,    
  AA.LOCATEND_CODIGO,    
  AA.PROF_CODIGO,    
  AA.ATENDAMB_CODIGO,    
  LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS LAUDOLIBERADO_R,    
  LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS LAUDOLIBERADO_D,    
  AA.atendamb_datafinal,    
  LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia,    
  LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose,    
  UCR.risaco_codigo    
    
  FROM  PRONTO_ATENDIMENTO PA WITH (NOLOCK)    
  INNER JOIN PACIENTE PAC WITH (NOLOCK) ON PAC.PAC_CODIGO = PA.PAC_CODIGO    
  INNER JOIN ATENDIMENTO_AMBULATORIAL AA WITH (NOLOCK) ON PA.SPA_CODIGO = AA.SPA_CODIGO    
  INNER JOIN UPA_ATENDIMENTO_MEDICO AM WITH (NOLOCK) ON AA.ATENDAMB_CODIGO = AM.ATENDAMB_CODIGO    
  INNER JOIN PROFISSIONAL PROF WITH (NOLOCK) ON (PROF.PROF_CODIGO = AA.PROF_CODIGO AND PROF.LOCATEND_CODIGO = AA.LOCATEND_CODIGO)    
  INNER JOIN VWCLINICA_SPA LA WITH (NOLOCK) ON PA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO    
  LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP WITH (NOLOCK)    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON PA.SPA_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM    
    
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP WITH (NOLOCK)    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON PA.SPA_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
    
 LEFT JOIN UPA_ACOLHIMENTO UA WITH (NOLOCK) ON PA.spa_codigo = UA.spa_codigo    
 LEFT JOIN UPA_Classificacao_Risco UCR WITH (NOLOCK) ON UA.ACO_CODIGO = UCR.aco_codigo     
    
  WHERE AA.ATENDAMB_DATAFINAL IS NULL    
  AND (AM.TIPSAI_CODIGO <> 5 OR AM.TIPSAI_CODIGO IS NULL)    
  AND (AM.TIPSAI_CODIGOENCAMINHAMENTO <> 5 OR AM.TIPSAI_CODIGOENCAMINHAMENTO  IS NULL)    
  AND EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WITH (NOLOCK) WHERE PROF_CODIGO = @PROF_CODIGO AND AA.LOCATEND_CODIGO = LOCATEND_CODIGO)    
  AND AA.PAC_CODIGO = ISNULL(@PAC_CODIGO, AA.PAC_CODIGO)    
  AND NOT EXISTS (SELECT 1 FROM INTERNACAO I WITH (NOLOCK)    
    WHERE I.SPA_CODIGO = PA.SPA_CODIGO) ORDER BY PA.SPA_CODIGO DESC ) X    
    
  LEFT JOIN    
      
   -- MONTA TABELA COM OS ATENDIMENTO ENCAMINHADOS COM RETORNO E QUE AINDA NAO RETORNARAM    
   (SELECT SPA_CODIGO, UPAENC_PRIORIDADE, UPAENC_DATAENCAMINHADO    
   FROM UPA_ENCAMINHAMENTO WITH (NOLOCK)    
   WHERE UPATIPENC_CODIGO = 3    
   AND UPAENC_DATARETORNO IS NULL) W ON W.SPA_CODIGO = X.SPA_CODIGO    
    
  LEFT JOIN    
    
   (SELECT DISTINCT SOLPED_CODIGOORIGEM, ORIPAC_CODIGO, COUNT(*) AS TOTALLAUDOLABORATORIO    
   FROM SOLICITACAO_PEDIDO_EXAME SPE  WITH (NOLOCK)    
   INNER JOIN VWSOLICITACAO_PEDIDO SP WITH (NOLOCK) ON SPE.PED_CODIGO = SP.PED_CODIGO    
   INNER JOIN EXAME_SOLICITADO_LABORATORIO EL WITH (NOLOCK) ON SPE.SOLPEDEXA_CODIGO_EXAME = EL.EXALAB_CODIGO    
   AND SP.SOLPED_CODIGOPEDIDO = EL.PEDEXALAB_CODIGO AND SP.SOLPED_TIPOSOLICITACAO = 7 AND (EL.EXASOLLAB_STATUS = 'LA' OR EL.EXASOLLAB_STATUS  = 'LI')    
   GROUP BY SOLPED_CODIGOORIGEM, ORIPAC_CODIGO) KL --RESULTADOS DO MODULO DE LABORATORIO DO KLINIKOS    
    
   ON (KL.SOLPED_CODIGOORIGEM = X.SPA_CODIGO AND KL.ORIPAC_CODIGO = 5)    
    
   LEFT JOIN    
    
   (SELECT SPA_CODIGO, COUNT(*) AS TOTALSEMRETORNO    
   FROM UPA_ENCAMINHAMENTO  WITH (NOLOCK)    
   WHERE UPAENC_DATARETORNO IS NULL    
   GROUP BY SPA_CODIGO) Y     
       
   ON X.SPA_CODIGO = Y.SPA_CODIGO    
    
   LEFT JOIN    
    
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALCOMRETORNO    
   FROM UPA_ENCAMINHAMENTO WITH (NOLOCK)    
   WHERE UPAENC_DATARETORNO IS NOT NULL    
   GROUP BY SPA_CODIGO) Z     
       
   ON X.SPA_CODIGO = Z.SPA_CODIGO    
    
   LEFT JOIN    
    
   (SELECT DISTINCT SPA_CODIGO,    
    COUNT(*) AS TOTALPRESCRICAO    
    FROM PRESCRICAO WITH (NOLOCK)    
    WHERE PRESC_TIPO = 'P'    
    GROUP BY SPA_CODIGO) XPTO     
        
    ON X.SPA_CODIGO = XPTO.SPA_CODIGO    
    
   LEFT JOIN    
    
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCFECHADA    
   FROM PRESCRICAO WITH (NOLOCK)    
   WHERE IDT_FECHADA = 'S'    
   AND PRESC_TIPO = 'P'    
   GROUP BY SPA_CODIGO) XPT     
       
   ON X.SPA_CODIGO = XPT.SPA_CODIGO    
    
  UNION    
    SELECT X.SPA_CODIGO, X.NOME, X.NOME_SOCIAL, X.LOC_DESCRICAO,    
    X.PROF_NOME, X.LOCATEND_CODIGO, X.PROF_CODIGO,    
    NULL, NULL, W.UPAENC_PRIORIDADE, W.UPAENC_DATAENCAMINHADO, '1' AS TIPO,    
    X.ATENDAMB_CODIGO,    
    XPTO.TOTALPRESCRICAO,    
    XPT.TOTALPRESCFECHADA,    
 X.LAUDOLIBERADO_R as TotalLaudoLiberadoRadiologia,    
    X.LAUDOLIBERADO_D AS TotalLaudoLiberadoDiagnose,    
    kl.TOTALLAUDOLABORATORIO AS TotalLaudoLaboratorio,    
    ISNULL (X.LAUDOLIBERADO_R,ISNULL(X.LAUDOLIBERADO_D, KL.TOTALLAUDOLABORATORIO)) AS LAUDOLIBERADO,    
    --ISNULL(LAUDOLIBERADO, KL.TOTALLAUDOLABORATORIO) AS LAUDOLIBERADO,    
    X.atendamb_datafinal AS ATENDAMB_DATAFINALIZADO,    
 X.risaco_codigo    
  FROM    
   (SELECT TOP 100 PA.SPA_CODIGO AS [SPA_CODIGO],    
   (CASE                   
    WHEN ISNULL((ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social)), 'N') = 'N'    
   THEN ''    
   ELSE ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social) + ' ['      
   END  +  ISNULL(PAC.PAC_NOME, PA.SPA_NOME)  +     
   CASE                   
  WHEN ISNULL((ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social)), 'N') = 'N'    
   THEN ''    
   ELSE ']'    
   END)    
  AS NOME,      
  ISNULL(PAC.PAC_NOME_SOCIAL,PA.spa_nome_social) AS NOME_SOCIAL,    
   LA.SET_DESCRICAO AS LOC_DESCRICAO,    
   PROF.PROF_NOME,    
   AA.LOCATEND_CODIGO,    
   AA.PROF_CODIGO,    
   AA.ATENDAMB_CODIGO,    
   LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS LAUDOLIBERADO_R,    
   LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS LAUDOLIBERADO_D,    
   AA.atendamb_datafinal,    
   UCR.risaco_codigo    
    FROM  PRONTO_ATENDIMENTO PA WITH (NOLOCK)    
    INNER JOIN PACIENTE PAC WITH (NOLOCK) ON PAC.PAC_CODIGO = PA.PAC_CODIGO    
    INNER JOIN ATENDIMENTO_AMBULATORIAL AA WITH (NOLOCK) ON PA.SPA_CODIGO = AA.SPA_CODIGO    
    INNER JOIN UPA_ATENDIMENTO_MEDICO AM WITH (NOLOCK) ON AA.ATENDAMB_CODIGO = AM.ATENDAMB_CODIGO    
    INNER JOIN PROFISSIONAL PROF WITH (NOLOCK) ON (PROF.PROF_CODIGO = AA.PROF_CODIGO AND PROF.LOCATEND_CODIGO = AA.LOCATEND_CODIGO)    
    INNER JOIN VWCLINICA_SPA LA WITH (NOLOCK) ON PA.LOCATEND_CODIGO = LA.LOCATEND_CODIGO    
    LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP WITH (NOLOCK)    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON PA.SPA_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM    
    
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP WITH (NOLOCK)    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON PA.SPA_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
 LEFT JOIN UPA_ACOLHIMENTO UA ON PA.spa_codigo = UA.spa_codigo    
 LEFT JOIN UPA_Classificacao_Risco UCR WITH (NOLOCK) ON UA.ACO_CODIGO = UCR.aco_codigo      
   WHERE AA.ATENDAMB_DATAFINAL IS NULL    
   AND (AM.TIPSAI_CODIGO <> 5 OR AM.TIPSAI_CODIGO IS NULL)    
   AND (AM.TIPSAI_CODIGOENCAMINHAMENTO <> 5 OR AM.TIPSAI_CODIGOENCAMINHAMENTO  IS NULL)    
   AND AA.PAC_CODIGO = ISNULL(@PAC_CODIGO, AA.PAC_CODIGO)    
   AND NOT EXISTS (SELECT 1 FROM INTERNACAO I WHERE I.SPA_CODIGO = PA.SPA_CODIGO) ORDER BY PA.SPA_CODIGO DESC ) X    
    
   INNER JOIN    
    
   (SELECT Y.SPA_CODIGO, Z.UPAENC_PRIORIDADE, Z.UPAENC_DATAENCAMINHADO    
   FROM    
    (SELECT DISTINCT SPA_CODIGO    
    FROM UPA_ENCAMINHAMENTO  WITH (NOLOCK)    
    WHERE    
    EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WITH (NOLOCK) WHERE PROF_CODIGO = @PROF_CODIGO AND LOCATEND_CODIGO_DESTINO = LOCATEND_CODIGO)    
    AND (PROF_CODIGO_ORIGEM <> @PROF_CODIGO)    
    AND UPAENC_DATARETORNO IS NULL) Y    
    INNER JOIN    
    
    (SELECT SPA_CODIGO, UPAENC_PRIORIDADE, UPAENC_DATAENCAMINHADO    
    FROM UPA_ENCAMINHAMENTO  WITH (NOLOCK)    
    WHERE UPATIPENC_CODIGO = 3    
    AND EXISTS (SELECT 1 FROM PROFISSIONAL_LOTACAO WITH (NOLOCK) WHERE PROF_CODIGO = @PROF_CODIGO AND LOCATEND_CODIGO_DESTINO = LOCATEND_CODIGO) AND (PROF_CODIGO_ORIGEM <> @PROF_CODIGO)    
    AND UPAENC_DATARETORNO IS NULL) Z    
       
   ON Y.SPA_CODIGO = Z.SPA_CODIGO) W ON X.SPA_CODIGO = W.SPA_CODIGO    
    
   LEFT JOIN    
    
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCRICAO    
   FROM PRESCRICAO WITH (NOLOCK)    
   WHERE PRESC_TIPO = 'P'    
   GROUP BY SPA_CODIGO) XPTO ON X.SPA_CODIGO = XPTO.SPA_CODIGO    
    
   LEFT JOIN    
       
  (SELECT DISTINCT SOLPED_CODIGOORIGEM, ORIPAC_CODIGO, COUNT(*) AS TOTALLAUDOLABORATORIO    
   FROM SOLICITACAO_PEDIDO_EXAME SPE WITH (NOLOCK)    
   INNER JOIN VWSOLICITACAO_PEDIDO SP WITH (NOLOCK) ON SPE.PED_CODIGO = SP.PED_CODIGO    
   INNER JOIN EXAME_SOLICITADO_LABORATORIO EL WITH (NOLOCK) ON SPE.SOLPEDEXA_CODIGO_EXAME = EL.EXALAB_CODIGO    
   AND SP.SOLPED_CODIGOPEDIDO = EL.PEDEXALAB_CODIGO AND SP.SOLPED_TIPOSOLICITACAO = 7 AND (EL.EXASOLLAB_STATUS = 'LA' OR EL.EXASOLLAB_STATUS  = 'LI')    
   GROUP BY SOLPED_CODIGOORIGEM, ORIPAC_CODIGO) KL --RESULTADOS DO MODULO DE LABORATORIO DO KLINIKOS    
    
   ON (KL.SOLPED_CODIGOORIGEM = X.SPA_CODIGO AND KL.ORIPAC_CODIGO = 5)    
    
   LEFT JOIN    
   (SELECT DISTINCT SPA_CODIGO, COUNT(*) AS TOTALPRESCFECHADA    
   FROM PRESCRICAO WITH (NOLOCK)    
   WHERE IDT_FECHADA = 'S'    
   AND PRESC_TIPO = 'P'    
   GROUP BY SPA_CODIGO) XPT     
       
   ON X.SPA_CODIGO = XPT.SPA_CODIGO    
       
   ORDER BY X.SPA_CODIGO DESC    
               
                       
 END                                                              
                                                   
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- RETORNA OS DADOS PARA ADMINISTRACAO DA FILA                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @opcao = 16                                                              
 BEGIN                                                              
                                                             
  DECLARE @WDataInicial smalldatetime                                                              
  DECLARE @WDataFinal smalldatetime                                                              
                                                             
  IF (@DATA_INICIAL IS NULL)                                                              
  BEGIN                                                              
   SET @WDataInicial = convert(smalldatetime, '01/01/1980 00:00:00', 103)                                                      
  END                                                              
  ELSE                                                              
  BEGIN                                                              
   SET @WDataInicial = convert(smalldatetime, @DATA_INICIAL, 103)                                                           
  END                                                              
                                                             
  IF (@DATA_FINAL IS NULL)                                                              
  BEGIN                                                              
   SET @WDataFinal = GETDATE()                                         
  END                                                              
  ELSE                                                          
  BEGIN                                                              
   SET @WDataFinal = convert(smalldatetime, @DATA_FINAL,103)                                                              
  END                                                              
                                                              
  SELECT ACO_CODIGO, A.SPA_CODIGO, NOME, RISCO,                   
   CASE WHEN LOC_DESCRICAO_SPA IS NOT NULL THEN LOC_DESCRICAO_SPA ELSE LOC_DESCRICAO END AS LOC_DESCRICAO,                   
   DATAHORA, SEQUENCIAL, DATA_CONFIRMACAO, NUM_CHAMADAS, CHAMADA_ATIVA, DATA_CANCELAMENTO, DESTINO                                                                    
  FROM                                                                    
  (                                                               
  SELECT F.ACO_CODIGO,                                                                    
    F.SPA_CODIGO,                                                                    
    NOME = case when pac.pac_nome_social is not null or f.NOMESOCIAL is not null then ISNULL(PAC.pac_nome_social, F.NOMESOCIAL) + '[' + ISNULL(PAC.PAC_NOME, F.NOME) + ']' else ISNULL(PAC.PAC_NOME, F.NOME) end,               
    F.RISCO,                                                                    
    LU.SET_DESCRICAO AS LOC_DESCRICAO,                                              
    F.ACO_DATAHORA AS DATAHORA,                                                                    
    FS.SEQUENCIAL,                                               
    F.DATA_CONFIRMACAO,                                                                    
    F.NUM_CHAMADAS,                                               
    CASE WHEN ((PN.ACO_CODIGO IS NOT NULL) OR (F.DATA_CONFIRMACAO IS NOT NULL))                                                                    
  THEN 1   
  ELSE 0               
    END AS CHAMADA_ATIVA,                                                                    
    F.DATA_CANCELAMENTO,                                     
    F.DESTINO,                                                                    
    FS.PRIORIDADE,                                                            
   F.ACO_IDOSO,                                                          
    PUR.MODATE_CODIGO                                                            
  FROM UPA_FILA F                                                                    
  INNER JOIN UPA_FILA_SEQUENCIAL FS ON FS.ACO_CODIGO = F.ACO_CODIGO                                                                    
  LEFT OUTER JOIN UPA_PAINEL PN ON PN.ACO_CODIGO = F.ACO_CODIGO                                         
  LEFT OUTER JOIN VWLOCAL_UNIDADE LU ON F.LOCATEND_CODIGO = LU.LOCATEND_CODIGO                                                          
  LEFT JOIN UPA_CLASSIFICACAO_RISCO CR ON CR.ACO_CODIGO = FS.ACO_CODIGO                                                                          
  LEFT JOIN PARAMETRO_UNIDADE_REDE PUR on PUR.UNID_CODIGO = LU.UNID_CODIGO               
  LEFT JOIn Pronto_Atendimento pa1 ON F.SPA_CODIGO = PA1.SPA_CODIGO                   
  LEFT JOIN PACIENTE PAC ON PAC.PAC_CODIGO = PA1.PAC_CODIGO              
  ) A                                                          
                   
 left join                   
                   
 (select SPA_CODIGO,LU.SET_DESCRICAO as LOC_DESCRICAO_SPA from Pronto_Atendimento pa                  
  LEFT OUTER JOIN VWLOCAL_UNIDADE LU ON pa.LOCATEND_CODIGO = LU.LOCATEND_CODIGO                                        ) b                  
  on b.spa_codigo = a.spa_codigo                  
                   
  WHERE                                                              
   (@CANCELADOS = 'S' OR A.DATA_CANCELAMENTO is null)                                                            
   AND A.DATAHORA >= @WDataInicial                                                              
   AND A.DATAHORA <= @WDataFinal                                                              
   AND convert(int,A.RISCO) <= (select top 1 convert(int,risaco_gravidade)                                                           
     from risco_acolhimento ra                                                          
     join protocolo_acolhimento pa on ra.proate_codigo = pa.proate_codigo                                                          
     join unidade u on pa.proate_codigo = u.unid_modelo_risco                                                          
     where risaco_fila = 'E'                                                          
     order by risaco_gravidade desc)                                                          
                                                             
 ORDER BY A.RISCO DESC, A.ACO_IDOSO DESC, A.PRIORIDADE DESC, A.ACO_CODIGO ASC                                                            
                                                             
 END                                                              
                                                             
 -- #####################################################################                                                              
 -- RESUMO DA FILA                                                              
 -- #####################################################################                                         
         
if (@opcao = 18)                                                              
 BEGIN                                                              
                                                             
  SELECT  COUNT(F.ACO_CODIGO), L.SET_DESCRICAO, 'REGISTRO'                                                              
  FROM                                                               
   VWUPA_FILA F        
   INNER JOIN UPA_ACOLHIMENTO A ON (A.ACO_CODIGO = F.ACO_CODIGO)                                                          
   INNER JOIN VWLOCAL_UNIDADE L ON (A.LOCATEND_CODIGO = L.LOCATEND_CODIGO)              
  WHERE  F.SPA_CODIGO IS NULL                                                              
  AND A.UNID_CODIGO = @UNID_CODIGO                                                              
  GROUP BY L.SET_DESCRICAO                                                              
  UNION                                                              
  SELECT  COUNT(F.ACO_CODIGO), L.SET_DESCRICAO, 'RISCO'                                                              
  FROM                                                               
   VWUPA_FILA F                                                              
   INNER JOIN PRONTO_ATENDIMENTO P ON (P.SPA_CODIGO = F.SPA_CODIGO)                       INNER JOIN VWLOCAL_UNIDADE L ON (P.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                               
  WHERE  F.RISCO = 1                                                              
  AND NOT EXISTS (SELECT 1 FROM UPA_CLASSIFICACAO_RISCO CR WHERE CR.ACO_CODIGO = F.ACO_CODIGO)                                  
  AND P.UNID_CODIGO = @UNID_CODIGO                                                              
  GROUP BY L.SET_DESCRICAO                                                              
  UNION                             
  SELECT  COUNT(F.ACO_CODIGO), L.SET_DESCRICAO, 'ATENDIMENTO'                                                              
  FROM                                                               
   VWUPA_FILA F                                                              
   INNER JOIN PRONTO_ATENDIMENTO P ON (P.SPA_CODIGO = F.SPA_CODIGO)                                                              
   INNER JOIN VWLOCAL_UNIDADE L ON (P.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                               
  WHERE  F.RISCO IN (0,2)                                                              
  AND P.UNID_CODIGO = @UNID_CODIGO                                                              
  GROUP BY L.SET_DESCRICAO                                                              
  UNION                                                              
  SELECT  COUNT(F.ACO_CODIGO), L.SET_DESCRICAO, 'INTERNACAO - RISCO AMARELO'                                                              
  FROM                                                               
   VWUPA_FILA F                                                              
   INNER JOIN PRONTO_ATENDIMENTO P ON (P.SPA_CODIGO = F.SPA_CODIGO)                                                              
   INNER JOIN VWLOCAL_UNIDADE L ON (P.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                               
  WHERE  F.RISCO IN (4)                                                              
  AND P.UNID_CODIGO = @UNID_CODIGO                                                              
  GROUP BY L.SET_DESCRICAO                                                           
  UNION                                                              
  SELECT  COUNT(F.ACO_CODIGO), L.SET_DESCRICAO, 'INTERNACAO - RISCO VERMELHO'                                                              
  FROM                                                               
   VWUPA_FILA F                                                              
   INNER JOIN PRONTO_ATENDIMENTO P ON (P.SPA_CODIGO = F.SPA_CODIGO)         
   INNER JOIN VWLOCAL_UNIDADE L ON (P.LOCATEND_CODIGO = L.LOCATEND_CODIGO)                                                               
  WHERE  F.RISCO IN (6)                                          
 GROUP BY L.SET_DESCRICAO                                                              
 order by 3                                                               
                       
                                                
 END          
                                                             
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- ATUALIZAR A FILA DO PACIENTE REGISTRADO PELA CLASSIFICACAO DE RISCO                                                              
 -- ESTE PROCEDIMENTO FAZ COM QUE O PACIENTE NAO PRECISE SER CHAMADO NOVAMENTE                                                              
 -- QUANDO RETORNAR AO CADASTRO DA CLASSIFICACAO DE RISCO                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                              
 if (@opcao = 19)                                                              
 BEGIN           UPDATE UPA_FILA SET                                                              
    NUM_CHAMADAS = 1,                                                              
    DATA_CONFIRMACAO = GETDATE()                                                              
  WHERE  ACO_CODIGO = @ACO_CODIGO                                                              
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- ATUALIZAR A FILA DO PACIENTE SALVO NA CLASSIFICACAO DE RISCO APOS SER REGISTRADO                                
 -- PELA PROPRIA CLASSICACAO DE RISCO                                                              
 -- ESTE PROCEDIMENTO DESFAZ A ACAO DA OPCAO 19 AO SALVAR A CLASSIFICACAO DE RISCO                                                               
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 if (@opcao = 20)                                                              
 BEGIN                                                              
  UPDATE UPA_FILA SET                                                              
    NUM_CHAMADAS = 0,                                    
    DATA_CONFIRMACAO = NULL                                                              
  WHERE  ACO_CODIGO = @ACO_CODIGO                                                              
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- DataHora em que o paciente foi confirmado no atendimento mÃƒÆ’Ã‚Â©dico                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 if (@opcao = 21)                                                              
 BEGIN                                                              
  IF(@SPA_CODIGO IS NOT NULL)                                             
  BEGIN                                                              
   SELECT max(DATA_HISTORICO) as DataHistorico                
    FROM UPA_FILA_HISTORICO F                                              
  join UPA_ACOLHIMENTO UA on F.aco_codigo = UA.aco_codigo            
    WHERE F.ID_EVENTO = 11 and UA.spa_codigo = @SPA_CODIGO                                                              
   group by F.aco_codigo         
  END                                                              
  IF(@EMER_CODIGO IS NOT NULL)          
  BEGIN                                                              
   SELECT max(DATA_HISTORICO) as DataHistorico                                                              
    FROM UPA_FILA_HISTORICO F                                         
  join UPA_ACOLHIMENTO UA on F.aco_codigo = UA.aco_codigo                                                              
    WHERE F.ID_EVENTO = 11 and UA.emer_codigo = @EMER_CODIGO                                                              
   group by F.aco_codigo                                                        
  END                                                              
                                                             
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- Pular Fila Idoso                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF (@opcao = 22)                                                              
 BEGIN                                                              
  DECLARE @SEQUENCIAL1 INT, @SEQUENCIAL_SEMRISCOIDOSO INT, @Contador INT                                                              
                                                             
  -- Recupera o risco e o sequencial                                                              
  SELECT  @RISCO=RISCO, @SEQUENCIAL1=SEQUENCIAL                                                              
  FROM vwUPA_FILA         
  WHERE ACO_CODIGO=@ACO_CODIGO                                                              
                                                             
  IF (@RISCO = 0)                                                              
  BEGIN                                                              
   --Tratar quando existir idoso jÃƒÆ’Ã‚Â¡ na fila com ACO_CODIGO anterior ao ÃƒÆ’Ã‚Âºltimo incluido                                                              
   SELECT @Contador = COUNT(IDOSO)                                                              
   FROM vwUPA_FILA                                 
   WHERE RISCO = 0                       
   AND  IDOSO = 1                                                              
                                                       
   IF (@Contador > 1)                                                              
   BEGIN                                                              
                                                             
    -- Coloca o registro como ÃƒÆ’Ã‚Âºltimo da fila dos SEM RISCO e Idosos                                                              
    --Verifica qual o penÃƒÆ’Ã‚Âºltimo sequencial do idoso cadastrado(o ÃƒÆ’Ã‚Âºltimo ÃƒÆ’Ã‚Â© o novo acolhido)                                                              
    SELECT @SEQUENCIAL_SEMRISCO = (MAX(SEQUENCIAL) + 1)                                                               
    FROM vwUPA_FILA                                                              
    WHERE RISCO = 0                                                              
    AND  IDOSO = 1                                                              
    AND  ACO_CODIGO < @ACO_CODIGO                                                               
                                                             
   END                 
   ELSE                                                              
   BEGIN                                                              
    SELECT @SEQUENCIAL_SEMRISCO = (ISNULL(MAX(SEQUENCIAL), 0) +1)                                                              
    FROM vwUPA_FILA                                              
    WHERE convert(int,RISCO) <= (select top 1 convert(int,risaco_gravidade)                                                           
     from risco_acolhimento ra                                                          
     join protocolo_acolhimento pa on ra.proate_codigo = pa.proate_codigo              
     join unidade u on pa.proate_codigo = u.unid_modelo_risco                                                          
     where risaco_fila = 'E'                                                          
     order by risaco_gravidade desc)                                                              
                                                             
    --Atualiza o primeiro idoso                                                
                                                             
   END                                                              
                                                             
   --Atualiza o paciente escolhido                                        
   UPDATE  UPA_FILA_SEQUENCIAL SET                                                                    
    SEQUENCIAL = @SEQUENCIAL_SEMRISCO                                                                    
   WHERE  ACO_CODIGO = @ACO_CODIGO                                                              
                                                               
   -- ATUALIZA O RESTANTE DOS REGISTROS SEM RISCO E NÃƒÆ’Ã†â€™O IDOSOS                                                                    
   UPDATE  UPA_FILA_SEQUENCIAL SET                                                                    
    UPA_FILA_SEQUENCIAL.SEQUENCIAL = UPA_FILA_SEQUENCIAL.SEQUENCIAL + 1                                
    FROM VWUPA_FILA F                                                                  
   WHERE F.ACO_CODIGO = UPA_FILA_SEQUENCIAL.ACO_CODIGO                                                                  
   AND F.ACO_CODIGO <> @ACO_CODIGO                                                                    
   AND UPA_FILA_SEQUENCIAL.SEQUENCIAL >= @SEQUENCIAL_SEMRISCO                                                                    
   AND F.RISCO = 0                                                            
                                                               
   -- Inclui o registro no histÃƒÆ’Ã‚Â³rico                                                              
   IF (@ACO_CODIGO IS NOT NULL)                                                              
   BEGIN                                                                
    INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)                                                              
    VALUES (@ACO_CODIGO, GETDATE(), 7, @LOCAL_DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)                                                              
   END                                                              
                                                     
  END                                                              
 END                                           
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                             
 -- Seleciona os pacientes da fila para atendimento nÃƒÆ’Ã‚Â£o informatizado                                          
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                        
 if @opcao = 23                      
 BEGIN                                                              
   SELECT                                                          
   SPA_CODIGO,    
   ACO_CODIGO,                                                          
   vw.LOCATEND_CODIGO,                                                          
   LOCATEND_DESCRICAO,                         
   CASE WHEN NOMESOCIAL IS NOT NULL THEN    
  NOMESOCIAL + '[' + NOME + ']'    
   ELSE     
  NOME    
   END AS NOME,                                                           
   RISCO,                                                           
   SEQUENCIAL,     
   DATA_CONFIRMACAO,                                    
   NUM_CHAMADAS,                                                           
   CHAMADA_ATIVA,                                                           
   DATA_CANCELAMENTO,                                                           
   DESTINO,                                                           
   IDOSO,                                                           
   ACO_DATAHORA                                                              
  FROM  vwUPA_Fila_Atendimento_Circulante vw                                                          
  inner join  vwlocal_unidade localAtendimento on localAtendimento.locatend_codigo = vw.locatend_codigo                                                          
  where vw.LOCATEND_CODIGO = isnull(@LOCATEND_CODIGO, vw.LOCATEND_CODIGO)                                                          
  ORDER BY RISCO DESC, IDOSO DESC, PRIORIDADE DESC, ACO_CODIGO ASC                                                          
                                                             
 END                                                           
                                                             
 -- /////////////////////////////////////////////////////////////                                                              
 -- SELECIONA O NOMA QUE ESTA SENDO EXIBIDO NO PAINEL                                                              
 -- UTILIZADO PELO PAINEL NO MODO DE EXIBICAO MINIMIZADO                                                              
 -- /////////////////////////////////////////////////////////////                              
 IF @opcao = 24                                                              
 BEGIN             
                                                             
  SELECT TOP 1 P.ACO_CODIGO,                                                               
    F.DESTINO, CASE WHEN P.NOMESOCIAL IS NOT NULL THEN P.NOMESOCIAL ELSE P.NOME END AS 'NOME'                                                          
  FROM vwUPA_Painel P                                                              
  INNER JOIN vwUPA_FILA F ON F.ACO_CODIGO = P.ACO_CODIGO                                                              
  ORDER BY P.DATA_ULTIMA_EXIBICAO ASC, P.DATA_CHAMADA ASC                                                              
                                                             
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////           
 -- Seleciona os pacientes agendados no dia                                                  
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                        
 if @opcao = 25                                                              
 BEGIN                                                 
                                                             
 SELECT agd_sequencial,                                                      
   agd_datahora,    
   CASE WHEN p.pac_nome_social is not null THEN     
  p.pac_nome_social + '[' + p.pac_nome + ']'    
   ELSE    
  p.pac_nome    
   end as pac_nome,                                                                                                                     
   a.atend_codigo,                                 
   isnull(parbol_usacheckin,'N') parbol_usacheckin                                                              
                                                             
  FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                                                              
   left join parametro_boletim pb on (pb.unid_codigo = ac.unid_codigo)                                         
   left join atendimento a on a.atend_codigo = ac.atend_codigo                                      
                                               
  WHERE (ac.agd_situacao = '0' or ac.agd_situacao = '5')        
   and not exists                                                               
   (select 1 from atendimento_ambulatorial where atend_codigo = ac.atend_codigo)                                                              
   and ac.agd_datahora between convert(smalldatetime, convert(varchar,getdate(),112)) and dateadd(d,1,convert(smalldatetime, convert(varchar,getdate(),112)))                                                              
   and ac.prof_codigo = @PROF_CODIGO                                                              
   and ac.locatend_codigo = @LOCATEND_CODIGO                                                              
   and ac.unid_codigo = @UNID_CODIGO                                                              
                                                             
  ORDER BY agd_datahora                                                              
                                                           
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- Seleciona os pacientes da fila para Atendimento para EmergÃƒÆ’Ã‚Âªncia                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 if @opcao = 26                                                              
 BEGIN                                                              
  SELECT  E.EMER_CODIGO AS CODIGO                                                              
   ,F.ACO_CODIGO                                              
   ,F.NOME                                                               
   ,F.RISCO                                                              
   ,LA.SET_DESCRICAO AS LOC_DESCRICAO                                                              
   ,F.ACO_DATAHORA AS DATAHORA                                                              
   ,F.SEQUENCIAL                                                              
   ,F.CHAMADA_ATIVA                                            
   ,F.DESTINO                                                              
   ,UE.EMER_CODIGO_DESTINO AS CODIGO_DESTINO                                                              
   ,F.IDOSO                                                           
 FROM  EMERGENCIA E                                                              
  INNER JOIN VWCLINICA_SPA LA ON LA.LOCATEND_CODIGO = E.LOCATEND_CODIGO                                                              
  INNER JOIN vwUPA_FILA_Atendimento_Emergencia F ON F.EMER_CODIGO = E.EMER_CODIGO      
  LEFT JOIN UPA_ENCAMINHAMENTO UE ON (UE.LOCATEND_CODIGO_DESTINO = E.LOCATEND_CODIGO AND UE.EMER_CODIGO_DESTINO = E.EMER_CODIGO)                                                              
  WHERE LA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LA.LOCATEND_CODIGO)                                                              
  ORDER BY RISCO DESC, SEQUENCIAL ASC               
 END     
                     
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- PROFISSIONAL/ESPECIALIDADE COM ATENDIMENTOS EM ABERTO PARA EMERGENCIA                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                             
 IF @opcao = 27                                   
 BEGIN                                                              
  SELECT  X.EMER_CODIGO                          
   , X.NOME                                                              
   , X.LOC_DESCRICAO                                        
   , X.PROF_NOME                                                              
   , X.LOCATEND_CODIGO                                                              
   , X.PROF_CODIGO                            
   , Y.TOTALSEMRETORNO                                                              
   , Z.TOTALCOMRETORNO                                                   
   , W.UPAENC_PRIORIDADE                                                              
   , W.UPAENC_DATAENCAMINHADO                                                              
   , '0' AS TIPO                                                               
  FROM                                                               
   (                                                              
   SELECT  EMER.EMER_CODIGO AS [EMER_CODIGO]                                                              
    , NOME = isnull(pac.pac_nome, EMER.EMER_NOME)              
    , LA.SET_DESCRICAO AS LOC_DESCRICAO                                                      
    , PROF.PROF_NOME                                                              
    , AA.LOCATEND_CODIGO                                                              
    , AA.PROF_CODIGO                                        
   FROM  EMERGENCIA EMER                                                              
   INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON  AA.EMER_CODIGO = EMER.EMER_CODIGO                                                              
   INNER JOIN UPA_Atendimento_Medico AM ON AM.atendamb_CODIGO = AA.atendamb_CODIGO                                                              
   INNER JOIN PROFISSIONAL prof ON (prof.prof_codigo = AA.prof_codigo AND prof.locatend_codigo = AA.locatend_codigo)         
   INNER JOIN VWCLINICA_SPA LA ON LA.LOCATEND_CODIGO = EMER.LOCATEND_CODIGO                                              
   Left join paciente pac on pac.pac_codigo = emer.pac_codigo              
   WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO NOT IN (4,5) OR AM.TIPSAI_CODIGO IS NULL)                                                              
   AND AA.LOCATEND_CODIGO = @LOCATEND_CODIGO                                                              
   AND AA.PROF_CODIGO = @PROF_CODIGO                                                              
   AND NOT EXISTS                                                               
    (SELECT 1 FROM INTERNACAO I                                                              
  WHERE I.EMER_CODIGO = EMER.EMER_CODIGO)     
   ) X                                                              
   LEFT JOIN           
   (                                                              
   SELECT  EMER_CODIGO                                                              
    , UPAENC_PRIORIDADE                                                              
    , UPAENC_DATAENCAMINHADO                                                              
   FROM UPA_ENCAMINHAMENTO                                            
   WHERE UPATIPENC_CODIGO = 3                               
   AND UPAENC_DATARETORNO IS NULL                                                
   ) W                                                              
   ON W.EMER_CODIGO = X.EMER_CODIGO                                                              
  LEFT JOIN                                                        
   (                                                              
   SELECT  EMER_CODIGO                                                              
    , COUNT(*) AS TOTALSEMRETORNO                                                              
   FROM UPA_ENCAMINHAMENTO                     
   WHERE UPAENC_DATARETORNO IS NULL                                                              
   GROUP BY EMER_CODIGO                                        
   ) Y                                         
   ON Y.EMER_CODIGO = X.EMER_CODIGO                                                               
  LEFT JOIN                                                               
   (                                                              
   SELECT DISTINCT                                                               
    EMER_CODIGO                                                              
    , COUNT(*) AS TOTALCOMRETORNO                                    
   FROM UPA_ENCAMINHAMENTO                                                              
   WHERE UPAENC_DATARETORNO IS NOT NULL                                                              
   GROUP BY EMER_CODIGO                                                              
   ) Z                                                              
   ON Z.EMER_CODIGO = X.EMER_CODIGO                                                              
  UNION                                                              
  SELECT  X.EMER_CODIGO                                                              
   , X.NOME                                                              
   , X.LOC_DESCRICAO                                                              
   , X.PROF_NOME                                                              
   , X.LOCATEND_CODIGO                                                              
   , X.PROF_CODIGO                                                              
   , NULL                                                              
   , NULL                                                              
   , W.UPAENC_PRIORIDADE                                                              
   , W.UPAENC_DATAENCAMINHADO                                                              
   , '1' AS TIPO                                                               
  FROM                                                               
   (                
   SELECT  EMER.EMER_CODIGO AS [EMER_CODIGO]                                                               
   , NOME = ISNULL(PAC.PAC_NOME, EMER.EMER_NOME)              
    , LA.SET_DESCRICAO AS LOC_DESCRICAO                                                              
    , PROF.PROF_NOME                                                       
    , AA.LOCATEND_CODIGO                                                              
    , AA.PROF_CODIGO                                                              
   FROM  EMERGENCIA EMER                                                              
   INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON AA.EMER_CODIGO = EMER.EMER_CODIGO                                                           
   INNER JOIN UPA_Atendimento_Medico AM ON AM.atendamb_codigo = AA.atendamb_CODIGO                       
   INNER JOIN PROFISSIONAL prof ON (prof.prof_codigo = AA.prof_codigo AND prof.locatend_codigo = AA.locatend_codigo)                                                            
   INNER JOIN VWCLINICA_SPA LA ON LA.LOCATEND_CODIGO  = EMER.LOCATEND_CODIGO                                                               
   LEFT JOIN PACIENTE PAC ON PAC.PAC_CODIGO = EMER.PAC_CODIGO              
   WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO NOT IN (4,5) OR AM.TIPSAI_CODIGO IS NULL)                                      
   AND NOT EXISTS                                                               
    (                                                              
    SELECT 1 FROM INTERNACAO I                                                              
  WHERE I.EMER_CODIGO = EMER.EMER_CODIGO                                                
    )                                                              
   ) X                                      
  INNER JOIN                                                              
   (                                                              
   SELECT Y.EMER_CODIGO                            
    , Z.UPAENC_PRIORIDADE                                                              
    , Z.UPAENC_DATAENCAMINHADO                                                              
   FROM                                                         
    (                                                              
SELECT DISTINCT EMER_CODIGO                                                              
    FROM UPA_ENCAMINHAMENTO                                                         
    WHERE LOCATEND_CODIGO_DESTINO = @LOCATEND_CODIGO                                                              
    AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                     
    AND UPAENC_DATARETORNO IS NULL                                                              
    ) Y                                                              
   LEFT JOIN                                                               
    (                                                              
    SELECT EMER_CODIGO                                                              
  , UPAENC_PRIORIDADE                                                              
  , UPAENC_DATAENCAMINHADO                                                              
    FROM UPA_ENCAMINHAMENTO                                               
    WHERE UPATIPENC_CODIGO = 3                                                              
    AND LOCATEND_CODIGO_DESTINO = @LOCATEND_CODIGO                                                              
    AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                                                              
    AND UPAENC_DATARETORNO IS NULL                                                              
    ) Z                                                              
    ON Z.EMER_CODIGO = Y.EMER_CODIGO                                                              
   ) W                                                              
  ON W.EMER_CODIGO = X.EMER_CODIGO                                                              
  ORDER BY UPAENC_PRIORIDADE DESC, UPAENC_DATAENCAMINHADO, X.EMER_CODIGO DESC                                                           
 END                                                              
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- ESPECIALIDADE COM ATENDIMENTOS EM ABERTO                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @opcao = 28          
                                                             
 BEGIN                                                              
  SELECT  X.EMER_CODIGO                                                              
   , X.NOME                                                              
   , X.LOC_DESCRICAO                                                              
   , X.PROF_NOME                                                              
   , X.LOCATEND_CODIGO                
   , X.PROF_CODIGO           
   , Y.TOTALSEMRETORNO                                                              
   , Z.TOTALCOMRETORNO                                                              
   , W.UPAENC_PRIORIDADE                                                              
   , W.UPAENC_DATAENCAMINHADO                                                              
   , '0' AS TIPO                                                               
  FROM             
   (                                                              
   SELECT EMER.EMER_CODIGO AS [EMER_CODIGO]                                                       
    , NOME = isnull(pac.pac_nome, EMER.EMER_NOME)               
    , LA.SET_DESCRICAO AS LOC_DESCRICAO                                                              
    , PROF.PROF_NOME                                             
    , AA.LOCATEND_CODIGO                                                              
    , AA.PROF_CODIGO                                                    
   FROM  EMERGENCIA EMER                                                              
   INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON EMER.EMER_CODIGO = AA.EMER_CODIGO                                                              
   INNER JOIN UPA_Atendimento_Medico AM ON AA.ATENDAMB_CODIGO = AM.ATENDAMB_CODIGO                                                        
   INNER JOIN PROFISSIONAL prof ON (prof.prof_codigo = AA.prof_codigo AND prof.locatend_codigo = AA.locatend_codigo)                          
   INNER JOIN VWCLINICA_SPA LA ON EMER.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                                                                
   left join paciente pac on pac.pac_codigo = emer.pac_codigo              
   WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO NOT IN (4,5) OR AM.TIPSAI_CODIGO IS NULL)                                                              
   AND AA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO , AA.LOCATEND_CODIGO)                                                              
   AND AA.PAC_CODIGO = ISNULL(@PAC_CODIGO, AA.PAC_CODIGO)                                                              
   AND NOT EXISTS (SELECT 1 FROM INTERNACAO I                                                              
  WHERE I.EMER_CODIGO = EMER.EMER_CODIGO)                                               
   ) X                                                              
  LEFT JOIN                                                              
   (                                                              
   SELECT EMER_CODIGO                                                              
    , UPAENC_PRIORIDADE                                                              
    , UPAENC_DATAENCAMINHADO                                                              
   FROM UPA_ENCAMINHAMENTO                                                              
   WHERE UPATIPENC_CODIGO = 3                                  
   AND UPAENC_DATARETORNO IS NULL                                                              
   ) W                                                              
   ON W.EMER_CODIGO = X.EMER_CODIGO                                                              
  LEFT JOIN                                                              
   (                                     
   SELECT  EMER_CODIGO                                                              
    , COUNT(*) AS TOTALSEMRETORNO                                        
   FROM UPA_ENCAMINHAMENTO                                                              
   WHERE UPAENC_DATARETORNO IS NULL                                                              
   GROUP BY EMER_CODIGO                                                              
   ) Y                                                              
   ON Y.EMER_CODIGO = X.EMER_CODIGO                                                               
  LEFT JOIN                                                             
   (                             
   SELECT DISTINCT                                                               
    EMER_CODIGO                                                              
    , COUNT(*) AS TOTALCOMRETORNO                                                               
   FROM UPA_ENCAMINHAMENTO                                                              
   WHERE UPAENC_DATARETORNO IS NOT NULL                                           
   GROUP BY EMER_CODIGO                                                              
   ) Z                  ON Z.EMER_CODIGO = X.EMER_CODIGO                                                              
  UNION                   
                                                             
  SELECT  X.EMER_CODIGO                                                              
   , X.NOME                                                              
   , X.LOC_DESCRICAO                                                              
   , X.PROF_NOME                                                              
   , X.LOCATEND_CODIGO                                                              
   , X.PROF_CODIGO                                                              
   , NULL                                                              
   , NULL                                            
   , W.UPAENC_PRIORIDADE                                                              
   , W.UPAENC_DATAENCAMINHADO                                                              
   , '1' AS TIPO                                                               
  FROM                                                               
   (                                             
   SELECT EMER.EMER_CODIGO AS [EMER_CODIGO]                                                              
    , NOME = isnull(pac.pac_nome, EMER.EMER_NOME)               
    , LA.SET_DESCRICAO AS LOC_DESCRICAO                                                              
    , PROF.PROF_NOME                                                  
    , AA.LOCATEND_CODIGO                                                     
    , AA.PROF_CODIGO                                                              
    FROM  EMERGENCIA EMER                                                              
  INNER JOIN ATENDIMENTO_AMBULATORIAL AA ON EMER.EMER_CODIGO = AA.EMER_CODIGO                                                              
   INNER JOIN UPA_Atendimento_Medico AM on AA.ATENDAMB_CODIGO = AM.ATENDAMB_CODIGO                                                              
   INNER JOIN PROFISSIONAL prof on (prof.prof_codigo = AA.prof_codigo and prof.locatend_codigo = AA.locatend_codigo)                                                              
   INNER JOIN VWCLINICA_SPA LA ON LA.LOCATEND_CODIGO = EMER.LOCATEND_CODIGO                                                                
   left join paciente pac on pac.pac_codigo = emer.pac_codigo           
   WHERE AA.ATENDAMB_DATAFINAL IS NULL                                                              
   AND (AM.TIPSAI_CODIGO NOT IN (4,5) OR AM.TIPSAI_CODIGO IS NULL)                                                      
   AND AA.PAC_CODIGO = ISNULL(@PAC_CODIGO, AA.PAC_CODIGO)                     
                                                             
   AND NOT EXISTS (SELECT 1 FROM INTERNACAO I                             
  WHERE I.EMER_CODIGO = EMER.EMER_CODIGO)                                                              
   ) X                                            
  INNER JOIN                                                              
   (                                                  
   SELECT Y.EMER_CODIGO                                                              
    , Z.UPAENC_PRIORIDADE                                                              
 , Z.UPAENC_DATAENCAMINHADO                     
   FROM                                            
    (       
    SELECT DISTINCT EMER_CODIGO                               
    FROM UPA_ENCAMINHAMENTO                                                              
    WHERE LOCATEND_CODIGO_DESTINO = ISNULL(@LOCATEND_CODIGO , LOCATEND_CODIGO_DESTINO)                                                              
    AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                                                              
    AND UPAENC_DATARETORNO IS NULL                                                              
    ) Y                                                              
   INNER JOIN                                                               
    (                                                              
    SELECT EMER_CODIGO                                                              
  , UPAENC_PRIORIDADE                               
  , UPAENC_DATAENCAMINHADO                                                              
    FROM UPA_ENCAMINHAMENTO                                                              
    WHERE UPATIPENC_CODIGO = 3                                                              
    AND LOCATEND_CODIGO_DESTINO = ISNULL(@LOCATEND_CODIGO, LOCATEND_CODIGO_DESTINO)                                                              
    AND PROF_CODIGO_ORIGEM <> @PROF_CODIGO                                                              
    AND UPAENC_DATARETORNO IS NULL                                                              
    ) Z                                                              
    ON Z.EMER_CODIGO = Y.EMER_CODIGO                                                              
   ) W                                                              
  ON W.EMER_CODIGO = X.EMER_CODIGO                                        
  ORDER BY UPAENC_PRIORIDADE DESC, UPAENC_DATAENCAMINHADO, X.EMER_CODIGO DESC                                                  
 END                                                 
                                                             
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 -- PACIENTES EM OBSERVACAO E AGUARDANDO LEITO --                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
 IF @OPCAO = 29                                                              
 BEGIN                                                              
  -- PACIENTES ACOLHIDOS COM RISCO REGISTRADOS E QUE POSSUEM ATENDIMENTO AMBULATORIAL                                    
  -- ENCAMINHANDO COM TIPO DE SAÃƒÆ’Ã‚ÂDA OBSERVACAO E RISCO AMARELO OU VERMELHO                                                            
  SELECT  EMER.EMER_codigo AS CODIGO                                                              
   ,NOME = isnull(pac.pac_nome, EMER.EMER_nome)               
   ,lu.set_descricao AS localAtendimento                                                
   ,NULL AS localInternacao                                                              
   ,NULL AS leito                                                              
   ,NULL AS inter_codigo                                                              
   ,prof.prof_nome AS profAtendimento                                               
   ,NULL AS profInternacao                                                              
   ,cr.upaclaris_risco                                             
   ,CASE                                                               
    WHEN am.TIPSAI_CODIGO = 4 THEN 'EM OBSERVAÇÃO'                                                              
    WHEN am.TIPSAI_CODIGO = 5 THEN 'REMOÇÃO'                                                               
END AS tipoSaidaAmbulatorio                                                              
   ,CASE                                                               
    WHEN am.TIPSAI_CODIGO = 4 THEN 1                                          
    WHEN am.TIPSAI_CODIGO = 5 THEN 3                                                            
   END AS SITUACAO                                                              
  FROM EMERGENCIA EMER                                                              
  INNER JOIN upa_acolhimento ua ON ua.EMER_codigo = EMER.EMER_codigo                                                         
  INNER JOIN upa_classificacao_risco cr ON  cr.aco_codigo = ua.aco_codigo                                             
  INNER JOIN  vwlocal_unidade lu ON lu.locatend_codigo = EMER.locatend_codigo                                                       
  INNER JOIN Atendimento_Ambulatorial A ON A.EMER_codigo = EMER.EMER_codigo                                            
  INNER JOIN UPA_Atendimento_Medico AM ON AM.Atendamb_Codigo = A.Atendamb_Codigo                                    
  INNER JOIN  profissional prof ON (prof.prof_codigo = A.prof_codigo AND prof.locatend_codigo = A.locatend_codigo)                                                              
  left join paciente pac on pac.pac_codigo = emer.pac_codigo              
  WHERE cr.upaclaris_risco IN (4,6)                                                               
  AND AM.TIPSAI_CODIGO IN (4,5)                                                               
  AND A.atendamb_datafinal IS NULL                                                              
  AND EMER.unid_codigo = @unid_codigo                                                              
  AND NOT EXISTS                                                              
   (                                                    
   SELECT 1 FROM INTERNACAO I                                                              
   WHERE I.EMER_CODIGO = EMER.EMER_CODIGO                                                              
   )                                         
  UNION                                                               
  -- PACIENTES ACOLHIDOS COM RISCO REGISTRADOS E QUE NÃƒÆ’Ã†â€™O POSSUEM ATENDIMENTO AMBULATORIAL                                                          
  SELECT EMER.EMER_codigo AS CODIGO                                                              
   ,NOME  = isnull(pac.pac_nome, EMER.EMER_nome)              
   ,lu.set_descricao AS localAtendimento                                                              
   ,NULL AS localInternacao                                                              
   ,NULL AS leito                                                              
   ,NULL AS inter_codigo                                                              
   ,NULL AS profAtendimento                                                              
   ,NULL AS profInternacao                                                              
   ,cr.upaclaris_risco                                                              
   ,'EM OBSERVAÇÃO' AS tipoSaidaAmbulatorio                                                              
   ,1 AS SITUACAO                                                              
  FROM  EMERGENCIA EMER                                 
  INNER JOIN upa_acolhimento ua ON ua.EMER_codigo = EMER.EMER_codigo                                                          
  INNER JOIN upa_classificacao_risco cr ON cr.aco_codigo = ua.aco_codigo                                                                          
  INNER JOIN vwlocal_unidade lu ON lu.locatend_codigo = EMER.locatend_codigo                       
  left join paciente pac on pac.pac_codigo = emer.pac_codigo              
  WHERE cr.upaclaris_risco in (4,6)                                                              
  AND NOT EXISTS                                                              
   (             
   SELECT EMER_CODIGO                           
   FROM ATENDIMENTO_AMBULATORIAL A                                                              
   WHERE A.EMER_codigo = EMER.EMER_codigo       
   )                                                              
   AND EMER.unid_codigo = @unid_codigo                                                              
  UNION                                                               
  -- EM OBSERVACAO                                                              
  SELECT  EMER.emer_codigo AS CODIGO                                             
   , NOME = isnull(pac.pac_nome, EMER.emer_nome)               
   , localAtendimento.set_descricao as localAtendimento                                                              
   , localInternacao.set_descricao as localInternacao                                                              
   , LocInt_Descricao as leito                                                             
   , i.inter_codigo                                                              
   , profAtendimento.prof_nome as profAtendimento                                                              
   , profInternacao.prof_nome as profInternacao                                                              
   , cr.upaclaris_risco                                                              
   , CASE                                                               
    WHEN am.TIPSAI_CODIGO = 4 THEN 'EM OBSERVAÇÃO'                                                              
    WHEN am.TIPSAI_CODIGO = 5 THEN 'REMOÇÃO'                                                               
   END AS tipoSaidaAmbulatorio                                                              
   ,CASE                                                               
    WHEN am.TIPSAI_CODIGO = 4 THEN 2                                                               
    WHEN am.TIPSAI_CODIGO = 5 THEN 3                                                               
   END AS SITUACAO                                 
  FROM EMERGENCIA EMER                                                              
  INNER JOIN Atendimento_Ambulatorial A ON A.EMER_codigo = EMER.EMER_codigo                          
  INNER JOIN upa_acolhimento ua ON ua.EMER_codigo = A.EMER_codigo                                            
  INNER JOIN upa_classificacao_risco cr ON cr.aco_codigo = ua.aco_codigo                                          
  INNER JOIN UPA_Atendimento_Medico AM ON AM.atendamb_codigo = A.atendamb_codigo                                                  
  INNER JOIN vwlocal_unidade localAtendimento ON localAtendimento.locatend_codigo = A.locatend_codigo                                                    
  INNER JOIN profissional profAtendimento ON (profAtendimento.prof_codigo = A.prof_codigo AND profAtendimento.locatend_codigo = A.locatend_codigo)                                                              
  INNER JOIN internacao i ON  i.EMER_codigo = EMER.EMER_codigo                                                              
  INNER JOIN vwlocal_unidade localInternacao ON localInternacao.locatend_codigo = i.locatend_codigo                                                              
  LEFT JOIN vwleito l ON l.locatend_codigo = i.locatend_leito AND l.lei_codigo = i.lei_codigo                                                              
  INNER JOIN  profissional profInternacao ON (profInternacao.prof_codigo = i.prof_codigo AND profInternacao.locatend_codigo = i.locatend_codigo)                                                              
  left join paciente pac on pac.pac_codigo = emer.pac_codigo               
  WHERE i.inter_dtalta IS NULL                                                              
  AND EMER.unid_codigo = @unid_codigo                                                              
  ORDER BY situacao ASC, cr.upaclaris_risco DESC                                                              
 END                                                              
                                                           
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                           
 -- Seleciona os pacientes em Atendimento (com Atendimento Ambulatorial, mas sem Alta) no AGENDAMENTO                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                              
                                                             
 if @opcao = 30                                                              
 BEGIN                                                                          
 SELECT agd_sequencial, agd_datahora,                                                               
  p.pac_nome, atend_codigo,           
  prof.prof_nome, vwLA.set_descricao,                                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin                                                              
                                                             
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                                                              
  left join parametro_boletim pb on (pb.unid_codigo = ac.unid_codigo)              
  left join profissional prof on ac.prof_codigo = prof.prof_codigo and ac.locatend_codigo = prof.locatend_codigo                                                              
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo                                                              
                                                             
 WHERE (ac.agd_situacao = '5' and exists                                                               
   (select 1 from atendimento_ambulatorial where atend_codigo = ac.atend_codigo and atendamb_datafinal is null))                                                              
                                                             
  and ac.prof_codigo = ISNULL(@PROF_CODIGO, ac.prof_codigo)                                                              
  and ac.locatend_codigo = ISNULL(@LOCATEND_CODIGO, ac.locatend_codigo )                                                              
  and ac.pac_codigo = isnull(@PAC_CODIGO, ac.pac_codigo)                                                              
                                                             
 ORDER BY agd_datahora                                                              
                          
 END                                                           
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                     
 -- PACIENTES COM PRESCRICAO                                                                        
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                        
        
                                                                
        
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                     
-- PACIENTES INTERNADOS SEM ALTA COM PRESCRICAO                                                                        
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                        
IF @OPCAO = 32                                                              
BEGIN                                                        
                                                            
 Select                                          
   null as spa_codigo,                                                     
   null as emer_codigo,                                                              
   '4' as origem,                                                            
                                                          
     i.inter_dtalta ,         
nomePaciente = case                                                           
  when (i.inter_dtalta is null) then p.pac_nome                                                          
  when (i.inter_dtalta is not null) then  'EN' + '-' + p.pac_nome                           
 end ,                                         
                                                            
  p.pac_nome as nomePaciente,                                                
   pr.presc_data,                                                                 
   i.inter_codigo,                                                              
   LocInt_Descricao as leito,         
  null as localAtendimento,                                                              
   null as profAtendimento,                                                                              
            null as localInternacao,                                                              
            null as upaclaris_risco,                                                              
            null as upaatemed_encaminhamentoEixo,null as tipoSaidaAmbulatorio,                      
   localInternacao.set_descricao as localInternacao,                                                              
   profInternacao.prof_nome as profInternacao,                                                              
   (select count(*) from item_prescricao ip where ip.presc_codigo = pr.presc_codigo and (                                                                      
      exists (select 1 from item_prescricao_sinais_vitais ipsv                              
   where ipsv.presc_codigo = ip.presc_codigo and ipsv.itpresc_codigo = ip.itpresc_codigo)                                                                      
     or exists (select 1 from item_prescricao_cuidados_especiais ipce                                                               
      where ipce.presc_codigo = ip.presc_codigo and ipce.itpresc_codigo = ip.itpresc_codigo)                                                    
     or exists (select 1 from item_prescricao_dieta ipd                                                               
      where ipd.presc_codigo = ip.presc_codigo and ipd.itpresc_codigo = ip.itpresc_codigo)                                                              
     or exists (select 1 from item_prescricao_medicamento ipm                                                               
      where ipm.presc_codigo = ip.presc_codigo and ipm.itpresc_codigo = ip.itpresc_codigo)                                                                       
     or exists (select 1 from item_prescricao_procedimento ipp                                                               
      where ipp.presc_codigo = ip.presc_codigo and ipp.itpresc_codigo = ip.itpresc_codigo)                                                                        
     or exists (select 1 from item_prescricao_oxigenoterapia ipo                                                               
      where ipo.presc_codigo = ip.presc_codigo and ipo.itpresc_codigo = ip.itpresc_codigo))) as TotalItem,                                                       
                                      
 (select count(distinct(ia.itpresc_codigo)) from item_aprazamento ia where ia.presc_codigo = pr.presc_codigo) as TotalAprazamento                                                              
 From  internacao i                                                              
 inner Join vwLeito vw on i.locatend_leito = vw.locatend_codigo and i.lei_codigo = vw.lei_codigo                      
 inner join  vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                        
 inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)                                                                        
 inner join prescricao pr on pr.inter_codigo = i.inter_codigo                                                              
 inner join paciente p on p.pac_codigo = i.pac_codigo                                                    
 Where (i.inter_DeObservacao = 'N' or i.inter_DeObservacao is null)                                                            
 and datediff(mi,pr.presc_data, getdate()) <= 1440                                                                   
 and  vw.unid_codigo = @unid_codigo                          
 and  pr.presc_tipo = 'P'                                                              
 order by p.pac_nome            
END                               
                                                          
IF @OPCAO = 33                                                              
BEGIN                                                                
 SELECT UA.ACO_CODIGO,                                                                     
 UA.SPA_CODIGO,                                                                    
 UA.EMER_CODIGO,                                                                    
 CASE WHEN UA.aco_nome_social IS NOT NULL THEN    
 UA.aco_nome_social + '[' + UA.ACO_NOME + ']'    
 ELSE    
 UA.ACO_NOME    
 END AS ACO_NOME,                                                                     
 ra.RISACO_Gravidade as risco,                                                                    
 LA.SET_DESCRICAO AS LOC_DESCRICAO,                                                                    
 UA.ACO_DATAHORA AS DATAHORA,                                                                    
 UA.ACO_SEQUENCIAL                                          
 FROM UPA_ACOLHIMENTO UA                                                              
 inner join upa_classificacao_risco ucr on ua.aco_codigo = ucr.aco_codigo                                                              
 inner join risco_acolhimento ra on ra.risaco_codigo = ucr.risaco_codigo and ra.risaco_porta = '3'                                                              
 INNER JOIN VWLOCAL_ATENDIMENTO LA   ON LA.LOCATEND_CODIGO = UA.LOCATEND_CODIGO                                                        
 inner join upa_fila uf on ua.aco_codigo = uf.aco_codigo                                                                        
 WHERE LA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LA.LOCATEND_CODIGO) and                                                         
 ua.spa_codigo is null and ua.emer_codigo is null and                                                              
 uf.DATA_CANCELAMENTO is null and                                                    
 ua.unid_codigo = @UNID_CODIGO                                                              
 order by  UA.ACO_DATAHORA desc                                                      
END                                            
                                                       
IF @OPCAO = 34                      
BEGIN                                                            
 SELECT LOCATEND_CODIGO         
 FROM VWUPA_FILA_ACOLHIMENTO                                                            
 WHERE ACO_CODIGO = @ACO_CODIGO                                                            
END                        
                        
IF @OPCAO = 35                      
BEGIN              
              
 /*emergencia*/                         
 select    
  null as ATENDAMB_CODIGO,                          
  ss.pst_codigo as POSTO,                  
  null as spa_codigo,                 
  e.emer_codigo,                                        
  case when e.emer_nome_social is not null then e.emer_nome_social + '[' + e.emer_nome + ']' else  e.emer_nome end as nomePaciente,                                                 
  lu.set_descricao as localAtendimento,         
  null as localInternacao,                                                                      
  null as leito,                                                                      
  null as inter_codigo,                                                                      
  prof.prof_nome as profAtendimento,                                                                      
  null as profInternacao,                       
  risaco_gravidade as upaclaris_risco,                                                                   
  case                                                                       
   when am.tipsai_codigo = 5 then 'REMOÇÃO'                                                                    
   when am.tipsai_codigoencaminhamento = 5 then 'EM OBSERVAÇÃO'                         
  end as tipoSaidaAmbulatorio,                               
  case                                                                       
   when a.atendamb_codigo is null then 1                                
   when a.atendamb_codigo is not null then 3                                                                    
  end AS SITUACAO,                      
  am.upaatemed_encaminhamentoEixo,                                                              
  risaco_gravidade as upaclaris_risco,                                                                  
  case                                                                       
  when a.atendamb_codigo is null then '0' else '1'end as atendimentoRealizado,                                                                    
  case                                                                     
  when am.upaatemed_encaminhamentoEixo is not null then am.upaatemed_encaminhamentoEixo else convert(int,risaco_gravidade) end as ordenacao                        
  from                                                                            
   emergencia e                                                             
   inner join Setor_Clinica_Paramtetro_Stok ss on ss.locatendcodigo = e.locatend_codigo                      
   inner join local_atendimento la on la.locatend_codigo = e.locatend_codigo                         
   inner join setor_clinica sclu on  la.setcli_codigo = sclu.setcli_codigo and sclu.setcli_codigo = ss.setclicodigo                          
   inner join risco_acolhimento ra on ra.risaco_codigo = e.risaco_codigo                                                                  
   inner join vwlocal_unidade lu on  lu.locatend_codigo = e.locatend_codigo                              
   left join Atendimento_Ambulatorial A on e.emer_codigo = A.emer_codigo                                                                      
   left join UPA_Atendimento_Medico AM on A.Atendamb_Codigo = AM.Atendamb_Codigo                                                                      
   left join profissional prof on (prof.prof_codigo = A.prof_codigo and prof.locatend_codigo = A.locatend_codigo)              
  where                                                                      
   A.atendamb_datafinal IS NULL                      
   and (a.atendamb_datainicio > dateadd(d, -@periodo, getdate()))                               
   and ss.pst_codigo = @PST_CODIGO                               
   and( ss.risaco_codigo = ra.risaco_codigo or (ss.risaco_codigo is null and ra.risaco_codigo is null))                                  
   and ss.tipoSetor = '2'                      
   and e.unid_codigo = @unid_codigo                
   and not exists (select 1 from internacao i where i.emer_codigo = e.emer_codigo)                                                
              
union              
/*emergencia com internacao*/              
 select                 
 null as ATENDAMB_CODIGO,             
  l.pst_codigo as POSTO,                                                                  
  null as spa_codigo,                 
  e.emer_codigo,                                                           
  case when e.emer_nome_social is not null then e.emer_nome_social + '[' + e.emer_nome + ']' else  e.emer_nome end as nomePaciente,                                                 
  lu.set_descricao as localAtendimento,                             
  localInternacao.set_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  prof.prof_nome as profAtendimento,                       
  profInternacao.prof_nome as profInternacao,                                                                      
  risaco_gravidade as upaclaris_risco,                                                                   
  case                                                                       
when am.tipsai_codigo = 5 then 'REMOÇÃO'                                                                    
   when am.tipsai_codigoencaminhamento = 5 then 'EM OBSERVAÇÃO'                         
  end as tipoSaidaAmbulatorio,                                
  case                                                                       
   when a.atendamb_codigo is null then 1                                                                    
   when i.inter_codigo is not null then 2                                                                    
   when a.atendamb_codigo is not null then 3                                                                    
  end AS SITUACAO,                                                               
  am.upaatemed_encaminhamentoEixo,                                                        
  risaco_gravidade as upaclaris_risco,                                                                  
  case                                                                       
  when a.atendamb_codigo is null then '0' else '1'end as atendimentoRealizado,                                                                    
  case                                                                     
  when am.upaatemed_encaminhamentoEixo is not null then am.upaatemed_encaminhamentoEixo else convert(int,risaco_gravidade) end as ordenacao                        
  from                                                                            
   emergencia e                                                             
   inner join local_atendimento la on la.locatend_codigo = e.locatend_codigo                         
   inner join setor_clinica sclu on  la.setcli_codigo = sclu.setcli_codigo              
   inner join risco_acolhimento ra on ra.risaco_codigo = e.risaco_codigo                                                                  
   inner join vwlocal_unidade lu on  lu.locatend_codigo = e.locatend_codigo                              
   left join Atendimento_Ambulatorial A on e.emer_codigo = A.emer_codigo                                                                      
   left join UPA_Atendimento_Medico AM on A.Atendamb_Codigo = AM.Atendamb_Codigo                                                                      
   left join profissional prof on (prof.prof_codigo = A.prof_codigo and prof.locatend_codigo = A.locatend_codigo)                                                                               
   inner join internacao i on  (i.emer_codigo = e.emer_codigo and i.inter_dtalta is NULL)                                                                     
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo          
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)                                                                      
  where                                                                   
   A.atendamb_datafinal IS NULL                   
   and (a.atendamb_datainicio > dateadd(d, -@periodo, getdate()))              
   and l.pst_codigo = @PST_CODIGO                                                                               
   and e.unid_codigo = @unid_codigo              
                
union                   
  /*spa*/                                                        
  select        
    null as ATENDAMB_CODIGO,                      
    ss.pst_codigo AS POSTO,                      
    p.spa_codigo,                                                                      
    null as emer_codigo,                                      
    case when p.spa_nome_social is not null then p.spa_nome_social + '[' + p.spa_nome + ']' else  p.spa_nome end as nomePaciente,      
    localAtendimento.set_descricao as localAtendimento,                                                                      
    null as localInternacao,                                                                      
    null as leito,                                                                      
    null as inter_codigo,                                                                      
    profAtendimento.prof_nome as profAtendimento,                                                                      
    null as profInternacao,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco,                                                                  
    case                                                                       
    when am.TIPSAI_CODIGO = 5 then 'REMOÇÃO'                            
    when am.tipsai_codigoencaminhamento = 5 then 'EM OBSERVAÇÃO' end as tipoSaidaAmbulatorio,                                                                      
    2 AS SITUACAO,                                                                      
    am.upaatemed_encaminhamentoEixo,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end AS risco,                                               
    '1' as atendimentoRealizado,                                                                    
    case when cr.upaclaris_codigo is not null then convert(int,cr.upaclaris_risco) else convert(int,rap.risaco_gravidade) end as ordenacao                        
  from                                                                        
    pronto_atendimento p                                                                      
    inner join Atendimento_Ambulatorial a on p.spa_codigo = a.spa_codigo                                                                      
    inner join upa_acolhimento ua on ua.spa_codigo = a.spa_codigo                                                                       
    left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                                                               
    left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo                                                                  
    left join risco_acolhimento rap on rap.risaco_codigo = p.risaco_codigo                                                                  
    inner join UPA_Atendimento_Medico AM on A.atendamb_codigo = AM.atendamb_codigo                                                                      
    inner join vwlocal_unidade localAtendimento on  localAtendimento.locatend_codigo = a.locatend_codigo                                                                   
    inner join profissional profAtendimento on (profAtendimento.prof_codigo = a.prof_codigo and profAtendimento.locatend_codigo = a.locatend_codigo)                          
    inner join Setor_Clinica_Paramtetro_Stok ss on ss.locatendCodigo = p.locatend_codigo                      
 inner join Local_Atendimento la on la.locatend_codigo = p.locatend_codigo                      
    inner join Setor_Clinica lu on la.SETCLI_CODIGO = lu.setCli_Codigo and lu.setcli_Codigo = ss.setcliCodigo              
   where                                                                        
  a.atendamb_datafinal is null                        
  and a.atendamb_datainicio > dateadd(d, -@periodo, getdate())              
  and ss.pst_codigo = @PST_CODIGO                                                                   
  and( ss.risaco_codigo = cr.risaco_codigo or (ss.risaco_codigo is null and cr.risaco_codigo is null))                                  
  and ss.tipoSetor = '3'              
  and p.unid_codigo = @unid_codigo              
  and not exists (select 1 from internacao i where i.spa_codigo = p.spa_codigo)              
             
  union              
  /*spa vermelho sem internacao*/              
  select    
    null as ATENDAMB_CODIGO,                          
    ss.pst_codigo AS POSTO,                      
    p.spa_codigo,                                                                      
    null as emer_codigo,           
    case when p.spa_nome_social is not null then p.spa_nome_social + '[' + p.spa_nome + ']' else  p.spa_nome end as nomePaciente,                                                                
    localAtendimento.set_descricao as localAtendimento,                                                                      
    null as localInternacao,                                                                      
    null as leito,                                                                      
    null as inter_codigo,                                                                      
    profAtendimento.prof_nome as profAtendimento,                                                                      
    null as profInternacao,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco,                                                                  
    case                                                                       
    when am.TIPSAI_CODIGO = 5 then 'REMOÇÃO'                            
    when am.tipsai_codigoencaminhamento = 5 then 'EM OBSERVAÇÃO' end as tipoSaidaAmbulatorio,                                                                      
    2 AS SITUACAO,                                               
    am.upaatemed_encaminhamentoEixo,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end AS risco,                                               
    '1' as atendimentoRealizado,                                                                    
    case when cr.upaclaris_codigo is not null then convert(int,cr.upaclaris_risco) else convert(int,rap.risaco_gravidade) end as ordenacao                        
  from                                                                        
    pronto_atendimento p                                                                      
    inner join Atendimento_Ambulatorial a on p.spa_codigo = a.spa_codigo                                                                      
    inner join upa_acolhimento ua on ua.spa_codigo = a.spa_codigo                                                                       
    left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                                                               
    left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo                                                                  
    left join risco_acolhimento rap on rap.risaco_codigo = p.risaco_codigo                                                                
    inner join UPA_Atendimento_Medico AM on A.atendamb_codigo = AM.atendamb_codigo                                                                      
    inner join vwlocal_unidade localAtendimento on  localAtendimento.locatend_codigo = a.locatend_codigo                                                                   
    inner join profissional profAtendimento on (profAtendimento.prof_codigo = a.prof_codigo and profAtendimento.locatend_codigo = a.locatend_codigo)                          
    inner join Setor_Clinica_Paramtetro_Stok ss on ss.locatendCodigo = p.locatend_codigo                      
 inner join Local_Atendimento la on la.locatend_codigo = p.locatend_codigo                      
    inner join Setor_Clinica lu on la.SETCLI_CODIGO = lu.setCli_Codigo and lu.setcli_Codigo = ss.setcliCodigo              
   where                                                                        
  a.atendamb_datafinal is null        
  and a.atendamb_datainicio > dateadd(d, -@periodo, getdate())              
  and ss.tipoSetor = '2'               
  and ss.pst_codigo = @pst_codigo              
  and cr.upaclaris_risco = '6'              
  and p.unid_codigo = @unid_codigo              
  and not exists (select 1 from internacao i where i.spa_codigo = p.spa_codigo)              
                  
  union                 
  /*spa com internacao*/                                 
  select    
    null as ATENDAMB_CODIGO,                          
    l.pst_codigo AS POSTO,                      
    p.spa_codigo,                                                                      
    null as emer_codigo,                                      
    case when p.spa_nome_social is not null then p.spa_nome_social + '[' + p.spa_nome + ']' else  p.spa_nome end as nomePaciente,                                                                
    localAtendimento.set_descricao as localAtendimento,                                                                      
    localInternacao.set_descricao as localInternacao,                                                                      
    LocInt_Descricao as leito,                                                                      
    i.inter_codigo,                                                                      
    profAtendimento.prof_nome as profAtendimento,                                                                      
    profInternacao.prof_nome as profInternacao,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end as upaclaris_risco,                                                                  
    case                                                                       
    when am.TIPSAI_CODIGO = 5 then 'REMOÇÃO'                            
    when am.tipsai_codigoencaminhamento = 5 then 'EM OBSERVAÇÃO' end as tipoSaidaAmbulatorio,                                                                      
    2 AS SITUACAO,                              
    am.upaatemed_encaminhamentoEixo,                                                                      
    case when cr.upaclaris_codigo is not null then cr.upaclaris_risco else rap.risaco_gravidade end AS risco,                                               
    '1' as atendimentoRealizado,                                                                  
    case when cr.upaclaris_codigo is not null then convert(int,cr.upaclaris_risco) else convert(int,rap.risaco_gravidade) end as ordenacao                        
  from                                                                   
    pronto_atendimento p                                                                      
    inner join Atendimento_Ambulatorial a on p.spa_codigo = a.spa_codigo                                                                      
    inner join upa_acolhimento ua on ua.spa_codigo = a.spa_codigo                  
    left join upa_classificacao_risco cr on  cr.aco_codigo = ua.aco_codigo                                                                               
    left join risco_acolhimento ra on ra.risaco_codigo = cr.risaco_codigo                                                                  
    left join risco_acolhimento rap on rap.risaco_codigo = p.risaco_codigo       
    inner join UPA_Atendimento_Medico AM on A.atendamb_codigo = AM.atendamb_codigo                                                                      
    inner join vwlocal_unidade localAtendimento on  localAtendimento.locatend_codigo = a.locatend_codigo                                                                   
    inner join profissional profAtendimento on (profAtendimento.prof_codigo = a.prof_codigo and profAtendimento.locatend_codigo = a.locatend_codigo)                      
    inner join Local_Atendimento la on la.locatend_codigo = p.locatend_codigo                      
    inner join Setor_Clinica lu on la.SETCLI_CODIGO = lu.setCli_Codigo              
    inner join internacao i on  i.spa_codigo = p.spa_codigo                                                                      
    inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                               
    inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                    
    inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)                                                                      
  where a.atendamb_datafinal is null                        
  and a.atendamb_datainicio > dateadd(d, -@periodo, getdate())              
  and l.pst_codigo = @PST_CODIGO                                                 
  and p.unid_codigo = @unid_codigo               
                                                                    
 order by ordenacao desc, situacao asc                           
                        
END              
              
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
-- LISTA DE AGENDAMENTOS COM OU SEM ATENDIMENTO EM ABERTO                              
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
IF @OPCAO = 36                
BEGIN                
                
SELECT distinct ac.agd_sequencial,                     
  agd_datahora,                     
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                      
  a.atend_codigo,                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin,                
  vwLA.set_descricao,                
  a.atend_codigo,               
  a.atend_data,                
  ac.pac_codigo            ,    
  PF.DATA_CONFIRMACAO,     
  PF.DATA_CANCELAMENTO,     
  pf.data_inicio_atend,  
  af.atenf_codigo  
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                    
  left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
  left join atendimento a on a.atend_codigo = ac.atend_codigo                
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
  left join pep_fila pf on pf.AGD_SEQUENCIAL = ac.AGD_SEQUENCIAL                 
  left join atendimento_enfermagem af on ac.agd_sequencial = af.agd_sequencial  
                 
 WHERE (ac.agd_situacao = '0' or ac.agd_situacao = '5')                    
  and (                
 not exists (select 1 from atendimento_ambulatorial                
    where atend_codigo = ac.atend_codigo) )    
--and ac.agd_datahora between convert(smalldatetime, convert(varchar,getdate(),112)) and dateadd(d,1,convert(smalldatetime, convert(varchar,getdate(),112)))                
  and DATEDIFF(d,ac.agd_datahora,GETDATE()) <= isnull(@FiltroDias,1)    
  and ac.prof_codigo = @PROF_CODIGO         
  and ac.locatend_codigo = @LOCATEND_CODIGO                    
  and ac.unid_codigo = @UNID_CODIGO        
  and (PF.DATA_CONFIRMACAO IS NULL OR pf.data_inicio_atend is null)    
  and PF.DATA_CANCELAMENTO IS NULL      
                  
 --ORDER BY ac.AGD_SEQUENCIAL, ac.agd_datahora        
 ORDER BY a.atend_data, a.atend_codigo, ac.AGD_SEQUENCIAL, ac.agd_datahora            
                
END          
        
-- /////////////////////////////////////////            
-- //  Lista de Pacientes da Internacao   //            
-- /////////////////////////////////////////            
            
IF @OPCAO = 37            
  BEGIN            
                 
 select                                
  l.pst_codigo as POSTO,                                                                          
  null as spa_codigo,                
  null as emer_codigo,                                                                             
  p.pac_nome as nomePaciente,                                                       
  null as localAtendimento,            
  localInternacao.set_descricao as localInternacao,                                          
  LocInt_Descricao  as leito,                                                                            
  i.inter_codigo as inter_codigo,                                                                            
  null as profAtendimento,             
  profInternacao.prof_nome as profInternacao,               
  null as upaclaris_risco,                                                                         
  null as tipoSaidaAmbulatorio,                                                            
  null AS SITUACAO,                     
  null as upaatemed_encaminhamentoEixo,            
  null as upaclaris_risco,            
  null as atendimentoRealizado,                                                                          
  null as ordenacao,          
  pp.Pac_Prontuario_Numero as CodigoProntuario                        
  from                                                                                  
   internacao i                                                                   
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                            
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                                     
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)             
   inner join paciente p on i.pac_codigo = p.pac_codigo              
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo          
  where                                                                         
   i.inter_dtalta IS NULL                        
   and l.pst_codigo = @PST_CODIGO                                                                                     
   and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo          
   and l.enf_codigo_chave = isnull(@ENF_CODIGO, l.enf_codigo_chave)             
order by nomePaciente          
END        
  -- ///////////////////////////////////////////////////                                                              
 -- CHAMAR O PACIENTE PEP                                                                     
 -- ///////////////////////////////////////////////////                                                                    
IF @OPCAO = 38                                 
 BEGIN                                                                                 
  DECLARE @NUM_CHAMADAS_PEP INT                 
  DECLARE @NUM_REPETICOES_PEP INT                                     
                                                                         
  SELECT TOP 1 @NUM_REPETICOES_PEP = ISNULL(NUMERO_REPETICOES, 1) FROM UPA_FILA_CONFIG                                                                                                                  
  SELECT @NUM_CHAMADAS_PEP = NUM_CHAMADAS FROM PEP_FILA  WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL                                                                    
                                                                         
  IF (ISNULL(@NUM_CHAMADAS_PEP,0) < @NUM_REPETICOES_PEP)                                                                      
   BEGIN                      
    DELETE FROM PEP_FILA WHERE AGD_SEQUENCIAL=@AGD_SEQUENCIAL      
    INSERT INTO PEP_FILA (AGD_SEQUENCIAL,NUM_CHAMADAS,DESTINO,PAC_CODIGO, UNID_CODIGO) VALUES (@AGD_SEQUENCIAL,0,@DESTINO,@PAC_CODIGO,@UNID_CODIGO)      
          
    DELETE FROM PEP_PAINEL WHERE AGD_SEQUENCIAL=@AGD_SEQUENCIAL      
    INSERT INTO PEP_PAINEL (AGD_SEQUENCIAL, DATA_CHAMADA, DATA_PRIMEIRA_EXIBICAO) VALUES (@AGD_SEQUENCIAL, GETDATE(), NULL)                                                              
          
    INSERT INTO PEP_FILA_HISTORICO (AGD_SEQUENCIAL, DATA_HISTORICO,ID_EVENTO,USU_CODIGO,UNID_CODIGO) VALUES (@AGD_SEQUENCIAL,GETDATE(),0,@USUARIO_CODIGO,@UNID_CODIGO)        
    -- ATUALIZA O NUMERO DE CHAMADAS                                                     
    UPDATE         
     PEP_FILA         
    SET                                           
     NUM_CHAMADAS = NUM_CHAMADAS + 1,                                                                      
     DATA_CONFIRMACAO = NULL,                                                              
     DESTINO = @DESTINO                                                                      
    WHERE         
     AGD_SEQUENCIAL = @AGD_SEQUENCIAL           
    SELECT ''                              
   END                                                                     
  ELSE                                                                      
   BEGIN                                                                      
    -- NUMERO DE CHAMADAS NO PAINEL ESGOTADAS                                                                      
    -- ATUALIZA O NUMERO DE CHAMADAS                                                                 
    UPDATE PEP_FILA SET DATA_CANCELAMENTO = GETDATE() WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL                                                                     
    SELECT 'ESTE PACIENTE FOI RETIRADO DA FILA POIS ATINGIU O NUMERO MAXIMO DE ' + CONVERT(VARCHAR, @NUM_CHAMADAS_PEP) + ' CHAMADAS NO PAINEL.'                      
   END        
 END             
            
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                
 -- Atender o Paciente PEP                                                               
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                
 IF @opcao = 39                                                                
 BEGIN                                                                
                                                               
  -- Remove o paciente do painel                                                              
  DELETE FROM PEP_Painel                                                                 
  WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL                                                 
                                                               
  -- Atualiza o numero de chamadas                                                                
  UPDATE       
  PEP_FILA       
  SET                                                                
  NUM_CHAMADAS = 0,                                                                
  DATA_CONFIRMACAO = GETDATE()                                                                
  WHERE       
  AGD_SEQUENCIAL = @AGD_SEQUENCIAL      
  AND UNID_CODIGO = @UNID_CODIGO      
           
          
  INSERT INTO PEP_FILA_HISTORICO (AGD_SEQUENCIAL, DATA_HISTORICO,ID_EVENTO,USU_CODIGO,UNID_CODIGO) VALUES (@AGD_SEQUENCIAL,GETDATE(),1,@USUARIO_CODIGO,@UNID_CODIGO)                                       
                                                               
 END           
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                           
 -- CANCELAMENTO PEP                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 IF @OPCAO = 40                                                                    
 BEGIN                                                                                  
   DECLARE @WDATAPEP SMALLDATETIME                                                                    
                                                                       
   SET @WDATAPEP = CONVERT(SMALLDATETIME, GETDATE(), 103)                                                                    
      
   IF (NOT EXISTS(SELECT AGD_SEQUENCIAL FROM PEP_FILA WHERE AGD_SEQUENCIAL=@AGD_SEQUENCIAL))      
    BEGIN      
  INSERT INTO PEP_FILA (AGD_SEQUENCIAL,NUM_CHAMADAS,DESTINO,PAC_CODIGO, UNID_CODIGO, DATA_CANCELAMENTO) VALUES (@AGD_SEQUENCIAL,0,@DESTINO,@PAC_CODIGO,@UNID_CODIGO,GETDATE())      
    END                                                                       
   ELSE      
   BEGIN         
    UPDATE       
   PEP_FILA                           
    SET       
   DATA_CANCELAMENTO = @WDATAPEP,         
   DATA_CONFIRMACAO = NULL,                                                                    
   NUM_CHAMADAS = 0                                                                    
    WHERE        
   AGD_SEQUENCIAL = @AGD_SEQUENCIAL      
   AND UNID_CODIGO = @UNID_CODIGO      
         
    DELETE FROM PEP_PAINEL WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL        
   END                                                            
                      
   INSERT INTO PEP_FILA_HISTORICO (AGD_SEQUENCIAL, DATA_HISTORICO,ID_EVENTO,USU_CODIGO,UNID_CODIGO) VALUES (@AGD_SEQUENCIAL,GETDATE(),3,@USUARIO_CODIGO,@UNID_CODIGO)                                                
 END        
  -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                    
 -- FINALIZAR ATENDIMENTO PEP FILA                                                              
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////        
 IF @OPCAO = 41        
 BEGIN        
 UPDATE PEP_FILA SET DATA_FINALIZACAO = GETDATE() WHERE AGD_SEQUENCIAL=@AGD_SEQUENCIAL AND UNID_CODIGO=@UNID_CODIGO        
         
 INSERT INTO PEP_FILA_HISTORICO (AGD_SEQUENCIAL, DATA_HISTORICO,ID_EVENTO,USU_CODIGO,UNID_CODIGO) VALUES (@AGD_SEQUENCIAL,GETDATE(),2,@USUARIO_CODIGO,@UNID_CODIGO)        
 END        
        
      
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
-- LISTA DE AGENDAMENTOS EM ANDAMENTO PEP                            
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
IF @OPCAO = 42               
BEGIN                
                
SELECT distinct ac.agd_sequencial,                     
  agd_datahora,                     
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                      
  a.atend_codigo,                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin,                
  vwLA.set_descricao,                
  a.atend_codigo,                
  a.atend_data,                
  ac.pac_codigo,                 
  case when exists (select 1 from UPA_Encaminhamento where ue.atend_codigo = a.atend_codigo and ue.prof_codigo_origem = @PROF_CODIGO) then 'Parecer' end as Parecer,    
  case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,    
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,    
  case when exists (select 1 from Prescricao pr where pr.atend_codigo = a.atend_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr,    
  LaudoLab.TotalLaudoLiberado as TotalLaudoLiberado,    
  LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS TotalLaudoLiberadoRadiologia,    
  LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS TotalLaudoLiberadoDiagnose     
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                    
  left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
  left join atendimento a on a.atend_codigo = ac.atend_codigo                
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
  left join pep_fila pf on pf.AGD_SEQUENCIAL = ac.AGD_SEQUENCIAL      
  left  join UPA_Encaminhamento ue on a.atend_codigo = ue.atend_codigo    
  left join UPA_Parecer up on up.upaenc_codigo = ue.upaenc_codigo    
  left join UPA_Tipo_Encaminhamento ute on ute.upatipenc_codigo = ue.upatipenc_codigo    
       
   LEFT JOIN (        
  SELECT DISTINCT vsp2.PAC_CODIGO, count(*) as TotalLaudoLiberado         
  from vwsolicitacao_pedido vsp2         
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido and esl.exasollab_status  in ('LA','LI')        
  where (vsp2.laudoliberado = 'L' or esl.exalab_codigo is not null) and vsp2.oripac_codigo = 5         
  group by vsp2.PAC_CODIGO        
   ) LaudoLab on pf.PAC_CODIGO = LaudoLab.PAC_CODIGO                  
       
   LEFT JOIN (SELECT DISTINCT vsp.PAC_CODIGO, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.PAC_CODIGO) LAUDOLAB_RADIOLOGIA ON pf.PAC_CODIGO = LAUDOLAB_RADIOLOGIA.PAC_CODIGO    
    
   LEFT JOIN (SELECT DISTINCT vsp.PAC_CODIGO, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY vsp.PAC_CODIGO) LAUDOLAB_DIAGNOSE ON pf.PAC_CODIGO = LAUDOLAB_DIAGNOSE.PAC_CODIGO            
                 
 WHERE (ac.agd_situacao = '0' or ac.agd_situacao = '5')                    
  and (exists                
     (select 1 from atendimento_ambulatorial                 
   where atend_codigo = ac.atend_codigo and                 
   atendamb_datafinal is null)                
      )                
--and ac.agd_datahora between convert(smalldatetime, convert(varchar,getdate(),112)) and dateadd(d,1,convert(smalldatetime, convert(varchar,getdate(),112)))                
  and DATEDIFF(d,ac.agd_datahora,GETDATE()) <= isnull(@FiltroDias,1)    
  and ac.prof_codigo = @PROF_CODIGO                    
  and ac.locatend_codigo = @LOCATEND_CODIGO                    
  and ac.unid_codigo = @UNID_CODIGO        
  and PF.DATA_FINALIZACAO IS NULL      
  AND PF.DATA_CANCELAMENTO IS NULL      
  AND (PF.DATA_CONFIRMACAO IS NOT NULL OR PF.data_inicio_atend IS NOT NULL)    
                  
 ORDER BY ac.AGD_SEQUENCIAL, ac.agd_datahora                
                
END       
    
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                       
 -- FILA PARA CLASSIFICACAO DE RISCO COM RISCO CLASSIFICADO PARA RECLASSIFICACAO      
 -- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                  
 IF @OPCAO = 43                                                                 
 BEGIN                                      
  SELECT FC.ACO_CODIGO,                                                                   
    FC.SPA_CODIGO,                                                           
    FC.EMER_CODIGO,        
    case when       
    pd.id is null then     
  case when fc.nomesocial is not null then fc.nomesocial + '[' + fc.nome + ']' else FC.NOME end    
 ELSE     
  'DENGUE - ' + (case when fc.nomesocial is not null then fc.nomesocial + '[' + fc.nome + ']' else FC.NOME end)    
 END AS NOME,                              
    FC.RISCO,                                                           
    CASE WHEN (LAPA.LOCATEND_CODIGO IS NOT NULL)                                   
  THEN LAPA.SET_DESCRICAO                                                                  
  ELSE LAAC.SET_DESCRICAO                                                                  
    END AS LOC_DESCRICAO,                                                                  
    AC.ACO_DATAHORA AS DATAHORA,                                                                  
    FC.SEQUENCIAL,                                                                  
    FC.CHAMADA_ATIVA,                                                                  
    FC.DESTINO,                                                                  
    FC.IDOSO,                                    
    FC.CHAMADA_ATIVA2,                                    
    FC.DESTINO2,    
    '' as TEMPOESPERAMINUTOS,    
    '' as TEMPOESPERAATENDIMENTO,    
    '' AS DATAULTIMOATENDIMENTO                                                                  
  FROM vwUPA_Fila_Classificados FC           
  INNER JOIN PRONTO_ATENDIMENTO PA  ON ( FC.SPA_CODIGO = PA.SPA_CODIGO    and pa.spa_chegada > dateadd(d, -@periodo, getdate()) )                                                       
  INNER JOIN UPA_ACOLHIMENTO AC   ON ( FC.ACO_CODIGO = AC.ACO_CODIGO  and ac.aco_datahora > dateadd(d, -@periodo, getdate()) )                                                                        
  LEFT JOIN PROTOCOLO_DENGUE PD   ON PD.SPA_CODIGO = FC.SPA_CODIGO OR PD.ACO_CODIGO = FC.ACO_CODIGO    
  INNER JOIN VWCLINICA_SPA LAAC   ON AC.LOCATEND_CODIGO = LAAC.LOCATEND_CODIGO                                                                       
  LEFT OUTER JOIN VWCLINICA_SPA LAPA ON PA.LOCATEND_CODIGO = LAPA.LOCATEND_CODIGO                                                                       
  WHERE ((LAAC.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LAAC.LOCATEND_CODIGO)                                                                   
  AND LAPA.LOCATEND_CODIGO IS NULL) OR  (LAPA.LOCATEND_CODIGO = ISNULL(@LOCATEND_CODIGO, LAPA.LOCATEND_CODIGO)                                                                   
  AND LAPA.LOCATEND_CODIGO IS NOT NULL))                     
  AND  AC.UNID_CODIGO = @UNID_CODIGO                                                                  
  AND NOT EXISTS(SELECT 1 FROM atendimento_ambulatorial AA WHERE AA.spa_codigo = PA.SPA_CODIGO AND AA.ATENDAMB_DATAFINAL IS NOT NULL)    
  ORDER BY FC.PRIORIDADE DESC, FC.ACO_CODIGO ASC                                                           
                              
 END      
    
 IF @OPCAO = 44    
 BEGIN    
    
 select     
  null as atendamb_codigo,                               
  l.pst_codigo as POSTO,                                                                          
  null as spa_codigo,                
  null as emer_codigo,                                                                             
  case when p.pac_nome_social is not null then p.pac_nome_social + '[' + p.pac_nome + ']' else p.pac_nome end as nomePaciente,                                                       
  localInternacao.set_descricao as localAtendimento,            
  LocInt_Descricao  as leito,                                                                            
  i.inter_codigo as inter_codigo,                                               
  profInternacao.prof_nome as profAtendimento,             
  null as upaclaris_risco,                                                                         
  null as tipoSaidaAmbulatorio,                                                            
  null AS SITUACAO,                                       
  null as upaatemed_encaminhamentoEixo,            
  null as upaclaris_risco,            
  null as atendimentoRealizado,                                                                          
  null as ordenacao,          
  pp.Pac_Prontuario_Numero as CodigoProntuario                        
  from                                                                                  
   internacao i                                                                   
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                            
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                                     
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)             
   inner join paciente p on i.pac_codigo = p.pac_codigo              
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo          
  where                                                                         
   i.inter_dtalta IS NULL                        
   and l.pst_codigo = @PST_CODIGO                                                                                     
   and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo          
   and l.enf_codigo_chave = isnull(@ENF_CODIGO, l.enf_codigo_chave)        
   and (i.inter_DeObservacao != 'S' or i.inter_DeObservacao is null)        
--order by nomePaciente       
    
--union ALL    
     
-- select    
--  aa.atendamb_codigo,                                
--  SC.pst_codigo as POSTO,                                                                          
--  null as spa_codigo,                
--  null as emer_codigo,                                                                             
--  case when p.pac_nome_social is not null then p.pac_nome_social + '[' + p.pac_nome + ']' else p.pac_nome end as nomePaciente,                           
--  vwa.LocAtend_descricao as localAtendimento,            
--  null  as leito,                                                                            
--  null as inter_codigo,                                                                            
--  prof.prof_nome as profAtendimento,             
--  null as upaclaris_risco,                                                                         
--  null as tipoSaidaAmbulatorio,                                                            
--  null AS SITUACAO,                                                                     
--  null as upaatemed_encaminhamentoEixo,            
--  null as upaclaris_risco,            
--  null as atendimentoRealizado,                             
--  null as ordenacao,          
--  pp.Pac_Prontuario_Numero as CodigoProntuario                        
--from                                                                                  
--   atendimento_ambulatorial aa    
--   inner join soap on aa.atendamb_codigo = soap.atendamb_codigo      
--   inner join vwlocal_atendimento vwa on vwa.locatend_codigo = aa.locatend_codigo    
--   inner join Setor_Clinica_Paramtetro_Stok sc on  sc.locatendCodigo = aa.locatend_codigo                                                                            
--   inner join profissional prof on (prof.prof_codigo = aa.prof_codigo and prof.locatend_codigo = aa.locatend_codigo)             
--   inner join paciente p on aa.pac_codigo = p.pac_codigo              
--   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo          
--  where                                                                         
--   aa.atendamb_datafinal IS NULL                        
--   and sc.pst_codigo = @PST_CODIGO                            
--   and p.unid_codigo  = @unid_codigo          
--   and sc.tipoSetor = 0    
   --and l.enf_codigo_chave = isnull(@ENF_CODIGO, l.enf_codigo_chave)             
    
order by nomePaciente         
    
 END    
    
IF @OPCAO = 45    
BEGIN    
    
 IF (@ACO_CODIGO IS NOT NULL)     
  DELETE FROM UPA_PAINEL WHERE ACO_CODIGO = @ACO_CODIGO    
     
 UPDATE UPA_FILA    
 SET NUM_CHAMADAS = 0,    
 DATA_CONFIRMACAO = NULL,    
 DESTINO = @DESTINO    
 WHERE ACO_CODIGO = @ACO_CODIGO    
    
 INSERT INTO UPA_FILA_HISTORICO (ACO_CODIGO, DATA_HISTORICO, ID_EVENTO, [LOCAL], ESPECIALIDADE, USU_CODIGO)    
 VALUES (@ACO_CODIGO, GETDATE(), 13, @DESTINO, @ESPECIALIDADE_CODIGO, @USUARIO_CODIGO)    
     
END    
    
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
-- LISTA DE AGENDAMENTOS FINALIZADOS PEP                            
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
IF @OPCAO = 46               
BEGIN                
                
SELECT distinct ac.agd_sequencial,                     
  agd_datahora,                     
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                     
  a.atend_codigo,                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin,                
  vwLA.set_descricao,                
  a.atend_codigo,                
  a.atend_data,                
  ac.pac_codigo                 
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo     
  left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
  left join atendimento a on a.atend_codigo = ac.atend_codigo                
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
  left join pep_fila pf on pf.AGD_SEQUENCIAL = ac.AGD_SEQUENCIAL                
  inner join atendimento_ambulatorial aa on aa.atend_codigo = a.atend_codigo        
                 
 WHERE exists (select 1 from atendimento_ambulatorial                
    where atend_codigo = ac.atend_codigo)     
  --and ac.agd_datahora between convert(smalldatetime, convert(varchar,getdate(),112)) and dateadd(d,1,convert(smalldatetime, convert(varchar,getdate(),112)))                
  and DATEDIFF(d,ac.agd_datahora,GETDATE()) <= isnull(@FiltroDias,1)    
  and ac.prof_codigo = @PROF_CODIGO                    
  and ac.locatend_codigo = @LOCATEND_CODIGO                    
  and ac.unid_codigo = @UNID_CODIGO        
  and AA.atendamb_datafinal is not null    
          
 ORDER BY ac.AGD_SEQUENCIAL, ac.agd_datahora                
                
END       
    
IF @OPCAO = 47    
BEGIN    
 IF (@AGD_SEQUENCIAL IS NOT NULL)     
  DELETE FROM PEP_PAINEL WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL    
     
 UPDATE PEP_FILA    
 SET NUM_CHAMADAS = 0,    
 DATA_CONFIRMACAO = NULL,    
 DESTINO = @DESTINO    
 WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL    
    
 INSERT INTO PEP_FILA_HISTORICO (AGD_SEQUENCIAL, DATA_HISTORICO, ID_EVENTO, USU_CODIGO, UNID_CODIGO)    
 VALUES (@AGD_SEQUENCIAL, GETDATE(), 13, @USUARIO_CODIGO, @UNID_CODIGO)     
END    
    
    
IF @OPCAO = 48    
BEGIN     
 UPDATE PEP_FILA    
 SET data_inicio_atend = GETDATE()    
 WHERE AGD_SEQUENCIAL = @AGD_SEQUENCIAL    
END    
    
IF @OPCAO = 49    
begin    
 SELECT distinct ac.agd_sequencial,                     
 agd_datahora,                     
 case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                      
 a.atend_codigo,                    
 isnull(parbol_usacheckin,'N') parbol_usacheckin,                
 vwLA.set_descricao,                
 a.atend_codigo,                
 a.atend_data,                
 ac.pac_codigo      
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                    
 left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
 left join atendimento a on a.atend_codigo = ac.atend_codigo    
 left join atendimento_ambulatorial aa on a.atend_codigo = aa.atend_codigo                
 left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
 inner join UPA_Encaminhamento ue on a.atend_codigo = ue.atend_codigo    
 inner join UPA_Parecer up on up.upaenc_codigo = ue.upaenc_codigo    
 inner join UPA_Tipo_Encaminhamento ute on ute.upatipenc_codigo = ue.upatipenc_codigo          
                 
 where ute.upatipenc_codigo = 4 and ue.atend_codigo is not null    
 and ue.prof_codigo_destino is null    
 and ue.prof_codigo_origem <> @PROF_CODIGO    
 and ue.locatend_codigo_destino = @LOCATEND_CODIGO                    
 and ac.unid_codigo = @UNID_CODIGO        
 and aa.atendamb_datafinal IS NULL    
 and DATEDIFF(d,ac.agd_datahora,GETDATE()) <= isnull(@FiltroDias,1)    
     
end    
    
    
IF @OPCAO = 50    
begin    
 SELECT distinct     
  p.pac_codigo,    
  pp.Pac_Prontuario_Numero,                      
  case when p.pac_nome_social is not null     
   then p.pac_nome_social + ' [' + p.pac_nome + '] - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')    
   else p.pac_nome + ' - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')    
  end as PAC_NOME,      
  case when p.pac_sexo = 'F' then 'Feminino' else 'Masculino' end as sexo,    
  p.pac_idade,    
  ue.upaenc_dataencaminhado,    
  vwLA.set_descricao,    
  i.inter_codigo    
     
                  
 FROM  internacao i inner join     
  PEDIDO_INTERNACAO pedi on pedi.pedint_sequencial = i.pedint_sequencial    
  inner join paciente p on i.pac_codigo = p.pac_codigo                    
  left join Paciente_Prontuario pp on p.pac_codigo = pp.pac_codigo    
  left join parametro_boletim pb on pb.unid_codigo = p.unid_codigo               
  inner join UPA_Encaminhamento ue on i.inter_codigo = ue.inter_codigo    
  inner join UPA_Parecer up on up.upaenc_codigo = ue.upaenc_codigo    
  inner join UPA_Tipo_Encaminhamento ute on ute.upatipenc_codigo = ue.upatipenc_codigo    
  left join vwLocal_Atendimento vwLA on ue.locatend_codigo_destino = vwLA.locatend_codigo        
 where ute.upatipenc_codigo = 4 and ue.inter_codigo is not null    
 and ue.prof_codigo_destino is null    
 and ue.prof_codigo_origem <> @PROF_CODIGO    
 and ue.locatend_codigo_destino = isnull(@LOCATEND_CODIGO, ue.locatend_codigo_destino)               
 and (@PacNomeProntuario is null    
   or p.pac_nome like '%' + @PacNomeProntuario + '%'    
   or p.pac_nome_social like '%' + @PacNomeProntuario + '%'    
   or pp.Pac_Prontuario_Numero like '%' + @PacNomeProntuario + '%')    
 and p.unid_codigo = @UNID_CODIGO    
 and i.inter_dtalta is null
     
end    
    
IF @OPCAO = 51                           
BEGIN    
     
 DECLARE @DESTINO_CHAMADO_AUXILIAR VARCHAR(50)    
    
 IF ( @ATENDAMB_CODIGO IS NULL )                                        
   BEGIN                                         
  SELECT @DESTINO_CHAMADO_AUXILIAR = DESTINO                                         
  FROM VWUPA_FILA       
  WHERE ACO_CODIGO = @ACO_CODIGO                                        
    AND  ((CHAMADA_ATIVA = 1 OR DATA_CONFIRMACAO IS NOT NULL)    
    OR (@ORIGEM = 'R' AND SPA_CODIGO IS NOT NULL)    
    OR (@ORIGEM = 'C' AND SPA_CODIGO IS NOT NULL AND ORIGEM = 'C')    
    )    
   END                                         
               
  ELSE                                        
   BEGIN                                          
  SELECT @DESTINO_CHAMADO_AUXILIAR = DESTINO                                    
  FROM UPA_FILA f                                        
     INNER JOIN UPA_FILA_SEQUENCIAL fs ON f.ACO_CODIGO = fs.ACO_CODIGO                                        
     LEFT OUTER JOIN UPA_PAINEL pn ON pn.ACO_CODIGO = fs.ACO_CODIGO                                        
  WHERE f.ACO_CODIGO = @ACO_CODIGO                                        
     AND f.DATA_CANCELAMENTO IS NULL                          
     AND f.ATENDAMB_CODIGO IS NOT NULL                        
     AND ((pn.ACO_CODIGO IS NOT NULL AND f.NUM_CHAMADAS > 0) OR (f.DATA_CONFIRMACAO IS NOT NULL))                        
   END    
     
 IF (@ACO_CODIGO IS NOT NULL)    
 BEGIN    
    
  DECLARE @NUM_CHAMADAS_AUXILIAR INT                                                                
  --DECLARE @NUM_REPETICOES_AUXILIAR INT                    
                              
  --SELECT TOP 1                                                                
  --@NUM_REPETICOES_AUXILIAR = ISNULL(NUMERO_REPETICOES, 1)                                              
  --FROM UPA_FILA_CONFIG                            
                                                                 
  SELECT @NUM_CHAMADAS_AUXILIAR = NUM_CHAMADAS                          
  FROM UPA_FILA                                          
  WHERE ACO_CODIGO = @ACO_CODIGO                                                                
                                                                 
  IF (@NUM_CHAMADAS_AUXILIAR > 0)    
  BEGIN    
   SELECT 'ESTE PACIENTE JA ESTA SENDO CHAMADO POR ' + @DESTINO_CHAMADO_AUXILIAR + '.'       
  END         
  ELSE    
  BEGIN      
   SELECT ''    
  END    
 END     
END    
    
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
-- LISTA DE AGENDAMENTOS EM ANDAMENTO PEP  , POR DATA    
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
IF @OPCAO = 52               
BEGIN                
                
SELECT distinct ac.agd_sequencial,                     
  agd_datahora,                     
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                      
  a.atend_codigo,                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin,                
  vwLA.set_descricao,                
  a.atend_codigo,                
  a.atend_data,                
  ac.pac_codigo,                 
  case when exists (select 1 from UPA_Encaminhamento where ue.atend_codigo = a.atend_codigo and ue.prof_codigo_origem = @PROF_CODIGO) then 'Parecer' end as Parecer,    
  case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,    
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,    
  case when exists (select 1 from Prescricao pr where pr.atend_codigo = a.atend_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr,    
  LaudoLab.TotalLaudoLiberado as TotalLaudoLiberado,    
  LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia AS TotalLaudoLiberadoRadiologia,    
  LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose AS TotalLaudoLiberadoDiagnose     
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                    
  left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
  left join atendimento a on a.atend_codigo = ac.atend_codigo                
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
  left join pep_fila pf on pf.AGD_SEQUENCIAL = ac.AGD_SEQUENCIAL      
  left  join UPA_Encaminhamento ue on a.atend_codigo = ue.atend_codigo    
  left join UPA_Parecer up on up.upaenc_codigo = ue.upaenc_codigo    
  left join UPA_Tipo_Encaminhamento ute on ute.upatipenc_codigo = ue.upatipenc_codigo    
       
   LEFT JOIN (        
  SELECT DISTINCT vsp2.PAC_CODIGO, count(*) as TotalLaudoLiberado         
  from vwsolicitacao_pedido vsp2         
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido and esl.exasollab_status  in ('LA','LI')        
  where (vsp2.laudoliberado = 'L' or esl.exalab_codigo is not null) and vsp2.oripac_codigo = 5         
  group by vsp2.PAC_CODIGO        
   ) LaudoLab on pf.PAC_CODIGO = LaudoLab.PAC_CODIGO                  
       
   LEFT JOIN (SELECT DISTINCT vsp.PAC_CODIGO, COUNT(*) AS TotalLaudoLiberadoRadiologia    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 AND VSP.solped_TipoSolicitacao = '8'    
  GROUP BY VSP.PAC_CODIGO) LAUDOLAB_RADIOLOGIA ON pf.PAC_CODIGO = LAUDOLAB_RADIOLOGIA.PAC_CODIGO    
    
   LEFT JOIN (SELECT DISTINCT vsp.PAC_CODIGO, COUNT(*) AS TotalLaudoLiberadoDiagnose    
  FROM VWSOLICITACAO_PEDIDO VSP    
  WHERE VSP.LAUDOLIBERADO = 'L' AND VSP.ORIPAC_CODIGO = 5 and VSP.solped_TipoSolicitacao = '9'    
  GROUP BY vsp.PAC_CODIGO) LAUDOLAB_DIAGNOSE ON pf.PAC_CODIGO = LAUDOLAB_DIAGNOSE.PAC_CODIGO            
                 
 WHERE (ac.agd_situacao = '0' or ac.agd_situacao = '5')                    
  and (exists                
     (select 1 from atendimento_ambulatorial                 
   where atend_codigo = ac.atend_codigo and                 
   atendamb_datafinal is null)                
      )                
  AND CAST(AC.agd_datahora AS DATE) = CAST(@DATA_INICIAL AS DATE)    
  and ac.prof_codigo = @PROF_CODIGO                    
  and ac.locatend_codigo = @LOCATEND_CODIGO                    
  and ac.unid_codigo = @UNID_CODIGO        
  and PF.DATA_FINALIZACAO IS NULL      
  AND PF.DATA_CANCELAMENTO IS NULL      
  AND (PF.DATA_CONFIRMACAO IS NOT NULL OR PF.data_inicio_atend IS NOT NULL)    
                  
 ORDER BY ac.AGD_SEQUENCIAL, ac.agd_datahora                   
                
END 


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
-- LISTA DE AGENDAMENTOS SEM ATENDIMENTO INICIADOS                        
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////                              
IF @OPCAO = 53 
  BEGIN

                               
SELECT distinct ac.agd_sequencial,                     
  agd_datahora,                     
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as pac_nome,                      
  a.atend_codigo,                    
  isnull(parbol_usacheckin,'N') parbol_usacheckin,                
  vwLA.set_descricao,                
  a.atend_codigo,               
  a.atend_data,                
  ac.pac_codigo            ,    
  PF.DATA_CONFIRMACAO,     
  PF.DATA_CANCELAMENTO,     
  pf.data_inicio_atend,  
  af.atenf_codigo  
                  
 FROM  agenda_consulta ac left join paciente p on ac.pac_codigo = p.pac_codigo                    
  left join parametro_boletim pb on pb.unid_codigo = ac.unid_codigo              
  left join atendimento a on a.atend_codigo = ac.atend_codigo                
  left join vwLocal_Atendimento vwLA on ac.locatend_codigo = vwLA.locatend_codigo        
  left join pep_fila pf on pf.AGD_SEQUENCIAL = ac.AGD_SEQUENCIAL                 
  left join atendimento_enfermagem af on ac.agd_sequencial = af.agd_sequencial  
                 
 WHERE (ac.agd_situacao = '0' or ac.agd_situacao = '5')                    
  and (                
 not exists (select 1 from atendimento_ambulatorial                
    where atend_codigo = ac.atend_codigo) )    
--and ac.agd_datahora between convert(smalldatetime, convert(varchar,getdate(),112)) and dateadd(d,1,convert(smalldatetime, convert(varchar,getdate(),112)))                
  and DATEDIFF(d,ac.agd_datahora,GETDATE()) <= isnull(@FiltroDias,1)    
  and ac.prof_codigo = @PROF_CODIGO         
  and ac.locatend_codigo = @LOCATEND_CODIGO                    
  and ac.unid_codigo = @UNID_CODIGO        
  and (PF.DATA_CONFIRMACAO IS NULL OR pf.data_inicio_atend is null)    
  and PF.DATA_CANCELAMENTO IS NULL      
  -- and ( ac.atend_codigo  in (select atend_codigo from atendimento_ambulatorial))
                  
 --ORDER BY ac.AGD_SEQUENCIAL, ac.agd_datahora        
 ORDER BY a.atend_data, a.atend_codigo, ac.AGD_SEQUENCIAL, ac.agd_datahora            
                
END
GO
ALTER PROCEDURE [dbo].[KSP_RELATORIO_EVOLUCAO_CTI_DIURNA] @inter_codigo char(12) = null, @evouti_codigo int = null
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
ALTER PROCEDURE [dbo].[ksp_Internacao]
@Opcao INT, @Inter_Codigo CHAR (12), @PedInt_Sequencial CHAR (12), @Pac_Codigo CHAR (12), @Inter_DtPrevista SMALLDATETIME, @LocAtend_Leito CHAR (4), @Lei_Codigo CHAR (4), @Inter_DataInter SMALLDATETIME, @EstPac_Codigo CHAR (4), @EstPac_Codigo_Alta CHAR (4), @Inter_DtAlta SMALLDATETIME, @LocAtend_Codigo CHAR (4), @Prof_Codigo CHAR (4), @Inter_Motivo_Alta CHAR (2), @LocAtend_Codigo_Resp CHAR (4), @Prof_Codigo_Resp CHAR (4), @Emer_Codigo CHAR (12), @LocAtend_Codigo_Atual CHAR (4), @EstPac_Codigo_Atual CHAR (4), @Usu_Codigo CHAR (4), @Proc_Codigo CHAR (10), @Cid_Codigo CHAR (9), @Cid_Codigo_Secundario CHAR (9), @CarInt_Codigo CHAR (2), @Set_Codigo CHAR (4), @Pac_Nome VARCHAR (50), @DataAtualClinica SMALLDATETIME, @DataCid SMALLDATETIME, @DataCid2 SMALLDATETIME, @LOGIN_USUARIO VARCHAR (50)=null, @Unid_Codigo CHAR (4)=null, @Hipotese VARCHAR (3000)=null, @Spa_Codigo CHAR (12)=null, @oripac_codigo SMALLINT=null, @inter_DeObservacao CHAR (1)='N', @lei_tipo CHAR (1)=null, @BoletimExtraviado CHAR (1)='N', @pac_prontuario CHAR (10)=null, @Sexo CHAR (12)=null, @Locatend_Codigo_Inicial CHAR (4)=null, @Modalidade INT=null, @Inter_Motivo_Alta_Descricao VARCHAR (3000)=null, @leitoRegulado CHAR (1)=null, @numAutorizacao CHAR (15)=NULL, @pstCodigo CHAR (4)=NULL, @enfCodigo CHAR (4)=NULL, @unidref_codigo_destino CHAR (4)=NULL, @PossuiPendencia INT=null, @principais_sinais_sintomas VARCHAR (500)=NULL, @condicoes_internacao VARCHAR (500)=NULL, @AtendAmb_Codigo CHAR (12)=NULL,
@PacNomeProntuario varchar(100) = null
AS
SET NOCOUNT ON                                    
DECLARE @unid_codigo_int char(3)                            
SET  @unid_codigo_int = right(@unid_codigo,2) + '%'                            
                            
                            
--Tratar erro a cada transatpo                            
DECLARE @Erro int                            
SET  @Erro = 0                            
                            
                            
--Trata erro especÃ­fico de concorrÃªncia de leito na inclusÃ£o da internaÃ§Ã£o. 07/12/2007 T=17295;C=8642                            
DECLARE @ErroConcorrenciaLeito int                            
SET @ErroConcorrenciaLeito = 0                            
                            
/*                        
 Log Diferenciado:                            
  Nas OpÃ§Ãµes de Incluspo e Exclusao: Apenas grava a OperaÃ§Ã£o                            
  Na  OpÃ§Ãµes de Alteracao: Gravar os campos Alterados e o Estorno                            
                            
*/                            
                            
DECLARE @UltCodigo  Char(12)                            
DECLARE @Data  Char(8)                            
DECLARE @Tipo_Alta  char(1)                            
DECLARE @sql   varchar(max)                            
DECLARE @par   varchar(255)                            
DECLARE @var1   varchar(255)                            
DECLARE @tp_pesq smallint                            
DECLARE @datahoje CHAR (10)                            
                            
SET @datahoje = Convert (varchar, getdate (), 103)                            
                            
IF @UNID_CODIGO IS NULL                            
 SELECT  @unid_codigo = unid_codigo FROM local_atendimento WHERE locatend_codigo = @LocAtend_Codigo                            
                            
IF @LOGIN_USUARIO IS NULL                            
 SELECT @LOGIN_USUARIO = USU_LOGIN                            
 FROM USUARIO                            
 WHERE USU_CODIGO = @USU_CODIGO                            
----------------------------- Selecao para Carga dos Dados ------------------------------------                            
If @Opcao = 0                            
 Begin                            
  set @sql =   ' SELECT I.inter_codigo,' -- 0                            
  set @sql = @sql + ' I.inter_datainter,' -- 1                            
  set @sql = @sql + ' I.inter_dtalta,' -- 2                            
  set @sql = @sql + ' I.inter_dtprevista,' -- 3                            
  set @sql = @sql + ' I.inter_motivo_alta,' -- 4                            
  set @sql = @sql + ' ISNULL(MC.motcobunid_descricao,MC_AIH.motcob_descricao) AS MotCob_Descricao,' -- 5                            
  set @sql = @sql + ' I.inter_tipo,' -- 6                            
  set @sql = @sql + ' I.pedint_sequencial,' -- 7                            
  set @sql = @sql + ' I.lei_codigo,' -- 8                            
  set @sql = @sql + ' I.locatend_codigo,' -- 9                            
  set @sql = @sql + ' S.SetCli_Descricao Descricao_LocAtend_Codigo,' -- 10                            
  set @sql = @sql + ' I.locatend_codigo_atual,' -- 11                            
  set @sql = @sql + ' S2.SetCli_Descricao Descricao_LocAtend_Codigo_Atual,' -- 12                            
  set @sql = @sql + ' I.locatend_leito,' -- 13                            
  set @sql = @sql + ' S3.SetCli_Descricao Descricao_LocAtend_Leito,' -- 14                         
  set @sql = @sql + ' I.pac_codigo,' -- 15                            
  set @sql = @sql + ' P.Pac_Nome, ' -- 16                            
  set @sql = @sql + ' PP.Pac_Prontuario_Numero Pac_Prontuario,' -- 17                            
  set @sql = @sql + ' P.Pac_Sexo,' -- 18                            
  set @sql = @sql + ' I.prof_codigo,' -- 19                            
  set @sql = @sql + ' Prof.Prof_Nome,' -- 20                            
  set @sql = @sql + ' I.emer_codigo,' -- 21                            
  set @sql = @sql + ' I.estpac_codigo,' -- 22                           
  set @sql = @sql + ' EP.EstPac_Descricao,' -- 23                            
  set @sql = @sql + ' I.estpac_codigo_atual,' -- 24                            
  set @sql = @sql + ' EP2.EstPac_Descricao EstPac_Descricao_Atual,' -- 25                            
  set @sql = @sql + ' Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + '' '' + E3.enf_codigo_local + ''/'' + L.lei_codigo Clinica_Paciente,' --26                            
  set @sql = @sql + ' I.Inter_Data_Cid,' -- 27                            
  set @sql = @sql + ' I.Inter_Data_Cid_Secundario,' -- 28                          
  set @sql = @sql + ' PID.INTER_PID_CODIGO,' -- 29                            
   set @sql = @sql + ' L.Lei_Tipo,' -- 30                               
  set @sql = @sql + ' I.Inter_hipdiag,' --31                             
  set @sql = @sql + ' I.spa_codigo,' --32                             
  set @sql = @sql + ' BE.emer_numero_be,' --32                            
  set @sql = @sql + ' PA.spa_numero_pa,' --32                            
  set @sql = @sql + ' I.inter_DeObservacao, '                            
  set @sql = @sql + ' I.prof_codigo_Resp, '                            
  set @sql = @sql + ' ProfResp.Prof_Nome Prof_Nome_Resp, ' -- 20                            
  set @sql = @sql + ' I.locatend_codigo_resp, ' -- 21 NÃ£o trazia a clinica responsÃ¡vel pela alta! Boris em 09/02/2009                              
  set @sql = @sql + ' R.resvis_descricao, '                            
  set @sql = @sql + ' I.Locatend_Codigo_Inicial, '                              
  set @sql = @sql + ' i.inter_motivo_alta_descricao,  '                            
  set @sql = @sql + ' PI.leitoRegulado,  '
  set @sql = @sql + ' PI.numAutorizacao, '
  set @sql = @sql + ' E3.pst_codigo, '
  set @sql = @sql + ' E3.enf_codigo, ' 
  set @sql = @sql + ' I.unidref_codigo_destino '                         
                            
  set @sql = @sql +' FROM  Internacao I'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_Unidade MC'                            
  set @sql = @sql +' ON   (MC.MotCob_Codigo=I.Inter_Motivo_Alta)and (MC.unid_codigo = ''' + @Unid_Codigo + ''')'
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_AIH MC_AIH'                            
  set @sql = @sql +' ON   (MC_AIH.MotCob_Codigo=I.Inter_Motivo_Alta)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA'                            
  set @sql = @sql +' ON   (LA.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN  Setor_Clinica S'                             
  set @sql = @sql +' ON   (S.SetCli_Codigo=LA.SetCli_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA2'                            
  set @sql = @sql +' ON   (LA2.LocAtend_Codigo=I.LocAtend_Codigo_Atual)'                            
                            
  set @sql = @sql +' INNER JOIN Setor_Clinica S2'                            
  set @sql = @sql +' ON  (S2.SetCli_Codigo=LA2.SetCli_Codigo)'                
                            
  set @sql = @sql +' LEFT JOIN Local_Atendimento LA3'                            
  set @sql = @sql +' ON  (LA3.LocAtend_Codigo=I.LocAtend_Leito)'                            
                            
  set @sql = @sql +' LEFT JOIN Enfermaria E3'                            
  set @sql = @sql +' ON  (E3.enf_Codigo=LA3.enf_codigo)'                            
                            
 set @sql = @sql +' LEFT JOIN Setor_Clinica S3'                            
  set @sql = @sql +' ON   (S3.SetCli_Codigo=LA3.SetCli_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Setor_Clinica SL'          
  set @sql = @sql +' ON (SL.SetCli_Codigo= La3.SetCli_Codigo)'                            
                            
  set @sql = @sql +'INNER JOIN Paciente P'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=I.Pac_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Paciente_Prontuario PP'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''')'                              
                            
  set @sql = @sql +' INNER JOIN Profissional Prof'                            
  set @sql = @sql +' ON  (Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Profissional_Rede ProfResp'                
  set @sql = @sql +' ON  (ProfResp.Prof_Codigo=I.prof_codigo_Resp)'                            
                              
  set @sql = @sql +' INNER JOIN Estado_Paciente EP'                            
  set @sql = @sql +' ON  (EP.EstPac_Codigo=I.EstPac_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Estado_Paciente EP2'                            
  set @sql = @sql +' ON  (EP2.EstPac_Codigo=I.EstPac_Codigo_Atual)'                            
                            
  set @sql = @sql +' LEFT JOIN Leito L'                            
  set @sql = @sql +' ON   (I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Internacao_Pid PID'                            
  set @sql = @sql +' ON  (PID.Inter_Codigo = I.Inter_Codigo)'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_BE BE'                            
  set @sql = @sql + ' ON  I.emer_codigo = BE.emer_codigo'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_PA PA'                            
  set @sql = @sql + ' ON  I.spa_codigo = PA.spa_codigo'                            
                            
  set @sql = @sql + ' LEFT JOIN Restricao_Visita R'                            
  set @sql = @sql + ' ON  I.inter_codigo = R.inter_codigo'                            
  
  set @sql = @sql + ' LEFT JOIN Pedido_Internacao PI'                            
  set @sql = @sql + ' ON  PI.PedInt_Sequencial = I.PedInt_Sequencial'                                                      
                            
  set @sql = @sql +' WHERE 1=1'                            
              
                            
  if @inter_codigo is not null                            
   set @sql = @sql + ' and I.Inter_Codigo  = ''' + @Inter_Codigo   + ''''
                              
  if @spa_codigo is not null                                 
  begin              
    if len(@SPA_CODIGO) < 12                      
        select  @SPA_CODIGO  = spa_codigo from numero_pa where spa_numero_pa = @SPA_CODIGO               
   set @sql = @sql + ' and I.spa_codigo  = ''' + @Spa_Codigo   + ''''
  end              
                            
  if @emer_codigo is not null                   
  begin                       
    if len(@emer_codigo) < 12                      
        select @emer_codigo = emer_codigo from numero_be where emer_numero_be = @emer_codigo                         
     set @sql = @sql + ' and I.emer_codigo  = ''' + @Emer_Codigo   + ''''
  end              
                              
  if @pedint_sequencial is not null                            
   set @sql = @sql + ' and I.PedInt_Sequencial = ''' + @PedInt_Sequencial  + ''''
                              
  if @Pac_Codigo is not null                            
   set @sql = @sql + ' and I.Pac_Codigo  = ''' + @Pac_Codigo   + ''''
                            
  set @sql = @sql  + ' and LA.UNID_CODIGO  = ''' + @Unid_Codigo   + ''''
                             
  --set @sql = left(@sql, len (@sql)-5)                            

  --set @sql = @sql + ' ORDER BY PID.Inter_Pid_codigo, I.Inter_DataInter DESC'                            
  set @sql = @sql + ' ORDER BY I.inter_codigo desc, I.Inter_DataInter DESC'
                              
  exec (@sql) 
                            
 End         
                            
                            
                            
-- INCLUIR INTERNAÃÃO ---------------------------------------------------------------------------------------------------                            
if @opcao = 1                            
begin                            
              
if @emer_codigo is not null              
begin              
    if len(@emer_codigo) < 12                      
        select @emer_codigo = emer_codigo from numero_be where emer_numero_be = @emer_codigo                         
end              
if @spa_codigo is not null              
begin              
    if len(@SPA_CODIGO) < 12                      
        select  @SPA_CODIGO  = spa_codigo from numero_pa where spa_numero_pa = @SPA_CODIGO               
end              
              
 -------------------------------------------------------------------------------                            
 -- Verifica se o leito estÃ¡ disponÃ­vel para internaÃ§Ã£o...       --                             
 -------------------------------------------------------------------------------                            
  
 if EXISTS(    
 SELECT 1  
 FROM MOVIMENTACAO_PACIENTE M  
 WHERE M.LOCATEND_CODIGO = @LOCATEND_LEITO  
   AND M.LEI_CODIGO = @LEI_CODIGO  
   AND M.MOVPAC_DATA <= ISNULL(@Inter_DtAlta, GETDATE())  
   AND  @Inter_DataInter <= ISNULL(M.MOVPAC_DATA_SAIDA, GETDATE())   
  )    
 BEGIN                             
  
  DECLARE @ERRORMESSAGE VARCHAR(1000)                           
    
  SET @INTER_CODIGO = (SELECT INTER_CODIGO FROM INTERNACAO                
  WHERE LOCATEND_LEITO = @LOCATEND_LEITO                
  AND LEI_CODIGO = @LEI_CODIGO                
  AND INTER_DTALTA IS NULL)                
                 
   IF @INTER_CODIGO IS NOT NULL                
   BEGIN                
  
    SET @ErrorMessage =  'Existe outro paciente internado no leito ' + @Lei_Codigo + ' com a internaÃ§Ã£o de nÃºmero ' + @inter_codigo                
    RAISERROR(@ERRORMESSAGE  ,1,1)                 
    RETURN                           
   END       
  
 end  
  
 update leito_historico  
 set lei_status = 'O'  
 where locatend_codigo = @locatend_leito  
   and lei_codigo = @lei_codigo  
   and data >= convert(smalldatetime, convert(char(10), @Inter_DataInter, 103), 103)  
   and data > convert(smalldatetime, convert(char(10), ISNULL(@Inter_DtAlta, GETDATE()), 103), 103)  
  
  
                
   -------------------------------------------------------------------------------                            
   -- Se necessÃ¡rio, inclui o pedido de internaÃ§Ã£o antes da internaÃ§Ã£o      --                             
   -------------------------------------------------------------------------------         
                               
   IF @PedInt_Sequencial is Null                            
   Begin                            
                               
    create table #tmp (codigo char(12))                       
                               
    insert into #tmp                            
    Execute kSp_pedido_internacao 1,                            
     null,                            
     null,                            
     @CarInt_Codigo,                            
     @cid_codigo,                            
     @Pac_Codigo, @Proc_Codigo, @Prof_Codigo,                            
     @LocAtend_Codigo,                            
     @Cid_Codigo_Secundario, @Inter_DataInter,                             
     null, null, @unid_codigo                            
                               
           set @Erro = @Erro + @@error                            
                               
    SET @datahoje = Convert (varchar, @Inter_DataInter, 103)                            
                               
    select @PedInt_Sequencial = codigo                            
    from #tmp                            
                             
 --select @PedInt_Sequencial   
                               
   End                            
                               
   Else                             
   Begin                            
                                
    update pedido_internacao                             
    set  cid_codigo = @cid_codigo,                            
     cid_secundario = @Cid_Codigo_Secundario,                            
     Proc_Codigo    = @Proc_Codigo,
	 leitoRegulado	= @leitoRegulado, 
	 numAutorizacao	= @numAutorizacao
    where PedInt_Sequencial  = @PedInt_Sequencial                            
                               
           set @Erro = @Erro + @@error                            
                               
   End                                                       
   -------------------------------------------------------------------------------                            
   -------------------------------------------------------------------------------                            
                              
                              
   -- Busca o CÃ³digo                    
   EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,                             
           @Chave      = 'internacao' ,                             
           @data       = @datahoje,                             
           @NovoCodigo = @Inter_Codigo OUTPUT                            
                              
   -- Atualiza Tabela de Internacao                            
   INSERT INTO  INTERNACAO ( inter_codigo,                             
                     pedint_sequencial,                             
                     pac_codigo,                            
                     inter_dtprevista,                             
                        locatend_leito,                             
                        lei_codigo,                             
                        inter_datainter,                      
                        estpac_codigo,                             
                        inter_dtalta,                             
                        locatend_codigo,                            
                        prof_codigo,                             
                        inter_motivo_alta,                             
         locatend_codigo_resp,                             
                        prof_codigo_resp,                            
       locatend_codigo_atual,                            
       estpac_codigo_atual,                            
       inter_data_cid,                            
       inter_data_cid_secundario,                            
       inter_hipdiag,                            
                     inter_deobservacao ,                            
       emer_codigo,                             
       spa_codigo,                          
  Locatend_Codigo_Inicial,   
       inter_motivo_alta_descricao ,
	   unidref_codigo_destino,
	   principais_sinais_sintomas,
        condicoes_internacao )                          
                              
   SELECT  @Inter_Codigo,                             
                        @PedInt_Sequencial,                             
                        @Pac_Codigo,                             
                        @Inter_DtPrevista,                           
                        @LocAtend_Leito,                             
                        @Lei_Codigo,                             
                        @Inter_DataInter,                             
                        @EstPac_Codigo,                             
                        @Inter_DtAlta,                             
                        @LocAtend_Codigo,                             
                        @Prof_Codigo,                            
                        @Inter_Motivo_Alta,                             
                        @LocAtend_Codigo_Resp,                             
                        @Prof_Codigo_Resp,                             
                 @LocAtend_Codigo_atual,                            
              @EstPac_Codigo_Atual,                            
           @DataCid,                            
           @DataCid2,                           @Hipotese,                            
       @inter_DeObservacao,                             
       @emer_codigo,                             
       @spa_codigo,                          
       @Locatend_Codigo_Inicial,  
       @Inter_Motivo_Alta_Descricao,                          
       @unidref_codigo_destino,
	   @principais_sinais_sintomas,
       @condicoes_internacao                       
                              
   set @Erro = @Erro + @@error                            
                              
   -----------------------------------------------------------------------------------------------------------------                            
   -- ALTERAR STATUS E LEITO, SE DIFERENTE DO RESERVO, DA RESERVA DE LEITO CASO EXITE PARA O PEDIDO DE INTERNAÃ?Ã?O --                             
   -----------------------------------------------------------------------------------------------------------------                            
   update  reserva_leito                            
   set reslei_status  = 3,                            
    locatend_codigo = @locatend_leito,                            
    lei_codigo  = @lei_codigo                            
   where pedint_sequencial = @pedint_sequencial                            
                              
   set @erro = @erro + @@error                            
   -----------------------------------------------------------------------------------------------------------------                            
   -----------------------------------------------------------------------------------------------------------------                            
                              
                              
   -- OS: 634 LOG DIFERENCIADO:                            
   DECLARE  @dtint char(35)                             
   set @dtint = 'Inclusao da Internacao em ' + convert(char(11), @Inter_DataInter,103) + convert(char(8), @Inter_DataInter,108)                            
                              
                              
   exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'INTERNACAO', '0' /* inclusao */, null, null, @dtint, @unid_codigo                            
      set @Erro = @Erro + @@error                            
                              
                              
    Execute ksp_Internacao_clinica_atual                             
     1,                             
     @Inter_Codigo,                             
     @LocAtend_Codigo_atual,                            
  @Inter_DataInter,                             
     @Inter_DtAlta, @LOGIN_USUARIO                            
                              
      set @Erro = @Erro + @@error                            
                              
                              
  /*                 
  SAMIR.18/11/2003                            
   Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                            
   a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                            
   os leitos                            
  */                            
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
                              
  -- SAMIR.18/11/2003.FIM                            
                              
    Execute kSp_Movimentacao_Paciente 1,                            
     Null,                            
     @LocAtend_Leito,                            
     @Inter_Codigo,                            
     @EstPac_Codigo,                             
     @Usu_Codigo,                            
     @Lei_Codigo,                            
     'I',                            
     Null,Null,Null,Null,Null,@Inter_DataInter, null, @unid_codigo                            
    
set @Erro = @Erro + @@error                                
    
 IF NOT EXISTS (SELECT 1 FROM MOVIMENTACAO_PACIENTE                            
     WHERE INTER_CODIGO = @INTER_CODIGO)                            
    BEGIN                            
                                  
  RAISERROR('Erro na inclusÃ£o da MovimentaÃ§Ã£o do Paciente.',1,1)                            
  return    
                              
    END                            
                              
  set @Erro = @Erro + @@error                            
  -- SAMIR 25/07/2002                            
                              
   /* EM CASO DE +BITO, GRAVA-O */                            
                              
    select @tipo_Alta = motcob_tipo from motivo_cobranca_aih where motcob_codigo = @Inter_Motivo_Alta                            
                              
    IF @Tipo_Alta = 'O'                            
        BEGIN                            
      Execute ksp_Obito_Paciente                            
      @Pac_Codigo,                            
      @Inter_DtAlta                            
  set @Erro = @Erro + @@error                            
     END                             
                              
                              
    INSERT INTO evolucao (inter_codigo,evo_data,prof_codigo,locatend_codigo,estpac_codigo,evo_evolucao,locatend_codigo_atual)                             
       VALUES              (@Inter_Codigo,@Inter_DataInter,@Prof_Codigo,@LocAtend_Codigo,@EstPac_Codigo_Atual,'INTERNACAO',@LocAtend_Codigo_ATUAL)                     
  set @Erro = @Erro + @@error                            
                              
   /* ALTERA AS DATAS POSTERIORES EXISTENTES, MARCANDO PARA REPROCESSAR O CENSO */                            
    UPDATE Status_Censo                            
    SET stcen_Status = 'R'                            
    WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DataInter,103),103)                            
  set @Erro = @Erro + @@error                            
                              
   /* WEB 04/04/2003  GRAVAR NOTIFICACAO COMPULASORIA*/                            
    DECLARE @CID_NOT CHAR(1)                            
                              
    SELECT @CID_NOT = C.cid_notcomp FROM CID_10 C                            
    WHERE CID_CODIGO = @CID_CODIGO                            
                              
    if @CID_NOT = 'S'                             
    BEGIN                            
     DECLARE @COD_NOTIF CHAR(10)                            
     SELECT @COD_NOTIF = ISNULL(MAX(NOTCOMP_NUMERO), 0) FROM NOTIFICACAO_COMPULSORIA                         SET @COD_NOTIF = RIGHT('0000000000' + RTRIM(CONVERT(INT, @COD_NOTIF) + 1),10)                            
                              
     DECLARE @ENDERECO VARCHAR(200)                            
     DECLARE @BAI_CODIGO CHAR(7)                            
     DECLARE @MUN_CODIGO CHAR(7)                            
                              
     SELECT  @ENDERECO = CEP.CEP_LOGRADOURO + ' - ' + ISNULL(P.pac_endereco_num,'') + ' - ' + ISNULL(p.pac_endereco_compl,''),                            
      @BAI_CODIGO = CEP.MUN_CODIGO,                            
      @MUN_CODIGO = CEP.BAI_CODIGO                            
     FROM PACIENTE P, CEP                             
     WHERE  P.CEP_SEQUENCIAL = CEP.CEP_SEQUENCIAL                            
     AND P.PAC_CODIGO = @PAC_CODIGO                            
                                 
                              
     INSERT INTO NOTIFICACAO_COMPULSORIA                            
     (notcomp_numero, pac_codigo, notcomp_data, cid_codigo, pac_endereco, bai_codigo, mun_codigo, locatend_codigo)                            
     VALUES                            
     (@COD_NOTIF ,@pac_codigo, @datacid, @cid_codigo, @ENDERECO, @BAI_CODIGO, @MUN_CODIGO, @LOCATEND_CODIGO)                            
  set @Erro = @Erro + @@error                            
                              
                              
    END                            
    
 If (@Erro <> 0)                            
            RAISERROR('ERRO - Tabela de Internação.',1,1)                            
 else    
     SELECT @Inter_Codigo as Codigo, @ErroConcorrenciaLeito as ConcorrenciaLeito  
                              
      
  
END                                    
      
                           
        
                             
------------------------------------ Alteracao dos Dados ---------------------------------------                              
If @Opcao = 2                                
Begin                                
 DECLARE @alta      smalldatetime                                
    DECLARE @dt_inter_original    smalldatetime              
    DECLARE @LocAtend_Codigo_Atual_original  char(04)                                
    DECLARE @Inter_Tipo_Alta_original   char(2)                                
    DECLARE @proc_codigo_original   char(10)                                
    DECLARE @cid_codigo_original   char(9)                                
 declare @Leito_original char(4)                                
 declare @LocAtend_Leito_original char(4)                                
                               
    
                
                                
 /*Consulta dados antes de gravar para comparar alterat)es*/                                
    Select                                
		@alta     = i.inter_dtalta,                            
		@dt_inter_original  = i.inter_datainter,                                
		@LocAtend_Codigo_Atual_original = i.locatend_codigo_atual,                                
		@Inter_Tipo_Alta_original = m.motcob_tipo,                                
		@proc_codigo_original  = p.proc_codigo,                                
		@cid_codigo_original  = p.cid_codigo,                  
		@PedInt_Sequencial  = p.pedint_sequencial,        
		@Leito_original = i.lei_codigo,        
		@LocAtend_Leito_original = i.locatend_leito,        
		@INTER_CODIGO =  inter_codigo                       
    From  internacao  i                                
		LEFT JOIN motivo_cobranca_aih  m ON m.motcob_codigo = i.inter_motivo_alta 
		LEFT JOIN pedido_internacao  p ON p.pedint_sequencial = i.pedint_sequencial 
                                
    Where  i.inter_codigo = @Inter_Codigo 
                                
   -- Data de Alta                                
    If (@alta is not null) and (@Inter_DtAlta is not null) and ( @alta <>  @Inter_DtAlta)                                
    Begin                                
     DECLARE  @dt1 char(19)                                
      DECLARE  @dt2 char(19)                                
                                   
      set @dt1 = convert(char(11), @alta,103) + convert(char(8), @alta,108)                                
      set @dt2 = convert(char(11), @Inter_DtAlta,103) + convert(char(8), @Inter_DtAlta,108)                                
                                   
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DT. DE SAIDA', '1' /* alteracao */,@dt1 ,@dt2 , 'Alteracao de Data de Saida', @unid_codigo                                
      set @Erro = @Erro + @@error                                             
 End                                
                                
  -- Data  de Internatpo                                
    If ( @dt_inter_original <>  @Inter_DataInter)                                
    Begin                                
      DECLARE  @dti1 char(19)                                
      DECLARE  @dti2 char(19)                                
                                   
      set @dti1 = convert(char(11), @dt_inter_original,103) + convert(char(8), @dt_inter_original,108)                                
      set @dti2 = convert(char(11), @Inter_DataInter,103) + convert(char(8), @Inter_DataInter,108)                                
                                
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DT. DE INTERNACAO', '1' /* alteracao */, @dti1, @dti2, 'Alteracao de Data de Internatpo', @unid_codigo                                
      set @Erro = @Erro + @@error                                              
    End                                
                                
  -- ClÃ­nica                                
    If ( @LocAtend_Codigo_Atual_original <>  @LocAtend_Codigo_Atual)                                
    Begin                                
     DECLARE @log_set_descricao varchar(50)                                
                                   
      select @log_set_descricao = 'Alteracao da Clinica do Paciente para ' + set_descricao from vwlocal_unidade where locatend_codigo = @LocAtend_Codigo_Atual                                
                                   
      exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'CLINICA DO PACIENTE', '1' /* alteracao */, @LocAtend_Codigo_Atual_original, @LocAtend_Codigo_Atual,  @log_set_descricao, @unid_codigo                                
      set @Erro = @Erro + @@error                                
    End                                
                                
   -- Motivo de Safda                                
    SELECT @tipo_Alta = motcob_tipo FROM motivo_cobranca_aih WHERE motcob_codigo = @Inter_Motivo_Alta                                
                                
   if ( @Inter_Tipo_Alta_original <>  @tipo_Alta) and ( @Inter_Tipo_Alta_original is not null) and ( @tipo_Alta is not null)                                
   begin                                
     DECLARE @log_motivo_origem varchar(30)            
     DECLARE @log_motivo_atual varchar(30)                                
                                
     if @tipo_Alta = 'A' set @log_motivo_atual = 'ALTA'                                
     if @tipo_Alta = 'O' set @log_motivo_atual = 'OBITO'                                
     if @tipo_Alta = 'P' set @log_motivo_atual = 'PERMANENCIA'                                
     if @tipo_Alta = 'T' set @log_motivo_atual = 'TRANSFERENCIA'                                
                                
    if @Inter_Tipo_Alta_original = 'A' set @log_motivo_origem = 'ALTA'                                
     if @Inter_Tipo_Alta_original = 'O' set @log_motivo_origem = 'OBITO'                                
     if @Inter_Tipo_Alta_original = 'P' set @log_motivo_origem = 'PERMANENCIA'                                
     if @Inter_Tipo_Alta_original = 'T' set @log_motivo_origem = 'TRANSFERENCIA'     
                      
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'MOTIVO DE SAIDA', '1' /* alteracao */, @log_motivo_origem, @log_motivo_atual, 'Alteracao do Motivo de Saida', @unid_codigo                                
     set @Erro = @Erro + @@error                                
                                 
    --Se alterou o motivo de saÃ­da, e era Ã³bito (logo, nÃ£o Ã© mais), retira o Ã³bito do paciente                                
     IF @Inter_Tipo_Alta_original = 'O'                                
     Begin                                
      if not exists (select 1 from obito where pac_codigo = @pac_codigo)                                 
        UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                                
     End                                
     ELSE                                
     Begin                                
        if @tipo_Alta = 'O'                                
        Execute ksp_Obito_Paciente @Pac_Codigo, @Inter_DtAlta --alterou motivo para obito                                
     End                                
 end                                
                                
  -- DIAGNOSTICO                                
   if ( @cid_codigo_original <>  @cid_codigo)                                
   begin                                
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'DIAGNOSTICO', '1' /* alteracao */, @cid_codigo_original, @cid_codigo, 'Alteracao de Diagnostico', @unid_codigo                                
    set @Erro = @Erro + @@error                                
   end                                
                                
 -- PROCEDIMETNO                                
   if ( @proc_codigo_original <>  @proc_codigo)                                
   begin                                
     exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'PROCEDIMENTO', '1' /* alteracao */, @proc_codigo_original, @proc_codigo, 'Alteracao de Procedimento', @unid_codigo                                
    set @Erro = @Erro + @@error                                
   end                                
                                
 /*Altera o Pedido da Internatpo*/                                
    EXECUTE	ksp_pedido_internacao
		@opcao = 2,
		@tp_pesq = NULL,
		@pedint_pedint_sequencial = @PedInt_Sequencial,
		@pedint_carint_codigo = @CarInt_Codigo,
		@pedint_cid_codigo = @cid_codigo,
		@pedint_pac_codigo = @Pac_Codigo,
		@pedint_proc_codigo = @Proc_Codigo,
		@pedint_prof_codigo = @Prof_Codigo,
		@pedint_locatend_codigo = @LocAtend_Codigo,
		@pedint_cid_secundario_codigo = @Cid_Codigo_Secundario,
		@pedint_inter_dtprevista = @Inter_DataInter,
		@pac_nome = NULL,
		@locatend_descricao = NULL,
		@unid_codigo = @unid_codigo,
		@pac_cartao_nsaude = NULL,
		@unid_codigocnes = NULL,
		@tipesplei_codigo = NULL,
		@locatend_codigo = NULL,
		@lei_codigo = NULL,
		@reslei_status = NULL,
		@reslei_dtAutorizacao = NULL,
		@reslei_dtInicial = NULL,
		@reslei_dtFinal = NULL,
		@usu_codigo = NULL,
		@reslei_status_busca = NULL,
		@reslei_motivo = NULL,
		@emer_codigo = NULL,
		@spa_codigo = NULL,
		@atend_codigo = NULL,
		@cod_solicitacao_ser = NULL,
		@leitoRegulado = @leitoRegulado,
		@numAutorizacao = @numAutorizacao
  set @Erro = @Erro + @@error                                
  /* Atualiza Tabela de Internacao */                                
    UPDATE INTERNACAO SET pedInt_sequencial    = @PedInt_Sequencial,                                 
		pac_codigo           = @Pac_Codigo,                            
		inter_dtprevista     = @Inter_DtPrevista,                                
		inter_datainter      = @Inter_DataInter,                                
		estpac_codigo        = @EstPac_Codigo,                                
		inter_dtalta         = @Inter_DtAlta,                                
		locatend_codigo      = @LocAtend_Codigo,                                
		prof_codigo          = @Prof_Codigo,                                
		inter_motivo_alta    = @Inter_Motivo_Alta,                                
		locatend_codigo_resp = @LocAtend_Codigo_Resp,                                
		prof_codigo_resp     = @Prof_Codigo_Resp,                                
		locatend_codigo_atual= @LocAtend_Codigo_Atual,                                
		estpac_codigo_atual  = @EstPac_Codigo_Atual,                               
		Inter_hipdiag        = @Hipotese,                                
		inter_DeObservacao   = @inter_DeObservacao,                                  
		inter_motivo_alta_descricao = @Inter_Motivo_Alta_Descricao,
		unidref_codigo_destino		= @unidref_codigo_destino    
                                
    WHERE inter_codigo         = @Inter_Codigo                                
    set @Erro = @Erro + @@error                         
                        
                        
  /* Se paciente teve alta antes da realiza??o da cirurgia, apagar a solicita??o */                        
                        
   declare @ped_codigo int
   
	if @tipo_Alta = 'O' -- Se for óbito limpa todos os pedidos posteriores a alta
	begin
		DECLARE	@return_value int
		
		EXEC	@return_value = ksp_Apagar_Pedido
				@Unid_Codigo = @unid_codigo,
				@Inter_Codigo = @inter_codigo,
				@Inter_DtAlta = @Inter_DtAlta
		
		set @Erro = @Erro + @@error
	end                         
  /* Se mudor a data de internatpo*/                                
    IF @Inter_DataInter <> @dt_inter_original                                
    Begin                                
     --mudou a data da internacao (inicial)                                
     execute ksp_Internacao_clinica_atual 2,                                
       @Inter_Codigo,                                
       @LocAtend_Codigo_Atual, -- indiferente                                
       @dt_inter_original, -- antiga                                
       @Inter_DataInter, -- nova                                
       @LOGIN_USUARIO                                
    set @Erro = @Erro + @@error                                
  --SAMIR.23/07: ALTERAR A TABELA DE MOVIMENTAÂ¦+O                                
      UPDATE  MOVIMENTACAO_PACIENTE                                
       SET MOVPAC_DATA = @Inter_DataInter                                
      WHERE INTER_CODIGO = @Inter_Codigo                                
      AND MOVPAC_STATUS = 'I'                        
    set @Erro = @Erro + @@error                                
 End                                
  /* Se mudou a Clinica Atual*/                                
    IF @LocAtend_Codigo_Atual <> @LocAtend_Codigo_Atual_original                                
    Begin                                
     -- mudou a clinica. Inclui o novo registro (alternado o outro)                                
     execute ksp_Internacao_clinica_atual 1,                 
       @Inter_Codigo,                                
       @LocAtend_Codigo_Atual,                                
       @DataAtualClinica,                                
       null,                                
       @LOGIN_USUARIO                                
   set @Erro = @Erro + @@error                                
  End                                
  /* Se mudou a Data de Alta */                                
    IF isnull(@Inter_DtAlta,'01/01/1950 00:00:00') <> isnull(@alta,'01/01/1950 00:00:00')                                
    Begin                                
     if @Alta is null                                 
      Begin                                 
      -- ALTA --                  
         execute ksp_Internacao_clinica_atual 4,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
          null,                                
          @Inter_DtAlta,                                
          @LOGIN_USUARIO                                
      set @Erro = @Erro + @@error                      
                   
  Update  MOVIMENTACAO_PACIENTE Set                  
        movpac_data_saida = @Inter_DtAlta                  
       Where inter_codigo = @inter_codigo                  
        and movpac_data_saida is null                  
      set @Erro = @Erro + @@error                                  
      End                                
      Else                                
      Begin                                
      --Mudou a Data de Alta                                
         execute ksp_Internacao_clinica_atual 9,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
         @Alta,  -- antiga                                
          @Inter_DtAlta,  -- nova                                
          @LOGIN_USUARIO                                
      set @Erro = @Erro + @@error                                
    End                                
  End                                
                                
  /* Se estava internado */                                
  IF @alta IS NULL                          
  BEGIN                                
  /* ... e npo estÃ mais: T ALTA */                                
     IF @Inter_DtAlta IS NOT NULL                                
     BEGIN                                
      -- OS: 634 LOG DIFERENCIADO:                                
         DECLARE  @dta char(19)                                
         set @dta = convert(char(11), @Inter_DtAlta,103) + convert(char(8), @Inter_DtAlta,108)                                
         set @log_motivo_atual = ''                                
         if @tipo_Alta = 'A' set @log_motivo_atual = 'Saida por ALTA'                                
         if @tipo_Alta = 'O' set @log_motivo_atual = 'Saida por OBITO'                                
         if @tipo_Alta = 'P' set @log_motivo_atual = 'Saida por PERMANENCIA'                                
         if @tipo_Alta = 'T' set @log_motivo_atual = 'Saida por TRANSFERENCIA'                                
                                  
         exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'SAIDA', '3' /* Alta */, null, @dta, @log_motivo_atual, @unid_codigo                                
      set @Erro = @Erro + @@error                                
      /*                                
      SAMIR.18/11/2003                                
      Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                                
      a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                                
      os leitos                                
      */                                
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
    -- SAMIR.18/11/2003.FIM                                
                                  
    /*EVOLUÂ¦+O, referente a ALTA */                             
      DECLARE @ja_evoluiu char(12)                                
                                    
         select @ja_evoluiu = inter_codigo from evolucao                                
         where inter_codigo = @Inter_Codigo and evo_data = @Inter_DtAlta                                
                  
         if @ja_evoluiu is null                                 
         begin                                
          select @tipo_Alta = motcob_tipo                                 
            from motivo_cobranca_aih                                 
            where motcob_codigo = @Inter_Motivo_Alta                                
             DECLARE @log_motivo_alta varchar(30)                                
             if @tipo_Alta = 'A' set @log_motivo_alta = 'ALTA'                                
            if @tipo_Alta = 'O' set @log_motivo_alta = 'OBITO'                                
            if @tipo_Alta = 'P' set @log_motivo_alta = 'PERMANENCIA'                                
            if @tipo_Alta = 'T' set @log_motivo_alta = 'TRANSFERENCIA'                                
            Execute kSP_Evolucao 1, Null, @Inter_Codigo, @Inter_DtAlta, @Prof_Codigo, @LocAtend_Codigo, @EstPac_Codigo_Atual, @LocAtend_Codigo_Atual, @log_motivo_alta, Null,null                                
       set @Erro = @Erro + @@error                                
      end                                
        /*Se o motivo da alta T +BITO, entpo mata o cara */                                
         select @tipo_Alta = motcob_tipo                                 
         from motivo_cobranca_aih                                 
         where motcob_codigo = @Inter_Motivo_Alta                                
                                  
         IF @TIPO_ALTA = 'O'                                
         BEGIN                                
          Execute ksp_Obito_Paciente                                
             @Pac_Codigo,                                
             @Inter_DtAlta                                
       set @Erro = @Erro + @@error                                
      END                                 
  END                        
  END                          
  ELSE                                
  /* Se npo estÃ internado (jÃ estÃ de alta)*/                                
  BEGIN                                
   /* ... E agora estÃ internado: T ESTORNO de ALTA */                                
     IF @Inter_DtAlta IS NULL                                
     BEGIN                                
      -- OS: 634 LOG DIFERENCIADO:                                
         exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'ESTORNO', '4' /* estorno */, null, null, 'Estorno da Saida da Internacao', @unid_codigo                                
   set @Erro = @Erro + @@error      
                                 
  if (@LocAtend_Leito = @LocAtend_Leito_original     
       and @Leito_original = @Lei_Codigo)    
  BEGIN         
   Update  MOVIMENTACAO_PACIENTE     
   Set movpac_data_saida = null                  
   Where movpac_sequencial = (select max(movpac_sequencial) from MOVIMENTACAO_PACIENTE where inter_codigo = @inter_codigo)                  
   set @Erro = @Erro + @@error                                   
  END        
  ELSE        
  BEGIN        
   declare @MovPac_Sequencial char(12)        
   EXEC ksp_controle_sequencial @Unidade = @unid_codigo ,           
   @Chave      = 'movimentacao_paciente' ,           
   @data       = @datahoje,           
   @NovoCodigo = @MovPac_Sequencial OUTPUT          
   INSERT INTO movimentacao_paciente          
   (movpac_sequencial,          
   locatend_codigo,          
   inter_codigo,          
   estpac_codigo,          
   usu_codigo,          
   lei_codigo,          
   movpac_data,          
   movpac_status)          
            
   VALUES          
   (@MovPac_Sequencial,          
         @LocAtend_Leito,                
       @Inter_Codigo,             
       @EstPac_Codigo,                   
       @Usu_Codigo,           
       @Lei_Codigo,           
       @alta,          
       'M')            
    
 update internacao     
  set locatend_leito = @locatend_leito,     
   lei_codigo = @Lei_Codigo     
 where inter_codigo = @Inter_Codigo       
            
   set @Erro = @Erro + @@error                                   
  End        
          
        
         /*                                
     SAMIR.18/11/2003                                
      Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                                
      a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                                
      os leitos                                
     */                                
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
      -- SAMIR.18/11/2003.FIM                         
                                  
         -- EM CASO DE ESTORNO DE ALTA, SENDO A ALTA UM +BITO, REMOVER O OBITO DO PACIENTE         
    --27/05/2002                                
       IF @Inter_Tipo_Alta_original = 'O'                                 
         Begin                                
          UPDATE  paciente                                 
            SET pac_dtObito = NULL                                
            WHERE  pac_codigo = @Pac_Codigo                                
       set @Erro = @Erro + @@error                                
       End                                
                                  
    /* Exclusao da Evolutpo de Alta, se for estorno de alta */                                
         Execute kSP_Evolucao 3, Null, @Inter_Codigo, @alta, Null, Null, Null, Null, Null, Null,null                                
   set @Erro = @Erro + @@error                                
                                  
    -- LEONARDO LIMA .24/10/2005                                
                                  
         -- EM CASO DE ESTORNO DE ALTA, LIMPAR A DATA FINAL DA CLINICA ATUAL                                
         execute ksp_Internacao_clinica_atual 8,                                
          @Inter_Codigo,                                
          @LocAtend_Codigo_Atual,                                
          @Alta,  -- antiga                                
 @Inter_DtAlta,  -- nova                                
          @LOGIN_USUARIO                                
                                  
      set @Erro = @Erro + @@error                                
                                   
    --FIM 24/10/200                                
  END                                    
 END                                
                                   
  -- ALTERA AS DATAS POSTERIORES EXISTENTES, MARCANDO PARA REPROCESSAR O CENSO                                
 If @dt_inter_original <> @Inter_DataInter                                
 Begin                                
  If @dt_inter_original < @Inter_DataInter                                
     Begin                                
        UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@dt_inter_original,103),103)                                
      set @Erro = @Erro + @@error                                
    End                                
     Else                                
     Begin                                
      UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DataInter,103),103)                                
      set @Erro = @Erro + @@error                                
  End                                
 End                                
                                  
  /*Marca para reprocessar desde a data: ou de ALTA, ou de ALTA ORIGINAL*/                                
 If @alta <> @Inter_DtAlta                                
 Begin                                
  If @Inter_DtAlta Is Not Null                                
     Begin                                
      UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DtAlta,103),103)                                
      set @Erro = @Erro + @@error                                
     End                                
     If @alta Is Not Null                         
      Begin         
        UPDATE Status_Censo                                
        SET stcen_Status = 'R'                                
        WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@alta,103),103)                                
      set @Erro = @Erro + @@error                                
  End                                
 End                                
                                
        
                              
End /* Optpo = 2: Alterar */                              
------------------------------------ Exclusao dos Dados ---------------------------------------                            
if @Opcao = 3                            
 Begin                            
                            
  -- OS: 634 LOG DIFERENCIADO:                            
  exec ksp_log_internacao @Inter_Codigo, @LOGIN_USUARIO, 'EXCLUSAO', '2' /* exclusao */, null, null, 'Exclusao da Internacao', @unid_codigo                            
set @Erro = @Erro + @@error                            
  /* verifica os dados */                            
  SELECT               
   @LocAtend_Codigo = locatend_leito,                             
   @Lei_Codigo  = lei_codigo,                            
   @Inter_DtAlta  = inter_dtalta,                            
   @cid_codigo = P.cid_codigo,                            
   @Inter_Motivo_Alta = inter_motivo_alta                            
  FROM  internacao
	LEFT JOIN PEDIDO_INTERNACAO P ON internacao.PEDINT_SEQUENCIAL = P.PEDINT_SEQUENCIAL 
  WHERE  inter_codigo = @Inter_Codigo
                            
                            
  -- 0 deletar NOTIFICACAO_COMPULSORIA                            
                            
  --1 DELETAR movimentacao_paciente                            
  --3 DELETAR espelho_aih                            
   --2 DELETAR auditor_procedimento                            
  --5 DELETAR resumo_alta                            
   --4 DELETAR resumo_alta_procedimento                            
  --6 DELETAR procedimentos_realizados                            
  --7 DELETAR internacao_parto                            
  --8 DELETAR evolucao                       
  --9 DELETAR internacao_clinica_atual                            
  --10 DELETAR internacao                            
  --11 ALTERAR leito = LIVRE                            
  --12 Marcar para reprocessar o CENSO                            
                            
  if not exists (select 1 from obito where pac_codigo = @pac_codigo)                            
   UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                            
                            
                            
 /* ROTINAS DE EXLUSAO */                            
 -- 0 deletar NOTIFICACAO_COMPULSORIA                            
  delete from NOTIFICACAO_COMPULSORIA                            
  where pac_codigo = @pac_codigo                            
  and cid_codigo = @cid_codigo                            
set @Erro = @Erro + @@error                            
 --1- DELETA Evolucao                            
    DELETE FROM                             
   movimentacao_paciente                            
  WHERE inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --2- DELETA auditor_procedimento (PRE-REQUISITO PARA espelho_aih)                            
  DELETE FROM                              
   auditor_procedimento                            
  FROM  espelho_aih, auditor_procedimento                            
  WHERE  auditor_procedimento.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
--SAMIR.23/04.ATOS_PROFISSIONAIS                            
 --21.PACIENTE_AIH   
  DELETE FROM                            
   paciente_aih                            
  FROM  espelho_aih, paciente_aih                            
  WHERE  paciente_aih.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --22.ATOS_PROFISSIONAIS                            
  DELETE FROM                            
   atos_profissionais                            
  FROM  espelho_aih, atos_profissionais                            
  WHERE  atos_profissionais.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
--FIM                            
--SAMIR.19/11/2003 Mais relacionaentos                            
 --23.PREVISAO_FATURAMENTO                            
  DELETE FROM                         
   previsao_faturamento                            
  FROM  espelho_aih, previsao_faturamento                            
  WHERE  previsao_faturamento.aih_sequencial = espelho_aih.aih_sequencial                            
  AND  espelho_aih.inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --24.Cartao_Visita                            
  DELETE FROM                            
   Cartao_Visita                            
  WHERE  inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
 --25.restricao_visita                            
  DELETE FROM                            
   restricao_visita                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
--fim                      
 --3- DELETA espelho_aih                            
    DELETE FROM                             
   espelho_aih                            
 WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --4- DELETA resumo_alta_procedimento (PRE-REQUISITO PARA resumo_alta)                            
    DELETE FROM                             
   resumo_alta_procedimento                            
  WHERE  inter_codigo = @Inter_Codigo                            
                            
set @Erro = @Erro + @@error                            
 --5- DELETA resumo_alta                            
    DELETE FROM                             
   resumo_alta                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --6- DELETA procedimentos_realizados                            
    DELETE FROM                             
   procedimentos_realizados                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --7- DELETA internacao_parto                            
    DELETE FROM                             
   internacao_parto                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
 --8- DELETA evolucao                            
                            
    DELETE FROM                             
   evolucao                            
  WHERE inter_codigo = @Inter_Codigo                         
set @Erro = @Erro + @@error                            
 -- 9 DELETA internacao_clinica_atual                            
  DELETE FROM                             
   INTERNACAO_CLINICA_ATUAL                            
  WHERE inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
-- LEONARDO LIMA 06/10/2005 - PID                              
DELETE FROM                             
   INTERNACAO_PID                            
  WHERE inter_codigo =  @Inter_Codigo                            
set @Erro = @Erro + @@error                            
                            
-- SolicitaÃ§Ã£o de ProntuÃ¡rio                            
 --Remove a solicitaÃ§Ã£o de prontuÃ¡rio:                            
 SELECT                             
  @LocAtend_Codigo = locatend_codigo                            
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
                            
                              
                            
                            
/*----*/--10- DELETA internacao  (MOTIVO DE TODOS OS DELETEÂ¦S ANTERIORES)                            
                            
    DELETE FROM                             
   internacao                            
  WHERE  inter_codigo = @Inter_Codigo                            
set @Erro = @Erro + @@error                            
/*------------------------------------------------------------*/                            
                            
 --11- Atualizacao na Tabela de Leitos                            
/*                            
SAMIR.18/11/2003                            
 Devido a problemas encontrados referente a leitos Livres e Ocupados, devido principalmente                            
 a tratamentos de internat)es/estornos retroativos, npo altera o leito em questpo, e sim, verifica todos                            
 os leitos                            
*/                            
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
                            
-- SAMIR.18/11/2003.FIM                            
                            
 --12 Marca para reprocessar os Censos...                          
  UPDATE                             
   Status_Censo                            
  SET stcen_Status = 'R'                            
  WHERE  stcen_Data >= convert(smalldatetime,convert(char(10),@Inter_DtAlta,103),103)                            
set @Erro = @Erro + @@error                                  
  IF @Inter_Motivo_Alta = 'O'                             
   UPDATE paciente SET pac_dtObito = NULL WHERE pac_codigo = @Pac_Codigo                            
set @Erro = @Erro + @@error                            
                            
 End /*Opcao 3=Excluir*/                            
---------------------------------- NÂ·mero do +ltimo C=digo -----------------------------------                            
If @Opcao = 4                             
 Begin                            
--  Exec  kSp_Novo_Codigo 'internacao','inter_codigo','N', @Inter_Codigo output                            
  EXEC ksp_controle_sequencial @Unidade    = @unid_codigo ,                            
          @Chave      = 'internacao' ,                             
          @data       = @datahoje,               
          @NovoCodigo = @inter_codigo OUTPUT                            
                            
 End                            
                            
------------------------------ Internacoes do Mapa de Leitos ----------------------------------                            
If @Opcao = 5                            
 Begin                            
  Select  I.Pac_Codigo,                            
   P.Pac_Nome,                            
   PP.Pac_Prontuario_Numero as Pac_Prontuario,                            
   I.Inter_Codigo,                            
   I.Inter_DataInter,                            
                            
   Enf.Set_Descricao,                            
   L.LocAtend_Codigo,                            
   L.Lei_Codigo,                            
   L.LocInt_Descricao,                            
   L.Enf_Codigo,                            
   L.Lei_Status                            
                            
                            
         From    Internacao I,                            
   vwLeito L,                            
   Estado_Paciente E,                            
   Paciente P,                            
   vwEnfermaria Enf,                            
   Paciente_Prontuario PP                            
                            
  Where   I.EstPac_Codigo  = E.EstPac_Codigo                            
  And  I.Pac_Codigo   = P.Pac_Codigo                            
  And  I.Lei_Codigo   = L.Lei_Codigo                            
  And I.LocAtend_Leito  = L.LocAtend_Codigo                            
  And L.Enf_Codigo   = Enf.Enf_Codigo                            
  And     P.Pac_Codigo            = PP.Pac_Codigo                            
                            
         And  I.Inter_DtAlta Is NULL                            
  And  L.LocAtend_Codigo =  IsNull(@LocAtend_Leito,L.LocAtend_Codigo)                            
  And I.Lei_Codigo = IsNull(@Lei_Codigo,I.Lei_Codigo)                            
  And  L.Set_Codigo = IsNull(@Set_Codigo,L.Set_Codigo)                            
                            
  Order By L.Enf_Codigo, L.Lei_Codigo, I.Inter_DataInter Desc                            
set @Erro = @Erro + @@error                            
 End                            
----------------------------------------- Mapa de Leitos ---------------------------------------                            
If @Opcao = 6                            
 Begin   
                            
                            
  set @sql =   ' Select vwEnf.LocAtend_Descricao,'                            
  set @sql = @sql + '   vwLei.LocAtend_Codigo,'                            
  set @sql = @sql + '   vwLei.Lei_Codigo,'                            
  set @sql = @sql + '   vwLei.LocInt_Descricao,'                            
  set @sql = @sql + '   vwEnf.Enf_Codigo,'                            
  set @sql = @sql + '   vwLei.Lei_Status,'                            
  set @sql = @sql + '   I.Inter_Codigo,'                            
  set @sql = @sql + '   I.Pac_Codigo,'                            
  set @sql = @sql + '   space(50) Pac_Nome,'                            
  set @sql = @sql + '   space(10) Pac_Prontuario,'                            
  set @sql = @sql + '   vwLei.Lei_Tipo,'               
  set @sql = @sql + '   LA.set_descricao Clinica_Paciente,'                            
  set @sql = @sql + '   I.inter_DeObservacao, '                            
  set @sql = @sql + '   I.inter_datainter,'                        
  set @sql = @sql + '   proced.proc_tempo,'
  set @sql = @sql + '   0 as PossuiPendencia,'   
  set @sql = @sql + '  (select case when count(*) = 1 then min(movpac_data)' 
  set @sql = @sql + '              when count(*) > 1 then max(movpac_data)' 
  set @sql = @sql + '  	  else null end'
  set @sql = @sql + '  	  from movimentacao_paciente mp where I.inter_codigo = mp.inter_codigo and I.LocAtend_Leito = mp.LocAtend_Codigo) as TempoLeito '                   
                            
  set @sql = @sql + ' Into  #Temp_Mapa_Leitos'                            
                                
  set @sql = @sql + ' From vwLeito  vwLei'                             
  set @sql = @sql + ' inner join vwEnfermaria vwEnf on VWLEI.LocAtend_Codigo = vwEnf.LocAtend_Codigo'                            
  set @sql = @sql + ' left join Internacao I on I.LocAtend_Leito = vwLei.LocAtend_Codigo and I.Lei_Codigo = vwLei.Lei_Codigo and I.Inter_DtAlta Is Null'                            
  set @sql = @sql + ' left join vwLocal_unidade LA on I.locatend_Codigo_atual = la.LocAtend_Codigo'                            
  set @sql = @sql + ' Left join Pedido_Internacao Ped_Int on I.pedint_sequencial = Ped_int.pedint_sequencial'                      
  set @sql = @sql + ' Left join procedimento proced on Ped_Int.proc_codigo = proced.proc_codigo'                      
                            
  set @sql = @sql + ' Where 1 = 1'                            
                            
  If @Set_Codigo is not null                            
   set @sql = @sql + '  And vwenf.locatend_Codigo_clinica = ' + '''' + @Set_Codigo + ''''                            
                            
                            If @LocAtend_Leito is not null                             
   set @sql = @sql + ' And vwLei.LocAtend_Codigo  = ' + '''' + @LocAtend_Leito + ''''                            
                            
  set @sql = @sql + ' And vwLei.unid_codigo   = ' + '''' + @unid_codigo + ''''                            
  set @sql = @sql + ' And not exists (select 1 from enfermaria e where e.enf_codigo = vwEnf.Codigo_Enfermaria and e.enf_operacional = ' + '''' + 'N' + '''' + ')'                            
                            
  -- Filtro por clÃ­nica ( exibe os leitos livres e ocupados da clinica e pacientes fora da clÃ­nica) --                            
  If @locatend_codigo_atual is not null                            
  begin                            
                            
   set @sql = @sql + ' And ( (I.locatend_codigo_atual = ' + '''' + @locatend_codigo_atual + '''' + ') Or'                            
   set @sql = @sql + '   ((vwEnf.locatend_Codigo_clinica = ' + '''' + @locatend_codigo_atual + '''' + ') And'                                        
   set @sql = @sql + '   (vwLei.lei_status = ' + '''' + 'L' + '''' + ')) )'                            
                            
  end                            
                            
  If @lei_tipo is not null                            
   set @sql = @sql + '  And vwLei.Lei_Tipo = ' + '''' + @lei_tipo + ''''                            
                            
  Else If @lei_tipo <> '5' or @lei_tipo is null                            
   set @sql = @sql + '  And (I.inter_DeObservacao = ''N'' or vwLei.Lei_Tipo <> ''5'')'                            
                        
  set @Erro = @Erro + @@error                            
                             
  set @sql = @sql + ' Update #Temp_Mapa_Leitos'                            
  set @sql = @sql + ' Set  Pac_Nome = Null, Pac_Prontuario = Null'                            
              
  set @Erro = @Erro + @@error                            
                            
  set @sql = @sql + ' Update  #Temp_Mapa_Leitos'                            
  set @sql = @sql + ' Set  #Temp_Mapa_Leitos.Pac_Nome = case when P.pac_nome_social is not null then p.pac_nome_social + ''['' + P.Pac_Nome + '']'' else P.pac_nome end,'                            
  set @sql = @sql + '    #Temp_Mapa_Leitos.Pac_Prontuario = PP.Pac_Prontuario_Numero'                            
  set @sql = @sql + ' From  #Temp_Mapa_Leitos
							INNER JOIN Paciente P ON #Temp_Mapa_Leitos.Pac_Codigo = P.Pac_Codigo
							LEFT JOIN Paciente_Prontuario PP ON P.Pac_Codigo = PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''' '
                            
  set @Erro = @Erro + @@error  
  
  set @sql = @sql + ' Update #Temp_Mapa_Leitos'
  set @sql = @sql + ' Set  PossuiPendencia = 1'
  set @sql = @sql + ' Where  Inter_Codigo in (select inter_codigo from Pendencia_Paciente)'                           
                            
  set @sql = @sql + ' Select LocAtend_Descricao,'                            
  set @sql = @sql + '   LocAtend_Codigo,'                            
  set @sql = @sql + '   Lei_Codigo,'                            
  set @sql = @sql + '   LocInt_Descricao,'                            
  set @sql = @sql + '   Enf_Codigo,'                            
  set @sql = @sql + '   Lei_Status,'                            
  set @sql = @sql + '   Inter_Codigo,'                            
  set @sql = @sql + '   Pac_Codigo,'                            
  set @sql = @sql + '   Pac_Nome,'                            
  set @sql = @sql + '   Pac_Prontuario,'                            
  set @sql = @sql + '   Lei_Tipo,'                            
  set @sql = @sql + '   Clinica_Paciente,'                            
 set @sql = @sql + '    Inter_DeObservacao,'        
  set @sql = @sql + '   inter_datainter,'                            
  set @sql = @sql + '   proc_tempo,'                
  set @sql = @sql + '   PossuiPendencia, '
  set @sql = @sql + '   TempoLeito '
                             
  set @sql = @sql + ' From #Temp_Mapa_Leitos'
  
  if (@PossuiPendencia = 1)
	set @sql = @sql + ' where PossuiPendencia = 1 '              
                  
  set @sql = @sql + ' Order By Enf_Codigo, Lei_Codigo'                            
                            
  set @sql = @sql + ' Drop Table  #Temp_Mapa_Leitos'                            
                            
  set @Erro = @Erro + @@error                            
                            
  Exec(@sql)                       
                            
 End                            
                            
----------------------------------------- Evolutpo ---------------------------------------                            
If @Opcao = 7                            
 Begin                            
  Select                            
   PDI.Pac_Codigo,                            
   P.Pac_Nome,                                
       vwLA.LocAtend_descricao,                            
   M.Med_Nome,                            
   CID.Cid_Descricao,                            
   Proced.Proc_Descricao,                            
   vwL.LocInt_Descricao,                            
   CA.LocAtend_Codigo,                            
   CA.LocAtend_Descricao,                            
   I.Inter_DataInter,                            
   I.Inter_DtAlta,  
   I.inter_motivo_alta_descricao,
   PDI.leitoRegulado,
   PDI.numAutorizacao                             
                            
  From Internacao   I                            
   INNER JOIN Pedido_Internacao PDI ON PDI.PedInt_Sequencial = I.PedInt_Sequencial                            
   LEFT JOIN CID_10 CID ON CID.Cid_Codigo = PDI.Cid_Codigo                            
   LEFT JOIN Medico M ON M.LocAtend_Codigo = PDI.locatend_codigo                            
     AND M.prof_codigo = PDI.Prof_Codigo                            
   LEFT JOIN Procedimento Proced ON Proced.Proc_Codigo = PDI.proc_codigo                           
   LEFT JOIN Paciente P ON P.Pac_Codigo = PDI.Pac_Codigo               
   LEFT JOIN vwLocal_Atendimento vwLA ON vwLA.LocAtend_Codigo = M.LocAtend_Codigo                            
       LEFT JOIN vwLeito vwL ON vwL.LocAtend_Codigo = I.locatend_leito                            
     AND vwL.Lei_Codigo = I.lei_codigo                            
   LEFT JOIN  vwLocal_Atendimento CA ON CA.LocAtend_Codigo = I.locatend_codigo                            
                            
      Where   I.Inter_Codigo          = @Inter_Codigo                            
 End                            
----------------------------------------- Pesquisa ---------------------------------------                            
If @Opcao = 8                            
 Begin                            
                            
  set @tp_pesq = convert(smallint,@carint_codigo)                            
                            
                            
  set @sql =    ' SELECT i.inter_codigo,'                            
  set @sql = @sql + ' convert(char(10),i.inter_datainter,103)    + '' '' +  convert(char(5),i.inter_datainter,108) inter_datainter,'                            
 set @sql = @sql + ' convert(char(10),i.inter_dtalta,103)  + '' '' +  convert(char(5),i.inter_dtalta,108) inter_dtalta,'                            
  set @sql = @sql + ' pp.pac_prontuario_numero as pac_prontuario,'                            
  set @sql = @sql + ' p.pac_nome,'                            
  set @sql = @sql + ' p.pac_codigo,'                            
  set @sql = @sql + ' i.spa_codigo,'                            
  set @sql = @sql + ' i.pedint_sequencial,'                            
  set @sql = @sql + ' i.inter_dtprevista,'                            
  set @sql = @sql + ' i.estpac_codigo,'                            
  set @sql = @sql + ' i.estpac_codigo_atual,'                            
  set @sql = @sql + ' i.locatend_codigo,'                            
  set @sql = @sql + ' i.locatend_leito,'                            
  set @sql = @sql + ' i.lei_codigo,'                            
  set @sql = @sql + ' i.prof_codigo,'                              
  set @sql = @sql + ' i.inter_motivo_alta_descricao,'                            
  set @sql = @sql + ' pi.proc_codigo,'
  set @sql = @sql + ' PI.leitoRegulado,'
  set @sql = @sql + ' PI.numAutorizacao '                            
  set @sql = @sql + ' FROM internacao i, pedido_internacao pi, paciente p, paciente_prontuario pp'                            
  set @sql = @sql + ' WHERE p.pac_codigo = i.pac_codigo and'                            
  set @sql = @sql + ' i.pedint_sequencial = pi.pedint_sequencial and'                            
  set @sql = @sql + ' p.pac_codigo = pp.pac_codigo and'                            
  set @sql = @sql + ' pp.unid_codigo = ''' + @unid_codigo +  ''' and'                
  set @sql = @sql + ' i.inter_codigo like ''' + @unid_codigo_int + ''' and '    
  set @sql = @sql + ' i.inter_DeObservacao = ''N'' and '                            
                            
  if @pac_codigo is not null                            
     begin                            
       Set @var1 = convert(varchar,@pac_codigo)                            
   Exec ksp_ParametroPesquisa @var1,'p.pac_codigo',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_codigo is not null                            
     begin                            
   Set @var1 = convert(varchar,@inter_codigo)                            
       Exec ksp_ParametroPesquisa @var1,'i.inter_codigo',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @pac_nome is not null                            
     begin                            
   Set @var1 = @pac_nome                            
   Exec ksp_ParametroPesquisa @var1,'p.pac_nome',@tp_pesq,'t', @par output                            
   set @Erro = @Erro + @@error                
            end                            
                            
  if @proc_codigo is not null                            
     begin                            
   set @var1 = convert(varchar,@proc_codigo)                            
   exec ksp_ParametroPesquisa @var1,'pp.pac_prontuario_numero',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_datainter is not null                            
     begin                            
   set @var1 = convert(char(10),@inter_datainter,103)                            
   exec ksp_ParametroPesquisa @var1,'convert(char(10),i.inter_datainter,103)',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @inter_dtalta is not null                            
     begin                            
   set @var1 = convert(char(10),@inter_dtalta,103)                            
   exec ksp_ParametroPesquisa @var1,'convert(char(10),i.inter_dtalta,103)',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                    
                            
  if @spa_codigo is not null                            
     begin                            
   set @var1 = @spa_codigo                            
   exec ksp_ParametroPesquisa @var1,'i.spa_codigo',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                           
                            
  if @emer_codigo is not null         begin                            
   set @var1 = @emer_codigo                            
   exec ksp_ParametroPesquisa @var1,'i.emer_codigo',@tp_pesq,'t',@par output              
   set @Erro = @Erro + @@error                            
     end                            
                            
  if @pac_prontuario is not null                            
     begin                            
   set @var1 = convert(varchar,@pac_prontuario)                            
   exec ksp_ParametroPesquisa @var1,'pp.pac_prontuario_numero',@tp_pesq,'t',@par output                            
   set @Erro = @Erro + @@error                            
     end                            
                            
                            
  set @Sql = @Sql + @par + ' Order by convert(smalldatetime,i.inter_datainter) desc'                            
                              
                            
  exec(@sql)                            
                            
  set @Erro = @Erro + @@error                        
 End                            
                            
                            
----------------------------------------- Local da Internatpo ---------------------------------------                            
If @Opcao = 9                            
Begin                            
 DECLARE @LocInt_Descricao CHAR(100)                            
 DECLARE @hospdia_codigo CHAR(12)                            
                             
 Select  @LocInt_Descricao = LocInt_Descricao,                            
   @LEI_TIPO = vw.Lei_Tipo,                            
   @inter_codigo = i.inter_codigo,                            
   @inter_DeObservacao = inter_DeObservacao                            
 From  internacao i, vwLeito vw                            
 Where  i.pac_codigo = @Pac_Codigo                            
 And  i.inter_dtalta is null                            
 And  i.locatend_leito = vw.locatend_codigo                            
 And  i.lei_codigo  = vw.lei_codigo                            
 And   vw.unid_codigo          = @unid_codigo                            
                            
 SELECT @hospdia_codigo = hospdia_codigo                            
 from hospitaldia          
 WHERE pac_codigo = @Pac_Codigo                            
 and hospdia_DataFim is null                            
                            
 if (@inter_codigo is not null)                            
  Select  @LocInt_Descricao  LocInt_Descricao,                             
   @hospdia_codigo  hospdia_codigo,                            
   @LEI_TIPO  Lei_Tipo,                            
   @inter_codigo  inter_codigo,                            
   ISNULL(@inter_DeObservacao, 'N')  inter_DeObservacao                            
                            
End                            
----------------------------------------- Clinica para Carga na Combo ---------------------------------------                       
If @Opcao = 10                            
Begin                            
                            
 Select  S.SET_DESCRICAO,                            
  S.SET_CODIGO                             
                            
 FROM    LOCAL_ATENDIMENTO LA,                             
  SETOR S                            
                            
 WHERE   LA.LOCATEND_CODIGO  = @LocAtend_Leito                            
 AND     S.SET_CODIGO   = LA.SET_CODIGO                            
                            
End                            
----------------------------------------- Internacao de Homonimo --------------------------------                            
If @Opcao = 11                            
Begin                            
                            
 Select i.inter_codigo                      
                            
 From  INTERNACAO I,                             
  Paciente P,                            
  LOCAL_ATENDIMENTO LA                            
                            
 Where  P.pac_nome  = @Pac_Nome                            
 AND  I.PAC_CODIGO  = P.PAC_CODIGO                            
 AND  I.PAC_CODIGO  <> @PAC_CODIGO                            
 AND     I.LOCATEND_CODIGO = LA.LOCATEND_CODIGO                            
 AND     LA.UNID_CODIGO    = @UNID_CODIGO                            
 and  I.inter_dtAlta  Is null                            
                            
End                            
----------------------------------------- Leito Ocupado por outra Internaca --------------------                            
If @Opcao = 12                            
Begin                            
                            
 Select L.LEI_STATUS                            
                            
 From  LEITO L, INTERNACAO I                            
                            
 WHERE  I.LOCATEND_LEITO  = @LocAtend_Leito                            
 AND  I.LEI_CODIGO            = @Lei_Codigo                            
 AND  I.inter_CODIGO          <> @Inter_Codigo                            
 AND  I.inter_dtalta          is null                
 AND  I.LOCATEND_LEITO      = L.LOCATEND_CODIGO                            
 AND  I.LEI_CODIGO            = L.LEI_CODIGO                            
-- And L.Lei_Status  = 'L'                            
End       
                
                            
                            
-- DADOS DA ALTA --------------------------------------------------------------------------------------------------------                            
if @opcao = 13                            
begin                     
                            
 select   i.inter_codigo,                               
   i.inter_dtalta,                               
   i.inter_motivo_alta,                              
   isnull(mc.motcobunid_descricao, mc_aih.motcob_descricao) as motcob_descricao,                           
   i.locatend_codigo_resp,                              
   lu.set_descricao descricao_locatend_codigo_resp,                             
   i.prof_codigo_resp,                              
   prof.prof_nome prof_nome_resp,                             
   null,                             
   null estpac_descricao_alta                             
                 
 from   internacao i                            
                             
 left join motivo_cobranca_unidade mc                            
 on  i.inter_motivo_alta = mc.motcob_codigo                            
                            
 left join motivo_cobranca_aih mc_aih                            
 on  i.inter_motivo_alta = mc_aih.motcob_codigo                            
                            
 inner join local_atendimento la                            
 on  i.locatend_codigo_resp = la.locatend_codigo                            
                            
 inner join setor s                            
 on  la.set_codigo = s.set_codigo                            
                            
 inner join vwlocal_unidade lu                            
 on  la.locatend_codigo      = lu.locatend_codigo                            
                            
 inner join profissional prof                            
 on  i.prof_codigo_resp = prof.prof_codigo                            
 and  i.locatend_codigo_resp = prof.locatend_codigo                            
                            
 where  i.inter_dtalta is not null                            
 and  i.inter_codigo = isnull(@inter_codigo,i.inter_codigo)                            
                            
end                            
                            
                            
                            
----------------------------------- PREVISAO DE INTERNACAO -------------------------------------                            
If @Opcao = 14                            
Begin                            
  Select                              
   Convert(char(10),I.inter_dtprevista,101) Data_Prevista,  -- 0                            
   Convert(char(05),I.inter_dtprevista,108) Hora_Prevista  -- 1                            
                            
  From  Internacao I                            
                            
  --Argumentos                            
  Where Convert(char(10),I.inter_dtprevista,101) = Convert(char(10), getdate() ,101)                            
  And I.Pac_Codigo  = @PAC_Codigo                            
                            
End                            
---------------------------- PROCEDIMENTOS REALIZADOS NA INTERNACAO ----------------------------                            
If @Opcao = 15                            
Begin                            
  Select PR.Proc_Codigo,                             
   P.Proc_Descricao                            
                            
  From Internacao I,                             
   Procedimentos_Realizados PR,            
   Procedimento P                            
                            
  Where I.Pac_Codigo  = @Pac_Codigo                            
  AND  I.Inter_Codigo = @Inter_Codigo                            
  AND  I.Inter_Codigo = PR.Inter_Codigo                            
  AND  PR.Proc_Codigo = P.Proc_Codigo                            
                              
  Order By P.Proc_Descricao                            
                            
                            
End                            
-- DAODS DO MEDICO AUDITOR (P/ TELA DE RESUMO DE ALTA ------------------------------------------                            
If @Opcao = 16                            
Begin                            
                            
 Select  espelho.aih_numero,                             
  espelho.aih_identificacao,                             
  espelho.aih_anterior,                             
  espelho.aih_proxima,                             
  espec.esp_codigo + ' ' + espec.esp_Descricao   ESPECIALIDADE,                             
  medico.med_nome,                     espelho.motcob_codigo + ' ' + motcob.motcob_descricao  MOTIVO,                             
  espelho.aih_uti_mesinicial,                             
  espelho.aih_uti_mesanterior,                             
  espelho.aih_uti_mesalta,                             
  espelho.aih_diaria_acomp,                      
  IntPart.Intpart_nasc_vivo,                             
  IntPart.Intpart_obito_fetal,                             
  IntPart.Intpart_obito_neoparto,                             
  IntPart.Intpar_alta_neoparto,                             
  IntPart.Intpar_transf_neoparto                              
                            
 From  internacao inter                             
  INNER JOIN espelho_aih espelho ON espelho.inter_codigo  = Inter.inter_codigo 
  INNER JOIN motivo_cobranca_aih motcob ON motcob.motcob_codigo  = espelho.motcob_codigo 
  INNER JOIN especialidade_aih espec ON espec.esp_codigo  = espelho.esp_codigo
  LEFT JOIN Internacao_parto IntPart ON intpart.inter_codigo  = espelho.inter_codigo
  INNER JOIN medico medico ON medico.prof_codigo  = espelho.prof_codigo
                            
 where  Inter.inter_codigo = @Inter_Codigo
                            
End                            
-- DAODS DO MEDICO AUDITOR (P/ TELA DE RESUMO DE ALTA ------------------------------------------                            
If @Opcao = 17                            
Begin                            
 SELECT  INTER.INTER_CODIGO COD_INTERNACAO,                            
		 VW.LOCATEND_DESCRICAO CLINICA,                            
         PROF.PROF_NOME  MEDICO,                            
         CID.CID_DESCRICAO DIAGNOSTICO,                            
         P.PROC_DESCRICAO PROCEDIMENTO,                            
         INTER.INTER_DATAINTER DT_INTERNACAO,                            
         VWL.LOCINT_DESCRICAO ENFERMARIA_LEITO,                            
         ET.ESTPAC_DESCRICAO EST_PACIENTE_INTERNACAO,                            
         INTER.INTER_DTALTA DT_ALTA,                            
         MCU.MOTCOBUNID_DESCRICAO MOTIVO_ALTA,                            
         EP.EstPac_Descricao as  EST_PACIENTE_ALTA,                          
		 CARINT.CARINT_DESCRICAO CARATER_INTERNACAO,                            
		 CID.CID_CODIGO,                            
		 P.PROC_CODIGO,
		 INTER.UNIDREF_CODIGO_DESTINO                                                           
                            
 FROM   INTERNACAO INTER                            
                            
 JOIN  VWLOCAL_UNIDADE VW	ON   VW.LOCATEND_CODIGO = INTER.LOCATEND_CODIGO                            
 JOIN  PROFISSIONAL PROF    ON   PROF.LOCATEND_CODIGO = INTER.LOCATEND_CODIGO AND PROF.PROF_CODIGO = INTER.PROF_CODIGO                            
 LEFT JOIN  PEDIDO_INTERNACAO PEDINTER ON   PEDINTER.PEDINT_SEQUENCIAL = INTER.PEDINT_SEQUENCIAL                            
 LEFT JOIN  CARATER_INTERNACAO CARINT  ON   PEDINTER.CARINT_CODIGO = CARINT.CARINT_CODIGO                            
 LEFT JOIN  CID_10 CID		ON  CID.CID_codigo = PEDINTER.cid_codigo                            
 LEFT JOIN  PROCEDIMENTO P  ON   P.proc_CODIGO = PEDINTER.proc_CODIGO                            
 JOIN VWLEITO_COMPLETO VWL  ON  VWL.locatend_CODIGO = INTER.LOCATEND_LEITO AND VWL.LEI_CODIGO = INTER.LEI_CODIGO                            
 JOIN ESTADO_PACIENTE ET    ON ET.ESTPAC_CODIGO = INTER.ESTPAC_CODIGO   
 INNER JOIN ESTADO_PACIENTE EP		  ON  (EP.EstPac_Codigo = INTER.EstPac_Codigo_Atual)                          
 LEFT JOIN MOTIVO_COBRANCA_UNIDADE MCU ON  INTER.INTER_MOTIVO_ALTA = MCU.MOTCOB_CODIGO                            
 
 WHERE   INTER.PAC_CODIGO = @Pac_Codigo
      AND (inter.inter_DeObservacao is null or inter.inter_DeObservacao = 'N')  
End                            
                            
-- 18 - VALIDA SE PODE EXCLUIR ----------------------------------------------------------------------------------                            
If @Opcao = 18                            
Begin                            
                            
  create table #temp_deleta (name sysname)              
  insert into #temp_deleta                            
 select sysobjects.name as tabela                            
  from sysobjects, syscolumns where upper(syscolumns.name) = 'inter_codigo'                            
  and sysobjects.id = syscolumns.id and sysobjects.xtype = 'U'                            
  order by sysobjects.name                              
                            
  delete from #temp_deleta                            
  where tabela in (                            
    'monitoracao_laboratorio',                            
    'movimentacao_paciente',                            
    'espelho_aih',                            
    'evolucao',                            
    'cartao_visita',                            
    'restricao_visita',                            
    'Internacao',                            
    'Resumo_Alta',                            
 'Resumo_Alta_Procedimento',              'internacao_parto',                            
    'procedimentos_realizados',                            
    'internacao_clinica_atual',                            
    'Ultimo_Censo_Hospitalar',                            
    'Censo_Hospitalar',                            
    'Log_Internacao',                            
    'internacao_pid',                            
    'pacientes_internados_central',                            
    'internacao_procedimento_cid')                            
                            
                            
  DECLARE cursor_tabela SCROLL CURSOR                            
  FOR select * from #temp_deleta                            
  DECLARE @tabela varchar(50)                            
  DECLARE @op3Sql varchar(1024)                            
                            
  OPEN cursor_TABELA                            
                            
  FETCH FIRST FROM cursor_tabela INTO @tabela                            
  create table #temp_onde (tabela varchar(50))                            
                            
  WHILE @@FETCH_STATUS = 0                            
  begin                             
   set @op3Sql = 'insert into #temp_onde select ''' + @tabela + ''' Tabela From ' + @tabela                            
     + ' where ' + @tabela + '.inter_codigo = ''' + @Inter_Codigo + ''''                            
                            
   exec(@op3Sql)                            
                               
   FETCH next FROM cursor_tabela INTO @tabela                            
  end                            
  DEALLOCATE cursor_TABELA                            
                            
  drop table #temp_deleta                            
                            
  select * from #temp_onde                            
                            
  drop table #temp_onde                            
                            
end                            
                            
-- 19 - RETORNA PENÃLTIMA INTERNAÃÃO, CASO HAJA ------------------------------------------------                  
If @Opcao = 19                            
Begin                            
                        
                 IF @INTER_CODIGO IS NULL                            
  SELECT *                             
  FROM INTERNACAO                            
  WHERE PAC_CODIGO = @PAC_CODIGO                            
  ORDER BY INTER_DATAINTER DESC                            
 ELSE     
  SELECT *                             
  FROM INTERNACAO           
  WHERE PAC_CODIGO = @PAC_CODIGO                            
    AND INTER_CODIGO <> @INTER_CODIGO                            
  ORDER BY INTER_DATAINTER DESC                            
                            
                            
END                            
                            
-- 20 - VERIFICA SE BOLETIM EM ABERTO ---------------------------------------------------------                            
If @Opcao = 20                            
Begin                            
                            
 SELECT   Case When E.emer_codigo is not null Then                             
    'BE Numero ' + IsNull(Cast(NBE.emer_numero_be As varchar), E.emer_codigo)                             
   Else                             
    Null                            
   End As Boletim                            
                             
 FROM  Emergencia E                            
                             
 inner join  unidade u                            
 on  u.unid_codigo = @Unid_Codigo                            
                             
 LEFT JOIN Atendimento_Ambulatorial AA                            
 ON  E.emer_codigo = AA.emer_codigo                            
                             
 LEFT JOIN Atendimento_Clinico AC                            
 ON  AA.atendamb_codigo = ac.atendamb_codigo                            
                             
LEFT JOIN Numero_BE NBE                            
 ON  AA.emer_codigo = NBE.emer_codigo                 
                             
 WHERE   E.pac_codigo = @pac_codigo                            
 AND  ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) )                            
                            
 and  e.emer_chegada > u.unid_Data_Versao3                            
                            
 UNION                            
                             
 SELECT   Case When PA.spa_codigo is not null Then                             
    'PA Numero ' + IsNull(Cast(NPA.spa_numero_pa As varchar), PA.spa_codigo)                             
   Else                             
    Null                            
   End As Boletim                            
                             
 FROM  Pronto_Atendimento PA                            
                            
 inner join  unidade u                            
 on  u.unid_codigo = @Unid_Codigo                            
                             
 LEFT JOIN Atendimento_Ambulatorial AA                            
 ON  PA.spa_codigo = AA.spa_codigo                            
                             
 LEFT JOIN Atendimento_Clinico AC                            
 ON  AA.atendamb_codigo = ac.atendamb_codigo                            
                             
 LEFT JOIN Numero_PA NPA                            
 ON  AA.spa_codigo = NPA.spa_codigo                            
                             
 WHERE   PA.pac_codigo = @pac_codigo                            
 AND  ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) )                            
                            
 and  pa.spa_chegada > u.unid_Data_Versao3                            
                            
End                            
                            
                             
set @Erro = @Erro + @@error                            
                            
-- 21 - VERIFICA SE BOLETIM EM ABERTO OU EXTRAVIADO ---------------------------------------------------------                            
If @Opcao = 21                            
                    
Begin                          
  if @oripac_codigo = '3'                      
    begin                          
 set @sql =   ' SELECT  TOP 1000 E.emer_codigo codigo, '
 set @sql = @sql + 'nome = case when pac.pac_nome_social is not null or e.emer_nome_social is not null then isnull(pac.pac_nome_social,e.emer_nome_social) + ''['' + isnull(pac.pac_nome, e.emer_nome) + '']'' else isnull(pac.pac_nome, e.emer_nome) end , '
 set @sql = @sql + 'convert(char(10),e.emer_chegada,103) data, '                          
 set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, E.emer_chegada , getdate()) aberto_horas '                          
                          
     set @sql = @sql + ' FROM Emergencia E '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                          
     set @sql = @sql + '   ON E.emer_codigo = AA.emer_codigo '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '              
     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                          
     set @sql = @sql + ' LEFT JOIN Numero_BE NBE '                          
     set @sql = @sql + '   ON AA.emer_codigo = NBE.emer_codigo '                          
     set @sql = @sql + ' LEFT JOIN PACIENTE PAC'                          
     set @sql = @sql + '   ON E.pac_codigo = pac.pac_codigo '                          
        if @BoletimExtraviado = 'S'                          
            set @sql = @sql + '  where (AC.atendamb_encaminhamento = ''09'') '                          
        else                          
            set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
                               
        set @SQL = @SQL + '   AND E.EMER_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                          
     set @SQL = @SQL + '   AND E.usu_codigo IS NOT NULL '                          
     set @sql = @sql + ' order by E.emer_chegada desc '                          
                          
        execute (@sql)                          
 end                          
                          
  if @oripac_codigo = '5'                          
    begin                              
     set @sql =   ' SELECT  TOP 1000 PA.spa_codigo codigo, convert(char(10),pa.spa_chegada,103) data, '  
	 set @sql = @sql + 'NOME = case when pac.pac_nome_social is not null or pa.spa_nome_social is not null then isnull(pac.pac_nome_social,pa.spa_nome_social) + ''['' + isnull(pac.pac_nome, pa.spa_nome) + '']'' else isnull(pac.pac_nome, pa.spa_nome) end , '                        
        set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, PA.spa_chegada , getdate()) aberto_horas '                          
                          
     set @sql = @sql + ' FROM Pronto_Atendimento PA '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                          
     set @sql = @sql + '   ON PA.spa_codigo = AA.spa_codigo '                          
     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '                          
     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                          
     set @sql = @sql + ' LEFT JOIN Numero_PA NPA '                          
     set @sql = @sql + '   ON AA.spa_codigo = NPA.spa_codigo '                          
  set @sql = @sql + ' LEFT JOIN PACIENTE PAC'                          
     set @sql = @sql + '   ON PA.pac_codigo = pac.pac_codigo '                          
                          
        if @BoletimExtraviado = 'S'                          
            set @sql = @sql + ' where (AC.atendamb_encaminhamento = ''09'') '                          
        else                          
            set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
                          
     set @SQL = @SQL + '   AND PA.SPA_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                          
     set @SQL = @SQL + '   AND PA.usu_codigo IS NOT NULL '                          
  set @sql = @sql + ' order by PA.spa_chegada desc '                          
                          
        execute (@sql)                          
    end                          
                    
End                          
                           
set @Erro = @Erro + @@error                          
-- // Retirado - chamado 15175 - Aline Lima - Voltar a como era antes. Sem risco em SPA. Aguardando definições.            
-- DECLARE @valor_pesquisa  varchar(80)                      
--                       
-- Begin                            
--      if @Modalidade = 0                      
--         BEGIN                      
--    if @oripac_codigo = 3                      
--     Begin                      
--      set @valor_pesquisa = 'AND (UCR.upaclaris_risco IN (''4'',''6'')) '                      
--     End                      
--    else if @oripac_codigo = 5                      
--     Begin       set @valor_pesquisa = 'AND ((UCR.upaclaris_risco IN (''2'',''3'')) OR (UPACLARIS_RISCO IS NULL)) '                      
--     End                      
--         END                      
--  else                      
--         BEGIN                      
--    if @oripac_codigo = 3                      
--     Begin                      
--      set @valor_pesquisa = 'AND (UCR.upaclaris_risco IN (''3'',''4'',''6'')) '                      
--     End                      
--    else if @oripac_codigo = 5                      
--     Begin                      
--      set @valor_pesquisa = 'AND ((UCR.upaclaris_risco IN (''2'')) OR (UCR.upaclaris_risco IS NULL)) '                      
--     End                      
--         END                      
--                       
--   set @sql = ' SELECT  TOP 1000 PA.spa_codigo codigo, pa.spa_nome nome, pa.spa_chegada data, '                            
--      set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, PA.spa_chegada , getdate()) aberto_horas '                            
--                             
--      set @sql = @sql + ' FROM Pronto_Atendimento PA '                     
--      set @sql = @sql + ' INNER JOIN UPA_ACOLHIMENTO UA '                      
--      set @sql = @sql + '   ON PA.spa_codigo = UA.spa_codigo '                        
--      set @sql = @sql + ' LEFT JOIN UPA_CLASSIFICACAO_RISCO UCR '                      
--      set @sql = @sql + '   ON UA.ACO_CODIGO = UCR.aco_codigo '                        
--      set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                            
--    set @sql = @sql + '   ON PA.spa_codigo = AA.spa_codigo '                            
--      set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '                            
--      set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                            
--      set @sql = @sql + ' LEFT JOIN Numero_PA NPA '                            
--      set @sql = @sql + '   ON AA.spa_codigo = NPA.spa_codigo '                            
--                             
--         if @BoletimExtraviado = 'S'                            
--             set @sql = @sql + ' where (AC.atendamb_encaminhamento = ''09'') AND (PA.spa_codigo = UA.spa_codigo) ' +  @valor_pesquisa                            
--                       
--                     
--             set @sql = @sql + ' WHERE ((AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null)) AND (PA.spa_codigo = UA.spa_codigo) ' +  @valor_pesquisa                        
--                             
--      set @sql = @sql + '   AND PA.SPA_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                            
--      set @sql = @sql + '   AND PA.usu_codigo IS NOT NULL '                            
--                       
--                       
--     if @oripac_codigo = 3                      
--   begin                      
--    set @sql = @sql + ' UNION '                      
--    set @sql = @sql + ' SELECT  TOP 1000 E.emer_codigo codigo, e.emer_nome nome, e.emer_chegada data, '                            
--    set @sql = @sql + '     AC.atendamb_encaminhamento, datediff(hh, E.emer_chegada , getdate()) aberto_horas '                            
--                             
--    set @sql = @sql + ' FROM Emergencia E '                          
--     set @sql = @sql + ' LEFT JOIN Atendimento_Ambulatorial AA '                            
--     set @sql = @sql + '   ON E.emer_codigo = AA.emer_codigo '                            
--     set @sql = @sql + ' LEFT JOIN Atendimento_Clinico AC '   
--     set @sql = @sql + '   ON AA.atendamb_codigo = ac.atendamb_codigo '                            
--     set @sql = @sql + ' LEFT JOIN Numero_BE NBE '                            
--     set @sql = @sql + '   ON AA.emer_codigo = NBE.emer_codigo '                            
--                       
--    if @BoletimExtraviado = 'S'                            
--     set @sql = @sql + '  where (AC.atendamb_encaminhamento = ''09'') '                       
--    else                            
--     set @sql = @sql + ' WHERE ( (AC.atendamb_codigo is null) OR (AC.atendamb_encaminhamento is Null) ) '                          
--                                   
--    set @sql = @sql + '   AND E.EMER_CODIGO like ' + '''' + substring(@unid_codigo, 3, 2) + '%' + ''''                            
--    set @sql = @sql + '   AND E.usu_codigo IS NOT NULL '                       
--                            
--         end                      
--                           
--     set @sql = @sql + ' order by data desc '                         
--                        
--  execute (@sql)                       
-- End                            
--                             
--                              
-- set @Erro = @Erro + @@error                            
--         
                            
-- Alta para uma internaÃ§Ã£o -------------------------------------------------------------------                            
If @Opcao = 22                            
  Begin                            
        
 if exists (select 1 from internacao where inter_codigo = @Inter_Codigo and inter_deobservacao = 'S')        
 begin        
         
  update internacao                            
  set inter_dtalta = @Inter_DtAlta,                            
   inter_motivo_alta = @Inter_Motivo_Alta,                            
   locatend_codigo_resp = @LocAtend_Codigo_Resp,                              
   prof_codigo_resp = @Prof_Codigo_Resp                                
  where inter_codigo = @Inter_Codigo                            
                            
  UPDATE LEITO                            
  SET lei_status = 'L'                            
  WHERE lei_status = 'O'                             
  and not exists                            
   (select 1                             
   from internacao                             
   where inter_dtalta is null                            
   and leito.locatend_codigo = internacao.locatend_LEITO                            
   and leito.lei_codigo = internacao.lei_codigo)                            
               
  Update  internacao_clinica_atual Set              
   interclinica_dtfim = @Inter_DtAlta              
  Where inter_codigo = @inter_codigo              
   and interclinica_dtfim is null              
               
  Update  MOVIMENTACAO_PACIENTE Set              
   movpac_data_saida = @Inter_DtAlta              
  Where inter_codigo = @inter_codigo              
   and movpac_data_saida is null              
              
 end                     
end                            
                
                            
-- Lista de pacientes internados sem alta em determinada clÃ­nica                            
if @opcao = 23                            
begin                            
                            
 select inter_codigo, pac_nome, inter_datainter,                            
  Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + ' ' +                             
  E.enf_codigo_local + '/' + L.lei_codigo LocInt_Descricao, Prof.Prof_Nome                            
 from internacao I                            
  INNER JOIN Paciente P on P.Pac_Codigo=I.Pac_Codigo                            
  INNER JOIN Profissional Prof on Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo                            
  LEFT JOIN Local_Atendimento LA on LA.LocAtend_Codigo=I.LocAtend_Leito                            
  LEFT JOIN Setor_Clinica SL on SL.SetCli_Codigo= LA.SetCli_Codigo                            
  LEFT JOIN Enfermaria E on E.enf_Codigo=LA.enf_codigo                  
  LEFT JOIN Leito L on I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo               
 where I.locatend_codigo_atual = @LocAtend_Codigo_Atual                            
  and inter_dtalta is null                            
  and (I.inter_DeObservacao = 'N' OR I.inter_DeObservacao is null)                            
                              
 order by SL.setCli_descricao,E.enf_codigo_local,L.lei_codigo,pac_nome                             
                            
end                            
                            
----------------------------- Selecao para Carga dos Dados da InternaÃ§Ã£o Aberta ------------------------------                            
If @Opcao = 24                            
 Begin                            
  set @sql =   ' SELECT I.inter_codigo,' -- 0                            
  set @sql = @sql + ' I.inter_datainter,' -- 1                            
  set @sql = @sql + ' I.inter_dtalta,' -- 2                            
  set @sql = @sql + ' I.inter_dtprevista,' -- 3                            
  set @sql = @sql + ' I.inter_motivo_alta,' -- 4                            
  set @sql = @sql + ' ISNULL(MC.motcobunid_descricao,MC_AIH.motcob_descricao) AS MotCob_Descricao,' -- 5                            
  set @sql = @sql + ' I.inter_tipo,' -- 6                            
  set @sql = @sql + ' I.pedint_sequencial,' -- 7                           
  set @sql = @sql + ' I.lei_codigo,' -- 8                            
  set @sql = @sql + ' I.locatend_codigo,' -- 9                            
  set @sql = @sql + ' S.SetCli_Descricao Descricao_LocAtend_Codigo,' -- 10                            
  set @sql = @sql + ' I.locatend_codigo_atual,' -- 11                            
  set @sql = @sql + ' S2.SetCli_Descricao Descricao_LocAtend_Codigo_Atual,' -- 12                            
  set @sql = @sql + ' I.locatend_leito,' -- 13                            
  set @sql = @sql + ' S3.SetCli_Descricao Descricao_LocAtend_Leito,' -- 14                            
  set @sql = @sql + ' I.pac_codigo,' -- 15                            
  set @sql = @sql + ' P.Pac_Nome, ' -- 16                            
  set @sql = @sql + ' PP.Pac_Prontuario_Numero Pac_Prontuario,' -- 17                            
  set @sql = @sql + ' P.Pac_Sexo,' -- 18                            
  set @sql = @sql + ' I.prof_codigo,' -- 19                            
  set @sql = @sql + ' Prof.Prof_Nome,' -- 20                            
  set @sql = @sql + ' I.emer_codigo,' -- 21                            
  set @sql = @sql + ' I.estpac_codigo,' -- 22                            
  set @sql = @sql + ' EP.EstPac_Descricao,' -- 23                            
  set @sql = @sql + ' I.estpac_codigo_atual,' -- 24                            
  set @sql = @sql + ' EP2.EstPac_Descricao EstPac_Descricao_Atual,' -- 25                            
  set @sql = @sql + ' Left(SL.setCli_descricao,20) + SPACE(20 - LEN(RTRIM(left(SL.setCli_descricao,20)))) + '' '' + E3.enf_codigo_local + ''/'' + L.lei_codigo LocInt_Descricao,' --26                            
  set @sql = @sql + ' I.Inter_Data_Cid,' -- 27                            
  set @sql = @sql + ' I.Inter_Data_Cid_Secundario,' -- 28                            
  set @sql = @sql + ' PID.INTER_PID_CODIGO,' -- 29                            
   set @sql = @sql + ' L.Lei_Tipo,' -- 30                               
  set @sql = @sql + ' I.Inter_hipdiag,' --31                             
  set @sql = @sql + ' I.spa_codigo,' --32                             
  set @sql = @sql + ' BE.emer_numero_be,' --32                            
  set @sql = @sql + ' PA.spa_numero_pa,' --32                            
  set @sql = @sql + ' I.inter_DeObservacao, '                            
  set @sql = @sql + ' I.prof_codigo_Resp, '    
  set @sql = @sql + ' i.inter_motivo_alta_descricao, '              
  set @sql = @sql + ' ProfResp.Prof_Nome Prof_Nome_Resp, ' -- 20
  set @sql = @sql + ' PI.leitoRegulado,'
  set @sql = @sql + ' PI.numAutorizacao ' 
                            
  set @sql = @sql +' FROM  Internacao I'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_Unidade MC'                            
  set @sql = @sql +' ON   (MC.MotCob_Codigo=I.Inter_Motivo_Alta)'                            
                            
  set @sql = @sql +' LEFT JOIN  Motivo_Cobranca_AIH MC_AIH'                            
  set @sql = @sql +' ON   (MC_AIH.MotCob_Codigo=I.Inter_Motivo_Alta)'                           
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA'                            
  set @sql = @sql +' ON   (LA.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN  Setor_Clinica S'                             
  set @sql = @sql +' ON   (S.SetCli_Codigo=LA.SetCli_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Local_Atendimento LA2'                            
  set @sql = @sql +' ON   (LA2.LocAtend_Codigo=I.LocAtend_Codigo_Atual)'                            
                            
  set @sql = @sql +' INNER JOIN Setor_Clinica S2'                            
  set @sql = @sql +' ON  (S2.SetCli_Codigo=LA2.SetCli_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Local_Atendimento LA3'                            
  set @sql = @sql +' ON  (LA3.LocAtend_Codigo=I.LocAtend_Leito)'                            
                            
  set @sql = @sql +' LEFT JOIN Enfermaria E3'                            
  set @sql = @sql +' ON  (E3.enf_Codigo=LA3.enf_codigo)'         
                            
  set @sql = @sql +' LEFT JOIN Setor_Clinica S3'        set @sql = @sql +' ON   (S3.SetCli_Codigo=LA3.SetCli_Codigo)'                            
                            
set @sql = @sql +' LEFT JOIN Setor_Clinica SL'                            
  set @sql = @sql +' ON (SL.SetCli_Codigo= La3.SetCli_Codigo)'                            
                            
  set @sql = @sql +'INNER JOIN Paciente P'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=I.Pac_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Paciente_Prontuario PP'                            
  set @sql = @sql +' ON  (P.Pac_Codigo=PP.Pac_Codigo AND PP.UNID_CODIGO = ''' + @Unid_Codigo + ''')'                              
                            
  set @sql = @sql +' INNER JOIN Profissional Prof'                            
  set @sql = @sql +' ON  (Prof.Prof_Codigo=I.Prof_Codigo and Prof.LocAtend_Codigo=I.LocAtend_Codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Profissional_Rede ProfResp'                            
  set @sql = @sql +' ON  (ProfResp.Prof_Codigo=I.prof_codigo_Resp)'                            
                              
  set @sql = @sql +' INNER JOIN Estado_Paciente EP'                            
  set @sql = @sql +' ON  (EP.EstPac_Codigo=I.EstPac_Codigo)'                            
                            
  set @sql = @sql +' INNER JOIN Estado_Paciente EP2'                            
  set @sql = @sql +' ON  (EP2.EstPac_Codigo=I.EstPac_Codigo_Atual)'                            
                            
  set @sql = @sql +' LEFT JOIN Leito L'                            
  set @sql = @sql +' ON   (I.Lei_codigo=L.lei_codigo and I.LocAtend_leito=L.locatend_codigo)'                            
                            
  set @sql = @sql +' LEFT JOIN Internacao_Pid PID'                            
  set @sql = @sql +' ON  (PID.Inter_Codigo = I.Inter_Codigo)'                            
                            
  set @sql = @sql + ' LEFT JOIN Numero_BE BE'                            
  set @sql = @sql + ' ON  I.emer_codigo = BE.emer_codigo'              
                            
  set @sql = @sql + ' LEFT JOIN Numero_PA PA'                            
  set @sql = @sql + ' ON  I.spa_codigo = PA.spa_codigo' 
  
  set @sql = @sql + ' LEFT JOIN Pedido_Internacao PI'                            
  set @sql = @sql + ' ON  PI.PedInt_Sequencial = I.PedInt_Sequencial'                             
                            
                                 
  set @sql = @sql +' WHERE i.inter_dtalta is null and '                            
                            
  if @inter_codigo is not null                      
   set @sql = @sql + ' I.Inter_Codigo  = ''' + @Inter_Codigo   + '''   and'                            
                              
  if @pedint_sequencial is not null                            
   set @sql = @sql + ' I.PedInt_Sequencial = ''' + @PedInt_Sequencial  + '''   and'               
                              
  if @Pac_Codigo is not null                            
   set @sql = @sql + ' I.Pac_Codigo  = ''' + @Pac_Codigo   + '''   and'                            
                      
                            
  set @sql = @sql  + ' LA.UNID_CODIGO  = ''' + @Unid_Codigo   + '''   and'                            
                             
  set @sql = left(@sql, len (@sql)-5)                            
                              
  set @sql = @sql + ' ORDER BY PID.Inter_Pid_codigo, I.Inter_DataInter DESC'                            
                              
  exec (@sql)                            
                            
 End                            
                      
If @Opcao = 25                      
Begin                      
                       
 Select @LocInt_Descricao = LocInt_Descricao,                      
   @LEI_TIPO = vw.Lei_Tipo,                      
   @inter_codigo = i.inter_codigo,                      
   @inter_DeObservacao = inter_DeObservacao,                    
   @LocAtend_Codigo = vw.locatend_codigo,                  
   @Inter_DtAlta = i.inter_DtAlta                  
                  
                   
 From internacao i, vwLeito vw                      
 Where i.pac_codigo = @Pac_Codigo                
 And  I.Inter_DtAlta Is NULL                                  
 And  i.locatend_leito = vw.locatend_codigo                      
 And  i.lei_codigo  = vw.lei_codigo                      
 And  vw.unid_codigo          = @unid_codigo                      
                      
 if (@inter_codigo is not null)                      
  Select  @LocInt_Descricao  LocInt_Descricao,                       
   @LEI_TIPO  Lei_Tipo,                      
   @inter_codigo  inter_codigo,                      
   ISNULL(@inter_DeObservacao, 'N')  inter_DeObservacao,           
   @locatend_codigo locatend_codigo,                     
   @Inter_DtAlta  inter_DtAlta                  
                      
End                            
       
  
IF(@OPCAO = 26)                            
BEGIN  
  
IF(@PROF_CODIGO IS NOT NULL)  
BEGIN  
  select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as PAC_NOME,                                                 
  null as localAtendimento,      
  localInternacao.set_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as PAC_PRONTUARIO,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo and ue.prof_codigo_origem = @PROF_CODIGO) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  ,CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
   CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
   CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
                   
  from                                                                            
   internacao i                                                             
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo  
   LEFT JOIN (    
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
  from vwsolicitacao_pedido vsp2     
   inner join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
  where (esl.exasollab_status  in ('LA','LI')) --and vsp2.oripac_codigo = 5     
  group by solped_CodigoOrigem    
   ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
   
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/ AND VSP.solped_TipoSolicitacao = '8'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/	and VSP.solped_TipoSolicitacao = '9'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
  where                                                                   
   i.inter_dtalta IS NULL                  
   AND profInternacao.prof_codigo = @Prof_Codigo  
   and i.locatend_codigo_atual = @LocAtend_Codigo_Atual  
   --and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo     
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)  
order by PAC_NOME  
END  
ELSE  
BEGIN  
 select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  case when p.pac_nome_social is not null then p.pac_nome_social + ' [' + p.pac_nome + ']' else p.pac_nome end as PAC_NOME,                                                 
  null as localAtendimento,      
  localInternacao.set_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as pac_prontuario,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  --case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  ,CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
   CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
   CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
  from                                                                            
   internacao i                                                             
   inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo
   LEFT JOIN (    
  SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
  from vwsolicitacao_pedido vsp2     
   left join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
  where (esl.exasollab_status  in ('LA','LI'))     
  group by solped_CodigoOrigem    
   ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
   
   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L'  AND VSP.solped_TipoSolicitacao = '8'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

   LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
		FROM VWSOLICITACAO_PEDIDO VSP
		WHERE VSP.LAUDOLIBERADO = 'L' and VSP.solped_TipoSolicitacao = '9'
		GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM      
  where                                                                   
   i.inter_dtalta IS NULL                  
   and i.locatend_codigo_atual = @LocAtend_Codigo_Atual  
   --and ('00' + SUBSTRING(I.inter_codigo , 1 , 2))  = @unid_codigo   
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)       
order by PAC_NOME  
END  
  
END                    

IF(@OPCAO = 27)
IF(@OPCAO = 27)
BEGIN

  Select                            
	I.*,
	L.set_descricao AS Descricao_LocAtend_Codigo,
	P.PROF_NOME,
	e.unid_codigo
  From Internacao   I                            
	INNER JOIN VWLOCAL_UNIDADE L ON I.LOCATEND_CODIGO = L.LOCATEND_CODIGO
	INNER JOIN PROFISSIONAL P ON (I.LOCATEND_CODIGO = P.LOCATEND_CODIGO AND I.PROF_CODIGO = P.PROF_CODIGO)
	LEFT JOIN EMERGENCIA E ON I.EMER_CODIGO = E.EMER_CODIGO
      Where   I.PAC_CODIGO = @PAC_CODIGO
      --AND EXISTS (SELECT 1 FROM SOAP WHERE INTER_CODIGO = I.INTER_CODIGO)
END   

IF(@OPCAO = 28)
BEGIN

	SELECT 
		i.inter_codigo,
		P.pac_nome,
			i.inter_dtalta
	FROM
		Internacao i inner join vwLeito l on I.LOCATEND_LEITO = L.LOCATEND_CODIGO AND I.LEI_CODIGO = L.LEI_CODIGO  
		INNER JOIN PACIENTE P ON (I.PAC_CODIGO = P.PAC_CODIGO)
	WHERE
		L.PST_CODIGO = isnull(@pstCodigo, L.PST_CODIGO)
		AND L.ENF_CODIGO_CHAVE = ISNULL(@enfCodigo, L.ENF_CODIGO)
	ORDER BY P.pac_nome

END

IF(@OPCAO = 29)
BEGIN

	SELECT 
		i.inter_codigo,
		i.inter_dtalta as DataAlta,
		P.pac_nome as Nome,
		CASE 
			WHEN P.pac_sexo = 'M' THEN 'Masculino'
			WHEN P.pac_sexo = 'F' THEN 'Feminino'
		END Sexo,
		pac_mae as NomeMae,
		pac_nascimento as DataNascimento,
		CONVERT(VARCHAR,ISNULL(((cast(DateDiff(dd,p.pac_nascimento, getdate()) as int) - (cast(DateDiff(yyyy, p.pac_nascimento, getdate()) as int) / 4)) / 365 ), p.pac_idade)) + ' Anos' as idade,
		Pac_Prontuario_Numero as Prontuario,
		DATEDIFF(day, I.inter_datainter, ISNULL(i.inter_dtalta,getdate())) as DiasInternados
	FROM
		Internacao i INNER JOIN PACIENTE P ON (I.PAC_CODIGO = P.PAC_CODIGO) 
		LEFT JOIN PACIENTE_PRONTUARIO PP ON (P.PAC_CODIGO = PP.PAC_CODIGO)
	WHERE
		p.pac_nome like @Pac_Nome + '%'
	ORDER BY P.pac_nome

END

IF(@OPCAO = 30) -- opcao em que procuramos se há internacoes a serem consolidadas (ao se criar a entidade espelho_aih)
BEGIN
	CREATE TABLE #Temp1 ( inter_codigo char(12),inter_datainter smalldatetime, inter_dtalta smalldatetime, pac_codigo char(12),proc_codigo char(10),cid_codigo char(9))

insert into #Temp1 (inter_codigo,inter_datainter,inter_dtalta,pac_codigo,proc_codigo,cid_codigo)
	select i.inter_codigo,i.inter_datainter,i.inter_dtalta,i.pac_codigo,ped.proc_codigo,ped.cid_codigo from internacao i
	inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
	where i.inter_codigo = @Inter_Codigo

	declare @dt_inter as smalldatetime
	declare @dt_inter_ultimo as smalldatetime
	DECLARE @dt_alta as smalldatetime
	
	SELECT @dt_inter = inter_datainter, @dt_inter_ultimo = inter_datainter FROM #Temp1


-- olho se há internacoes pra trás
	WHILE (@dt_inter is not null)
	BEGIN
			select top 1 @dt_inter = i.inter_datainter,@dt_alta = i.inter_dtalta,@Inter_Codigo =i.inter_codigo from internacao i --,@inter_codigo = min(i.inter_codigo)
			inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
			inner join #Temp1 on i.pac_codigo = #Temp1.pac_codigo and ped.proc_codigo = #Temp1.proc_codigo and ped.cid_codigo = #Temp1.cid_codigo
			left join espelho_aih ea on #Temp1.inter_codigo = ea.inter_codigo
			where
			i.inter_dtalta > DATEADD(HH,-@oripac_codigo,@dt_inter) and i.inter_datainter < @dt_inter and i.inter_codigo not in(select t.inter_codigo from #Temp1 as t)
			and isnull(ea.Aih_Status,'') <> '4'  and ea.aih_numero is null
			order by i.inter_datainter desc

		
		IF (@dt_inter <> @dt_inter_ultimo)
		BEGIN
			insert into #Temp1(inter_codigo,inter_datainter,inter_dtalta) select @inter_codigo,@dt_inter,@dt_alta where @inter_codigo not in(select inter_codigo from #Temp1)
			set @dt_inter_ultimo = @dt_inter
		END
		else
		begin
			set @dt_inter = null
		end
	END

	-- agora vou procurar pra frente


	DECLARE @dt_alta_ultimo as smalldatetime

	DECLARE @inter_codigo_alta as char(12)
	SELECT @dt_alta = max(inter_dtalta), @dt_inter = max(inter_datainter),  @dt_alta_ultimo = max(inter_dtalta) FROM #Temp1

	WHILE(@dt_alta is not null)
	BEGIN
			
			select @dt_alta = i.inter_dtalta,@dt_inter = i.inter_datainter,@inter_codigo = i.inter_codigo from internacao i --,@inter_codigo_alta = max(i.inter_codigo)
			inner join PEDIDO_INTERNACAO ped on i.pedint_sequencial = ped.pedint_sequencial
			inner join #Temp1 on i.pac_codigo = #Temp1.pac_codigo and ped.proc_codigo = #Temp1.proc_codigo and ped.cid_codigo = #Temp1.cid_codigo
			left join espelho_aih ea on #Temp1.inter_codigo = ea.inter_codigo
			where
			i.inter_datainter < DATEADD(HH,@oripac_codigo,@dt_alta) and i.inter_datainter > @dt_inter and i.inter_codigo not in(select t.inter_codigo from #Temp1 AS t)
			and isnull(ea.Aih_Status,'') <> '4'  and ea.aih_numero is null
			
			
			IF (@dt_alta <> @dt_alta_ultimo)
			BEGIN
				insert into #Temp1(inter_codigo,inter_dtalta,inter_datainter) select @inter_codigo,@dt_alta,@dt_inter 
				set @dt_alta_ultimo = @dt_alta
			END
			ELSE
			BEGIN
				SET @dt_alta = NULL
			END
	END



	SELECT inter_codigo,inter_datainter,inter_dtalta FROM #Temp1 order by inter_codigo
	

	DROP TABLE #Temp1



END

--retorna as ultimas internacoes para exibir na masterpage
IF(@OPCAO = 31)
BEGIN

select top 5	i.inter_codigo, 
				i.inter_datainter, 
				i.inter_dtalta, 
				(select count(1) from internacao_pep ip where i.inter_codigo = ip.inter_codigo) as total_internacao_pep
from internacao i 
where i.pac_codigo = @pac_codigo
order by i.inter_datainter desc

END

IF (@Opcao = 32)
BEGIN 
	select                          
  l.pst_codigo as POSTO,                                                                    
  null as spa_codigo,          
  null as emer_codigo,                                                                       
  p.pac_nome as PAC_NOME,                                                 
  null as localAtendimento,      
  sc.setCli_descricao as localInternacao,                                                                      
  LocInt_Descricao  as leito,                                                                      
  i.inter_codigo as inter_codigo,                                                                      
  null as profAtendimento,       
  profInternacao.prof_nome as profInternacao,                                                                      
  null as upaclaris_risco,                                                                   
  null as tipoSaidaAmbulatorio,                                                      
  null AS SITUACAO,                                                               
  null as upaatemed_encaminhamentoEixo,      
  null as upaclaris_risco,      
  null as atendimentoRealizado,                                                                    
  null as ordenacao,    
  pp.Pac_Prontuario_Numero as pac_prontuario,  
  I.inter_datainter, 
  case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo) then 'Parecer' end as Parecer,
  case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
  case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr                 
  from                                                                            
   internacao i                                                             
   inner join local_atendimento la on  la.locatend_codigo = i.locatend_leito                                                                    
   inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
   inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
   inner join paciente p on i.pac_codigo = p.pac_codigo        
   inner join vwenfermaria e on l.locatend_codigo = e.locatend_codigo and l.enf_codigo = e.enf_codigo 
   left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
   inner JOIN unidade u on u.unid_codigo = l.unid_codigo     
   inner join setor_clinica sc on la.SETCLI_CODIGO = sc.setCli_Codigo
  where                                                                   
   i.inter_dtalta IS NULL                  
   and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)       
   and exists (select 1 from Internacao_Pep ip where ip.inter_codigo = i.inter_codigo)
   and e.LOCATEND_CODIGO_CLINICA = isnull(@LocAtend_Codigo, e.LOCATEND_CODIGO_CLINICA)
   and l.enf_codigo_chave = isnull(@enfCodigo, l.enf_codigo_chave)
order by PAC_NOME 
	
END


--######################MAPA_EVOLUÇÃO###########################
IF (@Opcao = 33)
BEGIN
 	set @sql =   ' Select vwEnf.LocAtend_Descricao, '  
    set @sql = @sql +'    vwLei.LocAtend_Codigo, ' 
	set @sql = @sql +'    vwLei.Lei_Codigo, ' 
	set @sql = @sql +'    vwLei.LocInt_Descricao, '  
	set @sql = @sql +'    vwEnf.Enf_Codigo, '  
	set @sql = @sql +'    vwLei.Lei_Status, '  
	set @sql = @sql +'    I.Inter_Codigo, '  
	set @sql = @sql +'    I.Pac_Codigo, '  
	set @sql = @sql +'    case when p.pac_nome_social is null then p.pac_nome else rtrim(p.pac_nome_social) +''[''+rtrim(p.pac_nome)+'']'' end Pac_Nome, '  
	set @sql = @sql +'    PP.Pac_Prontuario_Numero Pac_Prontuario, '   
	set @sql = @sql +'    vwLei.Lei_Tipo, '   
	set @sql = @sql +'    LA.set_descricao Clinica_Paciente,'   
	set @sql = @sql +'    I.inter_DeObservacao, '  
	set @sql = @sql +'    I.inter_datainter, '
	set @sql = @sql + '   proc_tempo, '
	set @sql = @sql +'    I.emer_codigo, '
	set @sql = @sql +'    I.spa_codigo, ' 

	set @sql = @sql +' (select case when (DATEPART(HOUR, max(e.upaevo_datahora)) > 7) then ''R'''
    set @sql = @sql +'          else ''P'' end from UPA_Evolucao e, Profissional_Lotacao pl'
    set @sql = @sql +' where e.atendamb_codigo = AA.atendamb_codigo '
	set @sql = @sql +'     and CONVERT(varchar(12),e.upaevo_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101)'
	set @sql = @sql +'and pl.prof_codigo = e.prof_codigo and pl.tipprof_codigo = ''0001'' and pl.prof_ativo = ''S'') evoMedico, '
	 
	 set @sql = @sql +' (select Case when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr ' 
	 set @sql = @sql +'  left join Prescricao_Procedimento_Complementar ppc on ppc.atendamb_codigo = aa.atendamb_codigo ' 
	 set @sql = @sql +'  where  pr.usu_codigo = ppc.usu_codigo and pr.prof_codigo = pl.prof_codigo and pl.tipprof_codigo = ''0013'' and pl.prof_ativo = ''S'' '
	 set @sql = @sql +' and CONVERT(varchar(12),ppc.data, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +' having (DATEPART(HOUR, max(ppc.data)) > 7)) = 1 then ''R'' ' 
	 set @sql = @sql +' when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr '
	 set @sql = @sql +'  left join Controle_Sinais_Vitais_Balanco_Hidrico csv on (i.inter_codigo = csv.inter_codigo or i.spa_codigo = csv.spa_codigo or i.emer_codigo = csv.emer_codigo) '
	 set @sql = @sql +'  where CONVERT(varchar(12),csv.cosb_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +'  and pl.prof_codigo = csv.codProfissional and pl.tipprof_codigo = ''0013'' and pl.prof_ativo = ''S'' ' 
	 set @sql = @sql +' having (DATEPART(HOUR, max(csv.cosb_datahora)) > 7)) = 1 then ''R'' else ''P''end) evoTecEnf, '
	 	
     set @sql = @sql +' (select Case when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr ' 
	 set @sql = @sql +'  left join Prescricao_Procedimento_Complementar ppc on ppc.atendamb_codigo = aa.atendamb_codigo ' 
	 set @sql = @sql +'  where  pr.usu_codigo = ppc.usu_codigo and pr.prof_codigo = pl.prof_codigo and pl.tipprof_codigo = ''0002'' and pl.prof_ativo = ''S'' '
	 set @sql = @sql +' and CONVERT(varchar(12),ppc.data, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +' having (DATEPART(HOUR, max(ppc.data)) > 7)) = 1 then ''R'' ' 
	 set @sql = @sql +' when (select 1 from Profissional_Lotacao pl, PROFISSIONAL_REDE pr '
	 set @sql = @sql +'  left join Controle_Sinais_Vitais_Balanco_Hidrico csv on (i.inter_codigo = csv.inter_codigo or i.spa_codigo = csv.spa_codigo or i.emer_codigo = csv.emer_codigo) '
	 set @sql = @sql +'  where CONVERT(varchar(12),csv.cosb_datahora, 101) = CONVERT(varchar(12),GETDATE(), 101) '
	 set @sql = @sql +'  and pl.prof_codigo = csv.codProfissional and pl.tipprof_codigo = ''0002'' and pl.prof_ativo = ''S'' ' 
	 set @sql = @sql +' having (DATEPART(HOUR, max(csv.cosb_datahora)) > 7)) = 1 then ''R'' else ''P''end)evoEnfe,'
	 
	set @sql = @sql +' (select case when (DATEPART(HOUR, max(ss.upasersoc_DataHora)) > 7) then ''R'''
    set @sql = @sql +'          else ''P'' end from UPA_Servico_Social ss'
    set @sql = @sql +' where isnull(ss.spa_codigo, ss.emer_codigo) = isnull(aa.spa_codigo, aa.emer_codigo) '
	--set @sql = @sql +' where ss.spa_codigo = aa.spa_codigo '
	set @sql = @sql +'     AND CONVERT(varchar(12), ss.upasersoc_DataHora, 101) = CONVERT(varchar(12), GETDATE(), 101)) evoAssisSoc,' 

	set @sql = @sql +'case when aa.atendamb_datafinal is not null then ''R'' else ''P'' end evoNIR,' 

	set @sql = @sql +'   case when datediff(hour, convert(datetime, I.inter_datainter, 120),  convert(datetime, isnull(I.inter_dtalta,getdate()), 120)) > 24'
	set @sql = @sql +'		  then ''SIM'' else ''NÃO'' end obs_dia,'
	set @sql = @sql +'	 AA.atendamb_codigo, '
	set @sql = @sql +' I.locatend_codigo locatend_inter '
	set @sql = @sql +'   From vwLeito  vwLei '
	set @sql = @sql +'   inner join vwEnfermaria vwEnf on VWLEI.LocAtend_Codigo = vwEnf.LocAtend_Codigo '
	set @sql = @sql +'   left join Internacao I on I.LocAtend_Leito = vwLei.LocAtend_Codigo  '
	set @sql = @sql +'             and I.Lei_Codigo = vwLei.Lei_Codigo '
	set @sql = @sql +'			   and I.Inter_DtAlta Is Null '
    set @sql = @sql +'   left join vwLocal_unidade LA on I.locatend_Codigo_atual = la.LocAtend_Codigo '
	set @sql = @sql +'   Left join Pedido_Internacao Ped_Int on I.pedint_sequencial = Ped_int.pedint_sequencial' 
	set @sql = @sql +'   Left join procedimento proced on Ped_Int.proc_codigo = proced.proc_codigo' 
	set @sql = @sql +'   INNER JOIN PACIENTE P ON P.pac_codigo = I.pac_codigo'
	set @sql = @sql + ' LEFT JOIN Paciente_Prontuario PP ON P.Pac_Codigo = PP.Pac_Codigo '
	set @sql = @sql + ' INNER JOIN atendimento_ambulatorial AA ON ISNULL(AA.spa_codigo, AA.emer_codigo) = ISNULL(I.spa_codigo, I.emer_codigo) AND AA.pac_codigo = I.pac_codigo  AND AA.locatend_codigo = I.locatend_codigo'
set @sql = @sql +' Where 1 = 1' 
 set @sql = @sql +'And aa.atendamb_datafinal is null And vwLei.unid_codigo = ' + '''' + @Unid_Codigo + '''' 
 IF @Set_Codigo IS NOT NULL
 BEGIN
  set @sql = @sql +' And vwenf.locatend_Codigo_clinica = ' + '''' + @Set_Codigo + '''' 
 END 
 IF @LocAtend_Leito IS NOT NULL
 BEGIN
	set @sql = @sql + ' And vwLei.LocAtend_Codigo  = ' + '''' + @LocAtend_Leito + ''''
 END
 IF @Spa_Codigo IS NOT NULL
 BEGIN
   set @sql = @sql +' And I.spa_codigo = ' + '''' + @Spa_Codigo +''''
 END
 IF @Emer_Codigo IS NOT NULL
 BEGIN
	set @sql = @sql +' And I.emer_codigo =' + '''' +  @Emer_Codigo +'''' 
 END
 IF @Pac_Codigo IS NOT NULL
 BEGIN
   set @sql = @sql + ' And I.Pac_Codigo = ' + '''' + @Pac_Codigo +''''
 END
 IF @AtendAmb_Codigo IS NOT NULL
 BEGIN
  set @sql = @sql +' And AA.atendamb_codigo = ' + '''' + @AtendAmb_Codigo +''''
 END
  set @sql = @sql +'and inter_DeObservacao = ''S'' And not exists (select 1 from enfermaria e where e.enf_codigo = vwEnf.Codigo_Enfermaria and e.enf_operacional = ''N'') ' 

  set @Erro = @Erro + @@error                        
  --print(@sql)                      
  Exec(@sql) 

END

IF (@Opcao = 34)
BEGIN
	select i.inter_codigo
	from internacao i
	inner join leito l on l.lei_codigo = i.lei_codigo and l.locatend_codigo = i.locatend_leito
	where i.inter_codigo = @Inter_Codigo
	and l.lei_tipo = 2 -- tipo UTI

end

IF (@Opcao = 35)
BEGIN
	if (@PacNomeProntuario is not null or @locatend_codigo_atual is not null)
	begin 
		set @Prof_codigo = null;
	end

	select                          
		l.pst_codigo as POSTO,                                                                    
		null as spa_codigo,          
		null as emer_codigo,                                                                       
		case when p.pac_nome_social is not null 
			then p.pac_nome_social + ' [' + p.pac_nome + '] - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')
			else p.pac_nome + ' - ' + isnull(cast(dbo.CalculaIdade(getdate(), p.pac_nascimento) as varchar(20)) + ' anos', '')  + ' - ' + isnull(p.pac_sexo, '')
		end as PAC_NOME,                                                 
		null as localAtendimento,      
		localInternacao.set_descricao as localInternacao,                                                                      
		LocInt_Descricao  as leito,                                                                      
		i.inter_codigo as inter_codigo,                                                                      
		null as profAtendimento,       
		profInternacao.prof_nome as profInternacao,                                                                      
		null as upaclaris_risco,                                                                   
		null as tipoSaidaAmbulatorio,                                                      
		null AS SITUACAO,                                                               
		null as upaatemed_encaminhamentoEixo,      
		null as upaclaris_risco,      
		null as atendimentoRealizado,                                                                    
		null as ordenacao,    
		pp.Pac_Prontuario_Numero as PAC_PRONTUARIO,  
		I.inter_datainter, 
		case when exists (select 1 from UPA_Encaminhamento ue inner join Internacao_Pep ip on ip.inter_codigo = ue.inter_codigo  where ue.inter_codigo = i.inter_codigo and ue.prof_codigo_origem = isnull(@PROF_CODIGO, ue.prof_codigo_origem)) then 'Parecer' end as Parecer,
		case when exists (select 1 from pedido_exame_radiologico per inner join Internacao_Pep ip on ip.inter_codigo = per.inter_codigo where per.inter_codigo = i.inter_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
		--case when exists (select 1 from pedido_exame_radiologico per where per.atend_codigo = a.atend_codigo and per.STATUS = 'L') then 'Radiologia' end as Radiologia,
		case when exists (select 1 from Prescricao pr inner join Internacao_Pep ip on ip.inter_codigo = pr.inter_codigo  where pr.inter_codigo = i.inter_codigo and pr.idt_fechada = 'S') then 'Prescr' end as Prescr,
		CONVERT(varchar(10),LaudoLab.TotalLaudoLiberado) as TotalLaudoLiberado,
		CONVERT(varchar(10),LAUDOLAB_RADIOLOGIA.TotalLaudoLiberadoRadiologia) AS TotalLaudoLiberadoRadiologia,
		CONVERT(varchar(10),LAUDOLAB_DIAGNOSE.TotalLaudoLiberadoDiagnose) AS TotalLaudoLiberadoDiagnose   
                   
	from                                                                            
		internacao i                                                             
		inner join vwlocal_unidade localInternacao on  localInternacao.locatend_codigo = i.locatend_codigo                                                                      
		inner join vwleito l on i.locatend_leito = l.locatend_codigo and i.lei_codigo = l.lei_codigo                                               
		inner join profissional profInternacao on (profInternacao.prof_codigo = i.prof_codigo and profInternacao.locatend_codigo = i.locatend_codigo)       
		inner join paciente p on i.pac_codigo = p.pac_codigo        
		left join paciente_prontuario pp on p.pac_codigo = pp.pac_codigo 
		inner JOIN unidade u on u.unid_codigo = l.unid_codigo  
		LEFT JOIN (    
		SELECT DISTINCT solped_CodigoOrigem, count(*) as TotalLaudoLiberado     
		from vwsolicitacao_pedido vsp2     
		 inner join Exame_solicitado_laboratorio esl on esl.pedexalab_codigo = vsp2.solped_codigopedido
		where (esl.exasollab_status  in ('LA','LI')) --and vsp2.oripac_codigo = 5     
		group by solped_CodigoOrigem    
		 ) LaudoLab on i.inter_codigo = LaudoLab.solped_CodigoOrigem            
		 
		 LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoRadiologia
				FROM VWSOLICITACAO_PEDIDO VSP
				WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/ AND VSP.solped_TipoSolicitacao = '8'
				GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_RADIOLOGIA ON I.INTER_CODIGO = LAUDOLAB_RADIOLOGIA.SOLPED_CODIGOORIGEM

		 LEFT JOIN (SELECT DISTINCT SOLPED_CODIGOORIGEM, COUNT(*) AS TotalLaudoLiberadoDiagnose
				FROM VWSOLICITACAO_PEDIDO VSP
				WHERE VSP.LAUDOLIBERADO = 'L' /*AND VSP.ORIPAC_CODIGO = 5*/	and VSP.solped_TipoSolicitacao = '9'
				GROUP BY VSP.SOLPED_CODIGOORIGEM) LAUDOLAB_DIAGNOSE ON I.INTER_CODIGO = LAUDOLAB_DIAGNOSE.SOLPED_CODIGOORIGEM    
		where                                                                   
		i.inter_dtalta IS NULL                  
		AND profInternacao.prof_codigo = isnull(@Prof_Codigo, profInternacao.prof_codigo)
		and i.locatend_codigo_atual = isnull(@locatend_codigo_atual, i.locatend_codigo_atual) 
		and (@PacNomeProntuario is null
		     or p.pac_nome like '%' + @PacNomeProntuario + '%'
			 or p.pac_nome_social like '%' + @PacNomeProntuario + '%'
			 or pp.Pac_Prontuario_Numero like '%' + @PacNomeProntuario + '%')
		and (i.inter_DeObservacao = 'N' or i.inter_DeObservacao IS NULL)  
	order by PAC_NOME  
END



SET NOCOUNT OFF                            
                            
if (@ErroConcorrenciaLeito = 1)                            
       Begin          
          RAISERROR('ERRO - 9. Tabela de Internacao. O leito nÃ£o estaÂ¡ disponÃ­vel para internaÃ§Ã£o!',1,1)                            
                                       
       End                            
Else                            
 Begin                            
                            
  If (@Erro <> 0)                            
         Begin                            
            RAISERROR('ERRO - Tabela de InternaÃ§Ã£o.',1,1)                            
         End                            
                            
 End
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
	WHERE toc.CO_OCUPACAO = @cbo 
	and (tp.CO_PROCEDIMENTO like '%' + @descricao + '%' or tp.NO_PROCEDIMENTO like '%' + @descricao + '%')
end

-- TRATAMENTO DE ERRO ---------------------------------------------------------------------------------------------------
if (@@error <> 0)
begin
 	raiserror('erro - tabela de procedimentos.',1,1)
 	 
end
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
SET @versao = 'K.2020.06.10.1'

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
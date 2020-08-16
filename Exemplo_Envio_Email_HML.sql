--insert into [CheckList_Arquivos_Log]
--select @@SERVERNAME

--select * from [CheckList_Arquivos_Log]

--USE TraceDB
--create table [dbo].[CheckList_Arquivos_Log]
--(
--NomeServidor Varchar(30)
--)



/***********************************************************************************************************************************
	--	Arquivos Log - Header
	***********************************************************************************************************************************/
	DECLARE @ArquivosLog_Header VARCHAR(MAX)
	SET @ArquivosLog_Header = '<font color=black size=5>'
	SET @ArquivosLog_Header = @ArquivosLog_Header + '<br/> TOP 5 - Informações dos Arquivos de Log (LDF) <br/>' 
	SET @ArquivosLog_Header = @ArquivosLog_Header + '</font>'
	select @ArquivosLog_Header
	------------------------------------------------------------------------------------------------------------------------------------
	--	Arquivos Log - Informações
	------------------------------------------------------------------------------------------------------------------------------------
	DECLARE @ArquivosLog_Table VARCHAR(MAX)
	SET @ArquivosLog_Table = CAST( (
		SELECT td =	 	
					'</td><td>' + [NomeServidor]				+	'</td>'
	                                    
		FROM (           
				SELECT	TOP 5
						[NomeServidor]
						--ISNULL([Logical_Name], '-')							AS [Logical_Name], 
						--ISNULL(CAST([Total_Reservado]	AS VARCHAR), '-')	AS [Total_Reservado], 
						--ISNULL(CAST([Total_Utilizado]	AS VARCHAR), '-')	AS [Total_Utilizado],
						--ISNULL(CAST([Espaco_Livre (MB)]	AS VARCHAR), '-')	AS [Espaco_Livre (MB)], 
						--ISNULL(CAST([Espaco_Livre (%)]	AS VARCHAR), '-')	AS [Espaco_Livre (%)],
						--ISNULL(CAST([MaxSize]			AS VARCHAR), '-')	AS [MAXSIZE], 
						--ISNULL(CAST([Growth]			AS VARCHAR), '-')	AS [Growth]
				FROM  [dbo].[CheckList_Arquivos_Log]
				--ORDER BY	CAST(REPLACE([Total_Reservado], '-', 0) AS NUMERIC(15,2)) DESC,
							--CAST(REPLACE([Total_Utilizado], '-', 0) AS NUMERIC(15,2)) DESC
				    
			  ) AS D --ORDER BY	CAST(REPLACE([Total_Reservado], '-', 0) AS NUMERIC(15,2)) DESC,
								--CAST(REPLACE([Total_Utilizado], '-', 0) AS NUMERIC(15,2)) DESC
		  FOR XML PATH( 'tr' ), TYPE ) AS VARCHAR(MAX) 
	)   
      
    SET @ArquivosLog_Table = REPLACE( REPLACE( REPLACE(@ArquivosLog_Table, '&lt;', '<'), '&gt;', '>'), '<td>', '<td align=center>')
    
	SET @ArquivosLog_Table = 
			'<table cellspacing="2" cellpadding="5" border="3">'    
            +	'<tr>
					<th width="250" bgcolor=#0B0B61><font color=white>Nome Database</font></th>
					<th width="250" bgcolor=#0B0B61><font color=white>Nome Servidor</font></th>
					<th width="200" bgcolor=#0B0B61><font color=white>Total Reservado (MB)</font></th>
					<th width="200" bgcolor=#0B0B61><font color=white>Total Utilizado (MB)</font></th>
					<th width="150" bgcolor=#0B0B61><font color=white>Espaco_Livre (MB)</font></th>
					<th width="150" bgcolor=#0B0B61><font color=white>Espaco_Livre (%)</font></th>
					<th width="150" bgcolor=#0B0B61><font color=white>MAXSIZE</font></th>
					<th width="150" bgcolor=#0B0B61><font color=white>Growth</font></th>          
				</tr>'    
            + REPLACE( REPLACE( @ArquivosLog_Table, '&lt;', '<'), '&gt;', '>')   
            + '</table>' 
            
select @ArquivosLog_Table

/***********************************************************************************************************************************
	-- Seção em branco para dar espaço entre AS tabelas e os cabeçalhos
	***********************************************************************************************************************************/
	DECLARE @emptybody2 VARCHAR(MAX)  
	SET @emptybody2 =	''  
	SET @emptybody2 =	'<table cellpadding="5" cellspacing="5" border="0">' +              
							'<tr>
								<th width="500">               </th>
							</tr>'
							+ REPLACE( REPLACE( ISNULL(@emptybody2,''), '&lt;', '<'), '&gt;', '>')
						+ '</table>'    

------------------------------------------------------------------------------------------------------------------------------------	
	-- Seta AS Informações do E-Mail
	------------------------------------------------------------------------------------------------------------------------------------
	DECLARE	@importance AS VARCHAR(6) = 'High',			
			@Reportdate DATETIME = GETDATE(),
			@recipientsList VARCHAR(8000),
			@subject AS VARCHAR(500),
			@EmailBody VARCHAR(MAX) = ''
	
	SELECT @subject = 'CheckList Diário do Banco de Dados - ' + 'ECO SISTEMAS' + ' - ' + @@SERVERNAME	
IF ( @ArquivosLog_Table IS NOT NULL )
		SELECT @EmailBody = @EmailBody + @ArquivosLog_Header + @emptybody2 + @ArquivosLog_Table + @emptybody2	-- Arquivos Log

/***********************************************************************************************************************************
	-- Inclui uma imagem com link para o site do Fabricio Lima
	***********************************************************************************************************************************/
	select @EmailBody = @EmailBody + '<br/><br/>' +
				'<a href="http://www.fabriciolima.net" target=”_blank”> 
					<img src="http://www.fabriciolima.net/wp-content/uploads/2016/04/Logo_Fabricio-Lima_horizontal.png" height="100" width="400"/></a>'
				

	/***********************************************************************************************************************************
	-- Envia o E-Mail do CheckList do Banco de Dados
	***********************************************************************************************************************************/
	EXEC [msdb].[dbo].[sp_send_dbmail]  
			@profile_name = 'Admin',
			@recipients = 'rmarcus0301@hotmail.com',			
			@subject = @subject,
			@body = @EmailBody,
			@body_format = 'HTML',    
			@importance = @importance

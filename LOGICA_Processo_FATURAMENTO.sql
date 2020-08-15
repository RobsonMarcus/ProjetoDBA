DECLARE @DiaAtual DateTime
DECLARE @DiaInicial VARCHAR(10), @DiaFinal VARCHAR(10)
DECLARE @sql varchar(max)
DECLARE @Competencia CHAR(6)
DECLARE @unid_codigo CHAR(4)

set @DiaAtual = '2020-01-01 17:42:41.157' -- Será substituído por GETDATE()

IF (DAY(@DiaAtual) = 11)
BEGIN
	set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 10),126)
	set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
END

IF (DAY(@DiaAtual) = 21)
BEGIN
	set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 20),126)
	set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
END

IF (DAY(@DiaAtual) = 1 AND MONTH(@DiaAtual) = 3)-- PROCESSAR O MÊS DE FEVEREIRO
BEGIN
		IF (DAY(@DiaAtual - 1) = 28)
		BEGIN
			set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 28),126)
			set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
		END
		IF (DAY(@DiaAtual - 1) = 29)
		BEGIN
			set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 29),126)
			set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
		END
END

IF (DAY(@DiaAtual) = 1 AND MONTH(@DiaAtual) <> 3)-- PROCESSAR OUTROS MESES
BEGIN
		IF (DAY(@DiaAtual - 1) = 30)
		BEGIN
			set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 30),126)
			set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
		END
		IF (DAY(@DiaAtual - 1) = 31)
		BEGIN
			set @DiaInicial = CONVERT(varchar(10),(@DiaAtual - 31),126)
			set @DiaFinal = CONVERT(VARCHAR(10),@DiaAtual - 1,126)
		END
END

IF ((DAY(@DiaAtual) = 11 OR DAY(@DiaAtual) = 21) AND (MONTH(@DiaAtual) <= 9))
BEGIN
	set @Competencia = CONVERT(CHAR(4),YEAR(@DiaAtual)) + '0' + CONVERT(CHAR(2),MONTH(@DiaAtual))
END
	ELSE IF ((DAY(@DiaAtual) = 11 OR DAY(@DiaAtual) = 21) AND (MONTH(@DiaAtual) > 9))
	BEGIN
		set @Competencia = CONVERT(CHAR(4),YEAR(@DiaAtual-1)) + CONVERT(CHAR(2),MONTH(@DiaAtual-1))
	END
	ELSE IF ((DAY(@DiaAtual) = 1) AND (MONTH(@DiaAtual) between 2 AND 10))
	BEGIN
		set @Competencia = CONVERT(CHAR(4),YEAR(@DiaAtual)) + '0' + CONVERT(CHAR(2),MONTH(@DiaAtual-1))
	END
	ELSE IF ((DAY(@DiaAtual) = 1) AND (MONTH(@DiaAtual) > 10))
	BEGIN
		set @Competencia = CONVERT(CHAR(4),YEAR(@DiaAtual-1)) + CONVERT(CHAR(2),MONTH(@DiaAtual-1))
	END
	ELSE IF ((DAY(@DiaAtual) = 1) AND (MONTH(@DiaAtual) = 1))
	BEGIN
		set @Competencia = CONVERT(CHAR(4),YEAR(@DiaAtual-1)) + CONVERT(CHAR(2),MONTH(@DiaAtual-1))
	END

IF (DAY(@DiaAtual) = 11 OR DAY(@DiaAtual) = 21 OR DAY(@DiaAtual) = 1)
BEGIN
	select @unid_codigo = unid_codigo from unidade
	select @DiaAtual as 'Data Atual', @DiaInicial as 'Primeiro dia', @DiaFinal as 'Último Dia', @Competencia as 'Mês'
END


--CREATE TABLE ##TempBPAI
--(
--Descricao varchar(100),
--Total varchar(20)
--)

--INSERT INTO ##TempBPAI
--VALUES('oripac_descricao','Total')


--set @sql = 'ksp_bpa_individualizado_importacao_OP1 '''+ @Competencia +''',''' + @unid_codigo +''','''+ @DiaInicial + +''','''+ @DiaFinal +''','''+ '0001'',1'
--INSERT INTO ##TempBPAI
--EXEC (@sql)
--select * from ##TempBPAI
--EXEC ksp_bpa_individualizado_importacao_OP1 '202004','@unid_codigo','2020-04-01','2020-04-30','0001',1
--EXEC ksp_bpa_individualizado_importacao_OP1 '201901','0007','2019-01-01','2019-01-10','0001',1

-- DROP TABLE ##TempBPAI



DECLARE @inicio int, @fim int
DECLARE @tabNM VARCHAR(200), @tabNMN VARCHAR(200)
DECLARE @cmdSQL VARCHAR(max)

CREATE TABLE ##tempTBNM (iD  int IDENTITY (1,1), nome varchar(200) )

INSERT INTO ##tempTBNM (nome)
select name from sys.tables

set @inicio=2
select @fim = MAX(iD) FROM ##tempTBNM

while @inicio <= @fim
BEGIN
	select @tabNM = '['+ nome + ']' FROM ##tempTBNM where iD = @inicio
	select @tabNMN = REPLACE(REPLACE( nome, LEFT(nome,2),''),RIGHT(nome,4),'') FROM ##tempTBNM where iD = @inicio
	--PRINT (@tabNMN)
	set @cmdSQL = 'EXEC sp_rename ''' + @tabNM + ''',' + @tabNMN
	EXEC (@cmdSQL)
	set @inicio = @inicio + 1
END

--EXEC sp_rename '[tbAldeia202005.csv]', 'Aldeia202005';  
--select REPLACE(REPLACE('[tbArea202005.csv]',LEFT('[tbArea202005.csv]',3),''),RIGHT('[tbArea202005.csv]',5),'')

DROP TABLE ##tempTBNM
--SELECT REPLACE(REPLACE('[tbTurnoAtendimento202005.csv]',LEFT('[tbTurnoAtendimento202005.csv]',3),''),RIGHT('[tbTurnoAtendimento202005.csv]',5),'');
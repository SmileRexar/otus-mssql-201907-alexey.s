USE DB04

DECLARE @Count int = 10000
DECLARE @n int

SET @n = 1

WHILE @n < @Count
BEGIN	
	INSERT INTO Table1(Name, Col)
	VALUES ('name' + cast(@n as nvarchar(10)), @n);

	WAITFOR DELAY '00:00:05';	
	SET @n = @n + 1
END;
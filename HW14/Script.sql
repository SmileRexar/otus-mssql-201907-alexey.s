/*
В Visual studio сделать проект class library именем ExternalSQLHelper
Добавить статический метод валидации ip адреса
Подгрузить в sql сборку и вызвать функцию

*/


--код для валидации в обертке c#
--ExternalSQLHelper сборка и проект. SQLHelper класс в сборке

    public class SQLHelper
    {
        public static bool IsIpAdpress(SqlString strName)
        {
            Match match = Regex.Match(strName.ToString(), @"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}");
            if (match.Success)
                return true;

            return false;
        }
    }

---------------------
/*
Далее подгрузка в sql и вызов
1) Включение в sql поддержки clr
use WideWorldImporters
*/
-- Включаем CLR
exec sp_configure 'show advanced options', 1;
go
reconfigure;
go
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
go
reconfigure;
go
/*
2) Подключение сборки
*/
use WideWorldImporters
CREATE ASSEMBLY ExternalSQLHelper
FROM 'C:\Source\otus-mssql-201907-alexey.s\HW14\ExternalSQLHelper.dll'
WITH PERMISSION_SET = SAFE;  

-- DROP ASSEMBLY DemoAssembly

-- Посмотреть подключенные сборки (SSMS: <DB> -> Programmability -> Assemblies)
SELECT * FROM sys.assemblies
GO

-сборка.класс.функция
-- Подключить функцию из dll
CREATE FUNCTION dbo.fn_IsIpAdpress(@RawStr nvarchar(max))  
RETURNS bit
AS EXTERNAL NAME [ExternalSQLHelper].SQLHelper.IsIpAdpress;  
GO 

/*
3) Вызов функции из сборки
*/
declare @str nvarchar(100)
set @str  = '10.1.1.4'
--вернулся 1 
select dbo.fn_IsIpAdpress(@str)
set @str  = '10a.1.1.4'
select dbo.fn_IsIpAdpress(@str)
--вернулся 0



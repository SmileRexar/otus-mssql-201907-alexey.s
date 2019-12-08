
--резервное копирование системных баз данных
BACKUP DATABASE master
TO DISK = 'C:\D\Backups\master.bak'
 
BACKUP DATABASE model
TO DISK = 'C:\D\Backups\model.bak'
 
BACKUP DATABASE msdb
TO DISK = 'C:\D\Backups\msdb.bak'



--создание резервной копии
BACKUP DATABASE sbase
TO DISK = 'C:\D\Backups\sbase.bak'



--Добавим данные в созданную базу
use sbase;
--Создадим таблицу test
 CREATE TABLE test(
  id INT,
  name VARCHAR(MAX)
  );
--Добавим данные
INSERT INTO test (id,name)
VALUES
  (1, 'Student Ivan'),
  (2, 'Student Sasha'),
  (3, 'Student Masha'); 



  --Делаем полный бэкап
 BACKUP DATABASE sbase
TO DISK = 'C:\D\Backups\sbase_dif2'--полный бекап для последующего разностного восстановления
 
--Добавим еще данные
INSERT INTO test (id,name)
VALUES
  (4, 'Student Misha'),
  (5, 'Student Sasha'),
  (6, 'Student Misha'),
  (7, 'Student Sasha'),
  (8, 'Student Misha'),
  (9, 'Student Sasha'),
  (10, 'Student Masha'); 
  BACKUP DATABASE sbase
TO DISK = 'C:\D\Backups\sbase_dif3'
WITH DIFFERENTIAL;



--Резервное копирование журнала транзакций
BACKUP LOG sbase
TO DISK = 'C:\D\Backups\sbase_tran.bak'


--Резервное копирование файловых групп 
BACKUP DATABASE sbase
FILEGROUP = 'PRIMARY'
TO DISK = 'C:\D\Backups\primary.bak'



--Восстановление из полной резервной копии
USE master
GO
ALTER DATABASE sbase
SET SINGLE_USER -- если не сделать, то будет предупреждение, можно закрыть все подключения к бд
--Откатывает все неподтвержденные транзакции в базе данных.
WITH ROLLBACK IMMEDIATE
GO
RESTORE DATABASE sbase
FROM DISK='C:\D\Backups\sbase.bak'
WITH REPLACE
GO

--Восстановление из разностной резервной копии
USE master
ALTER DATABASE sbase
--переводим в SINGLE_USER
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
--откатываем неподтвержденные
RESTORE DATABASE sbase
FROM  DISK = 'C:\D\Backups\sbase_dif2' --полная копия
WITH  FILE = 1,  NORECOVERY, REPLACE
USE master
RESTORE DATABASE sbase
FROM  DISK = 'C:\D\Backups\sbase_dif3' --разностная копия
WITH  FILE = 1,  RECOVERY
GO


--Восстановление журнала транзакций.
USE master
ALTER DATABASE sbase
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
RESTORE DATABASE sbase
FROM  DISK = 'C:\D\Backups\sbase.bak'-- из полной копии
WITH  FILE = 1,  NORECOVERY, REPLACE
RESTORE DATABASE sbase
FROM  DISK = 'C:\D\Backups\sbase_dif2'-- из разностного
WITH  FILE = 1,  NORECOVERY, REPLACE
RESTORE LOG sbase
FROM  DISK = 'C:\D\Backups\sbase_tran.bak'-- из журнала
WITH  FILE = 1,  RECOVERY



--Пример восстановления до определенного времени
/*go
restore log [databasename] from disk='путь к файлу бэкапа лога' with norecovery,stopat='нужно время'
*/


--Восстановление файловых групп
ALTER DATABASE sbase
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
RESTORE DATABASE sbase FILEGROUP = 'PRIMARY'
FROM DISK = 'C:\D\Backups\primary.bak'
WITH PARTIAL, RECOVERY, REPLACE


--посмотреть файл бэкапа
RESTORE VERIFYONLY FROM DISK = 'C:\D\Backups\sbase.bak' WITH STATS

--посмотреть заголовок файла бэкапа
RESTORE HEADERONLY   
FROM DISK = N'C:\D\Backups\sbase.bak'   
WITH NOUNLOAD; 



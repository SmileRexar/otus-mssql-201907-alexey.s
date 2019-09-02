/*
1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
2. удалите 1 запись из Customers, которая была вами добавлена
3. изменить одну запись, из добавленных через UPDATE
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
INSERT INTO [Sales].[Customers] 
		([CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy])
SELECT top(5) [CustomerName]+'_TestName_'
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy] 
FROM [WideWorldImporters].[Sales].[Customers]
ORDER BY  CustomerID DESC


--2. удалите 1 запись из Customers, которая была вами добавлена
DELETE TOP(1) FROM [Sales].[Customers]
WHERE [CustomerName] LIKE '%_TestName_%'


--3. изменить одну запись, из добавленных через UPDATE
UPDATE TOP(1)  [Sales].[Customers]
SET [CustomerName] =REPLACE([CustomerName],'_TestName_','_NewName_') 
WHERE [CustomerName] LIKE '%_TestName_%'


--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
/*
Алгоритм:
Сделать дубликат таблицы  People. 
Добавить 1 запись в дубликат.
Написать Merge который добавит отсутствующую запись из дубликата 
*/
DROP TABLE IF EXISTS DublicateTPeople;

--сделать копию таблицы [People]
SELECT *
INTO DublicateTPeople
FROM [Application].[People]
ORDER BY [PersonID] DESC;


SELECT *
FROM DublicateTPeople;
INSERT INTO DublicateTPeople
(  
[PersonID],
[FullName], 
[PreferredName], 
[SearchName],
[IsPermittedToLogon],
[LogonName],
[IsExternalLogonProvider],
[HashedPassword],
[IsSystemUser],
[IsEmployee],
[IsSalesperson],
[UserPreferences],
[PhoneNumber],
[FaxNumber],
[EmailAddress],
[Photo],
[CustomFields],
[OtherLanguages],
[LastEditedBy],
[ValidFrom],
[ValidTo]
)
VALUES 
((SELECT MAX([PersonID]+1) FROM DublicateTPeople), 'MERGE 1' , 'MERGING ', 'MERGE 1', 1, 'NOLOGIN',0,NULL,0,1,1,'', NULL,NULL,'',NULL,NULL,'["EN","RU"]',1,GETDATE(), GETDATE()),
((SELECT MAX([PersonID]+2) FROM DublicateTPeople), 'MERGE 2' , 'MERGING ', 'MERGE 2', 1, 'NOLOGIN',0,NULL,0,1,1,'', NULL,NULL,'',NULL,NULL,'["EN","RU"]',1,GETDATE(), GETDATE()),
((SELECT MAX([PersonID]+3) FROM DublicateTPeople), 'MERGE 3' , 'MERGING ', 'MERGE 3', 1, 'NOLOGIN',0,NULL,0,1,1,'', NULL,NULL,'',NULL,NULL,'["EN","RU"]',1,GETDATE(), GETDATE()),
((SELECT MAX([PersonID]+4) FROM DublicateTPeople), 'MERGE 4' , 'MERGING ', 'MERGE 4', 1, 'NOLOGIN',0,NULL,0,1,1,'', NULL,NULL,'',NULL,NULL,'["EN","RU"]',1,GETDATE(), GETDATE()),
((SELECT MAX([PersonID]+5) FROM DublicateTPeople), 'MERGE 5' , 'MERGING ', 'MERGE 5', 1, 'NOLOGIN',0,NULL,0,1,1,'', NULL,NULL,'',NULL,NULL,'["EN","RU"]',1,GETDATE(), GETDATE())
   
SELECT TOP (5) *
FROM DublicateTPeople
ORDER BY PersonID DESC;

MERGE [Application].[People] AS TARGET
using (
SELECT 
DP.[PersonID],
DP.[FullName], 
DP.[PreferredName], 
DP.[SearchName],
DP.[IsPermittedToLogon],
DP.[LogonName],
DP.[IsExternalLogonProvider],
DP.[HashedPassword],
DP.[IsSystemUser],
DP.[IsEmployee],
DP.[IsSalesperson],
DP.[UserPreferences],
DP.[PhoneNumber],
DP.[FaxNumber],
DP.[EmailAddress],
DP.[Photo],
DP.[CustomFields],
DP.[LastEditedBy]
FROM DublicateTPeople dP
LEFT JOIN 
[Application].[People] P
ON DP.[PersonID]=P.[PersonID]
WHERE P.[PersonID] IS NULL
) AS source  (
[PersonID],
[FullName], 
[PreferredName], 
[SearchName],
[IsPermittedToLogon],
[LogonName],
[IsExternalLogonProvider],
[HashedPassword],
[IsSystemUser],
[IsEmployee],
[IsSalesperson],
[UserPreferences],
[PhoneNumber],
[FaxNumber],
[EmailAddress],
[Photo],
[CustomFields],
[LastEditedBy])
ON TARGET.[PersonID]=source.[PersonID]
WHEN MATCHED 
THEN UPDATE SET [PhoneNumber] = source.[PhoneNumber] +'11111111',
				[FaxNumber]=source.[FaxNumber]+ '222222222'
WHEN NOT MATCHED 
THEN INSERT (
[PersonID],
[FullName], 
[PreferredName],
[IsPermittedToLogon],
[LogonName],
[IsExternalLogonProvider],
[HashedPassword],
[IsSystemUser],
[IsEmployee],
[IsSalesperson],
[UserPreferences],
[PhoneNumber],
[FaxNumber],
[EmailAddress],
[Photo],
[CustomFields],
[LastEditedBy])
VALUES (
SOURCE.[PersonID],
SOURCE.[FullName], 
SOURCE.[PreferredName],
SOURCE.[IsPermittedToLogon],
SOURCE.[LogonName],
SOURCE.[IsExternalLogonProvider],
SOURCE.[HashedPassword],
SOURCE.[IsSystemUser],
SOURCE.[IsEmployee],
SOURCE.[IsSalesperson],
SOURCE.[UserPreferences],
SOURCE.[PhoneNumber],
SOURCE.[FaxNumber],
SOURCE.[EmailAddress],
SOURCE.[Photo],
SOURCE.[CustomFields],
SOURCE.[LastEditedBy]
)
OUTPUT deleted.*, $action, inserted.*;








--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert

-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  


--exec master..xp_cmdshell 'bcp "WorldWideImporters.Sales.InvoiceLines" out  "E:\SQL WWI\InvoiceLines.txt" -c -t, -S localhost\MSSQLServer01 -T -b 10000'

declare @pathFile nvarchar = 'C:\Source\Cities.txt'

declare @sqlCommand varchar(4000) =
'
bcp "[WideWorldImporters].[Application].[Cities]" out  "C:\Source\Cities.txt" -T -w -t"@dfgjydfgmy" -S ' + /*@@servername*/+'WIN-SUP3IDH6D6P
'
print @sqlCommand
exec master..xp_cmdshell @sqlCommand


use WideWorldImporters
go
CREATE TABLE [Cities_demo](
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_Application_Cities] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [USERDATA] TEXTIMAGE_ON [USERDATA]
 


	BULK INSERT [WideWorldImporters].[dbo].[Cities_demo]
				   FROM "C:\Source\Cities.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@dfgjydfgmy',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );




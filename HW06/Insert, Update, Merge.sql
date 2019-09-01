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
drop table if exists DublicateTPeople
SELECT * into DublicateTPeople
FROM [Application].[People]
ORDER BY  [PersonID] DESC

select * from DublicateTPeople

INSERT INTO [Application].[People] 
		(
			[FullName]
           ,[PreferredName]
           ,[IsPermittedToLogon]
           ,[LogonName]
           ,[IsExternalLogonProvider]
           ,[HashedPassword]
           ,[IsSystemUser]
           ,[IsEmployee]
           ,[IsSalesperson]
           ,[UserPreferences]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[EmailAddress]
           ,[Photo]
           ,[CustomFields]
           ,[LastEditedBy])
SELECT top(1) 
		[FullName]+'_Тестирование Merge_'
			,[PreferredName]
           ,[IsPermittedToLogon]
           ,[LogonName]
           ,[IsExternalLogonProvider]
           ,[HashedPassword]
           ,[IsSystemUser]
           ,[IsEmployee]
           ,[IsSalesperson]
           ,[UserPreferences]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[EmailAddress]
           ,[Photo]
           ,[CustomFields]
           ,[LastEditedBy]
FROM [Application].[People]
ORDER BY  PersonID DESC






--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert





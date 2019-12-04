/*
1) Для запроса выборки зарплат c тегами по фильтру
*/
SELECT [SalaryID]
 ,[Salary]
 ,[UsersFilterID]
  FROM [VacancyAgregator].[rpt].[SalaryList]
  where Salary>180000
  
-- Теперь в запросе в запросе будет index seek
CREATE NONCLUSTERED INDEX IX_SalaryList_Salary_UsersFilterID ON [rpt].[SalaryList]
(
	[Salary] ASC
)
INCLUDE([UsersFilterID])  


/*
2) Запрос поиск вакансий с определнной датой заполнения/сканирования 
*/
SELECT [DateActual]
      ,[DateRecord]
FROM [VacancyAgregator].[rpt].[SalaryList]
where  [DateActual] = '2019-10-27'

-- Теперь в запросе Index seek
CREATE NONCLUSTERED INDEX IX_SalaryList_DateActual_DateRecord ON [rpt].[SalaryList]
(
	DateActual ASC,
	DateRecord ASC
)

/*
3) Для всех таблиц заданы кластерные индексы в PK
*/
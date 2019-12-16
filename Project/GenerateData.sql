USE [VacancyAgregator]
GO
SET IDENTITY_INSERT [App].[Programs] ON 
GO
INSERT [App].[Programs] ([ProgramID], [ProgramName], [isActive]) VALUES (1, N'InsertToDB', 1)
GO
INSERT [App].[Programs] ([ProgramID], [ProgramName], [isActive]) VALUES (2, N'AdapterHeadHunter', 1)
GO
INSERT [App].[Programs] ([ProgramID], [ProgramName], [isActive]) VALUES (3, N'OLAPService', 1)
GO
SET IDENTITY_INSERT [App].[Programs] OFF
GO
SET IDENTITY_INSERT [Operation].[Permissions] ON 
GO
INSERT [Operation].[Permissions] ([PermissionID], [PermissionName], [ProgramsID], [RecordItem]) VALUES (1, N'Root', 1, CAST(N'2019-10-24T18:00:19.1100000+00:00' AS DateTimeOffset))
GO
SET IDENTITY_INSERT [Operation].[Permissions] OFF
GO
SET IDENTITY_INSERT [App].[Providers] ON 
GO
INSERT [App].[Providers] ([ProviderID], [Name], [URLAdress], [remark], [RecordDate]) VALUES (1, N'HeadHunter', N'https://hh.ru', NULL, CAST(N'2019-10-24T17:35:12.5200000+00:00' AS DateTimeOffset))
GO
SET IDENTITY_INSERT [App].[Providers] OFF
GO
SET IDENTITY_INSERT [Operation].[Users] ON 
GO
INSERT [Operation].[Users] ([UserID], [OperatorName], [PermissionID], [Email]) VALUES (1, N'Alexey', 1, NULL)
GO
INSERT [Operation].[Users] ([UserID], [OperatorName], [PermissionID], [Email]) VALUES (7, N'vlad', 1, NULL)
GO
SET IDENTITY_INSERT [Operation].[Users] OFF
GO
SET IDENTITY_INSERT [Operation].[UsersFilter] ON 
GO
INSERT [Operation].[UsersFilter] ([UsersFilterID], [UsersID], [ProviderID], [SearchFilter], [isEnabled]) VALUES (1, 1, 1, N'c#', 1)
GO
INSERT [Operation].[UsersFilter] ([UsersFilterID], [UsersID], [ProviderID], [SearchFilter], [isEnabled]) VALUES (2, 1, 1, N'devops', 1)
GO
INSERT [Operation].[UsersFilter] ([UsersFilterID], [UsersID], [ProviderID], [SearchFilter], [isEnabled]) VALUES (19, 7, 1, N'c++', 1)
GO
INSERT [Operation].[UsersFilter] ([UsersFilterID], [UsersID], [ProviderID], [SearchFilter], [isEnabled]) VALUES (20, 1, 1, N'qa тестировщик', 1)
GO
INSERT [Operation].[UsersFilter] ([UsersFilterID], [UsersID], [ProviderID], [SearchFilter], [isEnabled]) VALUES (21, 1, 1, N'sql разработчик', 1)
GO
SET IDENTITY_INSERT [Operation].[UsersFilter] OFF
GO
SET IDENTITY_INSERT [rpt].[SalaryList] ON 
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (55, 1, 1, 297, NULL, 0, CAST(130000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:24:10.0966667+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (56, 1, 1, 159, NULL, 0, CAST(180000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:24:24.5533333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (57, 1, 1, 74, NULL, 0, CAST(240000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:24:32.2166667+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (58, 1, 1, 27, NULL, 0, CAST(295000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:24:41.0666667+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (63, 1, 1, 72, NULL, 0, CAST(220000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:48:22.1200000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (64, 1, 1, 19, NULL, 0, CAST(285000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:48:30.9766667+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (65, 1, 1, 11, NULL, 0, CAST(350000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:48:43.1233333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (66, 1, 1, 17, NULL, 0, CAST(205000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:49:58.6200000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (67, 1, 1, 33, NULL, 0, CAST(165000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:50:12.2233333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (68, 1, 1, 11, NULL, 0, CAST(245000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:50:25.3200000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (69, 1, 1, 108, NULL, 0, CAST(245000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:05.4900000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (70, 1, 1, 44, NULL, 0, CAST(275000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:14.4433333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (71, 1, 1, 34, NULL, 0, CAST(300000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:24.7300000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (72, 1, 1, 14, NULL, 0, CAST(330000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:33.4733333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (73, 1, 1, 7, NULL, 0, CAST(355000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:44.7700000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (74, 1, 1, 6, NULL, 0, CAST(385000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:51:54.9133333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (75, 19, 1, 230, NULL, 0, CAST(145000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:52:27.8700000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (76, 19, 1, 108, NULL, 0, CAST(205000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:52:38.2500000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (77, 19, 1, 39, NULL, 0, CAST(270000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:52:46.3400000+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (78, 19, 1, 17, NULL, 0, CAST(335000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T18:52:54.1133333+00:00' AS DateTimeOffset))
GO
INSERT [rpt].[SalaryList] ([SalaryID], [UsersFilterID], [ProviderID], [CountOfVacancy], [CountVacanciesWithSum], [TotalVacancies], [Salary], [DateActual], [DateRecord]) VALUES (79, 1, 1, 7, NULL, 0, CAST(355000 AS Decimal(18, 0)), CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T19:53:50.3933333+00:00' AS DateTimeOffset))
GO
SET IDENTITY_INSERT [rpt].[SalaryList] OFF
GO
SET IDENTITY_INSERT [dbo].[ErrorLog] ON 
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (4, CAST(N'2019-10-26T16:31:41.380' AS DateTime), N'dbo', 50000, 16, 1, N'App.AddSalary', 25, N'Error raised in TRY block.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (5, CAST(N'2019-10-26T16:32:22.473' AS DateTime), N'dbo', 50000, 16, 1, N'App.AddSalary', 25, N'Error raised in TRY block.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (6, CAST(N'2019-10-26T16:33:55.570' AS DateTime), N'dbo', 50000, 16, 1, N'App.AddSalary', 25, N'Error raised in TRY block.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (7, CAST(N'2019-10-26T17:03:25.427' AS DateTime), N'dbo', 50000, 16, 1, N'App.AddSalary', 25, N'Error raised in TRY block.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (8, CAST(N'2019-10-26T17:05:16.860' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSalary', 65, N'Cannot insert the value NULL into column ''VacancyID'', table ''VacancyAgregator.rpt.SalaryList''; column does not allow nulls. INSERT fails.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (9, CAST(N'2019-10-26T17:05:29.600' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSalary', 65, N'Cannot insert the value NULL into column ''VacancyID'', table ''VacancyAgregator.rpt.SalaryList''; column does not allow nulls. INSERT fails.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (10, CAST(N'2019-10-26T17:05:51.263' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSalary', 65, N'Cannot insert the value NULL into column ''VacancyID'', table ''VacancyAgregator.rpt.SalaryList''; column does not allow nulls. INSERT fails.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (11, CAST(N'2019-10-26T17:19:30.977' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSearchWord', 32, N'Cannot insert the value NULL into column ''UsersID'', table ''VacancyAgregator.Operation.UsersFilter''; column does not allow nulls. INSERT fails.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (12, CAST(N'2019-10-26T17:21:06.463' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSearchWord', 32, N'Cannot insert the value NULL into column ''ProviderID'', table ''VacancyAgregator.Operation.UsersFilter''; column does not allow nulls. INSERT fails.')
GO
INSERT [dbo].[ErrorLog] ([ErrorLogID], [ErrorTime], [UserName], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage]) VALUES (1004, CAST(N'2019-12-15T21:00:24.010' AS DateTime), N'dbo', 515, 16, 2, N'App.AddSalary', 70, N'Cannot insert the value NULL into column ''VacancyID'', table ''VacancyAgregator.rpt.SalaryList''; column does not allow nulls. INSERT fails.')
GO
SET IDENTITY_INSERT [dbo].[ErrorLog] OFF
GO

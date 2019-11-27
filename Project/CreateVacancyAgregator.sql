USE [master]
GO
/****** Object:  Database [VacancyAgregator]    Script Date: 11/27/2019 5:39:49 AM ******/
CREATE DATABASE [VacancyAgregator]
GO
USE [VacancyAgregator]
GO
/****** Object:  User [lex]    Script Date: 11/27/2019 5:39:50 AM
CREATE USER [lex] FOR LOGIN [lex] WITH DEFAULT_SCHEMA=[dbo]
GO
 ******/
 
/****** Object:  Schema [App]    Script Date: 11/27/2019 5:39:50 AM ******/
CREATE SCHEMA [App]
GO
/****** Object:  Schema [Operation]    Script Date: 11/27/2019 5:39:50 AM ******/
CREATE SCHEMA [Operation]
GO
/****** Object:  Schema [rpt]    Script Date: 11/27/2019 5:39:50 AM ******/
CREATE SCHEMA [rpt]
GO
/****** Object:  Table [App].[Programs]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [App].[Programs](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramName] [nvarchar](150) NOT NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_Programs] PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [App].[Providers]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [App].[Providers](
	[ProviderID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[URLAdress] [nvarchar](50) NOT NULL,
	[remark] [nvarchar](10) NULL,
	[RecordDate] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_ImporterProvider] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [App].[Settings]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [App].[Settings](
	[SettingsID] [int] NOT NULL,
	[SettingsName] [nvarchar](150) NULL,
	[ProgramsID] [int] NULL,
	[Config] [xml] NULL,
	[RecordItem] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Adapter]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adapter](
	[AdapterID] [int] IDENTITY(1,1) NOT NULL,
	[AdapterName] [nvarchar](150) NOT NULL,
	[Info] [nvarchar](150) NULL,
 CONSTRAINT [PK_Adapter] PRIMARY KEY CLUSTERED 
(
	[AdapterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NULL,
	[UserName] [sysname] NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
	[JobID] [int] IDENTITY(1,1) NOT NULL,
	[JobName] [nvarchar](150) NOT NULL,
	[Schedule
ID] [int] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[Schedule
ID] [int] NOT NULL,
	[ScheduleName] [nvarchar](150) NOT NULL,
	[Date_Start] [datetimeoffset](7) NOT NULL,
	[Status] [int] NOT NULL,
	[UsersID] [bigint] NOT NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[Schedule
ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operation].[PermissionRules]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[PermissionRules](
	[PermissionRulesID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionRulesName] [nvarchar](150) NULL,
	[isEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_PermissionRules] PRIMARY KEY CLUSTERED 
(
	[PermissionRulesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operation].[Permissions]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[Permissions](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionName] [nvarchar](150) NULL,
	[PermissionRulesID] [int] NULL,
	[ProgramsID] [int] NOT NULL,
	[RecordItem] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED 
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operation].[Users]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[Users](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[OperatorName] [nvarchar](100) NOT NULL,
	[PermissionID] [int] NOT NULL,
	[Email] [nvarchar](150) NULL,
 CONSTRAINT [PK_Operators] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operation].[UsersFilter]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operation].[UsersFilter](
	[UsersFilterID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsersID] [bigint] NOT NULL,
	[ProviderID] [int] NOT NULL,
	[SearchFilter] [nvarchar](150) NULL,
	[isEnabled] [bit] NULL,
 CONSTRAINT [PK_ProvidersFilter] PRIMARY KEY CLUSTERED 
(
	[UsersFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [rpt].[SalaryList]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[SalaryList](
	[SalaryID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsersFilterID] [bigint] NOT NULL,
	[ProviderID] [int] NOT NULL,
	[VacancyID] [bigint] NOT NULL,
	[CountOfVacancy] [int] NOT NULL,
	[CountVacanciesWithSum] [int] NULL,
	[TotalVacancies] [int] NOT NULL,
	[Salary] [decimal](18, 0) NOT NULL,
	[DateActual] [date] NOT NULL,
	[DateRecord] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_SalaryList] PRIMARY KEY CLUSTERED 
(
	[SalaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [rpt].[VacancyLines]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[VacancyLines](
	[VacancyID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsersFilterID] [bigint] NULL,
	[DateRecord] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_VacancyList] PRIMARY KEY CLUSTERED 
(
	[VacancyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [App].[Providers] ADD  CONSTRAINT [DF_ImporterProvider_RecordDate]  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [App].[Settings] ADD  CONSTRAINT [DF_Settings_RecordItem]  DEFAULT (getdate()) FOR [RecordItem]
GO
ALTER TABLE [Operation].[Permissions] ADD  CONSTRAINT [DF_Permissions_RecordItem]  DEFAULT (getdate()) FOR [RecordItem]
GO
ALTER TABLE [rpt].[SalaryList] ADD  CONSTRAINT [DF_SalaryList_TotalVacancies]  DEFAULT ((0)) FOR [TotalVacancies]
GO
ALTER TABLE [rpt].[SalaryList] ADD  CONSTRAINT [DF_SalaryList_DateInseted]  DEFAULT (getdate()) FOR [DateRecord]
GO
ALTER TABLE [rpt].[VacancyLines] ADD  CONSTRAINT [DF_VacancyList_DateInserted]  DEFAULT (getdate()) FOR [DateRecord]
GO
ALTER TABLE [App].[Settings]  WITH CHECK ADD  CONSTRAINT [FK_Settings_Programs] FOREIGN KEY([ProgramsID])
REFERENCES [App].[Programs] ([ProgramID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [App].[Settings] CHECK CONSTRAINT [FK_Settings_Programs]
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Schedule] FOREIGN KEY([Schedule
ID])
REFERENCES [dbo].[Schedule] ([Schedule
ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Jobs] CHECK CONSTRAINT [FK_Jobs_Schedule]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_Users] FOREIGN KEY([UsersID])
REFERENCES [Operation].[Users] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_Users]
GO
ALTER TABLE [Operation].[Permissions]  WITH CHECK ADD  CONSTRAINT [FK_Permissions_Programs] FOREIGN KEY([ProgramsID])
REFERENCES [App].[Programs] ([ProgramID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Operation].[Permissions] CHECK CONSTRAINT [FK_Permissions_Programs]
GO
ALTER TABLE [Operation].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Permissions] FOREIGN KEY([PermissionID])
REFERENCES [Operation].[Permissions] ([PermissionID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Operation].[Users] CHECK CONSTRAINT [FK_Operators_Permissions]
GO
ALTER TABLE [Operation].[UsersFilter]  WITH CHECK ADD  CONSTRAINT [FK_ProvidersFilter_Provider] FOREIGN KEY([ProviderID])
REFERENCES [App].[Providers] ([ProviderID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Operation].[UsersFilter] CHECK CONSTRAINT [FK_ProvidersFilter_Provider]
GO
ALTER TABLE [Operation].[UsersFilter]  WITH CHECK ADD  CONSTRAINT [FK_UsersFilter_Users] FOREIGN KEY([UsersID])
REFERENCES [Operation].[Users] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Operation].[UsersFilter] CHECK CONSTRAINT [FK_UsersFilter_Users]
GO
ALTER TABLE [rpt].[SalaryList]  WITH CHECK ADD  CONSTRAINT [FK_SalaryList_ImporterProvider] FOREIGN KEY([ProviderID])
REFERENCES [App].[Providers] ([ProviderID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [rpt].[SalaryList] CHECK CONSTRAINT [FK_SalaryList_ImporterProvider]
GO
ALTER TABLE [rpt].[SalaryList]  WITH CHECK ADD  CONSTRAINT [FK_SalaryList_UsersFilter] FOREIGN KEY([UsersFilterID])
REFERENCES [Operation].[UsersFilter] ([UsersFilterID])
GO
ALTER TABLE [rpt].[SalaryList] CHECK CONSTRAINT [FK_SalaryList_UsersFilter]
GO
ALTER TABLE [rpt].[SalaryList]  WITH CHECK ADD  CONSTRAINT [FK_SalaryList_VacancyList] FOREIGN KEY([VacancyID])
REFERENCES [rpt].[VacancyLines] ([VacancyID])
GO
ALTER TABLE [rpt].[SalaryList] CHECK CONSTRAINT [FK_SalaryList_VacancyList]
GO
ALTER TABLE [rpt].[VacancyLines]  WITH CHECK ADD  CONSTRAINT [FK_VacancyLines_UsersFilter] FOREIGN KEY([UsersFilterID])
REFERENCES [Operation].[UsersFilter] ([UsersFilterID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [rpt].[VacancyLines] CHECK CONSTRAINT [FK_VacancyLines_UsersFilter]
GO
/****** Object:  StoredProcedure [App].[AddProvider]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Alexey X>
-- Create date: <2019-10-25>
-- Description:	<Функция добавления провайдера>
-- =============================================
CREATE PROCEDURE [App].[AddProvider]

@RoleName nvarchar(150),
@UserName nvarchar(150)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM sys.database_role_members AS drm
                            INNER JOIN sys.database_principals AS dpr
                            ON drm.role_principal_id = dpr.principal_id
                            AND dpr.type = N'R'
                            INNER JOIN sys.database_principals AS dpu
                            ON drm.member_principal_id = dpu.principal_id
                            AND dpu.type = N'S'
                            WHERE dpr.name = @RoleName
                            AND dpu.name = @UserName)
    BEGIN
        BEGIN TRY

            DECLARE @SQL nvarchar(max) = N'ALTER ROLE ' + QUOTENAME(@RoleName)
                                       + N' ADD MEMBER ' + QUOTENAME(@UserName) + N';'
            EXECUTE (@SQL);

            PRINT N'User ' + @UserName + N' added to role ' + @RoleName;

        END TRY
        BEGIN CATCH
            PRINT N'Unable to add user ' + @UserName + N' to role ' + @RoleName;
            THROW;
        END CATCH;
    END;
END;
GO
/****** Object:  StoredProcedure [App].[AddSalary]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create Procedure AddSalary
-- Create Procedure AddSalary
-- Alter Procedure AddSalary
-- =============================================
-- Author:		<Alexey X>
-- Create date: <2019-10-25>
-- Description:	<Функция добавления вакансий и зарплат>
-- =============================================
CREATE PROCEDURE [App].[AddSalary]

@ProviderName nvarchar(150),
@UserName nvarchar(150),
@SearchFilter nvarchar(150),
@CountOfVacan int,
@TotalOfVacan int,
@Salary int

WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 
    BEGIN
        BEGIN TRY

				/*
		RAISERROR ('Error raised in TRY block.', -- Message text.
               16, -- Severity.
               1 -- State.
               );
			   */

			/*№1 Если не указан провайден - выход   */
			IF NOT EXISTS (SELECT 1 FROM app.Providers WHERE Name=@ProviderName) 
			begin
			print 'Provider not found ';
			return;
			end

			/*№2 Если не указан пользователь - выход   */
			IF NOT EXISTS (SELECT 1 FROM Operation.Users WHERE OperatorName=@UserName) 
			begin
			print 'User not found ';
			return;
			end

			/*№3 Если ключового слова нет - создать в  ProvidersFilter*/
			IF NOT EXISTS (SELECT 1 FROM Operation.UsersFilter WHERE SearchFilter=@SearchFilter) 
			begin
			print 'SearchFilter not found ';
			return;
			end

			/*№4 Создать привязку вакансий к провайдеру */

			INSERT rpt.VacancyLines (UsersFilterID)
			SELECT p.UsersFilterID  FROM 
			Operation.UsersFilter p
			left join 
			rpt.VacancyLines v
			on p.UsersFilterID=v.UsersFilterID
			where v.UsersFilterID is null

			/*№5 Создать зарплату для вакансии */

			/*Перепишем позже*/

			insert rpt.SalaryList(UsersFilterID, ProviderID,VacancyID,CountOfVacancy,TotalVacancies, Salary,DateActual)
			values(
			( 
						SELECT  top(1) Operation.UsersFilter.UsersFilterID
						FROM  Operation.Users INNER JOIN
                        Operation.UsersFilter ON Operation.Users.UserID = Operation.UsersFilter.UsersID
						where OperatorName=@UserName
			
			),
			(select top(1) ProviderID from App.Providers where Name=@ProviderName),
			(
			SELECT rpt.VacancyLines.VacancyID
			FROM Operation.Users
				 INNER JOIN Operation.UsersFilter ON Operation.Users.UserID = Operation.UsersFilter.UsersID
				 INNER JOIN rpt.VacancyLines ON Operation.UsersFilter.UsersFilterID = rpt.VacancyLines.UsersFilterID
			WHERE(Operation.Users.OperatorName = @UserName)
				 AND (Operation.UsersFilter.SearchFilter = @SearchFilter)
			),
			@CountOfVacan,
			@TotalOfVacan,
			@Salary,
			getdate()
			)

			print 'operation success'

        END TRY
        BEGIN CATCH
		  EXECUTE [dbo].[uspLogError];
             THROW;	  
        END CATCH;
    END;
END;
GO
/****** Object:  StoredProcedure [App].[AddUser]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Alter Procedure AddSalary
-- =============================================
-- Author:		<Alexey X>
-- Create date: <2019-10-25>
-- Description:	<Функция добавления вакансий и зарплат>
-- =============================================
CREATE PROCEDURE [App].[AddUser]

@ProviderName nvarchar(150),
@UserName nvarchar(150),
@SearchFilter nvarchar(150)

WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 
    BEGIN
        BEGIN TRY

				/*
		RAISERROR ('Error raised in TRY block.', -- Message text.
               16, -- Severity.
               1 -- State.
               );
			   */

			    /*Добавляем пользователя при отсутствии*/
			IF NOT EXISTS (SELECT 1 FROM Operation.Users WHERE OperatorName=@UserName) 
			begin
			insert Operation.Users(OperatorName,PermissionID,Email) values(@UserName, 1, null )
			print 'User created ';
			end



			   /*Добавялем атрибуты поиска*/
			insert Operation.UsersFilter(UsersID, ProviderID,SearchFilter,isEnabled)
			values(
			(select top(1) UserID from Operation.Users where OperatorName=@UserName),
			(select top(1) ProviderID from App.Providers where Name=@ProviderName),
			@SearchFilter,
			'True'
			)

			print 'operation success'

        END TRY
        BEGIN CATCH
		  EXECUTE [dbo].[uspLogError];
             THROW;	  
        END CATCH;
    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[uspGetSalaryByProvider]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create Procedure uspGetSalaryByProvider
-- Alter Procedure uspGetSalaryByProvider


CREATE PROCEDURE [dbo].[uspGetSalaryByProvider]
AS
BEGIN
    SET NOCOUNT ON;
SELECT        Operation.Users.OperatorName, Operation.Users.UserID, rpt.SalaryList.SalaryID, rpt.SalaryList.UsersFilterID, rpt.SalaryList.ProviderID, rpt.SalaryList.VacancyID, rpt.SalaryList.CountOfVacancy, 
                         rpt.SalaryList.CountVacanciesWithSum, rpt.SalaryList.TotalVacancies, rpt.SalaryList.Salary, rpt.SalaryList.DateActual, rpt.SalaryList.DateRecord, Operation.UsersFilter.SearchFilter
FROM            Operation.UsersFilter INNER JOIN
                         Operation.Users ON Operation.UsersFilter.UsersID = Operation.Users.UserID INNER JOIN
                         rpt.SalaryList INNER JOIN
                         App.Providers ON rpt.SalaryList.ProviderID = App.Providers.ProviderID ON Operation.UsersFilter.UsersFilterID = rpt.SalaryList.UsersFilterID
ORDER BY App.Providers.ProviderID


END;
GO
/****** Object:  StoredProcedure [dbo].[uspLogError]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- uspLogError logs error information in the ErrorLog table about the 
-- error that caused execution to jump to the CATCH block of a 
-- TRY...CATCH construct. This should be executed from within the scope 
-- of a CATCH block otherwise it will return without inserting error 
-- information. 
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT -- contains the ErrorLogID of the row inserted
AS                               -- by uspLogError in the ErrorLog table
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END

        INSERT [dbo].[ErrorLog] 
            (
			[ErrorTime],
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
			GETDATE(),
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SET @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[uspPrintError]    Script Date: 11/27/2019 5:39:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- uspPrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logs error information in the ErrorLog table about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without inserting error information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspLogError'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Output parameter for the stored procedure uspLogError. Contains the ErrorLogID value corresponding to the row inserted by uspLogError in the ErrorLog table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspLogError', @level2type=N'PARAMETER',@level2name=N'@ErrorLogID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prints error information about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without printing any error information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspPrintError'
GO
USE [master]
GO
ALTER DATABASE [VacancyAgregator] SET  READ_WRITE 
GO

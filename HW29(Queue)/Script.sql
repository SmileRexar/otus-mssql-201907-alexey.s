/*
Создание очереди
Создание очереди в БД для фоновой обработки задачи в БД.
Критерии оценки: 3 задание сдано и есть замечания, которые студент не хочет исправлять
+1 балл замечаний нет либо они исправлены
+1 балл ДЗ сдано в течение 1 недели с момента занятия
Рекомендуем сдать до: 27.11.2019
*/

--Создание базы для тестов сервис брокера
USE [master]
GO

CREATE DATABASE [QueueExample]
GO

ALTER DATABASE [QueueExample] SET  ENABLE_BROKER 
GO

--создание типов сообщения
USE QueueExample

-- For Request
CREATE MESSAGE TYPE
[//QueueExample/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;

-- For Reply
CREATE MESSAGE TYPE
[//QueueExample/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 
GO

CREATE CONTRACT [//QueueExample/SB/Contract]
      ([//QueueExample/SB/RequestMessage]
         SENT BY INITIATOR,
       [//QueueExample/SB/ReplyMessage]
         SENT BY TARGET
      );
GO


CREATE QUEUE TargetQueueWWI;

CREATE SERVICE [//QueueExample/SB/TargetService]
       ON QUEUE TargetQueueWWI
       ([//QueueExample/SB/Contract]);
GO

CREATE QUEUE InitiatorQueueWWI;

CREATE SERVICE [//QueueExample/SB/InitiatorService]
       ON QUEUE InitiatorQueueWWI
       ([//QueueExample/SB/Contract]);
GO

USE [QueueExample]
GO

CREATE PROCEDURE [dbo].[SendNewPacked]
AS
BEGIN
	SET NOCOUNT ON;

    --Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
	DECLARE @RequestMessage NVARCHAR(4000);
	
	BEGIN TRAN 

	--Prepare the Message
	SELECT @RequestMessage = 
	( SELECT name, dbid, filename  
		FROM master.dbo.sysdatabases
		FOR XML AUTO); 
	
	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//QueueExample/SB/InitiatorService]
	TO SERVICE
	'//QueueExample/SB/TargetService'
	ON CONTRACT
	[//QueueExample/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//QueueExample/SB/RequestMessage]
	(@RequestMessage);
	--SELECT @RequestMessage AS SentRequestMessage;
	COMMIT TRAN 
END
GO

CREATE PROCEDURE [dbo].[GetPackedFromQueque]
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER,
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@ReplyMessageName Sysname,
			@xml XML; 
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message;

	SET @xml = CAST(@Message AS XML);
	select @xml
 
	SELECT @Message AS ReceivedRequestMessage, @MessageType; 

	-- Confirm and Send a reply
	IF @MessageType=N'//QueueExample/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//QueueExample/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; 

	COMMIT TRAN;
END
GO

CREATE PROCEDURE [dbo].[ConfirmPacked]
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER,
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM dbo.InitiatorQueueWWI; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; 
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; 

	COMMIT TRAN; 
END
GO

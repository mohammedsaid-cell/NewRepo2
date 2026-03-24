USE [master]
GO
/****** Object:  Database [DWQueue]    Script Date: 24/03/2026 11:19:20 ص ******/
CREATE DATABASE [DWQueue]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DWQueue', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DWQueue.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DWQueue_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DWQueue_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DWQueue] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DWQueue].[dbo].[sp_fulltext_dataabase] @action = 'enable'
end
GO
ALTER DATABASE [DWQueue] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DWQueue] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DWQueue] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DWQueue] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DWQueue] SET ARITHABORT OFF 
GO
ALTER DATABASE [DWQueue] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DWQueue] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DWQueue] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DWQueue] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DWQueue] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DWQueue] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DWQueue] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DWQueue] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DWQueue] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DWQueue] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DWQueue] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DWQueue] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DWQueue] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DWQueue] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DWQueue] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DWQueue] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DWQueue] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DWQueue] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DWQueue] SET  MULTI_USER 
GO
ALTER DATABASE [DWQueue] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DWQueue] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DWQueue] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DWQueue] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DWQueue] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DWQueue] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DWQueue', N'ON'
GO
ALTER DATABASE [DWQueue] SET QUERY_STORE = ON
GO
ALTER DATABASE [DWQueue] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DWQueue]
GO
/****** Object:  User [NT AUTHORITY\NETWORK SERVICE]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE USER [NT AUTHORITY\NETWORK SERVICE] FOR LOGIN [NT AUTHORITY\NETWORK SERVICE] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NT AUTHORITY\NETWORK SERVICE]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NT AUTHORITY\NETWORK SERVICE]
GO
/****** Object:  Table [dbo].[MessageQueue]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageQueue](
	[MessageId] [uniqueidentifier] NOT NULL,
	[QueueName] [nvarchar](255) NOT NULL,
	[Priority] [int] NOT NULL,
	[DateActive] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[MessageBody] [varbinary](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Sequence] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestId] [uniqueidentifier] NULL,
	[DateRequestExpires] [datetime] NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[LookupField1] [nvarchar](255) NULL,
	[LookupField2] [nvarchar](255) NULL,
	[LookupField3] [nvarchar](255) NULL,
 CONSTRAINT [PK_MessageQueue] PRIMARY KEY CLUSTERED 
(
	[MessageId] ASC,
	[QueueName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MessageQueue] SET (LOCK_ESCALATION = DISABLE)
GO
/****** Object:  Table [dbo].[TransactionState]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionState](
	[OperationId] [uniqueidentifier] NOT NULL,
	[TransactionId] [uniqueidentifier] NOT NULL,
	[State] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TransactionState] SET (LOCK_ESCALATION = DISABLE)
GO
/****** Object:  Index [PK_TransactionState]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE UNIQUE CLUSTERED INDEX [PK_TransactionState] ON [dbo].[TransactionState]
(
	[OperationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ActiveMessages]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue]
(
	[QueueName] ASC,
	[IsActive] ASC,
	[Priority] ASC,
	[DateActive] ASC,
	[Sequence] ASC,
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MessageQueue_LookupField1]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField1] ON [dbo].[MessageQueue]
(
	[LookupField1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MessageQueue_LookupField2]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField2] ON [dbo].[MessageQueue]
(
	[LookupField2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MessageQueue_LookupField3]    Script Date: 24/03/2026 11:19:21 ص ******/
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField3] ON [dbo].[MessageQueue]
(
	[LookupField3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[MessageQueueActivate]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[MessageQueueActivate]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	--Delete selected messages to complete the dequeue operation.
	UPDATE MessageQueue  WITH (READCOMMITTED, READPAST)
	SET IsActive = 1
	WHERE QueueName = @QueueName 
	AND	MessageId = @MessageId
END

GO
/****** Object:  StoredProcedure [dbo].[MessageQueueDeleteMessage]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[MessageQueueDeleteMessage]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	DELETE FROM MessageQueue 
	WHERE MessageId = @MessageId AND QueueName = @QueueName;
END
GO
/****** Object:  StoredProcedure [dbo].[MessageQueueDequeueAccept]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[MessageQueueDequeueAccept]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	--Delete selected messages to complete the dequeue operation.
	DELETE FROM MessageQueue 
	WHERE QueueName = @QueueName 
	AND	 MessageId = @MessageId;
END

GO
/****** Object:  StoredProcedure [dbo].[MessageQueueEnqueue]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[MessageQueueEnqueue]
	@MessageId uniqueidentifier,
	@QueueName nvarchar(255),
	@DateActive datetime,
	@IsActive bit,
	@Priority int,
	@MessageBody varbinary(MAX),
	@CorrelationId uniqueidentifier = NULL,
	@LookupField1 nvarchar(255) = NULL,
	@LookupField2 nvarchar(255) = NULL,
	@LookupField3 nvarchar(255) = NULL
AS
BEGIN
	
	INSERT INTO MessageQueue(MessageId, 
		QueueName, 
		DateActive, 
		IsActive,
		Priority, 
		MessageBody, 
		CorrelationId,
		LookupField1,
		LookupField2,
		LookupField3,
		DateCreated)
	VALUES (@MessageId, 
		@QueueName, 
		@DateActive, 
		@IsActive,
		@Priority, 
		@MessageBody, 
		@CorrelationId,
		@LookupField1,
		@LookupField2,
		@LookupField3,
		GetDate());
END

GO
/****** Object:  StoredProcedure [dbo].[MessageQueuePeek]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[MessageQueuePeek]
	@QueueName nvarchar(255),
	@BatchSize int = 1,
	@DateActive datetime = NULL,
	@CorrelationId uniqueidentifier = NULL,
	@LookupField1 nvarchar(255) = NULL,
	@LookupField2 nvarchar(255) = NULL,
	@LookupField3 nvarchar(255) = NULL,
	@IsActive int = 1
AS
BEGIN
	SELECT TOP(@BatchSize) *
	FROM MessageQueue WITH (NOLOCK)
	WHERE QueueName = @QueueName
		AND (@IsActive IS NULL OR IsActive = @IsActive)
		AND DateActive <= @DateActive
		AND (@LookupField1 IS NULL OR LookupField1 LIKE @LookupField1)
		AND (@LookupField2 IS NULL OR LookupField2 LIKE @LookupField2)
		AND (@LookupField3 IS NULL OR LookupField3 LIKE @LookupField3)
	ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
END

GO
/****** Object:  StoredProcedure [dbo].[MessageQueueReceive]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MessageQueueReceive]
	        @QueueName nvarchar(255),
	        @DateActive datetime = NULL,
	        @IsActive int = 1
        AS
        BEGIN
	        --select a batch of messages based on priority and activation date
	        --messages are selected with priority 0 being the highest and only
	        --if activation date is at @DateActive or before that.

	        SELECT TOP(1) mq1.*
	        FROM MessageQueue mq1 WITH (READCOMMITTED, READPAST, FORCESEEK INDEX(IX_ActiveMessages))
	        WHERE
		        mq1.MessageId NOT IN
		        (
			        SELECT ts1.OperationId
			        FROM TransactionState ts1
			        LEFT JOIN TransactionState ts2 WITH (READCOMMITTED, READPAST) ON ts1.OperationId = ts2.OperationId
			        WHERE ts2.OperationId is null
		        )
	        AND QueueName = @QueueName
	        AND (@IsActive IS NULL OR IsActive = @IsActive)
	        AND (@DateActive IS NULL OR DateActive <= @DateActive)
	        AND Priority >= 0
            --Below ORDER BY removed as it not necessary due to IX_ActiveMessages index.  Including the
            --ORDER BY below could cause the optimizer to generate a plan that will sort and spill to tempdb
            --which is undesirable due to the performance implications.  See vsts# 2013514 for details.
	        --ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
	        option ( fast 1 )
        END
GO
/****** Object:  StoredProcedure [dbo].[MessageQueueUpdate]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
   MessageQueueUpdate is used by the rollback manager to update the state of the message queue.
   This occurs when a undo operation fails and the priority, body, or active state needs to be updated.
*/
CREATE PROCEDURE [dbo].[MessageQueueUpdate]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier,
	@DateActive datetime,
	@Priority int = NULL,
	@IsActive int = 1,
	@MessageBody varbinary(MAX)
AS
BEGIN
	--Update selected messages to be dequeued again.
	UPDATE MessageQueue WITH  (READCOMMITTED, READPAST)
	SET DateActive = @DateActive, 
		Priority = ISNULL(@Priority, Priority),
		MessageBody = ISNULL(@MessageBody, MessageBody),
		IsActive = ISNULL(@IsActive, IsActive)
	WHERE QueueName = @QueueName 
	AND	 MessageId = @MessageId;
END
GO
/****** Object:  StoredProcedure [dbo].[TransactionStateCreate]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
	TransactionStateCreate creates a transactional record in the transaction state table.
	The state of the transaction is then maintained by TransactionStateUpdate.
*/
CREATE PROCEDURE [dbo].[TransactionStateCreate]
	@TransactionId uniqueidentifier,
	@OperationId uniqueidentifier,
	@State int
AS
BEGIN
	INSERT INTO TransactionState (TransactionId, OperationId, State, DateCreated)
	VALUES(@TransactionId, @OperationId, @State, GetDate())
END
GO
/****** Object:  StoredProcedure [dbo].[TransactionStateDelete]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[TransactionStateDelete]
	@OperationId uniqueidentifier
AS
BEGIN
	DELETE FROM TransactionState
	WHERE OperationId = @OperationId;
END

GO
/****** Object:  StoredProcedure [dbo].[TransactionStateGetCommittedOperationState]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[TransactionStateGetCommittedOperationState]
	@OperationId uniqueidentifier
AS
BEGIN
	SELECT [State] FROM TransactionState WITH (READCOMMITTED,READPAST)
	WHERE OperationId = @OperationId;
END

GO
/****** Object:  StoredProcedure [dbo].[TransactionStateGetCurrentOperationState]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[TransactionStateGetCurrentOperationState]
	@OperationId uniqueidentifier
AS
BEGIN
	SELECT [State] FROM TransactionState with (READUNCOMMITTED)
	WHERE OperationId = @OperationId;
END

GO
/****** Object:  StoredProcedure [dbo].[TransactionStateUpdate]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
	TransactionStateUpdate maintains the state of the transactional operation.  The state
	is initially created by TransactionStateCreate.
*/
CREATE PROCEDURE [dbo].[TransactionStateUpdate]
	@TransactionId uniqueidentifier,
	@OperationId uniqueidentifier,
	@State int
AS
BEGIN
	UPDATE TransactionState 
	SET [State] = @State
	WHERE [OperationId] = @OperationId
END
GO
/****** Object:  StoredProcedure [dbo].[UpgradeDWQueue]    Script Date: 24/03/2026 11:19:21 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpgradeDWQueue]
	-- Parameters
	@StoredVer INT, -- Currently stored version in the version_history table
	@DatabaseName NVARCHAR(MAX) -- Name of the Database to modify.  It is important to keep this generic to accommodate both setup and Backup/Restore
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Constants

		-- Work Variables
		DECLARE @ErrorMessage NVARCHAR(MAX);
		DECLARE @Sql NVARCHAR(MAX);

		------------------------------------------------------------------------------------------
		-- Validate All Input Parameters
		------------------------------------------------------------------------------------------

		-- Make sure the database exists.
		PRINT N'Database name is: ' + @DatabaseName;

		if DB_ID(@DatabaseName) IS NULL
		BEGIN
			SET @ErrorMessage = N'ERROR: Database "' + @DatabaseName + N'" does not exist.'
			raiserror(@ErrorMessage,16,1);
			return -1;
		END

		-- IMPORTANT!!! Specify the changes required for execution during Madison upgrade.
		-- For every NON-rerunnable change that is added, the @CurrentScriptVer value
		-- needs to match the version number specified in the condition below.
	    -- This will guarantee that the change is only executed once.
		--
		-- For example, if making a change after version 1 is released, roll @CurrentScriptVer = 2 and
		-- ADD another IF block, "IF (@StoredVer < 2) BEGIN ... statements ... END"
		-- On error, use raiserror to return the error back to the caller.
		IF (@StoredVer < 1)
		BEGIN
			-- Specify NON-rerunnable changes here; i.e. the changes that should be executed only once,
			-- when this particular version of the script is executed
			-- or when a fresh install is being executed
			PRINT N'Current Version:' + CAST(@StoredVer AS nvarchar(10))

		END

		IF (@StoredVer < 61)
		BEGIN
			--Cleanup leaked records.  This will clean up records due to vsts 903400.  There should always be a MessageQueue record
			--if a record exists in TransactionState.
			DELETE FROM DWQueue.dbo.TransactionState where OperationId NOT IN ( SELECT MessageId from DWQueue.dbo.MessageQueue );

			--Prepare the TransactionState table for the new one state per operation model
			DELETE ts FROM DWQueue.dbo.TransactionState as ts
			WHERE [State] < (SELECT MAX([State])
				FROM DWQueue.dbo.TransactionState WHERE [OperationId] = ts.OperationId AND [TransactionId] = ts.TransactionId )

			--Remove the RollbackExecuted messages.  We no longer use this state, and since a state of 4 means that the
			--rollback operation has been executed, we do not need to invoke it.
			DELETE FROM DWQueue.dbo.MessageQueue WHERE [MessageId] IN ( SELECT [OperationId] FROM [dbo].[TransactionState] WHERE [State] = 4 );
			DELETE FROM DWQueue.dbo.TransactionState where State = 4;

			--Optimistically re-enable de-activated rollback messages.  These messages where likely de-activate due to rollover timeout,
			--and will likely complete on re-activation.
			UPDATE DWQueue.dbo.MessageQueue SET IsActive = 1 where IsActive = 0;

			--Not needed: DROP INDEX [IX_TransactionState_OperationId] on [dbo].[TransactionState];

			ALTER INDEX [PK_MessageQueue] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField1] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField2] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField3] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );

			CREATE UNIQUE INDEX [IX_ActiveMessages] on [dbo].[MessageQueue]
			(
				[QueueName] ASC,
				[DateActive] ASC,
				[IsActive] ASC,
				[Priority] ASC,
				[Sequence] ASC,
				[MessageId] ASC
			) WITH (STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY];

			DROP INDEX [IX_TransactionState_OperationId] ON [dbo].[TransactionState]

			CREATE UNIQUE CLUSTERED INDEX [PK_TransactionState] ON [dbo].[TransactionState] ( [OperationId] ASC ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]

			--Disable lock escalation
			ALTER TABLE [dbo].[MessageQueue] set ( LOCK_ESCALATION = disable )
			ALTER TABLE [dbo].[TransactionState] set ( LOCK_ESCALATION = disable )
		END

		-- Specify rerunnable changes here;
		-- these changes can be executed during every upgrade, not just once
	END

    IF (@StoredVer < 86)
    BEGIN
        DROP INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue];

        -- Recreate the index based on the sorting criteria for dequeuing a request.
        CREATE UNIQUE NONCLUSTERED INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue]
        (
	        [QueueName] ASC,
	        [IsActive] ASC,
	        [Priority] ASC,
	        [DateActive] ASC,
	        [Sequence] ASC,
	        [MessageId] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY];

        -- Remove the order by clause that is implicitly enforced by the above index.
        -- This is necessary, as the optimizer cannot create an optimal plan for a stored procedure with
        -- passed parameters.  It will choose a plan that will sort the table, and spill to tempdb, causing
        -- excessive IO to tempdb.
        EXEC sp_executesql N'ALTER PROCEDURE [dbo].[MessageQueueReceive]
	        @QueueName nvarchar(255),
	        @DateActive datetime = NULL,
	        @IsActive int = 1
        AS
        BEGIN
	        --select a batch of messages based on priority and activation date
	        --messages are selected with priority 0 being the highest and only
	        --if activation date is at @DateActive or before that.

	        SELECT TOP(1) mq1.*
	        FROM MessageQueue mq1 WITH (READCOMMITTED, READPAST, FORCESEEK INDEX(IX_ActiveMessages))
	        WHERE
		        mq1.MessageId NOT IN
		        (
			        SELECT ts1.OperationId
			        FROM TransactionState ts1
			        LEFT JOIN TransactionState ts2 WITH (READCOMMITTED, READPAST) ON ts1.OperationId = ts2.OperationId
			        WHERE ts2.OperationId is null
		        )
	        AND QueueName = @QueueName
	        AND (@IsActive IS NULL OR IsActive = @IsActive)
	        AND (@DateActive IS NULL OR DateActive <= @DateActive)
	        AND Priority >= 0
            --Below ORDER BY removed as it not necessary due to IX_ActiveMessages index.  Including the
            --ORDER BY below could cause the optimizer to generate a plan that will sort and spill to tempdb
            --which is undesirable due to the performance implications.  See vsts# 2013514 for details.
	        --ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
	        option ( fast 1 )
        END'
    END
GO
USE [master]
GO
ALTER DATABASE [DWQueue] SET  READ_WRITE 
GO

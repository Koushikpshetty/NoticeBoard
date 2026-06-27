-- ================================================================
--  DIGITAL NOTICE BOARD v7 - Complete Database Setup
--  HOW TO RUN:
--  1. Open Visual Studio
--  2. View menu -> SQL Server Object Explorer
--  3. Expand: SQL Server -> (localdb)\MSSQLLocalDB
--  4. Right-click "(localdb)\MSSQLLocalDB" -> New Query
--  5. Paste this entire script and press Execute (Ctrl+Shift+E)
-- ================================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DigitalNoticeBoardDB')
BEGIN
    CREATE DATABASE DigitalNoticeBoardDB;
    PRINT 'SUCCESS: Database created.';
END
GO
USE DigitalNoticeBoardDB;
GO

-- Admin Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Admin' AND xtype='U')
BEGIN
    CREATE TABLE Admin (
        AdminID     INT IDENTITY(1,1) PRIMARY KEY,
        Username    NVARCHAR(50)  NOT NULL UNIQUE,
        Password    NVARCHAR(256) NOT NULL,
        FullName    NVARCHAR(100) NOT NULL DEFAULT 'Administrator',
        CreatedDate DATETIME      NOT NULL DEFAULT GETDATE()
    );
    PRINT 'SUCCESS: Table Admin created.';
END
GO

-- Students Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Students' AND xtype='U')
BEGIN
    CREATE TABLE Students (
        StudentID   INT IDENTITY(1,1) PRIMARY KEY,
        Username    NVARCHAR(50)  NOT NULL UNIQUE,
        Email       NVARCHAR(150) NOT NULL UNIQUE,
        Password    NVARCHAR(256) NOT NULL,
        FullName    NVARCHAR(100) NOT NULL DEFAULT '',
        CreatedDate DATETIME      NOT NULL DEFAULT GETDATE()
    );
    PRINT 'SUCCESS: Table Students created.';
END
GO

-- Notices Table (with Category, IsPinned, PDFPath)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notices' AND xtype='U')
BEGIN
    CREATE TABLE Notices (
        NoticeID        INT IDENTITY(1,1) PRIMARY KEY,
        Title           NVARCHAR(200) NOT NULL,
        Description     NVARCHAR(MAX) NOT NULL,
        ImagePath       NVARCHAR(500) NULL,
        PDFPath         NVARCHAR(500) NULL,
        Category        NVARCHAR(50)  NOT NULL DEFAULT 'Announcements',
        IsPinned        BIT           NOT NULL DEFAULT 0,
        UploadDate      DATETIME      NOT NULL DEFAULT GETDATE(),
        UploadedByAdmin NVARCHAR(50)  NOT NULL DEFAULT 'admin',
        IsActive        BIT           NOT NULL DEFAULT 1
    );
    PRINT 'SUCCESS: Table Notices created.';
END
GO

-- Messages Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Messages' AND xtype='U')
BEGIN
    CREATE TABLE Messages (
        MessageID   INT IDENTITY(1,1) PRIMARY KEY,
        StudentID   INT           NOT NULL,
        NoticeID    INT           NULL,
        Subject     NVARCHAR(200) NOT NULL,
        MessageText NVARCHAR(MAX) NOT NULL,
        SentDate    DATETIME      NOT NULL DEFAULT GETDATE(),
        ReplyText   NVARCHAR(MAX) NULL,
        ReplyDate   DATETIME      NULL,
        IsRead      BIT           NOT NULL DEFAULT 0,
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
        FOREIGN KEY (NoticeID)  REFERENCES Notices(NoticeID)
    );
    PRINT 'SUCCESS: Table Messages created.';
END
GO

-- Sample notices seeded by Global.asax on app startup
PRINT '';
PRINT '=== DATABASE SETUP COMPLETE ===';
PRINT 'Run the project in Visual Studio (F5).';
PRINT 'Admin credentials are set by the application at startup.';
GO

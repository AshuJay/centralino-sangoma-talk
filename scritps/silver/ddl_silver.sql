/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'Silver layer' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'Silver' Tables
===============================================================================
*/

USE SangomaCDR

IF OBJECT_ID('silver.sangoma_cdr', 'U')  IS NOT NULL 
    DROP TABLE silver.sangoma_cdr;
GO

CREATE TABLE silver.sangoma_cdr (
    call_date       NVARCHAR(250),
    call_time       TIME(0),
    call_from       NVARCHAR(250),
    destination_id  NVARCHAR(250),
    call_to         NVARCHAR(250),
    call_direction  NVARCHAR(250),
    ring_time       TIME(0),
    talk_time       TIME(0),
    total_time      TIME(0),
    disposition     NVARCHAR(250),
    dest_type       NVARCHAR(250),
    uniqueid        NVARCHAR(250),
    dest_number     NVARCHAR(250),
    dest_answered_by NVARCHAR(250),
    caller_id_name  NVARCHAR(250),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
        
);
GO

IF OBJECT_ID('silver.users', 'U')  IS NOT NULL 
    DROP TABLE silver.users;
GO

CREATE TABLE silver.users (
    extension       INT,
    name_user       NVARCHAR(250),
    outboundcid     BIGINT,
    dep_code        INT,
    location_code   INT,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.locations', 'U')  IS NOT NULL 
    DROP TABLE silver.locations;
GO

CREATE TABLE silver.locations (
    loc_code    INT,
    loc_name    NVARCHAR(50),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO



IF OBJECT_ID('silver.departments', 'U')  IS NOT NULL 
    DROP TABLE silver.departments;
GO

CREATE TABLE silver.departments (
    dep_code    INT,
    dep_name    NVARCHAR(50),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.slicer', 'U')  IS NOT NULL 
    DROP TABLE silver.slicer;
GO

CREATE TABLE silver.slicer (
    selection NVARCHAR(250),
    filter_column_byID NVARCHAR(250),
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

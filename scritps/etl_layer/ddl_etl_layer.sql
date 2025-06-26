/*
===============================================================================
DDL Script: Create ETL Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'ETL layer' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'ETL' Tables
===============================================================================
*/

IF OBJECT_ID('etl.sangoma_cdr', 'U')  IS NOT NULL 
    DROP TABLE etl.sangoma_cdr;
GO

CREATE TABLE etl.sangoma_cdr (
    call_date       NVARCHAR(250),
    call_from       NVARCHAR(250),
    destination_id  NVARCHAR(250),
    call_to         NVARCHAR(250),
    call_direction  NVARCHAR(250),
    ring_time       TIME,
    talk_time       TIME,
    total_time      TIME,
    disposition     NVARCHAR(250),
    dest_type       NVARCHAR(250),
    uniqueid        NVARCHAR(250),
    dest_number     NVARCHAR(250),
    dest_answered_by NVARCHAR(250),
    caller_id_name  NVARCHAR(250),
    accountcode     NVARCHAR(250),
    userfield       NVARCHAR(250) 
        
);
GO

IF OBJECT_ID('etl.users', 'U')  IS NOT NULL 
    DROP TABLE etl.users;
GO

CREATE TABLE etl.users (
    users           NVARCHAR(50),
    internal_num    INT
);
GO


IF OBJECT_ID('etl.locations', 'U')  IS NOT NULL 
    DROP TABLE etl.locations;
GO

CREATE TABLE etl.locations (
    loc_code    INT,
    loc_name    NVARCHAR(50)
);
GO



IF OBJECT_ID('etl.departments', 'U')  IS NOT NULL 
    DROP TABLE etl.departments;
GO

CREATE TABLE etl.departments (
    dep_code    INT,
    dep_name    NVARCHAR(50)
);
GO

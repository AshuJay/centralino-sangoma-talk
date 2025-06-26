/*
============================================================================
Create Database and Schemas
============================================================================
Script Purpose:
  This script creates a New database named 'SangomaCDR' after checking if it already exists.
  If the database exists, it is dropped and recreated.  Additionally, the script sets up two schemas
  within the database: 'etl' and 'datamart'.


WARNING:
    Running this script will drop the entire 'SangomaCDR' database if it exists.
    All data in Database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script.

*/

USE master;
GO

-- Drop and recreate the 'SangomaCDR' database
IF EXISTS( SELECT 1 FROM sys.databases WHERE name = 'SangomaCDR')
BEGIN
	ALTER DATABASE SangomaCDR SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE SangomaCDR;
END;
GO

--Create Database 'SangomaCDR'
CREATE DATABASE SangomaCDR;
GO


USE SangomaCDR;
GO


-- Create Schemas

CREATE SCHEMA etl;
GO
CREATE SCHEMA datamart;
GO

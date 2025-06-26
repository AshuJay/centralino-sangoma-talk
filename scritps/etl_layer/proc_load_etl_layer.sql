/*
===============================================================================
Stored Procedure: Load ETL Layer (Source -> ETL)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'ETL' schema from external CSV files. 
    It performs the following actions:
    - Truncates the ETL tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to ETL tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC etl.load_etl;
===============================================================================
*/
-- EXEC etl.load_etl;

CREATE OR ALTER PROCEDURE etl.load_etl AS
BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
		BEGIN TRY
			PRINT '==================================================';
			PRINT 'Loading ETL Layer';
			PRINT '==================================================';

			PRINT '--------------------------------------------------';
			PRINT 'Loading CDR Reports ';
			PRINT '--------------------------------------------------';

			SET @start_time = GETDATE();

			PRINT '>> Truncating Table: etl.sangoma_cdr';
			TRUNCATE TABLE etl.sangoma_cdr;


			BULK INSERT etl.sangoma_cdr
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\sangoma_cdr.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK

			);

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

			PRINT '----------------';
		

			

			PRINT '>> Truncating Table: etl.users';
			TRUNCATE TABLE etl.users;

			PRINT '>> Inserting Data Into: etl.users Table';
			BULK INSERT etl.users
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\users.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
		
			TABLOCK
				
			);

			PRINT '----------------';

		
			PRINT '>> Truncating Table: etl.locations';
			TRUNCATE TABLE etl.locations;

			PRINT '>> Inserting Data Into: etl.locations Table';
			BULK INSERT etl.locations
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\locations.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
				
			);

			PRINT '----------------';

			PRINT '>> Truncating Table: etl.departments';
			TRUNCATE TABLE etl.departments;

			PRINT '>> Inserting Data Into: etl.departments Table';
			BULK INSERT etl.departments
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\departments.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
				
			);

		END TRY
		BEGIN CATCH
			PRINT '==================================================';
			PRINT 'ERROR OCCURED DURING LOADING ETL LAYER';
			PRINT 'ERROR MESSAGE :' + ERROR_MESSAGE() ;
			PRINT 'ERROR MESSAGE :' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'ERROR MESSAGE :' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '==================================================';
		
		END CATCH

END	
	
	
	
	/*

*** Check Data Completeness and Schema Checks
	select * from etl.sangoma_cdr
	SELECT * FROM etl.departments
	SELECT * FROM etl.users


*/

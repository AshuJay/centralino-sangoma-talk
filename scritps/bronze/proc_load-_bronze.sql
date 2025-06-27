/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'Bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the ETL tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to Bronze  tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
--EXEC bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
		BEGIN TRY
			PRINT '==================================================';
			PRINT 'Loading Bronze Layer';
			PRINT '==================================================';

			PRINT '--------------------------------------------------';
			PRINT 'Loading CDR Reports ';
			PRINT '--------------------------------------------------';

			SET @start_time = GETDATE();

			PRINT '>> Truncating Table: bronze.sangoma_cdr';
			TRUNCATE TABLE bronze.sangoma_cdr;


			BULK INSERT bronze.sangoma_cdr
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\sangoma_cdr.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			--ROWTERMINATOR = '\n',
			TABLOCK

			);

			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

			PRINT '----------------';
		

			

			PRINT '>> Truncating Table: bronze.users';
			TRUNCATE TABLE bronze.users;

			PRINT '>> Inserting Data Into: bronze.users Table';
			BULK INSERT bronze.users
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\extensions.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
		
			TABLOCK
				
			);

			PRINT '----------------';

		
			PRINT '>> Truncating Table: bronze.locations';
			TRUNCATE TABLE bronze.locations;

			PRINT '>> Inserting Data Into: bronze.locations Table';
			BULK INSERT bronze.locations
			FROM 'C:\Users\ashu.ampue\Desktop\centralino\dataset\locations.csv'
			with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ';',
			TABLOCK
				
			);

			PRINT '----------------';

			PRINT '>> Truncating Table: bronze.departments';
			TRUNCATE TABLE bronze.departments;

			PRINT '>> Inserting Data Into: bronze.departments Table';
			BULK INSERT bronze.departments
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

END	;

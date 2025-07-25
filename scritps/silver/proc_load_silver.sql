/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		- Creates new Slicer Table for Filtering
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '----------------------------------------------------------'
		PRINT '-----------INSERT INTO silver Table ----------------------'
		PRINT '----------------------------------------------------------'


			SET @start_time = GETDATE();
				PRINT '>> Truncating table: silver.users';
				TRUNCATE TABLE silver.users;
				PRINT '>> Inserting Data into: silver.users';
				INSERT INTO silver.users
				(
					extension,
					name_user,
					outboundcid,
					dep_code,
					location_code

				)
				SELECT 
					extension,
					TRIM(REPLACE(name_user, '"', '')) AS name_user,
					CAST (TRIM(REPLACE(outboundcid, '+', '')) AS BIGINT) AS outboundcid,
					SUBSTRING(extension, 1, 2) AS dep_code,
					SUBSTRING(extension, 3, 2) AS location_code
	
				FROM bronze.users 
				WHERE outboundcid IS NOT NULL

			SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		
		PRINT '-----------INSERT INTO silver.departments Table-----------'
		
		SET @start_time = GETDATE();
				PRINT '>> Truncating table: silver.departments';
				TRUNCATE TABLE silver.departments;
				PRINT '>> Inserting Data into: silver.departments';
				INSERT INTO silver.departments(
					dep_code,
					dep_name
				)
				SELECT 
					dep_code,
					TRIM(UPPER(dep_name)) AS dep_name
				FROM bronze.departments
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '-----------INSERT INTO silver.locations Table-----------'
		SET @start_time = GETDATE();
				PRINT '>> Truncating table: silver.locations';
				TRUNCATE TABLE silver.locations;
				PRINT '>> Inserting Data into: silver.locations';
				INSERT INTO silver.locations(
					loc_code,
					loc_name
				)
				SELECT
					loc_code,
					TRIM(UPPER(loc_name)) AS loc_name
				FROM bronze.locations
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		
		PRINT '-----------INSERT INTO silver.sangoma_cdr Table-----------'
		SET @start_time = GETDATE();
				PRINT '>> Truncating table: silver.sangoma_cdr';
				TRUNCATE TABLE silver.sangoma_cdr;
				PRINT '>> Inserting Data into: silver.sangoma_cdr';
				INSERT INTO silver.sangoma_cdr (
					call_date,
					call_time,
					call_from,
					destination_id,
					call_to,
					call_direction,
					ring_time,
					talk_time,
					total_time,
					disposition,
					dest_type,
					uniqueid,
					dest_number,
					dest_answered_by,
					caller_id_name
				)
				SELECT 
					CAST (TRIM(REPLACE(call_date, '"', '')) AS DATE) AS call_date,
					CAST (TRIM(REPLACE(call_date, '"', '')) AS TIME(0))  AS call_time,
					CASE
						WHEN LEFT(call_from, 3) = '+39' THEN RIGHT(call_from, LEN(call_from)-3)  -- Remove the '+39'
						--WHEN ISNUMERIC(TRIM(REPLACE(call_from,'+', ''))) = 0 THEN NULL   -- Check if its non numeric and set NUll
						ELSE call_from
					END AS call_from,
					CASE WHEN LEFT( destination_id, 3) = '+39' THEN RIGHT(destination_id, LEN(destination_id) -3)  -- Remove the '+39'
							ELSE TRIM(REPLACE( destination_id,'+', ''))
					END AS destination_id,
					CASE WHEN LEFT(call_to, 1) = '0' THEN RIGHT(call_to, LEN(call_to)-1)
						 WHEN LEFT(call_to, 3) = '+39' THEN RIGHT(call_to, LEN(call_to)-3)
						ELSE call_to
					END AS call_to,
					UPPER(TRIM(call_direction)) AS call_direction,
					CAST(ring_time AS TIME(0)) AS ring_time,
					CAST(talk_time AS TIME(0)) AS talk_time,
					CAST(total_time AS TIME(0)) AS total_time,
					TRIM(REPLACE(disposition, '"','')) AS disposition,
					UPPER(TRIM(REPLACE(dest_type, '"',''))) AS dest_type,
					CAST( REPLACE(uniqueid, '.', '') AS BIGINT) AS uniqueid,
					CASE WHEN ISNUMERIC(dest_number) = 0 THEN NULL
						ELSE TRIM(REPLACE(dest_number,'+', ''))
					END AS dest_number,
	
					CASE WHEN LEFT( dest_answered_by, 1) = '0' THEN RIGHT(dest_answered_by, LEN(dest_answered_by) -1)
						 WHEN dest_answered_by IS NULL THEN 'n/a'  -- Consider n/a as  NO Answer which is different from Null
						 WHEN ISNUMERIC(dest_answered_by) = 0 THEN NULL
						 ELSE TRIM(REPLACE( dest_answered_by,'+', ''))
					END AS dest_answered_by,
					CASE WHEN LEFT(TRIM(REPLACE(caller_id_name, '"','')), 3) = '+39' THEN RIGHT(caller_id_name, LEN(caller_id_name) -3)
						 ELSE TRIM(REPLACE(caller_id_name, '"',''))
					END AS caller_id_name
					-- CONCAT( call_from, '|', call_to) AS FilterColumn
	
				FROM bronze.sangoma_cdr
					WHERE call_from IS NOT NULL

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	
	
	
		PRINT '-----------Create Slicer Table -----------'
		SET @start_time = GETDATE();
				PRINT '>> Truncating table: silver.slicer';
				TRUNCATE TABLE silver.slicer;
				PRINT '>> Inserting Data into: silver.slicer';

				INSERT INTO silver.slicer(
						selection,
						filter_column_byID
				)
				SELECT DISTINCT 
					selection,
					filter_column_byID
				FROM (
						SELECT call_from AS selection,
							   CONCAT(call_from, '|', call_to ,'|', dest_answered_by,  '|', uniqueid) AS filter_column_byID
						FROM silver.sangoma_cdr 
	
					UNION 

					SELECT call_to AS selection,
							   CONCAT(call_from, '|', call_to,'|', dest_answered_by, '|', uniqueid) AS filter_column_byID
						FROM silver.sangoma_cdr 

					UNION 
	
					SELECT dest_answered_by AS selection,
							CONCAT(call_from, '|', call_to,'|', dest_answered_by, '|', uniqueid) AS filter_column_byID
					 FROM silver.sangoma_cdr 
	
					) AS Combined

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------'

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='


	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH

END

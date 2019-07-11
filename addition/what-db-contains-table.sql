/*
Find out what database contains target table.
*/

DECLARE @MyCursor CURSOR;
DECLARE @databaseName varchar(50);
declare @tableName varchar(50);
set @tableName = 'VerificationRequests';
BEGIN
    SET @MyCursor = CURSOR FOR
    select name from sys.databases

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @databaseName

    WHILE @@FETCH_STATUS = 0
    BEGIN
      
	  exec ('use [' + @databaseName + '];
	  		DECLARE @retVal int;
			SELECT @retVal = COUNT(*) 
			FROM sys.tables
			WHERE name = ''' + @tableName + ''';
			IF (@retVal > 0)
			BEGIN
				print ''*****'' + ''' + @databaseName + ''' + ''*****''
			END')
	  print @databaseName;
	  --select db_name();
	  --select * from sys.tables;

      FETCH NEXT FROM @MyCursor 
      INTO @databaseName 
    END; 

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;




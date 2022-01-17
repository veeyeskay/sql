/*
Use this script to create insert statements for each row in the specified table.
 
Instructions:
1. Set the database you want to script from as normal.
 
2. change the set @TableName = '<yourtablename>' line to be the
table you want to script out.
 
3. Run the script and copy all the text from the results below
the line with all the dashes (----).
 
Notes:
   If you get the error message "Invalid object name '<yourtablename>'."
   then you either forgot to set the correct database or you spelled
   your table name wrong
 
Credits:
  Bob Wiechman - Fix for smalldatetime support
  Richard Lesh - correct support of uniqueidentifiers, automatic
	  setting of Identity off/on, add Where clause support, more detail in 
  	  debug mode.
  Fuhai Li - correct support of null values;
			 fix the coallation conflicts via using default coallation
			 correct the identity insert on/off for non debug mode
			 column name with bracket to make it robust for naming 
  To do: test the null values for gui type
  To do: add on parameters to choose which fields would export via colorder such as 1,2,...	
*/
 
DECLARE @TableName SYSNAME
DECLARE @WhereClause VARCHAR(1024)
DECLARE @IdentityInsert INT
DECLARE @ColName SYSNAME
DECLARE @ColType TINYINT
DECLARE @ColStatus TINYINT
DECLARE @DebugMode BIT
DECLARE @ColList NVARCHAR(4000)
DECLARE @ValList NVARCHAR(4000)
DECLARE @SQL1 NVARCHAR(1000)
DECLARE @SQL2 NCHAR(10)
DECLARE @SQL3 NCHAR(1000)
 
--Your Table Name
SET @TableName = 'TABLE_NAME'
 
-- limit scope of inserts, this will be hard coded thing to narrow down the set
SET @WhereClause = ''
 
-- set to 1 if you only want a script
SET @DebugMode = 0
 
-- set to 1 if you want to force IDENTITY_INSERT statements
SET @IdentityInsert = 0
 
SET @ColList = ''
SET @ValList = ''
SET @SQL1 = 'SELECT REPLACE(''INSERT INTO ' + @TableName + ' ('
SET @SQL2 = ') VALUES ('
SET @SQL3 = ')'' COLLATE DATABASE_DEFAULT, ''''''NULL'''''', ''NULL'') FROM '
    + @TableName
 
IF @DebugMode = 1 
   PRINT '-- StmtShell: ' + @sql1 + @sql2 + @sql3
 
DECLARE csrColumns CURSOR LOCAL fast_forward
FOR SELECT
c.name,
c.xtype,
c.STATUS
FROM
syscolumns c
INNER JOIN sysobjects o
ON o.id = c.id
WHERE
o.name = @TableName
AND o.xtype IN ('U', 'S')
ORDER BY
ColID
 
OPEN csrColumns
FETCH NEXT FROM csrColumns INTO @ColName, @ColType,
    @ColStatus
 
WHILE @@fetch_status = 0 
      BEGIN
            SET @ColList = @ColList + ' ' + '[' + @ColName + ']'
            IF @ColType IN (173, 104, 106, 62, 56, 60, 108, 59, 52, 122, 48,
                            165) 
               SET @ValList = @ValList + ' ''+ISNULL(CONVERT(VARCHAR(200),'
                   + @ColName + '),''NULL'')+'''
            ELSE 
               IF @ColType IN (175, 239, 231, 231, 167) 
                  SET @ValList = @ValList + ' ''''''+ISNULL(' + @ColName
                      + ',''NULL'')+'''''''
               ELSE 
                  IF @ColType IN (58, 61, 36) 
                     SET @ValList = @ValList
                         + ' ''''''+ISNULL(CONVERT(VARCHAR(200),' + @ColName
                         + '),''NULL'')+'''''''
            IF @DebugMode = 1 
               BEGIN
                     PRINT '-- @ValList: ' + @ValList
               END 
            IF (@ColStatus & 0x80) = 0x80 
               BEGIN
                     SET @IdentityInsert = 1
               END          
            FETCH NEXT FROM csrColumns INTO @ColName, @ColType,
            @ColStatus
      END
 
CLOSE csrColumns
DEALLOCATE csrColumns
 
SET @ColList = REPLACE(LTRIM(@ColList), ' ', ', ')
SET @ValList = REPLACE(LTRIM(@ValList), ' ', ', ')
 
IF @IdentityInsert = 1
   AND @DebugMode = 1 
   PRINT 'SET IDENTITY_INSERT ' + @TableName + ' ON'
IF @IdentityInsert = 1
   AND @DebugMode = 0 
   SELECT 'SET IDENTITY_INSERT ' + @TableName + ' ON'
 
IF @DebugMode = 1 
   PRINT @SQL1 + @ColList + @SQL2 + @ValList + @SQL3 + ' ' + @WhereClause
ELSE 
   EXEC
   (
   @SQL1 + @ColList + @SQL2 + @ValList + @SQL3 + ' '
   + @WhereClause
   )
 
IF @IdentityInsert = 1
   AND @DebugMode = 1 
   PRINT 'SET IDENTITY_INSERT ' + @TableName + ' ON'
IF @IdentityInsert = 1
   AND @DebugMode = 0 
   SELECT 'SET IDENTITY_INSERT ' + @TableName + ' ON'
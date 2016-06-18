
##
# get the size of tables in current database
#
SELECT DATABASE() FROM DUAL into @dbName;

	(SELECT 
		table_name AS "Tables"
		, format(((data_length + index_length) / 1024 / 1024), 2) as size_mb
		, format((data_free)/1024/1024,2) as free_mb 
	FROM information_schema.TABLES 
	WHERE table_schema = @dbName)
union all
	(select 
		"All"                  
		, format(sum(((data_length + index_length) / 1024 / 1024)),2) as size_mb
		, format((sum(data_free))/1024/1024,2) as free_mb  
	FROM information_schema.TABLES 
	WHERE table_schema = @dbName)
ORDER BY size_mb DESC;

# get the size of databases
select table_schema as database_name, round(sum(((data_length + index_length) / 1024 / 1024)),2) as size_mb, round((data_free)/1024/1024,2) as free_mb from information_schema.TABLES group by table_schema;


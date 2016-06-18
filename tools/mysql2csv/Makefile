all:
	g++ mysql2csv.cpp -omysql2csv -g -L/usr/lib64/mysql/  -lmysqlclient
	g++ csv2mysql.cpp -ocsv2mysql -g -L/usr/lib64/mysql/  -lmysqlclient

clean:
	rm -f mysql2csv  csv2mysql  output.csv

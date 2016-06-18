# The mysql2csv and csv2mysql Tools

There are two simple tools here in this directory for exporting and importing Mysql database data using [.csv format](http://tools.ietf.org/html/rfc4180). The csv format data is rather easy for application to generate and parse. Also, it is very easy to convert .csv file into .xls/.xlsx file or to convert .xls/.xlsx file into .csv file.

- mysql2csv - Export MySQL database data into a csv file
- csv2mysql - Import csv file data into MySQL database



## Compile the Code

Before you compiles the code, if you are using yum, the `mysql-devel` package should be install, so that the mysql header file `mysql/mysql.h` and library file `libmysqlclient.a` or `libmysqlclient.so` could be found on you system.

Type the following command to comiles the code:

``` shell
g++ mysql2csv.cpp -omysql2csv -g -L/usr/lib64/mysql/  -lmysqlclient
g++ csv2mysql.cpp -ocsv2mysql -g -L/usr/lib64/mysql/  -lmysqlclient
```



## Supported Options

<table>
    <thread>
        <tr>
            <th>Option</th> <th>Description</th> <th>Default</th>
        </tr>
    </thread>
    
    <thread>
        <tr>
            <th colspan="3">Common Options</th>
        </tr>
    </thread>
    
    <tbody>
        <tr>
            <td>--host</td> <td>The host name for MySQL server</td> <td>127.0.0.1</td>
        </tr>
        <tr>
            <td>--port</td> <td>The destination port for MySQL connection</td> <td>3306</td>
        </tr>
        <tr>
            <td>--user</td> <td>MySQL user name</td> <td>root</td>
        </tr>
        <tr>
            <td>--passwd</td> <td>The password of the MySQL user</td> <td></td>
        </tr>
        <tr>
            <td>--default-character-set</td> <td>The character set of the MySQL connection</td> <td>utf8</td>
        </tr>
        <tr>
            <td>--database</td> <td>The database to use</td> <td></td>
        </tr>
    </tbody>

    <thread>
        <tr>
            <th colspan="3">mysql2csv Specific</th>
        </tr>
    </thread>
    <tbody>
        <tr>
            <td>--execute</td> <td>The query statement</td> <td></td>
        </tr>
        <tr>
            <td>--null_cell_value</td> <td>The string to be used when the value of a column is NULL.</td> <td>NULL</td>
        </tr>
        <tr>
            <td>--output</td> <td>The name of the output csv file. If this option is empty, the data of the csv file will be passed to stdout.</td> <td></td>
        </tr>
    </tbody>
    
    <thread>
        <tr>
            <th colspan="3">csv2mysql Specific</th>
        </tr>
    </thread>
    <tbody>
        <tr>
            <td>--execute</td> <td>The update statement</td> <td></td>
        </tr>
        <tr>
            <td>--warning_as_error</td> <td>If this optioin is set to 1, then if there is any warning when execute the statement, the program treats it as an error and terminate directly.</td> <td>1</td>
        </tr>
        <tr>
            <td>--input</td> <td>The name of the input csv file. If this option is empty, the data of the csv file will be read from stdin.</td> <td></td>
        </tr>
    </tbody>
    
</table>


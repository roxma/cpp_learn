# mysql2csv 和 csv2mysql 工具

在这里提供了两个使用 .csv 格式 的简单的 MySQL 数据库的导数据工具。[csv 格式](http://tools.ietf.org/html/rfc4180)可以很容易地生成和解析，而且，也可以很容易地使用办公软件把 .csv 格式转换为 .xls/.xlsx 格式，或者把 .xls/.xlsx 格式转换为 .csv 格式的文件。

- mysql2csv - 将 MySQL 的数据导出为 csv 格式的文件。
- csv2mysql - 将 csv 格式的文件的数据导入到 MySQL 数据库。



## 编译代码

在编译代码之前，如果你用的是 yum，那么请先确定软件包 `mysql-devel` 已经安装在你的系统中，才能使用 mysql 的头文件 `mysql/mysql.h` ，以及和库文件 `libmysqlclient.a` 或者 `libmysqlclient.so`。

使用下面的两行命令一编译这两个工具:

``` shell
g++ mysql2csv.cpp -omysql2csv -g -L/usr/lib64/mysql/  -lmysqlclient
g++ csv2mysql.cpp -ocsv2mysql -g -L/usr/lib64/mysql/  -lmysqlclient
```



## 支持的工具选项

<table>
    <thread>
        <tr>
            <th>选项</th> <th>描述</th> <th>默认值</th>
        </tr>
    </thread>

    <thread>
        <tr>
            <th colspan="3">通用选项</th>
        </tr>
    </thread>

    <tbody>
        <tr>
            <td>--host</td> <td>MySQL server 的机器名</td> <td>127.0.0.1</td>
        </tr>
        <tr>
            <td>--port</td> <td>MySQL 连接的目标端口</td> <td>3306</td>
        </tr>
        <tr>
            <td>--user</td> <td>MySQL 用户名</td> <td>root</td>
        </tr>
        <tr>
            <td>--password</td> <td>MySQL 用户的密码</td> <td></td>
        </tr>
        <tr>
            <td>--default-character-set</td> <td>MySQL 连续使用的字符编码</td> <td>utf8</td>
        </tr>
        <tr>
            <td>--database</td> <td>使用的 MySQL 数据库名。相当于 use db 命令。</td> <td></td>
        </tr>
    </tbody>

    <thread>
        <tr>
            <th colspan="3">mysql2csv 选项</th>
        </tr>
    </thread>
    <tbody>
        <tr>
            <td>--execute</td> <td>需要执行的 MySQL 查询命令</td> <td></td>
        </tr>
        <tr>
            <td>--null_cell_value</td> <td>当对应的值NULL时，使用这个字符串替换到表格中。</td> <td>NULL</td>
        </tr>
        <tr>
            <td>--output</td> <td>生成的 csv 文件的文件名。如果这个选项为空，则文件 的内容会被输出到 stdout。</td> <td></td>
        </tr>
    </tbody>

    <thread>
        <tr>
            <th colspan="3">csv2mysql 选项</th>
        </tr>
    </thread>
    <tbody>
        <tr>
            <td>--execute</td> <td>需要执行的 MySQL 指令</td> <td></td>
        </tr>
        <tr>
            <td>--warning_as_error</td> <td>如果为个选项为1，那么在执行 MySQL 语句的过程中如果出现任何 warning，都会被视为错误，程序直接终止退出。</td> <td>1</td>
        </tr>
        <tr>
            <td>--input</td> <td>输入的 csv 文件的文件名。如果这个选项为空，则程序从 stdin 中读取数据。</td> <td></td>
        </tr>
    </tbody>

</table>



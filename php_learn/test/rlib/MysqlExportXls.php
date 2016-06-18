<?php 

//set_include_path('../../libs/PHPExcel_1.7.9/');

require_once '../../libs/rlib/MysqlExportXls.php';

$connectOptions = new MysqlExportXlsConnectOptions();
$connectOptions->password = "";
$connectOptions->useDatabase = "rlib_test";

$fileOptions = new MysqlExportXlsFileOptions();

MysqlExportXls($connectOptions,$fileOptions, "select * from test");

?>
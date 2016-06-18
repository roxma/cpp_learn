<?php

require_once '../../libs/rlib/ExportXls.php';

$file = new ExportXlsFileOptions();
$file->name = "ExportXlsFromArray.xls";


$array = array();
$array[] = array(
		"col1" => "col1l1"
		, "col2" => "col2l1"
		, "col3" => "col3l1"
);
$array[] = array(
		"col1" => "col1l2"
		, "col2" => "col2l2222"
		, "col3" => "col3l2"
);
$array[] = array(
		"col1" => "col1l2"
		//, "col2" => "col2l2222"
		, "col3" => "col3l2"
);

ExportXlsFromArray($file, $array);

?>
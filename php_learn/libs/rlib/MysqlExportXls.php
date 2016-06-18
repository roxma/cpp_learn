<?php

/**
 * @author roxma
 * provide function MysqlExportXls.
 */


require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel.php';
require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/Writer/Excel5.php';
include_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/IOFactory.php';

class MysqlExportXlsConnectOptions{
	var $host = '127.0.0.1:3306';
	var $userName = "root";
	var $password = "";
	var $useDatabase = "";
	// charset is set to utf8, because PHPExcel use utf-8 encoding to save file.
};

class MysqlExportXlsFileOptions{
	var $name = "newtable.xls";
	var $creator = "unknown";
	var $lastModifiedBy = "unknown";
	var $title = "untitled";
	var $subject = "unknown";
	var $description = "no description.";
};

/**
 * The MysqlExportXls function is used to export mysql query result into an .xls file.
 * @param MysqlExportXlsConnectOptions $connectOptions
 * @param MysqlExportXlsFileOptions $fileOptions
 * @return error message. Return empty string on success.
 */
function MysqlExportXls($connectOptions, $fileOptions, $query){
	
	$objPHPExcel = new PHPExcel();

	$objPHPExcel->getProperties()->setCreator($fileOptions->creator);
	$objPHPExcel->getProperties()->setLastModifiedBy($fileOptions->lastModifiedBy);
	$objPHPExcel->getProperties()->setTitle($fileOptions->title);
	$objPHPExcel->getProperties()->setSubject($fileOptions->subject);
	$objPHPExcel->getProperties()->setDescription($fileOptions->description);
	
	$objPHPExcel->setActiveSheetIndex(0);
	$activeSheet = $objPHPExcel->getActiveSheet();
	$activeSheet->setTitle($fileOptions->title);
	
	// connect to mysql
	$link = mysql_connect($connectOptions->host, $connectOptions->userName, $connectOptions->password);
	if(!$link) 
		return (__FILE__ . ":" . __FUNCTION__ . ':' 
				. 'Could not connect: ' . mysql_error($link));
	// use database
	$selectDb = mysql_select_db($connectOptions->useDatabase , $link);
	if(!$selectDb){
		return (__FILE__ . ":" . __FUNCTION__ . ':' 
				. 'Could not select database' . mysql_error($link));
	}

	// PHPExcel use utf-8 encoding to save file only !!!
	$setCharset = mysql_set_charset("utf8", $link);
	if(!$setCharset){
		return (__FILE__ . ":" . __FUNCTION__ . ':'
				. 'Could not set charset' . mysql_error($link));
	}
	
	// execute sql
	$result = mysql_query($query, $link);
	if(!$result){
		return (__FILE__ . ":" . __FUNCTION__ . ':'
			. 'Query failed: ' . mysql_error($link));
	}
	
	// field names
	$columnIndex = 0;
	while($field = mysql_fetch_field($result)){
		$activeSheet->SetCellValue( PHPExcel_Cell::stringFromColumnIndex($columnIndex) . '1', $field->name);
		++$columnIndex;
	}
	
	$rowIndex = 2;	// 1 based, the firset row is for field names.
	while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
		$columnIndex = 0;
		foreach ($line as $key => $col_value) {
			$activeSheet->SetCellValue(
								  PHPExcel_Cell::stringFromColumnIndex($columnIndex) . $rowIndex 
								, $col_value===null ? "" : $col_value
								, PHPExcel_Cell_DataType::TYPE_STRING2
							);
			++$columnIndex;
		}

		++$rowIndex;
	}
	
	// free mysql resource
	mysql_free_result($result);
	mysql_close($link);
	
	// write data into file
	$objWriter = new PHPExcel_Writer_Excel5($objPHPExcel);
	$objWriter->setPreCalculateFormulas(FALSE);	// Why true by default ? oh god damn it!
	$objWriter->save($fileOptions->name);
	
	return "";
}

?>
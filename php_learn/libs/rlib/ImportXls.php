<?php
 
require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel.php';
require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/Writer/Excel5.php';
include_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/IOFactory.php';

function ImportXlsToArray(& $arr, $inputFileName){
	if(strpos($inputFileName,'xlsx') !== false){
		$inputFileType = 'Excel2007';
	}else{
		$inputFileType = 'Excel5';
	}

	/**  Create a new Reader of the type defined in $inputFileType  **/
	$objReader = PHPExcel_IOFactory::createReader($inputFileType);
	/**  Load $inputFileName to a PHPExcel Object  **/
	$objPHPExcel = $objReader->load($inputFileName);
	
	$arr = $objPHPExcel->getActiveSheet()->toArray(null,true,true,false);
}

?>
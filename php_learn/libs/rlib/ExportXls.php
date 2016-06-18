<?php 

require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel.php';
require_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/Writer/Excel5.php';
include_once dirname(__FILE__) . "/" . '../PHPExcel_1.7.9/PHPExcel/IOFactory.php';

/**
 * @author roxma
 * provide function ExportXlsFromArray.
 */


class ExportXlsFileOptions{
	var $name = "newtable.xls";
	var $creator = "unknown";
	var $lastModifiedBy = "unknown";
	var $title = "untitled";
	var $subject = "unknown";
	var $description = "no description.";
};

/**
 * The ExportXlsFromArray function is used to dump an array into xls file.
 */
function ExportXlsFromArray(ExportXlsFileOptions $fileOptions, array $array){
	
	if( (count($array)==0) || (count($array[0])==0) ){
		return "Array is emtpty.";
	}
	
	$objPHPExcel = new PHPExcel();

	$objPHPExcel->getProperties()->setCreator($fileOptions->creator);
	$objPHPExcel->getProperties()->setLastModifiedBy($fileOptions->lastModifiedBy);
	$objPHPExcel->getProperties()->setTitle($fileOptions->title);
	$objPHPExcel->getProperties()->setSubject($fileOptions->subject);
	$objPHPExcel->getProperties()->setDescription($fileOptions->description);

	$objPHPExcel->setActiveSheetIndex(0);
	$activeSheet = $objPHPExcel->getActiveSheet();
	$activeSheet->setTitle($fileOptions->title);

	$fields = array();
	
	// field names
	$columnIndex = 0;
	foreach( $array[0] as $key=>$value){
		$fields[] = $key; $activeSheet->SetCellValue( PHPExcel_Cell::stringFromColumnIndex($columnIndex) . '1', $key);
		++$columnIndex;
	}

	$rowIndex = 2;	// 1 based, the firset row is for field names.
	foreach($array as $line){
		$columnIndex = 0;
		foreach ($fields as $field) {
			$activeSheet->SetCellValue(
					  PHPExcel_Cell::stringFromColumnIndex($columnIndex) . $rowIndex
					, !isset($line[$field]) || $line[$field]===null ? "" :  $line[$field]
					, PHPExcel_Cell_DataType::TYPE_STRING2
			);
			++$columnIndex;
		}

		++$rowIndex;
	}

	// write data into file
	$objWriter = new PHPExcel_Writer_Excel5($objPHPExcel);
	$objWriter->setPreCalculateFormulas(FALSE);	// Why true by default ? oh god damn it!
	$objWriter->save($fileOptions->name);

	return "";
}

?>

<?php

header('Content-Type: application/json; charset=utf-8');
header("Last-Modified: ".gmdate( "D, d M Y H:i:s")."GMT");
header("cache-Control: no-cache, must-revalidate");
header("Pragma: no-cache");

function CgiOutput($errorCode, $errorMessage, array $data = array()){
	$outputArr = array();
	$outputArr["error_code"] = $errorCode;
	$outputArr["error_message"] = (($errorMessage=="")&&$errorCode)?"未知错误":$errorMessage;
	if((($errorMessage=="")&&$errorCode))
		$outputArr["is_unknown_error"] = 1;
	$outputArr["data"] = $data;
	echo json_encode($outputArr);
	exit(0);
}

?>
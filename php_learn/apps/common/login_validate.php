<?php

require_once dirname(__FILE__) . '/' . '../common/Cgi.php';

require_once dirname(__FILE__) . '/' . 'Login.php';

require_once dirname(__FILE__) . '/' . '../common/GetLogger.php';


$inputMail = CgiInput("mail", "");
$inputValidateKey = CgiInput("validate_key", "");

$errorCode =  LoginValidate($inputMail, $inputValidateKey);
if( $errorCode ){
	sleep(1);
	CgiOutput($errorCode,"validate failed");
}else{
	CgiOutput(0,"");
}

?>

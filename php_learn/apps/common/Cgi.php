<?php

header('Content-Type: application/json; charset=utf-8');
header("Last-Modified: ".gmdate( "D, d M Y H:i:s")."GMT");
header("cache-Control: no-cache, must-revalidate");
header("Pragma: no-cache");

require_once dirname(__FILE__) . '/' . 'Login.php';


$g_cgi_script_begin_time_s = microtime(true);

function CgiInput($name, $default){
    if(isset($_GET[$name])){
        return $_GET[$name];
    }else if(isset($_POST[$name])){
        return $_POST[$name];
    }else{
        return $default;
    }
}

function CgiOutput($errorCode, $errorMessage, array $data = array()){

    $outputArr = array();

	/**
	 * JavaScript should use the result field to check if the operation success.
	 * In case the php code failed badly, then there is no result field in the response
	 * string, then in the JavaScript code if(response.result) will be false, which
	 * also means error.
	 */
	if($errorCode){
		$outputArr["result"] = 0;
	}else{
		$outputArr["result"] = 1;
	}

    $outputArr["error_code"] = $errorCode;
    $outputArr["error_message"] = (($errorMessage=="")&&$errorCode)?"未知错误":$errorMessage;
    if((($errorMessage=="")&&$errorCode))
        $outputArr["is_unknown_error"] = 1;
	else
        $outputArr["is_unknown_error"] = 0;

	global $g_cgi_script_begin_time_s;
	$outputArr["exection_time_s"] = microtime(true) - $g_cgi_script_begin_time_s;

    $outputArr["data"] = $data;

	$outputArr["user"] = LoginGetUser();

    echo json_encode($outputArr);

    exit(0);
}

function CgiRequireLogin(){
	if(LoginGetUser()==""){
		CgiOutput(__FILE__,"user require to login");
	}
	return 0;
}

?>

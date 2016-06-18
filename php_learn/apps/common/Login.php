<?php

require_once dirname(__FILE__) . '/' . 'session_start.php';
require_once dirname(__FILE__) . '/' . 'GetLogger.php';

function LoginSessionAntiCopyInit(){
	$ip = $_SERVER['REMOTE_ADDR'];
	$userAgentMd5 = md5($_SERVER['HTTP_USER_AGENT']);
	$_SESSION["login_validate_ip"] = $ip;
	$_SESSION["login_validate_uamd5"] = $userAgentMd5;
	GetLogger()->info("$ip $userAgentMd5");
}

function LoginSessionAntiCopyCheck(){
	$ip = $_SERVER['REMOTE_ADDR'];
	$userAgentMd5 = md5($_SERVER['HTTP_USER_AGENT']);
	if(!isset($_SESSION["login_validate_ip"])){
		return __LINE__;
	}
	if(!isset($_SESSION["login_validate_uamd5"])){
		return __LINE__;
	}
	if(($_SESSION["login_validate_ip"]!=$ip) || ($_SESSION["login_validate_uamd5"]!=$userAgentMd5)){
		return __LINE__;
	}
	return 0;
}

function LoginGetValidateKey($mail){
	$validateKey = "";
	for($i = 0; $i<25; ++$i){
		$rand = rand(0,9);
		$validateKey = $validateKey . $rand;
	}
	$_SESSION["login_validate_key"] = $validateKey;
	$_SESSION["login_validate_mail"] = $mail;
	GetLogger()->info("$mail $validateKey");

	LoginSessionAntiCopyInit();

	return $validateKey;
}

function LoginValidate($inputMail, $inputValidateKey){

	if(LoginSessionAntiCopyCheck()!=0){
		return __LINE__;
	}

	if(($inputMail =="") || ($inputValidateKey=="") ){
		return __LINE__;
	}

	$sessionKey = "";
	$sessionMail = "";
	if(isset($_SESSION["login_validate_key"])){
		$sessionKey = $_SESSION["login_validate_key"];
	}
	if(isset($_SESSION["login_validate_mail"])){
		$sessionMail = $_SESSION["login_validate_mail"];
	}
	
	if( ($inputMail==$sessionMail) && ($inputValidateKey==$sessionKey) ){
		$_SESSION["login_user"] = $inputMail;
		GetLogger()->info("$inputMail $inputValidateKey  $sessionMail $sessionKey");
		return 0;
	}else{
		GetLogger()->error("$inputMail $inputValidateKey  $sessionMail $sessionKey");
		return __LINE__;
	}
}

function LoginGetUser(){

	if(LoginSessionAntiCopyCheck()!=0){
		return "";
	}

	if(isset($_SESSION["login_user"])){
		return $_SESSION["login_user"];
	}
	return "";
}

function LoginLogout(){
	session_destroy();
}

?>

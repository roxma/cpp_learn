<?php

require_once dirname(__FILE__) . '/' . '../common/Cgi.php';
require_once dirname(__FILE__) . '/' . '../common/Dao.php';
require_once dirname(__FILE__) . '/' . 'PHPMailerSendFromQqConfig.php';
require_once dirname(__FILE__) . '/' . 'session_start.php';
require_once dirname(__FILE__) . '/' . 'Login.php';

function Entry(){

	$inputMail = CgiInput("mail", "");
	$inputReturnPage = CgiInput("return_page", "");

	if($inputMail==""){
		CgiOutput(__LINE__, "mail cannot be empty");
	}

	if(LoginGetUser()!=""){
		CgiOutput(__LINE__, "already login");
	}

	$validateKey = LoginGetValidateKey($inputMail);

	if(SendMail($inputMail,$validateKey,$inputReturnPage)){
		CgiOutput(__LINE__, "send mail failed");
	}

	CgiOutput(0, "");
}

function SendMail($inputMail, $validateKey, $inputReturnPage){

	// 发送确认邮件
	$commonDao = new CommonDao();
	$mailUserName = "";
	$mailPassword = "";
	$localhost = "";
	$commonDao->GetConfig("mail.user_name", $mailUserName);
	$commonDao->GetConfig("mail.password", $mailPassword);
	$commonDao->GetConfig("localhost", $localhost);

	$mail = new PHPMailer();
	PHPMailerSendFromQqConfig($mail, $mailUserName, $mailPassword);

	//Set who the message is to be sent to
	$mail->addAddress($inputMail, $inputMail);

	//Set the subject line
	$mail->Subject = '登录验证';

	$href = "http://" . $localhost . "/php_learn/apps/common/login_validate.html"
				. "?mail=" . $inputMail
				. "&validate_key=" . $validateKey
				. "&return_page=" . urlencode($inputReturnPage);

	$mail->msgHTML(
			"您好，你刚刚使用了这个邮件尝试登录：<br />"
			. "请在同一浏览器<a href=\"$href\">点击</a>完成验证。<br />"
			. "如果不能点击，请使用这个链接： $href<br />"
	);

	if (!$mail->send()) {
		return __LINE__;
	}

	return 0;
}

Entry();

?>


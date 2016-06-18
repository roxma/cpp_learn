<?php
	
require_once dirname(__FILE__) . '/' . 'CgiCommon.php';
require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
require_once dirname(__FILE__) . '/' . 'Dao.php';

require_once dirname(__FILE__) . '/' . '../common/Dao.php';
require_once dirname(__FILE__) . '/' . 'PHPMailerSendFromQqConfig.php';

$input = new AppointmentDaoCreateRequestInput();
$output = new AppointmentDaoCreateRequestOutput();

$input->issueId = CgiInput("issue_id", "");
$input->subIssueId = CgiInput("sub_issue_id", "");
$input->mail = CgiInput("mail", "");
$input->fields = CgiInput("fields", "");

$input->validateKey = rand(1,999999);

if($input->mail==""){
	CgiOutput(__LINE__,"邮箱不能为空");
}

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
$mail->addAddress($input->mail, $input->mail);

//Set the subject line
$mail->Subject = '报名/预约确认';

$href = "http://" . $localhost . "/php_learn/apps/appointment/appointment_validate.php"
			. "?issue_id=" . $input->issueId
			. "&sub_issue_id=" . $input->subIssueId
			. "&mail=" . $input->mail
			. "&validate_key=" . $input->validateKey ;
$mail->msgHTML(
		"您好，您刚刚预约了活动，信息如下：<br />"
		. htmlspecialchars($input->fields)
		. "<br />请<a href=\"$href\">点击确认</a>。"
);

//if (!$mail->send()) {
//	CgiOutput($error, "发送确认邮件失败");
//}

$dao = new AppointmentDao();
$error = $dao->CreateRequest($input, $output);

CgiOutput($error, $output->errorMessage);

?>
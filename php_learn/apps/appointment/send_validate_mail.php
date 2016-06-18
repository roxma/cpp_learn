<?php 

require_once dirname(__FILE__) . '/' . 'Dao.php';

require_once dirname(__FILE__) . '/' . '../common/Singleton.php';
require_once dirname(__FILE__) . '/' . '../common/Dao.php';
require_once dirname(__FILE__) . '/' . 'PHPMailerSendFromQqConfig.php';

$singleton = new CommonSingleton();
$error = $singleton->Init("appointment/send_validate_mail.php");
if($error){
	exit($error);
}

$commonDao = new CommonDao();
$mailUserName = "";
$mailPassword = "";
$localhost = "";
$commonDao->GetConfig("mail.user_name", $mailUserName);
$commonDao->GetConfig("mail.password", $mailPassword);
$commonDao->GetConfig("localhost", $localhost);

$requests = array();
$dao = new AppointmentDao();
$dao->GetUnMailedRequest($requests);

foreach($requests as $request){
	$mail = new PHPMailer();
	PHPMailerSendFromQqConfig($mail, $mailUserName, $mailPassword);
	
	//Set who the message is to be sent to
	$mail->addAddress($request["s_mail"], $request["s_mail"]);
	
	//Set the subject line
	$mail->Subject = '报名/预约确认';
	
	$href = "http://" . $localhost . "/php_learn/apps/appointment/appointment_validate.html"
			. "?issue_id=" . $request["issue_id"]
			. "&sub_issue_id=" .  $request["sub_issue_id"]
			. "&mail=" . $request["s_mail"]
			. "&validate_key=" . $request["s_validate_key"];
	$mail->msgHTML(
			"您好，您刚刚预约了活动，信息如下："
			. htmlspecialchars($request["s_fields_json"])
			. "<br />请<a href=\"$href\">点击确认</a>。"
	);
	
	if (!$mail->send()) {
		$dao->SetMailSended($request,2); // 2 表示失败
		continue;
	}
	
	$dao->SetMailSended($request,1);
}
?>
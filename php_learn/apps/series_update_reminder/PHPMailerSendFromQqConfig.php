<?php 

require_once dirname(__FILE__) . "/" .  '../../libs/PHPMailer-master/PHPMailerAutoload.php';

/**
 * @param string $from QQ邮箱发件人的用户名，如"346897220@qq.com"，注意这个账户需要开通SMTP服务。
 * @param string $password 发件人的邮箱密码。
 */
function PHPMailerSendFromQqConfig(PHPMailer $mail, $from, $password){

	//Tell PHPMailer to use SMTP
	$mail->isSMTP();
	
	//Enable SMTP debugging
	// 0 = off (for production use)
	// 1 = client messages
	// 2 = client and server messages
	//$mail->SMTPDebug = 2;
	//Ask for HTML-friendly debug output
	//$mail->Debugoutput = 'html';
	
	//Set the hostname of the mail server
	$mail->Host = "smtp.qq.com";
	//Set the SMTP port number - likely to be 25, 465 or 587
	$mail->Port = 465;
	//Whether to use SMTP authentication
	$mail->SMTPAuth = true;
	//Enable encryption, 'ssl' also accepted
	$mail->SMTPSecure = 'ssl';
	//Username to use for SMTP authentication
	$mail->Username = $from;
	//Password to use for SMTP authentication
	$mail->Password = $password;
	//Set who the message is to be sent from
	$mail->setFrom($from, $from);
}

// example:
/*

$mail = new PHPMailer();

PHPMailerSendFromQqConfig($mail, "2951675746@qq.com", "******");

//Set who the message is to be sent to
$mail->addAddress('roxma@qq.com', 'John Doe');

//Set the subject line
$mail->Subject = 'PHPMailer SMTP test';

//Read an HTML message body from an external file, convert referenced images to embedded,
//convert HTML into a basic plain-text alternative body
$mail->msgHTML("<b>roxma test</b>");

//send the message, check for errors
if (!$mail->send()) {
	echo "Mailer Error: " . $mail->ErrorInfo;
} else {
	echo "Message sent!";
}

// */

?>

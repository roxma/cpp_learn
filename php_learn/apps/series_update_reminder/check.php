<?php

require_once dirname(__FILE__) . "/" . '../../libs/rlib/NetUtils.php';

require_once dirname(__FILE__) . "/" . 'PHPMailerSendFromQqConfig.php';
require_once dirname(__FILE__) . "/" . 'Dao.php';

require_once dirname(__FILE__) . "/" . '../common/GetLogger.php';

function Entry(){
	$dao = new Dao();
	ScanRules($dao);
	SendMails($dao);
}

function ScanRules($dao){

	$getRulesIn = new Dao_GetRulesIn();
	$getRulesOut = new Dao_GetRulesOut();
	$dao->GetRules($getRulesIn,$getRulesOut);

	foreach ($getRulesOut->rules as &$item){

		$url = $item["s_url"];
		$pattern = $item["s_pattern"];
		$patternType = $item["s_pattern_type"];
		$lastResult = $item["s_last_result"];

		GetLogger()->info("scanning url[$url] pattern[$pattern] type[$patternType]");

		$currentResult = "";
		
		// load html
		$options = new NetUtilsHttpLoadOptions(); 
		$options->url = $url;
		$options->method = "GET";
		$options->timeoutSeconds = 20; // 20s timeout
		$loadData = "";
		$errorMessage = NetUtilsHttpLoad($options, $loadData);
		if($errorMessage != ""){
			GetLogger()->error("Load remote page error, $errorMessage");
			continue;
		}

		$currentResult = array();

		if($patternType == "preg"){
			// filter
			$output = array();
			preg_match_all($pattern, $loadData, $output);
			$currentResult = $output[0];
		}

		if(count($currentResult)==0){
			GetLogger()->error("scan url[$url] pattern[$pattern] failed, currentResult empty");
			continue;
		}
		$currentResult = json_encode($currentResult);

		GetLogger()->info("remote page scan complete url[$url] pattern[$pattern]");

		// compare with history result
		if($currentResult!=$lastResult){

			GetLogger()->error("update detected url[$url] pattern[$pattern]");

			// store result in db
			$updateLastResultIn = new Dao_UpdateRuleLastResultIn();
			$updateLastResultIn->id = $item["i_rule_id"];
			$updateLastResultIn->lastResult = $currentResult;
			$updateLastResultOout = new Dao_UpdateRuleLastResultOut();
			$dao->UpdateRuleLastResult($updateLastResultIn, $updateLastResultOout);
		}

	}
}

function SendMails($dao){

	$mailUserName = "";
	$mailPassword = "";
	$dao->GetConfig("mail.user_name", $mailUserName);
	$dao->GetConfig("mail.password", $mailPassword);

	$getUsersIn = new Dao_GetUsersToInformUpdateIn();
	$getUsersOut = new Dao_GetUsersToInformUpdateOut();
	$dao->GetUsersToInformUpdate($getUsersIn, $getUsersOut);
	
	$users = $getUsersOut->users;
	GetLogger()->info( count($users) . " users need to inform.");

	foreach ($users as $user){

		$from = $mailUserName;
		$passwrod = $mailPassword;

		$ruleId = $user["i_rule_id"];
		$url = $user["s_url"];
		$pattern = $user["s_pattern"];
		$subscriber = $user["s_subscriber"];
			
		// send mail
		$mail = new PHPMailer();
		PHPMailerSendFromQqConfig($mail, $from, $passwrod);

		//Set who the message is to be sent to
		$mail->addAddress($subscriber, $subscriber);

		//Set the subject line
		$mail->Subject = 'update notify';
		$mail->msgHTML(
				  htmlspecialchars($url)
		);
		if (!$mail->send()) {
			GetLogger()->error("send mail to $subscriber error, url[$url]");
			continue;
		}

		$updateInformTimeIn = new Dao_UpdateUserInformTimeIn();
		$updateInformTimeIn->ruleId = $ruleId;
		$updateInformTimeIn->subscriber = $subscriber;
		$updateInformTimeOut = new Dao_UpdateUserInformTimeOut();
		$dao->UpdateUserInformTime($updateInformTimeIn, $updateInformTimeOut);

	}

}

Entry();

?>

<?php
	
require_once dirname(__FILE__) . '/' . '../common/CgiRequireLogin.php';

require_once dirname(__FILE__) . "/" . 'Dao.php';
require_once dirname(__FILE__) . "/" . '../common/GetLogger.php';

function Entry(){

	$dao = new Dao();

	$getIn = new Dao_GetRulesIn();
	$getIn->user = LoginGetUser();
	$getOut = new Dao_GetRulesOut();

	$addIn->user = LoginGetUser();

	$dao->GetRules($getIn, $getOut);

	CgiOutput($getOut->errorCode,$geeOut->errorMessage, $getOut->rules);
}

Entry();

?>

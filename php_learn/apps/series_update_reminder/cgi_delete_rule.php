<?php
	
require_once dirname(__FILE__) . '/' . '../common/CgiRequireLogin.php';

require_once dirname(__FILE__) . "/" . 'Dao.php';
require_once dirname(__FILE__) . "/" . '../common/GetLogger.php';

function Entry(){

	$ruleId = CgiInput("rule_id","");
	if($ruleId==""){
		CgiOutput(__LINE__,"");
	}

	$dao = new Dao();

	$delIn = new Dao_DeleteRuleIn();
	$delOut = new Dao_DeleteRuleOut();

	$delIn->user = LoginGetUser();
	$delIn->ruleId = $ruleId;

	$dao->DeleteRule($delIn, $delOut);

	CgiOutput($delOut->errorCode,$delOut->errorMessage);
}

Entry();

?>

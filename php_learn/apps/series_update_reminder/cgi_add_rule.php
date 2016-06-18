<?php
	
require_once dirname(__FILE__) . '/' . '../common/CgiRequireLogin.php';

require_once dirname(__FILE__) . "/" . 'Dao.php';
require_once dirname(__FILE__) . "/" . '../common/GetLogger.php';

function Entry(){

	$url = CgiInput("url","");
	if($url==""){
		CgiOutput(__LINE__,"");
	}
	$pattern = CgiInput("pattern","");
	if($pattern==""){
		CgiOutput(__LINE__,"");
	}

	$dao = new Dao();

	$addIn = new Dao_AddRuleIn();
	$addOut = new Dao_AddRuleOut();

	$addIn->creator = LoginGetUser();
	$addIn->url = $url;
	$addIn->pattern = $pattern;

	$dao->AddRule($addIn, $addOut);

	CgiOutput($addOut->errorCode,$addOut->errorMessage);
}

Entry();

?>

<?php

require_once dirname(__FILE__) . '/' . '../libs/rlib/Db.php';

function PhpLearnDbConfig(){
	$config = new DbConfig();
	$config->userName = "root";
	$config->password = "";
	$config->charset = "utf8";
	$config->useDatabase = "php_learn";
	
	return $config;
}

?>
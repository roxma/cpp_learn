<?php
	
require_once dirname(__FILE__) . "/" . '../../libs/rlib/NetUtils.php';
require_once dirname(__FILE__) . "/" . '../common/GetLogger.php';

$url="";
if(isset($_GET["url"])){
	$url = $_GET["url"];
};
if($url==""){
	exit(0);
}


$options = new NetUtilsHttpLoadOptions(); 
$options->url = $url;
$options->method = "GET";
$options->timeoutSeconds = 20; // 20s timeout
$options->headers[] = $_SERVER['HTTP_USER_AGENT'];
$loadData = "";
$errorMessage = NetUtilsHttpLoad($options, $loadData);

// $metaTag = "<meta name=\"Referer\" content=\"$url\">";
//$baseTag = "";

echo $errorMessage;
//echo str_replace("<head>","<head>$baseTag",$loadData);
echo $loadData;


?>

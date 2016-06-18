<?php

require_once '../../libs/rlib/NetUtils.php';

$options = new NetUtilsHttpLoadOptions(); 
$options->url = "www.qq.com";
$loadData = "";
NetUtilsHttpLoad($options, $loadData);
echo $loadData;

?>
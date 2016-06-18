<?php

require_once dirname(__FILE__) . "/" .  '../../libs/rlib/RenderPhpToString.php';

function Entry(){
	$output = "";
	RenderPhpToString( dirname(__FILE__) . "/" . "Render.tpl.php", array("msg"=>"hello world"), $output);

	var_dump($output);

}

Entry();


?>

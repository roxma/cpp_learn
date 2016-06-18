<?php 
	echo "hello world. my name is roxma.";
	
	$a = array();
	$a["hehe"] = NULL;
	var_dump($a);
	
	echo json_encode($a);
	
	unset($a["hehe"]);
	var_dump($a);
?>
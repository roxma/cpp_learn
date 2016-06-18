<?php 

function CgiInput($name, $default){
	if(isset($_GET[$name])){
		return $_GET[$name];
	}else if(isset($_POST[$name])){
		return $_POST[$name];
	}else{
		return $default;
	}
}

?>
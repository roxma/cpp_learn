<?php

function RenderPhpToString($phpFileName, $data, &$outputStr){
	if (!is_file($phpFileName)) {
		return __LINE__;
	}

	ob_start();
	include $phpFileName;
	$outputStr = ob_get_clean();
	if($outputStr === FALSE){
		return __LINE__;
	}

	return 0;
}

?>

<?php 

/**
 * @author roxma
 */


/**
 * 获取本地 IP 地址
 * @return string
 */
function NetUtilsGetLocalIp(){
	return gethostbyname(trim(exec("hostname")));
}


class NetUtilsHttpLoadOptions{
	public		$url = "";
	public		$method = "POST";		/**< support "POST" and "GET" only */
	public		$postData = "";			/**< valid only when $method=="POST" */
	public		$headers = array();		/**< array of string */
	public		$timeoutSeconds = 0;	/**< never timeout by default */
};

/**
 * @param NetUtilsHttpLoadOptions $options
 * @param $loadData
 * @return error message. empty string on success.
 */
function NetUtilsHttpLoad(NetUtilsHttpLoadOptions $options, & $loadData){
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $options->url);

	curl_setopt($ch, CURLOPT_TIMEOUT, $options->timeoutSeconds);

	if(count($options->headers)!=0){
		curl_setopt($ch, CURLOPT_HTTPHEADER, $options->headers);
	}

	// do not output response header in result returned by curl_exec
	curl_setopt($ch, CURLOPT_HEADER, false);
	
	if($options->method=="POST"){
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $options->postData);
	}else{
		curl_setopt($ch, CURLOPT_HTTPGET, 1);
	}
	
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	
	$loadData=curl_exec($ch);
	$errMsg = curl_error($ch);
	curl_close($ch);
	
	if($loadData===FALSE){
		$loadData = "";
		return "curl_exec failed: " . $errMsg;
	}
	
	return "";
}

?>

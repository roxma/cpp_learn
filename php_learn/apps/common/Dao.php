<?php 

require_once dirname(__FILE__) . '/' . '../../libs/rlib/DbMysqli.php';
require_once dirname(__FILE__) . '/' . '../PhpLearnDbConfig.php';

class CommonDao{
	
	private $db = NULL;
	
	function __construct(){
		$this->db = new DbMysqli(PhpLearnDbConfig());
	}
	
	function SetConfig($name, $value){
		$result = $this->db->Execute(
						  "insert into common_config "
						, " set s_name=", DbWrapStr($name)
						, ", s_value=", DbWrapStr($value)
						, " on duplicate key update s_value=",DbWrapStr($value)
					);
		return $result->errorCode;
	}
	
	function GetConfig($name, &$value){
		$result = $this->db->Execute(
				" select * from common_config "
				, " where s_name=", DbWrapStr($name)
		);
		if($result->errorCode){
			return $result->errorCode;
		}
		if(count($result->selectResult)==0){
			$value = "";
			return 0;
		}
		$value = $result->selectResult[0]["s_value"];
		return 0;
	}
	
};

?>

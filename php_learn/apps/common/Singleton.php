<?php 
require_once dirname(__FILE__) . '/' . '../PhpLearnDbConfig.php';

/// protable

require_once dirname(__FILE__) . '/' . '../../libs/rlib/Db.php';

class CommonSingleton{
	
	private $db = NULL;
	private $tableName = "";
	
	//////////////////////////////
	function __construct($dbConfig=NULL, $tableName="common_singleton"){
		if($dbConfig==NULL)
			$this->db = new Db(PhpLearnDbConfig());
		else 
			$this->db = new Db($dbConfig);
		
		$this->tableName = $tableName;
	}
	
	function Init($name){
		$result = $this->db->Begin();
		if($result->errorCode){
			return __LINE__;
		}
		
		$result = $this->db->Execute("select * from " . $this->tableName 
			, " where s_name=", DbWrapStr($name), " for update");
		
		return $result->errorCode;
	}
	
};

?>
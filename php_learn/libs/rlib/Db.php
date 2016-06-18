<?php

/**
 * A simplified wrapper for php mysqli API.
 * @author roxma
 */

class DbConfig{
	var $host = '127.0.0.1';
	var $port = 3306;
	var $userName = "root";
	var $password = "";
	var $useDatabase = "";
	var $charset = "utf-8";
};

/**
 * Internal class
 */
class DbWrapStringHelper{
	public $value;
	function __construct($value){
		$this->value=$value;
	}
};

/**
 * The same as DbEscape
 * @param unknown $str
 * @return DbWrapStringHelper
 */
function DbWrapStr($str){
	return new DbWrapStringHelper($str);
}

class DbResult{
	public $errorCode = 0;
	public $errorMessage = "";

	/**
	 * The executed statement
	 */
	public $statement = "";
	
	/**
	 * The result for update statement
	 */
	public $affectedRows = 0;
	
	/**
	 * the result for select statement. for example:
	 * array(
	 *     array("id"=>"1", "value"=>"value1")
	 *   , array("id"=>"2", "value"=>"value2")
	 * );
	 */
	public $selectResult = array();
};


?>

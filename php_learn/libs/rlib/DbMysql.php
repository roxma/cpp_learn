<?php

require_once dirname(__FILE__) . "/" . 'Db.php';

if(defined('E_DEPRECATED'))
	error_reporting(E_ALL & ~E_NOTICE^E_DEPRECATED);
else    
	error_reporting(E_ALL & ~E_NOTICE);

class DbMysql{
	
	private $dbConfig;
	
	function __construct(DbConfig $dbConfig){
		$this->dbConfig = $dbConfig;
	}
	
	function __destruct(){
		$this->Reset();
	}
	
	private $mysqlLink = NULL;
	
	/**
	 * @return DbResult
	 */
	private function Init(){
		
		$result = new DbResult();
		
		if($this->mysqlLink == NULL){

			$this->mysqlLink = mysql_connect(
							  $this->dbConfig->host . ":" . $this->dbConfig->port
							, $this->dbConfig->userName
							, $this->dbConfig->password
						);
			if( ! $this->mysqlLink ){
				
				$result->errorCode = __LINE__;
				$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
							. 'Could not connect: ' . mysql_error($this->mysqlLink);
				
				mysql_close($this->mysqlLink);
				$this->mysqlLink = NULL;
				
				return $result;
			}

			if( $this->dbConfig->useDatabase != "" ){
				$selectDb = mysql_select_db($this->dbConfig->useDatabase, $this->mysqlLink);
				if( !$selectDb ){
					$result->errorCode = __LINE__;
					$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
								. 'Choose database fail: ' . mysql_error($this->mysqlLink);
					
					mysql_close($this->mysqlLink);
					$this->mysqlLink = NULL;
					
					return $result;
				}
			}
			
			$setCharset = mysql_set_charset ($this->dbConfig->charset, $this->mysqlLink);
			if(!$setCharset){
				$result->errorCode = __LINE__;
				$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
							. 'Could not set charset to ' .  $this->dbConfig->charset 
							. ", error: " . mysql_error($this->mysqlLink);
				
				mysql_close($this->mysqlLink);
				$this->mysqlLink = NULL;
				
				return $result;
			}
			
			return $result;
			
		}else{ // $this->mysqlLink != NULL
			return $result;
		}
	}
	
	/**
	 * Reset db connection.
	 */
	public function Reset(){
		if($this->mysqlLink){
			mysql_close($this->mysqlLink);
			$this->mysqlLink = NULL;
		}
	}
	
	public function GetLastError(){
		return mysql_error($this->mysqlLink);
	}

	private function QueryStatementAppend(& $query, $append){
		if($append instanceof DbWrapStringHelper){
			$query = $query . '"' . mysql_real_escape_string( $append->value, $this->mysqlLink ) . '"';
		}else if(is_array($append)){
			foreach ($append as $item){
				$this->QueryStatementAppend($query, $item);
			}
		}else{
			$query = $query . $append;
		}
	}
	
	/**
	 * @return DbResult
	 */
	public function Execute(){
	
		$result = new DbResult();
		
		$initResult = $this->Init();
		if($initResult->errorCode){
			
			$result->errorCode = __LINE__;
			$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
					. 'init failed: ' . $initResult->errorCode . ":" . $initResult->errorMessage;
			
			return $result;
		}
		
		$query = "";
		
		for($i = 0; $i<func_num_args(); ++$i){
			$param = func_get_arg($i);
			
			if(!isset($param)){
				$result->errorCode = __LINE__;
				$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
					. "invalid parameter index " . $i;
				return $result;
			}
			
			$this->QueryStatementAppend($query, $param);
		}
		
		$result->statement = $query;
		
		$queryResult = mysql_query($query, $this->mysqlLink);
		
		if($queryResult==FALSE){
			$result->errorCode = __LINE__;
			$result->errorMessage = "[" . __FILE__ . "]:[" . __FUNCTION__ . "]: "
					. "query error[" . mysql_errno($this->mysqlLink) . "] " . mysql_error($this->mysqlLink);
			return $result;
		}
		

		$result->affectedRows = mysql_affected_rows($this->mysqlLink);
	
		// fill $result->selectResult
		if( is_resource($queryResult) ){
			while ($row = mysql_fetch_assoc($queryResult)){
				$result->selectResult[] = $row;
			}
			mysql_free_result($queryResult);
		}
		
		return $result;
	}

	/**
	 * begin transaction
	 * @return DbResult
	 */
	public function Begin(){
		return $this->Execute("start transaction");
	}
	
	/**
	 * @return DbResult
	 */
	public function RollBack(){
		return $this->Execute("rollback");
	}
	
	/**
	 * @return DbResult
	 */
	public function Commit(){
		return $this->Execute("commit");
	}
	
};

?>

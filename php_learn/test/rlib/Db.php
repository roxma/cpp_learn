<?php

require_once '../../libs/rlib/DbMysql.php';

function Entry(){

	$config = new DbConfig();
	$config->userName = "root";
	$config->password = "";
	$config->charset = "utf8";
	$config->useDatabase = "php_learn";

	$db = new DbMysql($config);

	$initialRows = array( array("id"=>1, "message"=>"Hello 1") , array("id"=>2, "message"=>"Hello 2") , array("id"=>3, "message"=>"Hello 3"));

	ResetTable($db, $initialRows);

	$result = $db->Execute("select * from db_test");
	if($result->errorCode || (count($result->selectResult)!=count($initialRows))){
		die("select fail");
	}

	// ussage 2
	$query= array();
	$query[] = "  id=";
	$query[] = DbWrapStr( $initialRows[0]["id"]);
	$result = $db->Execute( "select * from db_test where ", $query);
	if($result->errorCode || (count($result->selectResult)!=1) || ($result->selectResult[0]["message"] != $initialRows[0]["message"])){
		die("select fail" );
	}

	echo "test ok!\n";
}


function ResetTable($db, $initialRows){
	
	$result = $db->Execute("drop table if exists db_test");
	if($result->errorCode){
		die("drop table fail, errorCode=".$result->errorCode.", errorMessage=".$result->errorMessage);
	}

	$result = $db->Execute("create table db_test(id bigint primary key, message varchar(1024) not null default '')engine=Innodb, charset=utf8");
	if($result->errorCode){
		die("create table fail");
	}

	// rollback test
	$result = $db->Begin();
	if($result->errorCode){
		var_dump($result);
		die("begin transaction error.");
	}

	foreach($initialRows as $row){
		$result = $db->Execute("insert into db_test "
			, " set id=", DbWrapStr($row["id"])
			, ", message=", DbWrapStr($row["message"])
		);
		if( $result->errorCode || ($result->affectedRows!=1)){
			die( "error: ". $db->GetLastError(). ", sql:". $result->statement);
		}
	}

	$result = $db->RollBack();
	if($result->errorCode){
		var_dump($result);
		die("rollback error.");
	}


	// commit test
	$result = $db->Begin();
	if($result->errorCode){
		var_dump($result);
		die("begin transaction error.");
	}

	foreach($initialRows as $row){
		$result = $db->Execute("insert into db_test "
			, " set id=", DbWrapStr($row["id"])
			, ", message=", DbWrapStr($row["message"])
		);
		if( $result->errorCode || ($result->affectedRows!=1)){
			die( "error: ". $db->GetLastError(). ", sql:". $result->statement);
		}
	}
	
	$result = $db->Commit();
	if($result->errorCode){
		var_dump($result);
		die("commit error.");
	}

}

Entry();
exit(0);

?>

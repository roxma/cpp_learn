<?php 

require_once dirname(__FILE__) . '/' . '../../libs/rlib/Db.php';
require_once dirname(__FILE__) . '/' . '../PhpLearnDbConfig.php';

class AppointmentDao{
	
	private $db = NULL;
	
	function __construct(){
		$this->db = new MysqlDb(PhpLearnDbConfig());
	}
	
	function CreateIssue(AppointmentDaoCreateIssueInput $input, AppointmentDaoCreateIssueOutput $output){
		$result = $this->db->Execute(
				"insert into appointment_issue "
				, " set s_name=", DbWrapStr($input->name)
				, ", s_desc=", DbWrapStr($input->desc)
				, ", s_creator=", DbWrapStr($input->creator)
				, ", d_create_time=now()"
		);
		return $result->errorCode;
	}
	
	function CreateSubIssue(AppointmentDaoCreateSubIssueInput $input, AppointmentDaoCreateSubIssueOutput $output){
		if($this->db->Begin()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		$result = $this->db->Execute("select * from appointment_issue where issue_id=", DbWrapStr($input->issueId));
		if($result->errorCode || (count($result->selectResult)!=1) ){
			$this->db->RollBack();
			return __LINE__;
		}
		$nextId = $result->selectResult[0]["i_next_sub_id"];
		
		$result = $this->db->Execute("update appointment_issue set i_next_sub_id=i_next_sub_id+1 where issue_id=", DbWrapStr($input->issueId));
		if($result->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		$result = $this->db->Execute("insert into appointment_sub_issue "
				, " set issue_id=", DbWrapStr($input->issueId)
				, ", sub_issue_id=", DbWrapStr($nextId)
				, ", s_name=", DbWrapStr($input->name)
				, ", s_desc=", DbWrapStr($input->desc)
				, ", i_cur_request=0"
				, ", i_max_request=", DbWrapStr($input->max)
				, ", s_field_list_json=", DbWrapStr($input->fields)
				, ", d_create_time=now()"
		);
		if($result->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		if($this->db->Commit()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		return 0;
	}
	
	function CreateRequest(AppointmentDaoCreateRequestInput $input, AppointmentDaoCreateRequestOutput $output){
		
		if($this->db->Begin()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		// lock
		$result = $this->db->Execute("select * from appointment_issue where issue_id=", DbWrapStr($input->issueId), " for update");
		if($result->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		$result = $this->db->Execute("select * from appointment_request where issue_id=", DbWrapStr($input->issueId)
				, " and i_validated=1 and s_mail=", DbWrapStr($input->mail));
		if(count($result->selectResult)>0){
			$output->errorMessage = $input->mail . " 在这个主题中已经预约过了。";
			$this->db->RollBack();
			return __LINE__;
		}
		
		$result = $this->db->Execute("select * from  appointment_sub_issue "
				, " where issue_id=", DbWrapStr($input->issueId)
				, " and sub_issue_id=", DbWrapStr($input->subIssueId)
				, " and i_cur_request>=i_max_request"
		);
		if($result->errorCode || (count($result->selectResult)>0)){
			$output->errorMessage = " 人数已满。";
			$this->db->RollBack();
			return __LINE__;
		}
		
		$result = $this->db->Execute(
			" REPLACE into appointment_request "
			, " set issue_id=", DbWrapStr($input->issueId)
			, ", sub_issue_id=", DbWrapStr($input->subIssueId)
			, ", s_mail=", DbWrapStr($input->mail)
			, ", d_create_time=now()"
			, ", s_fields_json=", DbWrapStr($input->fields)
			, ", s_validate_key=", DbWrapStr($input->validateKey)
		);
		if($result->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		if($this->db->Commit()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		return $result->errorCode;
	}
	
	function Validate(AppointmentDaoValidateInput $input, AppointmentDaoValidateOutput $output){
		if($this->db->Begin()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		// lock
		$result = $this->db->Execute("select * from appointment_issue where issue_id=", DbWrapStr($input->issueId), " for update");
		if($result->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		// 检查是否已经预约过
		$result = $this->db->Execute("select * from appointment_request where issue_id=", DbWrapStr($input->issueId)
				, " and i_validated=1 and s_mail=", DbWrapStr($input->mail));
		if($result->errorCode || (count($result->selectResult)>0)){
			$output->errorMessage = $input->mail . " 在这个主题中已经预约过了。";
			$this->db->RollBack();
			return __LINE__;
		}
		
		// 检查人数
		$result = $this->db->Execute("select * from  appointment_sub_issue "
				, " where issue_id=", DbWrapStr($input->issueId)
				, " and sub_issue_id=", DbWrapStr($input->subIssueId)
				, " and i_cur_request>=i_max_request"
		);
		if($result->errorCode || (count($result->selectResult)>0)){
			$output->errorMessage = " 人数已满。";
			$this->db->RollBack();
			return __LINE__;
		}
		
		// 改为已验证
		$result = $this->db->Execute("update appointment_request set i_validated=1 "
				, " where issue_id=", DbWrapStr($input->issueId)
				, " and sub_issue_id=", DbWrapStr($input->subIssueId)
				, " and i_validated=0 and s_mail=", DbWrapStr($input->mail)
		);
		if($result->errorCode || ($result->affectedRows!=1)){
			$this->db->RollBack();
			return __LINE__;
		}
		
		// 更新人数
		$result = $this->db->Execute("update appointment_sub_issue set i_cur_request=i_cur_request+1 "
				, " where issue_id=", DbWrapStr($input->issueId)
				, " and sub_issue_id=", DbWrapStr($input->subIssueId)
		);
		if($result->errorCode || ($result->affectedRows!=1)){
			$this->db->RollBack();
			return __LINE__;
		}
		
		if($this->db->Commit()->errorCode){
			$this->db->RollBack();
			return __LINE__;
		}
		
		return 0;
	}
	

	function GetIssues(AppointmentDaoGetIssuesInput $input, AppointmentDaoGetIssuesOutput $output){
		$result = $this->db->Execute("select * from appointment_issue");
		$output->issues = $result->selectResult;
		return $result->errorCode;
	}
	
	function GetInfo(AppointmentDaoGetInfoInput $input, AppointmentDaoGetInfoOutput $output){
		$result = $this->db->Execute(
				"select * from  appointment_issue "
				, " where issue_id =", DbWrapStr($input->issueId)
		);
		if($result->errorCode){
			return __LINE__;
		}
		$output->issueInfo = $result->selectResult[0];
		
		$result = $this->db->Execute(
				"select * from  appointment_sub_issue "
				, " where issue_id =", DbWrapStr($input->issueId)
		);
		if($result->errorCode){
			return __LINE__;
		}
		$output->subIssues = $result->selectResult;
		
		$result = $this->db->Execute(
				"select * from  appointment_request "
				, " where issue_id =", DbWrapStr($input->issueId)
		);
		if($result->errorCode){
			return __LINE__;
		}
		$output->requests = $result->selectResult;
		
		return 0;
	}
	
	function GetUnMailedRequest(& $requests){
		$result = $this->db->Execute("select * from appointment_request where i_mail_sended=0");
		$requests = $result->selectResult;
		return $result->errorCode;
	}
	function SetMailSended($request, $code){
		$result = $this->db->Execute("update appointment_request set i_mail_sended= ", DbWrapStr($code)
				, " where issue_id=", DbWrapStr($request["issue_id"])
				, " and sub_issue_id=", DbWrapStr($request["sub_issue_id"])
				, " and s_mail=", DbWrapStr($request["s_mail"])
		);
		return $result->errorCode;
	}
	
};

class AppointmentDaoCreateIssueInput{
	public $name = "";
	public $desc = "";
	public $creator = "";		/* 创建者的 email */
};
class AppointmentDaoCreateIssueOutput{
	public $errorMessage = "";
};


class AppointmentDaoGetIssuesInput{
};
class AppointmentDaoGetIssuesOutput{
	public $issues = array();
	public $errorMessage = "";
};
class AppointmentDaoGetInfoInput{
	public $issueId;
};
class AppointmentDaoGetInfoOutput{
	public $issueInfo = array();
	public $subIssues = array();
	public $requests = array();
	public $errorMessage = "";
};

class AppointmentDaoCreateSubIssueInput{
	public $issueId = 0;
	public $name = "";
	public $desc = "";
	public $max = 0;
	public $fields = "";	/* json 格式的字符串 */
};
class AppointmentDaoCreateSubIssueOutput{
	public $errorMessage = "";
};

class AppointmentDaoCreateRequestInput{
	public $issueId = 0;
	public $subIssueId = 0;
	public $mail = "";
	public $fields = "";
	public $validateKey = "";
};
class AppointmentDaoCreateRequestOutput{
	public $errorMessage = "";
};


class AppointmentDaoValidateInput{
	public $issueId = 0;
	public $subIssueId = 0;
	public $mail = "";
	public $validateKey = "";
};
class AppointmentDaoValidateOutput{
	public $errorMessage = "";
};

>?
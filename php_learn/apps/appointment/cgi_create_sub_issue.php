<?php
	
require_once dirname(__FILE__) . '/' . 'CgiCommon.php';
require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
require_once dirname(__FILE__) . '/' . 'Dao.php';

$input = new AppointmentDaoCreateSubIssueInput();
$output = new AppointmentDaoCreateSubIssueOutput();

$input->issueId = CgiInput("issue_id", "");
$input->name = CgiInput("name", "");
$input->desc = CgiInput("desc", "");
$input->fields = CgiInput("fields", "[]");
$input->max = CgiInput("max", "");

if($input->name==""){
	CgiOutput(__LINE__,"标题不能为空");
}

$dao = new AppointmentDao();
$error = $dao->CreateSubIssue($input, $output);

CgiOutput($error, $output->errorMessage);

?>
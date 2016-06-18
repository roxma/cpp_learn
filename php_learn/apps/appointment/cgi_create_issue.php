<?php
	
require_once dirname(__FILE__) . '/' . 'CgiCommon.php';
require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
require_once dirname(__FILE__) . '/' . 'Dao.php';

$input = new AppointmentDaoCreateIssueInput();
$output = new AppointmentDaoCreateIssueOutput();

$input->name = CgiInput("name", "");
$input->desc = CgiInput("desc", "");
$input->creator = CgiInput("creator", "");

if($input->name==""){
	CgiOutput(__LINE__,"标题不能为空");
}

$dao = new AppointmentDao();
$error = $dao->CreateIssue($input, $output);

CgiOutput($error, $output->errorMessage);

?>
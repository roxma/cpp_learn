<?php
	
require_once dirname(__FILE__) . '/' . 'CgiCommon.php';
require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
require_once dirname(__FILE__) . '/' . 'Dao.php';

$input = new AppointmentDaoGetInfoInput();
$output = new AppointmentDaoGetInfoOutput();

$input->issueId = CgiInput("issue_id", "");


$dao = new AppointmentDao();
$error = $dao->GetInfo($input, $output);

$data = array();

$data["issue_info"] = $output->issueInfo;
$data["sub_issues"]= $output->subIssues;
$data["requests"] = $output->requests;

CgiOutput($error, $output->errorMessage,$data);

?>
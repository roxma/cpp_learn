<?php
	
require_once dirname(__FILE__) . '/' . 'CgiCommon.php';
require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
require_once dirname(__FILE__) . '/' . 'Dao.php';

$input = new AppointmentDaoGetIssuesInput();
$output = new AppointmentDaoGetIssuesOutput();

$input->issueId = CgiInput("issue_id", "");


$dao = new AppointmentDao();
$error = $dao->GetIssues($input, $output);

$data = array();

$data["issues"] = $output->issues;

CgiOutput($error, $output->errorMessage,$data);

?>
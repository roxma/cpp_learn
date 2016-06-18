<?php
	require_once dirname(__FILE__) . '/' . 'CgiCommon.php';

	require_once dirname(__FILE__) . '/' . 'Dao.php';
	require_once dirname(__FILE__) . '/' . '../../libs/rlib/Cgi.php';
	
	$input= new AppointmentDaoValidateInput();
	$output = new AppointmentDaoValidateOutput();

	$input->issueId = CgiInput("issue_id", "");
	$input->subIssueId = CgiInput("sub_issue_id", "");
	$input->mail = CgiInput("mail", "");

	$input->validateKey = CgiInput("validate_key", "");

	$dao = new AppointmentDao();
	$error = $dao->Validate($input, $output);
	CgiOutput($error, $output->errorMessage);
?>
<?php 

require_once dirname(__FILE__) . "/" . "../../libs/log4php-2.3.0/Logger.php";

/**
 * @return Logger
 */
function GetLogger(){
	return Logger::getLogger('logger');
}

function GetLoggerInit(){
	$configArr = 
	array(
			'appenders' => array(
					'rollingFileAppender' => array(
							'class' => 'LoggerAppenderRollingFile',
							'layout' => array(
									'class' => 'LoggerLayoutPattern',
									'params' => array(
											'conversionPattern' => '[%date{Y-m-d H:i:s,u}] [%file:%line] [%le] sid[%sid] %message%newline'
									)
							)
							
							, 'params' => array(
									  'maxFileSize' => "10MB"
									, 'maxBackupIndex' => "5"
									, 'file' => 'unname.log'
							)
					)
					
					, 'consoleAppender' => array(
							'class' => 'LoggerAppenderConsole',
							'layout' => array(
									'class' => 'LoggerLayoutPattern',
									'params' => array(
											'conversionPattern' => '[%date{Y-m-d H:i:s,u}] [%file:%line] [%le] sid[%sid] %message%newline'
									)
							)
					)
			),
			'rootLogger' => array(
					'appenders' => array('consoleAppender')
			),
			
			'loggers' => array(
				'logger' => array( 'appenders' => array('rollingFileAppender') )
			),
	);
	
	Logger::configure($configArr);
	
	// Fetch a logger, it will inherit settings from the root logger
	$log = Logger::getLogger('logger');

	$rollingFileAppender = $log->getAppender("rollingFileAppender");
	
	// 支持按照  cgi的脚本文件名 来区分日志文件
	$tmpScriptName = $_SERVER["SCRIPT_NAME"];
	$tmpScriptName = str_replace("/","_",$tmpScriptName);
	$tmpScriptName = str_replace("\\","_",$tmpScriptName);
	$fileName = "default.log";
	if($tmpScriptName != ""){
		$fileName = $tmpScriptName;
	}

	// 参考 http://stackoverflow.com/questions/15666893/log4php-file-size-error
	// 由于 LoggerAppenderRollingFile 的问题，这里必须使用绝对路径
	// $fileName = dirname(__FILE__) . "/" . "../log/" . $fileName;
	$fileName = "/data/logs/" . $fileName;
	
	$rollingFileAppender->setFile($fileName);
}

GetLoggerInit();

?>

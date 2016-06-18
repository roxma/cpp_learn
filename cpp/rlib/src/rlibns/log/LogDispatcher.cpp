#include "rlibns/log/LogDispatcher.h"

#include "rlibns/log/LogLine.h"
using rlibns::log::LogLine;

#include <string>
using std::string;

#include <iostream>
using std::cout;
using std::endl;

namespace rlibns{ namespace log{

void LogDispatcher::OnLogLine(const rlibns::log::LogLine& logLine){
	if(GetAppenderCount() == 0){
		cout<< "[ "
				<<logLine.GetPrettyFunction()
			<<" ] [ "
				<<logLine.GetFileName()
			<<" "
				<<logLine.GetLineNumber()
			<<" ] "
			<<logLine.GetStringStream().str()
			<<endl;
	}
}

void LogDispatcher::OnLogCaptureInfoPush(const LogCaptureInfo& inLogCaptureInfo){

}

void LogDispatcher::OnLogCaptureInfoPop(const LogCaptureInfo& inLogCaptureInfo){

}

LogDispatcher::~LogDispatcher(){

}

}} // namespace rlibns::log

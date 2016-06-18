#ifndef RLIBNS_LOG_LOGAPPENDER_H
#define RLIBNS_LOG_LOGAPPENDER_H

#include <stdint.h>

#include <vector>

#include "rlibns/log/LogLine.h"
namespace rlibns{ namespace log{
	class LogLine;
}}

#include "rlibns/log/LogCapture.h"
namespace rlibns{ namespace log{
	struct LogCaptureInfo;
}}


namespace rlibns{ namespace log{

class LogAppender{
public:
	virtual int32_t OnLogLine(
						  const LogLine& logLine
						, const std::vector<rlibns::log::LogCaptureInfo*>& LogCaptures
						, size_t threadId
					) = 0;
	virtual ~LogAppender(){}


};

}}

#endif

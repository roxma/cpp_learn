#ifndef RLIBNS_LOG_LOGDISPATCHER
#define RLIBNS_LOG_LOGDISPATCHER

#include <stdint.h>
// type size_t

#include "rlibns/log/LogLine.h"
namespace rlibns{ namespace log{
	class LogLine;
}}

#include "rlibns/log/LogAppender.h"

#include "rlibns/log/LogCapture.h"
namespace rlibns{ namespace log{
	class LogCaptureInfo;
}}

#include <string>

namespace rlibns { namespace log{

class LogDispatcher{

public:

	/**
	 * Handle a LogLine event, this function is thread safe.
	 */
	virtual void OnLogLine(const rlibns::log::LogLine& logLine);
	
	/**
	 * Handle a LogCapture push event, this function is thread safe.
	 */
	virtual void OnLogCaptureInfoPush(const LogCaptureInfo& inLogCaptureInfo);

	/**
	 *
	 */
	virtual void OnLogCaptureInfoPop(const LogCaptureInfo& outLogCaptureInfo);
	
	virtual size_t GetAppenderCount()				{ return 0;				}
	virtual LogAppender* GetAppender(size_t index)	{ return (LogAppender*)0;	}

	virtual ~LogDispatcher();
};

}}

#endif

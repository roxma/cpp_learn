#ifndef RLIBNS_LOG_LOGCAPTURE_H
#define RLIBNS_LOG_LOGCAPTURE_H

#include <stdint.h>
#include <string>

#include "rlibns/log/LogDispatcher.h"
namespace rlibns{ namespace log{
	class LogDispatcher;
}} // namespace rlibns::log

namespace rlibns{ namespace log{

/**
 * @struct Log capture information. Name - value pair.
 */
struct LogCaptureInfo{
	const char * const				fileName;
	const char * const				functionName;
	const size_t					lineNumber;
	const char * const				prettyFunction;
	std::string						name;
	std::string						value;

	LogCaptureInfo(
			  const char*			inFileName
			, const char*			inFunctionName
			, size_t				inLineNumber
			, const char*			inPrettyFunction
			, const std::string&	inName
			, const std::string&	inValue
		)	: fileName(inFileName)
			, functionName(inFunctionName)
			, lineNumber(inLineNumber)
			, prettyFunction(inPrettyFunction)
			, name(inName)
			, value(inValue)
			{}
};

struct LogCaptureGuard: protected LogCaptureInfo{
	LogDispatcher& dispatcher;
	LogCaptureGuard(
			  const char*			inFileName
			, const char*			inFunctionName
			, size_t				inLineNumber
			, const char*			inPrettyFunction
			, const std::string&	inName
			, const std::string&	inValue
			, LogDispatcher&		inoutDispatcher
		);
	~LogCaptureGuard();
};

}}	// namespace rlibns::log


#endif

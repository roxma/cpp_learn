#include "rlibns/log/LogLine.h"

#include <iosfwd>
using std::streambuf;

#include <string>
using std::string;

#include "rlibns/log/LogDispatcher.h"
using rlibns::log::LogDispatcher;

namespace rlibns{ namespace log {

LogLine::~LogLine(){
	if(!thisLogDone)
		logDispatcher.OnLogLine(*this);
}

}} // namespace rlibns::log

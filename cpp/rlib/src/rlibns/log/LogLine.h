#ifndef RLIBNS_LOG_LOGLINE_H
#define RLIBNS_LOG_LOGLINE_H

#include <sstream>
#include <string>
#include <stdint.h>

#include "rlibns/log/LogDispatcher.h"
namespace rlibns{ namespace log{
	class LogDispatcher;
}}


namespace rlibns{ namespace log{


class LogLine {

private:
	rlibns::log::LogDispatcher& 	logDispatcher;
	const char * const				fileName;
	const char * const				functionName;
	const std::size_t				lineNumber;
	const int 						level;
	const char * const				prettyFunction;

	bool							thisLogDone;

	/**
	 * the GetStringStream is a const member function,
	 */
	mutable std::ostringstream oss;

public:

	virtual LogDispatcher& GetLogDispatcher() const	{return logDispatcher;}
	virtual const char* GetPrettyFunction() const	{ return prettyFunction; }
	virtual const char* GetFileName() const			{ return fileName;}
	virtual std::size_t GetLineNumber()	 const		{ return lineNumber;}
	virtual int GetLevel() const					{ return level; }

	/**
	 * If you hava your own LogLine class derived from this class, And you need to
	 * call LogDispatcher::OnLogLine in you own destructor, you should set this
	 * variable to false after you call it, so that OnLogLine won't be called agained.
	 */
	virtual void SetThisLogDone(bool val=false)	{ thisLogDone=val;		}
	virtual bool GetThisLogDone() const			{ return thisLogDone;	}

	/**
	 * If LogLine derives from std::ostringstream, you create a temporary LogLine
	 * object and then use the object like:
	 * <pre>
	 * LogLine(...)<<"This is a line of log";
	 * </pre>
	 * Then the result may be undesirable! Thus we use this member function and a
	 * mutable std::ostringstream member to work around, for example: <pre>
	 * LogLine(...).GetStringStream()<<"This is a line of log";
	 * </pre>
	 */
	virtual std::ostringstream& GetStringStream() const		{ return oss; }

	/**
	 * @param ref_LogDispatcher
	 * @param cstr_fineName[in] This parameter should be set with the standard macro
	 *   __FILE__.
	 * @param cstr_functionName should be set with the standard macro __FUNCTION__.
	 * @param size_lineNumber[in] This parameter should be set with the standard macro
	 *   __LINE__.
	 * @param i_level[in] The logging security level of this line.
	 * @param cstr_prettyFunction[in] It should be set to __PRETTY_FUNCTION__, a
	 *   predefined macro provided by gcc.
	 */
	explicit LogLine(
			  LogDispatcher&		ref_LogDispatcher
			, const char*			cstr_fileName
			, const char*			cstr_functionName
			, const std::size_t		size_lineNumber
			, const int				i_level
			, const char*			cstr_prettyFunction)
					: logDispatcher(ref_LogDispatcher)
					, fileName(cstr_fileName)
					, functionName(cstr_functionName)
					, lineNumber(size_lineNumber)
					, level(i_level)
					, prettyFunction(cstr_prettyFunction)
					, thisLogDone(false)
			{}

	/**
	  * Predefined Logging levels.
	  */
	enum LogLevel{
		  ERROR		= 12
		, WARN		= 8
		, INFO		= 4
	};

	virtual ~LogLine();
};

}} // namespace rlibns::log

#endif // end of header file

//
//  MYDebugMacro.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-25.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#ifndef OnlyUseJSONKit
#   define OnlyUseJSONKit 1
#endif

#ifdef USE_MYDebuger
#   import "LoggerClient.h"
#endif

#ifdef USE_MYDebuger
#   define MYLog(_level, ...) {NSString *MYLogPath = MY_AUTORELEASE([[NSString alloc] initWithBytes:__FILE__ length:strlen(__FILE__) encoding:NSUTF8StringEncoding]);\
NSString *MYLogTag = nil;\
NSArray *array = [MYLogPath componentsSeparatedByString:@"/"];\
NSUInteger index = [array indexOfObject:@"Pods"];\
if (index != NSNotFound) {\
if ([array count] > index + 1) {\
if ([array[index+1] isEqualToString:@".."]) {\
MYLogTag = array[index+2];\
} else {\
MYLogTag = array[index+1];\
}\
}\
}\
if (MYLogTag == nil) {\
MYLogTag = [MYLogPath lastPathComponent];\
}\
LogMessageF( __FILE__,__LINE__,__FUNCTION__, MYLogTag, _level, __VA_ARGS__);\
NSLog(__VA_ARGS__);}
//#   define NSLog(...) MYLog(9, __VA_ARGS__)
#else
#   ifdef __OPTIMIZE__
#       define NSLog(...) /**/
#   endif
#endif


#ifdef USE_MYDebuger
#	define LogDebug(...) MYLog(4, __VA_ARGS__)
#	ifdef TRACE_LOG
#		define LogDebugTrace(...) MYLog(3, __VA_ARGS__)
#	else
#		define LogDebugTrace(...)
#	endif
#	define LogInfo(...) MYLog(2, __VA_ARGS__)
#	define LogWarning(...) MYLog(1, __VA_ARGS__)
#	define LogError(...) MYLog(0,__VA_ARGS__)
#else
#	define LogDebug(...)
#	define TraceDebug(...)
#	define LogInfo(...)
#	define LogWarning(...)
#	define LogError(...)
#   define MYLog(...)
#endif

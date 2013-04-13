//
//  MYMacroDefine.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-24.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#ifndef kMYDateTimeFormat
#   define kMYDateTimeFormat @"yyyy-MM-dd'T'HH:mm:ssZ"
#endif

#ifndef kMYDateFormat
#   define kMYDateFormat @"yyyy-MM-dd"
#endif

#if __has_feature(objc_arc)
#   define MY_AUTORELEASE(exp) exp
#   define MY_RELEASE(exp) exp
#   define MY_RETAIN(exp) exp
#else
#   define MY_AUTORELEASE(exp) [exp autorelease]
#   define MY_RELEASE(exp) [exp release]
#   define MY_RETAIN(exp) [exp retain]
#endif

// performSelector 去除ARC警告
#define MYPerformSelectorWithoutLeakWarningBegin \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
#define MYPerformSelectorWithoutLeakWarningEnd \
_Pragma("clang diagnostic pop")

// Color helpers
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

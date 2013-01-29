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
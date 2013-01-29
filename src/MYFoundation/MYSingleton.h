//
//  MYSingleton.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-23.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#undef	AS_MY_SINGLETON
#define AS_MY_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_MY_SINGLETON
#define DEF_MY_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

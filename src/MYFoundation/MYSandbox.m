//
//  MYSandbox.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYSandbox.h"

@implementation MYSandbox

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
	return [[self libPath] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
	return [[self libPath] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
	return [[self libPath] stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)touch:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
        {
		[[NSFileManager defaultManager] createDirectoryAtPath:path
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
        }
	return path;
}
@end

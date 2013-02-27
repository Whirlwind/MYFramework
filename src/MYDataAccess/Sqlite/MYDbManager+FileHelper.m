//
//  MYDbManager+FileHelper.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-25.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDbManager+FileHelper.h"
#import "VersionString.h"
#import "sys/xattr.h"//iCloud属性设置

@implementation MYDbManager (FileHelper)

#pragma mark - get file path
+ (NSString *)getTmpFile:(NSString *)fileName {
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile =[tmpDirectory stringByAppendingPathComponent:fileName];
    return tmpFile;
}

+ (NSString *)getCacheFile:(NSString *)fileName {
    NSString *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheFile =[cachesPath stringByAppendingPathComponent:fileName];
    return cacheFile;
}

+ (NSString *)getDocumentFile:(NSString *)fileName {
    NSArray *domainDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *writableDBPath = [[domainDir objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return writableDBPath;
}
+ (NSString *)getResourceFile:(NSString *)fileName {
    NSString *resourceDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return resourceDBPath;
}

+ (NSComparisonResult)compareDBDate:(NSString *)_newDBPath oldDBPath:(NSString *)_oldDBPath{
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDate *oldDBDate = [[fm attributesOfItemAtPath:_oldDBPath error:&error] objectForKey:NSFileCreationDate];
	NSDate *newDBDate = [[fm attributesOfItemAtPath:_newDBPath error:&error] objectForKey:NSFileCreationDate];
	NSLog(@"%@:%@ %@ %@:%@", _oldDBPath, oldDBDate, [oldDBDate compare:newDBDate] == NSOrderedSame ? @"=":[oldDBDate compare:newDBDate] == NSOrderedAscending ? @"<":@">", _newDBPath, newDBDate);
	return [newDBDate compare:oldDBDate];
}

#pragma mark - SkipBackupAttribute
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@"5.0.1"]) {
        // for iOS 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@">=5.1"]) {
        // for iOS 5.1 and later
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            LogError(@"ERROR excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    return YES;
}

#pragma mark - copy db
+ (NSString *)copiedBundleDbIsExcludedFromBackupKey:(NSString *)_dbFileName
                                            replace:(BOOL)replace{
    NSString *resourceFile = [self getResourceFile:_dbFileName];
    NSString *documentFile = [self getDocumentFile:_dbFileName];
    NSString *cacheFile = [self getCacheFile:_dbFileName];
    NSString *lastedFile = resourceFile;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFile] && ![[self class] compareDBDate:documentFile oldDBPath:lastedFile] == NSOrderedDescending) {
        lastedFile = documentFile;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile] && ![[self class] compareDBDate:cacheFile oldDBPath:lastedFile] == NSOrderedDescending) {
        lastedFile = cacheFile;
    }
    NSString *toFile = nil;
    if ([VersionString isMatchVersion:[[UIDevice currentDevice] systemVersion] withExpression:@"5.0"]) {
        toFile = cacheFile;
    } else {
        toFile = documentFile;
    }
    NSLog(@"lastedFile: %@ toFile: %@", lastedFile, toFile);
    if ([self copiedDb:lastedFile to:toFile replace:replace]) {
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:toFile]];
    } else {
        return nil;
    }
    if (toFile != documentFile && [[NSFileManager defaultManager] fileExistsAtPath:documentFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:documentFile error:nil];
    }
    if (toFile != cacheFile && [[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:cacheFile error:nil];
    }
    return toFile;
}

+ (NSString *)copiedBundleDbToTmp:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getTmpFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDbToCache:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getCacheFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDbToDocuments:(NSString *)_dbFileName replace:(BOOL)replace{
    return [self copiedBundleDb:_dbFileName to:[self getDocumentFile:_dbFileName] replace:replace];
}

+ (NSString *)copiedBundleDb:(NSString *)_dbFileName to:(NSString *)writableDBPath replace:(BOOL)replace{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getResourceFile:_dbFileName]])
        return nil;
    if ([self copiedDb:[self getResourceFile:_dbFileName] to:writableDBPath replace:replace]) {
        return writableDBPath;
    }
    return nil;
}
+ (BOOL)copiedDb:(NSString *)resourceDBPath to:(NSString *)writableDBPath replace:(BOOL)replace{
    if ([resourceDBPath isEqualToString:writableDBPath]) {
        return YES;
    }
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];

	// 如果文件存在
	if ([fm fileExistsAtPath:writableDBPath]) {
        if (!replace)
            return YES;
		// 如果文件是最新的
		if ([[self class] compareDBDate:resourceDBPath oldDBPath:writableDBPath] == NSOrderedSame)
            return YES;
        else {
            [fm removeItemAtPath:writableDBPath error:&error];
        }
    }
    // copy新数据
    NSLog(@"copy newDB...");
    return [fm copyItemAtPath:resourceDBPath toPath:writableDBPath error:&error];
}

@end

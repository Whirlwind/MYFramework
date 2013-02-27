//
//  MYDbManager+FileHelper.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-25.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYDbManager.h"

@interface MYDbManager (FileHelper)
+ (NSString *)getTmpFile:(NSString *)_dbFileName;
+ (NSString *)getCacheFile:(NSString *)_dbFileName;
+ (NSString *)getDocumentFile:(NSString *)_dbFileName;
+ (NSString *)getResourceFile:(NSString *)_dbFileName;

+ (NSComparisonResult)compareDBDate:(NSString *)_newDBPath
                          oldDBPath:(NSString *)_oldDBPath;

+ (NSString *)copiedBundleDbIsExcludedFromBackupKey:(NSString *)_dbFileName
                                            replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToTmp:(NSString *)_dbFileName
                          replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToDocuments:(NSString *)_dbFileName
                                replace:(BOOL)replace;
+ (NSString *)copiedBundleDbToCache:(NSString *)_dbFileName
                            replace:(BOOL)replace;
+ (NSString *)copiedBundleDb:(NSString *)_dbFileName
                          to:(NSString *)writableDBPath
                     replace:(BOOL)replace;
+ (BOOL)copiedDb:(NSString *)resourceDBPath
              to:(NSString *)writableDBPath
         replace:(BOOL)replace;
@end

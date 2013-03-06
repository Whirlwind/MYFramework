//
//  MYFileStream.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-6.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYFileStream : NSObject

@property (retain, nonatomic) NSData *data;
@property (copy, nonatomic) NSString *mimeType;
@property (copy, nonatomic) NSString *filePath;
@property (copy, nonatomic) NSString *fileName;

+ (MYFileStream *)fileStreamWithFilePath:(NSString *)filePath;
+ (MYFileStream *)fileStreamWithData:(NSData *)data mimeType:(NSString *)mimeType fileName:(NSString *)fileName;

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;
@end

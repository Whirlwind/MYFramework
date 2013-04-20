//
//  MYFileStream.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-3-6.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import "MYFileStream.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MYFileStream

- (NSData *)data {
    if (_data == nil && _filePath != nil) {
        self.data = [NSData dataWithContentsOfFile:_filePath];
    }
    return _data;
}

- (NSString *)fileName {
    if (_fileName == nil && _filePath != nil) {
        return [_filePath lastPathComponent];
    }
    return _fileName;
}

- (NSString *)mimeType {
    if (_mimeType == nil && _filePath != nil) {
        self.mimeType = [[self class] mimeTypeForFileAtPath:_filePath];
    }
    return _mimeType;
}

+ (MYFileStream *)fileStreamWithFilePath:(NSString *)filePath {
    MYFileStream *stream = [[MYFileStream alloc] init];
    [stream setFilePath:filePath];
    return stream;
}

+ (MYFileStream *)fileStreamWithData:(NSData *)data mimeType:(NSString *)mimeType fileName:(NSString *)fileName {
    MYFileStream *stream = [[MYFileStream alloc] init];
    [stream setData:data];
    [stream setMimeType:mimeType];
    [stream setFileName:fileName];
    return stream;
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
	if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
		return nil;
	}
	// Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
	if (!MIMEType) {
		return @"application/octet-stream";
	}
    return (__bridge_transfer id)MIMEType;
}
@end

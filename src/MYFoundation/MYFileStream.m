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

- (void)dealloc {
    [_data release], _data = nil;
    [_fileName release], _fileName = nil;
    [_filePath release], _filePath = nil;
    [_mimeType release], _mimeType = nil;
    [super dealloc];
}

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

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
	if (![[[[NSFileManager alloc] init] autorelease] fileExistsAtPath:path]) {
		return nil;
	}
	// Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
	if (!MIMEType) {
		return @"application/octet-stream";
	}
    return [NSMakeCollectable(MIMEType) autorelease];
}
@end

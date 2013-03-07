//
//  MYEntryJsonAccessProtocol.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-26.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYEntryJsonAccessProtocol <NSObject>

@optional

@property (copy, nonatomic) NSString *modelName;
@property (copy, nonatomic) NSString *modelNameWithPlural;

- (NSString *)deleteAPI;
- (NSString *)updateAPI;
- (NSString *)createAPI;
@end

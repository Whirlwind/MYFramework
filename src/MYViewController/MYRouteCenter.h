//
//  MYRouteCenter.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYRouteCenter : NSObject
@property (retain, nonatomic) NSMutableDictionary *list;
+ (id)sharedInstant;
+ (void)addFileInBundle;

- (void)addFile:(NSString *)path;
- (id)callRoute:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end

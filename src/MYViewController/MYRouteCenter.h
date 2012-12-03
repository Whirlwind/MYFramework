//
//  MYRouteCenter.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYNotification : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) id object;
@property (retain, nonatomic) id userInfo;
- (id)initWithName:(NSString *)name object:(id)object userInfo:(id)userInfo;
+ (id)notificationWithName:(NSString *)name object:(id)object userInfo:(id)userInfo;
@end

@interface MYRouteCenter : NSObject
@property (retain, nonatomic) NSMutableDictionary *list;
+ (id)sharedInstant;
+ (void)addFileInBundle;

- (void)addFile:(NSString *)path;
- (id)callRoute:(NSString *)name object:(id)object userInfo:(id)userInfo;

@end

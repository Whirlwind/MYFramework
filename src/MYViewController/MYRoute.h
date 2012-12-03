//
//  MYRoute.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYRoute : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *path;

- (id)initWithName:(NSString *)name
              path:(NSString *)path;

+ (id)parseFileLine:(NSString *)line;
- (id)executeWithNotification:(MYNotification *)ntf;
@end

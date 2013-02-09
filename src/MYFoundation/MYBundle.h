//
//  MYBundle.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-2-4.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYBundle : NSObject
// 可重载
+ (NSString *)bundleName;
+ (void)changeBundleName:(NSString *)name;

+ (NSString *)resource:(NSString *)name;
+ (UIImage *)image:(NSString *)name;
@end

#define MYBundleImage(__image) [MYBundle image:__image]
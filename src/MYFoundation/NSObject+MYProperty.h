//
//  NSObject+MYProperty.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 13-1-22.
//  Copyright (c) 2013年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MYProperty)
+ (SEL)setterFromPropertyString:(NSString *)property;
+ (SEL)getterFromPropertyString:(NSString *)property;
@end

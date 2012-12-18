//
//  ValueCheckBoxViewCellRuler.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-12-18.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValueCheckBoxViewCellRuler : UIView

- (id)initWithFrame:(CGRect)frame splitNumber:(NSInteger)splitNumber;

@property (assign, nonatomic) NSInteger splitNumber;
@end

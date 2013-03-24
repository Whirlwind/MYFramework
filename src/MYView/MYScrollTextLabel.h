//
//  MYScrollTextLabel.h
//  inice
//
//  Created by Whirlwind James on 12-8-11.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYScrollTextLabel : UIScrollView
@property (retain, nonatomic) UILabel *label;
@property (assign, nonatomic) CGFloat maxScrollWidth;

- (void)setText:(NSString *)text;
- (NSString *)text;
@end

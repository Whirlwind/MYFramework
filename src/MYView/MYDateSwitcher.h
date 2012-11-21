//
//  MYDateSwitcher.h
//  iNice
//
//  Created by Whirlwind James on 12-7-10.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "NSDate+Extend.h"
#import "CGRectAdditions.h"
@protocol MYDateSwitcherDelegate <NSObject>
 @optional
- (void)customTitleLabel:(UILabel *)label atDate:(NSDate *)date;
- (void)dateSwitcherWillChangeFrom:(NSDate *)from to:(NSDate *)to;
- (void)dateSwitcherDidChangedFrom:(NSDate *)from to:(NSDate *)to;
- (NSString *)dateStringForDate:(NSDate *)date;
@end


@interface MYDateSwitcher : UIView
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *lastDate;
@property (nonatomic, assign) IBOutlet id<MYDateSwitcherDelegate> delegate;
@property (retain, nonatomic) NSDate *minDate;
@property (retain, nonatomic) NSDate *maxDate;



- (void)updateDateWithAnimated:(BOOL)animated
                      complete:(void(^)(void))block;
- (void)updateDateWithAnimated:(BOOL)animated;
@end

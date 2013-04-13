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
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, weak) IBOutlet id<MYDateSwitcherDelegate> delegate;
@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;



- (void)updateDateWithAnimated:(BOOL)animated
                      complete:(void(^)(void))block;
- (void)updateDateWithAnimated:(BOOL)animated;
@end

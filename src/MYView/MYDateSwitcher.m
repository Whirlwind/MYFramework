//
//  MYDateSwitcher.m
//  iNice
//
//  Created by Whirlwind James on 12-7-10.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYDateSwitcher.h"
#import "MYDateSwitcherDefine.h"

@implementation MYDateSwitcher

#pragma mark - dealloc
- (void)dealloc{
    [_leftBtn removeFromSuperview];
    [_leftBtn release], _leftBtn = nil;
    [_rightBtn removeFromSuperview];
    [_rightBtn release], _rightBtn = nil;
    [_date release], _date = nil;
    [_lastDate release], _lastDate = nil;
    [_minDate release], _minDate = nil;
    [_maxDate release], _maxDate = nil;
    [super dealloc];
}
#pragma mark - init
- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
        [self initUI];
	}
	return self;
}

- (void)initUI{
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setTag:-1];
    [self.leftBtn addTarget:self
                     action:@selector(changeDateAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setFrame:CGRectMake(0, (self.frame.size.height - kMYDateSwitcherButtonHeight) / 2, kMYDateSwitcherButtonWidth, kMYDateSwitcherButtonHeight)];
    [self.leftBtn setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin];
#ifdef kMYDateSwitcherPrevButtonImageNormal
    [self.leftBtn setImage:[UIImage imageNamed:kMYDateSwitcherPrevButtonImageNormal] forState:UIControlStateNormal];
#endif
    [self addSubview:self.leftBtn];

    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setTag:1];
    [self.rightBtn addTarget:self
                      action:@selector(changeDateAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setFrame:CGRectMake(self.frame.size.width - self.leftBtn.frame.origin.x - self.leftBtn.frame.size.width,
                                       self.leftBtn.frame.origin.y,
                                       self.leftBtn.frame.size.width,
                                       self.leftBtn.frame.size.height)];
    [self.rightBtn setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin];
#ifdef kMYDateSwitcherNextButtonImageNormal
    [self.rightBtn setImage:[UIImage imageNamed:kMYDateSwitcherNextButtonImageNormal] forState:UIControlStateNormal];
#endif
    [self addSubview:self.rightBtn];

    [self setClipsToBounds:YES];
}

#pragma mark - getter
- (NSDate *)maxDate {
    if (_maxDate == nil) {
        self.maxDate = [[[NSDate date] date] addDay:1];
    }
    return _maxDate;
}
#pragma mark - setter
- (void)setDate:(NSDate *)date{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateSwitcherWillChangeFrom:to:)]) {
        [self.delegate dateSwitcherWillChangeFrom:_date to:date];
    }
    self.lastDate = _date;
    [_date release];
    _date = [date retain];
    if (self.minDate && [self.minDate timeIntervalSinceDate:_date]>=0) {
        [self.leftBtn setHidden:YES];
    } else {
        [self.leftBtn setHidden:NO];
    }
    if (self.maxDate && [self.maxDate timeIntervalSinceDate:_date]<=0) {
        [self.rightBtn setHidden:YES];
    } else {
        [self.rightBtn setHidden:NO];
    }
    [self updateDateWithAnimated:YES complete:nil];

}
#pragma mark - event
- (void)changeDateAction:(id)sender {
    UIControl *senderView = (UIControl *)sender;
    NSDate *newDate = [self.date addDay:senderView.tag];
    self.date = newDate;
}
- (NSString *)dateStringForDate:(NSDate *)date {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateStringForDate:)]) {
        return [self.delegate dateStringForDate:date];
    }
    switch ([date daysSince:[[NSDate date] date]]) {
        case 1:
            return @"明天";
        case 0:
            return @"今天";
        case -1:
            return @"昨天";
        default:
            return [date stringWithFormat:@"M月d日"];
    }
}
- (void)updateDateWithAnimated:(BOOL)animated{
    [self updateDateWithAnimated:animated complete:nil];
}
- (void)updateDateWithAnimated:(BOOL)animated
                      complete:(void(^)(void))block{
    UILabel *oldLabel = nil;
    for (UIView *sub in [self subviews]) {
        if ([sub isKindOfClass:[UILabel class]]) {
            oldLabel = (UILabel *)sub;
            break;
        }
    }
    if (oldLabel && oldLabel.tag == [self.date timeIntervalSince1970]) {
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFrameWithWidth:self.bounds.size.width Height:self.bounds.size.height];
    [label setTextColor:kMYDateSwitcherTitleColor];
    [label setFont:[UIFont systemFontOfSize:kMYDateSwitcherTitleSize]];
    [label setText:[self dateStringForDate:self.date]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTag:[self.date timeIntervalSince1970]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTitleLabel:atDate:)]) {
        [self.delegate customTitleLabel:label atDate:self.date];
    }


    [self.leftBtn setEnabled:NO];
    [self.rightBtn setEnabled:NO];

    if (oldLabel != nil && animated) {
        if (label.tag > oldLabel.tag) {
            [label setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + label.frame.size.height)];
        } else {
            [label setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - label.frame.size.height)];
        }
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (label.tag > oldLabel.tag) {
                                 [oldLabel setCenter:CGPointMake(oldLabel.center.x, oldLabel.center.y - oldLabel.frame.size.height)];
                                 [label setCenter:CGPointMake(label.center.x, label.center.y - label.frame.size.height)];
                             } else {
                                 [oldLabel setCenter:CGPointMake(oldLabel.center.x, oldLabel.center.y + oldLabel.frame.size.height)];
                                 [label setCenter:CGPointMake(label.center.x, label.center.y + label.frame.size.height)];
                             }
                         }
                         completion:^(BOOL finished) {
                             [oldLabel removeFromSuperview];
                             [self.leftBtn setEnabled:YES];
                             [self.rightBtn setEnabled:YES];
                             if (self.delegate && [self.delegate respondsToSelector:@selector(dateSwitcherDidChangedFrom:to:)]) {
                                 [self.delegate dateSwitcherDidChangedFrom:self.lastDate
                                                                        to:self.date];
                             }
                             if (block) {
                                 block();
                             }
                         }];

    } else {
        if (oldLabel) {
            [oldLabel removeFromSuperview];
        }
        [label setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];

        [self.leftBtn setEnabled:YES];
        [self.rightBtn setEnabled:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dateSwitcherDidChangedFrom:to:)]) {
            [self.delegate dateSwitcherDidChangedFrom:self.lastDate
                                                   to:self.date];
        }
        if (block) {
            block();
        }
    }

    [label release];
}


@end

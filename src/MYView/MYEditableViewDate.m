//
//  MYEditableViewDate.m
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableViewDate.h"

#import "KalLogic.h"
#import "KalDate.h"
#import "CGRectAdditions.h"

@implementation MYEditableViewDate
- (void)dealloc {
    [self.kalView removeObserver:self forKeyPath:@"frame"];
    [_kalLogic release], _kalLogic = nil;
    [_kalView release], _kalView = nil;
    [_date release], _date = nil;
    [super dealloc];
}

- (void)initUI {
    [super initUI];
    [self.titleLabel setText:@"日期"];
}
#pragma mark - getter
- (KalLogic *)kalLogic {
    if (_kalLogic == nil) {
        _kalLogic = [[KalLogic alloc] initForDate:self.date];
    }
    return _kalLogic;
}

- (KalView *)kalView {
    if (_kalView == nil) {
        _kalView = [[KalView alloc] initWithOrigin:CGPointZero delegate:self logic:self.kalLogic];
        [_kalView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_kalView addObserver:self forKeyPath:@"frame" options:0 context:nil];
    }
    return _kalView;
}

#pragma mark - override

- (void)addKeyboardToShowView {
    if (self.kalView.superview == nil) {
        [[self keyboardView] addSubview:self.kalView];
    }
    [self.keyboardView setFrameWithY:self.keyboardShowView.frame.size.height - self.kalView.frame.size.height];
    [self.keyboardShowView addSubview:self.keyboardView];
}

#pragma mark - delegate
- (void)didSelectDate:(KalDate *)date {
    [self setDate:[date NSDate]];
}
- (void)showPreviousMonth
{
}

- (void)showFollowingMonth
{
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.keyboardShowView == nil) {
        return;
    }
    [self.keyboardView setFrameWithY:self.keyboardShowView.frame.size.height - self.kalView.frame.size.height];
}
@end

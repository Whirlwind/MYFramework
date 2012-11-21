//
//  MYEditableViewDuration.h
//  SPORTRECORD
//
//  Created by Whirlwind on 12-11-21.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableView.h"
#import "ValueCheckBoxView.h"

@interface MYEditableViewDuration : MYEditableView <ValueCheckBoxViewDelegate>
@property (retain, nonatomic) ValueCheckBoxView *minutePickerView;
@property (assign, nonatomic) NSInteger minute;
@end

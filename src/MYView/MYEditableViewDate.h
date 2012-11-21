//
//  MYEditableViewDate.h
//  Weight
//
//  Created by Whirlwind on 12-11-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYEditableView.h"
#import "KalView.h"
#import "NSDate+Extend.h"

@interface MYEditableViewDate : MYEditableView <KalViewDelegate>
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) KalLogic *kalLogic;
@property (retain, nonatomic) KalView *kalView;
@end

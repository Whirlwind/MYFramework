//
//  ValueCheckBoxView.h
//  iNice
//
//  Created by Whirlwind James on 12-7-15.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ValueCheckBoxViewDelegate.h"

@interface ValueCheckBoxView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, retain) NSArray *units;

@property (nonatomic, assign) CGFloat selectedValue;
@property (nonatomic, assign) NSInteger selectedUnitIndex;

@property (assign, nonatomic) CGFloat increaseValuePerCell;

@property (nonatomic, retain) UILabel *valueSelectedLabel;
@property (retain, nonatomic) UILabel *subValueSelectedLabel;
@property (nonatomic, retain) UILabel *unitSelectedLabel;
@property (nonatomic, retain) UITableView *valueSelector;
@property (nonatomic, retain) UIView *unitsView;
@property (retain, nonatomic) UIView *unitSelectedFlagView;
@property (readonly) NSObject *selectedUnit;

@property (assign, nonatomic) IBOutlet id<ValueCheckBoxViewDelegate> delegate;
- (void)updateMinValue:(NSInteger)minValue;
- (void)updateMaxValue:(NSInteger)maxValue;
- (void)updateSelectedValue:(CGFloat)value;
- (void)updateSelectedUnit:(NSObject *)unit;
- (void)updateSelectedUnitIndex:(NSInteger)index;
- (void)updateUnits:(NSArray *)units;
@end

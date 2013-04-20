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
@property (assign, nonatomic) BOOL canSelectMinValue;
@property (assign, nonatomic) BOOL canSelectMaxValue;
@property (nonatomic, strong) NSArray *units;

@property (nonatomic, assign) CGFloat selectedValue;
@property (nonatomic, assign) NSInteger selectedUnitIndex;

@property (assign, nonatomic) CGFloat increaseValuePerCell;
@property (assign, nonatomic) NSInteger splitNumberPerCell;

@property (nonatomic, strong) UILabel *valueSelectedLabel;
@property (strong, nonatomic) UILabel *subValueSelectedLabel;
@property (nonatomic, strong) UILabel *unitSelectedLabel;
@property (nonatomic, strong) UITableView *valueSelector;
@property (nonatomic, strong) UIView *unitsView;
@property (strong, nonatomic) UIView *unitSelectedFlagView;
@property (unsafe_unretained, readonly) NSObject *selectedUnit;

@property (weak, nonatomic) IBOutlet id<ValueCheckBoxViewDelegate> delegate;
- (void)updateMinValue:(NSInteger)minValue;
- (void)updateMaxValue:(NSInteger)maxValue;
- (void)updateSelectedValue:(CGFloat)value;
- (void)updateSelectedUnit:(NSObject *)unit;
- (void)updateSelectedUnitIndex:(NSInteger)index;
- (void)updateUnits:(NSArray *)units;
@end

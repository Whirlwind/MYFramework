//
//  ValueCheckBoxView.m
//  iNice
//
//  Created by Whirlwind James on 12-7-15.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ValueCheckBoxView.h"

#import "ValueCheckBoxViewDefine.h"
#import "CGRectAdditions.h"
#import "ValueCheckBoxViewCellRuler.h"

#define kTagPreValue 100

@implementation ValueCheckBoxView

#pragma mark - dealloc
- (void)dealloc {
    _minValue = -1;
    _maxValue = -1;
    _selectedValue = -1;
    _selectedUnitIndex = -1;
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.increaseValuePerCell = 10;
    self.splitNumberPerCell = 10;
    self.canSelectMinValue = NO;
    self.canSelectMaxValue = NO;
#ifdef kValueCheckBoxHeight
    [self setFrameWithHeight:kValueCheckBoxHeight];
#endif
    
    self.backgroundColor = [UIColor clearColor];
    UIImageView * backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rulerBackground"]];
    backgroundView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 219.0f);
    [self addSubview:backgroundView];
    
    [self addSubview:self.valueSelectedLabel];
    [self addSubview:self.subValueSelectedLabel];
    [self addSubview:self.unitSelectedLabel];
    [self addSubview:self.valueSelector];
    [self setClipsToBounds:YES];

    UIImageView * mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rulerMask"]];
    mask.frame = CGRectMake(0.0f, 63.0f, 320.0f, 101.0f);
    [self addSubview:mask];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kValueCheckBoxViewPointerImage]];
    [image setCenter:CGPointMake(160.0f, 113.0f)];
    [self addSubview:image];

    [self addSubview:self.unitsView];
    [self.unitsView addSubview:self.unitSelectedFlagView];
}

#pragma mark - getter
- (UILabel *)subValueSelectedLabel {
    if (_subValueSelectedLabel == nil) {
        _subValueSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 100, 15)];
        [_subValueSelectedLabel setTag:201209121701];
        [_subValueSelectedLabel setBackgroundColor:[UIColor clearColor]];
        [_subValueSelectedLabel setFont:[UIFont systemFontOfSize:15]];
#ifdef kValueCheckBoxViewSubValueSelectedLabelTextColor
        [_subValueSelectedLabel setTextColor:kValueCheckBoxViewSubValueSelectedLabelTextColor];
#endif
        [_subValueSelectedLabel setHidden:YES];
    }
    return _subValueSelectedLabel;
}

- (UILabel *)valueSelectedLabel {
    if (_valueSelectedLabel == nil) {
        _valueSelectedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_valueSelectedLabel setBackgroundColor:[UIColor clearColor]];
        [_valueSelectedLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
#ifdef kValueCheckBoxViewValueSelectedLabelTextColor
        [_valueSelectedLabel setTextColor:kValueCheckBoxViewValueSelectedLabelTextColor];
#endif
#ifdef kValueCheckBoxViewValueSelectedLabelTextFont
        [_valueSelectedLabel setFont:kValueCheckBoxViewValueSelectedLabelTextFont];
#endif
    }
    return _valueSelectedLabel;
}

- (UILabel *)unitSelectedLabel {
    if (_unitSelectedLabel == nil) {
        _unitSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 44)];
        [_unitSelectedLabel setBackgroundColor:[UIColor clearColor]];
        [_unitSelectedLabel setFont:kValueCheckBoxViewUnitSelectedLabelTextFont];
        [_unitSelectedLabel setTextColor:kValueCheckBoxViewUnitSelectedLabelTextColor];
        [_unitSelectedLabel sizeToFit];
    }
    return _unitSelectedLabel;
}
- (UITableView *)valueSelector {
    if (_valueSelector == nil) {
        _valueSelector = [[UITableView alloc] initWithFrame:CGRectZero];
        [_valueSelector setFrameWithWidth:kValueCheckBoxViewCellWidth Height:kValueCheckBoxViewCellHeight*2*(kValueCheckBoxViewExtendCellNumber + 0.5)];
        [_valueSelector setCenter:CGPointMake(self.frame.size.width/2, 113.5f)];
        [_valueSelector setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        [_valueSelector setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_valueSelector setShowsVerticalScrollIndicator:NO];
        [_valueSelector setRowHeight:kValueCheckBoxViewCellHeight];
        [_valueSelector setDelegate:self];
        [_valueSelector setDataSource:self];
    }
    return _valueSelector;
}
- (UIView *)unitsView {
    if (_unitsView == nil) {
        _unitsView = [[UIView alloc] initWithFrame:CGRectMake(0, 168, self.frame.size.width, 51)];
    }
    _unitsView.backgroundColor = [UIColor clearColor];
 
    return _unitsView;
}

- (UIView *)unitSelectedFlagView {
    if (_unitSelectedFlagView == nil) {
        UIImageView * unitPointer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 18)];
        unitPointer.image = [UIImage imageNamed:@"unitPointer"];
        
        _unitSelectedFlagView = [[UIView alloc] initWithFrame:unitPointer.frame];
        [_unitSelectedFlagView setUserInteractionEnabled:NO];
        [_unitSelectedFlagView setTag:99];
        
        [_unitSelectedFlagView addSubview:unitPointer];
    }
    return _unitSelectedFlagView;
}

- (NSObject *)selectedUnit {
    return (self.units)[self.selectedUnitIndex];
}

#pragma mark - set data
- (void)updateMinValue:(NSInteger)minValue {
    self.minValue = minValue;
    if (self.selectedValue < minValue) {
        self.selectedValue = minValue;
    }
    [self.valueSelector reloadData];
}

- (void)updateMaxValue:(NSInteger)maxValue {
    self.maxValue = maxValue;
    if (self.selectedValue > maxValue) {
        self.selectedValue = maxValue;
    }
    [self.valueSelector reloadData];
}

- (void)updateSelectedValue:(CGFloat)value {
    [self updateSelectedValue:value scroll:YES];
}
- (void)updateSelectedValue:(CGFloat)value scroll:(BOOL)scroll{
    self.selectedValue = value;
    [self.valueSelectedLabel setText:[NSString stringWithFormat:@"%@", @(self.selectedValue)]];
    [self.valueSelectedLabel sizeToFit];
    [self.valueSelectedLabel setCenter:CGPointMake(self.frame.size.width / 2, 35)];
    [self.unitSelectedLabel setCenter:CGPointMake(self.valueSelectedLabel.frame.origin.x + self.valueSelectedLabel.frame.size.width + 5 + self.unitSelectedLabel.frame.size.width / 2, 28)];

    if (scroll) {
        [self scrollToValue:value];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBox:didChangedValue:)]) {
        [self.delegate checkBox:self didChangedValue:value];
    }
}
- (void)updateSelectedUnit:(NSObject *)unit {
    int i = [self.units count] - 1;
    for (; i >= 0; i --) {
        if (unit == (self.units)[i]) {
            break;
        }
    }
    if (i < 0) {
        i = 0;
    }
    [self updateSelectedUnitIndex:i];
}
- (void)updateSelectedUnitIndex:(NSInteger)index {
    [self unitChanged:[self.unitsView viewWithTag:index+kTagPreValue]];
}
- (void)updateUnits:(NSArray *)units {
    NSInteger count = [units count];
    if (count < 1)
        return;
    self.units = units;
    for (UIView *v in [self.unitsView subviews]) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    if ( count > 1 ) {
        UIImageView * unitBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 51.0f)];
        unitBackground.image = [UIImage imageNamed:@"unitBackground"];
        [_unitsView addSubview:unitBackground];
    }
    
    CGFloat width = self.unitsView.frame.size.width / count;
    for (int i = 0; i < count; i ++) {
        UIButton *unitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [unitBtn setTag:i+kTagPreValue];
#ifdef kValueCheckBoxViewUnitTitleColorForNormal
        [unitBtn setTitleColor:kValueCheckBoxViewUnitTitleColorForNormal forState:UIControlStateNormal];
#endif
#ifdef kValueCheckBoxViewUnitTitleColorForSelected
        [unitBtn setTitleColor:kValueCheckBoxViewUnitTitleColorForSelected forState:UIControlStateSelected];
#endif
        [unitBtn setTitle:[units[i] description] forState:UIControlStateNormal];
        [unitBtn setTitle:[units[i] description] forState:UIControlStateHighlighted];
        [unitBtn setTitle:[units[i] description] forState:UIControlStateSelected];
        [unitBtn setFrame:CGRectMake(width * i, 0, width, self.unitsView.frame.size.height)];
        [unitBtn addTarget:self action:@selector(unitChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.unitsView addSubview:unitBtn];
        [unitBtn setHidden:count < 2];
    }
    //[self.unitSelectedFlagView setFrameWithWidth:width];
    [self.unitSelectedFlagView setHidden:count < 2];
    [self.unitsView bringSubviewToFront:self.unitSelectedFlagView];
}
- (void)unitChanged:(id)sender {
    if (((UIButton *)sender).selected) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBox:shouldChangeUnitFrom:to:)]) {
        if (![self.delegate checkBox:self shouldChangeUnitFrom:self.selectedUnit to:(self.units)[((UIView *)sender).tag-kTagPreValue]])
            return;
    }
    for (UIView *view in [self.unitsView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (view == sender) {
                btn.userInteractionEnabled = NO;
                btn.selected = YES;
            } else {
                btn.userInteractionEnabled = YES;
                btn.selected = NO;
            }
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.unitSelectedFlagView setFrameWithX:((UIView *)sender).frame.origin.x + ((UIView *)sender).frame.size.width / 2 - 15.0f];
    [UIView commitAnimations];
    
    self.selectedUnitIndex = ((UIView *)sender).tag-kTagPreValue;
    [self.unitSelectedLabel setText:[(self.units)[self.selectedUnitIndex] description]];
    [self.unitSelectedLabel sizeToFit];
    [self.unitSelectedLabel setCenter:CGPointMake(self.valueSelectedLabel.frame.origin.x + self.valueSelectedLabel.frame.size.width + 5 + self.unitSelectedLabel.frame.size.width / 2, 28)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBox:didChangedUnit:)]) {
        [self.delegate checkBox:self didChangedUnit:self.selectedUnit];
    }
}

- (CGFloat)valueForContentOffsetY:(CGFloat)y {
    return ((NSInteger)(0.5f + y / (kValueCheckBoxViewCellHeight / self.splitNumberPerCell))) * self.increaseValuePerCell / self.splitNumberPerCell + self.minValue;
}

- (CGFloat)offsetYForValue:(CGFloat)value {
    return (value - self.minValue) / self.increaseValuePerCell * kValueCheckBoxViewCellHeight;
}

- (void)moveForcusToRightPoint:(UIScrollView *)scrollView {
    [self scrollToValue:[self valueForContentOffsetY:[scrollView contentOffset].y]];
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil((self.maxValue - self.minValue + 2*self.increaseValuePerCell*kValueCheckBoxViewExtendCellNumber) / self.increaseValuePerCell + 1);
}

- (UIView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 刻度条
    tableView.backgroundColor = [UIColor clearColor];
    UITableViewCell *cell = nil;
    NSString *cellId = [NSString stringWithFormat:@"kValueCell_%d", self.splitNumberPerCell];
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setFrameWithWidth:kValueCheckBoxViewCellWidth Height:kValueCheckBoxViewCellHeight];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:[[ValueCheckBoxViewCellRuler alloc] initWithFrame:cell.bounds splitNumber:self.splitNumberPerCell]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTag:12071614];
        [label setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        [label setFont:[UIFont systemFontOfSize:18]];
        [label setTextColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1]];
        [label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:label];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:12071614];
    CGFloat value = [self valueForContentOffsetY:(indexPath.row - kValueCheckBoxViewExtendCellNumber) * kValueCheckBoxViewCellHeight];
    if (value < self.minValue || value > self.maxValue) {
        [label setHidden:YES];
    } else {
        [label setText:[NSString stringWithFormat:@"%.0f", value]];
        [label sizeToFit];
        [label setCenter:CGPointMake(18, 50)];
        [label setHidden:NO];
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self moveForcusToRightPoint:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self moveForcusToRightPoint:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSelectedValue:[self valueForContentOffsetY:[scrollView contentOffset].y] scroll:NO];
}

- (void)scrollToValue:(CGFloat)value {
    if (value <= self.minValue) {
        value = self.canSelectMinValue ? self.minValue : self.minValue + (self.increaseValuePerCell / self.splitNumberPerCell);
    } else if (value >= self.maxValue) {
        value = self.canSelectMaxValue ? self.maxValue : self.maxValue - (self.increaseValuePerCell / self.splitNumberPerCell);
    }
    [self.valueSelector setContentOffset:CGPointMake(0, [self offsetYForValue:value]) animated:YES];
}
@end

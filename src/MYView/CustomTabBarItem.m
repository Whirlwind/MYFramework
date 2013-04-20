//
//  CustomTabBarItem.m
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//

#import "CustomTabBarItem.h"


@implementation CustomTabBarItem

-(void)buildWithButton:(UIButton *)button label:(UILabel *)label {
	self.button = button;
	self.button.selected = NO;
	[button addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.button) {
        [self addSubview:self.button];
    }

    self.titleLabel = label;
	if (self.titleLabel) {
		[self.button addSubview:label];
	}

	self.frame = self.button.bounds;
	_allSelectedStatus = 2;
	_selectedStatus = 0;
	_loopSelect = NO;
	_canRepeatClick = NO;
}
-(void)build:(NSString *)title {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	button.adjustsImageWhenHighlighted = NO;
	
	UILabel *label = [[UILabel alloc] init];
	label.text = title;
	[label setFont:[UIFont boldSystemFontOfSize:14]];
	[label setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
	[label setHighlightedTextColor:[UIColor whiteColor]];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment =  UITextAlignmentCenter;
    [label sizeToFit];
    [label setCenter:CGPointMake(label.frame.size.width/2.0f+5.0f, label.frame.size.height/2.0f+5.0f)];
    
    [button setFrame:CGRectMake(0, 0, label.frame.size.width+10.0f, label.frame.size.height+10.0f)];
	
	[self buildWithButton:button label:label];
}

-(void)setTitle:(NSString *)_title{
	self.titleLabel.text = _title;
}
-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
	[self.button setBackgroundImage:image forState:state];
}
-(void)myClick:(id)sender{
	[self setSelectedStatus:self.selectedStatus+1];
	if (self.click) {
        MYPerformSelectorWithoutLeakWarningBegin
		[self.myDelegate performSelector:self.click withObject:self];
        MYPerformSelectorWithoutLeakWarningEnd
	}
}
-(void)setClick:(id)delegate click:(SEL)click{
	self.myDelegate = delegate;
	self.click = click;
}
- (void)updateSelectedStatus {
    BOOL selected = _selectedStatus >= 1;
    if (self.selected != selected) {
        self.selected = selected;
    }
	self.button.selected = _selected;
	self.titleLabel.highlighted = _selected;
    self.userInteractionEnabled = !self.selected || self.canRepeatClick;
}
-(void)setSelectedStatus:(int)status{
	int selectedStatus = status % self.allSelectedStatus;
	_selectedStatus = selectedStatus;
    if (_selectedStatus == 0 && _selected) {
        _selected = NO;
    }
    [self updateSelectedStatus];
}
-(void)setSelected:(BOOL)selected{
	_selected = selected;
    self.selectedStatus = selected ? 1 : 0;
}
- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    [self.button setTag:tag];
}
+(CustomTabBarItem *)itemWithTitle:(NSString *)_title {
	CustomTabBarItem *item = [[CustomTabBarItem alloc] init];
	[item build:_title];
	return item;
}
+(CustomTabBarItem *)itemWithButton:(UIButton *)_button label:(UILabel *)_label {
	CustomTabBarItem *item = [[CustomTabBarItem alloc] init];
	[item buildWithButton:_button label:_label];
	return item;
}
@end

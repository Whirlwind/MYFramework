//
//  CustomTabBarItem.m
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//

#import "CustomTabBarItem.h"


@implementation CustomTabBarItem
@synthesize selected, loopSelect, canRepeatClick, allSelectedStatus, selectedStatus;
@synthesize titleLabel, button;
@synthesize myDelegate, click;
-(void)dealloc{
	[button release], button=nil;
	[titleLabel release], titleLabel=nil;
	[super dealloc];
}
-(void)buildWithButton:(UIButton *)_button label:(UILabel *)_label tag:(int)_tag{
	self.button = _button;
	self.button.tag = _tag;
	self.button.selected = NO;
	[button addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
	
	if (_label) {
		self.titleLabel = _label;
		[self.button addSubview:_label];
	}
	
	[self setCustomView:button];
	
	self.tag = _tag;
	
	allSelectedStatus = 2;
	selectedStatus = 0;
	loopSelect = NO;
	canRepeatClick = YES;
}
-(void)build:(NSString *)_title tag:(int)_tag{
	UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect rect = CGRectMake(0.0, 0.0, 92.0, 44.0);
	[_button setFrame:rect];	
	[_button setBackgroundImage:[UIImage imageNamed:@"subtab-normal"] forState:UIControlStateNormal];
	[_button setBackgroundImage:[UIImage imageNamed:@"subtab-current"] forState:UIControlStateSelected];
	_button.adjustsImageWhenHighlighted = NO;
	
	UILabel *_label = [[UILabel alloc] initWithFrame:rect];
	_label.text = _title;
	[_label setFont:[UIFont boldSystemFontOfSize:14]];
	[_label setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
	[_label setHighlightedTextColor:[UIColor whiteColor]];
	_label.backgroundColor = [UIColor clearColor];
	_label.textAlignment =  UITextAlignmentCenter;
	
	[self buildWithButton:_button label:_label tag:_tag];
	[_label release], _label=nil;
	self.width = 92.0;
}
-(void)setTitle:(NSString *)_title{
	titleLabel.text = _title;
}
-(void)setBackgroundImage:(UIImage *)_image forState:(UIControlState)_state{
	[button setBackgroundImage:_image forState:_state];
}
-(void)myClick:(id)sender{
	[self setSelectedStatus:selectedStatus+1];
	if (click) {
		[myDelegate performSelector:click withObject:self];
	}
}
-(void)setClick:(id)_delegate click:(SEL)_click{
	myDelegate = _delegate;
	click = _click;
}
-(void)setCanRepeatClick:(BOOL)_repeat{
	canRepeatClick = _repeat;
	if (!selected) {
		selectedStatus = 0;
		button.userInteractionEnabled = YES;
	}else {
		if (selectedStatus == -1) {
			selectedStatus = 0;
		}
		button.userInteractionEnabled = canRepeatClick;
	}
}
-(void)setSelectedStatus:(int)_status{
	int _selectedStatus = _status % allSelectedStatus;
	if (_selectedStatus == 0 && !loopSelect && selectedStatus == allSelectedStatus - 1) {
		return;
	}
	selectedStatus = _selectedStatus;
	[self setSelected:selectedStatus == 1];
}
-(void)setSelected:(BOOL)_selected{
	selected = _selected;
	self.canRepeatClick = canRepeatClick;

	button.selected = _selected;
	titleLabel.highlighted = _selected;
}
+(CustomTabBarItem *)initWithTitle:(NSString *)_title tag:(int)_tag{
	CustomTabBarItem *item = [[CustomTabBarItem alloc] init];
	[item build:_title tag:_tag];
	return [item autorelease];
}
+(CustomTabBarItem *)initWithButton:(UIButton *)_button label:(UILabel *)_label tag:(int)_tag{
	CustomTabBarItem *item = [[CustomTabBarItem alloc] init];
	[item buildWithButton:_button label:_label tag:_tag];
	return [item autorelease];
}
@end

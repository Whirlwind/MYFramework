//
//  CustomTabBar.m
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//
#import "CustomTabBar.h"
#import "CustomTabBarItem.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomTabBar ()
- (void)initTabBar;
@end

@implementation CustomTabBar

@synthesize myDelegate, switchTab, clickTab;
@synthesize canRepeatClick;
@synthesize selectedIndex = _selectedIndex;
@synthesize oldSelectedIndex = _oldSelectedIndex;
@synthesize selectedItem = _selectedItem;
@synthesize oldSelectedItem = _oldSelectedItem;
- (void)dealloc{
    [_oldSelectedItem release], _oldSelectedItem = nil;
    [_selectedItem release], _selectedItem = nil;
	[super dealloc];
}

// 将UIToolBar设置为透明
- (void)drawRect:(CGRect)rect {
    // Do nothing!
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // Do nothing!
}
-(CustomTabBar *)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
        [self initTabBar];
	}
	return self;
}
-(CustomTabBar *)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
        [self initTabBar];
	}
	return self;
}
- (void)initTabBar{
    canRepeatClick = YES;
    self.oldSelectedIndex = -1;
    self.oldSelectedItem = nil;
    self.selectedIndex = -1;
    self.selectedItem = nil;
}
-(void)setItems:(NSArray *)itemArray{
	[self setItems:itemArray animated:NO];
}
-(void)setItemsWithButton:(NSArray *)buttonArray animated:(BOOL)animated{
	[self setItemsWithButton:buttonArray label:nil animated:NO];
}
-(void)setItemsWithButton:(NSArray *)buttonArray label:(NSArray *)labelArray animated:(BOOL)animated{
	NSMutableArray *itemArray = [[NSMutableArray alloc] initWithCapacity:8];
	for (int i = 0; i < [buttonArray count]; i++) {
		CustomTabBarItem *tabbar = [CustomTabBarItem initWithButton:buttonArray[i] label:labelArray && [labelArray count]>i?labelArray[i]:nil tag:i];
		[tabbar setClick:self click:@selector(switchTab:)];
		
		[itemArray addObject:tabbar];
	}
	for (int i = 1; i < [buttonArray count]; i++) {
		UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[itemArray insertObject:spacer atIndex:2*i-1];
		[spacer release], spacer=nil;
	}
	[super setItems:itemArray animated:animated];
	[itemArray release], itemArray=nil;
}
-(void)setItems:(NSArray *)itemArray animated:(BOOL)animated{
	NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithCapacity:8];
	int index = 0;
	for (NSString *item in itemArray) {
		CustomTabBarItem *tabbar = [CustomTabBarItem initWithTitle:item tag:index];
		[tabbar setClick:self click:@selector(switchTab:)];
		
		[buttonArray addObject:tabbar];
		
		index ++;
	}
	for (int i = 1; i < [itemArray count]; i++) {
		UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[buttonArray insertObject:spacer atIndex:2*i-1];
		[spacer release], spacer=nil;
	}
	
	
	[super setItems:buttonArray animated:animated];
	[buttonArray release], buttonArray=nil;
}
-(void)setLayerColor:(UIColor *)_color{
	// 必须先将contents设置为透明，才能设置背景颜色
	self.layer.contents = (id)[UIColor clearColor].CGColor;
	self.layer.backgroundColor = _color.CGColor;
}
-(void)setLayerImage:(UIImage *)_image{
	self.layer.contents = (id)_image.CGImage;
}
-(void)setCanRepeatClick:(BOOL)_repeat{
	canRepeatClick = _repeat;
	for (UIBarButtonItem *temp in self.items) {
		if (![temp isKindOfClass:[CustomTabBarItem class]]) {
			continue;
		}
		CustomTabBarItem *tabItem = (CustomTabBarItem *)temp;
		[tabItem setCanRepeatClick:_repeat];
	}
}
-(void)setSelectedItem:(CustomTabBarItem *)_item{
    self.oldSelectedItem = self.selectedItem;
    self.oldSelectedIndex = self.selectedIndex;
    [_selectedItem release];
    _selectedItem = [_item retain];
	_selectedIndex = _item ? _item.tag : -1;
}
-(void)setSelectedIndex:(int)_index{
	for (UIBarButtonItem *temp in self.items) {
		if (![temp isKindOfClass:[CustomTabBarItem class]]) {
			continue;
		}
		CustomTabBarItem *tabItem = (CustomTabBarItem *)temp;
		if (tabItem.tag != _index) {
			tabItem.selected = NO;
		}else {
			tabItem.selected = YES;
			tabItem.canRepeatClick = canRepeatClick;
			self.selectedItem = tabItem;
		}

	}
	if (self.selectedItem && myDelegate && switchTab) {
		[myDelegate performSelector:switchTab withObject:self.selectedItem];
	}
}
-(void)switchTab:(id)sender {
	UIButton *btn = (UIButton *)sender;
	if(self.selectedIndex != btn.tag){
		self.selectedIndex = btn.tag;
	}
	else {
		if (self.selectedItem && myDelegate && clickTab) {
			[myDelegate performSelector:clickTab withObject:self.selectedItem];
		}
	}

}

@end

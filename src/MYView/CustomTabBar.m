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

@end

@implementation CustomTabBar

- (void)dealloc{
    [_oldSelectedItem release], _oldSelectedItem = nil;
    [_selectedItem release], _selectedItem = nil;
	[super dealloc];
}

- (CustomTabBar *)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
        [self initTabBar];
	}
	return self;
}
- (CustomTabBar *)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
        [self initTabBar];
	}
	return self;
}
- (void)initTabBar{
    _canRepeatClick = NO;
    _oldSelectedIndex = -1;
    _oldSelectedItem = nil;
    _selectedIndex = -1;
    _selectedItem = nil;
}

- (void)setItemsWithTitle:(NSArray *)itemArray animated:(BOOL)animated {
	NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithCapacity:8];
    [itemArray enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
		CustomTabBarItem *tabbar = [CustomTabBarItem itemWithTitle:item tag:idx];
		[tabbar setClick:self click:@selector(switchTab:)];
        [tabbar.titleLabel sizeToFit];

		[buttonArray addObject:tabbar];
	}];
    [self setItems:buttonArray animated:animated];
	[buttonArray release], buttonArray=nil;
}

- (void)setItems:(NSMutableArray *)items animated:(BOOL)animated {
    self.items = items;
    [self updateItems:animated];
}

- (void)updateItems:(BOOL)animated {
    // TODO: animated support
    __block CGFloat totalWidth = 0;
    [self.items enumerateObjectsUsingBlock:^(CustomTabBarItem *obj, NSUInteger idx, BOOL *stop) {
        totalWidth += obj.frame.size.width;
    }];
    CGFloat edge = (self.frame.size.width - totalWidth) / ([self.items count]-1);
    __block CGFloat x = 0;
    [self.items enumerateObjectsUsingBlock:^(CustomTabBarItem *obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = obj.frame;
        frame.origin.x = x ;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0f;
        x += frame.size.width + edge;
        [obj setFrame:frame];
        if (obj.superview != self) {
            [self addSubview:obj];
        }
    }];
}
- (void)setCanRepeatClick:(BOOL)_repeat{
	_canRepeatClick = _repeat;
	for (CustomTabBarItem *tabItem in self.items) {
		[tabItem setCanRepeatClick:_repeat];
	}
}
- (void)setSelectedItem:(CustomTabBarItem *)_item{
    self.oldSelectedItem = self.selectedItem;
    self.oldSelectedIndex = self.selectedIndex;
    [_selectedItem release];
    _selectedItem = [_item retain];
	_selectedIndex = _item ? _item.tag : -1;
    [self updateSelectedItem];
}
- (void)setSelectedIndex:(int)index{
    if (index >= [self.items count]) {
        return;
    }
    self.selectedItem = [self.items objectAtIndex:index];
}
- (void)updateSelectedItem {
	for (CustomTabBarItem *tabItem in self.items) {
		if (tabItem.tag != self.selectedIndex) {
			tabItem.selected = NO;
		}else {
			tabItem.selected = YES;
		}
	}
	if (self.selectedItem && self.myDelegate && self.switchTab) {
		[self.myDelegate performSelector:self.switchTab withObject:self.selectedItem];
	}    
}
- (void)switchTab:(id)sender {
	UIButton *btn = (UIButton *)sender;
	if(self.selectedIndex != btn.tag){
		self.selectedIndex = btn.tag;
	}
	else {
		if (self.selectedItem && self.myDelegate && self.clickTab) {
			[self.myDelegate performSelector:self.clickTab withObject:self.selectedItem];
		}
	}

}

@end

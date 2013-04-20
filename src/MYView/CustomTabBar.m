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
    [_contentView removeObserver:self forKeyPath:@"frame"];
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
    [self addSubview:self.contentView];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addObserver:self
                       forKeyPath:@"frame"
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                          context:NULL];
    }
    return _contentView;
}

- (void)setItemsWithTitle:(NSArray *)itemArray animated:(BOOL)animated {
	NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithCapacity:[itemArray count]];
    [itemArray enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
		CustomTabBarItem *tabbar = [CustomTabBarItem itemWithTitle:item];

		[buttonArray addObject:tabbar];
	}];
    [self setItems:buttonArray animated:animated];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    self.items = [NSMutableArray arrayWithArray:items];
    [self.items enumerateObjectsUsingBlock:^(CustomTabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTag:idx];
		[item setClick:self click:@selector(switchTab:)];
    }];
    [self updateItems:animated];
}

- (void)setContentViewRect:(CGRect)rect animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self updateItemsWithoutAnimated];
                         }
                         completion:NULL];
    } else {
        [self updateItemsWithoutAnimated];
    }
}
- (void)updateItems:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self updateItemsWithoutAnimated];
                         }
                         completion:NULL];
    } else {
        [self updateItemsWithoutAnimated];
    }
}
- (void)updateItemsWithoutAnimated {
    if (self.items == nil) {
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
    [array addObject:[NSMutableArray array]];
    NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:1];
    __block CGFloat width = 0.0f;
    __block CGFloat maxHeight = 0.0f;
    __block CGFloat totalHeight = 0.0f;
    [self.items enumerateObjectsUsingBlock:^(CustomTabBarItem *obj, NSUInteger idx, BOOL *stop) {
        if (width + obj.frame.size.width > self.contentView.frame.size.width) {
            totalHeight += maxHeight;
            [lines addObject:[NSValue valueWithCGSize:CGSizeMake(width, maxHeight)]];
            [array addObject:[NSMutableArray array]];
            width = 0.0f;
            maxHeight = 0.0f;
        }
        width += obj.frame.size.width;
        if (maxHeight < obj.frame.size.height) {
            maxHeight = obj.frame.size.height;
        }
        [[array lastObject] addObject:obj];
    }];
    totalHeight += maxHeight;
    [lines addObject:[NSValue valueWithCGSize:CGSizeMake(width, maxHeight)]];

    CGFloat lineEdge = [lines count] <= 1 ? 0:(self.contentView.frame.size.height - totalHeight) / ([lines count] - 1);
    __block CGFloat y = 0;
    [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger line, BOOL *stop) {
        CGSize lineSize = [[lines objectAtIndex:line] CGSizeValue];
        CGFloat columnEdge = [obj count] <= 1 ? 0:(self.contentView.frame.size.width - lineSize.width) / ([obj count] - 1);
        __block CGFloat x = 0;
        [obj enumerateObjectsUsingBlock:^(CustomTabBarItem *item, NSUInteger column, BOOL *stop) {
            CGRect frame = item.frame;
            frame.origin.x = x;
            frame.origin.y = y;
            [item setFrame:frame];
            if (item.superview != self.contentView) {
                [self.contentView addSubview:item];
            }
            x += frame.size.width + columnEdge;
        }];
        y += lineSize.height + lineEdge;
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
    _selectedItem = _item;
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
        MYPerformSelectorWithoutLeakWarningBegin
		[self.myDelegate performSelector:self.switchTab withObject:self.selectedItem];
        MYPerformSelectorWithoutLeakWarningEnd
	}
}
- (void)switchTab:(id)sender {
	UIButton *btn = (UIButton *)sender;
	if(self.selectedIndex != btn.tag){
		self.selectedIndex = btn.tag;
	}
	else {
		if (self.selectedItem && self.myDelegate && self.clickTab) {
            MYPerformSelectorWithoutLeakWarningBegin
			[self.myDelegate performSelector:self.clickTab withObject:self.selectedItem];
            MYPerformSelectorWithoutLeakWarningEnd
		}
	}

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGRect oldRect = [[change valueForKey:NSKeyValueChangeOldKey] CGRectValue];
    CGRect newRect = [[change valueForKey:NSKeyValueChangeNewKey] CGRectValue];
    if (newRect.size.width != oldRect.size.width || newRect.size.height != oldRect.size.height) {
        [self updateItemsWithoutAnimated];
    }
}
@end

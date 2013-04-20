//
//  CustomTabBar.h
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//
#import "CustomTabBarItem.h"

@interface CustomTabBar : UIView

@property (nonatomic, weak) id myDelegate;
@property (nonatomic, assign) SEL switchTab;
@property (nonatomic, assign) SEL clickTab;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int oldSelectedIndex;
@property (nonatomic, assign) BOOL canRepeatClick;
@property (nonatomic, strong) CustomTabBarItem *selectedItem;
@property (nonatomic, strong) CustomTabBarItem *oldSelectedItem;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *contentView;

- (void)setItemsWithTitle:(NSArray *)itemArray animated:(BOOL)animated;
- (void)setItems:(NSArray *)items animated:(BOOL)animated;
@end


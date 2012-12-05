//
//  CustomTabBar.h
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//
#import "CustomTabBarItem.h"

@interface CustomTabBar : UIView

@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) SEL switchTab;
@property (nonatomic, assign) SEL clickTab;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int oldSelectedIndex;
@property (nonatomic, assign) BOOL canRepeatClick;
@property (nonatomic, retain) CustomTabBarItem *selectedItem;
@property (nonatomic, retain) CustomTabBarItem *oldSelectedItem;
@property (retain, nonatomic) NSMutableArray *items;

- (void)setItemsWithTitle:(NSArray *)itemArray animated:(BOOL)animated;
- (void)setItems:(NSMutableArray *)items animated:(BOOL)animated;
@end


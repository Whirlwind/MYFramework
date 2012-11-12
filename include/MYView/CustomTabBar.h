//
//  CustomTabBar.h
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//
@class CustomTabBarItem;

@interface CustomTabBar : UIToolbar {
	
	id myDelegate;
	SEL switchTab;
	SEL clickTab;
	
	BOOL canRepeatClick;
}

@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) SEL switchTab;
@property (nonatomic, assign) SEL clickTab;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int oldSelectedIndex;
@property (nonatomic, assign) BOOL canRepeatClick;
@property (nonatomic, retain) CustomTabBarItem *selectedItem;
@property (nonatomic, retain) CustomTabBarItem *oldSelectedItem;
-(void)setLayerColor:(UIColor *)_color;
-(void)setLayerImage:(UIImage *)_image;

-(void)setItemsWithButton:(NSArray *)buttonArray animated:(BOOL)animated;
-(void)setItemsWithButton:(NSArray *)buttonArray label:(NSArray *)labelArray animated:(BOOL)animated;
@end


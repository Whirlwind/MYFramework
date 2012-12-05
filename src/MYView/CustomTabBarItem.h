//
//  CustomTabBarItem.h
//  food
//
//  Created by Whirlwind James on 11-9-22.
//  Copyright 2011 BOOHEE. All rights reserved.
//


@interface CustomTabBarItem : UIView

@property (nonatomic, assign) int selectedStatus;
@property (nonatomic, assign) int allSelectedStatus;
@property (nonatomic, assign) BOOL loopSelect;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL canRepeatClick;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *button;


@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) SEL click;

+(CustomTabBarItem *)itemWithTitle:(NSString *)_title;
+(CustomTabBarItem *)itemWithButton:(UIButton *)_button label:(UILabel *)_label;
-(void)setTitle:(NSString *)_title;
-(void)setBackgroundImage:(UIImage *)_image forState:(UIControlState)_state;
-(void)setClick:(id)_delegate click:(SEL)_click;
- (void)setTag:(NSInteger)tag;
@end

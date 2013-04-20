//
//  ViewController.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-12.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setItemsWithTitle:@[@"1", @"2", @"3"] animated:NO];
    [self.tabBar setCanRepeatClick:YES];
    [self.tabBar.items enumerateObjectsUsingBlock:^(CustomTabBarItem *obj, NSUInteger idx, BOOL *stop) {
        [obj setBackgroundColor:[UIColor blueColor]];
    }];

    // ValueCheckBoxView
    [_checkBox setIncreaseValuePerCell:10];
    [_checkBox setSplitNumberPerCell:5];
    [_checkBox setMaxValue:100];
    [_checkBox setMinValue:0];
    [_checkBox updateUnits:@[@"分钟"]];
    [_checkBox updateSelectedUnitIndex:0];
    [_checkBox updateSelectedValue:50];

    // MYInputFieldPicker
    [self.picker setSource:@[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h"]];
    [self.picker setValue:@"c"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabBar:nil];
    [self setCheckBox:nil];
    [super viewDidUnload];
}
- (IBAction)changeTabBar:(id)sender {
    if (((UIButton *)sender).tag == 0) {
        [self.tabBar setFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width - 20.0f, 100)];
    } else {
        [UIView animateWithDuration:0.2
                         animations:^{

                             [self.tabBar setFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width - 50.0f, 100)];
                         }];
    }
}
@end

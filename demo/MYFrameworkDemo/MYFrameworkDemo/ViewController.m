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
    [self.tabBar setItemsWithTitle:@[@"1", @"2", @"3"] animated:YES];
    [self.tabBar setCanRepeatClick:YES];

    // ValueCheckBoxView
    [_checkBox setIncreaseValuePerCell:10];
    [_checkBox setMaxValue:100];
    [_checkBox setMinValue:0];
    [_checkBox updateUnits:@[@"分钟"]];
    [_checkBox updateSelectedUnitIndex:0];
    [_checkBox updateSelectedValue:50];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tabBar release];
    [_checkBox release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTabBar:nil];
    [self setCheckBox:nil];
    [super viewDidUnload];
}
@end

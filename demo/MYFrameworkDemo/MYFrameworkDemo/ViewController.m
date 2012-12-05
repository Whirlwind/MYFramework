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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tabBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}
@end

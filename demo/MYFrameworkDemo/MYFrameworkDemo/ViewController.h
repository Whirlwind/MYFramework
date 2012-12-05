//
//  ViewController.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-11-12.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"
#import "ValueCheckBoxView.h"
@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet CustomTabBar *tabBar;

@property (retain, nonatomic) IBOutlet ValueCheckBoxView *checkBox;
@end

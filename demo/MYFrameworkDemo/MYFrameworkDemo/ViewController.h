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
#import "MYInputFieldPickerString.h"

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet CustomTabBar *tabBar;

@property (retain, nonatomic) IBOutlet ValueCheckBoxView *checkBox;

@property (retain, nonatomic) IBOutlet MYInputFieldPickerString *picker;
- (IBAction)changeTabBar:(id)sender;
@end

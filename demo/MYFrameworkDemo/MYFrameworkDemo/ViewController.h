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
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

@property (strong, nonatomic) IBOutlet ValueCheckBoxView *checkBox;

@property (strong, nonatomic) IBOutlet MYInputFieldPickerString *picker;
- (IBAction)changeTabBar:(id)sender;
@end

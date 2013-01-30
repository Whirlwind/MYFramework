//
//  MYViewModel.h
//  SecretLove
//
//  Created by Whirlwind on 12-12-27.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYViewController.h"

@interface MYViewModel : MYViewController <MYViewControllerDelegate>
@property (assign, nonatomic, getter=subViewControllers, setter=setSubViewControllers:) NSMutableArray *subViewModels;

- (void)addSubViewModel:(MYViewModel *)vm;
- (void)addSubViewModel:(MYViewModel *)vm view:(UIView *)__view;

@end

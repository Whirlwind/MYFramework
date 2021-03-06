//
//  MYNavigationControllerAnimationFactory.m
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-12-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYNavigationControllerAnimationFactory.h"

@implementation MYNavigationControllerAnimationFactory
@synthesize nav = _nav;

- (id)initWithNavigationController:(MYNavigationController *)nav {
    if (self = [self init]) {
        self.nav = nav;
    }
    return self;
}

- (void)exchangeViewController:(id<MYViewControllerDelegate>)prevViewController
        withNextViewController:(id<MYViewControllerDelegate>)nextViewController
                     direction:(BOOL)isPush
                      animated:(BOOL)animated
                        sender:(id)sender
                      complete:(void (^)(void))block {
    [nextViewController.myNavigationController.contentView addSubview:nextViewController.view];
    [prevViewController.view removeFromSuperview];
    if (block) {
        block();
    }
}

@end

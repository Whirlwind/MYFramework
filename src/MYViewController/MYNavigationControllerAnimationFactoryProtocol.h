//
//  MYNavigationControllerAnimationFactoryProtocol.h
//  MYFrameworkDemo
//
//  Created by Whirlwind on 12-12-20.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYNavigationControllerAnimationFactoryProtocol <NSObject>

- (void)exchangeViewController:(id<MYViewControllerDelegate>)prevViewController
        withNextViewController:(id<MYViewControllerDelegate>)nextViewController
                     direction:(BOOL)isPush
                      animated:(BOOL)animated
                        sender:(id)sender
                      complete:(void (^)(void))block;
@end

//
//  MYViewModel.m
//  SecretLove
//
//  Created by Whirlwind on 12-12-27.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYViewModel.h"

@interface MYViewModel ()

@end

@implementation MYViewModel

- (void)viewDidLoad
{
    static NSString *suffix = @"Model";
    NSString *name = [[self class] description];
    NSString *viewName = nil;
    if ([name hasSuffix:suffix]) {
        viewName = [[[self class] description] substringToIndex:[name length] - [suffix length]];
        if([self.nibBundle pathForResource:viewName ofType:@"nib"] != nil) {
            NSArray *array = [self.nibBundle loadNibNamed:viewName owner:nil options:nil];
            if (array) {
                self.contentView = array[0];
            }
        } else {
            self.contentView = [[[NSClassFromString(viewName) alloc] init] autorelease];
        }
    }
    [super viewDidLoad];
}

- (void)addSubViewModel:(MYViewModel *)vm {
    [self addSubViewController:vm];
}

- (void)addSubViewModel:(MYViewModel *)vm view:(UIView *)__view {
    [self addSubViewController:vm view:__view];
}

@end

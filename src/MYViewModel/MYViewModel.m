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

- (void)dealloc {
    [_viewName release], _viewName = nil;
    [super dealloc];
}

- (id)initWithViewName:(NSString *)viewName {
    if (self = [self init]) {
        self.viewName = viewName;
    }
    return self;
}

- (void)viewDidLoad
{
    static NSString *suffix = @"Model";
    NSString *name = NSStringFromClass([self class]);
    if (self.viewName == nil) {
        if ([name hasSuffix:suffix]) {
            self.viewName = [[[self class] description] substringToIndex:[name length] - [suffix length]];
        } else {
            self.viewName = name;
        }
    }
    if([self.nibBundle pathForResource:self.viewName ofType:@"nib"] != nil) {
        NSArray *array = [self.nibBundle loadNibNamed:self.viewName owner:nil options:nil];
        if (array) {
            self.contentView = array[0];
        }
    } else {
        Class v = NSClassFromString(self.viewName);
        if (v) {
            self.contentView = [[[v alloc] init] autorelease];
        }
    }
    self.view.width = self.contentView.width;
    self.view.height = self.contentView.height;
    [super viewDidLoad];
}

- (void)addSubViewModel:(MYViewModel *)vm {
    [self addSubViewController:vm];
}

- (void)addSubViewModel:(MYViewModel *)vm view:(UIView *)__view {
    [self addSubViewController:vm view:__view];
}

@end

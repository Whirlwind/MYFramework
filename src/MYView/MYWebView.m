//
//  MYWebView.m
//  iNice
//
//  Created by Whirlwind James on 12-7-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYWebView.h"

@implementation MYWebView

- (void)disableBounces {
    for (id view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view setBounces:NO];
        }
    }
}

- (void)loadRequestWithStringUrl:(NSString *)url{
    [self loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
}

- (void)loadResource:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name
                                                                                        ofType:@"html"]
                                               encoding:NSUTF8StringEncoding error:nil];
    [self loadHTMLString:html baseURL:baseURL];
}
- (UIScrollView *)scrollView {
    UIScrollView *scrollView = nil;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 5) {
        scrollView = super.scrollView;
    } else {
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                scrollView = (UIScrollView *)v;
                break;
            }
        }
    }
    return scrollView;
}

// 去除webview上下的阴影
- (void)removeShape {
    for( UIView *innerView in [[self scrollView] subviews] ) {
        if( [innerView isKindOfClass:[UIImageView class]] ) {
            innerView.hidden = YES;
        }
    }
}
@end

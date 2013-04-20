//
//  MYWebView.h
//  iNice
//
//  Created by Whirlwind James on 12-7-31.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYWebView : UIWebView
- (void)disableBounces;
- (void)loadRequestWithStringUrl:(NSString *)url;
- (void)loadResource:(NSString *)name;
- (void)removeShape;
@end

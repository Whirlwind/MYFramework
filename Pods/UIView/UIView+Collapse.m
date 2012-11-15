//
//  UIView+Collapse.m
//  food
//
//  Created by James Whirlwind on 11-11-14.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

#import "UIView+Collapse.h"
static const char *collapseHeightKey = "objCollapseHeightKey";
static const char *collapseSizeHeightKey = "objCollapseSizeHeightKey";

@implementation UIView (Collapse)
// TODO: 优化参数为NO时的动作
- (void)setCollapseHeight:(BOOL)_collapse{
    BOOL old = [self collapseHeight];
    if (old==_collapse) {
        return;
    }
    if (_collapse) {
        //[self setValue:[NSNumber numberWithFloat:self.frame.size.height] forKeyPath:@"collapseSize.Height"];
        objc_setAssociatedObject(self, collapseSizeHeightKey, [NSNumber numberWithFloat:self.frame.size.height], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setHidden:YES];
        [self changeHeightTo:0.0];
    }else{
        CGFloat height = [((NSNumber *)objc_getAssociatedObject(self, collapseSizeHeightKey)) floatValue];
        [self setHidden:NO];
        [self changeHeightTo:height];
    }
    objc_setAssociatedObject(self, collapseHeightKey, [NSNumber numberWithBool:_collapse], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (BOOL)collapseHeight{
    id value = objc_getAssociatedObject(self, collapseHeightKey);
    if (value==nil) {
        return NO;
    }
    return [((NSNumber *)value) boolValue];
}
- (void)changeHeightTo:(CGFloat)newHeight{
    [self changeHeight:self.frame.size.height To:newHeight];
}
- (void)changeHeight:(CGFloat)oldHeight To:(CGFloat)newHeight{
    [UIView changeHeight:self oldHeight:oldHeight newHeight:newHeight];
}

+ (void)changeHeight:(UIView *)changeView oldHeight:(CGFloat)oldHeight newHeight:(CGFloat)newHeight{
	changeView.frame = CGRectMake(changeView.frame.origin.x, changeView.frame.origin.y, changeView.frame.size.width, newHeight);
	for(UIView *view in changeView.superview.subviews){
		if (view == changeView) {
			continue;
		}
		if (view.frame.origin.y <= changeView.frame.origin.y && view.frame.origin.y + view.frame.size.height >= changeView.frame.origin.y + oldHeight) {
			view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height - (oldHeight - newHeight));
			continue;
		}
		if (view.frame.origin.y > changeView.frame.origin.y) {
			view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + newHeight - oldHeight, view.frame.size.width, view.frame.size.height);
		}
	}
	if (changeView.superview != nil) {
		if ([changeView.superview isKindOfClass:[UIScrollView class]]) {
			UIScrollView *superview = (UIScrollView *)changeView.superview;
			[superview setContentSize:CGSizeMake(superview.contentSize.width, superview.contentSize.height - (oldHeight - newHeight))];
			return;
		}
		[self changeHeight:changeView.superview oldHeight:changeView.superview.frame.size.height newHeight:changeView.superview.frame.size.height - (oldHeight-newHeight)];
	}
}

//- (void)dealloc{
//    objc_setAssociatedObject(self, collapseHeightKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, collapseSizeHeightKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    [super dealloc];
//}
@end

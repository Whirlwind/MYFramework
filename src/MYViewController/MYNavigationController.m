//
//  MYNavigationController.m
//  iNice
//
//  Created by Whirlwind James on 12-6-28.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYNavigationController.h"
#import "MYFramework.h"
#import "MYNavigationControllerAnimationFactory.h"

@implementation MYNavigationController

#pragma mark - release
- (void)didReceiveMemoryWarning
{
    // Do Nothing
}

- (void)releaseSubViews{
    [super releaseSubViews];
}

- (void)dealloc{
    [_animationFactory release], _animationFactory = nil;
    [_viewControllers release], _viewControllers = nil;
    [super dealloc];
}

#pragma mark - init
- (id)initWithRootViewController:(id<MYViewControllerDelegate>)viewController {
    if (self = [self init]) {
        [self.viewControllers addObject:viewController];
        [viewController setMyNavigationController:self];
    }
    return self;
}

#pragma mark - getter
- (NSMutableArray *)viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _viewControllers;
}

- (id<MYNavigationControllerAnimationFactoryProtocol>)animationFactory {
    if (_animationFactory == nil) {
        _animationFactory = [[MYNavigationControllerAnimationFactory alloc] initWithNavigationController:self];
    }
    return _animationFactory;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    [self exchangeViewController:nil
          withNextViewController:[self.viewControllers lastObject]
                       direction:YES
                        animated:NO
                          sender:nil
                        complete:nil];
}

#pragma mark - private methods
- (void)exchangeViewController:(id<MYViewControllerDelegate>)prevViewController
        withNextViewController:(id<MYViewControllerDelegate>)nextViewController
                     direction:(BOOL)isPush
                      animated:(BOOL)animated
                        sender:(id)sender
                      complete:(void (^)(void))block {
    [prevViewController retain];
    if ([prevViewController respondsToSelector:@selector(viewControllerResignTopViewController:)])
        [prevViewController viewControllerResignTopViewController:YES];
    [nextViewController setMyNavigationController:self];
    [nextViewController view];
    if ([nextViewController respondsToSelector:@selector(viewControllerBecomeTopViewController:)])
        [nextViewController viewControllerBecomeTopViewController:YES];
    BOOL isIOS4 = [[[UIDevice currentDevice] systemVersion] integerValue] < 5;
    if (isIOS4)
        [prevViewController viewWillDisappear:animated];
    if (isIOS4)
        [nextViewController viewWillAppear:animated];
    [self viewControllerWillChangeTo:nextViewController from:prevViewController];
    [self.animationFactory exchangeViewController:prevViewController
                           withNextViewController:nextViewController
                                        direction:isPush
                                         animated:animated
                                           sender:sender
                                         complete:^{
                                             if (isIOS4)
                                                 [prevViewController viewDidDisappear:animated];
                                             [prevViewController setMyNavigationController:nil];
                                             [prevViewController release];
                                             if (isIOS4)
                                                 [nextViewController viewDidAppear:animated];
                                             if (block)
                                                 block();
                                             [self viewControllerDidChangedTo:nextViewController from:prevViewController];
                                         }];
}

#pragma mark - controller
- (id<MYViewControllerDelegate> )topViewController {
    if ([self.viewControllers count] == 0) {
        return nil;
    }
    return [self.viewControllers lastObject];
}

- (id<MYViewControllerDelegate>)rootViewController {
    if ([self.viewControllers count] == 0) {
        return nil;
    }
    return self.viewControllers[0];
}

- (void)setRootViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated{
    if ([self.viewControllers count] <= 1) {
        [self pushViewController:vc
                        animated:animated];
    } else {
        [self.viewControllers insertObject:vc atIndex:1];
    }
    if ([self.viewControllers count] > 1) {
        [self.viewControllers removeObjectAtIndex:0];
    }
}
- (void)setRootViewControllerWithEmptyStack:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated {
    [self setRootViewControllerWithEmptyStack:vc animated:animated sender:nil];
}

- (void)setRootViewControllerWithEmptyStack:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    if ([self.viewControllers count] == 0) {
        [self.viewControllers addObject:vc];
        [self exchangeViewController:nil
              withNextViewController:vc
                           direction:YES
                            animated:animated
                              sender:sender
                            complete:nil];
    } else {
        id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
        [self.viewControllers removeAllObjects];
        [self.viewControllers addObject:vc];
        [self exchangeViewController:[last autorelease]
              withNextViewController:vc
                           direction:YES
                            animated:animated
                              sender:sender
                            complete:nil];
    }
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated{
    [self pushViewController:vc animated:animated sender:nil];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    [self pushViewController:vc
                      sender:sender
              animationBlock:^(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender) {
                  [self exchangeViewController:preVC
                        withNextViewController:nextVC
                                     direction:YES
                                      animated:animated
                                        sender:sender
                                      complete:nil];
              }];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    [self pushViewController:vc sender:nil animationBlock:block];
}

- (void)pushViewController:(id<MYViewControllerDelegate> )vc sender:(id)sender animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    id<MYViewControllerDelegate> last = [self.viewControllers lastObject];
    [self.viewControllers addObject:vc];
    block(last, vc, sender);
}

- (void)popToTopViewControllerWithAnimated:(BOOL)animated {
    [self popToTopViewControllerWithAnimated:animated sender:nil];
}

- (void)popToTopViewControllerWithAnimated:(BOOL)animated sender:(id)sender {
    if ([self.viewControllers count] < 2)
        return;
    NSRange range;
    range.location = 1;
    range.length = [self.viewControllers count] - 2;
    if (range.length > 0) {
        [self.viewControllers removeObjectsInRange:range];
    }
    [self popViewControllerAnimated:animated sender:sender];
}

- (void)popToViewControllerWithBlock:(BOOL (^)(UIViewController *))block
                            animated:(BOOL)animated
                              sender:(id)sender{
    NSInteger i = [self.viewControllers count] - 1;
    for (; i >= 0; i--) {
        UIViewController *vc = (self.viewControllers)[i];
        if (block(vc)) {
            break;
        }
    }
    if (i < 0) {
        return;
    }
    if (i < [self.viewControllers count] - 2) {
        NSRange range;
        range.location = i + 1;
        range.length = [self.viewControllers count] - i - 2;
        if (range.length > 0) {
            [self.viewControllers removeObjectsInRange:range];
        }
    }
    [self popViewControllerAnimated:animated sender:sender];
}

- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
                     sender:(id)sender{
    [self popToViewControllerWithBlock:^ BOOL (UIViewController *vc) {
        return vc == viewController;
    }
                              animated:animated
                                sender:sender];
}
- (void)popToClass:(Class)className
          animated:(BOOL)animated
            sender:(id)sender{
    [self popToViewControllerWithBlock:^ BOOL (UIViewController *vc) {
        return [vc isKindOfClass:className];
    }
                              animated:animated
                                sender:sender];
}
- (void)popViewControllerAnimated:(BOOL)animated{
    [self popViewControllerAnimated:animated sender:nil];
}

- (void)popViewControllerAnimated:(BOOL)animated sender:(id)sender{
    [self popViewControllerBySender:sender
                     animationBlock:^(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender) {
                         [self exchangeViewController:preVC
                               withNextViewController:nextVC
                                            direction:NO
                                             animated:animated
                                               sender:sender
                                             complete:nil];
                     }];
}

- (void)popViewControllerAnimationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    [self popViewControllerBySender:nil animationBlock:block];
}

- (void)popViewControllerBySender:(id)sender animationBlock:(void (^)(id<MYViewControllerDelegate> preVC, id<MYViewControllerDelegate> nextVC, id sender))block {
    if (self.viewControllers.count <= 1) {
        return;
    }
    id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
    [self.viewControllers removeLastObject];
    block([last autorelease], [self.viewControllers lastObject], sender);
}

- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated {
    [self replaceTopViewController:vc animated:animated sender:nil];
}
- (void)replaceTopViewController:(id<MYViewControllerDelegate> )vc animated:(BOOL)animated sender:(id)sender{
    id<MYViewControllerDelegate> last = [[self.viewControllers lastObject] retain];
    if (last) {
        [self.viewControllers removeObject:last];
    }
    [self.viewControllers addObject:vc];
    [self exchangeViewController:[last autorelease]
          withNextViewController:vc
                       direction:YES
                        animated:animated
                          sender:sender
                        complete:nil];
}

#pragma mark - override

- (void)viewControllerWillChangeTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController {

}
- (void)viewControllerDidChangedTo:(id<MYViewControllerDelegate>)nextViewController
                              from:(id<MYViewControllerDelegate>)prevViewController {
    
}
@end

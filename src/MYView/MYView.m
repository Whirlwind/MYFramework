//
//  MYView.m
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYView.h"
#import "MYViewModel.h"

@implementation MYView

- (void)dealloc {
    for (NSString *keyPath in self.observerList.allKeys) {
        for (NSArray *array in (self.observerList)[keyPath]) {
            [array[0] removeObserver:self forKeyPath:keyPath];
        }
    }
    [_observerList release], _observerList = nil;
    [_relatedViewController release], _relatedViewController = nil;
    [super dealloc];
}

- (void)updateRelatedViewController:(MYViewController *)vc {
    self.relatedViewController = vc;
}

- (void)configView {

}

- (void)popViewModel {
    [self.relatedViewController.myNavigationController popViewControllerAnimated:YES];
}

- (void)pushViewModel:(MYViewModel *)vm {
    [self.relatedViewController.myNavigationController pushViewController:vm animated:YES];
}

- (void)pushViewModelClass:(Class)className {
    id vm = [[className alloc] init];
    [self pushViewModel:vm];
    [vm release];
}

#pragma mark - getter
- (NSMutableDictionary *)observerList {
    if (_observerList == nil) {
        _observerList = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _observerList;
}

#pragma mark - observer
- (void)registerBindingObject:(NSObject *)object
                     property:(NSString *)property
                       target:(NSObject *)target
               targetProperty:(NSString *)targetProperty {
    [self registerBindingObject:object
                       property:property
                         target:target
                 targetProperty:targetProperty
                           mode:kMYViewBindingModeOneWay];
}

- (void)registerBindingObject:(NSObject *)object
                     property:(NSString *)property
                       target:(NSObject *)target
               targetProperty:(NSString *)targetProperty
                         mode:(enum MYViewBindingMode)mode {
    SEL selector = [[target class] setterFromPropertyString:targetProperty];
    [self registerObserverObject:object keyPath:property callback:target selector:selector];
    if (mode == kMYViewBindingModeTwoWay) {
        [self registerBindingObject:target
                           property:targetProperty
                             target:object
                     targetProperty:property
                               mode:kMYViewBindingModeOneWay];
    }
}
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      callback:(NSObject *)callback
                      selector:(SEL)selector {
    [self registerObserverObject:object
                         keyPath:keyPath
                        callback:callback
                        selector:selector
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE];
}
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      selector:(SEL)selector
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context {
    [self registerObserverObject:object
                         keyPath:keyPath
                        callback:self
                        selector:selector
                         options:options
                         context:context];
}
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      callback:(NSObject *)callback
                      selector:(SEL)selector
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context {
    NSMutableArray *array = (self.observerList)[keyPath];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
    }
    [array addObject:@[object, callback, NSStringFromSelector(selector)]];
    [self.observerList setValue:array forKey:keyPath];
    [object addObserver:self forKeyPath:keyPath options:options context:context];
}

- (void)unregisterObserverObject:(NSObject *)object
                         keyPath:(NSString *)keyPath {
    [object removeObserver:self forKeyPath:keyPath];
    NSMutableArray *objects = (self.observerList)[keyPath];
    if (objects == nil) {
        return;
    }
    for (NSArray *array in objects) {
        if (array[0] == object) {
            [objects removeObject:array];
            break;
        }
    }
    if ([objects count] == 0) {
        [self.observerList removeObjectForKey:keyPath];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) {
        return;
    }
    NSArray *receivers = (self.observerList)[keyPath];
    if (receivers == nil) {
        return;
    }
    for (NSArray *array in receivers) {
        NSObject *receiver = array[0];
        if (receiver == object) {
            NSObject *callback = array[1];
            SEL selector = NSSelectorFromString((NSString *)array[2]);
            if ([NSThread isMainThread]) {
                [callback performSelector:selector
                               withObject:context == KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE ? change[NSKeyValueChangeNewKey] : change];
            } else {
                [callback performSelectorOnMainThread:selector
                                           withObject:context == KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE ? change[NSKeyValueChangeNewKey] : change
                                        waitUntilDone:YES];
            }
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - IB event
- (IBAction)backAction:(id)sender {
    [self popViewModel];
}
// 隐藏键盘
- (IBAction)cancelKeyboard:(id)sender {
    [self endEditing:YES];
}
@end

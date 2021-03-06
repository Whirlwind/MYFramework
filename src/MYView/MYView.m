//
//  MYView.m
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYView.h"
#import "MYViewModel.h"
@interface MYViewCallBacker : NSObject

@property (unsafe_unretained, nonatomic) id object;
@property (strong, nonatomic) NSString *keyPath;
@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL selector;

- (id)initWithObject:(id)object keyPath:(NSString *)keyPath observer:(id)observer selector:(SEL)selector context:(void *)context;
@end


@implementation MYViewCallBacker
- (id)initWithObject:(id)object keyPath:(NSString *)keyPath observer:(id)observer selector:(SEL)selector context:(void *)context {
    if (self = [self init]) {
        self.object = object;
        self.keyPath = keyPath;
        self.observer = observer;
        self.selector = selector;
        self.context = context;
    }
    return self;
}
@end

@implementation MYView

- (void)dealloc {
    [self stopObserver];
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
                 listenObject:(NSObject *)target
               listenProperty:(NSString *)targetProperty {
    [self registerBindingObject:object
                       property:property
                   listenObject:target
                 listenProperty:targetProperty
                           mode:kMYViewBindingModeOneWay];
}

- (void)registerBindingObject:(NSObject *)object
                     property:(NSString *)property
                 listenObject:(NSObject *)target
               listenProperty:(NSString *)targetProperty
                         mode:(enum MYViewBindingMode)mode {
    SEL selector = [[target class] setterFromPropertyString:property];
    MYPerformSelectorWithoutLeakWarningBegin
    NSObject *value = [target performSelector:NSSelectorFromString(targetProperty) withObject:nil];
    MYPerformSelectorWithoutLeakWarningEnd
    [self sendToObject:object setProperty:selector withChange:value];
    [self registerObserverObject:target keyPath:targetProperty callback:object selector:selector];
    if (mode == kMYViewBindingModeTwoWay) {
        [self registerObserverObject:object keyPath:property callback:target selector:[[target class] setterFromPropertyString:targetProperty]];
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
                         context:( void *)(KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE)];
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
    MYViewCallBacker *callbacker = [[MYViewCallBacker alloc] initWithObject:object
                                                                    keyPath:keyPath
                                                                   observer:callback
                                                                   selector:selector
                                                                    context:context];
    [array addObject:callbacker];
    [self.observerList setValue:array forKey:keyPath];
    [object addObserver:callback forKeyPath:keyPath options:options context:context];
}

- (void)unregisterObserverObject:(NSObject *)object
                         keyPath:(NSString *)keyPath {
    [object removeObserver:self forKeyPath:keyPath];
    NSMutableArray *objects = (self.observerList)[keyPath];
    if (objects == nil) {
        return;
    }
    for (MYViewCallBacker *caller in objects) {
        if (caller.object == object) {
            [objects removeObject:caller];
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
    } else if ([change[NSKeyValueChangeNewKey] isKindOfClass:[NSString class]] && [change[NSKeyValueChangeNewKey] isEqualToString:change[NSKeyValueChangeOldKey]]) {
        return;
    }
    NSArray *receivers = (self.observerList)[keyPath];
    if (receivers == nil) {
        return;
    }
    for (MYViewCallBacker *callbacker in receivers) {
        if (callbacker.object == object) {
            [self sendToObject:callbacker.observer setProperty:callbacker.selector withChange:context == (__bridge void *)(KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE) ? change[NSKeyValueChangeNewKey] : change];
        }
    }
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)sendToObject:(NSObject *)ui setProperty:(SEL)setProperty withChange:(NSObject *)change {
    if ([NSThread isMainThread]) {
        MYPerformSelectorWithoutLeakWarningBegin
        [ui performSelector:setProperty
                 withObject:change];
        MYPerformSelectorWithoutLeakWarningEnd
    } else {
        [ui performSelectorOnMainThread:setProperty
                             withObject:change
                          waitUntilDone:YES];
    }
}

- (void)stopObserver {
    [self.observerList enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, NSArray *obj, BOOL *stop) {
        for (MYViewCallBacker *callbacker in obj) {
            [callbacker.object removeObserver:callbacker.observer forKeyPath:keyPath context:callbacker.context];
        }
    }];
    [self.observerList removeAllObjects];
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

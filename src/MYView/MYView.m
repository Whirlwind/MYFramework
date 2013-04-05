//
//  MYView.m
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYView.h"

@interface MYViewCallBacker : NSObject

@property (nonatomic, assign) id recevier;
@property (nonatomic, assign) SEL selector;

- (id)initWithRecevier:(id)recevier selector:(SEL)selector;
@end


@implementation MYViewCallBacker
- (id)initWithRecevier:(id)recevier selector:(SEL)selector {
    if (self = [self init]) {
        self.recevier = recevier;
        self.selector = selector;
    }
    return self;
}
@end


@implementation MYView

- (void)dealloc {
    [self stopViewObserver];
    [_observerList release], _observerList = nil;
    [super dealloc];
}

- (void)updateRelatedViewController:(MYViewController *)vc {
    self.relatedViewController = vc;
}

- (void)configView {
    
}
#pragma mark - getter
- (NSMutableDictionary *)observerList {
    if (_observerList == nil) {
        _observerList = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _observerList;
}

#pragma mark - observer

- (void)stopViewObserver {
    for (NSString *keyPath in self.observerList.allKeys) {
        for (MYViewCallBacker *backer in (self.observerList)[keyPath]) {
            [backer.recevier removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (void)registerObserverReceiver:(id)receiver
                        selector:(SEL)selector
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options
                         context:(void *)context {
    NSMutableArray *array = (self.observerList)[keyPath];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
    }
    [array addObject:[[[MYViewCallBacker alloc] initWithRecevier:receiver selector:selector] autorelease]];
    [self.observerList setValue:array forKey:keyPath];
    [receiver addObserver:self forKeyPath:keyPath options:options context:context];
}

- (void)unregisterObserverReceiver:(id)receiver
                           keyPath:(NSString *)keyPath {
    [receiver removeObserver:self forKeyPath:keyPath];
    NSMutableArray *receivers = (self.observerList)[keyPath];
    if (receivers == nil) {
        return;
    }
    for (MYViewCallBacker *backer in receivers) {
        if (backer.recevier == receiver) {
            [receivers removeObject:backer];
            break;
        }
    }
    if ([receivers count] == 0) {
        [self.observerList removeObjectForKey:keyPath];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSArray *receivers = (self.observerList)[keyPath];
    if (receivers == nil) {
        return;
    }
    for (MYViewCallBacker *backer in receivers) {
        id receiver = backer.recevier;
        if (receiver == object) {
            SEL selector = backer.selector;
            if ([receiver respondsToSelector:selector]) {
                if ([NSThread isMainThread]) {
                    [receiver performSelector:selector withObject:change];
                } else {
                    [receiver performSelectorOnMainThread:selector withObject:change waitUntilDone:YES];
                }
            }
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
@end

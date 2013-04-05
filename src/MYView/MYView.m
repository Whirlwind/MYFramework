//
//  MYView.m
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYView.h"

@implementation MYView

- (void)dealloc {
    for (NSString *keyPath in self.observerList.allKeys) {
        for (NSArray *array in (self.observerList)[keyPath]) {
            [array[0] removeObserver:self forKeyPath:keyPath];
        }
    }
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
- (void)registerObserverReceiver:(NSObject *)receiver
                        selector:(SEL)selector
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options
                         context:(void *)context {
    NSMutableArray *array = (self.observerList)[keyPath];
    if (array == nil) {
        array = [NSMutableArray arrayWithCapacity:1];
    }
    [array addObject:@[receiver,NSStringFromSelector(selector)]];
    [self.observerList setValue:array forKey:keyPath];
    [receiver addObserver:self forKeyPath:keyPath options:options context:context];
}

- (void)unregisterObserverReceiver:(NSObject *)receiver
                           keyPath:(NSString *)keyPath {
    [receiver removeObserver:self forKeyPath:keyPath];
    NSMutableArray *receivers = (self.observerList)[keyPath];
    if (receivers == nil) {
        return;
    }
    for (NSArray *array in receivers) {
        if (array[0] == receiver) {
            [receivers removeObject:array];
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
    for (NSArray *array in receivers) {
        NSObject *receiver = array[0];
        if (receiver == object) {
            SEL selector = NSSelectorFromString((NSString *)array[1]);
            if ([NSThread isMainThread]) {
                [self performSelector:selector withObject:change];
            } else {
                [self performSelectorOnMainThread:selector withObject:change waitUntilDone:YES];
            }
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
@end

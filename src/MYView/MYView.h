//
//  MYView.h
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#define MYView_Define_ViewModelClass(name)\
- (name *)vm {\
    return (name *)self.relatedViewController;\
}

@class MYViewController;
@class MYViewModel;

static NSString *const KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE = @"KVO_CONTEXT_ONLY_PASS_CHANGED_VALUE";

enum MYViewBindingMode {
    kMYViewBindingModeOneWay = 0,
    kMYViewBindingModeTwoWay = 1
};

@interface MYView : UIView

@property (retain, nonatomic) NSMutableDictionary *observerList;

@property (retain, nonatomic) MYViewController *relatedViewController;

- (void)updateRelatedViewController:(MYViewController *)vc;
- (void)configView;
- (void)pushViewModel:(MYViewModel *)vm;
- (void)pushViewModelClass:(Class)className;
- (void)popViewModel;

- (void)registerBindingObject:(NSObject *)object
                     property:(NSString *)property
                 listenObject:(NSObject *)target
               listenProperty:(NSString *)targetProperty;
- (void)registerBindingObject:(NSObject *)object
                     property:(NSString *)property
                       listenObject:(NSObject *)target
               listenProperty:(NSString *)targetProperty
                         mode:(enum MYViewBindingMode)mode;
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      callback:(NSObject *)callback
                      selector:(SEL)selector;
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      selector:(SEL)selector
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context;
- (void)registerObserverObject:(NSObject *)object
                       keyPath:(NSString *)keyPath
                      callback:(NSObject *)callback
                      selector:(SEL)selector
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context;
- (void)unregisterObserverObject:(NSObject *)object
                         keyPath:(NSString *)keyPath;

#pragma mark - IB event
- (IBAction)backAction:(id)sender;
// 隐藏键盘
- (IBAction)cancelKeyboard:(id)sender;
@end

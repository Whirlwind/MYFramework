//
//  MYView.h
//  Weight
//
//  Created by Whirlwind on 12-11-8.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//


@class MYViewController;
@class MYViewModel;

@interface MYView : UIView
@property (retain, nonatomic) NSMutableDictionary *observerList;

@property (retain, nonatomic) MYViewController *relatedViewController;

- (void)updateRelatedViewController:(MYViewController *)vc;
- (void)configView;
- (void)pushViewModel:(MYViewModel *)vm;
- (void)pushViewModelClass:(Class)className;
- (void)popViewModel;
- (void)registerObserverReceiver:(NSObject *)receiver
                        selector:(SEL)selector
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options
                         context:(void *)context;
- (void)unregisterObserverReceiver:(NSObject *)receiver
                           keyPath:(NSString *)keyPath;

#pragma mark - IB event
- (IBAction)backAction:(id)sender;
// 隐藏键盘
- (IBAction)cancelKeyboard:(id)sender;
@end

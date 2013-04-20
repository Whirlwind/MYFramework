//
//  MYViewController.h
//  ONE
//
//  Created by Whirlwind James on 11-9-20.
//  Copyright 2011 BOOHEE. All rights reserved.
//

@class MYView;
@class MYNavigationController;
//#import "UIViewController+GuideImageView.h"
//#import "UIViewController+ViewCounter.h"


#import "MYViewControllerDelegate.h"
@interface MYViewController: UIViewController <MYViewControllerDelegate> {
    BOOL subViewDidLoaded;
    BOOL dataDidLoaded;
}
@property (strong) NSMutableArray *threadPool;

@property (assign, nonatomic) NSInteger vcType;
@property (nonatomic, weak) MYNavigationController *myNavigationController;
@property (nonatomic, assign) BOOL keyboardIsOpened;
@property (assign, nonatomic) BOOL autoResizeToFitIphone5;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, assign) NSInteger viewZIndex;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (id)initWithVCType:(NSInteger)vcType;
@end





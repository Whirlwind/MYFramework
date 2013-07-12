//
//  MYTextView.h
//  Pods
//
//  Created by Whirlwind on 13-7-9.
//
//

#import <UIKit/UIKit.h>

@interface MYTextView : UITextView

@property (assign, nonatomic) BOOL allowSelection;
@property (strong, nonatomic) NSAttributedString *attributedString;

- (CGFloat)lineHeight;

@end

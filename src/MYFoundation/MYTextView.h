//
//  MYTextView.h
//  Pods
//
//  Created by Whirlwind on 13-7-9.
//
//

#import <UIKit/UIKit.h>

@interface MYTextView : UITextView
/**
 The string that is displayed when there is no other text in the text view.

 The default value is `nil`.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 The color of the placeholder.

 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

@property (assign, nonatomic) BOOL allowSelection;
@property (strong, nonatomic) NSAttributedString *attributedString;
@property (nonatomic, assign) BOOL isEditing;
- (CGFloat)lineHeight;

@end

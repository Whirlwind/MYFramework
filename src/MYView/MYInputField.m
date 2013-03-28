//
//  MYInputField.m
//  food
//
//  Created by 詹 迟晶 on 12-2-26.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "MYInputField.h"
#import <QuartzCore/QuartzCore.h>

#ifndef kCustomCheckBoxViewValidViewBorderWidth
#define kCustomCheckBoxViewValidViewBorderWidth 1.0f
#endif

@implementation MYInputField

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [_backgroundImageView release], _backgroundImageView = nil;
    [_validView release], _validView = nil;
    [_inputField release], _inputField = nil;
    [_inputKeyboard release], _inputKeyboard = nil;
    [_unitString release], _unitString = nil;
    [_stringWhenEmpty release], _stringWhenEmpty = nil;
    [_validPredicate release], _validPredicate = nil;
    [super dealloc];
}

#pragma mark - init
- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initData];
        [self initUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData{
    self.showValidErrorVisual = YES;
    self.isValid = YES;
    self.stringWhenEmpty = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)initUI{
    [self addSubview:self.validView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouch:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    if (self.backgroundImageView) {
        [self addSubview:self.backgroundImageView];
    }
#ifdef kCustomCheckBoxViewBorderWidth
    [self.layer setBorderWidth:kCustomCheckBoxViewBorderWidth];
#endif
#ifdef kCustomCheckBoxViewBorderColor
    [self.layer setBorderColor:kCustomCheckBoxViewBorderColor.CGColor];
#endif
    [self addSubview:self.inputField];
}

- (UIImageView *)initialiseBackgroundImageView{
#ifdef kCheckBoxBackgroundImage
    UIImage *image = [UIImage imageNamed:kCheckBoxBackgroundImage];
    UIImage *backgroundImage = nil;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 5) {
        backgroundImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2.0f - 1, image.size.width / 2.0f - 1, image.size.height / 2.0f - 1, image.size.width / 2.0f - 1)];
    } else {
        backgroundImage = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0f - 1 topCapHeight:image.size.height / 2.0f - 1];
    }
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundView setFrame:CGRectMakeWithSize(self.frame.size)];
    return [backgroundView autorelease];
#else
    return nil;
#endif
}
- (UITextField *)initialiseInputField{
    UITextField *inputField = [[UITextField alloc] initWithFrame:self.bounds];
    [inputField setDelegate:self];
    [inputField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [inputField setClearButtonMode:UITextFieldViewModeWhileEditing];
#ifdef kCustomCheckBoxViewInputFieldBorderStyle
    [inputField setBorderStyle:kCustomCheckBoxViewInputFieldBorderStyle];
#endif
#ifdef kCustomCheckBoxViewInputFieldBackgroundColor
    [inputField setBackgroundColor:kCustomCheckBoxViewInputFieldBackgroundColor];
#endif
#ifdef kCustomCheckBoxViewInputFieldTextFont
    [inputField setFont:kCustomCheckBoxViewInputFieldTextFont];
#endif
#ifdef kCustomCheckBoxViewInputFieldTextColor
    [inputField setTextColor:kCustomCheckBoxViewInputFieldTextColor];
#endif
#ifdef kCustomCheckBoxViewInputFieldBorderWidth
    [inputField.layer setBorderWidth:kCustomCheckBoxViewInputFieldBorderWidth];
#endif
#ifdef kCustomCheckBoxViewInputFieldBorderColor
    [inputField.layer setBorderColor:kColor8.CGColor];
#endif
    if (self.inputKeyboard != nil) {
        inputField.inputView = self.inputKeyboard;
    }
    if (self.inputKeyboardAccessoryView != nil) {
        [inputField setInputAccessoryView:self.inputKeyboardAccessoryView];
    }
    return [inputField autorelease];
}

- (UIView *)initialiseInputKeyboard{
    return nil;
}

- (UIView *)initialiseInputKeyboardAccessoryView{
//    UIView *V = [[UIView alloc] initWithFrame:CGRectMake(0, -32, 32, 32)];
//    [V setBackgroundColor:[UIColor blueColor]];
//    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [okBtn setFrame:CGRectMake(0, 0, 32, 32)];
//    [okBtn setBackgroundImage:[UIImage imageNamed:@"picker-switch"] forState:UIControlStateNormal];
//    okBtn.backgroundColor = [UIColor clearColor];
//    [okBtn addTarget:self action:@selector(cancelEditing) forControlEvents:UIControlEventTouchUpInside];
//    [V addSubview:okBtn];
//    return [V autorelease];
    return nil;
}

#pragma mark - getter
- (NSStringValid *)validPredicate{
    if (_validPredicate == nil) {
        _validPredicate = [[NSStringValid alloc] init];
        [_validPredicate setAllowEmpty:NO];
    }
    return _validPredicate;
}
- (UIView *)validView{
    if (_validView == nil) {
        _validView = [[UIView alloc] initWithFrame:CGRectMake(-kCustomCheckBoxViewValidViewBorderWidth, -kCustomCheckBoxViewValidViewBorderWidth, self.frame.size.width + 2*kCustomCheckBoxViewValidViewBorderWidth, self.frame.size.height + 2*kCustomCheckBoxViewValidViewBorderWidth)];
#ifdef kCustomCheckBoxViewValidViewBorderColor
        [_validView.layer setBorderColor:kCustomCheckBoxViewValidViewBorderColor.CGColor];
#endif
#ifdef kCustomCheckBoxViewValidViewCornerRadius
        [_validView.layer setCornerRadius:10.0];
#endif
        [_validView.layer setBorderWidth:kCustomCheckBoxViewValidViewBorderWidth];
        [_validView setHidden:YES];
        [self.validView setAlpha:0.0f];
    }
    return _validView;
}
- (UITextField *)inputField{
    if (_inputField == nil) {
        self.inputField = [self initialiseInputField];
    }
    return _inputField;
}
- (UIView *)inputKeyboard{
    if (_inputKeyboard == nil) {
        self.inputKeyboard = [self initialiseInputKeyboard];
    }
    return _inputKeyboard;
}
- (UIView *)inputKeyboardAccessoryView{
    if (_inputKeyboardAccessoryView == nil) {
        self.inputKeyboardAccessoryView = [self initialiseInputKeyboardAccessoryView];
    }
    return _inputKeyboardAccessoryView;
}
- (UIImageView *)backgroundImageView{
    if (_backgroundImageView == nil) {
        self.backgroundImageView = [self initialiseBackgroundImageView];
    }
    return _backgroundImageView;
}
#pragma mark - setter
- (void)showErrorVisualView {
    [self.validView setHidden:NO];
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [UIView setAnimationRepeatCount:3];
                         [self.validView setAlpha:0.8f];
                     }
                     completion:^(BOOL finished) {
                     }];
}
- (void)hideErrorVisualView {
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.validView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self.validView setHidden:YES];
                     }];
}
- (void)updateValidResultVisual {
    if (self.showValidErrorVisual) {
        if (!_isValid) {
            [self showErrorVisualView];
        }else{
            [self hideErrorVisualView];
        }
    }
}

- (void)setIsValid:(BOOL)isValid{
    BOOL oldIsValid = _isValid;
    _isValid = isValid;
    [self updateValidResultVisual];
    if (oldIsValid == isValid) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckBoxValidChanged object:self];
}

- (void)setShowValidErrorVisual:(BOOL)showValidErrorVisual{
    _showValidErrorVisual = showValidErrorVisual;
    if (!showValidErrorVisual) {
        [self.validView setHidden:YES];
        [self.validView setAlpha:0.0f];
    }
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = [self value];
//    self.isValid = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideErrorVisualView];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([textField.text isEqualToString:@""]) {
        textField.text = self.stringWhenEmpty;
    }
    if (self.unitString != nil && textField.text != nil && ![textField.text isEqualToString:@""]) {
        textField.text = [NSString stringWithFormat:@"%@ %@", textField.text, self.unitString];
    }
    [self tryValid];
    if (self.checkBoxDelegate && [self.checkBoxDelegate respondsToSelector:@selector(checkbox:didInputValue:)]) {
        [self.checkBoxDelegate checkbox:self didInputValue:self.value];
    }
}

- (void)setValue:(NSObject *)value{
    [self tryValid];
    [self willChangeValueForKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.inputField];
    [self didChangeValueForKey:@"value"];
}

- (NSString *)value{
    NSString *string = self.inputField.text;
    if (self.unitString != nil) {
        string = [string stringByReplacingOccurrencesOfString:self.unitString withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [string length])];
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string;
}

- (BOOL)tryValid{
     self.isValid = [self.validPredicate evaluateWithString:[self value]];
    NSLog(@"%@ valid %d", self, self.isValid);
    return self.isValid;
}

#pragma mark - keyboard event
- (void)keyboardWasShown:(NSNotification *)aNotification{
    NSDictionary* info = [aNotification userInfo];
    
    //键盘的大小
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self updateScrollViewOffset:kbRect];
}
- (void)keyboardWillHidden:(NSNotification *)aNotification{
    UIScrollView *scView = [self superScrollView];
    if (scView == nil) {
        return;
    }
    if (![scView isDragging])
        [scView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)keyboardDidShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    
    //键盘的大小
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self updateScrollViewOffset:kbRect];
}
#pragma mark - scroll
- (UIScrollView *)superScrollView{
    UIView *superView = [self superview];
    while (superView != nil && ![superView isKindOfClass:[UIScrollView class]]) {
        superView = [superView superview];
    }
    if (superView == nil) {
        return nil;
    }
    return (UIScrollView *)superView;
}
- (void)updateScrollViewOffset:(CGRect)kbRect{
    if ([self.inputField isFirstResponder]) {
        UIScrollView *scView = [self superScrollView];
        if (scView == nil) {
            return;
        }
        
        // 取得scrollView相对于屏幕的坐标
        CGRect scViewWindowRect = [scView convertRect:scView.bounds toView:nil];
        // 取得屏幕的坐标
        CGRect windowRect = [(UIWindow *)[[[UIApplication sharedApplication] windows] objectAtIndex:0] bounds];
        // 取得可见区域高度
        CGFloat visibleHeight = windowRect.size.height - kbRect.size.height - scViewWindowRect.origin.y;
        // 取得self相对于scrollView的坐标
        NSLog(@"%f", [self bounds].origin.y);
        CGRect selfScrollViewRect = [self convertRect:[self bounds] toView:scView];
        CGFloat selfScrollViewY = selfScrollViewRect.origin.y - scView.contentOffset.y;
        NSLog(@"contentOffset: %f, %f", scView.contentOffset.x, scView.contentOffset.y);
        CGFloat moveHeight = self.frame.size.height / 2 + selfScrollViewY - visibleHeight / 2;
        CGPoint offset = [scView contentOffset];
        CGPoint scrollPoint = CGPointMake(offset.x, offset.y + moveHeight > 0 ? offset.y + moveHeight : 0);
        [scView setContentOffset:scrollPoint animated:YES];
    }
}

#pragma mark - self touch event
- (void)viewTouch:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        [self becameEditing];
    }
}

#pragma mark - edit status

- (void)cancelEditing{
    [self.inputField resignFirstResponder];
}
- (void)becameEditing{
    [self.inputField becomeFirstResponder];
}
//#pragma mark - Action
//- (void)touchInputField:(id)sender{
//
//}
@end

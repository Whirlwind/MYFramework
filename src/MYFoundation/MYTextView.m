//
//  MYTextView.m
//  Pods
//
//  Created by Whirlwind on 13-7-9.
//
//

#import "MYTextView.h"
@interface UITextView ()

- (id)styleString;

@end

@implementation MYTextView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allowSelection = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.allowSelection = YES;
    }
    return self;
}

- (CGFloat)lineHeight {
    return 2.f;
}

- (id)styleString {
    return [[super styleString] stringByAppendingString:[NSString stringWithFormat:@"; line-height: %fem", [self lineHeight]]];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.attributedText = attributedString;
}

- (NSAttributedString *)attributedString {
    return self.attributedText;
}

- (BOOL)canBecomeFirstResponder {
    return self.allowSelection;
}
@end

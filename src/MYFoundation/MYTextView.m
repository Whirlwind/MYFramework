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
        self.contentInset = UIEdgeInsetsMake(8.f, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
		[self _initialize];
    }
    return self;
}

- (CGFloat)lineHeight {
    return 20.f;
}

- (id)styleString {
    return [[super styleString] stringByAppendingString:[NSString stringWithFormat:@"; line-height: %fpx", [self lineHeight]]];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.attributedText = attributedString;
}

- (NSAttributedString *)attributedString {
    return self.attributedText;
}

- (BOOL)canBecomeFirstResponder {
    if (self.allowSelection) {
        return [super canBecomeFirstResponder];
    }
    return NO;
}

- (void)setText:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return;
    }
	[super setText:string];
	[self setNeedsDisplay];
}


- (void)insertText:(NSString *)string {
	[super insertText:string];
	[self setNeedsDisplay];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
	[super setAttributedText:attributedText];
	[self setNeedsDisplay];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}

	_placeholder = string;
	[self setNeedsDisplay];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
	[super setContentInset:contentInset];
	[self setNeedsDisplay];
}


- (void)setFont:(UIFont *)font {
	[super setFont:font];
	[self setNeedsDisplay];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	[self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	if (self.text.length == 0 && self.placeholder) {
		// Inset the rect
		rect = UIEdgeInsetsInsetRect(rect, self.contentInset);

		// TODO: This is hacky. Not sure why 8 is the magic number
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
        if (self.contentInset.top == 0.0f) {
            rect.origin.y += 8.0f;
        }
        rect.origin.y += 3.f;
		// Draw the text
		[_placeholderTextColor set];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
#else
		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
#endif
	}
}


#pragma mark - Private

- (void)_initialize {
    self.allowSelection = YES;
    self.isEditing = NO;
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}


- (void)_textChanged:(NSNotification *)notification {
	[self setNeedsDisplay];
}

- (void)_textBeginEditing:(NSNotification *)notification {
	[self setIsEditing:YES];
}

- (void)_textEndEditing:(NSNotification *)notification {
	[self setIsEditing:NO];
    self.text = self.text;
}
@end

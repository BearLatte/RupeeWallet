//
//  UITextView+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void)setPlaceholderWithText:(NSString *)text placeholderColor:(NSString *)placeholderColor {
    [self.superview layoutIfNeeded];
    if(text == nil) {
        return;
    }
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = [UIColor colorWithHexString:placeholderColor];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = self.font;
    placeholderLabel.text = text;
    placeholderLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    placeholderLabel.textAlignment = self.textAlignment;
    [self addSubview:placeholderLabel];
    [self setValue:placeholderLabel forKeyPath:@"_placeholderLabel"];
}
@end

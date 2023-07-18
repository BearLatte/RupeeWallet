//
//  UITextView+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void)setPlaceholderWithText:(NSString *)text placeholderColor:(NSString *)placeholderColor {
    if(text == nil) {
        return;
    }
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = [UIColor colorWithHexString:placeholderColor];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = self.font;
    placeholderLabel.text = text;
    [placeholderLabel sizeToFit];
    [self addSubview:placeholderLabel];
    [self setValue:placeholderLabel forKeyPath:@"_placeholderLabel"];
}
@end

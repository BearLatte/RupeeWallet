//
//  RWAttributedLabel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWAttributedLabel.h"

@interface RWAttributedLabel()
@property(nonatomic, copy) NSString *keyColor;
@property(nonatomic, copy) NSString *valueColor;
@property(nonatomic, strong) UIFont *keyFont;
@property(nonatomic, strong) UIFont *valueFont;
@end

@implementation RWAttributedLabel
+ (instancetype)attributedLabelWithKey:(NSString *)key
                              keyColor:(NSString *)keyColor
                               keyFont:(UIFont *)keyFont
                                 value:(NSString *)value
                            valueColor:(NSString *)valueColor
                             valueFont:(UIFont *)valueFont {
    RWAttributedLabel *label = [[self alloc] init];
    label.keyColor = keyColor;
    label.keyFont = keyFont;
    label.valueColor = valueColor;
    label.valueFont = valueFont;
    label.key = key;
    label.value = value;
    [label confitAttributedString];
    return label;
}

- (void)setKey:(NSString *)key {
    _key = key;
    [self confitAttributedString];
}

- (void)setValue:(NSString *)value {
    _value = value;
    [self confitAttributedString];
}

- (void)confitAttributedString {
    NSString *currentKey = self.key == nil ? @" " : self.key;
    NSString *currentValue = self.value == nil ? @" " : self.value;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSAttributedString *keyText = [[NSAttributedString alloc] initWithString:currentKey attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:self.keyColor],
        NSFontAttributeName : self.keyFont
    }];
    
    NSAttributedString *valueText = [[NSAttributedString alloc] initWithString:currentValue attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:self.valueColor],
        NSFontAttributeName : self.valueFont
    }];
    
    [attributedText appendAttributedString:keyText];
    [attributedText appendAttributedString:valueText];
    
    self.attributedText = attributedText;
}

@end

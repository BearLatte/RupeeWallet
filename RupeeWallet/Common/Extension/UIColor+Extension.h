//
//  UIColor+Extension.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)
+ (UIColor *)random;
+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END

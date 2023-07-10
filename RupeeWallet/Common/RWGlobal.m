//
//  RWGlobal.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import "RWGlobal.h"
#import "RWLoginViewController.h"

NSString * const IS_LOGIN_KEY = @"kIS_LOGIN_KEY";
NSString * const ACCESS_TOKEN_KEY = @"kACCESS_TOKEN_KEY";
NSString * const IDFA_KEY = @"kIDFA_KEY";

NSString * const THEME_COLOR = @"#4BB7AC";
NSString * const THEME_TEXT_COLOR = @"#333333";
NSString * const INDICATOR_TEXT_COLOR = @"#999999";
NSString * const NORMAL_BORDER_COLOR = @"#D4D3D8";
NSString * const THEME_BACKGROUND_COLOR = @"#EBF0EF";
NSString * const TAB_BAR_NORMAL_FOREGROUND_COLOR = @"#BDBDBD";

@implementation RWGlobal
+ (RWGlobal *)sharedGlobal {
    static RWGlobal *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[RWGlobal alloc] init];
    });
    
    return global;
}

- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN_KEY];
}

- (void)go2login {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:IS_LOGIN_KEY];
    
    RWLoginViewController *loginVC = [[RWLoginViewController alloc] init];
    loginVC.modalStyle = RWModalStylePresent;
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:loginVC animated:YES completion:nil];
}

- (UIButton *)createThemeButtonWithTitle:(NSString * _Nullable)title cornerRadius:(CGFloat)radius {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:THEME_COLOR]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:NORMAL_BORDER_COLOR]] forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (UILabel *)createLabelWithText:(NSString *_Nullable)text font:(UIFont *)font textColor:(NSString *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor colorWithHexString:color];
    return label;
}

- (UILabel *)createAttributedStringLabelWithKey:(NSString *)key keyColor:(NSString *)keyColor value:(NSString *)value valueColor:(NSString *)valueColor {
    keyColor = keyColor == nil ? INDICATOR_TEXT_COLOR : keyColor;
    valueColor = valueColor == nil ? THEME_TEXT_COLOR : valueColor;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", key, value]];
    [attStr addAttributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName : [UIColor colorWithHexString:keyColor]
    } range:NSRangeFromString(key)];
    [attStr addAttributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName : [UIColor colorWithHexString:valueColor]
    } range:NSRangeFromString(value)];
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attStr;
    return label;
}
@end

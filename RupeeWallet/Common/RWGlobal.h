//
//  RWGlobal.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Userdefaults key
extern NSString * const IS_LOGIN_KEY;
extern NSString * const ACCESS_TOKEN_KEY;
extern NSString * const IDFA_KEY;


// MARK: - Color value
extern NSString * const THEME_COLOR;
extern NSString * const THEME_TEXT_COLOR;
extern NSString * const INDICATOR_TEXT_COLOR;
extern NSString * const NORMAL_BORDER_COLOR;
extern NSString * const THEME_BACKGROUND_COLOR;
extern NSString * const TAB_BAR_NORMAL_FOREGROUND_COLOR;


@interface RWGlobal : NSObject
@property(nonatomic, assign) BOOL isLogin;
+ (RWGlobal *)sharedGlobal;
- (void)go2login;
- (UIButton *)createThemeButtonWithTitle: (NSString *_Nullable)title cornerRadius: (CGFloat)radius;
- (UILabel *)createLabelWithText: (NSString *_Nullable)text font:(UIFont *)font textColor: (NSString *)color;
- (UILabel *)createAttributedStringLabelWithKey:(NSString *_Nonnull)key keyColor:(NSString *_Nullable)keyColor value:(NSString *_Nonnull)value valueColor:(NSString *_Nullable)valueColor;
@end

NS_ASSUME_NONNULL_END

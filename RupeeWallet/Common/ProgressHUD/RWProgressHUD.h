//
//  RWProgressHUD.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWProgressHUDMaskType) {
    RWProgressHUDMaskTypeClear = 0,       // don't allow user interactions
    RWProgressHUDMaskTypeInteraction,     // allow user interactions
};

@interface RWProgressHUD : NSObject
// show only message
+ (void)showInfoWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType;
+ (void)showInfoWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType completion:(void (^)(void))completion;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString*)status;

// show indicator/message
+ (void)show;
+ (void)showWithMaskType:(RWProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType;
+ (void)showWithProgress:(CGFloat)progress;
+ (void)showWithProgress:(CGFloat)progress maskType:(RWProgressHUDMaskType)maskType;

// dismiss hud
+ (void)dismiss;
+ (void)dismissWithDelay:(NSTimeInterval)delay;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion;

+ (BOOL)isVisible;
@end

NS_ASSUME_NONNULL_END

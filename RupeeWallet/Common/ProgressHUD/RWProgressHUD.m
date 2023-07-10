//
//  RWProgressHUD.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "RWProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

NSTimeInterval const HUDMinDismissTimeInterval = 1.0;
NSTimeInterval const HUDMaxDismissTimeInterval = 5.0;

@implementation RWProgressHUD
+ (void)load {
    [self customHUD];
}

+ (void)showInfoWithStatus:(NSString *)status {
    [self showInfoWithStatus:status maskType:RWProgressHUDMaskTypeClear];
}

+ (void)showInfoWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType {
    [self showInfoWithStatus:status maskType:maskType completion:^{

    }];
}

+ (void)showInfoWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType completion:(void (^)(void))completion {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == RWProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showInfoWithStatus:status];
    NSTimeInterval delay = [self displayDurationForString:status];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [self resetHUDBehavior];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString*)status {
    [self resetHUDBehavior];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)show {
    [self showWithMaskType:RWProgressHUDMaskTypeClear];
}

+ (void)showWithMaskType:(RWProgressHUDMaskType)maskType {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == RWProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString *)status {
    [self showWithStatus:status maskType:RWProgressHUDMaskTypeClear];
}

+ (void)showWithStatus:(NSString *)status maskType:(RWProgressHUDMaskType)maskType {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == RWProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showWithProgress:(CGFloat)progress{
    [self showWithProgress:progress maskType:RWProgressHUDMaskTypeClear];
}

+ (void)showWithProgress:(CGFloat)progress maskType:(RWProgressHUDMaskType)maskType{
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == RWProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showProgress:progress];
}

+ (void)dismiss {
    [self dismissWithDelay:0];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [self dismissWithDelay:delay completion:^{

    }];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (BOOL)isVisible {
    return [SVProgressHUD isVisible];
}

+ (void)customHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:HUDMinDismissTimeInterval];
    [SVProgressHUD setMaximumDismissTimeInterval:HUDMaxDismissTimeInterval];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [SVProgressHUD setInfoImage:nil];
#pragma clang diagnostic pop
}

+ (void)resetHUDBehavior {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (NSTimeInterval)displayDurationForString:(NSString *)string {
    CGFloat minimum = MAX((CGFloat)string.length * 0.06 + 0.5, HUDMinDismissTimeInterval);
    return MIN(minimum, HUDMaxDismissTimeInterval);
}
@end

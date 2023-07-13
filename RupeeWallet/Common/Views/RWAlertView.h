//
//  RWAlertView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWAlertStyle) {
    RWAlertStyleTips,
    RWAlertStyleError
};

typedef void(^ConfirmButtonAction)(void);

@interface RWAlertView : UIView
+ (void)showAlertViewWithStyle:(RWAlertStyle)alertStyle title:(NSString *_Nullable)title message:(NSString *)message confirmAction:(ConfirmButtonAction _Nullable)action;
@end

NS_ASSUME_NONNULL_END

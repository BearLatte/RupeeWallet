//
//  RWAlertView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfirmButtonAction)(void);

@interface RWAlertView : UIView
+ (void)showAlertViewWithTitle:(NSString *_Nullable)title message:(NSString *)message confirmAction:(ConfirmButtonAction)action;
@end

NS_ASSUME_NONNULL_END

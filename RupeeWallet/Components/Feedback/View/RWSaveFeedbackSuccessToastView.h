//
//  RWSaveFeedbackSuccessToastView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWSaveFeedbackSuccessToastView : UIView
+ (void)showToastWithOkAction:(void(^)(void))action;
@end

NS_ASSUME_NONNULL_END

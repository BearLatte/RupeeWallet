//
//  RWProblemToastView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWProblemToastView : UIView
+ (void)showToastWithTitle:(NSString *)title list:(NSArray *)list didSelectedAction:(void(^)(NSInteger selectedIndex))didSelectedAction;
@end

NS_ASSUME_NONNULL_END

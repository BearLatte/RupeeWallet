//
//  UIViewController+Extension.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)
+ (void)closeGesturePopWithController:(UIViewController *)viewController;
+ (void)openGesturePopWithController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END

//
//  UIViewController+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
+ (void)closeGesturePopWithController:(UIViewController *)viewController {
    if([viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        for (UIGestureRecognizer *reco in viewController.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            reco.enabled = NO;
        }
    }
}

+ (void)openGesturePopWithController:(UIViewController *)viewController {
    if([viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        for (UIGestureRecognizer *reco in viewController.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            reco.enabled = YES;
        }
    }
}
@end

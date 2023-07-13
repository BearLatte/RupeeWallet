//
//  UIViewController+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
- (void)closeGesturePop {
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        for (UIGestureRecognizer *reco in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            reco.enabled = NO;
        }
    }
}

- (void)openGesturePop {
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        for (UIGestureRecognizer *reco in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            reco.enabled = YES;
        }
    }
}
@end

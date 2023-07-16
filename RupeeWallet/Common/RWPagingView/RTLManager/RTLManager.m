//
//  RTCManager.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RTLManager.h"

@implementation RTLManager
+ (BOOL)supportRTL {
    return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}

+ (void)horizontalFlipView:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(-1, 1);
}

+ (void)horizontalFlipViewIfNeeded:(UIView *)view {
    if ([self supportRTL]) {
        [self horizontalFlipView:view];
    }
}
@end

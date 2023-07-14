//
//  UIView+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)corner {
    [self.superview layoutIfNeeded];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
    shapLayer.path = path.CGPath;
    self.layer.mask = shapLayer;
}

@end

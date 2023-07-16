//
//  UIColor+RWAdd.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "UIColor+RWAdd.h"

@implementation UIColor (RWAdd)
- (CGFloat)rw_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)rw_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)rw_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)rw_alpha {
    return CGColorGetAlpha(self.CGColor);
}
@end

//
//  RWPagingFactory.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingFactory.h"
#import <UIKit/UIKit.h>
#import "UIColor+RWAdd.h"

@implementation RWPagingFactory
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.rw_red to:toColor.rw_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.rw_green to:toColor.rw_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.rw_blue to:toColor.rw_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.rw_alpha to:toColor.rw_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end

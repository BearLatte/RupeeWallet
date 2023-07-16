//
//  RWPagingFactory.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingFactory : NSObject
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;
+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END

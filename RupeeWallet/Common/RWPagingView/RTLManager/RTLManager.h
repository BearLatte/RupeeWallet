//
//  RTLManager.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTLManager : NSObject
+ (BOOL)supportRTL;
+ (void)horizontalFlipView:(UIView *)view;
+ (void)horizontalFlipViewIfNeeded:(UIView *)view;
@end

NS_ASSUME_NONNULL_END

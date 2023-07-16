//
//  UIColor+RWAdd.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RWAdd)

@property (nonatomic, assign, readonly) CGFloat rw_red;
@property (nonatomic, assign, readonly) CGFloat rw_green;
@property (nonatomic, assign, readonly) CGFloat rw_blue;
@property (nonatomic, assign, readonly) CGFloat rw_alpha;

@end

NS_ASSUME_NONNULL_END

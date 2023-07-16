//
//  RWPagingIndicatorLineView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RWPagingIndicatorLineStyle) {
    RWPagingIndicatorLineStyle_Normal         = 0,
    RWPagingIndicatorLineStyle_Lengthen       = 1,
    RWPagingIndicatorLineStyle_LengthenOffset = 2,
};

@interface RWPagingIndicatorLineView : RWPagingIndicatorComponentView
@property (nonatomic, assign) RWPagingIndicatorLineStyle lineStyle;
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@end

NS_ASSUME_NONNULL_END

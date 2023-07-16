//
//  RWPagingIndicatorImageView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingIndicatorImageView : RWPagingIndicatorComponentView
@property (nonatomic, strong, readonly) UIImageView *indicatorImageView;
@property (nonatomic, assign) BOOL indicatorImageViewRollEnabled;
@property (nonatomic, assign) CGSize indicatorImageViewSize;
@end

NS_ASSUME_NONNULL_END

//
//  RWPagingVerticalTitleZoomView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingVerticalTitleZoomView : RWPagingTitleView
@property (nonatomic, assign) CGFloat maxVerticalFontScale;
@property (nonatomic, assign) CGFloat minVerticalFontScale;
@property (nonatomic, assign) CGFloat maxVerticalCellSpacing;
@property (nonatomic, assign) CGFloat minVerticalCellSpacing;
- (void)listDidScrollWithVerticalHeightPercent:(CGFloat)percent;
@end

NS_ASSUME_NONNULL_END

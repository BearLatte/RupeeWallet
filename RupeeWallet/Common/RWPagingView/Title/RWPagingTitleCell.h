//
//  RWPagingTitleCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorCell.h"
#import "RWPagingViewDefines.h"
#import "RWPagingViewDefines.h"

@class RWPagingTitleCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingTitleCell : RWPagingIndicatorCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

- (RWPagingCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(RWPagingTitleCellModel *)cellModel baseScale:(CGFloat)baseScale;

- (RWPagingCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(RWPagingTitleCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString;

- (RWPagingCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(RWPagingTitleCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END

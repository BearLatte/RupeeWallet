//
//  RWPagingDotCellModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RWPagingDotRelativePosition) {
    RWPagingDotRelativePosition_TopLeft = 0,
    RWPagingDotRelativePosition_TopRight,
    RWPagingDotRelativePosition_BottomLeft,
    RWPagingDotRelativePosition_BottomRight,
};

@interface RWPagingDotCellModel : RWPagingTitleCellModel
@property (nonatomic, assign) BOOL dotHidden;
@property (nonatomic, assign) RWPagingDotRelativePosition relativePosition;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, assign) CGFloat dotCornerRadius;
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, assign) CGPoint dotOffset;
@end

NS_ASSUME_NONNULL_END

//
//  RWPagingDotView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleView.h"
#import "RWPagingDotCell.h"
#import "RWPagingDotCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingDotView : RWPagingTitleView
@property (nonatomic, assign) RWPagingDotRelativePosition relativePosition;
@property (nonatomic, strong) NSArray <NSNumber *> *dotStates;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, assign) CGFloat dotCornerRadius;
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, assign) CGPoint dotOffset;
@end

NS_ASSUME_NONNULL_END

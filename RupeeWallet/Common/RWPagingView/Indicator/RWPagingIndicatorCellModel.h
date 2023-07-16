//
//  RWPagingIndicatorCellModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingIndicatorCellModel : RWPagingBaseCellModel
@property (nonatomic, assign, getter=isSepratorLineShowEnabled) BOOL sepratorLineShowEnabled;
@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame; // 底部指示器的 frame 转换到 cell 的 frame

@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;
@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;
@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;
@end

NS_ASSUME_NONNULL_END

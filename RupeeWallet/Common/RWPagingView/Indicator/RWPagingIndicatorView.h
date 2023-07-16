//
//  RWPagingIndicatorView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingBaseView.h"
#import "RWPagingIndicatorCell.h"
#import "RWPagingIndicatorCellModel.h"
#import "RWPagingIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingIndicatorView : RWPagingBaseView
@property (nonatomic, strong) NSArray <UIView<RWPagingIndicatorProtocol> *> *indicators;
@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;
@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;
@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

//----------------------separatorLine-----------------------//
@property (nonatomic, assign, getter=isSeparatorLineShowEnabled) BOOL separatorLineShowEnabled;
@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, assign) CGSize separatorLineSize;
@end

@interface RWPagingIndicatorView (UISubclassingIndicatorHooks)
- (void)refreshLeftCellModel:(RWPagingBaseCellModel *)leftCellModel rightCellModel:(RWPagingBaseCellModel *)rightCellModel ratio:(CGFloat)ratio NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END

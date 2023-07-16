//
//  RWPagingNumberView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleView.h"
#import "RWPagingNumberCell.h"
#import "RWPagingNumberCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *_Nullable(^RWNumberStringFormatterBlock) (NSInteger number);
@interface RWPagingNumberView : RWPagingTitleView
@property (nonatomic, strong) NSArray <NSNumber *> *counts;
@property (nonatomic, copy) RWNumberStringFormatterBlock _Nullable numberStringFormatterBlock;
@property (nonatomic, strong) UIFont *numberLabelFont;
@property (nonatomic, strong) UIColor *numberBackgroundColor;
@property (nonatomic, strong) UIColor *numberTitleColor;
@property (nonatomic, assign) CGFloat numberLabelWidthIncrement;
@property (nonatomic, assign) CGFloat numberLabelHeight;
@property (nonatomic, assign) CGPoint numberLabelOffset;
@property (nonatomic, assign) BOOL shouldMakeRoundWhenSingleNumber;

@end

NS_ASSUME_NONNULL_END

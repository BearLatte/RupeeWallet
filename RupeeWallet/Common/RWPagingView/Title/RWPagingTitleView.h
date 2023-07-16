//
//  RWPagingTitleView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorView.h"
#import "RWPagingTitleCell.h"
#import "RWPagingTitleCellModel.h"
#import "RWPagingViewDefines.h"

@class RWPagingTitleView;

NS_ASSUME_NONNULL_BEGIN

@protocol RWPagingTitleViewDataSource <NSObject>
@optional
- (CGFloat)categoryTitleView:(RWPagingTitleView *)titleView widthForTitle:(NSString *)title;
@end


@interface RWPagingTitleView : RWPagingIndicatorView

@property (nonatomic, weak) id<RWPagingTitleViewDataSource> titleDataSource;

@property (nonatomic, strong) NSArray <NSString *>*titles;

@property (nonatomic, assign) NSInteger titleNumberOfLines;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *titleSelectedFont;
@property (nonatomic, assign, getter=isTitleColorGradientEnabled) BOOL titleColorGradientEnabled;
@property (nonatomic, assign, getter=isTitleLabelMaskEnabled) BOOL titleLabelMaskEnabled;

//----------------------titleLabelZoomEnabled-----------------------//
@property (nonatomic, assign, getter=isTitleLabelZoomEnabled) BOOL titleLabelZoomEnabled;

@property (nonatomic, assign, getter=isTitleLabelZoomScrollGradientEnabled) BOOL titleLabelZoomScrollGradientEnabled;
@property (nonatomic, assign) CGFloat titleLabelZoomScale;
@property (nonatomic, assign) CGFloat titleLabelZoomSelectedVerticalOffset;
//----------------------titleLabelStrokeWidth-----------------------//
@property (nonatomic, assign, getter=isTitleLabelStrokeWidthEnabled) BOOL titleLabelStrokeWidthEnabled;

@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;
//----------------------titleLabel缩放中心位置-----------------------//
@property (nonatomic, assign) CGFloat titleLabelVerticalOffset;

@property (nonatomic, assign) RWPagingTitleLabelAnchorPointStyle titleLabelAnchorPointStyle; 

@end

NS_ASSUME_NONNULL_END

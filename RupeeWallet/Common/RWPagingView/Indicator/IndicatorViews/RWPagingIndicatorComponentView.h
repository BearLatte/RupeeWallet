//
//  RWPagingIndicatorComponentView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import "RWPagingViewDefines.h"
#import "RWPagingIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingIndicatorComponentView : UIView<RWPagingIndicatorProtocol>
@property (nonatomic, assign) RWPagingComponentPosition componentPosition;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat indicatorWidthIncrement;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat indicatorCornerRadius;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign) RWPagingIndicatorScrollStyle scrollStyle;
@property (nonatomic, assign) NSTimeInterval scrollAnimationDuration;
- (CGFloat)indicatorWidthValue:(CGRect)cellFrame;
- (CGFloat)indicatorHeightValue:(CGRect)cellFrame;
- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame;

@end

NS_ASSUME_NONNULL_END

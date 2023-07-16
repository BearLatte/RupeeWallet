//
//  RWPagingIndicatorComponentView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorComponentView.h"

@implementation RWPagingIndicatorComponentView
#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureDefaultValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureDefaultValue];
    }
    return self;
}

- (void)configureDefaultValue {
    _componentPosition = RWPagingComponentPosition_Bottom;
    _scrollEnabled = YES;
    _verticalMargin = 0;
    _scrollAnimationDuration = 0.25;
    _indicatorWidth = RWPagingViewAutomaticDimension;
    _indicatorWidthIncrement = 0;
    _indicatorHeight = 3;
    _indicatorCornerRadius = RWPagingViewAutomaticDimension;
    _indicatorColor = [UIColor redColor];
    _scrollStyle = RWPagingIndicatorScrollStyleSimple;
}

#pragma mark - Public

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == RWPagingViewAutomaticDimension) {
        return cellFrame.size.width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

- (CGFloat)indicatorHeightValue:(CGRect)cellFrame {
    if (self.indicatorHeight == RWPagingViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.indicatorHeight;
}

- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame {
    if (self.indicatorCornerRadius == RWPagingViewAutomaticDimension) {
        return [self indicatorHeightValue:cellFrame]/2;
    }
    return self.indicatorCornerRadius;
}

#pragma mark - RWPagingIndicatorProtocol

- (void)rw_refreshState:(RWPagingIndicatorParamsModel *)model {

}

- (void)rw_contentScrollViewDidScroll:(RWPagingIndicatorParamsModel *)model {

}

- (void)rw_selectedCell:(RWPagingIndicatorParamsModel *)model {
    
}

@end

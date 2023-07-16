//
//  RWPagingndicatorRainbowLineView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingndicatorRainbowLineView.h"
#import "RWPagingFactory.h"

@implementation RWPagingndicatorRainbowLineView
- (void)rw_refreshState:(RWPagingIndicatorParamsModel *)model {
    [super rw_refreshState:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}

- (void)rw_contentScrollViewDidScroll:(RWPagingIndicatorParamsModel *)model {
    [super rw_contentScrollViewDidScroll:model];

    UIColor *leftColor = self.indicatorColors[model.leftIndex];
    UIColor *rightColor = self.indicatorColors[model.rightIndex];
    UIColor *color = [RWPagingFactory interpolationColorFrom:leftColor to:rightColor percent:model.percent];
    self.backgroundColor = color;
}

- (void)rw_selectedCell:(RWPagingIndicatorParamsModel *)model {
    [super rw_selectedCell:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}


@end

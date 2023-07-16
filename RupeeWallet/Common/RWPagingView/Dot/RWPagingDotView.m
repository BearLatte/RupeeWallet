//
//  RWPagingDotView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingDotView.h"

@implementation RWPagingDotView
- (void)initializeData {
    [super initializeData];

    _relativePosition = RWPagingDotRelativePosition_TopRight;
    _dotSize = CGSizeMake(10, 10);
    _dotCornerRadius = RWPagingViewAutomaticDimension;
    _dotColor = [UIColor redColor];
    _dotOffset = CGPointZero;
}

- (Class)preferredCellClass {
    return [RWPagingDotCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        RWPagingDotCellModel *cellModel = [[RWPagingDotCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    RWPagingDotCellModel *myCellModel = (RWPagingDotCellModel *)cellModel;
    myCellModel.dotHidden = [self.dotStates[index] boolValue];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.dotSize = self.dotSize;
    myCellModel.dotColor = self.dotColor;
    myCellModel.dotOffset = self.dotOffset;
    if (self.dotCornerRadius == RWPagingViewAutomaticDimension) {
        myCellModel.dotCornerRadius = self.dotSize.height/2;
    }else {
        myCellModel.dotCornerRadius = self.dotCornerRadius;
    }
}
@end

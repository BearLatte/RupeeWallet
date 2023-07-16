//
//  RWPagingNumberView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingNumberView.h"
#import "RWPagingNumberCellModel.h"

@implementation RWPagingNumberView
- (void)dealloc {
    self.numberStringFormatterBlock = nil;
}

- (void)initializeData {
    [super initializeData];

    self.cellSpacing = 25;
    _numberTitleColor = [UIColor whiteColor];
    _numberBackgroundColor = [UIColor colorWithRed:241/255.0 green:147/255.0 blue:95/255.0 alpha:1];
    _numberLabelHeight = 14;
    _numberLabelWidthIncrement = 10;
    _numberLabelFont = [UIFont systemFontOfSize:11];
    _shouldMakeRoundWhenSingleNumber = NO;
}

- (Class)preferredCellClass {
    return [RWPagingNumberCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        RWPagingNumberCellModel *cellModel = [[RWPagingNumberCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    RWPagingNumberCellModel *myCellModel = (RWPagingNumberCellModel *)cellModel;
    myCellModel.count = [self.counts[index] integerValue];
    if (self.numberStringFormatterBlock != nil) {
        myCellModel.numberString = self.numberStringFormatterBlock(myCellModel.count);
    }else {
        myCellModel.numberString = [NSString stringWithFormat:@"%ld", (long)myCellModel.count];
    }
    myCellModel.numberBackgroundColor = self.numberBackgroundColor;
    myCellModel.numberTitleColor = self.numberTitleColor;
    myCellModel.numberLabelHeight = self.numberLabelHeight;
    myCellModel.numberLabelOffset = self.numberLabelOffset;
    myCellModel.numberLabelWidthIncrement = self.numberLabelWidthIncrement;
    myCellModel.numberLabelFont = self.numberLabelFont;
    myCellModel.shouldMakeRoundWhenSingleNumber = self.shouldMakeRoundWhenSingleNumber;
}

@end

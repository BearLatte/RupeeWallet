//
//  RWPagingTitleView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleView.h"
#import "RWPagingFactory.h"

@implementation RWPagingTitleView
- (void)initializeData {
    [super initializeData];

    _titleNumberOfLines = 1;
    _titleLabelZoomEnabled = NO;
    _titleLabelZoomScale = 1.2;
    _titleColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColorGradientEnabled = NO;
    _titleLabelMaskEnabled = NO;
    _titleLabelZoomScrollGradientEnabled = YES;
    _titleLabelStrokeWidthEnabled = NO;
    _titleLabelSelectedStrokeWidth = -3;
    _titleLabelVerticalOffset = 0;
    _titleLabelAnchorPointStyle = RWPagingTitleLabelAnchorPointStyleCenter;
}

- (UIFont *)titleSelectedFont {
    if (_titleSelectedFont) {
        return _titleSelectedFont;
    }
    return self.titleFont;
}

#pragma mark - Override

- (Class)preferredCellClass {
    return [RWPagingTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        RWPagingTitleCellModel *cellModel = [[RWPagingTitleCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshSelectedCellModel:(RWPagingBaseCellModel *)selectedCellModel unselectedCellModel:(RWPagingBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    RWPagingTitleCellModel *myUnselectedCellModel = (RWPagingTitleCellModel *)unselectedCellModel;
    RWPagingTitleCellModel *myselectedCellModel = (RWPagingTitleCellModel *)selectedCellModel;
    if (self.isSelectedAnimationEnabled && (selectedCellModel.selectedType == RWPagingCellSelectedTypeClick || selectedCellModel.selectedType == RWPagingCellSelectedTypeCode)) {
        BOOL isUnselectedCellVisible = NO;
        BOOL isSelectedCellVisible = NO;
        NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.item == myUnselectedCellModel.index) {
                isUnselectedCellVisible = YES;
                continue;
            } else if (indexPath.item == myselectedCellModel.index) {
                isSelectedCellVisible = YES;
                continue;
            }
        }
        if (!isUnselectedCellVisible) {
            myUnselectedCellModel.titleCurrentColor = myUnselectedCellModel.titleNormalColor;
            myUnselectedCellModel.titleLabelCurrentZoomScale = myUnselectedCellModel.titleLabelNormalZoomScale;
            myUnselectedCellModel.titleLabelCurrentStrokeWidth = myUnselectedCellModel.titleLabelNormalStrokeWidth;
        }
        if (!isSelectedCellVisible) {
            myselectedCellModel.titleCurrentColor = myselectedCellModel.titleSelectedColor;
            myselectedCellModel.titleLabelCurrentZoomScale = myselectedCellModel.titleLabelSelectedZoomScale;
            myselectedCellModel.titleLabelCurrentStrokeWidth = myselectedCellModel.titleLabelSelectedStrokeWidth;
        }
    } else {
        myselectedCellModel.titleCurrentColor = myselectedCellModel.titleSelectedColor;
        myselectedCellModel.titleLabelCurrentZoomScale = myselectedCellModel.titleLabelSelectedZoomScale;
        myselectedCellModel.titleLabelCurrentStrokeWidth = myselectedCellModel.titleLabelSelectedStrokeWidth;

        myUnselectedCellModel.titleCurrentColor = myUnselectedCellModel.titleNormalColor;
        myUnselectedCellModel.titleLabelCurrentZoomScale = myUnselectedCellModel.titleLabelNormalZoomScale;
        myUnselectedCellModel.titleLabelCurrentStrokeWidth = myUnselectedCellModel.titleLabelNormalStrokeWidth;
    }
}

- (void)refreshLeftCellModel:(RWPagingBaseCellModel *)leftCellModel rightCellModel:(RWPagingBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    RWPagingTitleCellModel *leftModel = (RWPagingTitleCellModel *)leftCellModel;
    RWPagingTitleCellModel *rightModel = (RWPagingTitleCellModel *)rightCellModel;

    if (self.isTitleLabelZoomEnabled && self.isTitleLabelZoomScrollGradientEnabled) {
        leftModel.titleLabelCurrentZoomScale = [RWPagingFactory interpolationFrom:self.titleLabelZoomScale to:1.0 percent:ratio];
        rightModel.titleLabelCurrentZoomScale = [RWPagingFactory interpolationFrom:1.0 to:self.titleLabelZoomScale percent:ratio];
    }

    if (self.isTitleLabelStrokeWidthEnabled) {
        leftModel.titleLabelCurrentStrokeWidth = [RWPagingFactory interpolationFrom:leftModel.titleLabelSelectedStrokeWidth to:leftModel.titleLabelNormalStrokeWidth percent:ratio];
        rightModel.titleLabelCurrentStrokeWidth = [RWPagingFactory interpolationFrom:rightModel.titleLabelNormalStrokeWidth to:rightModel.titleLabelSelectedStrokeWidth percent:ratio];
    }

    if (self.isTitleColorGradientEnabled) {
        leftModel.titleCurrentColor = [RWPagingFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
        rightModel.titleCurrentColor = [RWPagingFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == RWPagingViewAutomaticDimension) {
        if (self.titleDataSource && [self.titleDataSource respondsToSelector:@selector(categoryTitleView:widthForTitle:)]) {
            return [self.titleDataSource categoryTitleView:self widthForTitle:self.titles[index]];
        } else {
            return ceilf([self.titles[index] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.width);
        }
    } else {
        return self.cellWidth;
    }
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    RWPagingTitleCellModel *model = (RWPagingTitleCellModel *)cellModel;
    model.title = self.titles[index];
    model.titleNumberOfLines = self.titleNumberOfLines;
    model.titleFont = self.titleFont;
    model.titleSelectedFont = self.titleSelectedFont;
    model.titleNormalColor = self.titleColor;
    model.titleSelectedColor = self.titleSelectedColor;
    model.titleLabelMaskEnabled = self.isTitleLabelMaskEnabled;
    model.titleLabelZoomEnabled = self.isTitleLabelZoomEnabled;
    model.titleLabelNormalZoomScale = 1;
    model.titleLabelZoomSelectedVerticalOffset = self.titleLabelZoomSelectedVerticalOffset;
    model.titleLabelSelectedZoomScale = self.titleLabelZoomScale;
    model.titleLabelStrokeWidthEnabled = self.isTitleLabelStrokeWidthEnabled;
    model.titleLabelNormalStrokeWidth = 0;
    model.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
    model.titleLabelVerticalOffset = self.titleLabelVerticalOffset;
    model.titleLabelAnchorPointStyle = self.titleLabelAnchorPointStyle;
    if (index == self.selectedIndex) {
        model.titleCurrentColor = model.titleSelectedColor;
        model.titleLabelCurrentZoomScale = model.titleLabelSelectedZoomScale;
        model.titleLabelCurrentStrokeWidth= model.titleLabelSelectedStrokeWidth;
    }else {
        model.titleCurrentColor = model.titleNormalColor;
        model.titleLabelCurrentZoomScale = model.titleLabelNormalZoomScale;
        model.titleLabelCurrentStrokeWidth = model.titleLabelNormalStrokeWidth;
    }
}
@end

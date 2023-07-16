//
//  RWPagingIndicatorCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorCell.h"
#import "RWPagingIndicatorCellModel.h"

@interface RWPagingIndicatorCell()
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation RWPagingIndicatorCell

- (void)initializeViews {
    [super initializeViews];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    RWPagingIndicatorCellModel *model = (RWPagingIndicatorCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    RWPagingIndicatorCellModel *model = (RWPagingIndicatorCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}


@end

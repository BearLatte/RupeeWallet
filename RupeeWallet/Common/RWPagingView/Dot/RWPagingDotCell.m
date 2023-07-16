//
//  RWPagingDotCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingDotCell.h"
#import "RWPagingDotCellModel.h"

@interface RWPagingDotCell()
@property (nonatomic, strong) UIView *dot;
@end

@implementation RWPagingDotCell
- (void)initializeViews {
    [super initializeViews];

    _dot = [[UIView alloc] init];
    [self.contentView addSubview:self.dot];
    self.dot.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    RWPagingDotCellModel *myCellModel = (RWPagingDotCellModel *)cellModel;
    self.dot.hidden = !myCellModel.dotHidden;
    self.dot.backgroundColor = myCellModel.dotColor;
    self.dot.layer.cornerRadius = myCellModel.dotCornerRadius;
    [NSLayoutConstraint deactivateConstraints:self.dot.constraints];
    [self.dot.widthAnchor constraintEqualToConstant:myCellModel.dotSize.width].active = YES;
    [self.dot.heightAnchor constraintEqualToConstant:myCellModel.dotSize.height].active = YES;
    switch (myCellModel.relativePosition) {
        case RWPagingDotRelativePosition_TopLeft:
        {
            [self.dot.centerXAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor constant:myCellModel.dotOffset.x].active = YES;
            [self.dot.centerYAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:myCellModel.dotOffset.y].active = YES;
        }
            break;
        case RWPagingDotRelativePosition_TopRight:
        {
            [self.dot.centerXAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:myCellModel.dotOffset.x].active = YES;
            [self.dot.centerYAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:myCellModel.dotOffset.y].active = YES;
        }
            break;
        case RWPagingDotRelativePosition_BottomLeft:
        {
            [self.dot.centerXAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor constant:myCellModel.dotOffset.x].active = YES;
            [self.dot.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:myCellModel.dotOffset.y].active = YES;
        }
            break;
        case RWPagingDotRelativePosition_BottomRight:
        {
            [self.dot.centerXAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:myCellModel.dotOffset.x].active = YES;
            [self.dot.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:myCellModel.dotOffset.y].active = YES;
        }
            break;
    }
}
@end

//
//  RWPagingVerticalTitleZoomCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingVerticalTitleZoomCell.h"
#import "RWPagingVerticalTitleZoomCellModel.h"

@implementation RWPagingVerticalTitleZoomCell
- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    RWPagingVerticalTitleZoomCellModel *myCellModel = (RWPagingVerticalTitleZoomCellModel *)cellModel;

    if (myCellModel.isTitleLabelZoomEnabled) {
        //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleLabelZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
        UIFont *maxScaleFont = [UIFont fontWithDescriptor:myCellModel.titleFont.fontDescriptor size:myCellModel.titleFont.pointSize*myCellModel.maxVerticalFontScale];
        CGFloat baseScale = myCellModel.titleFont.lineHeight/maxScaleFont.lineHeight;
        if (myCellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myCellModel]) {
            RWPagingCellSelectedAnimationBlock block = [self preferredTitleZoomAnimationBlock:myCellModel baseScale:baseScale];
            [self addSelectedAnimationBlock:block];
        } else {
            self.titleLabel.font = maxScaleFont;
            self.maskTitleLabel.font = maxScaleFont;
            CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*myCellModel.titleLabelCurrentZoomScale, baseScale*myCellModel.titleLabelCurrentZoomScale);
            self.titleLabel.transform = currentTransform;
            self.maskTitleLabel.transform = currentTransform;
        }
    } else {
        if (myCellModel.isSelected) {
            self.titleLabel.font = myCellModel.titleSelectedFont;
            self.maskTitleLabel.font = myCellModel.titleSelectedFont;
        }else {
            self.titleLabel.font = myCellModel.titleFont;
            self.maskTitleLabel.font = myCellModel.titleFont;
        }
    }

    [self.titleLabel sizeToFit];
}
@end

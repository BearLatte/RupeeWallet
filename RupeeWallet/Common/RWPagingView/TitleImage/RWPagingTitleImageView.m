//
//  RWPagingTitleImageView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleImageView.h"
#import "RWPagingFactory.h"
#import "RWPagingTitleImageCell.h"
#import "RWPagingTitleImageCellModel.h"

@implementation RWPagingTitleImageView
- (void)dealloc {
    self.loadImageBlock = nil;
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _titleImageSpacing = 5;
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
}

- (Class)preferredCellClass {
    return [RWPagingTitleImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        RWPagingTitleImageCellModel *cellModel = [[RWPagingTitleImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
    
    if (!self.imageTypes || (self.imageTypes.count == 0)) {
        NSMutableArray *types = [NSMutableArray arrayWithCapacity:self.titles.count];
        for (int i = 0; i< self.titles.count; i++) {
            [types addObject:@(RWPagingTitleImageType_LeftImage)];
        }
        self.imageTypes = [NSArray arrayWithArray:types];
    }
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    RWPagingTitleImageCellModel *myCellModel = (RWPagingTitleImageCellModel *)cellModel;
    myCellModel.loadImageBlock = self.loadImageBlock;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageType = [self.imageTypes[index] integerValue];
    myCellModel.imageSize = self.imageSize;
    myCellModel.titleImageSpacing = self.titleImageSpacing;
    if (self.imageInfoArray && self.imageInfoArray.count != 0) {
        myCellModel.imageInfo = self.imageInfoArray[index];
    }else if (self.imageNames && self.imageNames.count != 0) {
        myCellModel.imageName = self.imageNames[index];
    }else if (self.imageURLs && self.imageURLs.count != 0) {
        myCellModel.imageURL = self.imageURLs[index];
    }
    if (self.selectedImageInfoArray && self.selectedImageInfoArray.count != 0) {
        myCellModel.selectedImageInfo = self.selectedImageInfoArray[index];
    }else if (self.selectedImageNames && self.selectedImageNames.count != 0) {
        myCellModel.selectedImageName = self.selectedImageNames[index];
    }else if (self.selectedImageURLs && self.selectedImageURLs.count != 0) {
        myCellModel.selectedImageURL = self.selectedImageURLs[index];
    }
    myCellModel.imageZoomEnabled = self.imageZoomEnabled;
    myCellModel.imageZoomScale = ((index == self.selectedIndex) ? self.imageZoomScale : 1.0);
}

- (void)refreshSelectedCellModel:(RWPagingBaseCellModel *)selectedCellModel unselectedCellModel:(RWPagingBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    RWPagingTitleImageCellModel *myUnselectedCellModel = (RWPagingTitleImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    RWPagingTitleImageCellModel *myselectedCellModel = (RWPagingTitleImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshLeftCellModel:(RWPagingBaseCellModel *)leftCellModel rightCellModel:(RWPagingBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    RWPagingTitleImageCellModel *leftModel = (RWPagingTitleImageCellModel *)leftCellModel;
    RWPagingTitleImageCellModel *rightModel = (RWPagingTitleImageCellModel *)rightCellModel;

    if (self.isImageZoomEnabled) {
        leftModel.imageZoomScale = [RWPagingFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [RWPagingFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == RWPagingViewAutomaticDimension) {
        CGFloat titleWidth = [super preferredCellWidthAtIndex:index];
        RWPagingTitleImageType type = [self.imageTypes[index] integerValue];
        CGFloat cellWidth = 0;
        switch (type) {
            case RWPagingTitleImageType_OnlyTitle:
                cellWidth = titleWidth;
                break;
            case RWPagingTitleImageType_OnlyImage:
                cellWidth = self.imageSize.width;
                break;
            case RWPagingTitleImageType_LeftImage:
            case RWPagingTitleImageType_RightImage:
                cellWidth = titleWidth + self.titleImageSpacing + self.imageSize.width;
                break;
            case RWPagingTitleImageType_TopImage:
            case RWPagingTitleImageType_BottomImage:
                cellWidth = MAX(titleWidth, self.imageSize.width);
                break;
        }
        return cellWidth;
    }
    return self.cellWidth;
}
@end

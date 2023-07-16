//
//  RWPagingImageView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingImageView.h"
#import "RWPagingFactory.h"

@implementation RWPagingImageView
- (void)dealloc {
    self.loadImageBlock = nil;
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
    _imageCornerRadius = 0;
}

- (Class)preferredCellClass {
    return [RWPagingImageCell class];
}

- (void)refreshDataSource {
    NSUInteger count = 0;
    if (self.imageInfoArray.count > 0) {
        count = self.imageInfoArray.count;
    }else if (self.imageNames.count > 0) {
        count = self.imageNames.count;
    }else {
        count = self.imageURLs.count;
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        RWPagingImageCellModel *cellModel = [[RWPagingImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshSelectedCellModel:(RWPagingBaseCellModel *)selectedCellModel unselectedCellModel:(RWPagingBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    RWPagingImageCellModel *myUnselectedCellModel = (RWPagingImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    RWPagingImageCellModel *myselectedCellModel = (RWPagingImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    RWPagingImageCellModel *myCellModel = (RWPagingImageCellModel *)cellModel;
    myCellModel.loadImageBlock = self.loadImageBlock;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageSize = self.imageSize;
    myCellModel.imageCornerRadius = self.imageCornerRadius;
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

- (void)refreshLeftCellModel:(RWPagingBaseCellModel *)leftCellModel rightCellModel:(RWPagingBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    RWPagingImageCellModel *leftModel = (RWPagingImageCellModel *)leftCellModel;
    RWPagingImageCellModel *rightModel = (RWPagingImageCellModel *)rightCellModel;

    if (self.isImageZoomEnabled) {
        leftModel.imageZoomScale = [RWPagingFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [RWPagingFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == RWPagingViewAutomaticDimension) {
        return self.imageSize.width;
    }
    return self.cellWidth;
}

@end

//
//  RWPagingImageCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingImageCell.h"
#import "RWPagingImageCellModel.h"

@interface RWPagingImageCell()
@property (nonatomic, strong) id currentImageInfo;
@property (nonatomic, strong) NSString *currentImageName;
@property (nonatomic, strong) NSURL *currentImageURL;
@end

@implementation RWPagingImageCell
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.currentImageInfo = nil;
    self.currentImageName = nil;
    self.currentImageURL = nil;
}

- (void)initializeViews {
    [super initializeViews];

    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    RWPagingImageCellModel *myCellModel = (RWPagingImageCellModel *)self.cellModel;
    self.imageView.bounds = CGRectMake(0, 0, myCellModel.imageSize.width, myCellModel.imageSize.height);
    self.imageView.center = self.contentView.center;
    if (myCellModel.imageCornerRadius && (myCellModel.imageCornerRadius != 0)) {
        self.imageView.layer.cornerRadius = myCellModel.imageCornerRadius;
        self.imageView.layer.masksToBounds = YES;
    }
}

- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    RWPagingImageCellModel *myCellModel = (RWPagingImageCellModel *)cellModel;
    if (myCellModel.loadImageBlock != nil) {
        id currentImageInfo = myCellModel.imageInfo;
        if (myCellModel.isSelected) {
            currentImageInfo = myCellModel.selectedImageInfo;
        }
        if (currentImageInfo && ![currentImageInfo isEqual:self.currentImageInfo]) {
            self.currentImageInfo = currentImageInfo;
            if (myCellModel.loadImageBlock) {
                myCellModel.loadImageBlock(self.imageView, currentImageInfo);
            }
        }
    } else {
        NSString *currentImageName;
        NSURL *currentImageURL;
        if (myCellModel.imageName) {
            currentImageName = myCellModel.imageName;
        } else if (myCellModel.imageURL) {
            currentImageURL = myCellModel.imageURL;
        }
        if (myCellModel.isSelected) {
            if (myCellModel.selectedImageName) {
                currentImageName = myCellModel.selectedImageName;
            } else if (myCellModel.selectedImageURL) {
                currentImageURL = myCellModel.selectedImageURL;
            }
        }
        if (currentImageName && ![currentImageName isEqualToString:self.currentImageName]) {
            self.currentImageName = currentImageName;
            self.imageView.image = [UIImage imageNamed:currentImageName];
        } else if (currentImageURL && ![currentImageURL.absoluteString isEqualToString:self.currentImageURL.absoluteString]) {
            self.currentImageURL = currentImageURL;
            if (myCellModel.loadImageCallback) {
                myCellModel.loadImageCallback(self.imageView, currentImageURL);
            }
        }
    }
    
    if (myCellModel.isImageZoomEnabled) {
        self.imageView.transform = CGAffineTransformMakeScale(myCellModel.imageZoomScale, myCellModel.imageZoomScale);
    }else {
        self.imageView.transform = CGAffineTransformIdentity;
    }
}
@end

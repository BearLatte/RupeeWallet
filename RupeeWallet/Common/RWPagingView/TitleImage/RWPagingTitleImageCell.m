//
//  RWPagingTitleImageCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleImageCell.h"
#import "RWPagingTitleImageCellModel.h"

@interface RWPagingTitleImageCell()
@property (nonatomic, strong) id currentImageInfo;
@property (nonatomic, strong) NSString *currentImageName;
@property (nonatomic, strong) NSURL *currentImageURL;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSLayoutConstraint *imageViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageViewHeightConstraint;
@end

@implementation RWPagingTitleImageCell
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.currentImageInfo = nil;
    self.currentImageName = nil;
    self.currentImageURL = nil;
}

- (void)initializeViews {
    [super initializeViews];

    [self.titleLabel removeFromSuperview];

    _imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewWidthConstraint = [self.imageView.widthAnchor constraintEqualToConstant:0];
    self.imageViewWidthConstraint.active = YES;
    self.imageViewHeightConstraint = [self.imageView.heightAnchor constraintEqualToConstant:0];
    self.imageViewHeightConstraint.active = YES;

    _stackView = [[UIStackView alloc] init];
    self.stackView.alignment = UIStackViewAlignmentCenter;
    [self.contentView addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.stackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
}

- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    RWPagingTitleImageCellModel *myCellModel = (RWPagingTitleImageCellModel *)cellModel;

    self.titleLabel.hidden = NO;
    self.imageView.hidden = NO;
    [self.stackView removeArrangedSubview:self.titleLabel];
    [self.stackView removeArrangedSubview:self.imageView];
    CGSize imageSize = myCellModel.imageSize;
    self.imageViewWidthConstraint.constant = imageSize.width;
    self.imageViewHeightConstraint.constant = imageSize.height;
    self.stackView.spacing = myCellModel.titleImageSpacing;
    
    switch (myCellModel.imageType) {
        case RWPagingTitleImageType_TopImage: {
            self.stackView.axis = UILayoutConstraintAxisVertical;
            [self.stackView addArrangedSubview:self.imageView];
            [self.stackView addArrangedSubview:self.titleLabel];
            break;
        }
        case RWPagingTitleImageType_LeftImage: {
            self.stackView.axis = UILayoutConstraintAxisHorizontal;
            [self.stackView addArrangedSubview:self.imageView];
            [self.stackView addArrangedSubview:self.titleLabel];
            break;
        }
        case RWPagingTitleImageType_BottomImage: {
            self.stackView.axis = UILayoutConstraintAxisVertical;
            [self.stackView addArrangedSubview:self.titleLabel];
            [self.stackView addArrangedSubview:self.imageView];
            break;
        }
        case RWPagingTitleImageType_RightImage: {
            self.stackView.axis = UILayoutConstraintAxisHorizontal;
            [self.stackView addArrangedSubview:self.titleLabel];
            [self.stackView addArrangedSubview:self.imageView];
            break;
        }
        case RWPagingTitleImageType_OnlyImage: {
            self.titleLabel.hidden = YES;
            [self.stackView addArrangedSubview:self.imageView];
            break;
        }
        case RWPagingTitleImageType_OnlyTitle: {
            self.imageView.hidden = YES;
            [self.stackView addArrangedSubview:self.titleLabel];
            break;
        }
    }

    /**
     * Because the `- (void) reloadData: (RWPagingBaseCellModel *) cellModel` method will be called back many times, especially when scrolling around countless times, if the image is triggered to load each time, it will consume a lot of performance.
     * Therefore, the picture will be loaded only when the picture has changed.
     */
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
    }else {
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
    } else {
        self.imageView.transform = CGAffineTransformIdentity;
    }
}
@end

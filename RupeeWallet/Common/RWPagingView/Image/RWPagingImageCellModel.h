//
//  RWPagingImageCellModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingImageCellModel : RWPagingIndicatorCellModel

@property (nonatomic, strong) id imageInfo;
@property (nonatomic, strong) id selectedImageInfo;
@property (nonatomic, copy) void(^loadImageBlock)(UIImageView *imageView, id info);

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) CGFloat imageCornerRadius;

@property (nonatomic, assign, getter=isImageZoomEnabled) BOOL imageZoomEnabled;

@property (nonatomic, assign) CGFloat imageZoomScale;

/// The following properties will be deprecated
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) NSString *selectedImageName;
@property (nonatomic, strong) NSURL *selectedImageURL;
@property (nonatomic, copy) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);
@end

NS_ASSUME_NONNULL_END

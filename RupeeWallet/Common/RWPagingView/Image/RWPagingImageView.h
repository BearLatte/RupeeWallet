//
//  RWPagingImageView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingIndicatorView.h"
#import "RWPagingImageCell.h"
#import "RWPagingImageCellModel.h"
#import "RWPagingViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingImageView : RWPagingIndicatorView
@property (nonatomic, strong) NSArray <id>*imageInfoArray;
@property (nonatomic, strong) NSArray <id>*selectedImageInfoArray;
@property (nonatomic, copy) RWLoadImageBlock _Nullable loadImageBlock;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat imageCornerRadius; //图片圆角
@property (nonatomic, assign, getter=isImageZoomEnabled) BOOL imageZoomEnabled;
@property (nonatomic, assign) CGFloat imageZoomScale;

/**
 * the following attributes will be deprecated. Use `imageInfoArray`,
 * `selectedImageInfoArray` and `loadImageBlock` attributes to complete the
 * requirements.
 */
@property (nonatomic, strong) NSArray <NSString *>*imageNames;
@property (nonatomic, strong) NSArray <NSURL *>*imageURLs;
@property (nonatomic, strong) NSArray <NSString *>*selectedImageNames;
@property (nonatomic, strong) NSArray <NSURL *>*selectedImageURLs;
@property (nonatomic, copy) RWLoadImageCallback _Nullable loadImageCallback;
@end

NS_ASSUME_NONNULL_END

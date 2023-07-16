//
//  RWPagingTitleImageView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleView.h"
#import "RWPagingViewDefines.h"
#import "RWPagingTitleImageCell.h"
#import "RWPagingTitleImageCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingTitleImageView : RWPagingTitleView
@property (nonatomic, strong) NSArray <id>*imageInfoArray;
@property (nonatomic, strong) NSArray <id>*selectedImageInfoArray;
@property (nonatomic, copy) RWLoadImageBlock _Nullable loadImageBlock;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat titleImageSpacing;
@property (nonatomic, assign, getter=isImageZoomEnabled) BOOL imageZoomEnabled;
@property (nonatomic, assign) CGFloat imageZoomScale;
@property (nonatomic, strong) NSArray <NSNumber *> *imageTypes;

/**
 * The following attributes will be deprecated. Use `imageInfoArray`, `selectedImageInfoArray` and `loadImageBlock` attributes to complete the requirements.
 */
@property (nonatomic, strong) NSArray <NSString *>*imageNames;
@property (nonatomic, strong) NSArray <NSString *>*selectedImageNames;
@property (nonatomic, strong) NSArray <NSURL *>*imageURLs;
@property (nonatomic, strong) NSArray <NSURL *>*selectedImageURLs;
@property (nonatomic, copy) RWLoadImageCallback _Nullable loadImageCallback;

@end

NS_ASSUME_NONNULL_END

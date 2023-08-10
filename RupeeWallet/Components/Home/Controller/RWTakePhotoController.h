//
//  RWTakePhotoController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^UploadedFaceImage)(void);
@interface RWTakePhotoController : RWBaseViewController
@property(nonatomic, copy) UploadedFaceImage uploadedImageAction;
@end

NS_ASSUME_NONNULL_END

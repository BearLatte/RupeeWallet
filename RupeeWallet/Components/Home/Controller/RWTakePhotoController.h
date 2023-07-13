//
//  RWTakePhotoController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SubmitImageAction)(UIImage *selectedImage);
@interface RWTakePhotoController : RWBaseViewController
@property(nonatomic, copy) SubmitImageAction submitAction;
@end

NS_ASSUME_NONNULL_END

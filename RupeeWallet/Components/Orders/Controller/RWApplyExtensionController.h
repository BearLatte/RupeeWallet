//
//  RWApplyExtensionController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/17.
//

#import "RWBaseViewController.h"
#import "RWOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWApplyExtensionController : RWBaseViewController
@property(nonatomic, copy) NSString *orderNumber;
@property(nonatomic, copy) NSString *productLogo;
@property(nonatomic, copy) NSString *productName;
@end

NS_ASSUME_NONNULL_END

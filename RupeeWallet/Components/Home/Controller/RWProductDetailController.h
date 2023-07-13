//
//  RWProductDetailController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import "RWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWProductDetailController : RWBaseViewController
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, assign) BOOL isRecommend;
@end

NS_ASSUME_NONNULL_END

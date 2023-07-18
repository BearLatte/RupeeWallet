//
//  RWFeedbackDetailController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWBaseScrollViewController.h"
#import "RWFeedbackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWFeedbackDetailController : RWBaseScrollViewController
@property(nonatomic, strong) RWFeedbackModel *feedback;
@end

NS_ASSUME_NONNULL_END

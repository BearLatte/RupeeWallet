//
//  RWBankCardController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "RWBaseScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWBankCardController : RWBaseScrollViewController
@property(nonatomic, assign, getter=isModify) BOOL modify;
@property(nonatomic, strong) RWContentModel *authStatus;
@end

NS_ASSUME_NONNULL_END

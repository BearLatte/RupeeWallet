//
//  RWProductDetailModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWProductDetailModel : NSObject
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *spaceName;
/// 到账金额
@property(nonatomic, copy) NSString *receiveAmountStr;
/// 手续费
@property(nonatomic, copy) NSString *feeAmountStr;
@property(nonatomic, copy) NSString *verificationFeeStr;
@property(nonatomic, copy) NSString *gstFeeStr;
/// 利息
@property(nonatomic, copy) NSString *interestAmountStr;
/// 逾期费率
@property(nonatomic, copy) NSString *overdueChargeStr;
/// 应还金额
@property(nonatomic, copy) NSString *repayAmountStr;
/// 借款天数
@property(nonatomic, copy) NSString *loanDate;
/// 借款金额
@property(nonatomic, copy) NSString *loanAmountStr;
@end

NS_ASSUME_NONNULL_END

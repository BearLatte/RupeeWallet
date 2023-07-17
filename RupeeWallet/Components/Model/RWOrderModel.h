//
//  RWOrderModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWOrderModel : NSObject
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *loanName;
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *bankCardNo;
/// 距离还款日时间
@property(nonatomic, copy) NSString *daysToRepay;
/// 借款单号
@property(nonatomic, copy) NSString *loanOrderNo;
/// loan  date
@property(nonatomic, copy) NSString *applyDateStr;

@property(nonatomic, copy) NSString *loanAmountStr;
@property(nonatomic, copy) NSString *loanDate;
/// 放款时间
@property(nonatomic, copy) NSString *receiveDateStr;
@property(nonatomic, copy) NSString *receiveAmountStr;
@property(nonatomic, copy) NSString *repayAmountStr;
@property(nonatomic, copy) NSString *repayDateStr;
@property(nonatomic, copy) NSString *overDueDays;
/// 逾期费
@property(nonatomic, copy) NSString *overDueFeeStr;
/// 0待审核  1待放款 2待还款 5已逾期  6放款失败 7审核失败 8已还款-未逾期 9已还款-有逾期
@property(nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END

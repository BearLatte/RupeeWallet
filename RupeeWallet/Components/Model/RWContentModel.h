//
//  RWContentModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <Foundation/Foundation.h>
#import "RWProductModel.h"
#import "RWOrderModel.h"
#import "RWProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWContentModel : NSObject

// MARK: - Login
@property(nonatomic, copy) NSString *_Nullable uid;
@property(nonatomic, copy) NSString *_Nullable token;
/// 1是登录 0是注册
@property(nonatomic, assign) NSInteger isLogin;

// MARK: - Authenfication

/// 总的信息认证状态  1 认证 0 未认证
@property(nonatomic, assign) BOOL authStatus;
@property(nonatomic, assign) BOOL loanapiUserIdentity;
@property(nonatomic, assign) BOOL loanapiUserBasic;
@property(nonatomic, assign) BOOL loanapiUserLinkMan;
@property(nonatomic, assign) BOOL loanapiUserBankCard;

/// 1未认证   2可借款（金融产品信息）  3待审核  4待放款  5被拒绝  6待还款  7已逾期
@property(nonatomic, assign) NSInteger userStatus;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, assign) NSInteger frozenDays;

/// 借款单信息
@property(nonatomic, strong) RWOrderModel *loanAuditOrderVo;
/// 产品详情信息
@property(nonatomic, strong) RWProductDetailModel *loanProductVo;

// MARK: - Product
@property(nonatomic, strong) NSArray<RWProductModel*> *_Nullable loanProductList;
@end

NS_ASSUME_NONNULL_END

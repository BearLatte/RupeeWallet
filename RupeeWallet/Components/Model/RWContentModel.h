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
#import "RWOSSCredentialModel.h"

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

// MARK: - 下拉列表项
@property(nonatomic, strong) NSArray<NSString *> *eduList;
@property(nonatomic, strong) NSArray<NSString *> *marryList;
@property(nonatomic, strong) NSArray<NSString *> *jobList;
@property(nonatomic, strong) NSArray<NSString *> *moneyList;
@property(nonatomic, strong) NSArray<NSString *> *monthSalaryList;
@property(nonatomic, strong) NSArray<NSString *> *industryList;

// MARK: - OSS Parameters
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *bucket;
@property(nonatomic, strong) RWOSSCredentialModel *credentials;

// MARK: - OCR

// aadhar card front
@property(nonatomic, copy) NSString *aadharNumber;
@property(nonatomic, copy) NSString *aadharName;
@property(nonatomic, copy) NSString *dateOfBirth;
@property(nonatomic, copy) NSString *gender;
@property(nonatomic, copy) NSString *education;
@property(nonatomic, copy) NSString *frontImg;
@property(nonatomic, copy) NSString *backImg;
@property(nonatomic, copy) NSString *marriageStatus;
@property(nonatomic, copy) NSString *residenceDetailAddress;
@property(nonatomic, copy) NSString *firstName;

// aadhar card back
@property(nonatomic, copy) NSString *addressAll;

// pan card front
@property(nonatomic, copy) NSString *panNumber;
@property(nonatomic, copy) NSString *panCardImg;
@property(nonatomic, copy) NSString *monthlySalary;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) NSString *job;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *paytmAccount;
@property(nonatomic, copy) NSString *bodyImg;

// MARK: - Contact Info
@property(nonatomic, copy) NSString *_Nullable colleagueName;
@property(nonatomic, copy) NSString *_Nullable colleagueNumber;
@property(nonatomic, copy) NSString *_Nullable familyName;
@property(nonatomic, copy) NSString *_Nullable familyNumber;
@property(nonatomic, copy) NSString *_Nullable brotherOrSisterName;
@property(nonatomic, copy) NSString *_Nullable brotherOrSisterNumber;

@end

NS_ASSUME_NONNULL_END

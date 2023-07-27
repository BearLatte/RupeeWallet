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
#import "RWUserPayFailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWContentModel : NSObject

/// 调用哪家三方做活体 (枚举 ： accuauth)
@property(nonatomic, copy) NSString *_Nullable thirdLiveness;
/// 用户是否做完活体  0否 1是  (0的时候下单前需要做活体)
@property(nonatomic, assign) BOOL userLiveness;
/// 用户是否放款失败  0否 1是 (1的时候 需要弹放款失败的弹窗)
@property(nonatomic, assign) BOOL userPayFail;
/// 失败的弹窗详情信息
@property(nonatomic, strong) RWUserPayFailModel *_Nullable userPayFailInfo;

// MARK: - Login
@property(nonatomic, copy) NSString *_Nullable uid;
@property(nonatomic, copy) NSString *_Nullable token;
/// 1是登录 0是注册
@property(nonatomic, assign) NSInteger isLogin;

/// 是否显示展期按钮
@property(nonatomic, assign) BOOL isExtend;

// MARK: - Authenfication

/// 总的信息认证状态  1 认证 0 未认证
@property(nonatomic, assign) BOOL authStatus;
@property(nonatomic, assign) BOOL loanapiUserIdentity;
@property(nonatomic, assign) BOOL loanapiUserBasic;
@property(nonatomic, assign) BOOL loanapiUserLinkMan;
@property(nonatomic, assign) BOOL loanapiUserBankCard;

/// 1未认证   2可借款（金融产品信息）  3待审核  4待放款  5被拒绝  6待还款  7已逾期
/// 此字段在首页取值是 1:未认证， 2:已认证
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

// MARK: - Bank Card Info
@property(nonatomic, copy) NSString *bankCardNo;
@property(nonatomic, copy) NSString *ifscCode;
@property(nonatomic, copy) NSString *bankName;

/// 是否是第一次下单
@property(nonatomic, assign) BOOL isFirstApply;

/// 支付跳转地址
@property(nonatomic, copy) NSString *_Nullable path;
/// 支付拦截地址
@property(nonatomic, copy) NSString *_Nullable h5;
/// webview 这个字段。
/// 0 跳转系统浏览器
/// 1 打开原生webview 并且里面可以跳转系统浏览器
/// 2 只能在webview 里面处理
@property(nonatomic, copy) NSString *_Nullable webview;

/// 是否申请了展期还款流水 1是  0否
@property(nonatomic, assign) BOOL isExtendIng;
/// 展期手续费
@property(nonatomic, copy) NSString *extendFee;
/// 展期天数
@property(nonatomic, copy) NSString *extendDate;
/// 展期后还款日
@property(nonatomic, copy) NSString *extendRepayDate;
/// 展期后还款金额
@property(nonatomic, copy) NSString *extendRepayAmount;

/// 反馈问题列表
@property(nonatomic, strong) NSArray *_Nullable feedBackTypeList;
@end

NS_ASSUME_NONNULL_END

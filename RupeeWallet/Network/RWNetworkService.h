//
//  RWNetworkService.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import "RWContentModel.h"
#import "RWProductDetailModel.h"
#import "RWOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWAuthType) {
    RWAuthTypeAllInfo,
    RWAuthTypeKYCInfo,
    RWAuthTypePersonalInfo,
    RWAuthTypeContactInfo,
    RWAuthTypeBankCardInfo
};

@interface RWNetworkService : NSObject
+ (instancetype)sharedInstance;
- (void)firstLaunchNetworkWithSuccess:(void(^)(void))success;
- (void)fetchProductWithIsRecommend:(BOOL)isRecommend success:(void(^)(RWContentModel *_Nullable userInfo, NSArray *_Nullable products, RWProductDetailModel *_Nullable recommendProduct))successClosure failure: (void(^)(void))failureClosure;
- (void)sendSMSWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(void))success;
- (void)loginWithPhone:(NSString *)phone code:(NSString *)code success: (void(^)(void))success;
- (void)fetchUserAuthInfoWithType:(RWAuthType)type success:(void(^)(RWContentModel *authenficationInfo))success;
- (void)checkUserStatusWithProductId:(NSString *)productId success:(void(^)(NSInteger userStatus, NSString *orderNumber, RWProductDetailModel *productDetail))success;
- (void)fetchDropMenuListSuccess:(void(^)(RWContentModel *content))success;
- (void)ocrRequestWithImage:(UIImage *)image ocrType:(RWOCRType)ocrType success:(void(^)(RWContentModel *content, NSString *imageUrl))success;
- (void)authInfoWithType:(RWAuthType)type parameters:(NSDictionary *)parameters success:(void(^)(void))success;
- (void)userFaceAuthWithImage:(UIImage *)image success:(void(^)(void))success failure:(void(^)(void))failure;
- (void)purchaseProductWithParameters:(NSDictionary *)parameters success:(void(^)(NSArray *_Nullable recommendProductList, BOOL isFirstApply))success;
- (void)logoutWithSuccess:(void(^)(void))success;
- (void)fetchOrderListWithOrderType:(RWOrderType)orderType success:(void(^)(NSArray *orderList))success failure:(void(^)(void))failure;
- (void)checkExtensionBtnShowWithOrderNumber:(NSString *)orderNumber success:(void(^)(BOOL isShow))success;
- (void)fetchOrderDetailWithOrderNumber:(NSString *)orderNumber success:(void(^)(NSInteger frozenDays, RWOrderModel *order, NSArray *productList))success;
- (void)fetchRepayPathWithOrderNumber:(NSString *)orderNumber repayType:(NSString *)repayType success:(void(^)(RWContentModel *repayPathModel))success;
- (void)fetchExtensionApplyWithOrderNumber:(NSString *)orderNumber success:(void(^)(RWContentModel *extensionModel))success;
- (void)fetchFeedbackListWithSuccess:(void(^)(RWContentModel *feedbackParams, NSArray *feedbackList))success failure:(void(^)(void))failure;
- (void)uploadImageWithImage:(UIImage *)image success:(void(^)(NSString *imageUrl))success failure:(void(^)(void))failure;
- (void)saveFeedbackWithParameters:(NSDictionary *)parameters success:(void(^)(void))success;
- (void)changeBankCardWithParameters:(NSDictionary *)parameters success:(void(^)(void))success;
@end

NS_ASSUME_NONNULL_END

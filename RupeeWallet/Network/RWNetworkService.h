//
//  RWNetworkService.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import "RWContentModel.h"
#import "RWProductDetailModel.h"

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
@end

NS_ASSUME_NONNULL_END

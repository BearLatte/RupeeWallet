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

@interface RWNetworkService : NSObject
+ (instancetype)sharedInstance;
- (void)fetchPerductListWithSuccess: (void(^)(NSArray *products))successClosure failure: (void(^)(void))failureClosure;
- (void)sendSMSWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(void))success;
- (void)loginWithPhone:(NSString *)phone code:(NSString *)code success: (void(^)(void))success;
- (void)fetchUserAuthInfoWithType:(NSInteger)type step:(NSString *_Nullable)step success:(void(^)(RWContentModel *authenficationInfo))success;
- (void)checkUserStatusWithProductId:(NSString *)productId success:(void(^)(NSInteger userStatus, NSString *orderNumber, RWProductDetailModel *productDetail))success;
@end

NS_ASSUME_NONNULL_END

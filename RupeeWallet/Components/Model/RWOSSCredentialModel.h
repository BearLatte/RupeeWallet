//
//  RWOSSParametersModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RWOSSCredentialModel : NSObject
@property(nonatomic, copy) NSString *_Nullable securityToken;
@property(nonatomic, copy) NSString *_Nullable accessKeySecret;
@property(nonatomic, copy) NSString *_Nullable accessKeyId;
@property(nonatomic, copy) NSString *_Nullable expiration;
@end
NS_ASSUME_NONNULL_END

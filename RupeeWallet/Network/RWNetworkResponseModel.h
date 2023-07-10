//
//  RWNetworkResponseModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import <Foundation/Foundation.h>
#import "RWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWNetworkResponseModel : NSObject
@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSString *msg;
@property(nonatomic, strong) RWBaseModel *response;
@end

NS_ASSUME_NONNULL_END

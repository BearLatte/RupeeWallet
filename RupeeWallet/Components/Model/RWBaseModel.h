//
//  RWBaseModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <Foundation/Foundation.h>
#import "RWContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWBaseModel : NSObject
@property(nonatomic, strong) NSArray *_Nullable list;
@property(nonatomic, strong) RWContentModel *_Nullable cont;
@end

NS_ASSUME_NONNULL_END



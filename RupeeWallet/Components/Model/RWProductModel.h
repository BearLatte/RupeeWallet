//
//  RWProductModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWProductModel : NSObject
@property(nonatomic, copy) NSString *_Nullable logo;
@property(nonatomic, copy) NSString *_Nullable productId;
@property(nonatomic, copy) NSString *_Nullable spaceName;
@property(nonatomic, copy) NSString *_Nullable loanName;
@property(nonatomic, copy) NSString *_Nullable loanDate;
@property(nonatomic, copy) NSString *_Nullable loanAmount;
@property(nonatomic, copy) NSString *_Nullable loanRate;
@end

NS_ASSUME_NONNULL_END

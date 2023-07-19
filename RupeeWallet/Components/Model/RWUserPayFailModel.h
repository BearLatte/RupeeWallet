//
//  RWUserPayFailModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWUserPayFailModel : NSObject
@property(nonatomic, copy) NSString *_Nullable loanOrderNo;
@property(nonatomic, copy) NSString *_Nullable content;
@property(nonatomic, copy) NSString *_Nullable logo;
@property(nonatomic, copy) NSString *_Nullable loanName;
@end

NS_ASSUME_NONNULL_END

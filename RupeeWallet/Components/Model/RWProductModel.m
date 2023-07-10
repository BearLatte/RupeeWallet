//
//  RWProductModel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWProductModel.h"

@implementation RWProductModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"productId" : @"id"};
}

@end

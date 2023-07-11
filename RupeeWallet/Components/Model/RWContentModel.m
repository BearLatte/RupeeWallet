//
//  RWContentModel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWContentModel.h"

@implementation RWContentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"loanProductList" : [RWProductModel class],
        @"eduList" : [NSString class],
        @"marryList" : [NSString class],
        @"jobList" : [NSString class],
        @"moneyList" : [NSString class],
        @"monthSalaryList" : [NSString class],
        @"industryList" : [NSString class]
    };
}
@end

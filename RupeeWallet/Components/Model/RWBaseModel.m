//
//  RWContentModel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWBaseModel.h"

@implementation RWBaseModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [NSDictionary class]};
}
@end

//
//  NSBundle+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)
- (NSString *)version {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}
@end

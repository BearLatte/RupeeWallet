//
//  UIDevice+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "UIDevice+Extension.h"

@implementation UIDevice (Extension)
static NSString * const IDFA = @"kIDFA";

- (NSString *)idfa {
    NSString *idfaString = [[NSUserDefaults standardUserDefaults] valueForKey:IDFA];
    if ([idfaString isEqual: @"00000000-0000-0000-0000-000000000000"]) {
        return @"";
    } else {
        return idfaString;
    }
}
@end

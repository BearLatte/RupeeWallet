//
//  NSDate+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/11.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSString *)date2stringWithFormatter:(NSString *)format {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = format;
    return [dateformatter stringFromDate:self];
}
@end

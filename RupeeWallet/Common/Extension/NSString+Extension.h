//
//  NSString+Extension.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
+ (NSString *)generateRandomStringWithLength:(NSUInteger)length;
+ (NSString *)sortedDictionary:(NSDictionary *)dict;
- (NSString *)MD5;
@end

NS_ASSUME_NONNULL_END

//
//  NSString+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
+ (NSString *)generateRandomStringWithLength:(NSUInteger)length {
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = @"".mutableCopy;
    for(int i = 0; i < length; i++) {
        NSInteger index = arc4random() % characters.length;
        NSString *subString = [characters substringWithRange:NSMakeRange(index, 1)];
        [randomString appendString:subString];
    }
    return [randomString copy];
}

+ (NSString *)sortedDictionary:(NSDictionary *)dict {
    NSArray *allKeys = [dict allKeys];
    NSMutableString *paramsString = @"".mutableCopy;
    NSArray *sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    for(NSInteger i = 0; i < sortedKeys.count; i++) {
        NSString *key = sortedKeys[i];
        if (i == sortedKeys.count - 1) {
            [paramsString appendFormat:@"%@=%@", key, dict[key]];
        } else {
            [paramsString appendFormat:@"%@=%@&", key, dict[key]];
        }
    }
    return [paramsString copy];
}

//- (NSString *)md5String {
//    const char *value = [self UTF8String];
//    NSData *keyData = [NSData dataWithBytes:value length:strlen(value)];
//
//    uint8_t outputBuffer[CC_SHA256_DIGEST_LENGTH] = {0};
//    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, outputBuffer);
//
//    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
//        [outputString appendFormat:@"%02x",outputBuffer[count]];
//    }
//
//    return outputString;
//}

- (NSString *) MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
      
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
      
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
      
    RWLog(@"MD5 %@", output);
    return output;
}

- (BOOL)isNum {
    NSCharacterSet *str=[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *filter=[[self componentsSeparatedByCharactersInSet:str] componentsJoinedByString:@""];
    BOOL isNum = [self isEqualToString:filter];
    return isNum;
}
@end

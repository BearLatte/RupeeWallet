//
//  UIDevice+Extension.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extension)
@property(nonatomic, copy, readonly) NSString *idfa;
@property(nonatomic, copy, readonly) NSString *batteryLevel;
@property(nonatomic, copy, readonly) NSString *batteryStatus;
@property(nonatomic, copy, readonly) NSString *openAppTimeStamp;
@property(nonatomic, copy, readonly) NSString *ipAddress;

- (void)setOpenAppTimeStamp;
@end

NS_ASSUME_NONNULL_END

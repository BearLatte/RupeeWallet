//
//  UIDevice+Extension.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extension)
@property(nonatomic, copy, readonly) NSString *deviceModelName;
@property(nonatomic, copy, readonly) NSString *idfa;
@property(nonatomic, copy, readonly) NSString *batteryLevelString;
@property(nonatomic, copy, readonly) NSString *batteryStatus;
@property(nonatomic, copy, readonly) NSString *openAppTimeStamp;
@property(nonatomic, copy, readonly) NSString *ipAddress;
@property(nonatomic, copy, readonly) NSString *bootTime;
@property(nonatomic, copy, readonly) NSString *uptime;
@property(nonatomic, copy, readonly) NSString *networkType;
@property(nonatomic, copy, readonly) NSString *totalDiskSpaceInGB;
@property(nonatomic, copy, readonly) NSString *freeDiskSpaceInGB;
@property(nonatomic, copy, readonly) NSString *usedDiskSpaceInGB;
@property(nonatomic, assign, readonly) long long freeDiskSpaceInBytes;
@property(nonatomic, assign, readonly) long long totalDiskSpaceInBytes;
@property(nonatomic, assign, readonly) long long usedDiskSpaceInBytes;
@property(nonatomic, copy, readonly) NSString *language;
- (void)setOpenAppTimeStamp;
@end

NS_ASSUME_NONNULL_END

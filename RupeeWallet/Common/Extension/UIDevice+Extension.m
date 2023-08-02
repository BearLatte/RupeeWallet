//
//  UIDevice+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "UIDevice+Extension.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>

@implementation UIDevice (Extension)
static NSString * const OPEN_APP_TIME_KEY = @"kOPEN_APP_TIME_KEY";

- (NSString *)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([deviceModel isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([deviceModel isEqualToString:@"iPhone14,2"])   return @"iPhone 13  Pro";
    if ([deviceModel isEqualToString:@"iPhone14,3"])   return @"iPhone 13  Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,6"])   return @"iPhone SE3";
    if ([deviceModel isEqualToString:@"iPhone14,7"])   return @"iPhone 14";
    if ([deviceModel isEqualToString:@"iPhone14,8"])   return @"iPhone 14 Plus";
    if ([deviceModel isEqualToString:@"iPhone15,2"])   return @"iPhone 14 Pro";
    if ([deviceModel isEqualToString:@"iPhone15,3"])   return @"iPhone 14 Pro Max";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}

- (NSString *)idfa {
    NSString *idfaString = [[NSUserDefaults standardUserDefaults] valueForKey:IDFA_KEY];
    if ([idfaString isEqual: @"00000000-0000-0000-0000-000000000000"] || idfaString == nil) {
        return @"";
    } else {
        return idfaString;
    }
}

- (NSString *)batteryStatus {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    UIDeviceBatteryState state = [UIDevice currentDevice].batteryState;
    switch (state) {
        case UIDeviceBatteryStateCharging:
            return @"2";
        case UIDeviceBatteryStateFull:
            return @"5";
        case UIDeviceBatteryStateUnplugged:
            return @"3";
        default:
            return @"1";
    }
}

- (NSString *)language {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [languages firstObject];
}

- (NSString *)openAppTimeStamp {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OPEN_APP_TIME_KEY];
}

- (NSString *)batteryLevelString {
    return [NSString stringWithFormat:@"%.f", [UIDevice currentDevice].batteryLevel * 100];
}

- (void)setOpenAppTimeStamp {
    NSString *time = [NSString stringWithFormat:@"%.f", [[NSDate alloc] init].timeIntervalSince1970 * 1000];
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:OPEN_APP_TIME_KEY];
}

- (NSString *)ipAddress {
    NSString *adress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        //将结构体复制给副本temp_addr
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr ->ifa_name] isEqualToString:@"en0"]) {
                    adress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr -> ifa_next;
        }
    }
    //Free memory
    //extern void freeifaddrs(struct ifaddrs *);
    freeifaddrs(interfaces);
    return (adress);
}

- (NSString *)bootTime {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    NSInteger bootTimeStamp = [[[NSDate alloc] init] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%ld", labs(bootTimeStamp - ts.tv_sec * 1000)];
}

- (NSString *)uptime {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return [NSString stringWithFormat:@"%ld", ts.tv_sec * 1000];
}


- (NSString *)networkType {
    return [self getNetworkType];
}


- (NSString *)getNetworkType {
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return @"NETWORK_UNKNOWN";
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    if (isReachable && !needsConnection) { }else{
        return @"NETWORK_UNKNOWN";
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired ) {
        
        return @"NETWORK_UNKNOWN";
        
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        
        return [self cellularType];
        
    } else {
        return @"NETWORK_WiFi";
    }
    
}

- (NSString *)cellularType {
    
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentRadioAccessTechnology;
    
    if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
        NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
        if (radioDic.allKeys.count) {
            currentRadioAccessTechnology = [radioDic objectForKey:radioDic.allKeys[0]];
        } else {
            return @"NETWORK_UNKNOWN";
        }
    } else {
        return @"NETWORK_UNKNOWN";
    }
    
    if (currentRadioAccessTechnology) {
        
        if (@available(iOS 14.1, *)) {
            
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]) {
                return @"NETWORK_5G";
            }
        }
        
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            
            return @"NETWORK_4G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            
            return @"NETWORK_3G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            
            return @"NETWORK_2G";
            
        } else {
            return @"NETWORK_UNKNOWN";
        }
        
        
    } else {
        
        return @"NETWORK_UNKNOWN";
    }
}

- (NSString *)totalDiskSpaceInGB {
    NSString *totalSpaceStr = [NSByteCountFormatter stringFromByteCount:[[UIDevice currentDevice] totalDiskSpaceInBytes] countStyle:NSByteCountFormatterCountStyleDecimal];
    return [totalSpaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)freeDiskSpaceInGB {
    NSString *freeSpaceStr = [NSByteCountFormatter stringFromByteCount:[[UIDevice currentDevice] freeDiskSpaceInBytes] countStyle:NSByteCountFormatterCountStyleDecimal];
    return [freeSpaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)usedDiskSpaceInGB {
    NSString *usedSpaceStr = [NSByteCountFormatter stringFromByteCount:[[UIDevice currentDevice] usedDiskSpaceInBytes] countStyle:NSByteCountFormatterCountStyleDecimal];
    return [usedSpaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)totalDiskSpaceInMB {
    return [[UIDevice currentDevice] MBFormatterWithBytes:[[UIDevice currentDevice] totalDiskSpaceInBytes]];
}

- (NSString *)freeDiskSpaceInMB {
    return [[UIDevice currentDevice] MBFormatterWithBytes:[[UIDevice currentDevice] freeDiskSpaceInBytes]];
}

- (NSString *)usedDiskSpaceInMB {
    return [[UIDevice currentDevice] MBFormatterWithBytes:[[UIDevice currentDevice] usedDiskSpaceInBytes]];
}

// MARK: - Private
- (long long)totalDiskSpaceInBytes {
    NSError *error;
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if(error) {
        return 0;
    }
    
    long long space = [systemAttributes[NSFileSystemSize] integerValue];
    return space;
}

- (long long)freeDiskSpaceInBytes {
    NSError *error;
    NSURL *fileURL = [NSURL fileURLWithPath:NSHomeDirectory()];
    NSDictionary *dict = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
    if(error) {
        return 0;
    }
    
    long long space = [dict[NSURLVolumeAvailableCapacityForImportantUsageKey] integerValue];
    return space;
}

- (long long)usedDiskSpaceInBytes {
    return [[UIDevice currentDevice] totalDiskSpaceInBytes] - [[UIDevice currentDevice] freeDiskSpaceInBytes];
}

- (NSString *)MBFormatterWithBytes:(long long)bytes {
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    formatter.allowedUnits = NSByteCountFormatterUseMB;
    formatter.countStyle = NSByteCountFormatterCountStyleDecimal;
    formatter.includesUnit = NO;
    return [formatter stringFromByteCount:bytes];
}

@end

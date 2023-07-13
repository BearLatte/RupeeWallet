//
//  UIDevice+Extension.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "UIDevice+Extension.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation UIDevice (Extension)
static NSString * const IDFA = @"kIDFA";
static NSString * const OPEN_APP_TIME_KEY = @"kOPEN_APP_TIME_KEY";

- (NSString *)idfa {
    NSString *idfaString = [[NSUserDefaults standardUserDefaults] valueForKey:IDFA];
    if ([idfaString isEqual: @"00000000-0000-0000-0000-000000000000"]) {
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

- (NSString *)openAppTimeStamp {
    return [[NSUserDefaults standardUserDefaults] stringForKey:OPEN_APP_TIME_KEY];
}

- (NSString *)batteryLevel {
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
    if(@available(iOS 10.0, *)) {
        clock_gettime(CLOCK_MONOTONIC, &ts);
    }
    
    return [NSString stringWithFormat:@"%ld", ts.tv_sec];
}


@end

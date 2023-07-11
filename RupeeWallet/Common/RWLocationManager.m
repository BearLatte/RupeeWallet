//
//  RWLocationManager.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/11.
//

#import "RWLocationManager.h"
#import <UIKit/UIKit.h>

@interface RWLocationManager()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, copy) locationBlock locationBlock;
@end

@implementation RWLocationManager
+ (instancetype)sharedManager {
    static RWLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RWLocationManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
    }
    return self;
}

- (BOOL)hasLocationService {
    return CLLocationManager.locationServicesEnabled;
}

- (BOOL)hasLocationPermission {
    // 获取权限
    CLAuthorizationStatus status = [self locationPermission];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            return NO;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
        default:
            break;
    }
    return NO;
}

- (void)getLocationWithBlock:(locationBlock)locationBlock {
    [self.locationManager requestLocation];
    self.locationBlock = locationBlock;
}

- (void)requestLocationAuthorizaiton {
    CLAuthorizationStatus status = [self locationPermission];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showIndicatorAlert];
            return;
        default:
            break;
    }
}

- (CLAuthorizationStatus)locationPermission {
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus status = self.locationManager.authorizationStatus;
        return status;
    } else {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        return status;
    }
    
}

- (void)showIndicatorAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This feature requires you to authorize this app to open the location service\nHow to set it: open phone Settings -> Privacy -> Location service" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Go To Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
        }
    }];
    [alert addAction: cencelAction];
    [alert addAction:settingsAction];
    [[[RWGlobal sharedGlobal] getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}


// MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    if(location != nil && self.locationBlock != nil) {
        self.locationBlock(YES, location);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(self.locationBlock) {
        self.locationBlock(NO, nil);
    }
}
@end

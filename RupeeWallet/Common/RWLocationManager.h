//
//  RWLocationManager.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/11.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^locationBlock)(BOOL success, CLLocation *_Nullable location);

@interface RWLocationManager : NSObject

+ (instancetype)sharedManager;
- (void)getLocationWithBlock:(locationBlock)locationBlock;
- (BOOL)hasLocationService;
- (BOOL)hasLocationPermission;
- (void)requestLocationAuthorizaiton;
@end

NS_ASSUME_NONNULL_END

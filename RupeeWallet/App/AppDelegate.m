//
//  AppDelegate.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "AppDelegate.h"
#import "RWMainTabbarController.h"
#import <IQKeyboardManager.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RWMainTabbarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestIDFA];
}


// MARK: - idfa
- (void)requestIDFA {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
                [[NSUserDefaults standardUserDefaults] setValue:idfa forKey: IDFA_KEY];
            }
        }];
        
    } else {
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
            [[NSUserDefaults standardUserDefaults] setValue:idfa forKey: IDFA_KEY];
        }
    }
}


@end

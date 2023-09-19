//
//  AppDelegate.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "AppDelegate.h"
#import <Adjust/Adjust.h>
#import "UIDevice+Extension.h"
#import "RWMainTabbarController.h"
#import <IQKeyboardManager.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self listenNetworkType];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[UIDevice currentDevice] setOpenAppTimeStamp];
    
    [self firstLuanchNetwork];
    
    [self requestIDFA];
    
    ADJConfig *adjustConfig = [[ADJConfig alloc] initWithAppToken:ADJUST_APP_TOKEN environment:ADJEnvironmentProduction];
    adjustConfig.logLevel = ADJLogLevelVerbose;
    adjustConfig.defaultTracker = @"AppStore";
    adjustConfig.allowIdfaReading = YES;
    [Adjust appDidLaunch:adjustConfig];
    
    // facebook
    [RWFBTrackTool applicationDidFinishLaunchingWith:application options:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RWMainTabbarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestIDFA];
    [Adjust requestTrackingAuthorizationWithCompletionHandler:nil];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [RWFBTrackTool applicationWith:app open:url options:options];
}

- (void)listenNetworkType {
    
}


// MARK: - idfa
- (void)requestIDFA {
    if (@available(iOS 14.0, *)) {
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


// MARK: - First Launch Network
- (void)firstLuanchNetwork {
    [[RWNetworkService sharedInstance] firstLaunchNetworkWithSuccess:^{
            
    }];
}
@end

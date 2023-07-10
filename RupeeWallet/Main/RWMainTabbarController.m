//
//  RWMainTabbarController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWMainTabbarController.h"
#import "RWBaseViewController.h"
#import "RWMainNavigationController.h"
#import "RWHomeController.h"
#import "RWPersonalCenterController.h"

@interface RWMainTabbarController ()

@end

@implementation RWMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // config appearence
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:TAB_BAR_NORMAL_FOREGROUND_COLOR],
        NSFontAttributeName : [UIFont systemFontOfSize:12]
    } forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:THEME_COLOR],
        NSFontAttributeName : [UIFont systemFontOfSize:12]
    } forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTranslucent:NO];
    
    
    RWHomeController *home = [[RWHomeController alloc] init];
    home.tabBarItem.title = @"Loan";
    home.tabBarItem.image = [[UIImage imageNamed:@"home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RWMainNavigationController *homeNav = [[RWMainNavigationController alloc] initWithRootViewController:home];
    
    RWPersonalCenterController *personalCenter = [[RWPersonalCenterController alloc] init];
    personalCenter.tabBarItem.title = @"Me";
    personalCenter.tabBarItem.image = [[UIImage imageNamed:@"me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalCenter.tabBarItem.selectedImage = [[UIImage imageNamed:@"me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RWMainNavigationController *personalCenterNav = [[RWMainNavigationController alloc] initWithRootViewController:personalCenter];

    self.viewControllers = @[homeNav, personalCenterNav];
}
@end

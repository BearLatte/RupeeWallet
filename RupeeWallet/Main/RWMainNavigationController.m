//
//  RWMainNavigationController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWMainNavigationController.h"

@interface RWMainNavigationController ()

@end

@implementation RWMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end

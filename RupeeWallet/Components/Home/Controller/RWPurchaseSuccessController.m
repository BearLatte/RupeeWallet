//
//  RWPurchaseSuccessController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWPurchaseSuccessController.h"

@interface RWPurchaseSuccessController ()

@end

@implementation RWPurchaseSuccessController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self closeGesturePop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self openGesturePop];
}

@end

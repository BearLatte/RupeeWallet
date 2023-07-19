//
//  RWADJTrackTool.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/19.
//

#import "RWADJTrackTool.h"
#import <Adjust/Adjust.h>

@implementation RWADJTrackTool

+ (void)trackingWithPoint:(nonnull NSString *)point {
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:point];
    [Adjust trackEvent:event];
}

@end

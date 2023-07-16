//
//  RWPagingListContainerRTLCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingListContainerRTLCell.h"
#import "RTLManager.h"

@implementation RWPagingListContainerRTLCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RTLManager horizontalFlipViewIfNeeded:self];
        [RTLManager horizontalFlipViewIfNeeded:self.contentView];
    }
    return self;
}
@end

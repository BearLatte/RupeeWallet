//
//  RWOrderListController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWBaseTableViewController.h"
#import "RWPagingListContainerView.h"

NS_ASSUME_NONNULL_BEGIN
@interface RWOrderListController : RWBaseTableViewController<RWPagingListContentViewDelegate>
- (instancetype)initWithOrderType:(RWOrderType)type;
@end

NS_ASSUME_NONNULL_END

//
//  RWOrderListController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWBaseTableViewController.h"
#import "RWPagingListContainerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RWOrderType) {
    RWOrderTypeAll = 0,
    RWOrderTypeDisbursing = 1,
    RWOrderTypeToBeRepaid = 2,
    RWOrderTypeDenied = 3,
    RWOrderTypePending = 4,
    RWOrderTypeRepaid = 5,
    RWOrderTypeOverdue = 6
};
@interface RWOrderListController : RWBaseTableViewController<RWPagingListContentViewDelegate>
- (instancetype)initWithOrderType:(RWOrderType)type;
@end

NS_ASSUME_NONNULL_END

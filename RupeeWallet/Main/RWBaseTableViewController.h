//
//  RWBaseTableViewController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWBaseViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWBaseTableViewController : RWBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *_Nullable tableView;

@end

NS_ASSUME_NONNULL_END

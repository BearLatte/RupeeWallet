//
//  RWOrderListController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWOrderListController.h"
#import "RWOrderCell.h"
#import "RWOrderDetailViewController.h"

@interface RWOrderListController ()
@property(nonatomic, assign) RWOrderType orderType;
@property(nonatomic, strong) NSArray *orders;
@end

@implementation RWOrderListController
- (instancetype)initWithOrderType:(RWOrderType)type {
    if(self = [super init]) {
        self.orderType = type;
    }
    return self;
}
- (void)setupUI {
    [super setupUI];
    self.isHiddenBackButton = YES;
    [self.tableView registerClass:[RWOrderCell class] forCellReuseIdentifier:@"OrderCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)loadData {
    [[RWNetworkService sharedInstance] fetchOrderListWithOrderType:self.orderType success:^(NSArray * _Nonnull orderList) {
        self.orders = orderList;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^{
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

// MARK: - RWPagingListContentViewDelegate {
- (UIView *)listView {
    return self.view;
}

// MARK: - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    cell.order = self.orders[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RWOrderModel *order = self.orders[indexPath.row];
    RWOrderDetailViewController *detail = [[RWOrderDetailViewController alloc] init];
    detail.auditOrderNo = order.loanOrderNo;
    [self.navigationController pushViewController:detail animated:YES];
}

@end

//
//  RWOrderListController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWOrderListController.h"

@interface RWOrderListController ()
@property(nonatomic, assign) RWOrderType orderType;
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
    self.tableView.backgroundColor = [UIColor random];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

// MARK: - RWPagingListContentViewDelegate {
- (UIView *)listView {
    return self.view;
}
@end

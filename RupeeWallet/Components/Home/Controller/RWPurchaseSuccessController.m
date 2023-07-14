//
//  RWPurchaseSuccessController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWPurchaseSuccessController.h"
#import "RWProductCell.h"
#import "RWSectionHeaderView.h"

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

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    self.isDarkBackMode = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purchase_success_icon"]];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.size.mas_equalTo(CGSizeMake(95, 95));
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *indicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Successful application" font:[UIFont systemFontOfSize:18] textColor:THEME_TEXT_COLOR];
    [self.view addSubview:indicatorLabel];
    [indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(iconView);
    }];
    
    UIView *recommendIndicatorView = [[UIView alloc] init];
    recommendIndicatorView.layer.cornerRadius = 10;
    recommendIndicatorView.layer.masksToBounds = YES;
    recommendIndicatorView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view addSubview:recommendIndicatorView];
    [recommendIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(indicatorLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(105);
    }];
    
    UIImageView *circleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other_loan_indicator_icon"]];
    [recommendIndicatorView addSubview:circleImage];
    [circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(recommendIndicatorView);
    }];
    
    UILabel *otherLoanLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Other loan products are also available." font:[UIFont systemFontOfSize:18] textColor:@"#ffffff"];
    otherLoanLabel.numberOfLines = 0;
    [recommendIndicatorView addSubview:otherLoanLabel];
    [otherLoanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(circleImage.mas_right).offset(12);
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(recommendIndicatorView);
    }];
    
    self.tableView.showsPullToRefresh = NO;
    [self.tableView registerClass:[RWProductCell class] forCellReuseIdentifier:@"ProductCell"];
    [self.tableView registerClass:[RWSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SectionView"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(recommendIndicatorView.mas_bottom).offset(20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(0);
    }];
    self.tableView.layer.cornerRadius = 10;
//    [self.tableView setCornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)backAction {
    if(self.isRecommend) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// MARK: - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendProductList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    cell.product = self.recommendProductList[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RWSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionView"];
    [headerView layoutIfNeeded];
    return headerView;
}
@end

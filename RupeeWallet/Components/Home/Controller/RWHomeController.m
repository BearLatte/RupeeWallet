//
//  RWHomeController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWHomeController.h"
#import "RWProductModel.h"
#import "RWProductCell.h"
#import "RWSectionHeaderView.h"
#import "RWKYCInfoContrroller.h"
#import "RWOrderDetailViewController.h"
#import "RWProductDetailController.h"
#import "RWPayFailToastView.h"
#import "UIDevice+Extension.h"
#import "RWBankCardController.h"
#import "Reachability.h"

@interface RWHomeController ()
@property(nonatomic, strong) UIImageView *_Nullable headerImageView;
@property(nonatomic, strong) NSArray<RWProductModel *> *_Nullable products;
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation RWHomeController
- (UIImageView *)headerImageView {
    if(!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

- (void)setupUI {
    [super setupUI];
    self.isHiddenBackButton = YES;
    
    [self.view insertSubview:self.headerImageView belowSubview:self.tableView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.77);
    }];
    
    
    [self.tableView registerClass:[RWProductCell class] forCellReuseIdentifier:@"ProductCell"];
    [self.tableView registerClass:[RWSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SectionView"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(-50);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-10);
    }];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAuthFinished:) name:AUTHENFICATION_FINISHED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChange) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}


- (void)didReceiveAuthFinished:(NSNotification *)noti {
    [[RWNetworkService sharedInstance] fetchProductWithIsRecommend:YES success:^(RWContentModel *userInfo, NSArray * _Nullable products, RWProductDetailModel * _Nullable recommendProduct) {
        if (recommendProduct.productId != nil) {
            RWProductDetailController *detail = [[RWProductDetailController alloc] init];
            detail.productId = recommendProduct.productId;
            detail.modalPresentationStyle = UIModalPresentationFullScreen;
            detail.isRecommend = YES;
            [self .navigationController pushViewController:detail animated:YES];
        }
    } failure:^{
        
    }];
}

- (void)netWorkStatusChange {
    [self loadData];
}


- (void)loadData {
    [[RWNetworkService sharedInstance] fetchProductWithIsRecommend:NO success:^(RWContentModel *userInfo, NSArray * _Nullable products, RWProductDetailModel * _Nullable recommendProduct) {
        if(userInfo.userPayFail) {
            [RWPayFailToastView showToastWithPayFailInfo:userInfo.userPayFailInfo];
        }
        
        if(userInfo.userStatus == 2) {
            self.headerImageView.image = [UIImage imageNamed:@"header_img_login"];
        } else {
            self.headerImageView.image = [UIImage imageNamed:@"header_img"];
        }
        
        self.products = products;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^{
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

// MARK: - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    cell.product = self.products[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RWSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionView"];
    headerView.isHiddenRefreshBtn = NO;
    headerView.action = ^{
        [self loadData];
    };
    [headerView layoutIfNeeded];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![RWGlobal sharedGlobal].isLogin) {
        [RWADJTrackTool trackingWithPoint:@"p0bv1q"];
        [[RWGlobal sharedGlobal] go2login];
    }
    
    
    [RWADJTrackTool trackingWithPoint:@"pzyuaj"];
    RWProductModel *product = self.products[indexPath.row];
    [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:RWAuthTypeAllInfo success:^(RWContentModel * _Nonnull authenficationInfo) {
        if (authenficationInfo.authStatus) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_CERTIFIED_KEY];
            [self checkUserStatusWithProduct:product.productId];
        } else {
            RWKYCInfoContrroller *kycController = [[RWKYCInfoContrroller alloc] init];
            kycController.authStatus = authenficationInfo;
            RWMainNavigationController *nav = [[RWMainNavigationController alloc] initWithRootViewController:kycController];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)checkUserStatusWithProduct:(NSString *)productId {
    [[RWNetworkService sharedInstance] checkUserStatusWithProductId:productId success:^(NSInteger userStatus, NSString * _Nonnull orderNumber, RWProductDetailModel * _Nonnull productDetail) {
        if (userStatus == 2) {
            RWProductDetailController *detailController = [[RWProductDetailController alloc] init];
            detailController.productId = productId;
            [self.navigationController pushViewController:detailController animated:YES];
        } else {
            RWOrderDetailViewController *detailController = [[RWOrderDetailViewController alloc] init];
            detailController.auditOrderNo = orderNumber;
            [self.navigationController pushViewController:detailController animated:YES];
        }
    }];
}

@end

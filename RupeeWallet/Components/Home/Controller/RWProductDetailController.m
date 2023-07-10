//
//  RWProductDetailController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import "RWProductDetailController.h"
#import "RWProductDetailModel.h"

@interface RWProductDetailController ()
@property(nonatomic, strong) RWProductDetailModel *productDetail;
@end

@implementation RWProductDetailController

- (void)setProductDetail:(RWProductDetailModel *)productDetail {
    _productDetail = productDetail;
    [self updateUI];
}

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    self.isDarkBackMode = YES;
}

- (void)updateUI {
    
}

- (void)loadData {
    [[RWNetworkService sharedInstance] checkUserStatusWithProductId:self.productId success:^(NSInteger userStatus, NSString * _Nonnull orderNumber, RWProductDetailModel * _Nonnull productDetail) {
        
    }];
}
@end

//
//  RWProductDetailController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import "RWProductDetailController.h"
#import "RWProductDetailModel.h"
#import "RWAttributedLabel.h"

@interface RWProductDetailController ()
@property(nonatomic, weak) UIImageView *productLogoView;
@property(nonatomic, weak) UILabel *productNameLabel;
@property(nonatomic, weak) RWAttributedLabel *receivedAmoutLabel;
@property(nonatomic, weak) RWAttributedLabel *amountLable;
@property(nonatomic, weak) RWAttributedLabel *verificationFeeLabel;
@property(nonatomic, weak) RWAttributedLabel *gstLabel;
@property(nonatomic, weak) RWAttributedLabel *interestLabel;
@property(nonatomic, weak) RWAttributedLabel *termsLabel;
@property(nonatomic, weak) RWAttributedLabel *overdueChargeLabel;
@property(nonatomic, weak) RWAttributedLabel *repaymentAmountLabel;
@property(nonatomic, weak) UIButton *loanBtn;

@property(nonatomic, strong) RWProductDetailModel *productDetail;
@end

@implementation RWProductDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isRecommend) {
        [self closeGesturePop];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self openGesturePop];
}

- (void)setProductDetail:(RWProductDetailModel *)productDetail {
    _productDetail = productDetail;
    [self.productLogoView sd_setImageWithURL:[NSURL URLWithString:productDetail.logo]
                            placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    self.productNameLabel.text = productDetail.loanName;
    self.receivedAmoutLabel.key = [NSString stringWithFormat:@"₹ %@", productDetail.receiveAmountStr];
    self.amountLable.value = [NSString stringWithFormat:@"₹ %@", productDetail.loanAmountStr];
    self.verificationFeeLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.verificationFeeStr];
    self.gstLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.gstFeeStr];
    self.interestLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.interestAmountStr];
    self.termsLabel.value = [NSString stringWithFormat:@"%@ Days", productDetail.loanDate];
    self.overdueChargeLabel.value = [NSString stringWithFormat:@"%@/day", productDetail.overdueChargeStr];
    self.repaymentAmountLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.repayAmountStr];
    
    [self updateUI];
}

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    self.isDarkBackMode = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.layer.cornerRadius = 10;
    logo.layer.masksToBounds = YES;
    logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:logo];
    self.productLogoView = logo;
    
    UILabel *productName = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
    [self.view addSubview:productName];
    self.productNameLabel = productName;
    
    RWAttributedLabel *receivedAmoutn = [RWAttributedLabel attributedLabelWithKey:nil keyColor:THEME_COLOR keyFont:[UIFont systemFontOfSize:30 weight:UIFontWeightSemibold] value:@" Received Amount" valueColor:INDICATOR_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
    receivedAmoutn.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:receivedAmoutn];
    self.receivedAmoutLabel = receivedAmoutn;
    
    RWAttributedLabel *amount = [self attributedLabelWithKey:@"Amount : "];
    [self.view addSubview:amount];
    self.amountLable = amount;
    
    RWAttributedLabel *verification = [self attributedLabelWithKey:@"Verification Fee : "];
    [self.view addSubview:verification];
    self.verificationFeeLabel = verification;
    
    RWAttributedLabel *gst = [self attributedLabelWithKey:@"GST : "];
    [self.view addSubview:gst];
    self.gstLabel = gst;
    
    RWAttributedLabel *interest = [self attributedLabelWithKey:@"Interest :"];
    [self.view addSubview:interest];
    self.interestLabel = interest;
    
    RWAttributedLabel *terms = [self attributedLabelWithKey:@"Terms : "];
    [self.view addSubview:terms];
    self.termsLabel = terms;
    
    RWAttributedLabel *overdueCharge = [self attributedLabelWithKey:@"Overdue Charge : "];
    [self.view addSubview:overdueCharge];
    self.overdueChargeLabel = overdueCharge;
    
    RWAttributedLabel *repaymentAmount = [RWAttributedLabel attributedLabelWithKey:@"Repayment Amount :" keyColor:THEME_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_COLOR valueFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:repaymentAmount];
    self.repaymentAmountLabel = repaymentAmount;
    
    UIButton *loanBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Loan now" cornerRadius:30];
    [self.view addSubview:loanBtn];
    self.loanBtn = loanBtn;
    
    [self updateUI];
}

- (RWAttributedLabel *)attributedLabelWithKey:(NSString *)key {
    RWAttributedLabel *label = [RWAttributedLabel attributedLabelWithKey:key keyColor:INDICATOR_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
    return  label;
}

- (void)updateUI {
    [self.productLogoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA + 60);
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.right.mas_equalTo(self.view.mas_centerX).offset(-5);
    }];
    
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.productLogoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.productLogoView);
    }];
    
    [self.receivedAmoutLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productLogoView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    
    [self.amountLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.receivedAmoutLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(22);
    }];
    
    [self.verificationFeeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLable.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.gstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationFeeLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.interestLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gstLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.termsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.interestLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.overdueChargeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.termsLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.repaymentAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.overdueChargeLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.loanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-BOTTOM_SAFE_AREA);
    }];
    
}

- (void)loadData {
    [[RWNetworkService sharedInstance] checkUserStatusWithProductId:self.productId success:^(NSInteger userStatus, NSString * _Nonnull orderNumber, RWProductDetailModel * _Nonnull productDetail) {
        self.productDetail = productDetail;
    }];
}

- (void)backAction {
    if(self.isRecommend) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

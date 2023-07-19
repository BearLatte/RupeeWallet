//
//  RWApplyExtensionController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/17.
//

#import "RWApplyExtensionController.h"
#import "RWAttributedLabel.h"
#import "RWContentModel.h"

@interface RWApplyExtensionController ()
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *loanNameLabel;
@property(nonatomic, weak) UILabel *extensionTermValueLabel;
@property(nonatomic, weak) UILabel *repaymentAmountValueLabel;
@property(nonatomic, weak) UILabel *nextRepaymentDateValueLabel;
@property(nonatomic, weak) UIButton *extensionBtn;
@property(nonatomic, weak) RWAttributedLabel *extensionFeeLabel;
@property(nonatomic, strong) RWContentModel *extensionOrderModel;
@end

@implementation RWApplyExtensionController

- (void)setupUI {
    [super setupUI];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    UILabel *copywritingLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Pay the extension fee can repayment later." font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    copywritingLabel.numberOfLines = 0;
    [topView addSubview:copywritingLabel];
    [copywritingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(topView).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    [logoView sd_setImageWithURL:[NSURL URLWithString:self.productLogo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    [bgView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(bgView.mas_centerX).offset(-5);
    }];
    self.logoView = logoView;

    UILabel *loanNameLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.productName font:[UIFont systemFontOfSize:20] textColor:THEME_TEXT_COLOR];
    [bgView addSubview:loanNameLabel];
    [loanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(logoView);
    }];
    self.loanNameLabel = loanNameLabel;

    RWAttributedLabel *extensionFeeLabel = [RWAttributedLabel attributedLabelWithKey:nil keyColor:THEME_COLOR keyFont:[UIFont systemFontOfSize:30 weight:UIFontWeightMedium] value:@"Extension Fee" valueColor:INDICATOR_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
    extensionFeeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:extensionFeeLabel];
    [extensionFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(16);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    self.extensionFeeLabel = extensionFeeLabel;
    
    UILabel *extensionTermKeyLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Extension Term" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [bgView addSubview:extensionTermKeyLabel];
    [extensionTermKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(extensionFeeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(22);
        
    }];
    
    UILabel *repaymentAmountKeyLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Repayment Amount" font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [bgView addSubview:repaymentAmountKeyLabel];
    [repaymentAmountKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(extensionTermKeyLabel.mas_bottom).offset(4);
        make.left.height.mas_equalTo(extensionTermKeyLabel);
        
    }];

    UILabel *nextRepaymentDateKeyLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Next Repayment Date" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [bgView addSubview:nextRepaymentDateKeyLabel];
    [nextRepaymentDateKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repaymentAmountKeyLabel.mas_bottom).offset(4);
        make.left.height.mas_equalTo(extensionTermKeyLabel);
    }];

    UILabel *extensionTermValueLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    UILabel *repaymentAmountValueLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_COLOR];
    UILabel *nextRepaymentDateValueLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [bgView addSubview:extensionTermValueLabel];
    [bgView addSubview:repaymentAmountValueLabel];
    [bgView addSubview:nextRepaymentDateValueLabel];
    self.extensionTermValueLabel = extensionTermValueLabel;
    self.repaymentAmountValueLabel = repaymentAmountValueLabel;
    self.nextRepaymentDateValueLabel = nextRepaymentDateValueLabel;

    [extensionTermValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(extensionTermKeyLabel);
    }];

    [repaymentAmountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(extensionTermValueLabel);
        make.centerY.mas_equalTo(repaymentAmountKeyLabel);
    }];

    [nextRepaymentDateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(extensionTermValueLabel);
        make.centerY.mas_equalTo(nextRepaymentDateKeyLabel);
    }];

    UIButton *btn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Extension Now" cornerRadius:30];
    [btn addTarget:self action:@selector(extensionNowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nextRepaymentDateKeyLabel.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(bgView);
        make.bottom.mas_equalTo(bgView).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    [bgView setCornerRadius:10 rectCorner:UIRectCornerAllCorners];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setExtensionOrderModel:(RWContentModel *)extensionOrderModel {
    _extensionOrderModel = extensionOrderModel;
    self.extensionFeeLabel.key = [NSString stringWithFormat:@"₹ %@ ", extensionOrderModel.extendFee];
    self.extensionTermValueLabel.text = [NSString stringWithFormat:@"%@ days", extensionOrderModel.extendDate];
    self.repaymentAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", extensionOrderModel.extendRepayAmount];
    self.nextRepaymentDateValueLabel.text = extensionOrderModel.extendRepayDate;
}

- (void)loadData {
    [[RWNetworkService sharedInstance] fetchExtensionApplyWithOrderNumber:self.orderNumber success:^(RWContentModel * _Nonnull extensionModel) {
        self.extensionOrderModel = extensionModel;
    }];
}

- (void)extensionNowBtnClicked {
    [RWADJTrackTool trackingWithPoint:@"nve5kh"];
    [[RWNetworkService sharedInstance] fetchRepayPathWithOrderNumber:self.orderNumber repayType:@"extend" success:^(RWContentModel * _Nonnull repayPathModel) {
        NSURL *url = [NSURL URLWithString:repayPathModel.path];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }
    }];
}

- (void)appDidBecomeActive:(NSNotification *)noti {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

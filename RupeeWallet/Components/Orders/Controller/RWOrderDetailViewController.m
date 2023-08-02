//
//  RWOrderDetailViewController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import "RWOrderDetailViewController.h"
#import "RWAttributedLabel.h"
#import "RWOrderModel.h"
#import "RWProductCell.h"
#import "RWSectionHeaderView.h"
#import "RWAlertView.h"
#import "RWApplyExtensionController.h"
#import "RWProductDetailController.h"

@interface RWOrderDetailViewController ()
@property(nonatomic, weak) UIView *detailBgView;
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *loanNameLabel;

@property(nonatomic, weak) UILabel *repaymentAmountKeyLabel;
@property(nonatomic, weak) UILabel *repaymentAmountValueLabel;

@property(nonatomic, weak) UILabel *repaymentDateKeyLabel;
@property(nonatomic, weak) UILabel *repaymentDateValueLabel;

@property(nonatomic, weak) UILabel *orderNumberKeyLabel;
@property(nonatomic, weak) UILabel *orderNumberValueLabel;

@property(nonatomic, weak) UILabel *loanAmountKeyLabel;
@property(nonatomic, weak) UILabel *loanAmountValueLabel;

@property(nonatomic, weak) UILabel *applyDateKeyLabel;
@property(nonatomic, weak) UILabel *applyDateValueLabel;

@property(nonatomic, weak) UILabel *receivedAmountKeyLabel;
@property(nonatomic, weak) UILabel *receivedAmountValueLabel;

@property(nonatomic, weak) UILabel *receivedDateKeyLabel;
@property(nonatomic, weak) UILabel *receivedDateValueLabel;

@property(nonatomic, weak) UILabel *overdueChargeKeyLabel;
@property(nonatomic, weak) UILabel *overdueChargeValueLabel;

@property(nonatomic, weak) UILabel *overdueDaysKeyLabel;
@property(nonatomic, weak) UILabel *overdueDaysValueLabel;

@property(nonatomic, weak) UILabel *accountKeyLabel;
@property(nonatomic, weak) UILabel *accountValueLabel;

@property(nonatomic, weak) UIView *topView;
@property(nonatomic, weak) UILabel *copywritingLabel;


/// repay button
@property(nonatomic, weak) UIButton *repayNowBtn;
@property(nonatomic, weak) UIButton *repayExtensionBtn;

@property(nonatomic, strong) RWOrderModel *orderDetail;
@property(nonatomic, strong) NSArray *_Nullable recommendProducts;
@property(nonatomic, assign) NSInteger frozenDays;
@end

@implementation RWOrderDetailViewController
- (void)setupUI {
    [super setupUI];
    self.tableView.hidden = YES;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    self.topView = topView;
    
    UILabel *copyrwiting = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    copyrwiting.numberOfLines = 0;
    [self.topView addSubview:copyrwiting];
    self.copywritingLabel = copyrwiting;
    
    UIView *contentBg = [[UIView alloc] init];
    contentBg.backgroundColor = [UIColor whiteColor];
    contentBg.layer.cornerRadius = 10;
    contentBg.layer.masksToBounds = YES;
    [self.view addSubview:contentBg];
    self.detailBgView = contentBg;
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.layer.cornerRadius = 10;
    logo.layer.masksToBounds = YES;
    logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.detailBgView addSubview:logo];
    self.logoView = logo;
    
    UILabel *loanName = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:loanName];
    self.loanNameLabel = loanName;
    
    
    UILabel *loanAmountTipLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Loan amount:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:loanAmountTipLabel];
    self.loanAmountKeyLabel = loanAmountTipLabel;
    
    UILabel *loanAmountValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:loanAmountValue];
    self.loanAmountValueLabel = loanAmountValue;
    
    UILabel *applyDateTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Apply date:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:applyDateTip];
    self.applyDateKeyLabel = applyDateTip;
    
    UILabel *applyDateValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:applyDateValue];
    self.applyDateValueLabel = applyDateValue;
    
    UILabel *accountKeyTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Account:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:accountKeyTip];
    self.accountKeyLabel = accountKeyTip;
    
    UILabel *accountValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:accountValue];
    self.accountValueLabel = accountValue;
    
    UILabel *orderNumberTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Order Number:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:orderNumberTip];
    self.orderNumberKeyLabel = orderNumberTip;
    
    UILabel *orderNumberValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:orderNumberValue];
    self.orderNumberValueLabel = orderNumberValue;
    
    
    UILabel *repaymentAmountTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Repayment Amount" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:repaymentAmountTip];
    self.repaymentAmountKeyLabel = repaymentAmountTip;
    
    UILabel *repaymentAmountValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:repaymentAmountValue];
    self.repaymentAmountValueLabel = repaymentAmountValue;
    
    UILabel *repaymentDateTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Repayment Date:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:repaymentDateTip];
    self.repaymentDateKeyLabel = repaymentDateTip;
    
    UILabel *repaymentDateValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:repaymentDateValue];
    self.repaymentDateValueLabel = repaymentDateValue;
    
    UILabel *receivedAmountTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Received Amount:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:receivedAmountTip];
    self.receivedAmountKeyLabel = receivedAmountTip;
    
    UILabel *receivedAmountValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:receivedAmountValue];
    self.receivedAmountValueLabel = receivedAmountValue;
    
    UILabel *receivedDateTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Date of loan received:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:receivedDateTip];
    self.receivedDateKeyLabel = receivedDateTip;
    
    UILabel *receivedDateValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:receivedDateValue];
    self.receivedDateValueLabel = receivedDateValue;
    
    UILabel *overdueChageTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Overdue Charge:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:overdueChageTip];
    self.overdueChargeKeyLabel = overdueChageTip;
    
    UILabel *overdueChangeValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:overdueChangeValue];
    self.overdueChargeValueLabel = overdueChangeValue;
    
    UILabel *overdueDaysTip = [[RWGlobal sharedGlobal] createLabelWithText:@"Overdue Days:" font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    [self.detailBgView addSubview:overdueDaysTip];
    self.overdueDaysKeyLabel = overdueDaysTip;
    
    UILabel *overdueDaysValue = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [self.detailBgView addSubview:overdueDaysValue];
    self.overdueDaysValueLabel = overdueDaysValue;
    
    UIButton *repayBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Repay Now" cornerRadius:30];
    [repayBtn addTarget:self action:@selector(repayNow) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBgView addSubview:repayBtn];
    self.repayNowBtn = repayBtn;
    
    UIButton *extensionBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Repay Extension" cornerRadius:30];
    [extensionBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#99D9D3"]] forState:UIControlStateNormal];
    [extensionBtn addTarget:self action:@selector(extensionRepay) forControlEvents:UIControlEventTouchUpInside];
    [self.detailBgView addSubview:extensionBtn];
    self.repayExtensionBtn = extensionBtn;
    
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    [self.tableView registerClass:[RWProductCell class] forCellReuseIdentifier:@"ProductCell"];
    [self.tableView registerClass:[RWSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SectionHeaderView"];
}

- (void)setOrderDetail:(RWOrderModel *)orderDetail {
    _orderDetail = orderDetail;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:orderDetail.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    self.loanNameLabel.text = orderDetail.loanName;
    self.loanAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", orderDetail.loanAmountStr];
    self.applyDateValueLabel.text = orderDetail.applyDateStr;
    self.orderNumberValueLabel.text = orderDetail.loanOrderNo;
    self.accountValueLabel.text = orderDetail.bankCardNo;
    switch (orderDetail.status) {
        case 0:
        case 1:
        case 7:
            [self configTopViewStyleViewData];
            break;
        default:
            self.view.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
            [self configNotTopViewStyleViewData];
            break;
    }
    [self updateUI];
}



- (void)configTopViewStyleViewData {
    self.topView.hidden = NO;
    self.orderNumberKeyLabel.hidden = YES;
    self.orderNumberValueLabel.hidden = YES;
    self.repaymentAmountKeyLabel.hidden = YES;
    self.repaymentAmountValueLabel.hidden = YES;
    self.repaymentDateKeyLabel.hidden = YES;
    self.repaymentDateValueLabel.hidden = YES;
    self.receivedAmountKeyLabel.hidden = YES;
    self.receivedAmountValueLabel.hidden = YES;
    self.receivedDateKeyLabel.hidden = YES;
    self.receivedDateValueLabel.hidden = YES;
    self.overdueChargeKeyLabel.hidden = YES;
    self.overdueChargeValueLabel.hidden = YES;
    self.overdueDaysKeyLabel.hidden = YES;
    self.overdueDaysValueLabel.hidden = YES;
    self.repayNowBtn.hidden = YES;
    self.repayExtensionBtn.hidden = YES;
    
    if(self.orderDetail.status == 0) {
        self.title = @"Pending";
        self.copywritingLabel.text = @"Your loan is being reviewed. We will notify you after it is approved.";
    } else if(self.orderDetail.status == 1) {
        self.title = @"Disbursing";
        self.copywritingLabel.text = @"The loan is being disbursed and we will inform you immediately after it is disbursed.";
    } else {
        if(self.frozenDays > 0) {
            self.title = @"Denied";
            self.copywritingLabel.text = [NSString stringWithFormat:@"Unfortunately, your loan application has not been approved. You can reapply for this product in %ld  days, or you can apply for the following other products immediately.", self.frozenDays];
        } else {
            self.detailBgView.hidden = YES;
            self.title = @"Detail";
            self.copywritingLabel.text = @"Congratulate! You can apply for a loan now.";
        }
    }
    
    self.tableView.hidden = NO;
}

- (void)configNotTopViewStyleViewData {
    self.topView.hidden = YES;
    if(self.orderDetail.status == 2 || self.orderDetail.status == 5) {
        self.repayNowBtn.hidden = NO;
        self.repayExtensionBtn.hidden = NO;
        [self checkExtensionBtnIsShow];
        self.title = self.orderDetail.status == 2 ? @"To be Repaid" : @"Overdue";
        self.repaymentAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.repayAmountStr];
        self.repaymentAmountValueLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        self.repaymentAmountValueLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
        self.repaymentAmountKeyLabel.text = @"Repayment Amount";
        self.repaymentDateValueLabel.text = self.orderDetail.repayDateStr;
        self.receivedAmountKeyLabel.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        self.receivedAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.receiveAmountStr];
        self.receivedAmountValueLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        self.receivedDateValueLabel.text = self.orderDetail.receiveDateStr;
        self.overdueChargeValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.overDueFeeStr];
        self.overdueDaysValueLabel.text = self.orderDetail.overDueDays;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    } else if(self.orderDetail.status == 6) {
        self.repayNowBtn.hidden = YES;
        self.repayExtensionBtn.hidden = YES;
        self.title = @"Disbursing Fail";
        self.loanAmountKeyLabel.text = @"Loan Amount";
        self.loanAmountValueLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
        self.loanAmountValueLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
    } else {
        self.repayNowBtn.hidden = YES;
        self.repayExtensionBtn.hidden = YES;
        self.title = @"Repaid";
        self.tableView.hidden = NO;
        self.repaymentAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.repayAmountStr];
        self.repaymentAmountValueLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        self.repaymentAmountValueLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
        self.repaymentAmountKeyLabel.text = @"Repayment Amount";
        self.repaymentDateValueLabel.text = self.orderDetail.repayDateStr;
        self.receivedAmountKeyLabel.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        self.receivedAmountValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.receiveAmountStr];
        self.receivedAmountValueLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        self.receivedDateValueLabel.text = self.orderDetail.receiveDateStr;
        self.overdueChargeValueLabel.text = [NSString stringWithFormat:@"₹ %@", self.orderDetail.overDueFeeStr];
        self.overdueDaysValueLabel.text = self.orderDetail.overDueDays;
    }
}


- (void)updateUI {
    switch (self.orderDetail.status) {
        case 0:
        case 1:
        case 7:
            [self layoutTopViewStyle];
            break;
        case 2:
        case 5:
            [self layoutToRepaidAndOverdueStyle];
            break;
        case 6:
            [self layoutDisbursingFailStyle];
            break;
        default:
            [self layoutRepaidStyle];
            break;
    }
}

- (void)layoutTopViewStyle {
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.copywritingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.topView).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    
    if(self.orderDetail.status != 7 || (self.orderDetail.status == 7 && self.frozenDays > 0)) {
        [self.detailBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];

        [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 42));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(self.detailBgView.mas_centerX).offset(-5);
        }];

        [self.loanNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.detailBgView.mas_centerX).offset(5);
            make.centerY.mas_equalTo(self.logoView);
        }];

        [self.loanAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logoView.mas_bottom).offset(20);
            make.left.mas_equalTo(30);
            make.height.mas_equalTo(22);
        }];

        [self.loanAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(self.loanAmountKeyLabel);
        }];

        [self.applyDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loanAmountKeyLabel.mas_bottom).offset(4);
            make.left.height.mas_equalTo(self.loanAmountKeyLabel);
        }];

        [self.applyDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.loanAmountValueLabel);
            make.centerY.mas_equalTo(self.applyDateKeyLabel);
        }];

        [self.accountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.applyDateKeyLabel.mas_bottom).offset(4);
            make.left.height.mas_equalTo(self.loanAmountKeyLabel);
            make.bottom.mas_equalTo(self.detailBgView.mas_bottom).offset(-20).priority(MASLayoutPriorityDefaultHigh);
        }];

        [self.accountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.loanAmountValueLabel);
            make.centerY.mas_equalTo(self.accountKeyLabel);
        }];

        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailBgView.mas_bottom).offset(20);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(- BOTTOM_SAFE_AREA);
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(- BOTTOM_SAFE_AREA);
        }];
    }
    
    [self.tableView reloadData];
    
}

- (void)layoutDisbursingFailStyle {
    [self.detailBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    
    [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.right.mas_equalTo(self.detailBgView.mas_centerX).offset(-5);
    }];
    
    [self.loanNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.loanAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.logoView);
        make.height.mas_equalTo(42);
    }];
    
    [self.loanAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loanAmountValueLabel.mas_right).offset(10);
        make.bottom.mas_equalTo(self.loanAmountValueLabel).offset(-5);
    }];
    
    [self.applyDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loanAmountValueLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(22);
    }];
    
    [self.applyDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.applyDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.applyDateKeyLabel);
    }];
    
    [self.orderNumberKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.applyDateKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.applyDateKeyLabel);
    }];
    
    [self.orderNumberValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumberKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.orderNumberKeyLabel);
    }];
    
    [self.accountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumberKeyLabel.mas_bottom).offset(10);
        make.left.height.mas_equalTo(self.applyDateKeyLabel);
    }];
    
    [self.accountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.accountKeyLabel);
    }];
}

- (void)layoutToRepaidAndOverdueStyle {
    [self.detailBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    
    [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(self.detailBgView.mas_centerX).offset(-5);
    }];
    
    [self.loanNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.repaymentAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(16);
        make.right.mas_equalTo(self.logoView.mas_right).offset(18);
        make.height.mas_equalTo(42);
    }];
    
    [self.repaymentAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.repaymentAmountValueLabel).offset(-5);
        make.left.mas_equalTo(self.repaymentAmountValueLabel.mas_right).offset(10);
    }];
    
    [self.repaymentDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repaymentAmountValueLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(22);
    }];
    
    [self.repaymentDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.repaymentDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.orderNumberKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repaymentDateKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.orderNumberValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumberKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.orderNumberKeyLabel);
    }];
    
    [self.loanAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumberKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.loanAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loanAmountKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.loanAmountKeyLabel);
    }];
    
    [self.applyDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loanAmountKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.applyDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.applyDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.applyDateKeyLabel);
    }];
    
    if(self.orderDetail.status == 5) {
        [self.overdueChargeKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.applyDateKeyLabel.mas_bottom).offset(8);
            make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
        }];
        
        [self.overdueChargeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.overdueChargeKeyLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.overdueChargeKeyLabel);
        }];
        
        [self.overdueDaysKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.overdueChargeKeyLabel.mas_bottom).offset(8);
            make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
        }];
        
        [self.overdueDaysValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.overdueDaysKeyLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.overdueDaysKeyLabel);
        }];
    }
    
    [self.receivedAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderDetail.status == 5 ? self.overdueDaysKeyLabel.mas_bottom : self.applyDateKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.receivedAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receivedAmountKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.receivedAmountKeyLabel);
    }];
    
    [self.receivedDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.receivedAmountKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.receivedDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receivedDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.receivedDateKeyLabel);
    }];
    
    [self.repayExtensionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.bottom.mas_equalTo(self.detailBgView).offset(-20);
        make.centerX.mas_equalTo(self.detailBgView);
    }];
    
    [self.repayNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.mas_equalTo(self.repayExtensionBtn);
        make.bottom.mas_equalTo(self.repayExtensionBtn.mas_top).offset(-10);
    }];
    
}

- (void)layoutRepaidStyle {
    [self.detailBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(self.detailBgView.mas_centerX).offset(-5);
    }];
    
    [self.loanNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.repaymentAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(16);
        make.right.mas_equalTo(self.logoView.mas_right).offset(18);
        make.height.mas_equalTo(42);
    }];
    
    [self.repaymentAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.repaymentAmountValueLabel).offset(-5);
        make.left.mas_equalTo(self.repaymentAmountValueLabel.mas_right).offset(10);
    }];
    
    [self.repaymentDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repaymentAmountValueLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(22);
    }];
    
    [self.repaymentDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.repaymentDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.orderNumberKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repaymentDateKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.orderNumberValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumberKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.orderNumberKeyLabel);
    }];
    
    [self.loanAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumberKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.loanAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loanAmountKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.loanAmountKeyLabel);
    }];
    
    [self.applyDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loanAmountKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.applyDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.applyDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.applyDateKeyLabel);
    }];
    
    if(self.orderDetail.status == 9) {
        [self.overdueChargeKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.applyDateKeyLabel.mas_bottom).offset(8);
            make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
        }];
        
        [self.overdueChargeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.overdueChargeKeyLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.overdueChargeKeyLabel);
        }];
        
        [self.overdueDaysKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.overdueChargeKeyLabel.mas_bottom).offset(8);
            make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
        }];
        
        [self.overdueDaysValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.overdueDaysKeyLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.overdueDaysKeyLabel);
        }];
    }
    
    [self.receivedAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderDetail.status == 9 ? self.overdueDaysKeyLabel.mas_bottom : self.applyDateKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
    }];
    
    [self.receivedAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receivedAmountKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.receivedAmountKeyLabel);
    }];
    
    [self.receivedDateKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.receivedAmountKeyLabel.mas_bottom).offset(8);
        make.left.height.mas_equalTo(self.repaymentDateKeyLabel);
        make.bottom.mas_equalTo(self.detailBgView).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [self.receivedDateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receivedDateKeyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.receivedDateKeyLabel);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailBgView.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    
    [self.tableView reloadData];
}

- (void)repayNow {
    if(self.orderDetail.status == 5) {
        [RWADJTrackTool trackingWithPoint:@"h2ppgy"];
    } else {
        [RWADJTrackTool trackingWithPoint:@"dh9710"];
    }
    
    [[RWNetworkService sharedInstance] fetchRepayPathWithOrderNumber:self.auditOrderNo repayType:@"all" success:^(RWContentModel * _Nonnull repayPathModel) {
        NSURL *url = [NSURL URLWithString:repayPathModel.path];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }
    }];
}

- (void)extensionRepay {
    if(self.orderDetail.status == 5) {
        [RWADJTrackTool trackingWithPoint:@"rwel5k"];
    } else {
        [RWADJTrackTool trackingWithPoint:@"m7og9z"];
    }
    [RWAlertView showAlertViewWithStyle:RWAlertStyleTips title:nil message:@"Paying a small amount admission fee. You can pay the whole bill later." confirmAction:^{
        RWApplyExtensionController *applyController = [[RWApplyExtensionController alloc] init];
        applyController.orderNumber = self.orderDetail.loanOrderNo;
        applyController.productLogo = self.orderDetail.logo;
        applyController.productName = self.orderDetail.loanName;
        [self.navigationController pushViewController:applyController animated:YES];
    }];
}

- (void)appDidBecomeActive:(NSNotification *)noti {
    [self loadData];
}


- (void)loadData {
    
    [[RWNetworkService sharedInstance] fetchOrderDetailWithOrderNumber:self.auditOrderNo success:^(NSInteger frozenDays, RWOrderModel * _Nonnull order, NSArray * _Nonnull productList) {
        self.frozenDays = frozenDays;
        self.recommendProducts = productList;
        self.orderDetail = order;
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)checkExtensionBtnIsShow {
    [[RWNetworkService sharedInstance] checkExtensionBtnShowWithOrderNumber:self.auditOrderNo success:^(BOOL isShow) {
        self.repayExtensionBtn.hidden = !isShow;;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// MARK: - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    cell.product = self.recommendProducts[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RWSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionHeaderView"];
    headerView.hidden = YES;
    if(self.tableView.isHidden) {
        headerView.hidden = YES;
    } else {
        headerView.hidden = false;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.orderDetail.status == 7) {
        [RWADJTrackTool trackingWithPoint:@"ebjfex"];
    }
    RWProductModel *product = self.recommendProducts[indexPath.row];
    [[RWNetworkService sharedInstance] checkUserStatusWithProductId:product.productId success:^(NSInteger userStatus, NSString * _Nonnull orderNumber, RWProductDetailModel * _Nonnull productDetail) {
        if (userStatus == 2) {
            RWProductDetailController *detailController = [[RWProductDetailController alloc] init];
            detailController.productId = product.productId;
            [self.navigationController pushViewController:detailController animated:YES];
        } else {
            RWOrderDetailViewController *detailController = [[RWOrderDetailViewController alloc] init];
            detailController.auditOrderNo = orderNumber;
            [self.navigationController pushViewController:detailController animated:YES];
        }
    }];
}


@end

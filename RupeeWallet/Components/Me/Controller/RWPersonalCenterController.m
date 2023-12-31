//
//  RWPersonalCenterController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWPersonalCenterController.h"
#import "UIButton+Extension.h"
#import "RWBankCardController.h"
#import "RWFeedbackController.h"
#import "RWAboutUsController.h"
#import "RWOrderPagingController.h"
#import "RWWebViewController.h"


typedef void(^ItemViewTapAction)(void);

@interface RWItemView : UIView
@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *rightArrowView;
@property(nonatomic, copy) ItemViewTapAction tapAction;
+ (instancetype)itemViewWithIcon:(NSString *)icon title:(NSString *)title tapAction:(void(^)(void))tapAction;
@end

@implementation RWItemView
+ (instancetype)itemViewWithIcon:(NSString *)icon title:(NSString *)title tapAction:(void (^)(void))tapAction {
    RWItemView *itemView = [[RWItemView alloc] init];
    itemView.iconView.image = [UIImage imageNamed:icon];
    itemView.titleLabel.text = title;
    itemView.tapAction = tapAction;
    return itemView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:14] textColor:THEME_TEXT_COLOR];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        rightArrow.contentMode = UIViewContentModeCenter;
        [self addSubview:rightArrow];
        self.rightArrowView = rightArrow;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(self).offset(-15).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(16);
        make.centerY.mas_equalTo(self.iconView);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 9));
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if(self.tapAction) {
        self.tapAction();
    }
}

@end

@interface RWPersonalCenterController ()
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *phoneLabel;
@property(nonatomic, weak) RWItemView *aboutUsView;
@property(nonatomic, weak) RWItemView *deleteAccountView;
@property(nonatomic, weak) UIButton *logoutBtn;
@end

@implementation RWPersonalCenterController

- (void)setupUI {
    [super setupUI];
    self.isHiddenBackButton = YES;
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_img"]];
    topImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(topImg.mas_width).multipliedBy(0.77);
    }];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_icon"]];
    [self.contentView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topImg);
    }];
    self.logoView = logo;
    
    UILabel *phoneLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:22 weight:UIFontWeightMedium] textColor:@"#ffffff"];
    [self.contentView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logo.mas_bottom).offset(6);
        make.centerX.mas_equalTo(logo);
    }];
    self.phoneLabel = phoneLabel;
    
    UIButton *orderBtn = [self buttonWithImage:@"orders_icon" title:@"My Orders"];
    [self.contentView addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImg.mas_bottom).offset(-38);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(76);
    }];
    [orderBtn addTarget:self action:@selector(ordersBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bankCardBtn = [self buttonWithImage:@"bank_card_icon" title:@"Change Bank Info"];
    [self.contentView addSubview:bankCardBtn];
    [bankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(orderBtn);
        make.left.mas_equalTo(orderBtn.mas_right);
    }];
    [bankCardBtn addTarget:self action:@selector(bankCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *feedbackBtn = [self buttonWithImage:@"feedback_icon" title:@"Feedback"];
    [self.contentView addSubview:feedbackBtn];
    [feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(bankCardBtn);
        make.left.mas_equalTo(bankCardBtn.mas_right);
        make.right.mas_equalTo(-12);
    }];
    [feedbackBtn addTarget:self action:@selector(feedbackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [orderBtn setCornerRadius:10 rectCorner: UIRectCornerTopLeft | UIRectCornerBottomLeft];
    [feedbackBtn setCornerRadius:10 rectCorner:UIRectCornerTopRight | UIRectCornerBottomRight];
    [orderBtn topImageLayoutWithSpacing:4];
    [bankCardBtn topImageLayoutWithSpacing: 4];
    [feedbackBtn topImageLayoutWithSpacing:4];
    
    RWItemView *privacyView = [RWItemView itemViewWithIcon:@"privacy_icon" title:@"Privacy Policy" tapAction:^{
        RWWebViewController *webView = [[RWWebViewController alloc] init];
        [self.navigationController pushViewController:webView animated:YES];
    }];
    [self.contentView addSubview:privacyView];
    [privacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    [privacyView setCornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    RWItemView *aboutUsView = [RWItemView itemViewWithIcon:@"about_us_icon" title:@"About Us" tapAction:^{
        RWAboutUsController *aboutUsController = [[RWAboutUsController alloc] init];
        [self.navigationController pushViewController:aboutUsController animated:YES];
    }];
    [self.contentView addSubview:aboutUsView];
    [aboutUsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privacyView.mas_bottom);
        make.left.right.mas_equalTo(privacyView);
    }];
    self.aboutUsView = aboutUsView;
    
    RWItemView *deleteAccountView = [RWItemView itemViewWithIcon:@"delete_icon" title:@"Delete account" tapAction:^{
        if([RWGlobal sharedGlobal].isLogin) {
            [[RWNetworkService sharedInstance] logoutWithDeleteAccount:YES success:^{
                [[RWGlobal sharedGlobal] clearLoginData];
                [self loadData];
            }];
        } else {
            return;
        }
    }];
    [self.contentView addSubview:deleteAccountView];
    [deleteAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(aboutUsView.mas_bottom);
        make.left.right.mas_equalTo(privacyView);
    }];
    [deleteAccountView setCornerRadius:10 rectCorner: UIRectCornerBottomLeft | UIRectCornerBottomRight];
    self.deleteAccountView = deleteAccountView;
    
    UIButton *logout = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Logout" cornerRadius:20];
    [logout setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#A5D0CB"]] forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor colorWithHexString:@"4BB7AC"] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:logout];
    [logout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(deleteAccountView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(165, 40));
        make.centerX.mas_equalTo(self.view);
    }];
    self.logoutBtn = logout;
    
    UIImageView *bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_img"]];
    [self.contentView addSubview:bottomImage];
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logout.mas_bottom).offset(20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
//        make.height.mas_equalTo(bottomImage.mas_width).multipliedBy(0.47);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)loadData {
    if([RWGlobal sharedGlobal].isLogin) {
        self.phoneLabel.text = [RWGlobal sharedGlobal].currentPhoneNumber;
        self.aboutUsView.layer.mask = nil;
        self.deleteAccountView.hidden = NO;
        self.logoutBtn.hidden = NO;
        self.logoView.image = [UIImage imageNamed:@"logo_login"];
    } else {
        self.phoneLabel.text = @"Please log in";
        self.deleteAccountView.hidden = YES;
        self.logoutBtn.hidden = YES;
        self.logoView.image = [UIImage imageNamed:@"logo_icon"];
        [self.aboutUsView setCornerRadius:10 rectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
}


- (UIButton *)buttonWithImage:(NSString *)image title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:THEME_COLOR]] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}

- (void)ordersBtnClicked {
    [RWADJTrackTool trackingWithPoint:@"6fh0a9"];
    if([RWGlobal sharedGlobal].isLogin) {
        RWOrderPagingController *paging = [[RWOrderPagingController alloc] init];
        [self.navigationController pushViewController:paging animated:YES];
    } else {
        [[RWGlobal sharedGlobal] go2login];
    }
}

- (void)bankCardBtnClicked {
    [RWADJTrackTool trackingWithPoint:@"ruvhae"];
    if([RWGlobal sharedGlobal].isLogin) {
        [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:RWAuthTypeAllInfo success:^(RWContentModel * _Nonnull authenficationInfo) {
            if(authenficationInfo.authStatus) {
                RWBankCardController *controller= [[RWBankCardController alloc] init];
                controller.authStatus = authenficationInfo;
                controller.modify = YES;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [RWProgressHUD showInfoWithStatus:@"Please authenticate your identity first."];
            }
        }];
    } else {
        [[RWGlobal sharedGlobal] go2login];
    }
}

- (void)feedbackBtnClicked {
    if([RWGlobal sharedGlobal].isLogin) {
        RWFeedbackController *feedback = [[RWFeedbackController alloc] init];
        [self.navigationController pushViewController:feedback animated:YES];
    } else {
        [[RWGlobal sharedGlobal] go2login];
    }
}


- (void)logoutAction {
    [[RWNetworkService sharedInstance] logoutWithDeleteAccount:NO success:^{
        [[RWGlobal sharedGlobal] clearLoginData];
        [self loadData];
    }];
}

@end




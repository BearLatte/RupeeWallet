//
//  RWPayFailToastView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/19.
//

#import "RWPayFailToastView.h"
#import "RWAttributedLabel.h"

@interface RWPayFailToastView()
@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *loanNameLabel;
@property(nonatomic, weak) RWAttributedLabel *orderNumberLabel;
@property(nonatomic, weak) UILabel *tipsLabel;
@property(nonatomic, weak) UILabel *infoLabel;
@property(nonatomic, weak) UIButton *confirmBtn;

@property(nonatomic, strong) RWUserPayFailModel *payFailInfo;
@end

@implementation RWPayFailToastView
+ (void)showToastWithPayFailInfo:(RWUserPayFailModel *)info {
    RWPayFailToastView *toastView = [[RWPayFailToastView alloc] init];
    toastView.payFailInfo = info;
    [toastView show];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor whiteColor];
        [self addSubview:container];
        self.containerView = container;
        
        UIImageView *logo = [[UIImageView alloc] init];
        logo.contentMode = UIViewContentModeScaleAspectFill;
        logo.layer.cornerRadius = 10;
        logo.layer.masksToBounds = YES;
        [self.containerView addSubview:logo];
        self.logoView = logo;
        
        UILabel *nameLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
        [self.containerView addSubview:nameLabel];
        self.loanNameLabel = nameLabel;
        
        RWAttributedLabel *orderLabel = [RWAttributedLabel attributedLabelWithKey:@"Order Number : " keyColor:INDICATOR_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
        [self.containerView addSubview:orderLabel];
        self.orderNumberLabel = orderLabel;
        
        UILabel *tipsLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Tips" font:[UIFont systemFontOfSize:18] textColor:THEME_TEXT_COLOR];
        [self.containerView addSubview:tipsLabel];
        self.tipsLabel = tipsLabel;
        
        UILabel *infoLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:18] textColor:THEME_TEXT_COLOR];
        infoLabel.numberOfLines = 0;
        [self.containerView addSubview:infoLabel];
        self.infoLabel = infoLabel;
        
        UIButton *btn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"OK" cornerRadius:30];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:btn];
        self.confirmBtn = btn;
    }
    return self;
}

- (void)setPayFailInfo:(RWUserPayFailModel *)payFailInfo {
    _payFailInfo = payFailInfo;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:payFailInfo.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    self.loanNameLabel.text = payFailInfo.loanName;
    self.orderNumberLabel.value = payFailInfo.loanOrderNo;
    self.infoLabel.text = payFailInfo.content;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_top);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA + 20);
        make.right.mas_equalTo(self.mas_centerX).offset(-5);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.loanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(16);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumberLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(22);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.containerView).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
}

- (void)show {
    [self.containerView layoutIfNeeded];
    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

//
//  RWSaveFeedbackSuccessToastView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWSaveFeedbackSuccessToastView.h"

@interface RWSaveFeedbackSuccessToastView()
@property(nonatomic, weak) UIView *container;
@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UILabel *indicatorLabel;
@property(nonatomic, weak) UIButton *okBtn;
@property(nonatomic, copy) void(^okBtnClickedAction)(void);
@end

@implementation RWSaveFeedbackSuccessToastView
+ (void)showToastWithOkAction:(void (^)(void))action {
    RWSaveFeedbackSuccessToastView *toast = [[RWSaveFeedbackSuccessToastView alloc] init];
    toast.okBtnClickedAction = action;
    [toast layoutIfNeeded];
    [toast show];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor whiteColor];
        [self addSubview:container];
        self.container = container;
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon"]];
        iconView.contentMode = UIViewContentModeCenter;
        [self.container addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *indicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Submitted successfully" font:[UIFont systemFontOfSize:18] textColor:THEME_TEXT_COLOR];
        indicatorLabel.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:indicatorLabel];
        self.indicatorLabel = indicatorLabel;
        
        UIButton *okBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"OK" cornerRadius:30];
        [okBtn addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:okBtn];
        self.okBtn = okBtn;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_top);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(4);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(23);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indicatorLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
}

- (void)okBtnClicked {
    if(self.okBtnClickedAction) {
        self.okBtnClickedAction();
    }
    [self dismiss];
}

- (void)show {
    [self.container layoutIfNeeded];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.container.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.container.frame));
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.container.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end


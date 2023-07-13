//
//  RWAlertView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWAlertView.h"
@interface RWAlertView()
@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, weak) UILabel *_Nullable titleLabel;
@property(nonatomic, weak) UILabel *_Nullable messageLabel;
@property(nonatomic, weak) UIButton *cancelButton;
@property(nonatomic, weak) UIButton *sureButton;
@property(nonatomic, copy) ConfirmButtonAction confirmAction;
@end
@implementation RWAlertView
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmAction:(ConfirmButtonAction)action {
    RWAlertView *alertView = [[RWAlertView alloc] init];
    if(title) {
        alertView.titleLabel.text = title;
    } else {
        alertView.hidden = YES;
    }
    alertView.messageLabel.text = message;
    alertView.confirmAction = action;
    [alertView layoutIfNeeded];
    [alertView show];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        self.containerView = containerView;
        
        UILabel *titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_COLOR];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *message = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:18] textColor:THEME_TEXT_COLOR];
        message.numberOfLines = 0;
        message.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:message];
        self.messageLabel = message;
        
        UIButton *cancel = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Cancel" cornerRadius:30];
        [cancel setTitleColor:[UIColor colorWithHexString:THEME_TEXT_COLOR] forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#99D9D3"]] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:cancel];
        self.cancelButton = cancel;
        
        UIButton *sure = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Sure" cornerRadius:30];
        sure.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        [sure addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:sure];
        self.sureButton = sure;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.mas_top);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.left.right.equalTo(@0);
        make.height.equalTo(@55);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.titleLabel.isHidden) {
            make.top.mas_equalTo(TOP_SAFE_AREA);
        } else {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.containerView.mas_centerX).offset(-3);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.containerView).offset(-20);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.cancelButton);
        make.left.mas_equalTo(self.cancelButton.mas_right).offset(6);
        make.right.mas_equalTo(-20);
    }];
}

- (void)sureBtnClicked {
    if(self.confirmAction) {
        self.confirmAction();
    }
    
    [self dismiss];
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

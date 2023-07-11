//
//  RWLoginViewController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWLoginViewController.h"
#import "RWLoginContentView.h"

@interface RWLoginViewController ()<RWLoginContentViewDelegate>
@property(nonatomic, strong) RWLoginContentView *loginPhoneNumberContentView;
@property(nonatomic, strong) RWLoginContentView *loginOPTContentView;
@property(nonatomic, assign) NSInteger step;
@end

@implementation RWLoginViewController

- (RWLoginContentView *)loginPhoneNumberContentView {
    if(!_loginPhoneNumberContentView) {
        _loginPhoneNumberContentView = [[RWLoginContentView alloc] init];
        _loginPhoneNumberContentView.contentMode = RWContentViewModeInputPhoneNumber;
        _loginPhoneNumberContentView.delegate = self;
    }
    
    return _loginPhoneNumberContentView;
}

- (RWLoginContentView *)loginOPTContentView {
    if (!_loginOPTContentView) {
        _loginOPTContentView = [[RWLoginContentView alloc] init];
        _loginOPTContentView.contentMode = RWContentViewModeInputOPT;
        _loginOPTContentView.delegate = self;
    }
    return _loginOPTContentView;
}

- (void)setStep:(NSInteger)step {
    _step = step;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (step - 1), 0) animated:YES];
}

- (void)setupUI {
    [super setupUI];
    self.step = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_header_icon"]];
    [self.view insertSubview:imgView atIndex:0];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(imgView.mas_width);
    }];
    
    self.scrollView.scrollEnabled = NO;
    
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
        make.bottom.mas_equalTo(0).priority(MASLayoutPriorityDefaultHigh);
        make.right.mas_equalTo(0).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    
    [self.contentView addSubview:self.loginPhoneNumberContentView];
    [self.loginPhoneNumberContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.contentView addSubview:self.loginOPTContentView];
    [self.loginOPTContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.loginPhoneNumberContentView);
        make.left.mas_equalTo(self.loginPhoneNumberContentView.mas_right);
        make.right.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
}

- (void)backAction {
    if(self.step == 2) {
        self.step = 1;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// MARK: - RWLoginContentViewDelegate
- (void)contentViewTermsConditionAction:(RWLoginContentView *)contentView {
    RWLog(@"TermsCondition");
}

- (void)contentViewPrivacyAction:(RWLoginContentView *)contentView {
    RWLog(@"Privacy");
}

- (void)contentViewActionButtonDidTapped:(RWLoginContentView *)contentView {
    if (contentView == self.loginPhoneNumberContentView) {
        [[RWNetworkService sharedInstance] sendSMSWithPhoneNumber:self.loginPhoneNumberContentView.phoneNumber success:^{
            self.step = 2;
            self.loginOPTContentView.phoneNumber = self.loginPhoneNumberContentView.phoneNumber;
            [self.loginOPTContentView loadCodeInputView];
        }];
    } else {
        [[RWNetworkService sharedInstance] loginWithPhone:self.loginPhoneNumberContentView.phoneNumber code:self.loginOPTContentView.smsCode success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end

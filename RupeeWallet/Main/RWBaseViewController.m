//
//  RWBaseViewController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWBaseViewController.h"

@interface RWBaseViewController ()
@property(nonatomic, strong) UIButton *_Nullable backButton;
@property(nonatomic, strong) UILabel *_Nullable titleLabel;
@end

@implementation RWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalStyle = RWModalStylePush;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)setupUI {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:THEME_BACKGROUND_COLOR];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(TOP_SAFE_AREA);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backButton.mas_right);
        make.centerY.mas_equalTo(self.backButton);
    }];
}

- (UIButton *)backButton {
    if(!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)setIsDarkBackMode:(BOOL)isDarkBackMode {
    _isDarkBackMode = isDarkBackMode;
    if(isDarkBackMode) {
        [self.backButton setImage:[UIImage imageNamed:@"back_icon_dark"] forState:UIControlStateNormal];
        self.titleLabel.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setIsHiddenBackButton:(BOOL)isHiddenBackButton {
    _isHiddenBackButton = isHiddenBackButton;
    self.backButton.hidden = isHiddenBackButton;
}

- (void)loadData {
    RWLog(@"开始加载数据");
}

- (void)backAction {
    if (self.modalPresentationStyle == RWModalStylePresent) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end

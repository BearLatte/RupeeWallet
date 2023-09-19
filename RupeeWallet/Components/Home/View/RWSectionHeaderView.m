//
//  RWSectionHeaderView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWSectionHeaderView.h"
@interface RWSectionHeaderView()
@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UIButton *refreshBtn;
@end

@implementation RWSectionHeaderView

- (void)setIsHiddenRefreshBtn:(BOOL)isHiddenRefreshBtn {
    _isHiddenRefreshBtn = isHiddenRefreshBtn;
    self.refreshBtn.hidden = isHiddenRefreshBtn;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        self.isHiddenRefreshBtn = YES;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bgView;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_header_img"]];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        self.imageView = imgView;
        
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshBtn setImage:[UIImage imageNamed:@"refresh_icon"] forState:UIControlStateNormal];
        refreshBtn.hidden = self.isHiddenRefreshBtn;
        [self.contentView addSubview:refreshBtn];
        [refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.refreshBtn = refreshBtn;
    }
    return self;
}

- (void)refreshBtnClicked {
    if(self.action != nil) {
        self.action();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
}

@end

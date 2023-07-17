//
//  RWApplyExtensionController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/17.
//

#import "RWApplyExtensionController.h"

@interface RWApplyExtensionController ()

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
        make.height.mas_equalTo(200);
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    [logoView sd_setImageWithURL:[NSURL URLWithString:self.order.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    [bgView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(bgView.mas_centerX).offset(-5);
    }];
}

@end

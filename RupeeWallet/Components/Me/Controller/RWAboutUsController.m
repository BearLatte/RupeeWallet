//
//  RWAboutUsController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWAboutUsController.h"
#import "NSBundle+Extension.h"

@interface RWAboutUsController ()

@end

@implementation RWAboutUsController

- (void)setupUI {
    [super setupUI];
    self.title = @"About Us";
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us_bg"]];
    [self.view insertSubview:bgView atIndex:0];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UILabel *versionLabel = [[RWGlobal sharedGlobal] createLabelWithText:[NSString stringWithFormat:@"Version %@", [[NSBundle mainBundle] version]] font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-BOTTOM_SAFE_AREA);
    }];
}

@end

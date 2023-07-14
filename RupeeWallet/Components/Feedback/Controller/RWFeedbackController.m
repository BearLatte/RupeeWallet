//
//  RWFeedbackController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/14.
//

#import "RWFeedbackController.h"

@interface RWFeedbackController ()

@end

@implementation RWFeedbackController
- (void)setupUI {
    [super setupUI];
    self.title = @"My feedback";
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(topView.mas_width).multipliedBy(0.41);
    }];
    
    UILabel *indicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Click the button in the upper right corner to submit your feedback." font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    indicatorLabel.numberOfLines = 0;
    [topView addSubview:indicatorLabel];
    [indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
}
@end

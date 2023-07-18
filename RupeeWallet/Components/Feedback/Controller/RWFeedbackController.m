//
//  RWFeedbackController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/14.
//

#import "RWFeedbackController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "RWSubmitFeedbackController.h"

@interface RWFeedbackController ()<EmptyDataSetSource, EmptyDataSetDelegate>
@property(nonatomic, strong) RWContentModel *_Nullable feedbackParams;
@property(nonatomic, strong) NSArray *_Nullable feedbackList;
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
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
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
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)addBtnClicked {
    RWSubmitFeedbackController *submit = [[RWSubmitFeedbackController alloc] init];
    submit.feedbackParams = self.feedbackParams;
    [self.navigationController pushViewController:submit animated:YES];
}

// MARK: - EmptyDataSetSource, EmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"Please describe your problems and suggestions. we will solve them in time." attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:THEME_TEXT_COLOR],
        NSFontAttributeName : [UIFont systemFontOfSize:16]
    }];
    
    return attStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_data_icon"];
}

- (void)loadData {
    [[RWNetworkService sharedInstance] fetchFeedbackListWithSuccess:^(RWContentModel * _Nonnull feedbackParams, NSArray * _Nonnull feedbackList) {
        self.feedbackParams = feedbackParams;
        self.feedbackList = feedbackList;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^{
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}
@end

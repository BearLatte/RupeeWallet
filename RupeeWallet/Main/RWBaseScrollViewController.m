//
//  RWBaseScrollViewController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWBaseScrollViewController.h"

@interface RWBaseScrollViewController ()

@end

@implementation RWBaseScrollViewController

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (void)setupUI {
    [super setupUI];
    [self.view insertSubview:self.scrollView atIndex:0];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(TOP_SAFE_AREA + 44));
        make.left.right.bottom.equalTo(@0);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0).priority(MASLayoutPriorityDefaultHigh);
    }];
}

@end

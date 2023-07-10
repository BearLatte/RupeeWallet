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
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.scrollView addSubview:self.contentView];
}

@end

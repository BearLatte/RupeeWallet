//
//  RWOrderPagingController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWOrderPagingController.h"
#import "RWOrderListController.h"
#import "RWPagingTitleView.h"
#import "RWPagingListContainerView.h"

@interface RWOrderPagingController ()<RWPagingViewDelegate, RWPagingListContainerViewDelegate>
@property(nonatomic, strong) NSArray *listTitles;
@property(nonatomic, strong) RWPagingTitleView *pagingView;
@property(nonatomic, strong) RWPagingListContainerView *containerView;
@end

@implementation RWOrderPagingController
- (RWPagingTitleView *)pagingView {
    if(!_pagingView) {
        _pagingView = [[RWPagingTitleView alloc] init];
        _pagingView.titles = self.listTitles;
        _pagingView.delegate = self;
        _pagingView.listContainer = self.containerView;
        _pagingView.titleColor = [UIColor colorWithWhite:1 alpha:0.5];
        _pagingView.titleFont = [UIFont systemFontOfSize:20];
        _pagingView.titleSelectedColor = [UIColor whiteColor];
//        _pagingView.indicators
        _pagingView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    }
    return _pagingView;
}

- (RWPagingListContainerView *)containerView {
    if(!_containerView) {
        _containerView = [[RWPagingListContainerView alloc] initWithType:RWPagingListContainerType_ScrollView delegate:self];
    }
    return _containerView;
}

- (NSArray *)listTitles {
    if(!_listTitles) {
        _listTitles = @[@"All Orders", @"Disbursing", @"To be Repaid", @"Denied", @"Pending", @"Repaid", @"Overdue"];
    }
    return _listTitles;
}

- (void)setupUI {
    [super setupUI];
    self.title = @"My orders";
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT);
    }];
    [self.view layoutIfNeeded];
    
    [self.view addSubview:self.pagingView];
    [self.pagingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pagingView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.pagingView.selectedIndex == 0) {
        [self openGesturePop];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self openGesturePop];
}

// MARK: - RWPagingViewDelegate
- (void)categoryView:(RWPagingBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

// MARK: - RWPagingListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(RWPagingListContainerView *)listContainerView {
    return self.listTitles.count;
}



- (id<RWPagingListContentViewDelegate>)listContainerView:(RWPagingListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return [[RWOrderListController alloc] initWithOrderType:index];
}

@end

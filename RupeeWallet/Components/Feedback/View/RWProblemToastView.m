//
//  RWProblemToastView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWProblemToastView.h"
#import "RWProductModel.h"
#import "RWProblemToastItemCell.h"

@interface RWProblemToastView() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) UITableView *listTableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, copy) void(^didSelectedAction)(NSInteger selectedIndex);
@end

@implementation RWProblemToastView

+ (void)showToastWithTitle:(NSString *)title list:(NSArray *)list didSelectedAction:(void (^)(NSInteger))didSelectedAction {
    RWProblemToastView *toastView = [[RWProblemToastView alloc] init];
    toastView.dataList = list;
    toastView.titleLabel.text = title;
    toastView.didSelectedAction = didSelectedAction;
    [toastView show];
}

- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (UITableView *)listTableView {
    if(!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        [_listTableView registerClass:[RWProblemToastItemCell class] forCellReuseIdentifier:@"ItemCell"];
    }
    return _listTableView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:self.container];
        [self.container addSubview:self.titleLabel];
        [self.container addSubview:self.listTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 280 + TOP_SAFE_AREA));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}

- (void)show {
    [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.container.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.container.frame));
    }];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.container.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// MARK: - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWProblemToastItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataList enumerateObjectsUsingBlock:^(RWSelectionableModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == indexPath.row) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    
    [self.listTableView reloadData];
    
    if(self.didSelectedAction) {
        self.didSelectedAction(indexPath.row);
    }
    [self dismiss];
}

@end

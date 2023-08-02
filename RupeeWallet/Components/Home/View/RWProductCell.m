//
//  RWProductCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWProductCell.h"

@interface RWProductCell()
@property(nonatomic, strong) UIImageView *logoView;
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, weak) UIImageView *quotaIconView;
@property(nonatomic, weak) UILabel *quotaLabel;
@property(nonatomic, weak) UILabel *amountIndicatorLabel;
@property(nonatomic, strong) UIButton *loanBtn;
@property(nonatomic, weak) UILabel *feeRatioLabel;
@property(nonatomic, weak) UIImageView *feeRatioIconView;
@property(nonatomic, weak) UILabel *loanDateLabel;
@property(nonatomic, weak) UIImageView *bottomLineView;
@end

@implementation RWProductCell

- (void)setProduct:(RWProductModel *)product {
    _product = product;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:product.logo]];
    self.productNameLabel.text = product.loanName;
    self.quotaLabel.text = [NSString stringWithFormat:@"INR %@", product.loanAmount];
    self.feeRatioLabel.text = [NSString stringWithFormat:@"Fee %@ / day", product.loanRate];
    self.loanDateLabel.text = [NSString stringWithFormat:@"%@ days", product.loanDate];
    [self layoutIfNeeded];
}

-(UIImageView *)logoView {
    if(!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.contentMode = UIViewContentModeScaleAspectFill;
        _logoView.layer.cornerRadius = 10;
        _logoView.layer.masksToBounds = YES;
    }
    
    return _logoView;
}

- (UILabel *)productNameLabel {
    if(!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _productNameLabel.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
    }
    return _productNameLabel;
}

- (UIButton *)loanBtn {
    if(!_loanBtn) {
        _loanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loanBtn setTitle:@"Loan now" forState:UIControlStateNormal];
        [_loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loanBtn.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
        _loanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _loanBtn.layer.cornerRadius = 10;
        _loanBtn.enabled = NO;
    }
    
    return _loanBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.logoView];
        [self.contentView addSubview:self.productNameLabel];
        
        UIImageView *quotaIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quota_icon"]];
        quotaIconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:quotaIconView];
        self.quotaIconView = quotaIconView;
        
        UILabel *quotaLabel = [self createLabelWithColor:THEME_COLOR font:[UIFont boldSystemFontOfSize:18]];
        [self.contentView addSubview:quotaLabel];
        self.quotaLabel = quotaLabel;
        
        UILabel *indicatorLabel = [self createLabelWithColor:THEME_TEXT_COLOR font:[UIFont systemFontOfSize:14]];
        indicatorLabel.text = @"Loan amount";
        [self.contentView addSubview:indicatorLabel];
        self.amountIndicatorLabel = indicatorLabel;
        
        [self.contentView addSubview:self.loanBtn];
        
        UIImageView *feeRatioIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fee_ratio_icon"]];
        feeRatioIconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:feeRatioIconView];
        self.feeRatioIconView = feeRatioIconView;
        
        UILabel *feeRatioLabel = [self createLabelWithColor:THEME_COLOR font:[UIFont systemFontOfSize:18]];
        [self.contentView addSubview:feeRatioLabel];
        self.feeRatioLabel = feeRatioLabel;
        
        UILabel *loanDateLabel = [self createLabelWithColor:THEME_TEXT_COLOR font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:loanDateLabel];
        self.loanDateLabel = loanDateLabel;
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotted_line"]];
        bottomLine.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:bottomLine];
        self.bottomLineView = bottomLine;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.quotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.quotaIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 18));
        make.centerY.mas_equalTo(self.logoView);
        make.right.mas_equalTo(self.quotaLabel.mas_left).offset(-5);
    }];
    
    [self.loanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(14);
        make.left.mas_equalTo(self.logoView);
        make.size.mas_equalTo(CGSizeMake(116, 42));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loanBtn.mas_bottom).offset(25);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [self.amountIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quotaLabel.mas_bottom);
            make.right.mas_equalTo(self.quotaLabel);
    }];
    
    [self.feeRatioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountIndicatorLabel.mas_bottom).offset(14);
        make.right.mas_equalTo(self.amountIndicatorLabel);
    }];
    
    [self.feeRatioIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.feeRatioLabel);
        make.right.mas_equalTo(self.feeRatioLabel.mas_left).offset(-5);
    }];
    
    [self.loanDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.feeRatioLabel.mas_bottom);
        make.right.mas_equalTo(self.feeRatioLabel);
    }];
}

// MARK: - Private method
- (UILabel *)createLabelWithColor:(NSString *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:color];
    label.font = font;
    return label;
}
@end

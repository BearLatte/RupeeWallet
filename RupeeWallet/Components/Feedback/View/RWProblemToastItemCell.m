//
//  RWProblemToastItemCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWProblemToastItemCell.h"

@interface RWProblemToastItemCell()
@property(nonatomic, strong) UIImageView *logoView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *checkBoxIcon;
@end

@implementation RWProblemToastItemCell
- (UIImageView *)logoView {
    if(!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.layer.cornerRadius = 10;
        _logoView.layer.masksToBounds = YES;
        _logoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _logoView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    }
    return _titleLabel;
}

- (UIButton *)checkBoxIcon {
    if(!_checkBoxIcon) {
        _checkBoxIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxIcon setImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
        [_checkBoxIcon setImage:[UIImage imageNamed:@"check_box_fill"] forState:UIControlStateSelected];
    }
    return _checkBoxIcon;
}


- (void)setModel:(RWSelectionableModel *)model {
    _model = model;
    if(model.logo) {
        self.logoView.hidden = NO;
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    } else {
        self.logoView.hidden = YES;
    }
    self.titleLabel.text = model.title;
    self.checkBoxIcon.selected = model.isSelected;
    [self layoutIfNeeded];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.logoView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.checkBoxIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.logoView.isHidden) {
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(28, 28));
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    
    if(!self.logoView.isHidden) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.logoView.mas_right).offset(10);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
        }];
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
        }];
    }
    
    [self.checkBoxIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
}

@end

//
//  RWFeedbackItemCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWFeedbackItemCell.h"

@interface RWFeedbackItemCell()
@property(nonatomic, weak) UIView *indicatorView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *dateLabel;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, weak) UIImageView *dashedView;
@end

@implementation RWFeedbackItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *indicator = [[UIView alloc] init];
        indicator.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
        indicator.layer.cornerRadius = 1;
        [self.contentView addSubview:indicator];
        self.indicatorView = indicator;
        
        UILabel *title = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
        [self.contentView addSubview:title];
        self.titleLabel = title;
        
        UILabel *dateLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:14] textColor:TAB_BAR_NORMAL_FOREGROUND_COLOR];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UILabel *content = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:14] textColor:INDICATOR_TEXT_COLOR];
        [self.contentView addSubview:content];
        self.contentLabel = content;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotted_line"]];
        [self.contentView addSubview:imgView];
        self.dashedView = imgView;
    }
    return self;
}

- (void)setFeedback:(RWFeedbackModel *)feedback {
    _feedback = feedback;
    self.indicatorView.hidden = feedback.replyNum < 1;
    self.titleLabel.text = feedback.feedBackType;
    self.dateLabel.text = feedback.createTime;
    self.contentLabel.text = feedback.feedBackContent;
    [self layoutIfNeeded];
}

- (void)setHiddedDashedView:(BOOL)hiddedDashedView {
    _hiddedDashedView = hiddedDashedView;
    self.dashedView.hidden = hiddedDashedView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indicatorView.mas_right).offset(6);
        make.centerY.mas_equalTo(self.indicatorView);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.indicatorView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indicatorView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.indicatorView);
        make.right.mas_equalTo(self.dateLabel);
        make.height.mas_equalTo(17);
    }];
    
    [self.dashedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(16);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
}
@end

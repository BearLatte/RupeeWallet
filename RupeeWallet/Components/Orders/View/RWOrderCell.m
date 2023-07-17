//
//  RWOrderCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/17.
//

#import "RWOrderCell.h"
#import "RWAttributedLabel.h"

@interface RWOrderCell()
@property(nonatomic, weak) UIImageView *logoView;
@property(nonatomic, weak) UILabel *loanNameLabel;
@property(nonatomic, weak) UILabel *indicatorLabel;
@property(nonatomic, weak) RWAttributedLabel *loanAmountLabel;
@property(nonatomic, weak) RWAttributedLabel *applyDateLabel;
@property(nonatomic, weak) RWAttributedLabel *orderNumberLabel;
@property(nonatomic, weak) UIImageView *dashedView;
@end

@implementation RWOrderCell

- (void)setOrder:(RWOrderModel *)order {
    _order = order;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:order.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    self.loanNameLabel.text = order.loanName;
    
    switch (order.status) {
        case 0:
            self.indicatorLabel.text = @"Pending";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#0096F0"];
            break;
        case 1:
            self.indicatorLabel.text = @"Disbursing";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#3DDA6E"];
            break;
        case 2:
            self.indicatorLabel.text = @"To be Repaid";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#F8A822"];
            break;
        case 5:
            self.indicatorLabel.text = @"Overdue";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#FF7373"];
            break;
        case 6:
            self.indicatorLabel.text = @"Disbursing Fail";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#E663D5"];
            break;
        case 7:
            self.indicatorLabel.text = @"Denied";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#E65FD4"];
            break;
        case 8:
        case 9:
            self.indicatorLabel.text = @"Repaid";
            self.indicatorLabel.textColor = [UIColor colorWithHexString:INDICATOR_TEXT_COLOR];
            break;
        default:
            break;
    }
    
    self.loanAmountLabel.key = [NSString stringWithFormat:@"₹ %@ ", order.loanAmountStr];
    self.applyDateLabel.value = order.applyDateStr;
    self.orderNumberLabel.value = order.loanOrderNo;
    [self layoutSubviews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *logo = [[UIImageView alloc] init];
        logo.contentMode = UIViewContentModeScaleAspectFill;
        logo.layer.cornerRadius = 10;
        logo.layer.masksToBounds = YES;
        [self.contentView addSubview:logo];
        self.logoView = logo;
        
        UILabel *loanName = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
        [self.contentView addSubview:loanName];
        self.loanNameLabel = loanName;
        
        UILabel *indicator = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20] textColor:@"#0096F0"];
        [self.contentView addSubview:indicator];
        self.indicatorLabel = indicator;
        
        RWAttributedLabel *loanAmount = [RWAttributedLabel attributedLabelWithKey:nil keyColor:THEME_COLOR keyFont:[UIFont systemFontOfSize:30 weight:UIFontWeightMedium] value:@"Loan amount" valueColor:INDICATOR_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
        loanAmount.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:loanAmount];
        self.loanAmountLabel = loanAmount;
        
        RWAttributedLabel *dateLabel = [RWAttributedLabel attributedLabelWithKey:@"Apply date : " keyColor:INDICATOR_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:dateLabel];
        self.applyDateLabel = dateLabel;
        
        RWAttributedLabel *numberLabel = [RWAttributedLabel attributedLabelWithKey:@"Order Number : " keyColor:INDICATOR_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:numberLabel];
        self.orderNumberLabel = numberLabel;
        
        UIImageView *dashed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotted_line"]];
        [self.contentView addSubview:dashed];
        self.dashedView = dashed;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.loanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.logoView);
    }];
    
    [self.loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(4);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    
    [self.applyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loanAmountLabel.mas_bottom).offset(6);
        make.left.mas_equalTo(self.logoView);
        make.height.mas_equalTo(22);
    }];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.applyDateLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.logoView);
        make.height.mas_equalTo(self.applyDateLabel);
    }];
    
    [self.dashedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderNumberLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
}
@end

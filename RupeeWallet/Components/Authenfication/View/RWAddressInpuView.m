//
//  RWAddressInpuView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import "RWAddressInpuView.h"

@interface RWAddressInpuView()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *contentLabel;
@property(nonatomic, copy) NSString *placeholder;
@end

@implementation RWAddressInpuView
+ (instancetype)addressViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    RWAddressInpuView *addressView = [[RWAddressInpuView alloc] init];
    addressView.titleLabel.text = title;
    addressView.placeholder = placeholder;
    return addressView;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.contentLabel.text = placeholder;
    [self chengeContentLabelColor:0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UILabel *title = [[RWGlobal sharedGlobal] createLabelWithText:@"Gender" font:[UIFont systemFontOfSize:16] textColor:FORM_TITLE_TEXT_COLOR];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        self.titleLabel = title;
        
        UILabel *contentLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:NORMAL_BORDER_COLOR];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        contentLabel.layer.cornerRadius = 14;
        contentLabel.layer.masksToBounds = YES;
        contentLabel.layer.borderWidth = 1;
        contentLabel.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    
    return self;
}

- (void)chengeContentLabelColor:(NSInteger)type {
    if(type == 0) {
        self.contentLabel.textColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
    } else {
        self.contentLabel.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.equalTo(@0);
        make.height.equalTo(@26);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.greaterThanOrEqualTo(@44);
        make.bottom.equalTo(self).priority(MASLayoutPriorityDefaultHigh);
    }];
}
@end

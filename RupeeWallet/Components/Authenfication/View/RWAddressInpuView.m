//
//  RWAddressInpuView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import "RWAddressInpuView.h"
#import "UITextView+Extension.h"

@interface RWAddressInpuView()<UITextViewDelegate>
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UITextView *contentTextView;
@end

@implementation RWAddressInpuView
+ (instancetype)addressViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    RWAddressInpuView *addressView = [[RWAddressInpuView alloc] init];
    addressView.titleLabel.text = title;
    [addressView.contentTextView setPlaceholderWithText:placeholder placeholderColor:NORMAL_BORDER_COLOR];
    return addressView;
}



- (void)setAddress:(NSString *)address {
    _address = address;
    self.contentTextView.text = address;
    [self layoutIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UILabel *title = [[RWGlobal sharedGlobal] createLabelWithText:@"Gender" font:[UIFont systemFontOfSize:16] textColor:FORM_TITLE_TEXT_COLOR];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        self.titleLabel = title;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:16];
        textView.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        textView.layer.cornerRadius = 14;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        textView.scrollEnabled = NO;
        textView.textAlignment = NSTextAlignmentCenter;
        textView.backgroundColor = [UIColor clearColor];
        textView.delegate = self;
        [self addSubview:textView];
        self.contentTextView = textView;
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.equalTo(@0);
        make.height.equalTo(@26);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.greaterThanOrEqualTo(@44);
        make.bottom.equalTo(self).priority(MASLayoutPriorityDefaultHigh);
    }];
}

// MARK: - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [RWADJTrackTool trackingWithPoint:@"rq7qit"];
}

- (void)textViewDidChange:(UITextView *)textView {
    _address = textView.text;
}
@end

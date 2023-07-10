//
//  RWFormInputView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import "RWFormInputView.h"

@interface RWFormInputView()
@property(nonatomic, assign) RWFormInputViewType inputType;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UITextField *contentInputField;
@property(nonatomic, weak) UIImageView *rightIconView;
@end

@implementation RWFormInputView
+ (instancetype)inputViewWithInputType:(RWFormInputViewType)inputType title:(NSString *)title placeholder:(NSString *)placeholder {
    RWFormInputView *inputView = [[RWFormInputView alloc] init];
    inputView.inputType = inputType;
    inputView.titleLabel.text = title;
    inputView.contentInputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:NORMAL_BORDER_COLOR]}];
    switch (inputType) {
        case RWFormInputViewTypeNormal:
            inputView.contentInputField.rightViewMode = UITextFieldViewModeNever;
            break;
        case RWFormInputViewTypeDate:
            inputView.contentInputField.rightViewMode = UITextFieldViewModeAlways;
            inputView.rightIconView.image = [UIImage imageNamed:@"calenda_icon"];
            break;
        case RWFormInputViewTypeList:
            inputView.contentInputField.rightViewMode = UITextFieldViewModeAlways;
            inputView.rightIconView.image = [UIImage imageNamed:@"down_arrow"];
            break;
    }
    return inputView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.textColor = [UIColor colorWithHexString:FORM_TITLE_TEXT_COLOR];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLb];
        self.titleLabel = titleLb;
        
        UITextField *field = [[UITextField alloc] init];
        field.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        field.font = [UIFont systemFontOfSize:16];
        field.borderStyle = UITextBorderStyleNone;
        field.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        field.layer.borderWidth = 1;
        field.layer.cornerRadius = 14;
        field.layer.masksToBounds = YES;
        field.textAlignment = NSTextAlignmentCenter;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        UIImageView *rightIconView = [[UIImageView alloc] initWithFrame:rightView.bounds];
        rightIconView.contentMode = UIViewContentModeCenter;
        [rightView addSubview:rightIconView];
        self.rightIconView = rightIconView;
        field.rightView = rightView;
        [self addSubview:field];
        self.contentInputField = field;
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
    
    [self.contentInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@44);
        make.bottom.equalTo(@0).priority(MASLayoutPriorityDefaultHigh);
    }];
}

@end

//
//  RWLoginContentView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import "RWLoginContentView.h"
#import <CRBoxInputView/CRBoxInputView.h>

@interface RWLoginContentView()<UITextViewDelegate>
@property(nonatomic, weak) UIView *_Nullable topView;
@property(nonatomic, weak) UILabel *_Nullable titleLabel;
@property(nonatomic, weak) UILabel *_Nullable typeDescriptionLabel;
@property(nonatomic, weak) UILabel *_Nullable detailDescriptionLabel;
@property(nonatomic, weak) UILabel *_Nullable phoneNumberLabel;
@property(nonatomic, weak) UILabel *_Nullable typeIndicatorLabel;
@property(nonatomic, weak) UIButton *_Nullable actionButton;
@property(nonatomic, weak) UIView *_Nullable bottomView;
@property(nonatomic, weak) UIButton *_Nullable checkBoxButton;
@property(nonatomic, strong) UITextView *_Nullable privacyTextView;
@property(nonatomic, weak) UIView *_Nullable contentInputView;

@property(nonatomic, strong) UITextField *_Nullable phoneInputField;
@property(nonatomic, strong) CRBoxInputView *_Nullable smsCodeView;
@end

@implementation RWLoginContentView

- (BOOL)isCheckedPrivacy {
    return self.checkBoxButton.isSelected;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    self.phoneNumberLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"+91%@", phoneNumber] attributes:@{
        NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]
    }];
}

- (NSString *)currentPhoneNumber {
    return self.phoneInputField.text;
}

- (void)setContentMode:(RWContentViewMode)contentMode {
    _contentMode = contentMode;
    switch (contentMode) {
        case RWContentViewModeInputPhoneNumber:
            self.typeDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Mobile phone number" attributes:@{
                NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]
            }];;
            self.detailDescriptionLabel.text = @"Please enter your mobile phone\nnumber so we can send you a\nverification code.";
            self.typeIndicatorLabel.text = @"Mobile number";
            [self.actionButton setTitle:@"Next" forState:UIControlStateNormal];
            [self.actionButton setTitle:@"Next" forState:UIControlStateDisabled];
            self.bottomView.hidden = YES;
            self.phoneNumberLabel.hidden = YES;
            self.phoneInputField.hidden = NO;
            self.smsCodeView.hidden = YES;
            break;
            
        case RWContentViewModeInputOPT:
            self.typeDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"OTP confirm" attributes:@{
                NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]
            }];;
            self.detailDescriptionLabel.text = @"Enter the 4-digit code we just\ntexted to your phone number.";
            self.typeIndicatorLabel.text = @"One-time-Password";
            [self.actionButton setTitle:@"Login now" forState:UIControlStateNormal];
            self.bottomView.hidden = NO;
            self.phoneNumberLabel.hidden = NO;
            self.phoneInputField.hidden = YES;
            self.smsCodeView.hidden = NO;
            break;
    }
}

- (UITextField *)phoneInputField {
    if(!_phoneInputField) {
        _phoneInputField = [[UITextField alloc] init];
        _phoneInputField.font = [UIFont systemFontOfSize: 20];
        _phoneInputField.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        
        _phoneInputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"Mobile number" attributes:@{
            NSForegroundColorAttributeName : [UIColor colorWithHexString:NORMAL_BORDER_COLOR]
        }];;
        _phoneInputField.layer.cornerRadius = 25;
        _phoneInputField.layer.masksToBounds = YES;
        _phoneInputField.layer.borderColor = [UIColor colorWithHexString: NORMAL_BORDER_COLOR].CGColor;
        _phoneInputField.layer.borderWidth = 1;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _phoneInputField.leftView = leftView;
        _phoneInputField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_icon"]];
        iconView.frame = CGRectMake(20, 13, 24, 24);
        [leftView addSubview:iconView];
        
        
        UILabel *areaCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame), 0, CGRectGetWidth(leftView.frame) - CGRectGetMaxX(iconView.frame) - 10, 50)];
        areaCodeLabel.text = @"+91";
        areaCodeLabel.font = [UIFont systemFontOfSize:20];
        areaCodeLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        areaCodeLabel.textAlignment = NSTextAlignmentRight;
        [leftView addSubview:areaCodeLabel];
        
        _phoneInputField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneInputField;
}

- (CRBoxInputView *)smsCodeView {
    if(!_smsCodeView) {
        CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
        cellProperty.cellCursorColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
        cellProperty.cellCursorWidth = 2;
        cellProperty.cellCursorHeight = 30;
        cellProperty.cornerRadius = 20;
        cellProperty.borderWidth = 1;
        cellProperty.cellFont = [UIFont systemFontOfSize:20];
        cellProperty.cellBorderColorNormal = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
        cellProperty.cellBorderColorSelected = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
        cellProperty.cellBorderColorFilled =  [UIColor colorWithHexString:THEME_COLOR];
        cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
        cellProperty.cellTextColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        

        _smsCodeView = [[CRBoxInputView alloc] initWithCodeLength:4];
        _smsCodeView.boxFlowLayout.itemSize = CGSizeMake(78, 45);
        _smsCodeView.customCellProperty = cellProperty;
        
        _smsCodeView.textEditStatusChangeblock = ^(CRTextEditStatus state) {
            if(state == CRTextEditStatus_BeginEdit) {
                [RWADJTrackTool trackingWithPoint:@"eaodys"];
            }
        };
    }
    return _smsCodeView;
}


- (UITextView *)privacyTextView {
    if(!_privacyTextView) {
        NSString *str = @"By continuing you agree our Terms & Conditions and Privacy Policy.";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 5;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraph}];
        [attStr addAttribute:NSLinkAttributeName value:@"labelAction://terms&conditions" range:[str rangeOfString:@"Terms & Conditions"]];
        [attStr addAttribute:NSLinkAttributeName value:@"labelAction://privacyPolicy" range:[str rangeOfString:@"Privacy Policy"]];
        _privacyTextView = [[UITextView alloc] init];
        _privacyTextView.attributedText = attStr;
        _privacyTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:THEME_COLOR]};
        _privacyTextView.font = [UIFont systemFontOfSize:14];
        _privacyTextView.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        _privacyTextView.editable = NO;
        _privacyTextView.delegate = self;
        _privacyTextView.backgroundColor = [UIColor clearColor];
        _privacyTextView.scrollEnabled = NO;
    }
    return _privacyTextView;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *topView = [UIView new];
        [self addSubview:topView];
        self.topView = topView;
        
        UILabel *titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Login in" font:[UIFont boldSystemFontOfSize:28] textColor:@"#ffffff"];
        [self.topView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *typeDescLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont boldSystemFontOfSize:20] textColor:@"#ffffff"];
        [self.topView addSubview:typeDescLabel];
        self.typeDescriptionLabel = typeDescLabel;
        
        UILabel *detailDesc = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20] textColor:@"#ffffff"];
        detailDesc.numberOfLines = 0;
        [self.topView addSubview:detailDesc];
        self.detailDescriptionLabel = detailDesc;
        
        UILabel *phoneNumberLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20] textColor:@"#0C211F"];
        [self.topView addSubview:phoneNumberLabel];
        self.phoneNumberLabel = phoneNumberLabel;
        
        UILabel *indicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20] textColor:THEME_TEXT_COLOR];
        [self addSubview:indicatorLabel];
        self.typeIndicatorLabel = indicatorLabel;
        
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentInputView = contentView;
        
        [self.contentInputView addSubview:self.phoneInputField];
        [self.phoneInputField addTarget:self action:@selector(phoneInputFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self.contentInputView addSubview:self.smsCodeView];
        
        __weak RWLoginContentView *weakSelf = self;
        self.smsCodeView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
            if (isFinished) {
                weakSelf.actionButton.enabled = YES;
#ifdef DEBUG
                self->_smsCode = @"821350";
#else
                self->_smsCode = text;
#endif
                
            }
        };
        
       
        UIButton *btn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:nil cornerRadius:30];
        btn.enabled = NO;
        [self addSubview:btn];
        self.actionButton = btn;
        [self.actionButton addTarget:self action:@selector(actionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomView = [UIView new];
        bottomView.hidden = YES;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
        UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBox setImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"check_box_fill"] forState:UIControlStateSelected];
        checkBox.selected = YES;
        [self.bottomView addSubview:checkBox];
        self.checkBoxButton = checkBox;
        
        [self.bottomView addSubview:self.privacyTextView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.topView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA + 50);
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.typeDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(28);
    }];
    
    [self.detailDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeDescriptionLabel.mas_bottom).offset(18);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-40);
    }];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailDescriptionLabel.mas_bottom);
        make.left.mas_equalTo(self.detailDescriptionLabel);
    }];
    
    [self.typeIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(18);
        make.left.mas_equalTo(40);
    }];
    
    [self.contentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeIndicatorLabel.mas_bottom).offset(18);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.smsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentInputView.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA));
        make.height.mas_equalTo(55);
    }];
    
    [self.checkBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [self.privacyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.checkBoxButton.mas_right).offset(10);
    }];
}

- (void)phoneInputFieldTextChanged:(UITextField *)field {
    if(self.contentMode == RWContentViewModeInputPhoneNumber) {
        NSString *mobildNumber = field.text;
        if (mobildNumber.length > 9) {
            self.phoneInputField.text = [mobildNumber substringToIndex:10];
            self.phoneInputField.layer.borderColor = [UIColor colorWithHexString:THEME_COLOR].CGColor;
            self.actionButton.enabled = YES;
            [self endEditing:YES];
        } else {
            self.actionButton.enabled = NO;
            self.phoneInputField.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        }
        
        self.phoneNumber = field.text;
    }
}

- (void)actionBtnClicked {
    if([self.delegate respondsToSelector:@selector(contentViewActionButtonDidTapped:)]) {
        [self.delegate contentViewActionButtonDidTapped:self];
    }
}

- (void)loadCodeInputView {
    [self.smsCodeView clearAll];
    [self.smsCodeView loadAndPrepareView];
}

// MARK: - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if([URL.description isEqual:@"labelAction://terms&conditions"]) {
        if([self.delegate respondsToSelector:@selector(contentViewTermsConditionAction:)]) {
            [self.delegate contentViewTermsConditionAction:self];
        }
    } else if([URL.description isEqual:@"labelAction://privacyPolicy"]) {
        if([self.delegate respondsToSelector:@selector(contentViewPrivacyAction:)]) {
            [self.delegate contentViewPrivacyAction:self];
        }
    }
    return NO;
}

@end

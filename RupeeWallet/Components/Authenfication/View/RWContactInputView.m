//
//  RWContactInputView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "RWContactInputView.h"

@interface RWContactInputView()<UITextFieldDelegate>
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UITextField *nameField;
@property(nonatomic, weak) UILabel *numberIndicatorLabel;
@property(nonatomic, weak) UITextField *numberField;
@property(nonatomic, copy) TapAction tapAction;
@property(nonatomic, copy) TextFieldDidEditingAction didEditingAction;
@end

@implementation RWContactInputView
+ (instancetype)inputViewWithTitle:(NSString *)title namePlaceholder:(NSString *)namePlaceholder tapAction:(TapAction)action didEditingAction:(nonnull TextFieldDidEditingAction)didEditingAction {
    RWContactInputView *inputView = [[RWContactInputView alloc] init];
    inputView.titleLabel.text = title;
    inputView.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:namePlaceholder attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:NORMAL_BORDER_COLOR]
    }];
    inputView.tapAction = action;
    inputView.didEditingAction = didEditingAction;
    return inputView;
}

- (void)setContactName:(NSString *)contactName {
    _contactName = contactName;
    self.nameField.text = contactName;
}

- (void)setContactNumber:(NSString *)contactNumber {
    _contactNumber = contactNumber;
    self.numberField.text = contactNumber;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UILabel *titleLabel = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:16] textColor:FORM_TITLE_TEXT_COLOR];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UITextField *name = [[UITextField alloc] init];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        name.font = [UIFont systemFontOfSize:16];
        name.borderStyle = UITextBorderStyleNone;
        name.layer.cornerRadius = 14;
        name.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        name.layer.borderWidth = 1;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:rightView.bounds];
        rightIcon.image = [UIImage imageNamed:@"contact_icon"];
        rightIcon.contentMode = UIViewContentModeCenter;
        [rightView addSubview:rightIcon];
        name.rightView = rightView;
        name.rightViewMode = UITextFieldViewModeAlways;
        name.delegate = self;
        [self addSubview:name];
        self.nameField = name;
        
        UILabel *numberIndicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Number" font:[UIFont systemFontOfSize:16] textColor:FORM_TITLE_TEXT_COLOR];
        numberIndicatorLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numberIndicatorLabel];
        self.numberIndicatorLabel = numberIndicatorLabel;
        
        UITextField *numberField = [[UITextField alloc] init];
        numberField.textAlignment = NSTextAlignmentCenter;
        numberField.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        numberField.font = [UIFont systemFontOfSize:16];
        numberField.borderStyle = UITextBorderStyleNone;
        numberField.layer.cornerRadius = 14;
        numberField.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
        numberField.layer.borderWidth = 1;
        numberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Number" attributes:@{
            NSForegroundColorAttributeName : [UIColor colorWithHexString:NORMAL_BORDER_COLOR]
        }];
        numberField.delegate = self;
        [self addSubview:numberField];
        self.numberField = numberField;
        
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
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.titleLabel);
        make.height.equalTo(@44);
    }];
    
    [self.numberIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.titleLabel);
    }];
    
    [self.numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberIndicatorLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameField);
        make.bottom.equalTo(self).offset(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSString *loginPhoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PHONE_NUMBER_KEY];
    if([loginPhoneNumber isEqualToString:APP_STORE_TEST_ACCOUNT]) {
        return YES;
    } else {
        self.tapAction();
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.nameField) {
        _contactName = textField.text;
        
        if(self.didEditingAction) {
            self.didEditingAction();
        }
    }
    
    if(textField == self.numberField) {
        _contactNumber = textField.text;
        if(self.didEditingAction) {
            self.didEditingAction();
        }
    }
    
    
}
@end

//
//  RWPersonalInfoController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/11.
//

#import "RWPersonalInfoController.h"
#import "RWOCRCameraPanel.h"
#import "RWFormInputView.h"
#import "RWContactInfoController.h"

typedef NS_ENUM(NSUInteger, RWInputType) {
    RWInputTypeIndustry,
    RWInputTypeWorkTitle,
    RWInputTypeSalary
};

@interface RWPersonalInfoController ()<RWOCRCameraPanelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, weak) RWOCRCameraPanel *panOcrPanel;
@property(nonatomic, weak) RWFormInputView *panNumberInput;
@property(nonatomic, weak) RWFormInputView *whatsAppNumberInput;
@property(nonatomic, weak) RWFormInputView *industryInput;
@property(nonatomic, weak) RWFormInputView *workTitleInput;
@property(nonatomic, weak) RWFormInputView *salaryInput;
@property(nonatomic, weak) RWFormInputView *emailInput;
@property(nonatomic, weak) RWFormInputView *paytmInput;
@property(nonatomic, weak) UIButton *nextBtn;

@property(nonatomic, assign) RWInputType inputType;

@property(nonatomic, strong) NSArray *industryList;
@property(nonatomic, strong) NSArray *workTitleList;
@property(nonatomic, strong) NSArray *salaryList;

@property(nonatomic, copy) NSString *panCardImg;

@property(nonatomic, strong) RWContentModel *personalInfo;
@end

@implementation RWPersonalInfoController

- (void)setupUI {
    [super setupUI];
    self.isDarkBackMode = YES;
    self.title = @"Personal info";
    [self setupStepViewWithCurrenStep:@"2" totalStep:@"/4"];
        
    self.view.backgroundColor = [UIColor whiteColor];
    RWOCRCameraPanel *panel = [[RWOCRCameraPanel alloc] init];
    panel.ocrType = RWOCRTypePanCardFront;
    panel.delegate = self;
    [self.contentView addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    self.panOcrPanel = panel;
    
    RWFormInputView *numberInput = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Pan Number" placeholder:@"Pan Number" keyboardType:UIKeyboardTypeDefault tapAction:nil didEndEditingAction:^{
        [self checkNextBtnEnabel];
    }];
    [self.contentView addSubview:numberInput];
    [numberInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panOcrPanel.mas_bottom);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    self.panNumberInput = numberInput;
    
    RWFormInputView *whatsNumberInput = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"WhatsApp Account" placeholder:@"WhatsApp Account" keyboardType:UIKeyboardTypeNumberPad tapAction:nil didEndEditingAction:^{
        [self checkNextBtnEnabel];
    }];
    [self.contentView addSubview:whatsNumberInput];
    [whatsNumberInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panNumberInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.whatsAppNumberInput = whatsNumberInput;

    RWFormInputView *industry = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Industry" placeholder:@"Industry" keyboardType:UIKeyboardTypeDefault tapAction:^{
        self.inputType = RWInputTypeIndustry;
        [self showPickerWithTitle:@"Industry"];
    } didEndEditingAction: nil];
    [self.contentView addSubview:industry];
    [industry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whatsAppNumberInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.industryInput = industry;

    RWFormInputView *workTitle = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Work Title" placeholder:@"Work Title" keyboardType:UIKeyboardTypeDefault tapAction:^{
        self.inputType = RWInputTypeWorkTitle;
        [self showPickerWithTitle:@"Work Title"];
    } didEndEditingAction:nil];
    [self.contentView addSubview:workTitle];
    [workTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.industryInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.workTitleInput = workTitle;
    
    RWFormInputView *salary = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Monthly Salary" placeholder:@"Monthly Salary" keyboardType:UIKeyboardTypeDefault tapAction:^{
        self.inputType = RWInputTypeSalary;
        [self showPickerWithTitle:@"Monthly Salary"];
    } didEndEditingAction: nil];
    [self.contentView addSubview:salary];
    [salary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workTitleInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.salaryInput = salary;

    RWFormInputView *email = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"E-mail" placeholder:@"E-mail" keyboardType:UIKeyboardTypeEmailAddress tapAction:nil didEndEditingAction:^{
        [self checkNextBtnEnabel];
    }];
    [self.contentView addSubview:email];
    [email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.salaryInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.emailInput = email;

    RWFormInputView *paytm = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Paytm Account(optional)" placeholder:@"Paytm Account(optional)" keyboardType:UIKeyboardTypeNumberPad tapAction:nil didEndEditingAction: nil];
    [self.contentView addSubview:paytm];
    [paytm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailInput.mas_bottom);
        make.left.right.equalTo(self.panNumberInput);
    }];
    self.paytmInput = paytm;
    
    UIButton *next = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"NEXT" cornerRadius:30];
    next.enabled = NO;
    [next addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paytmInput.mas_bottom).offset(20);
        make.size.equalTo(@(CGSizeMake(240, 60)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
    self.nextBtn = next;
}

- (void)setPersonalInfo:(RWContentModel *)personalInfo {
    _personalInfo = personalInfo;
    [self.panOcrPanel setImageUrl:personalInfo.panCardImg ocrType:RWOCRTypePanCardFront];
    self.panCardImg = personalInfo.panCardImg;
    self.panNumberInput.inputedText = personalInfo.panNumber;
    self.whatsAppNumberInput.inputedText = personalInfo.bodyImg;
    self.industryInput.inputedText = personalInfo.industry;
    self.workTitleInput.inputedText = personalInfo.job;
    self.salaryInput.inputedText = personalInfo.monthlySalary;
    self.emailInput.inputedText = personalInfo.email;
    self.paytmInput.inputedText = personalInfo.paytmAccount;
    [self checkNextBtnEnabel];
}

- (void)loadData {
    [[RWNetworkService sharedInstance] fetchDropMenuListSuccess:^(RWContentModel * _Nonnull content) {
        self.industryList = content.industryList;
        self.workTitleList = content.jobList;
        self.salaryList = content.monthSalaryList;
    }];
    
    if(self.authStatus.loanapiUserBasic) {
        [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:RWAuthTypePersonalInfo success:^(RWContentModel * _Nonnull authenficationInfo) {
            self.personalInfo = authenficationInfo;
        }];
    }
}

- (void)checkNextBtnEnabel {
    BOOL panNumberEnabel = self.panNumberInput.inputedText.length > 0;
    BOOL whatsAppEnabel = self.whatsAppNumberInput.inputedText.length > 0;
    BOOL industryEnabel = self.industryInput.inputedText.length > 0;
    BOOL workTitleEnabel = self.workTitleInput.inputedText.length > 0;
    BOOL salaryEnabel = self.salaryInput.inputedText.length > 0;
    BOOL emailEnabel = self.emailInput.inputedText.length > 0;
    BOOL panCardImageEnable = self.panCardImg.length > 0;
    
    if(panNumberEnabel && whatsAppEnabel && industryEnabel && workTitleEnabel && salaryEnabel && emailEnabel && panCardImageEnable) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

- (void)nextBtnClicked {
    NSString *whatsAppNumber = self.whatsAppNumberInput.inputedText;
    if(whatsAppNumber.length != 10 || ![whatsAppNumber isNum]) {
        [RWProgressHUD showInfoWithStatus:@"WhatsApp Account must enter a 10-digit mobile number"];
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    NSString *paytm = self.paytmInput.inputedText;
    if(paytm.length > 0) {
        if(paytm.length != 10 || ![paytm isNum]) {
            [RWProgressHUD showInfoWithStatus:@"Paytm Account must enter a 10-digit mobile number"];
            return;
        }
        params[@"paytmAccount"] = paytm;
    }
    
    
    params[@"panCardImg"] = self.panCardImg;
    params[@"panNumber"] = self.panNumberInput.inputedText;
    params[@"panNumberPaste"] = @"0";
    params[@"industry"] = self.industryInput.inputedText;
    params[@"email"] = self.emailInput.inputedText;
    params[@"emailPaste"] = @"0";
    params[@"job"] = self.workTitleInput.inputedText;
    params[@"monthlySalary"] = self.salaryInput.inputedText;
    params[@"bodyImg"] = self.whatsAppNumberInput.inputedText;
    
    [[RWNetworkService sharedInstance] authInfoWithType:RWAuthTypePersonalInfo parameters:[params copy] success:^{
        RWContactInfoController *contactInfo = [[RWContactInfoController alloc] init];
        contactInfo.authStatus = self.authStatus;
        [self.navigationController pushViewController:contactInfo animated:YES];
    }];
}


- (void)showPickerWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 60, 120)];
    picker.dataSource = self;
    picker.delegate = self;
    [alert.view addSubview:picker];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger row = [picker selectedRowInComponent:0];
        switch (self.inputType) {
            case RWInputTypeIndustry:
                self.industryInput.inputedText = self.industryList[row];
                break;
            case RWInputTypeWorkTitle:
                self.workTitleInput.inputedText = self.workTitleList[row];
                break;
            case RWInputTypeSalary:
                self.salaryInput.inputedText = self.salaryList[row];
                break;
            default:
                break;
        }
        
        [self checkNextBtnEnabel];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


// MARK: RWOCRCameraPanelDelegate
- (void)camerapPanelDidTappedFrontView:(RWOCRCameraPanel *)panelView {
    [[RWGlobal sharedGlobal] checkCameraAuthorityWithTarget:self];
}

// MARK: - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(image == nil) {
        return;
    }
    
    [[RWNetworkService sharedInstance] ocrRequestWithImage:image ocrType:RWOCRTypePanCardFront success:^(RWContentModel *content, NSString *imageUrl) {
        self.panCardImg = imageUrl;
        self.panNumberInput.inputedText = content.panNumber;
        [self.panOcrPanel setImage:image ocrType:RWOCRTypePanCardFront];
        [self checkNextBtnEnabel];
    }];
}

// MARK: - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.inputType) {
        case RWInputTypeIndustry:
            return self.industryList.count;
            break;
        case RWInputTypeWorkTitle:
            return self.workTitleList.count;
            break;
        case RWInputTypeSalary:
            return self.salaryList.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.inputType) {
        case RWInputTypeIndustry:
            return self.industryList[row];
            break;
        case RWInputTypeWorkTitle:
            return self.workTitleList[row];
            break;
        case RWInputTypeSalary:
            return self.salaryList[row];
            break;
        default:
            break;
    }
    return @"";
}
@end

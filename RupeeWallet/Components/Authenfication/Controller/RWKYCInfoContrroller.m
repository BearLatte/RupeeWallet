//
//  RWKYCInfoContrroller.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/8.
//

#import "RWKYCInfoContrroller.h"
#import "RWOCRCameraPanel.h"
#import "RWFormInputView.h"
#import "RWGenderSelectView.h"
#import "RWAddressInpuView.h"
#import "RWLocationManager.h"

@interface RWKYCInfoContrroller ()<RWOCRCameraPanelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, strong) RWOCRCameraPanel *_Nullable cameraPanel;
@property(nonatomic, weak) RWFormInputView *nameInput;
@property(nonatomic, weak) RWFormInputView *numberInput;
@property(nonatomic, weak) RWFormInputView *birthInput;
@property(nonatomic, weak) RWGenderSelectView *genderView;
@property(nonatomic, weak) RWAddressInpuView *addressView;
@property(nonatomic, weak) RWFormInputView *marriageView;
@property(nonatomic, weak) RWFormInputView *educationView;
@property(nonatomic, weak) UIButton *nextBtn;

@property(nonatomic, strong) NSArray *marriageStatusList;
@property(nonatomic, strong) NSArray *eduList;

@property(nonatomic, assign) BOOL isFront;
@property(nonatomic, assign) BOOL isMarriagePicker;

@property(nonatomic, copy) NSString *selectedMarriageState;
@property(nonatomic, copy) NSString *selectedEdu;
@end

@implementation RWKYCInfoContrroller
- (RWOCRCameraPanel *)cameraPanel {
    if(!_cameraPanel) {
        _cameraPanel = [[RWOCRCameraPanel alloc] init];
        _cameraPanel.ocrType = RWOCRTypeAadhaarCardFront;
        _cameraPanel.delegate = self;
    }
    return _cameraPanel;
}

- (void)setupUI {
    [super setupUI];
    [self setupStepViewWithCurrenStep:@"1" totalStep:@"/4"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"KYC info";
    self.modalStyle = RWModalStylePresent;
    self.isDarkBackMode = YES;
    
        
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_indicator_icon"]];
    indicatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:indicatorImageView];
    [indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
    }];
    
    [self.contentView addSubview:self.cameraPanel];
    [self.cameraPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicatorImageView.mas_bottom).offset(12);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    
    RWFormInputView *name = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Aadhaar Name" placeholder:@"Aadhaar Name" keyboardType:UIKeyboardTypeDefault tapAction:nil];
    [self.contentView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraPanel.mas_bottom).offset(20);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    self.nameInput = name;
    
    RWFormInputView *number = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Aadhaar Number" placeholder:@"Aadhaar Number" keyboardType:UIKeyboardTypeNumberPad tapAction:nil];
    [self.contentView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameInput.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.numberInput = number;
    
    RWFormInputView *birth = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeDate title:@"Date of Birth" placeholder:@"Date of Birth" keyboardType:UIKeyboardTypeDefault tapAction:^{
        [self showDatePicker];
    }];
    [self.contentView addSubview:birth];
    [birth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberInput.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.birthInput = birth;
    
    RWGenderSelectView *genderView = [RWGenderSelectView genderView];
    [self.contentView addSubview:genderView];
    [genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthInput.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.genderView = genderView;
    
    RWAddressInpuView *address = [RWAddressInpuView addressViewWithTitle:@"Detail Address" placeholder:@"Detail Address"];
    [self.contentView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.genderView.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.addressView = address;
    
    RWFormInputView *marriage = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeDate title:@"Marriage Status" placeholder:@"Marriage Status" keyboardType:UIKeyboardTypeDefault tapAction:^{
        self.isMarriagePicker = YES;
        [self showListPickerWithTitle:@"Marriage Status"];
    }];
    [self.contentView addSubview:marriage];
    [marriage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.marriageView = marriage;
    
    RWFormInputView *education = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeDate title:@"Education" placeholder:@"Education" keyboardType:UIKeyboardTypeDefault tapAction:^{
        self.isMarriagePicker = NO;
        [self showListPickerWithTitle:@"Education"];
    }];
    [self.contentView addSubview:education];
    [education mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marriageView.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.educationView = education;
    
    UIButton *next = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"NEXT" cornerRadius:30];
    next.enabled = NO;
    [next addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.educationView.mas_bottom).offset(20);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        make.height.equalTo(@60);
        make.bottom.equalTo(@0).priority(MASLayoutPriorityDefaultHigh);
    }];
    self.nextBtn = next;
}

- (void)checkNextButtonEnabel {
    BOOL isName = self.nameInput.inputedText.length > 0;
    BOOL isNumber = self.numberInput.inputedText.length > 0;
    BOOL isBirth = self.birthInput.inputedText.length > 0;
    BOOL isAddress = self.addressView.address.length > 0;
    BOOL isMarriageEnable = self.marriageView.inputedText.length > 0;
    BOOL isEduEnabel = self.educationView.inputedText.length > 0;
    
    
    if((isName && isNumber && isBirth && isAddress && isMarriageEnable && isEduEnabel && [self.cameraPanel isFrontViewHaveBackgroundImage] && [self.cameraPanel isBackViewHaveBackgroundImage])) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

- (void)showDatePicker {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Date of Birth" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 300)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"EN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [[NSDate alloc] init];
    if (@available(iOS 13.4, *)) {
        [datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    }
    [alert.view addSubview:datePicker];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.birthInput.inputedText = [datePicker.date date2stringWithFormatter:@"dd-MM-yyyy"];
    }]];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showListPickerWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH - 60, 80)];
    picker.dataSource = self;
    picker.delegate   = self;
    [alert.view addSubview:picker];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger row = [picker selectedRowInComponent:0];
        if(self.isMarriagePicker) {
            self.marriageView.inputedText = self.marriageStatusList[row];
        } else {
            self.educationView.inputedText = self.eduList[row];
        }
        [self checkNextButtonEnabel];
    }];
    [alert addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadData {
    // 获取下拉列表项目
    [[RWNetworkService sharedInstance] fetchDropMenuListSuccess:^(RWContentModel * _Nonnull content) {
        self.marriageStatusList = content.marryList;
        self.eduList = content.eduList;
    }];
    
    if(self.authStatus.loanapiUserIdentity) {
        [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:2 step:@"loanapiUserIdentity" success:^(RWContentModel * _Nonnull authenficationInfo) {
                    
        }];
    }
}

- (void)nextButtonAction {
    // check location permission
    if(![[RWLocationManager sharedManager] hasLocationService]) {
        [RWProgressHUD showInfoWithStatus:@"Please trun on the Location service."];
        return;
    }
    
    if(![[RWLocationManager sharedManager] hasLocationPermission]) {
        [[RWLocationManager sharedManager] requestLocationAuthorizaiton];
        return;
    }
}

// MARK: - RWOCRCameraPanelDelegate
- (void)camerapPanelDidTappedFrontView:(RWOCRCameraPanel *)panelView {
    self.isFront = YES;
    [[RWGlobal sharedGlobal] checkCameraAuthorityWithTarget:self];
}

- (void)camerapPanelDidTappedBackView:(RWOCRCameraPanel *)panelView {
    self.isFront = NO;
    [[RWGlobal sharedGlobal] checkCameraAuthorityWithTarget:self];
}

// MARK: - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(image == nil) {
        return;
    }
    
    [[RWNetworkService sharedInstance] ocrRequestWithImage:image ocrType:self.isFront ? RWOCRTypeAadhaarCardFront : RWOCRTypeAadhaarCardBack success:^(RWContentModel *content) {
        if (self.isFront) {
            self.nameInput.inputedText = content.aadharName;
            self.numberInput.inputedText = content.aadharNumber;
            self.genderView.gender = [content.gender.uppercaseString isEqual: @"MALE"] ? RWGenderMale : RWGenderFemale;
            self.birthInput.inputedText = content.dateOfBirth;
        } else {
            self.addressView.address = content.addressAll;
        }
        [self.cameraPanel setImage:image ocrType:self.isFront ? RWOCRTypeAadhaarCardFront : RWOCRTypeAadhaarCardBack];
        
        
    }];
}

// MARK: - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.isMarriagePicker) {
        return self.marriageStatusList.count;
    } else {
        return self.eduList.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.isMarriagePicker) {
        return self.marriageStatusList[row];
    } else {
        return self.eduList[row];
    }
}
@end

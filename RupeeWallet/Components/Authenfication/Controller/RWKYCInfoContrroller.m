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

@interface RWKYCInfoContrroller ()
@property(nonatomic, strong) RWOCRCameraPanel *_Nullable cameraPanel;
@property(nonatomic, weak) RWFormInputView *nameInput;
@property(nonatomic, weak) RWFormInputView *numberInput;
@property(nonatomic, weak) RWFormInputView *birthInput;
@property(nonatomic, weak) RWGenderSelectView *genderView;
@property(nonatomic, weak) RWAddressInpuView *addressView;
@property(nonatomic, weak) RWFormInputView *marriageView;
@property(nonatomic, weak) RWFormInputView *educationView;
@property(nonatomic, weak) UIButton *nextBtn;
@end

@implementation RWKYCInfoContrroller
- (RWOCRCameraPanel *)cameraPanel {
    if(!_cameraPanel) {
        _cameraPanel = [[RWOCRCameraPanel alloc] init];
        _cameraPanel.ocrType = RWOCRTypeAadhaarCardFront;
    }
    return _cameraPanel;
}

- (void)setupUI {
    [super setupUI];
    [self setupStepViewWithCurrenStep:@"1" totalStep:@"/4"];
    
    self.title = @"KYC info";
    self.modalStyle = RWModalStylePresent;
    self.isDarkBackMode = YES;
    
        
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_indicator_icon"]];
    indicatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:indicatorImageView];
    [indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(44);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
    }];
    
    [self.contentView addSubview:self.cameraPanel];
    [self.cameraPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicatorImageView.mas_bottom).offset(12);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    
    RWFormInputView *name = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Aadhaar Name" placeholder:@"Aadhaar Name"];
    [self.contentView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cameraPanel.mas_bottom).offset(20);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    self.nameInput = name;
    
    RWFormInputView *number = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Aadhaar Number" placeholder:@"Aadhaar Number"];
    [self.contentView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameInput.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.numberInput = number;
    
    RWFormInputView *birth = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeDate title:@"Date of Birth" placeholder:@"Date of Birth"];
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
    
    RWFormInputView *marriage = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Marriage Status" placeholder:@"Marriage Status"];
    [self.contentView addSubview:marriage];
    [marriage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.marriageView = marriage;
    
    RWFormInputView *education = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Education" placeholder:@"Education"];
    [self.contentView addSubview:education];
    [education mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marriageView.mas_bottom);
        make.left.right.equalTo(self.nameInput);
    }];
    self.educationView = education;
    
    UIButton *next = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"NEXT" cornerRadius:30];
    next.enabled = NO;
    [self.contentView addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.educationView.mas_bottom).offset(20);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        make.height.equalTo(@60);
        make.bottom.equalTo(@0).priority(MASLayoutPriorityDefaultHigh);
    }];
}
@end

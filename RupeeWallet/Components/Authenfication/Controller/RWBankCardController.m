//
//  RWBankCardController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "RWBankCardController.h"
#import "RWFormInputView.h"
#import "RWProductDetailController.h"
#import "RWContentModel.h"
#import "RWAlertView.h"

@interface RWBankCardController ()
@property(nonatomic, weak) RWFormInputView *bankNameInput;
@property(nonatomic, weak) RWFormInputView *bankNumberInput;
@property(nonatomic, weak) RWFormInputView *ifscCodeInput;
@property(nonatomic, weak) UIButton *submitBtn;
@property(nonatomic, strong) RWContentModel *bankCardInfo;
@end

@implementation RWBankCardController

- (void)setupUI {
    [super setupUI];
    self.title = @"Bank info";
    self.isDarkBackMode = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupStepViewWithCurrenStep:@"4" totalStep:@"/4"];
    
    RWFormInputView *bankName = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Bank Name" placeholder:@"Bank Name" keyboardType:UIKeyboardTypeDefault tapAction:nil didEndEditingAction:^{
        [self checkSubmitBtnEnable];
    }];
    [self.contentView addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    self.bankNameInput = bankName;
    
    RWFormInputView *number = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"Account Number" placeholder:@"Account Number" keyboardType:UIKeyboardTypeNumberPad tapAction:nil didEndEditingAction:^{
        [self checkSubmitBtnEnable];
    }];
    [self.contentView addSubview:number];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameInput.mas_bottom);
        make.left.right.equalTo(self.bankNameInput);
    }];
    self.bankNumberInput = number;
    
    RWFormInputView *ifsc = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeNormal title:@"IFSC Code" placeholder:@"IFSC Code" keyboardType:UIKeyboardTypeDefault tapAction:nil didEndEditingAction:^{
        [self checkSubmitBtnEnable];
    }];
    [self.contentView addSubview:ifsc];
    [ifsc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNumberInput.mas_bottom);
        make.left.right.equalTo(self.bankNameInput);
    }];
    self.ifscCodeInput = ifsc;
    
    UIButton *submit = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Submit" cornerRadius:30];
    submit.enabled = NO;
    [submit addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ifscCodeInput.mas_bottom).offset(50);
        make.size.equalTo(@(CGSizeMake(240, 60)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
    self.submitBtn = submit;
}

- (void)setBankCardInfo:(RWContentModel *)bankCardInfo {
    _bankCardInfo = bankCardInfo;
    self.bankNameInput.inputedText = bankCardInfo.bankName;
    self.bankNumberInput.inputedText = bankCardInfo.bankCardNo;
    self.ifscCodeInput.inputedText = bankCardInfo.ifscCode;
    [self checkSubmitBtnEnable];
}

- (void)loadData {
    if(self.authStatus.loanapiUserBankCard) {
        [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:RWAuthTypeBankCardInfo success:^(RWContentModel * _Nonnull authenficationInfo) {
            self.bankCardInfo = authenficationInfo;
        }];
    }
}

- (void)checkSubmitBtnEnable {
    BOOL bankNameEnable = self.bankNameInput.inputedText.length > 0;
    BOOL bankNumberEnable = self.bankNumberInput.inputedText.length > 0;
    BOOL ifscEnable = self.ifscCodeInput.inputedText.length > 0;
    
    if(bankNameEnable && bankNumberEnable && ifscEnable) {
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.enabled = NO;
    }
}

- (void)submitBtnClicked {
    [RWADJTrackTool trackingWithPoint:@"kp9d7h"];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"bankName"] = self.bankNameInput.inputedText;
    params[@"bankCardNo"] = self.bankNumberInput.inputedText;
    params[@"bankCardNoPaste"] = @"0";
    params[@"ifscCode"] = self.ifscCodeInput.inputedText;
    
    if(self.isModify) {
        [[RWNetworkService sharedInstance] changeBankCardWithParameters:params success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [RWAlertView showAlertViewWithStyle:RWAlertStyleTips title:@"TIPS" message:@"The information cannot be changed in step 1-3 after submission. Please fill in the correct information." confirmAction:^{
            [[RWNetworkService sharedInstance] authInfoWithType:RWAuthTypeBankCardInfo parameters:[params copy] success:^{
                [self fetchRecommendProduct];
            }];
        }];
    }
}

- (void)fetchRecommendProduct {
    [[RWNetworkService sharedInstance] fetchProductWithIsRecommend:YES success:^(RWContentModel *userInfo, NSArray * _Nullable products, RWProductDetailModel * _Nullable recommendProduct) {
        if(recommendProduct == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            RWProductDetailController *detail = [[RWProductDetailController alloc] init];
            detail.productId = recommendProduct.productId;
            detail.isRecommend = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
    } failure:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end

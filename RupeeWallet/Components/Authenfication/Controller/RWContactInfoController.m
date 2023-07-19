//
//  RWContactInfoController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import "RWContactInfoController.h"
#import "RWContactInputView.h"
#import "RWBankCardController.h"
#import "RWContentModel.h"

typedef NS_ENUM(NSUInteger, RWContactType) {
    RWContactTypeParents,
    RWContactTypeFamily,
    RWContactTypeColleague
};

@interface RWContactInfoController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, weak) RWContactInputView *parentsContactInputView;
@property(nonatomic, weak) RWContactInputView *familyContactInputView;
@property(nonatomic, weak) RWContactInputView *colleagueContactInputView;
@property(nonatomic, weak) UIButton *nextBtn;
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, assign) RWContactType contactType;
@property(nonatomic, strong) RWContentModel *_Nullable contactInfo;
@end

@implementation RWContactInfoController
- (void)setupUI {
    [super setupUI];
    self.title = @"Contact info";
    self.isDarkBackMode = YES;
    [self setupStepViewWithCurrenStep:@"3" totalStep:@"/4"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    RWContactInputView *parents = [RWContactInputView inputViewWithTitle:@"Parents Contact" namePlaceholder:@"Parents Contact" tapAction:^{
        if(self.contacts == nil) {
            self.contacts = [[RWGlobal sharedGlobal] getContactList];
        }
        self.contactType = RWContactTypeParents;
        [self showContactPicker];
    } didEditingAction:^{
        [self checkNextBtnEnable];
    }];
    [self.contentView addSubview:parents];
    [parents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
    }];
    self.parentsContactInputView = parents;
    
    RWContactInputView *family = [RWContactInputView inputViewWithTitle:@"Family Contact" namePlaceholder:@"Family Contact" tapAction:^{
        if(self.contacts == nil) {
            self.contacts = [[RWGlobal sharedGlobal] getContactList];
        }
        self.contactType = RWContactTypeFamily;
        [self showContactPicker];
    } didEditingAction:^{
        [self checkNextBtnEnable];
    }];
    [self.contentView addSubview:family];
    [family mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parentsContactInputView.mas_bottom);
        make.left.right.equalTo(self.parentsContactInputView);
    }];
    self.familyContactInputView = family;
    
    RWContactInputView *colleague = [RWContactInputView inputViewWithTitle:@"Colleague Contact" namePlaceholder:@"Colleague Contact" tapAction:^{
        if(self.contacts == nil) {
            self.contacts = [[RWGlobal sharedGlobal] getContactList];
        }
        self.contactType = RWContactTypeColleague;
        [self showContactPicker];
    } didEditingAction:^{
        [self checkNextBtnEnable];
    }];
    [self.contentView addSubview:colleague];
    [colleague mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.familyContactInputView.mas_bottom);
        make.left.right.equalTo(self.parentsContactInputView);
    }];
    self.colleagueContactInputView = colleague;
    
    UIButton *next = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"NEXT" cornerRadius:30];
    [next addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    next.enabled = NO;
    [self.contentView addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colleagueContactInputView.mas_bottom);
        make.size.equalTo(@(CGSizeMake(240, 60)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
    self.nextBtn = next;
}

- (void)setContactInfo:(RWContentModel *)contactInfo {
    _contactInfo = contactInfo;
    self.parentsContactInputView.contactName = contactInfo.brotherOrSisterName;
    self.parentsContactInputView.contactNumber = contactInfo.brotherOrSisterNumber;
    self.familyContactInputView.contactName  = contactInfo.familyName;
    self.familyContactInputView.contactNumber = contactInfo.familyNumber;
    self.colleagueContactInputView.contactName = contactInfo.colleagueName;
    self.colleagueContactInputView.contactNumber = contactInfo.colleagueNumber;
    [self checkNextBtnEnable];
}

- (void)showContactPicker {
    if(self.contacts == nil) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Contacts" message:@"\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 60, 120)];
    picker.dataSource = self;
    picker.delegate = self;
    [alert.view addSubview:picker];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger row = [picker selectedRowInComponent:0];
        NSDictionary *contact = self.contacts[row];
        switch (self.contactType) {
            case RWContactTypeParents:
                self.parentsContactInputView.contactName = contact[@"name"];
                self.parentsContactInputView.contactNumber = contact[@"number"];
                break;
            case RWContactTypeFamily:
                self.familyContactInputView.contactName = contact[@"name"];
                self.familyContactInputView.contactNumber = contact[@"number"];
                break;
            case RWContactTypeColleague:
                self.colleagueContactInputView.contactName = contact[@"name"];
                self.colleagueContactInputView.contactNumber = contact[@"number"];
                break;
            default:
                break;
        }
        
        [self checkNextBtnEnable];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)checkNextBtnEnable {
    BOOL parentsEnable = self.parentsContactInputView.contactName.length > 0 && self.parentsContactInputView.contactName.length;
    BOOL familyEnable = self.familyContactInputView.contactName.length > 0 && self.familyContactInputView.contactName.length;
    BOOL colleagueEnable = self.colleagueContactInputView.contactName.length > 0 && self.colleagueContactInputView.contactName.length > 0;
    
    if(parentsEnable && familyEnable && colleagueEnable) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

- (void)nextBtnClicked {
    [RWADJTrackTool trackingWithPoint:@"tagrdx"];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"brotherOrSisterName"] = self.parentsContactInputView.contactName;
    params[@"brotherOrSisterNumber"] = self.parentsContactInputView.contactNumber;
    params[@"familyName"] = self.familyContactInputView.contactName;
    params[@"familyNumber"] = self.familyContactInputView.contactNumber;
    params[@"colleagueName"] = self.colleagueContactInputView.contactName;
    params[@"colleagueNumber"] = self.colleagueContactInputView.contactNumber;
    
    [[RWNetworkService sharedInstance] authInfoWithType:RWAuthTypeContactInfo parameters:params success:^{
        RWBankCardController *bankController= [[RWBankCardController alloc] init];
        bankController.authStatus = self.authStatus;
        [self.navigationController pushViewController:bankController animated:YES];
    }];
}

- (void)loadData {
    if (self.authStatus.loanapiUserLinkMan) {
        [[RWNetworkService sharedInstance] fetchUserAuthInfoWithType:RWAuthTypeContactInfo success:^(RWContentModel * _Nonnull authenficationInfo) {
            self.contactInfo = authenficationInfo;
        }];
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.contacts.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *contact = self.contacts[row];
    NSString *title = [NSString stringWithFormat:@"%@:%@", contact[@"name"], contact[@"number"]];
    return title;
}
@end

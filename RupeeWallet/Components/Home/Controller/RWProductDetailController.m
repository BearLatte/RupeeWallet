//
//  RWProductDetailController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/9.
//

#import "RWProductDetailController.h"
#import "RWProductDetailModel.h"
#import "RWAttributedLabel.h"
#import "RWAlertView.h"
#import "RWTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIDevice+Extension.h"
#import "RWLocationManager.h"
#import "RWPurchaseSuccessController.h"

@interface RWProductDetailController ()
@property(nonatomic, weak) UIImageView *productLogoView;
@property(nonatomic, weak) UILabel *productNameLabel;
@property(nonatomic, weak) RWAttributedLabel *receivedAmoutLabel;
@property(nonatomic, weak) RWAttributedLabel *amountLable;
@property(nonatomic, weak) RWAttributedLabel *verificationFeeLabel;
@property(nonatomic, weak) RWAttributedLabel *gstLabel;
@property(nonatomic, weak) RWAttributedLabel *interestLabel;
@property(nonatomic, weak) RWAttributedLabel *termsLabel;
@property(nonatomic, weak) RWAttributedLabel *overdueChargeLabel;
@property(nonatomic, weak) RWAttributedLabel *repaymentAmountLabel;
@property(nonatomic, weak) UIButton *loanBtn;

@property(nonatomic, strong) RWProductDetailModel *productDetail;
@end

@implementation RWProductDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isRecommend) {
        [self closeGesturePop];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self openGesturePop];
}

- (void)setProductDetail:(RWProductDetailModel *)productDetail {
    _productDetail = productDetail;
    [self.productLogoView sd_setImageWithURL:[NSURL URLWithString:productDetail.logo]
                            placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    self.productNameLabel.text = productDetail.loanName;
    self.receivedAmoutLabel.key = [NSString stringWithFormat:@"₹ %@", productDetail.receiveAmountStr];
    self.amountLable.value = [NSString stringWithFormat:@"₹ %@", productDetail.loanAmountStr];
    self.verificationFeeLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.verificationFeeStr];
    self.gstLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.gstFeeStr];
    self.interestLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.interestAmountStr];
    self.termsLabel.value = [NSString stringWithFormat:@"%@ Days", productDetail.loanDate];
    self.overdueChargeLabel.value = [NSString stringWithFormat:@"%@/day", productDetail.overdueChargeStr];
    self.repaymentAmountLabel.value = [NSString stringWithFormat:@"₹ %@", productDetail.repayAmountStr];
    
    [self updateUI];
}

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    self.isDarkBackMode = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.layer.cornerRadius = 10;
    logo.layer.masksToBounds = YES;
    logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:logo];
    self.productLogoView = logo;
    
    UILabel *productName = [[RWGlobal sharedGlobal] createLabelWithText:nil font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
    [self.view addSubview:productName];
    self.productNameLabel = productName;
    
    RWAttributedLabel *receivedAmoutn = [RWAttributedLabel attributedLabelWithKey:nil keyColor:THEME_COLOR keyFont:[UIFont systemFontOfSize:30 weight:UIFontWeightSemibold] value:@" Received Amount" valueColor:INDICATOR_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
    receivedAmoutn.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:receivedAmoutn];
    self.receivedAmoutLabel = receivedAmoutn;
    
    RWAttributedLabel *amount = [self attributedLabelWithKey:@"Amount : "];
    [self.view addSubview:amount];
    self.amountLable = amount;
    
    RWAttributedLabel *verification = [self attributedLabelWithKey:@"Verification Fee : "];
    [self.view addSubview:verification];
    self.verificationFeeLabel = verification;
    
    RWAttributedLabel *gst = [self attributedLabelWithKey:@"GST : "];
    [self.view addSubview:gst];
    self.gstLabel = gst;
    
    RWAttributedLabel *interest = [self attributedLabelWithKey:@"Interest :"];
    [self.view addSubview:interest];
    self.interestLabel = interest;
    
    RWAttributedLabel *terms = [self attributedLabelWithKey:@"Terms : "];
    [self.view addSubview:terms];
    self.termsLabel = terms;
    
    RWAttributedLabel *overdueCharge = [self attributedLabelWithKey:@"Overdue Charge : "];
    [self.view addSubview:overdueCharge];
    self.overdueChargeLabel = overdueCharge;
    
    RWAttributedLabel *repaymentAmount = [RWAttributedLabel attributedLabelWithKey:@"Repayment Amount :" keyColor:THEME_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_COLOR valueFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:repaymentAmount];
    self.repaymentAmountLabel = repaymentAmount;
    
    UIButton *loanBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Loan now" cornerRadius:30];
    [loanBtn addTarget:self action:@selector(loanNowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loanBtn];
    self.loanBtn = loanBtn;
    
    [self updateUI];
}

- (RWAttributedLabel *)attributedLabelWithKey:(NSString *)key {
    RWAttributedLabel *label = [RWAttributedLabel attributedLabelWithKey:key keyColor:INDICATOR_TEXT_COLOR keyFont:[UIFont systemFontOfSize:16] value:nil valueColor:THEME_TEXT_COLOR valueFont:[UIFont systemFontOfSize:16]];
    return  label;
}

- (void)updateUI {
    [self.productLogoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_SAFE_AREA + 60);
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.right.mas_equalTo(self.view.mas_centerX).offset(-5);
    }];
    
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.productLogoView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.productLogoView);
    }];
    
    [self.receivedAmoutLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productLogoView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    
    [self.amountLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.receivedAmoutLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(22);
    }];
    
    [self.verificationFeeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLable.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.gstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verificationFeeLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.interestLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gstLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.termsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.interestLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.overdueChargeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.termsLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.repaymentAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.overdueChargeLabel.mas_bottom).offset(8);
        make.left.right.height.mas_equalTo(self.amountLable);
    }];
    
    [self.loanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-BOTTOM_SAFE_AREA);
    }];
    
}

- (void)loanNowBtnClicked {
    [[RWNetworkService sharedInstance] fetchProductWithIsRecommend:NO success:^(RWContentModel * _Nullable userInfo, NSArray * _Nullable products, RWProductDetailModel * _Nullable recommendProduct) {
        if(userInfo.userLiveness) {
            [self configParameters];
        } else {
            [RWAlertView showAlertViewWithStyle:RWAlertStyleTips title:@"TIPS" message:@"Please upload a selfie photo before continuing." confirmAction:^{
                [self go2takePhoto];
            }];
        }
    } failure:^{
    }];
}


- (void)go2takePhoto {
    BOOL isPermission = [self checkCameraPermission];
    if (isPermission) {
        RWTakePhotoController *takePhotoVC = [[RWTakePhotoController alloc] init];
        takePhotoVC.submitAction = ^(UIImage *selectedImage) {
            [self selectedImageAction:selectedImage];
        };
        [self.navigationController pushViewController:takePhotoVC animated:YES];
    } else {
        [RWProgressHUD showInfoWithStatus:@"You did not allow us to access the camera, which will help you obtain a loan. Would you like to set up authorization."];
    }
    
}

- (void)selectedImageAction:(UIImage *)selectedImage {
    [[RWNetworkService sharedInstance] userFaceAuthWithImage:selectedImage success:^{
        [RWProgressHUD showSuccessWithStatus:@"upload success"];
    } failure:^{
        [RWAlertView showAlertViewWithStyle:RWAlertStyleError title:nil message:@"Upload failed, please try again." confirmAction:nil];
    }];
}

- (BOOL)checkCameraPermission {
    __block BOOL isPermission = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            isPermission = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    } else if(status == AVAuthorizationStatusAuthorized) {
        isPermission = YES;
        dispatch_semaphore_signal(semaphore);
    } else {
        dispatch_semaphore_signal(semaphore);
        isPermission = NO;
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isPermission;
}

- (void)configParameters {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"productId"] = self.productDetail.productId;
    params[@"loanAmount"] = self.productDetail.loanAmountStr;
    params[@"loanDate"] = self.productDetail.loanDate;
    NSMutableDictionary *deviceAllInfo = @{}.mutableCopy;
    if([UIDevice currentDevice].idfa.length > 0) {
        deviceAllInfo[@"idfa"] =  [UIDevice currentDevice].idfa;
    }
    deviceAllInfo[@"udid"] =  [UIDevice currentDevice].identifierForVendor.UUIDString;
    deviceAllInfo[@"model"] =  [UIDevice currentDevice].model;
    deviceAllInfo[@"batteryStatus"] =  [UIDevice currentDevice].batteryStatus;
    BOOL isIpad = [[UIDevice currentDevice].model isEqualToString:@"iPad"];
    deviceAllInfo[@"isPhone"] = isIpad ? @"false" : @"true";
    deviceAllInfo[@"isTablet"] = isIpad ? @"true" : @"false";
    deviceAllInfo[@"batteryLevel"] = [UIDevice currentDevice].batteryLevelString;
    deviceAllInfo[@"ipAddress"] = [UIDevice currentDevice].ipAddress;
    deviceAllInfo[@"bootTime"] = [UIDevice currentDevice].bootTime;
    deviceAllInfo[@"time"] = [UIDevice currentDevice].uptime;
    deviceAllInfo[@"networkType"] = [UIDevice currentDevice].networkType;
    deviceAllInfo[@"is4G"] = @([[UIDevice currentDevice].networkType isEqualToString: @"NETWORK_4G"]);
    deviceAllInfo[@"is5G"] = @([[UIDevice currentDevice].networkType isEqualToString: @"NETWORK_5G"]);
    deviceAllInfo[@"wifiConnected"] = @([[UIDevice currentDevice].networkType isEqualToString: @"NETWORK_WIFI"]);
    deviceAllInfo[@"sdkVersionName"] = [[UIDevice currentDevice] systemVersion];
    deviceAllInfo[@"externalTotalSize"] = [UIDevice currentDevice].totalDiskSpaceInGB;
    deviceAllInfo[@"internalTotalSize"] = [UIDevice currentDevice].totalDiskSpaceInGB;
    deviceAllInfo[@"internalAvailableSize"] = [UIDevice currentDevice].freeDiskSpaceInGB;
    deviceAllInfo[@"externalAvailableSize"] = [UIDevice currentDevice].freeDiskSpaceInGB;
    deviceAllInfo[@"availableMemory"] = @([UIDevice currentDevice].freeDiskSpaceInBytes);
    CGFloat percent = (CGFloat)[UIDevice currentDevice].usedDiskSpaceInBytes / (CGFloat)[UIDevice currentDevice].totalDiskSpaceInBytes * 100.0;
    deviceAllInfo[@"percentValue"] = [NSString stringWithFormat:@"%.0f", percent];
    deviceAllInfo[@"language"] = [UIDevice currentDevice].language;
    deviceAllInfo[@"brand"] = @"Apple";
    BOOL mobileData = ![[UIDevice currentDevice].networkType isEqualToString:@"NETWORK_WIFI"] && ![[UIDevice currentDevice].networkType isEqualToString:@"NETWORK_UNKNOWN"];
    deviceAllInfo[@"mobileData"] =  @(mobileData);
    deviceAllInfo[@"languageList"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    deviceAllInfo[@"screenWidth"] = @(SCREEN_WIDTH);
    deviceAllInfo[@"screenHeight"] = @(SCREEN_HEIGHT);
    deviceAllInfo[@"brightness"] = [NSString stringWithFormat:@"%.0f", [UIScreen mainScreen].brightness * 100];
    deviceAllInfo[@"appOpenTime"] = [UIDevice currentDevice].openAppTimeStamp;
    deviceAllInfo[@"timezone"] = [NSTimeZone localTimeZone].name;
    NSMutableDictionary *data = @{}.mutableCopy;
    if(![RWGlobal sharedGlobal].isAppleTestAccount) {
        NSArray *contacts = [[RWGlobal sharedGlobal] getContactList];
        if(contacts == nil) {
            return;
        }
        
        data[@"phoneList"] = contacts;
        
        if(![[RWLocationManager sharedManager] hasLocationService]) {
            [RWProgressHUD showInfoWithStatus:@"Please switch location service to on"];
            return;
        }
        
        if(![[RWLocationManager sharedManager] hasLocationPermission]) {
            [[RWLocationManager sharedManager] requestLocationAuthorizaiton];
            return;
        }
        
        [[RWLocationManager sharedManager] getLocationWithBlock:^(BOOL success, CLLocation * _Nullable location) {
            deviceAllInfo[@"latitude"] = [NSString stringWithFormat:@"%lf", location.coordinate.latitude];
            deviceAllInfo[@"longitude"] = [NSString stringWithFormat:@"%lf", location.coordinate.longitude];
            data[@"deviceAllInfo"] = deviceAllInfo;
            params[@"data"] = [[data copy] mj_JSONString];
            [self purchaseProductWithParams:params];
        }];
        
    } else {
        data[@"deviceAllInfo"] = deviceAllInfo;
        params[@"data"] = [[data copy] mj_JSONString];
        [self purchaseProductWithParams:params];
    }
    
}

- (void)purchaseProductWithParams:(NSDictionary *)params {
    [[RWNetworkService sharedInstance] purchaseProductWithParameters:params success:^(NSArray * _Nullable recommendProductList, BOOL isFirstApply) {
        if(isFirstApply) {
            // TUDO: 首单埋点
        }
        
        RWPurchaseSuccessController *successController = [[RWPurchaseSuccessController alloc] init];
        successController.isRecommend = self.isRecommend;
        successController.recommendProductList = recommendProductList;
        [self.navigationController pushViewController:successController animated:YES];
    }];
}

- (void)loadData {
    [[RWNetworkService sharedInstance] checkUserStatusWithProductId:self.productId success:^(NSInteger userStatus, NSString * _Nonnull orderNumber, RWProductDetailModel * _Nonnull productDetail) {
        self.productDetail = productDetail;
    }];
}

- (void)backAction {
    if(self.isRecommend) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

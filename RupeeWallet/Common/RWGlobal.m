//
//  RWGlobal.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import "RWGlobal.h"
#import "RWLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>

NSString * const IS_LOGIN_KEY = @"kIS_LOGIN_KEY";
NSString * const IS_CERTIFIED_KEY = @"kIS_CERTIFIED_KEY";
NSString * const ACCESS_TOKEN_KEY = @"kACCESS_TOKEN_KEY";
NSString * const IDFA_KEY = @"kIDFA_KEY";
NSString * const LOGIN_PHONE_NUMBER_KEY = @"kLOGIN_PHONE_NUMBER_KEY";

NSString * const THEME_COLOR = @"#4BB7AC";
NSString * const THEME_TEXT_COLOR = @"#333333";
NSString * const INDICATOR_TEXT_COLOR = @"#999999";
NSString * const NORMAL_BORDER_COLOR = @"#D4D3D8";
NSString * const THEME_BACKGROUND_COLOR = @"#EBF0EF";
NSString * const FORM_TITLE_TEXT_COLOR  = @"#5E6078";
NSString * const TAB_BAR_NORMAL_FOREGROUND_COLOR = @"#BDBDBD";
NSString * const PLACEHOLDER_IMAGE_COLOR = @"#D8D8D8";

// TODO: 上线前需要添上
NSString * const APP_STORE_TEST_ACCOUNT = @"";
NSString * const ADJUST_APP_TOKEN = @"sg346zqpiuio";

@interface RWGlobal()
@property(nonatomic, strong) CNContactStore *contactStore;
@end

@implementation RWGlobal
+ (RWGlobal *)sharedGlobal {
    static RWGlobal *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[RWGlobal alloc] init];
    });
    
    return global;
}

- (CNContactStore *)contactStore {
    if(!_contactStore) {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}


- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN_KEY];
}

- (NSString *)currentPhoneNumber {
    return [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PHONE_NUMBER_KEY];
}

- (BOOL)isAppleTestAccount {
    NSString *loginPhoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:LOGIN_PHONE_NUMBER_KEY];
    return [loginPhoneNumber isEqualToString:APP_STORE_TEST_ACCOUNT];
}

- (BOOL)isBangs {
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        return NO;
    }
    
    if(@available(iOS 11.0, *)) {
        UIWindow *currentWindow = [UIApplication sharedApplication].delegate.window;
        if(currentWindow.safeAreaInsets.left > 0 || currentWindow.safeAreaInsets.bottom > 0) {
            return  YES;
        }
    }
    return NO;
}

- (void)go2login {
    [self clearLoginData];
    RWLoginViewController *loginVC = [[RWLoginViewController alloc] init];
    loginVC.modalStyle = RWModalStylePresent;
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:loginVC animated:YES completion:nil];
}

- (void)clearLoginData {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:IS_LOGIN_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LOGIN_PHONE_NUMBER_KEY];
}

- (UIButton *)createThemeButtonWithTitle:(NSString * _Nullable)title cornerRadius:(CGFloat)radius {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:THEME_COLOR]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:NORMAL_BORDER_COLOR]] forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (UILabel *)createLabelWithText:(NSString *_Nullable)text font:(UIFont *)font textColor:(NSString *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor colorWithHexString:color];
    return label;
}

- (UILabel *)createAttributedStringLabelWithKey:(NSString *)key keyColor:(NSString *)keyColor keyFont:(UIFont *)keyFont value:(NSString *)value valueColor:(NSString *)valueColor valueFont:(UIFont *)valueFont {
    keyColor = keyColor == nil ? INDICATOR_TEXT_COLOR : keyColor;
    valueColor = valueColor == nil ? THEME_TEXT_COLOR : valueColor;
    keyFont = keyFont == nil ? [UIFont systemFontOfSize:16] : keyFont;
    valueFont = valueFont == nil ? [UIFont systemFontOfSize:16] : valueFont;
    NSAttributedString *keyAttributedString = [[NSAttributedString alloc] initWithString:key attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:keyColor],
        NSFontAttributeName : keyFont
    }];
    NSAttributedString *valueAttributedString = [[NSAttributedString alloc] initWithString:value attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithHexString:valueColor],
        NSFontAttributeName : valueFont
    }];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:keyAttributedString];
    [attStr appendAttributedString:valueAttributedString];
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attStr;
    return label;
}

- (void)checkCameraAuthorityWithTarget:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> )target {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized: {
            UIImagePickerController *imgController = [[UIImagePickerController alloc] init];
            imgController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgController.allowsEditing = NO;
            imgController.delegate = target;
            [(UIViewController *)target presentViewController:imgController animated:YES completion:nil];
        }
            break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imgController = [[UIImagePickerController alloc] init];
                        imgController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imgController.allowsEditing = NO;
                        imgController.delegate = target;
                        [(UIViewController *)target presentViewController:imgController animated:YES completion:nil];
                    });
                }
            }];
        }
            break;
        default: {
            [RWProgressHUD showInfoWithStatus:@"You did not allow us to access the camera, which will help you obtain a loan. Would you like to set up authorization."];
        }
            break;
    }
}

- (UIViewController *)getCurrentViewController {
    return [self getCurrentViewControllFrom:[UIApplication sharedApplication].windows.firstObject.rootViewController];
}

- (UIViewController *)getCurrentViewControllFrom:(UIViewController *)root {
    UIViewController *currentVC;
    if ([root presentedViewController]) {
        root = [root presentedViewController];
    }
    if ([root isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentViewControllFrom:[(UITabBarController *)root selectedViewController]];
    } else if ([root isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentViewControllFrom:[(UINavigationController *)root visibleViewController]];
    } else {
        currentVC = root;
    }
    
    return currentVC;
}

- (NSArray *)getContactList {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined:
            return [self requestContactStoreAuthorizationWithContactStore:self.contactStore];
        case CNAuthorizationStatusAuthorized:
            return [self readContactsFromContactStore:self.contactStore];
        default:
            [RWProgressHUD showInfoWithStatus:@"You did not allow us to access the contacts. Allowing it will help you obtain a loan. Do you want to set up authorization."];
            return nil;
    }
}


- (NSArray *)requestContactStoreAuthorizationWithContactStore:(CNContactStore *)store {
    __block NSArray *contacts = nil;
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(error) {
            [RWProgressHUD showInfoWithStatus:@"You did not allow us to access the contacts. Allowing it will help you obtain a loan. Do you want to set up authorization."];
            return;
        }
        
        if(granted) {
            contacts = [self readContactsFromContactStore:store];
        }
    }];
    
    return contacts;
}

- (NSArray *)readContactsFromContactStore:(CNContactStore *)store {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if(status != CNAuthorizationStatusAuthorized) {
        [RWProgressHUD showInfoWithStatus:@"You did not allow us to access the contacts. Allowing it will help you obtain a loan. Do you want to set up authorization."];
        return nil;
    }
    
    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [RWProgressHUD showWithStatus:@"reading contacts ..."];
    });
    
    __block NSMutableArray *contactList = @[].mutableCopy;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;
        [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
            for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                NSString *number = ((CNPhoneNumber *)labeledValue.value).stringValue;
                [contactList addObject:@{@"contactDisplayName" : name, @"number" : number}];
            }
            
        }];
        
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [RWProgressHUD showErrorWithStatus:error.description];
                contactList = nil;
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [RWProgressHUD dismiss];
        });
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return [contactList copy];
}

@end

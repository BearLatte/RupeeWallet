//
//  RWNetworkService.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/5.
//

#import "RWNetworkService.h"
#import "UIDevice+Extension.h"
#import <AFNetworking/AFNetworking.h>
#import "RWBaseModel.h"
#import "RWProgressHUD.h"
#import "RWNetworkResponseModel.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>

@interface RWNetworkService()
@property(nonatomic, strong) AFHTTPSessionManager *_Nullable networkManager;
@end

@implementation RWNetworkService

#ifdef DEBUG
static NSString * const baseURL = @"http://8.215.46.156:1060";
#else
static NSString * const baseURL = @"";
#endif



+ (instancetype)sharedInstance {
    static RWNetworkService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[RWNetworkService alloc] init];
    });
    
    return service;
}


- (AFHTTPSessionManager *)networkManager {
    if(!_networkManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 60;
        _networkManager= [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL] sessionConfiguration:config];
    }
    return _networkManager;
}



- (NSDictionary *)getHeader {
    NSMutableDictionary *header = @{}.mutableCopy;
    header[@"lang"]  = @"id";
    header[@"token"] = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_KEY];
    
    NSMutableDictionary *deviceInfo = @{}.mutableCopy;
    deviceInfo[@"appVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    deviceInfo[@"bag"] = [NSBundle mainBundle].bundleIdentifier;
    deviceInfo[@"brand"] = @"Apple";
    deviceInfo[@"deviceModel"] = [UIDevice currentDevice].model;
    deviceInfo[@"osVersion"] = [UIDevice currentDevice].systemVersion;
    deviceInfo[@"operationSys"] = [UIDevice currentDevice].systemName;
    deviceInfo[@"advertising_id"] = [UIDevice currentDevice].idfa;
    deviceInfo[@"udid"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    deviceInfo[@"channel"] = @"AppStore";
    deviceInfo[@"mac"] = @"";
    
    header[@"deviceInfo"] = [deviceInfo mj_JSONString];
    
    return [header copy];
}

- (void)fetchPerductListWithSuccess:(void (^)(NSArray * _Nonnull))successClosure failure:(void (^)(void))failureClosure {
    [RWProgressHUD showWithStatus:@"loading..."];
    if ([RWGlobal sharedGlobal].isLogin) {
        [self requestWithPath:@"/uzYONRY/Yuulyz/kluBMGy" parameters:nil success:^(RWBaseModel *response) {
            [[NSUserDefaults standardUserDefaults] setValue:response.cont.phone forKey:LOGIN_PHONE_NUMBER_KEY];
            successClosure(response.cont.loanProductList);
        } failure:^{
            failureClosure();
        }];
    } else {
        [self requestWithPath:@"/uzYONRY/ihaEGZs" parameters:nil success:^(RWBaseModel *response) {
            successClosure(response.cont.loanProductList);
        } failure:^{
            failureClosure();
        }];
    }
}

- (void)sendSMSWithPhoneNumber: (NSString *)phoneNumber success:(void (^)(void))success {
    [RWProgressHUD showWithStatus:@"sending..."];
    [self requestWithPath:@"/uzYONRY/jSevQuB" parameters:@{@"phone" : phoneNumber} success:^(RWBaseModel *response) {
        success();
    } failure:^{
        
    }];
}

- (void)loginWithPhone:(NSString *)phone code:(NSString *)code success:(void (^)(void))success {
    [RWProgressHUD showWithStatus:@"login..."];
    [self requestWithPath:@"/uzYONRY/xKEWXAdz" parameters:@{@"phone" : phone, @"code": code} success:^(RWBaseModel *response) {
        if(response.cont.isLogin == 0) {
            // TODO: - 此处需要做注册的埋点
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:response.cont.token forKey:ACCESS_TOKEN_KEY];
        success();
    } failure:^{
        
    }];
}

- (void)fetchUserAuthInfoWithType:(RWAuthType)type success:(void (^)(RWContentModel * _Nonnull))success {
    [RWProgressHUD showWithStatus:@"loading..."];
    NSMutableDictionary *params = @{}.mutableCopy;
    switch (type) {
        case RWAuthTypeAllInfo:
            params[@"type"] = @"1";
            break;
        case RWAuthTypeKYCInfo:
            params[@"type"] = @"2";
            params[@"step"] = @"loanapiUserIdentity";
            break;
        case RWAuthTypePersonalInfo:
            params[@"type"] = @"2";
            params[@"step"] = @"loanapiUserBasic";
            break;
        case RWAuthTypeContactInfo:
            params[@"type"] = @"2";
            params[@"step"] = @"loanapiUserLinkMan";
            break;
        case RWAuthTypeBankCardInfo:
            params[@"type"] = @"2";
            params[@"step"] = @"loanapiUserBankCard";
            break;
        default:
            break;
    }
    [self requestWithPath:@"/uzYONRY/Yuulyz/cFDJWnU" parameters:[params copy] success:^(RWBaseModel *response) {
        success(response.cont);
    } failure:^{

    }];
}

- (void)checkUserStatusWithProductId:(NSString *)productId success:(void (^)(NSInteger, NSString *, RWProductDetailModel * _Nonnull))success {
    [RWProgressHUD showWithStatus:@"loading..."];
    [self requestWithPath:@"/uzYONRY/Yuulyz/emoeOAT" parameters:@{@"productId" : productId} success:^(RWBaseModel *response) {
        success(response.cont.userStatus, response.cont.loanAuditOrderVo.loanOrderNo, response.cont.loanProductVo);
    } failure:^{
        
    }];
}

- (void)fetchDropMenuListSuccess:(void (^)(RWContentModel * _Nonnull))success {
    [RWProgressHUD showWithStatus:@"loading..."];
    [self requestWithPath:@"/uzYONRY/Yuulyz/OizltM" parameters:nil success:^(RWBaseModel *response) {
        success(response.cont);
    } failure:^{
        
    }];
}

// MARK: - OCR Image upload
- (void)ocrRequestWithImage:(UIImage *)image ocrType:(RWOCRType)type success:(void (^)(RWContentModel * _Nonnull, NSString *))success {
    dispatch_queue_t dispatchQueue = dispatch_queue_create("background.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block RWContentModel *ossParams = nil;
    __block NSString *imageUrl = nil;
    
    dispatch_async(dispatchQueue, ^{
        [self fetchOSSParametersSuccess:^(RWContentModel *content) {
            ossParams = content;
            dispatch_semaphore_signal(semaphore);
        } failure:^{
            dispatch_semaphore_signal(semaphore);
        }];
        
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self uploadImageWithOSSParameters:ossParams image:image success:^(NSString *imgUrl) {
            imageUrl = imgUrl;
            dispatch_semaphore_signal(semaphore);
        } failure:^{
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self ocrServiceWithType:type imageUrl:imageUrl success:^(RWContentModel *content) {
            success(content, imageUrl);
            dispatch_semaphore_signal(semaphore);
        } failure:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
}

- (void)authInfoWithType:(RWAuthType)type parameters:(NSDictionary *)parameters success:(void (^)(void))success {
    [RWProgressHUD showWithStatus:@"verifying..."];
    NSString *path = nil;
    switch (type) {
        case RWAuthTypeKYCInfo:
            path = @"/uzYONRY/Yuulyz/dDOjZz";
            break;
        case RWAuthTypePersonalInfo:
            path = @"/uzYONRY/Yuulyz/uWEGwa";
            break;
        case RWAuthTypeContactInfo:
            path = @"/uzYONRY/Yuulyz/nOONCuy";
            break;
        case RWAuthTypeBankCardInfo:
            path = @"/uzYONRY/Yuulyz/iskepOc";
            break;
        default:
            break;
    }
    
    [self requestWithPath:path parameters:parameters success:^(RWBaseModel *response) {
        success();
    } failure:^{
        
    }];
}


// MARK: - Private method
- (NSDictionary *)configParametersWithOldParameters: (NSDictionary *)oldParams {
    NSMutableDictionary *body = oldParams.mutableCopy;
    if (body == nil) {
        body = @{}.mutableCopy;
    }
    NSString *randomKey = [NSString generateRandomStringWithLength:30];
    body[@"noncestr"] = randomKey;
    
    NSString *keyString;
#ifdef DEBUG
    keyString = [NSString stringWithFormat:@"%@&indiakey=6ShEUmiNSp9sQWgBzS8N831zyJXlKEKrjqlcZBZN", [NSString sortedDictionary:body]];
#else
    keyString = @"";
#endif
    NSString *signString = [[keyString MD5] uppercaseString];
    body[@"sign"] = signString;
    return [body copy];
}

- (void)requestWithPath:(NSString *)path
             parameters: (NSDictionary *)parameters
                success:(nullable void (^)(RWBaseModel *response))success failure:(void(^)(void))failure {
    
    NSDictionary *header = [self getHeader];
    NSDictionary *params = [self configParametersWithOldParameters:parameters];
    RWLog(@"请求地址:%@%@\n请求头: %@\n请求体: %@", baseURL, path, header, params);
    [self.networkManager POST:path parameters:params headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (RWProgressHUD.isVisible) {
                [RWProgressHUD dismiss];
            }
            
            RWNetworkResponseModel *model = [RWNetworkResponseModel mj_objectWithKeyValues:responseObject];
            if (model.code == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(model.response);
                });
            } else if (model.code == -1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[RWGlobal sharedGlobal] go2login];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RWProgressHUD showInfoWithStatus:model.msg];
                });
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RWProgressHUD showErrorWithStatus:@"Network Error"];
            failure();
        });
    }];
}

- (void)fetchOSSParametersSuccess:(void(^)(RWContentModel *content))success failure:(void(^)(void))failure {
    [RWProgressHUD showWithStatus:@"loading..."];
    [self requestWithPath:@"/uzYONRY/Yuulyz/JjXaQYJ" parameters:nil success:^(RWBaseModel *response) {
        success(response.cont);
    } failure:^{
        failure();
    }];
}

- (void)uploadImageWithOSSParameters:(RWContentModel *)parameters image:(UIImage *)image success:(void(^)(NSString *imgUrl))success failure:(void(^)(void))failure {
    [RWProgressHUD showWithStatus:@"uploading..."];
    OSSFederationCredentialProvider *provider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * _Nullable{
        OSSFederationToken *token = [OSSFederationToken new];
        token.tAccessKey = parameters.credentials.accessKeyId;
        token.tSecretKey = parameters.credentials.accessKeySecret;
        token.tToken     = parameters.credentials.securityToken;
        token.expirationTimeInGMTFormat = parameters.credentials.expiration;
        return token;
    }];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:parameters.url credentialProvider:provider];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = parameters.bucket;
    NSString *fullPath = [NSString stringWithFormat:@"india/img/%@/%@.jpg", [[[NSDate alloc] init] date2stringWithFormatter:@"yyyy-MM-dd"], [NSString generateRandomStringWithLength:32]];
    put.objectKey = fullPath;
    put.uploadingData = [image compressImageToMaxLength: 1024 * 200];
    OSSTask *task = [client putObject:put];
    [[task continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RWProgressHUD dismiss];
        });
        
        if(task.error != nil) {
            [RWProgressHUD showErrorWithStatus:@"Upload Failed"];
        }
        
        success(fullPath);
        return nil;
    }] waitUntilFinished];
}

- (void)ocrServiceWithType:(RWOCRType)type imageUrl:(NSString *)imageUrl success:(void(^)(RWContentModel *content))success failure:(void(^)(void))failure {
    [RWProgressHUD showWithStatus:@"identifying..."];
    NSString *typeStr = nil;
    switch (type) {
        case RWOCRTypeAadhaarCardFront:
            typeStr = @"AADHAAR_FRONT";
            break;
        case RWOCRTypeAadhaarCardBack:
            typeStr = @"AADHAAR_BACK";
            break;
        case RWOCRTypePanCardFront:
            typeStr = @"PAN_FRONT";
            break;
        default:
            break;
    }
    
    [self requestWithPath:@"/uzYONRY/Yuulyz/RCyYWTbj" parameters:@{@"type" : typeStr, @"imgUrl" : imageUrl} success:^(RWBaseModel *response) {
        success(response.cont);
    } failure:^{
        failure();
    }];
}
@end

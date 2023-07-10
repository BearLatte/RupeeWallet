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

- (void)fetchUserAuthInfoWithType:(NSInteger)type step:(NSString *)step success:(void (^)(RWContentModel * _Nonnull))success {
    [RWProgressHUD showWithStatus:@"loading..."];
    NSMutableDictionary *params = @{@"type": @(type)}.mutableCopy;
    if(step != nil) {
        params[@"step"] = step;
    }
    [self requestWithPath:@"/uzYONRY/Yuulyz/cFDJWnU" parameters:params success:^(RWBaseModel *response) {
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


@end

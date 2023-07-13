//
//  RWTakePhotoController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import "RWTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>

@interface RWTakePhotoController ()<AVCapturePhotoCaptureDelegate>
@property(nonatomic, weak) UIButton *takePhotoButton;
@property(nonatomic, weak) UIView *moreActionBgView;

@property(nonatomic, strong) AVCaptureSession *_Nullable session;
@property(nonatomic, strong) AVCapturePhotoOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *photoPreviewLayer;

@property(nonatomic, strong) UIImage *selectedImage;
@end

@implementation RWTakePhotoController

- (AVCapturePhotoOutput *)output {
    if(!_output) {
        _output = [[AVCapturePhotoOutput alloc] init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)photoPreviewLayer {
    if(!_photoPreviewLayer) {
        _photoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    }
    return _photoPreviewLayer;
}

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    self.view.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    
    UILabel *indicatorLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Please keep all faces in the viewfinder and must upload clear photos." font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.numberOfLines = 0;
    [self.view addSubview:indicatorLabel];
    [indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 14);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    
    UIImageView *cameraLayerBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus_border"]];
    cameraLayerBorderView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:cameraLayerBorderView];
    [cameraLayerBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(330, 330));
        make.center.mas_equalTo(self.view);
    }];
    
    UIView *preview = [[UIView alloc] init];
    preview.backgroundColor = [UIColor whiteColor];
    preview.layer.cornerRadius = 140;
    preview.layer.masksToBounds = YES;
    [self.view addSubview:preview];
    [preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280, 280));
        make.center.mas_equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
    
    self.photoPreviewLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.photoPreviewLayer.frame = preview.bounds;
    [preview.layer addSublayer:self.photoPreviewLayer];
    
    UIButton *take = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Photograph" cornerRadius:30];
    [take setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
    [take setTitleColor:[UIColor colorWithHexString:THEME_COLOR] forState:UIControlStateNormal];
    [take addTarget:self action:@selector(takeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:take];
    [take mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    self.takePhotoButton = take;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    self.moreActionBgView = bgView;
    
    UIButton *retry = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Retry" cornerRadius:30];
    [retry setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#99D9D3"]] forState:UIControlStateNormal];
    [retry setTitleColor:[UIColor colorWithHexString:THEME_TEXT_COLOR] forState:UIControlStateNormal];
    [retry addTarget:self action:@selector(retryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.moreActionBgView addSubview:retry];
    [retry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.moreActionBgView.mas_centerX).offset(-3);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *submit = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Submit" cornerRadius:30];
    [submit setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor colorWithHexString:THEME_COLOR] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.moreActionBgView addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(self.moreActionBgView.mas_centerX).offset(3);
        make.bottom.mas_equalTo(0);
    }];
    
    [self setupCamera];
}


- (void)setupCamera {
    [RWProgressHUD showWithStatus:@"Turning on the camera..."];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    if(!device) {
        [RWProgressHUD showErrorWithStatus:@"Camera Error"];
        return;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];

    if ([session canAddOutput:self.output]) {
        [session addOutput:self.output];
    }
    
    if([session canAddInput:input]) {
        [session addInput:input];
    }
    
    self.photoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.photoPreviewLayer.session = session;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [RWProgressHUD dismiss];
        });
    });
    
    self.session = session;
}

- (void)takeButtonClicked {
    [self updateTakeButtonLayout:YES];
    [self.output capturePhotoWithSettings:[[AVCapturePhotoSettings alloc] init] delegate:self];
}

- (void)retryButtonClicked {
    [self updateTakeButtonLayout:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.session startRunning];
    });
    
}

- (void)submitButtonClicked {
    if(self.submitAction) {
        self.submitAction(self.selectedImage);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTakeButtonLayout:(BOOL)isTake {
    if(isTake) {
        [UIView animateWithDuration:0.25 animations:^{
            self.takePhotoButton.alpha = 1.0;
            self.takePhotoButton.transform = CGAffineTransformIdentity;
            self.moreActionBgView.alpha = 0.1;
            self.moreActionBgView.transform = CGAffineTransformIdentity;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.takePhotoButton.alpha = 0.1;
            self.takePhotoButton.transform = CGAffineTransformMakeTranslation(0, 70 + BOTTOM_SAFE_AREA);
            self.moreActionBgView.alpha = 1.0;
            self.moreActionBgView.transform = CGAffineTransformMakeTranslation(0, -(70 + BOTTOM_SAFE_AREA));
        }];
    }
}


// MARK: - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    if(!data) {
        [RWProgressHUD showErrorWithStatus:@"Take Photo Failed"];
        [self.session startRunning];
        [self updateTakeButtonLayout:YES];
        return;
    }
    
    UIImage *image = [UIImage imageWithData:data];
    if(!image) {
        [RWProgressHUD showErrorWithStatus:@"Take Photo Failed"];
        [self.session startRunning];
        [self updateTakeButtonLayout:YES];
        return;
    }

    [self.session stopRunning];
    [self updateTakeButtonLayout:NO];
    self.selectedImage = image;
}
@end

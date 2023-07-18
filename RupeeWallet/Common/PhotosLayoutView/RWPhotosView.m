//
//  RWPhotosView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWPhotosView.h"
#import "RWPhotosItemView.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface RWPhotosView()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, PHPickerViewControllerDelegate>
@property(nonatomic, assign) RWPhotosViewStyle photosStyle;
@property(nonatomic, assign) NSInteger maxItem;
@property(nonatomic, strong) UIButton *addBtn;
@end
@implementation RWPhotosView
+ (instancetype)photosViewWithStyle:(RWPhotosViewStyle)style maxItem:(NSInteger)maxItem {
    RWPhotosView *photosView = [[RWPhotosView alloc] init];
    photosView.photosStyle = style;
    photosView.maxItem = maxItem;
    [photosView configImages];
    return photosView;
}

- (UIButton *)addBtn {
    if(!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"add_photo_btn_icon"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)setImageUrls:(NSMutableArray *)imageUrls {
    _imageUrls = imageUrls;
    [self configImages];
}

- (void)setImages:(NSMutableArray *)images {
    _images = images;
    [self configImages];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.images = @[].mutableCopy;
        self.imageUrls = @[].mutableCopy;
    }
    return self;
}

- (void)configImages {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if(self.photosStyle == RWPhotosViewStyleUpload) {
        for(NSInteger index = 0; index < self.images.count; index++) {
            RWPhotosItemView *itemView = [RWPhotosItemView itemViewWithIsShowDeleteBtn:YES tag: index + 999 deleteAction:^(NSInteger tag) {
                [self.images removeObjectAtIndex:tag % 999];
                [self.imageUrls removeObjectAtIndex:tag % 999];
                [self configImages];
            }];
            itemView.image = self.images[index];
            [self addSubview:itemView];
        }
        
        if(self.images.count < self.maxItem) {
            [self addSubview:self.addBtn];
        }
        
        [self layoutIfNeeded];
    } else {
        for (NSInteger index = 0; index < self.imageUrls.count; index++) {
            RWPhotosItemView *itemView = [RWPhotosItemView itemViewWithIsShowDeleteBtn:NO tag:0 deleteAction:nil];
            itemView.imageUrl = self.imageUrls[index];
            [self addSubview:itemView];
        }
        
        [self layoutIfNeeded];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.bounds.size.width == 0) {
        return;
    }
    
    CGFloat margin = 9;
    NSInteger maxColumn = 3;
    CGFloat itemWidht  = (self.bounds.size.width - margin * (maxColumn - 1)) / maxColumn;
    CGFloat itemHeight = itemWidht;
    
    UIView *lastView = nil;
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        NSInteger row = index / maxColumn;
        NSInteger column = index % maxColumn;
        
        CGFloat left = column * (margin + itemWidht);
        CGFloat top  = row * (margin + itemHeight);
        
        UIView *view = self.subviews[index];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.left.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(itemWidht, itemHeight));
        }];
        
        lastView = view;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).priority(MASLayoutPriorityDefaultHigh);
    }];
}

- (void)addPhotoAction {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self openAlbum];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlert];
                    });
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized: {
            [self openAlbum];
        }
            break;
        default:
            [self showAlert];
            break;
    }
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"This feature requires you to authorize this app to open the PhotoAlbom service\nHow to set it: open phone Settings -> Privacy -> PhotoAlbom service" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *go2authAction = [UIAlertAction actionWithTitle:@"Go To Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:go2authAction];
    [[[RWGlobal sharedGlobal] getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)openAlbum {
    if(@available(iOS 14.0, *)) {
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = 1;
        config.filter = PHPickerFilter.imagesFilter;
        PHPickerViewController *pickerController = [[PHPickerViewController alloc] initWithConfiguration:config];
        pickerController.delegate = self;
        [[[RWGlobal sharedGlobal] getCurrentViewController] presentViewController:pickerController animated:YES completion:nil];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] initWithRootViewController:[[RWGlobal sharedGlobal] getCurrentViewController]];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [[[RWGlobal sharedGlobal] getCurrentViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)uploadImage:(UIImage *)image {
    [[RWNetworkService sharedInstance] uploadImageWithImage:image success:^(NSString * _Nonnull imageUrl) {
        [self.images addObject:image];
        [self.imageUrls addObject:imageUrl];
        [self configImages];
    } failure:^{
        [RWProgressHUD showErrorWithStatus:@"Upload Failed, Please try again latter."];
    }];
}

// MARK: - UINavigationControllerDelegate,UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *currentImage = info[UIImagePickerControllerOriginalImage];
    if(!currentImage) {
        return;
    }
    
    [self uploadImage:currentImage];
}

// MARK: - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(results.count > 0) {
        PHPickerResult *result = results[0];
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof UIImage *  _Nullable object, NSError * _Nullable error) {
            if(error == nil) {
                [self uploadImage:object];
            } else {
                [RWProgressHUD showErrorWithStatus:error.description];
            }
        }];
    } else {
        [RWProgressHUD showErrorWithStatus:@"Please choose photo again"];
    }
}
@end

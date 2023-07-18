//
//  RWPhotosItemView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DeleteBtnAction)(NSInteger tag);

@interface RWPhotosItemView : UIView
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSString *imageUrl;

+ (instancetype)itemViewWithIsShowDeleteBtn:(BOOL)isShowDeleteBtn tag:(NSInteger)tag deleteAction:(DeleteBtnAction _Nullable)deleteBtnAction;
@end

NS_ASSUME_NONNULL_END

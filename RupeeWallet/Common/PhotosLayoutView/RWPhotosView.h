//
//  RWPhotosView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWPhotosViewStyle) {
    RWPhotosViewStyleUpload,
    RWPhotosViewStylePreview
};
@interface RWPhotosView : UIView
@property(nonatomic, strong) NSMutableArray *imageUrls;
@property(nonatomic, strong) NSMutableArray *images;

+ (instancetype)photosViewWithStyle:(RWPhotosViewStyle)style maxItem:(NSInteger)maxItem;
@end

NS_ASSUME_NONNULL_END

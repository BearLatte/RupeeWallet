//
//  RWOCRCameraPanel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RWOCRCameraPanel;

@protocol RWOCRCameraPanelDelegate <NSObject>
@optional
- (void)camerapPanelDidTappedFrontView:(RWOCRCameraPanel *)panelView;
- (void)camerapPanelDidTappedBackView:(RWOCRCameraPanel *)panelView;
@end

@interface RWOCRCameraPanel : UIView
@property(nonatomic, weak) id<RWOCRCameraPanelDelegate> delegate;
@property(nonatomic, assign) RWOCRType ocrType;

- (void)setImage:(UIImage *)image ocrType:(RWOCRType)type;
- (void)setImageUrl:(NSString *)imageUrl ocrType:(RWOCRType)type;
@end

NS_ASSUME_NONNULL_END

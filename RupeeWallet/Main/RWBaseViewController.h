//
//  RWBaseViewController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RWModalStyle) {
    RWModalStylePresent,
    RWModalStylePush
};

NS_ASSUME_NONNULL_BEGIN

@interface RWBaseViewController : UIViewController
@property(nonatomic, assign) RWModalStyle modalStyle;
@property(nonatomic, assign) BOOL isHiddenBackButton;
@property(nonatomic, assign) BOOL isDarkBackMode;

@property(nonatomic, strong) UILabel *_Nullable titleLabel;

/// ConfigUI
- (void)setupUI;
- (void)loadData;
- (void)backAction;
- (void)setupStepViewWithCurrenStep:(NSString *)currentStep totalStep:(NSString *)totalStep;
@end

NS_ASSUME_NONNULL_END

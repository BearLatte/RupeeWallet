//
//  RWLoginContentView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWContentViewMode) {
    RWContentViewModeInputPhoneNumber,
    RWContentViewModeInputOPT
};

@class RWLoginContentView;
@protocol RWLoginContentViewDelegate <NSObject>
@optional
- (void)contentViewTermsConditionAction:(RWLoginContentView *)contentView;
- (void)contentViewPrivacyAction:(RWLoginContentView *)contentView;
- (void)contentViewActionButtonDidTapped:(RWLoginContentView *)contentView;
@end

@interface RWLoginContentView : UIView
@property(nonatomic, weak) id<RWLoginContentViewDelegate> delegate;
@property(nonatomic, assign) RWContentViewMode contentMode;
@property(nonatomic, assign, readonly) BOOL isCheckedPrivacy;
@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, copy, readonly) NSString *_Nullable smsCode;

- (void)loadCodeInputView;
@end

NS_ASSUME_NONNULL_END

//
//  RWFormInputView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RWFormInputViewType) {
    RWFormInputViewTypeNormal,
    RWFormInputViewTypeDate,
    RWFormInputViewTypeList
};

@interface RWFormInputView : UIView

+ (instancetype)inputViewWithInputType:(RWFormInputViewType)inputType title:(NSString *)title placeholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END

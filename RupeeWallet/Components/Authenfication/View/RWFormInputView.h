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

typedef void(^textfieldTapAction) (void);
typedef void(^didEndEditingAction) (void);
@interface RWFormInputView : UIView

@property(nonatomic, copy) NSString *inputedText;

+ (instancetype)inputViewWithInputType:(RWFormInputViewType)inputType title:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType tapAction:(textfieldTapAction _Nullable)tapAction didEndEditingAction:(didEndEditingAction _Nullable)didEndEditingAction;
@end

NS_ASSUME_NONNULL_END

//
//  RWContactInputView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapAction)(void);
typedef void(^TextFieldDidEditingAction)(void);

@interface RWContactInputView : UIView
@property(nonatomic, copy) NSString *contactName;
@property(nonatomic, copy) NSString *contactNumber;
+ (instancetype)inputViewWithTitle:(NSString *)title namePlaceholder:(NSString *)namePlaceholder tapAction:(TapAction)action didEditingAction:(TextFieldDidEditingAction)didEditingAction;
@end

NS_ASSUME_NONNULL_END

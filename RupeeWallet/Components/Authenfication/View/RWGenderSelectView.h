//
//  RWGenderSelectView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RWGender) {
    RWGenderMale,
    RWGenderFemale
};

@interface RWGenderSelectView : UIView
@property(nonatomic, assign) RWGender gender;
+ (instancetype)genderView;
@end

NS_ASSUME_NONNULL_END

//
//  RWAttributedLabel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWAttributedLabel : UILabel
@property(nonatomic, copy) NSString *_Nullable key;
@property(nonatomic, copy) NSString *_Nullable value;
+ (instancetype)attributedLabelWithKey:(NSString *_Nullable)key keyColor:(NSString *)keyColor keyFont:(UIFont *)keyFont value:(NSString *_Nullable)value valueColor:(NSString *)valueColor valueFont:(UIFont *)valueFont;
@end

NS_ASSUME_NONNULL_END

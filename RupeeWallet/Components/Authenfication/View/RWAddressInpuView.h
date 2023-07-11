//
//  RWAddressInpuView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWAddressInpuView : UIView
@property(nonatomic, copy) NSString *_Nullable address;
+ (instancetype)addressViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END

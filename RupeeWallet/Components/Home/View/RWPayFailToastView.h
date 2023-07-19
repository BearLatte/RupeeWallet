//
//  RWPayFailToastView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/19.
//

#import <UIKit/UIKit.h>
#import "RWUserPayFailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPayFailToastView : UIView
+ (void)showToastWithPayFailInfo:(RWUserPayFailModel *)info;
@end

NS_ASSUME_NONNULL_END

//
//  RWBaseScrollViewController.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/4.
//

#import "RWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWBaseScrollViewController : RWBaseViewController
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@end

NS_ASSUME_NONNULL_END

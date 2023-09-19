//
//  RWSectionHeaderView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^refreshBlock)(void);

@interface RWSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, assign) BOOL isHiddenRefreshBtn;
@property (nonatomic, copy) refreshBlock action;
@end

NS_ASSUME_NONNULL_END

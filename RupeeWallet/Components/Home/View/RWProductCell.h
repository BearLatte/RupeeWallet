//
//  RWProductCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import <UIKit/UIKit.h>
#import "RWProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWProductCell : UITableViewCell
@property(nonatomic, strong) RWProductModel *_Nullable product;
@end

NS_ASSUME_NONNULL_END

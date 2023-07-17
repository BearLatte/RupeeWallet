//
//  RWOrderCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/17.
//

#import <UIKit/UIKit.h>
#import "RWOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWOrderCell : UITableViewCell
@property(nonatomic, strong)  RWOrderModel *order;
@end

NS_ASSUME_NONNULL_END

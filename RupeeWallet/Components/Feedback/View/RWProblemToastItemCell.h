//
//  RWProblemToastItemCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>
#import "RWSelectionableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWProblemToastItemCell : UITableViewCell
@property(nonatomic, strong) RWSelectionableModel *model;
@end

NS_ASSUME_NONNULL_END

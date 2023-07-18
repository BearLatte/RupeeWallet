//
//  RWFeedbackItemCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <UIKit/UIKit.h>
#import "RWFeedbackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWFeedbackItemCell : UITableViewCell
@property(nonatomic, assign, getter=isHiddedDashedView) BOOL hiddedDashedView;
@property(nonatomic, strong) RWFeedbackModel *_Nullable feedback;
@end

NS_ASSUME_NONNULL_END

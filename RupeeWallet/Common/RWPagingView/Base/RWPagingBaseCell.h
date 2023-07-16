//
//  RWPagingBaseCell.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import "RWPagingBaseCellModel.h"
#import "RWPagingViewAnimator.h"
#import "RWPagingViewDefines.h"


NS_ASSUME_NONNULL_BEGIN

@interface RWPagingBaseCell : UICollectionViewCell
@property (nonatomic, strong, readonly) RWPagingBaseCellModel *cellModel;
@property (nonatomic, strong, readonly) RWPagingViewAnimator *animator;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(RWPagingBaseCellModel *)cellModel NS_REQUIRES_SUPER;

- (BOOL)checkCanStartSelectedAnimation:(RWPagingBaseCellModel *)cellModel;

- (void)addSelectedAnimationBlock:(RWPagingCellSelectedAnimationBlock)block;

- (void)startSelectedAnimationIfNeeded:(RWPagingBaseCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END

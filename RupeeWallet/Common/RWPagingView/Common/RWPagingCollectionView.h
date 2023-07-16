//
//  RWPagingCollectionView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import "RWPagingIndicatorProtocol.h"

@class RWPagingCollectionView;

NS_ASSUME_NONNULL_BEGIN

@protocol RWPagingCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)categoryCollectionView:(RWPagingCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)categoryCollectionView:(RWPagingCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end


@interface RWPagingCollectionView : UICollectionView
@property (nonatomic, strong) NSArray <UIView<RWPagingIndicatorProtocol> *> *indicators;
@property (nonatomic, weak) id<RWPagingCollectionViewGestureDelegate> gestureDelegate;

@end

NS_ASSUME_NONNULL_END

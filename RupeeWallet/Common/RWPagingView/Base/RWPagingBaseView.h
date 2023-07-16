//
//  RWPagingBaseView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import "RWPagingBaseCell.h"
#import "RWPagingBaseCellModel.h"
#import "RWPagingCollectionView.h"
#import "RWPagingViewDefines.h"

@class RWPagingBaseView;

NS_ASSUME_NONNULL_BEGIN

@protocol RWPagingViewListContainer <NSObject>
- (void)setDefaultSelectedIndex:(NSInteger)index;
- (UIScrollView *)contentScrollView;
- (void)reloadData;
- (void)didClickSelectedItemAtIndex:(NSInteger)index;
@end

@protocol RWPagingViewDelegate <NSObject>

@optional
- (void)categoryView:(RWPagingBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index;
- (void)categoryView:(RWPagingBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index;
- (void)categoryView:(RWPagingBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index;
- (BOOL)categoryView:(RWPagingBaseView *)categoryView canClickItemAtIndex:(NSInteger)index;
- (void)categoryView:(RWPagingBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio;

@end

@interface RWPagingBaseView : UIView
@property (nonatomic, strong, readonly) RWPagingCollectionView *collectionView;

@property (nonatomic, strong) NSArray <RWPagingBaseCellModel *> *dataSource;

@property (nonatomic, weak) id<RWPagingViewDelegate> delegate;
@property (nonatomic, weak) id<RWPagingViewListContainer> listContainer;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, assign) NSInteger defaultSelectedIndex;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, assign, getter=isContentScrollViewClickTransitionAnimationEnabled) BOOL contentScrollViewClickTransitionAnimationEnabled;
@property (nonatomic, assign) CGFloat contentEdgeInsetLeft;
@property (nonatomic, assign) CGFloat contentEdgeInsetRight;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellWidthIncrement;
@property (nonatomic, assign) CGFloat cellSpacing;
@property (nonatomic, assign, getter=isAverageCellSpacingEnabled) BOOL averageCellSpacingEnabled;
@property (nonatomic, assign, getter=isCellWidthZoomEnabled) BOOL cellWidthZoomEnabled;
@property (nonatomic, assign, getter=isCellWidthZoomScrollGradientEnabled) BOOL cellWidthZoomScrollGradientEnabled;
@property (nonatomic, assign) CGFloat cellWidthZoomScale;
@property (nonatomic, assign, getter=isSelectedAnimationEnabled) BOOL selectedAnimationEnabled;
@property (nonatomic, assign) NSTimeInterval selectedAnimationDuration;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)reloadData;
- (void)reloadDataWithoutListContainer;
- (void)reloadCellAtIndex:(NSInteger)index;
@end

@interface RWPagingBaseView (UISubclassingBaseHooks)
- (CGRect)getTargetCellFrame:(NSInteger)targetIndex;
- (CGRect)getTargetSelectedCellFrame:(NSInteger)targetIndex selectedType:(RWPagingCellSelectedType)selectedType;
- (void)initializeData NS_REQUIRES_SUPER;
- (void)initializeViews NS_REQUIRES_SUPER;
- (void)refreshDataSource;
- (void)refreshState NS_REQUIRES_SUPER;
- (void)refreshSelectedCellModel:(RWPagingBaseCellModel *)selectedCellModel unselectedCellModel:(RWPagingBaseCellModel *)unselectedCellModel NS_REQUIRES_SUPER;
- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset NS_REQUIRES_SUPER;
- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(RWPagingCellSelectedType)selectedType NS_REQUIRES_SUPER;
- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index;
- (Class)preferredCellClass;
- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index NS_REQUIRES_SUPER;

@end
NS_ASSUME_NONNULL_END

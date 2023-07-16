//
//  RWPagingListContainerView.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import "RWPagingViewDefines.h"
#import "RWPagingBaseView.h"
@class RWPagingListContainerView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RWPagingListContainerType) {
    RWPagingListContainerType_ScrollView,
    RWPagingListContainerType_CollectionView,
};

@protocol RWPagingListContentViewDelegate <NSObject>

- (UIView *)listView;

@optional

- (void)listWillAppear;
- (void)listDidAppear;
- (void)listWillDisappear;
- (void)listDidDisappear;

@end

@protocol RWPagingListContainerViewDelegate <NSObject>
- (NSInteger)numberOfListsInlistContainerView:(RWPagingListContainerView *)listContainerView;
- (id<RWPagingListContentViewDelegate>)listContainerView:(RWPagingListContainerView *)listContainerView initListForIndex:(NSInteger)index;

@optional
- (Class)scrollViewClassInlistContainerView:(RWPagingListContainerView *)listContainerView;
- (BOOL)listContainerView:(RWPagingListContainerView *)listContainerView canInitListAtIndex:(NSInteger)index;
- (void)listContainerViewDidScroll:(UIScrollView *)scrollView;
- (void)listContainerViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)listContainerViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)listContainerViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)listContainerViewDidEndDecelerating:(UIScrollView *)scrollView;

@end


@interface RWPagingListContainerView : UIView <RWPagingViewListContainer>

@property (nonatomic, assign, readonly) RWPagingListContainerType containerType;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) NSDictionary <NSNumber *, id<RWPagingListContentViewDelegate>> *validListDict; 
@property (nonatomic, strong) UIColor *listCellBackgroundColor;
@property (nonatomic, assign) CGFloat initListPercent;
@property (nonatomic, assign) BOOL bounces; //默认NO

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithType:(RWPagingListContainerType)type delegate:(id<RWPagingListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@end



NS_ASSUME_NONNULL_END

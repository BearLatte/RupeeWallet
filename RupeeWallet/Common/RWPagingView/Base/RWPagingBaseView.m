//
//  RWPagingBaseView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingBaseView.h"
#import "RWPagingFactory.h"
#import "RWPagingViewAnimator.h"
#import "RTLManager.h"

struct DelegateFlags {
    unsigned int didSelectedItemAtIndexFlag : 1;
    unsigned int didClickSelectedItemAtIndexFlag : 1;
    unsigned int didScrollSelectedItemAtIndexFlag : 1;
    unsigned int canClickItemAtIndexFlag : 1;
    unsigned int scrollingFromLeftIndexToRightIndexFlag : 1;
};

@interface RWPagingBaseView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) RWPagingCollectionView *collectionView;
@property (nonatomic, assign) struct DelegateFlags delegateFlags;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat innerCellSpacing;
@property (nonatomic, assign) CGPoint lastContentViewContentOffset;
@property (nonatomic, strong) RWPagingViewAnimator *animator;
@property (nonatomic, assign) NSInteger scrollingTargetIndex;
@property (nonatomic, assign, getter=isNeedReloadByBecomeActive) BOOL needReloadByBecomeActive;
@property (nonatomic, assign, getter=isFirstLayoutSubviews) BOOL firstLayoutSubviews;
@property (nonatomic, assign, getter=isNeedConfigAutomaticallyAdjustsScrollViewInsets) BOOL needConfigAutomaticallyAdjustsScrollViewInsets;

@end

@implementation RWPagingBaseView
- (void)dealloc {
    if (self.contentScrollView) {
        [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeData];
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeData];
        [self initializeViews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    [self configAutomaticallyAdjustsScrollViewInsets:newSuperview];
}

- (void)reloadData {
    [self reloadDataWithoutListContainer];
    [self.listContainer reloadData];
}

- (void)reloadDataWithoutListContainer {
    [self refreshDataSource];
    [self refreshState];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (void)reloadCellAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.dataSource.count) {
        return;
    }
    RWPagingBaseCellModel *cellModel = self.dataSource[index];
    cellModel.selectedType = RWPagingCellSelectedTypeUnknown;
    [self refreshCellModel:cellModel index:index];
    RWPagingBaseCell *cell = (RWPagingBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell reloadData:cellModel];
}

- (void)selectItemAtIndex:(NSInteger)index {
    [self selectCellAtIndex:index selectedType:RWPagingCellSelectedTypeCode];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //部分使用者为了适配不同的手机屏幕尺寸，RWPagingView的宽高比要求保持一样，所以它的高度就会因为不同宽度的屏幕而不一样。计算出来的高度，有时候会是位数很长的浮点数，如果把这个高度设置给UICollectionView就会触发内部的一个错误。所以，为了规避这个问题，在这里对高度统一向下取整。
    //如果向下取整导致了你的页面异常，请自己重新设置RWPagingView的高度，保证为整数即可。
    CGRect targetFrame = CGRectMake(0, 0, self.bounds.size.width, floor(self.bounds.size.height));
    if (self.isFirstLayoutSubviews) {
        if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
            return;
        }
        if (self.isNeedConfigAutomaticallyAdjustsScrollViewInsets) {
            [self configAutomaticallyAdjustsScrollViewInsets:self.superview];
        }
        self.firstLayoutSubviews = NO;
        self.collectionView.frame = targetFrame;
        [self reloadDataWithoutListContainer];
    }else {
        if (!CGRectEqualToRect(self.collectionView.frame, targetFrame)) {
            self.collectionView.frame = targetFrame;
            [self refreshState];
            [self.collectionView.collectionViewLayout invalidateLayout];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - Setter

- (void)setDelegate:(id<RWPagingViewDelegate>)delegate {
    _delegate = delegate;

    _delegateFlags.didSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(categoryView:didSelectedItemAtIndex:)];
    _delegateFlags.didClickSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(categoryView:didClickSelectedItemAtIndex:)];
    _delegateFlags.didScrollSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(categoryView:didScrollSelectedItemAtIndex:)];
    _delegateFlags.canClickItemAtIndexFlag = [delegate respondsToSelector:@selector(categoryView:canClickItemAtIndex:)];
    _delegateFlags.scrollingFromLeftIndexToRightIndexFlag = [delegate respondsToSelector:@selector(categoryView:scrollingFromLeftIndex:toRightIndex:ratio:)];
}

- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    _defaultSelectedIndex = defaultSelectedIndex;

    self.selectedIndex = defaultSelectedIndex;
    [self.listContainer setDefaultSelectedIndex:defaultSelectedIndex];
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView {
    if (_contentScrollView != nil) {
        [_contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _contentScrollView = contentScrollView;

    self.contentScrollView.scrollsToTop = NO;
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setListContainer:(id<RWPagingViewListContainer>)listContainer {
    _listContainer = listContainer;
    [listContainer setDefaultSelectedIndex:self.defaultSelectedIndex];
    self.contentScrollView = [listContainer contentScrollView];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass]) forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RWPagingBaseCellModel *cellModel = self.dataSource[indexPath.item];
    cellModel.selectedType = RWPagingCellSelectedTypeUnknown;
    [(RWPagingBaseCell *)cell reloadData:cellModel];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isTransitionAnimating = NO;
    for (RWPagingBaseCellModel *cellModel in self.dataSource) {
        if (cellModel.isTransitionAnimating) {
            isTransitionAnimating = YES;
            break;
        }
    }
    if (!isTransitionAnimating) {
        //当前没有正在过渡的item，才允许点击选中
        [self clickSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, [self getContentEdgeInsetLeft], 0, [self getContentEdgeInsetRight]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.dataSource[indexPath.item].cellWidth, self.collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.innerCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.innerCellSpacing;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if ((self.contentScrollView.isTracking || self.contentScrollView.isDecelerating)) {
            //只处理用户滚动的情况
            [self contentOffsetOfContentScrollViewDidChanged:contentOffset];
        }
        self.lastContentViewContentOffset = contentOffset;
    }
}

#pragma mark - Private

- (void)configAutomaticallyAdjustsScrollViewInsets:(UIView *)view {
    UIResponder *next = view;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            ((UIViewController *)next).automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
            self.needConfigAutomaticallyAdjustsScrollViewInsets = NO;
            break;
        }
        next = next.nextResponder;
    }
}

- (CGFloat)getContentEdgeInsetLeft {
    if (self.contentEdgeInsetLeft == RWPagingViewAutomaticDimension) {
        return self.innerCellSpacing;
    }
    return self.contentEdgeInsetLeft;
}

- (CGFloat)getContentEdgeInsetRight {
    if (self.contentEdgeInsetRight == RWPagingViewAutomaticDimension) {
        return self.innerCellSpacing;
    }
    return self.contentEdgeInsetRight;
}

- (CGFloat)getCellWidthAtIndex:(NSInteger)index {
    return [self preferredCellWidthAtIndex:index] + self.cellWidthIncrement;
}

- (void)clickSelectItemAtIndex:(NSInteger)index {
    if (self.delegateFlags.canClickItemAtIndexFlag && ![self.delegate categoryView:self canClickItemAtIndex:index]) {
        return;
    }

    [self selectCellAtIndex:index selectedType:RWPagingCellSelectedTypeClick];
}

- (void)scrollSelectItemAtIndex:(NSInteger)index {
    [self selectCellAtIndex:index selectedType:RWPagingCellSelectedTypeScroll];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.isNeedReloadByBecomeActive) {
        self.needReloadByBecomeActive = NO;
        [self reloadData];
    }
}

@end

@implementation RWPagingBaseView (UISubclassingBaseHooks)

- (CGRect)getTargetCellFrame:(NSInteger)targetIndex {
    CGFloat x = [self getContentEdgeInsetLeft];
    for (int i = 0; i < targetIndex; i ++) {
        RWPagingBaseCellModel *cellModel = self.dataSource[i];
        CGFloat cellWidth;
        if (cellModel.isTransitionAnimating && cellModel.isCellWidthZoomEnabled) {
            //正在进行动画的时候，cellWidthCurrentZoomScale是随着动画渐变的，而没有立即更新到目标值
            if (cellModel.isSelected) {
                cellWidth = [self getCellWidthAtIndex:cellModel.index]*cellModel.cellWidthSelectedZoomScale;
            }else {
                cellWidth = [self getCellWidthAtIndex:cellModel.index]*cellModel.cellWidthNormalZoomScale;
            }
        }else {
            cellWidth = cellModel.cellWidth;
        }
        x += cellWidth + self.innerCellSpacing;
    }
    CGFloat width;
    RWPagingBaseCellModel *selectedCellModel = self.dataSource[targetIndex];
    if (selectedCellModel.isTransitionAnimating && selectedCellModel.isCellWidthZoomEnabled) {
        width = [self getCellWidthAtIndex:selectedCellModel.index]*selectedCellModel.cellWidthSelectedZoomScale;
    }else {
        width = selectedCellModel.cellWidth;
    }
    return CGRectMake(x, 0, width, self.bounds.size.height);
}

- (CGRect)getTargetSelectedCellFrame:(NSInteger)targetIndex selectedType:(RWPagingCellSelectedType)selectedType {
    CGFloat x = [self getContentEdgeInsetLeft];
    for (int i = 0; i < targetIndex; i ++) {
        RWPagingBaseCellModel *cellModel = self.dataSource[i];
        x += [self getCellWidthAtIndex:cellModel.index] + self.innerCellSpacing;
    }
    CGFloat cellWidth = 0;
    RWPagingBaseCellModel *selectedCellModel = self.dataSource[targetIndex];
    if (selectedCellModel.cellWidthZoomEnabled) {
        cellWidth = [self getCellWidthAtIndex:targetIndex]*selectedCellModel.cellWidthSelectedZoomScale;
    }else {
        cellWidth = [self getCellWidthAtIndex:targetIndex];
    }
    return CGRectMake(x, 0, cellWidth, self.bounds.size.height);
}

- (void)initializeData {
    _firstLayoutSubviews = YES;
    _dataSource = [NSMutableArray array];
    _selectedIndex = 0;
    _cellWidth = RWPagingViewAutomaticDimension;
    _cellWidthIncrement = 0;
    _cellSpacing = 20;
    _averageCellSpacingEnabled = YES;
    _cellWidthZoomEnabled = NO;
    _cellWidthZoomScale = 1.2;
    _cellWidthZoomScrollGradientEnabled = YES;
    _contentEdgeInsetLeft = RWPagingViewAutomaticDimension;
    _contentEdgeInsetRight = RWPagingViewAutomaticDimension;
    _lastContentViewContentOffset = CGPointZero;
    _selectedAnimationEnabled = NO;
    _selectedAnimationDuration = 0.25;
    _scrollingTargetIndex = -1;
    _contentScrollViewClickTransitionAnimationEnabled = YES;
    _needReloadByBecomeActive = NO;
}

- (void)initializeViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[RWPagingCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[self preferredCellClass] forCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass])];
    if (@available(iOS 10.0, *)) {
        self.collectionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        if ([self.collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    if ([RTLManager supportRTL]) {
        self.collectionView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [RTLManager horizontalFlipView:self.collectionView];
    }
    [self addSubview:self.collectionView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)refreshDataSource {}

- (void)refreshState {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.dataSource.count) {
        self.defaultSelectedIndex = 0;
    }

    self.innerCellSpacing = self.cellSpacing;
    //总的内容宽度（左边距+cell总宽度+总cellSpacing+右边距）
    __block CGFloat totalItemWidth = [self getContentEdgeInsetLeft];
    //总的cell宽度
    CGFloat totalCellWidth = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        RWPagingBaseCellModel *cellModel = self.dataSource[i];
        cellModel.index = i;
        cellModel.cellWidthZoomEnabled = self.cellWidthZoomEnabled;
        cellModel.cellWidthNormalZoomScale = 1;
        cellModel.cellWidthSelectedZoomScale = self.cellWidthZoomScale;
        cellModel.selectedAnimationEnabled = self.selectedAnimationEnabled;
        cellModel.selectedAnimationDuration = self.selectedAnimationDuration;
        cellModel.cellSpacing = self.innerCellSpacing;
        if (i == self.selectedIndex) {
            cellModel.selected = YES;
            cellModel.cellWidthCurrentZoomScale = cellModel.cellWidthSelectedZoomScale;
        }else {
            cellModel.selected = NO;
            cellModel.cellWidthCurrentZoomScale = cellModel.cellWidthNormalZoomScale;
        }
        if (self.isCellWidthZoomEnabled) {
            cellModel.cellWidth = [self getCellWidthAtIndex:i]*cellModel.cellWidthCurrentZoomScale;
        }else {
            cellModel.cellWidth = [self getCellWidthAtIndex:i];
        }
        totalCellWidth += cellModel.cellWidth;
        if (i == self.dataSource.count - 1) {
            totalItemWidth += cellModel.cellWidth + [self getContentEdgeInsetRight];
        }else {
            totalItemWidth += cellModel.cellWidth + self.innerCellSpacing;
        }
        [self refreshCellModel:cellModel index:i];
    }

    if (self.isAverageCellSpacingEnabled && totalItemWidth < self.bounds.size.width) {
        //如果总的内容宽度都没有超过视图宽度，就将cellSpacing等分
        NSInteger cellSpacingItemCount = self.dataSource.count - 1;
        CGFloat totalCellSpacingWidth = self.bounds.size.width - totalCellWidth;
        //如果内容左边距是Automatic，就加1
        if (self.contentEdgeInsetLeft == RWPagingViewAutomaticDimension) {
            cellSpacingItemCount += 1;
        }else {
            totalCellSpacingWidth -= self.contentEdgeInsetLeft;
        }
        //如果内容右边距是Automatic，就加1
        if (self.contentEdgeInsetRight == RWPagingViewAutomaticDimension) {
            cellSpacingItemCount += 1;
        }else {
            totalCellSpacingWidth -= self.contentEdgeInsetRight;
        }

        CGFloat cellSpacing = 0;
        if (cellSpacingItemCount > 0) {
            cellSpacing = totalCellSpacingWidth/cellSpacingItemCount;
        }
        self.innerCellSpacing = cellSpacing;
        [self.dataSource enumerateObjectsUsingBlock:^(RWPagingBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.cellSpacing = self.innerCellSpacing;
        }];
    }

    //---------------------定位collectionView到当前选中的位置----------------------
    //因为初始化的时候，collectionView并没有初始化完，cell都没有被加载出来。只有自己手动计算当前选中的index的位置，然后更新到contentOffset
    __block CGFloat frameXOfSelectedCell = [self getContentEdgeInsetLeft];
    __block CGFloat selectedCellWidth = 0;
    totalItemWidth = [self getContentEdgeInsetLeft];
    [self.dataSource enumerateObjectsUsingBlock:^(RWPagingBaseCellModel * cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.selectedIndex) {
            frameXOfSelectedCell += cellModel.cellWidth + self.innerCellSpacing;
        }else if (idx == self.selectedIndex) {
            selectedCellWidth = cellModel.cellWidth;
        }
        if (idx == self.dataSource.count - 1) {
            totalItemWidth += cellModel.cellWidth + [self getContentEdgeInsetRight];
        }else {
            totalItemWidth += cellModel.cellWidth + self.innerCellSpacing;
        }
    }];

    CGFloat minX = 0;
    CGFloat maxX = totalItemWidth - self.bounds.size.width;
    CGFloat targetX = frameXOfSelectedCell - self.bounds.size.width/2.0 + selectedCellWidth/2.0;
    [self.collectionView setContentOffset:CGPointMake(MAX(MIN(maxX, targetX), minX), 0) animated:NO];
    //---------------------定位collectionView到当前选中的位置----------------------

    if (CGRectEqualToRect(self.contentScrollView.frame, CGRectZero) && self.contentScrollView.superview != nil) {
        //某些情况系统会出现RWPagingView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现contentScrollView的frame为zero时，强行触发其父视图链里面已经有frame的一个父视图的layoutSubviews方法。
        //比如JXSegmentedListContainerView会将contentScrollView包裹起来使用，该情况需要JXSegmentedListContainerView.superView触发布局更新
        UIView *parentView = self.contentScrollView.superview;
        while (parentView != nil && CGRectEqualToRect(parentView.frame, CGRectZero)) {
            parentView = parentView.superview;
        }
        [parentView setNeedsLayout];
        [parentView layoutIfNeeded];
    }
    //将contentScrollView的contentOffset定位到当前选中index的位置
    [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.bounds.size.width, 0) animated:NO];
}

- (BOOL)selectCellAtIndex:(NSInteger)targetIndex selectedType:(RWPagingCellSelectedType)selectedType {
    if (targetIndex < 0 || targetIndex >= self.dataSource.count) {
        return NO;
    }

    self.needReloadByBecomeActive = NO;
    if (self.selectedIndex == targetIndex) {
        //目标index和当前选中的index相等，就不需要处理后续的选中更新逻辑，只需要回调代理方法即可。
        if (selectedType == RWPagingCellSelectedTypeCode) {
            [self.listContainer didClickSelectedItemAtIndex:targetIndex];
        }else if (selectedType == RWPagingCellSelectedTypeClick) {
            [self.listContainer didClickSelectedItemAtIndex:targetIndex];
            if (self.delegateFlags.didClickSelectedItemAtIndexFlag) {
                [self.delegate categoryView:self didClickSelectedItemAtIndex:targetIndex];
            }
        }else if (selectedType == RWPagingCellSelectedTypeScroll) {
            if (self.delegateFlags.didScrollSelectedItemAtIndexFlag) {
                [self.delegate categoryView:self didScrollSelectedItemAtIndex:targetIndex];
            }
        }
        if (self.delegateFlags.didSelectedItemAtIndexFlag) {
            [self.delegate categoryView:self didSelectedItemAtIndex:targetIndex];
        }
        self.scrollingTargetIndex = -1;
        return NO;
    }

    //通知子类刷新当前选中的和将要选中的cellModel
    RWPagingBaseCellModel *lastCellModel = self.dataSource[self.selectedIndex];
    lastCellModel.selectedType = selectedType;
    RWPagingBaseCellModel *selectedCellModel = self.dataSource[targetIndex];
    selectedCellModel.selectedType = selectedType;
    [self refreshSelectedCellModel:selectedCellModel unselectedCellModel:lastCellModel];

    //刷新当前选中的和将要选中的cell
    RWPagingBaseCell *lastCell = (RWPagingBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    [lastCell reloadData:lastCellModel];
    RWPagingBaseCell *selectedCell = (RWPagingBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]];
    [selectedCell reloadData:selectedCellModel];

    if (self.scrollingTargetIndex != -1 && self.scrollingTargetIndex != targetIndex) {
        RWPagingBaseCellModel *scrollingTargetCellModel = self.dataSource[self.scrollingTargetIndex];
        scrollingTargetCellModel.selected = NO;
        scrollingTargetCellModel.selectedType = selectedType;
        [self refreshSelectedCellModel:selectedCellModel unselectedCellModel:scrollingTargetCellModel];
        RWPagingBaseCell *scrollingTargetCell = (RWPagingBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.scrollingTargetIndex inSection:0]];
        [scrollingTargetCell reloadData:scrollingTargetCellModel];
    }

    if (self.isCellWidthZoomEnabled) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        //延时为了解决cellwidth变化，点击最后几个cell，scrollToItem会出现位置偏移bu。需要等cellWidth动画渐变结束后再滚动到index的cell位置。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.selectedAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }

    if (selectedType == RWPagingCellSelectedTypeClick ||
        selectedType == RWPagingCellSelectedTypeCode) {
        [self.contentScrollView setContentOffset:CGPointMake(targetIndex*self.contentScrollView.bounds.size.width, 0) animated:self.isContentScrollViewClickTransitionAnimationEnabled];
    }

    self.selectedIndex = targetIndex;
    if (selectedType == RWPagingCellSelectedTypeCode) {
        [self.listContainer didClickSelectedItemAtIndex:targetIndex];
    } else if (selectedType == RWPagingCellSelectedTypeClick) {
        [self.listContainer didClickSelectedItemAtIndex:targetIndex];
        if (self.delegateFlags.didClickSelectedItemAtIndexFlag) {
            [self.delegate categoryView:self didClickSelectedItemAtIndex:targetIndex];
        }
    } else if(selectedType == RWPagingCellSelectedTypeScroll) {
        if (self.delegateFlags.didScrollSelectedItemAtIndexFlag) {
            [self.delegate categoryView:self didScrollSelectedItemAtIndex:targetIndex];
        }
    }
    if (self.delegateFlags.didSelectedItemAtIndexFlag) {
        [self.delegate categoryView:self didSelectedItemAtIndex:targetIndex];
    }
    self.scrollingTargetIndex = -1;

    return YES;
}


- (void)refreshSelectedCellModel:(RWPagingBaseCellModel *)selectedCellModel unselectedCellModel:(RWPagingBaseCellModel *)unselectedCellModel {
    selectedCellModel.selected = YES;
    unselectedCellModel.selected = NO;

    if (self.isCellWidthZoomEnabled) {
        if (selectedCellModel.selectedType == RWPagingCellSelectedTypeCode ||
            selectedCellModel.selectedType == RWPagingCellSelectedTypeClick) {
            self.animator = [[RWPagingViewAnimator alloc] init];
            self.animator.duration = self.selectedAnimationDuration;
            __weak typeof(self) weakSelf = self;
            self.animator.progressCallback = ^(CGFloat percent) {
                selectedCellModel.transitionAnimating = YES;
                unselectedCellModel.transitionAnimating = YES;
                selectedCellModel.cellWidthCurrentZoomScale = [RWPagingFactory interpolationFrom:selectedCellModel.cellWidthNormalZoomScale to:selectedCellModel.cellWidthSelectedZoomScale percent:percent];
                selectedCellModel.cellWidth = [weakSelf getCellWidthAtIndex:selectedCellModel.index] * selectedCellModel.cellWidthCurrentZoomScale;
                unselectedCellModel.cellWidthCurrentZoomScale = [RWPagingFactory interpolationFrom:unselectedCellModel.cellWidthSelectedZoomScale to:unselectedCellModel.cellWidthNormalZoomScale percent:percent];
                unselectedCellModel.cellWidth = [weakSelf getCellWidthAtIndex:unselectedCellModel.index] * unselectedCellModel.cellWidthCurrentZoomScale;
                [weakSelf.collectionView.collectionViewLayout invalidateLayout];
            };
            self.animator.completeCallback = ^{
                selectedCellModel.transitionAnimating = NO;
                unselectedCellModel.transitionAnimating = NO;
            };
            [self.animator start];
        } else {
            selectedCellModel.cellWidthCurrentZoomScale = selectedCellModel.cellWidthSelectedZoomScale;
            selectedCellModel.cellWidth = [self getCellWidthAtIndex:selectedCellModel.index] * selectedCellModel.cellWidthCurrentZoomScale;
            unselectedCellModel.cellWidthCurrentZoomScale = unselectedCellModel.cellWidthNormalZoomScale;
            unselectedCellModel.cellWidth = [self getCellWidthAtIndex:unselectedCellModel.index] * unselectedCellModel.cellWidthCurrentZoomScale;
        }
    }
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    if (self.dataSource.count == 0) {
        return;
    }
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    if (contentOffset.x == 0 && self.selectedIndex == 0 && self.lastContentViewContentOffset.x == 0) {
        //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
        return;
    }
    CGFloat maxContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width;
    if (contentOffset.x == maxContentOffsetX && self.selectedIndex == self.dataSource.count - 1 && self.lastContentViewContentOffset.x == maxContentOffsetX) {
        //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;

    if (remainderRatio == 0) {
        //快速滑动翻页，用户一直在拖拽contentScrollView，需要更新选中状态
        //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
        if (!(self.lastContentViewContentOffset.x == contentOffset.x && self.selectedIndex == baseIndex)) {
            [self scrollSelectItemAtIndex:baseIndex];
        }
    } else {
        self.needReloadByBecomeActive = YES;
        if (self.animator.isExecuting) {
            [self.animator invalid];
            //需要重置之前animator.progessCallback为处理完的状态
            for (RWPagingBaseCellModel *model in self.dataSource) {
                if (model.isSelected) {
                    model.cellWidthCurrentZoomScale = model.cellWidthSelectedZoomScale;
                    model.cellWidth = [self getCellWidthAtIndex:model.index] * model.cellWidthCurrentZoomScale;
                }else {
                    model.cellWidthCurrentZoomScale = model.cellWidthNormalZoomScale;
                    model.cellWidth = [self getCellWidthAtIndex:model.index] * model.cellWidthCurrentZoomScale;
                }
            }
        }
        //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
        if (fabs(ratio - self.selectedIndex) > 1) {
            NSInteger targetIndex = baseIndex;
            if (ratio < self.selectedIndex) {
                targetIndex = baseIndex + 1;
            }
            [self scrollSelectItemAtIndex:targetIndex];
        }

        if (self.selectedIndex == baseIndex) {
            self.scrollingTargetIndex = baseIndex + 1;
        } else {
            self.scrollingTargetIndex = baseIndex;
        }

        if (self.isCellWidthZoomEnabled && self.isCellWidthZoomScrollGradientEnabled) {
            RWPagingBaseCellModel *leftCellModel = (RWPagingBaseCellModel *)self.dataSource[baseIndex];
            RWPagingBaseCellModel *rightCellModel = (RWPagingBaseCellModel *)self.dataSource[baseIndex + 1];
            leftCellModel.cellWidthCurrentZoomScale = [RWPagingFactory interpolationFrom:leftCellModel.cellWidthSelectedZoomScale to:leftCellModel.cellWidthNormalZoomScale percent:remainderRatio];
            leftCellModel.cellWidth = [self getCellWidthAtIndex:leftCellModel.index] * leftCellModel.cellWidthCurrentZoomScale;
            rightCellModel.cellWidthCurrentZoomScale = [RWPagingFactory interpolationFrom:rightCellModel.cellWidthNormalZoomScale to:rightCellModel.cellWidthSelectedZoomScale percent:remainderRatio];
            rightCellModel.cellWidth = [self getCellWidthAtIndex:rightCellModel.index] * rightCellModel.cellWidthCurrentZoomScale;
            [self.collectionView.collectionViewLayout invalidateLayout];
        }

        if (self.delegateFlags.scrollingFromLeftIndexToRightIndexFlag) {
            [self.delegate categoryView:self scrollingFromLeftIndex:baseIndex toRightIndex:baseIndex + 1 ratio:remainderRatio];
        }
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    return 0;
}

- (Class)preferredCellClass {
    return RWPagingBaseCell.class;
}

- (void)refreshCellModel:(RWPagingBaseCellModel *)cellModel index:(NSInteger)index {

}
@end

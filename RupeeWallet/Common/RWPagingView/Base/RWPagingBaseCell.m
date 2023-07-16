//
//  RWPagingBaseCell.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingBaseCell.h"
#import "RTLManager.h"

@interface RWPagingBaseCell()
@property (nonatomic, strong) RWPagingBaseCellModel *cellModel;
@property (nonatomic, strong) RWPagingViewAnimator *animator;
@property (nonatomic, strong) NSMutableArray <RWPagingCellSelectedAnimationBlock> *animationBlockArray;
@end

@implementation RWPagingBaseCell
#pragma mark - Initialize

- (void)dealloc {
    [self.animator stop];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeViews];
    }
    return self;
}

#pragma mark - Public

- (void)initializeViews {
    _animationBlockArray = [NSMutableArray array];

    [RTLManager horizontalFlipViewIfNeeded:self];
    [RTLManager horizontalFlipViewIfNeeded:self.contentView];
}

- (void)reloadData:(RWPagingBaseCellModel *)cellModel {
    self.cellModel = cellModel;

    if (cellModel.isSelectedAnimationEnabled) {
        [self.animationBlockArray removeLastObject];
        if ([self checkCanStartSelectedAnimation:cellModel]) {
            self.animator = [[RWPagingViewAnimator alloc] init];
            self.animator.duration = cellModel.selectedAnimationDuration;
        } else {
            [self.animator stop];
        }
    }
}

- (BOOL)checkCanStartSelectedAnimation:(RWPagingBaseCellModel *)cellModel {
    BOOL canStartSelectedAnimation = ((cellModel.selectedType == RWPagingCellSelectedTypeCode) || (cellModel.selectedType == RWPagingCellSelectedTypeClick));
    return canStartSelectedAnimation;
}

- (void)addSelectedAnimationBlock:(RWPagingCellSelectedAnimationBlock)block {
    [self.animationBlockArray addObject:block];
}

- (void)startSelectedAnimationIfNeeded:(RWPagingBaseCellModel *)cellModel {
    if (cellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:cellModel]) {
        // 需要更新 isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
        cellModel.transitionAnimating = YES;
        __weak typeof(self)weakSelf = self;
        self.animator.progressCallback = ^(CGFloat percent) {
            for (RWPagingCellSelectedAnimationBlock block in weakSelf.animationBlockArray) {
                block(percent);
            }
        };
        self.animator.completeCallback = ^{
            cellModel.transitionAnimating = NO;
            [weakSelf.animationBlockArray removeAllObjects];
        };
        [self.animator start];
    }
}

@end

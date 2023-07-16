//
//  RWPagingCollectionView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingCollectionView.h"

@interface RWPagingCollectionView()<UIGestureRecognizerDelegate>

@end
@implementation RWPagingCollectionView

- (void)setIndicators:(NSArray<UIView<RWPagingIndicatorProtocol> *> *)indicators {
    for (UIView *indicator in _indicators) {
        [indicator removeFromSuperview];
    }

    _indicators = indicators;

    for (UIView *indicator in indicators) {
        [self addSubview:indicator];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (UIView<RWPagingIndicatorProtocol> *view in self.indicators) {
        [self sendSubviewToBack:view];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(categoryCollectionView:gestureRecognizerShouldBegin:)]) {
        return [self.gestureDelegate categoryCollectionView:self gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(categoryCollectionView:gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate categoryCollectionView:self gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}
@end

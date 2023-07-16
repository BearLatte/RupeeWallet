//
//  RWPagingBaseCellModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RWPagingViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingBaseCellModel : NSObject
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellSpacing;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign, getter=isCellWidthZoomEnabled) BOOL cellWidthZoomEnabled;
@property (nonatomic, assign) CGFloat cellWidthNormalZoomScale;
@property (nonatomic, assign) CGFloat cellWidthCurrentZoomScale;
@property (nonatomic, assign) CGFloat cellWidthSelectedZoomScale;

@property (nonatomic, assign, getter=isSelectedAnimationEnabled) BOOL selectedAnimationEnabled;
@property (nonatomic, assign) NSTimeInterval selectedAnimationDuration;
@property (nonatomic, assign) RWPagingCellSelectedType selectedType;

@property (nonatomic, assign, getter=isTransitionAnimating) BOOL transitionAnimating;
@end

NS_ASSUME_NONNULL_END

//
//  RWPagingViewDefines.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat RWPagingViewAutomaticDimension = -1;

typedef void(^RWPagingCellSelectedAnimationBlock)(CGFloat percent);
typedef void(^RWLoadImageBlock)(UIImageView *imageView, id info);
typedef void(^RWLoadImageCallback)(UIImageView *imageView, NSURL *imageURL);

// 指示器的位置
typedef NS_ENUM(NSUInteger, RWPagingComponentPosition) {
    RWPagingComponentPosition_Bottom,
    RWPagingComponentPosition_Top
};

// cell 被选中的类型
typedef NS_ENUM(NSUInteger, RWPagingCellSelectedType) {
    RWPagingCellSelectedTypeUnknown, // 未知，不是选中（cellForRow方法里面、两个cell过渡时）
    RWPagingCellSelectedTypeClick,   // 点击选中
    RWPagingCellSelectedTypeCode,    // 调用方法 selectItemAtIndex: 选中
    RWPagingCellSelectedTypeScroll   // 通过滚动到某个 cell 选中
};

// cell 标题锚点位置
typedef NS_ENUM(NSUInteger, RWPagingTitleLabelAnchorPointStyle) {
    RWPagingTitleLabelAnchorPointStyleCenter,
    RWPagingTitleLabelAnchorPointStyleTop,
    RWPagingTitleLabelAnchorPointStyleBottom
};

// 指示器滚动样式
typedef NS_ENUM(NSUInteger, RWPagingIndicatorScrollStyle) {
    RWPagingIndicatorScrollStyleSimple,           // 简单滚动，即从当前位置过渡到目标位置
    RWPagingIndicatorScrollStyleSameAsUserScroll  // 和用户左右滚动列表时的效果一样
};

#define RWPagingViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

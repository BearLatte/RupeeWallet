//
//  RWPagingIndicatorParamsModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RWPagingViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPagingIndicatorParamsModel : NSObject
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGRect selectedCellFrame;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) CGRect leftCellFrame;
@property (nonatomic, assign) NSInteger rightIndex;
@property (nonatomic, assign) CGRect rightCellFrame;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, assign) RWPagingCellSelectedType selectedType;
@end

NS_ASSUME_NONNULL_END

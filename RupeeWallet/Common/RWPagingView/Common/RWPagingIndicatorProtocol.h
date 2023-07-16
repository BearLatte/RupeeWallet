//
//  RWPagingIndicatorProtocol.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RWPagingViewDefines.h"
#import "RWPagingIndicatorParamsModel.h"

@protocol RWPagingIndicatorProtocol <NSObject>

- (void)rw_refreshState:(RWPagingIndicatorParamsModel *)model;

- (void)rw_contentScrollViewDidScroll:(RWPagingIndicatorParamsModel *)model;

- (void)rw_selectedCell:(RWPagingIndicatorParamsModel *)model;

@end

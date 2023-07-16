//
//  RWPagingViewAnimator.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RWProgressCallback)(CGFloat percent);
typedef void(^RWCompleteCallback) (void);

@interface RWPagingViewAnimator : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) RWProgressCallback _Nullable progressCallback;
@property (nonatomic, copy) RWCompleteCallback _Nullable completeCallback;
@property (readonly, getter=isExecuting) BOOL executing;

- (void)start;
- (void)stop;
- (void)invalid;
@end

NS_ASSUME_NONNULL_END

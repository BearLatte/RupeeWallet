//
//  RWFeedbackModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWFeedbackModel : NSObject
@property(nonatomic, copy) NSString *_Nullable phone;
@property(nonatomic, copy) NSString *_Nullable logo;
@property(nonatomic, copy) NSString *_Nullable loanName;
@property(nonatomic, copy) NSString *_Nullable feedBackType;
@property(nonatomic, copy) NSString *_Nullable feedBackContent;
@property(nonatomic, copy) NSString *_Nullable feedBackImg;
@property(nonatomic, copy) NSString *_Nullable feedBackReply;
@property(nonatomic, copy) NSString *_Nullable replyTime;
@property(nonatomic, assign) NSInteger replyNum;
@property(nonatomic, copy) NSString *_Nullable createTime;
@end

NS_ASSUME_NONNULL_END

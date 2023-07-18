//
//  RWSelectionableModel.h
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWSelectionableModel : NSObject
@property(nonatomic, copy) NSString *_Nullable logo;
@property(nonatomic, copy) NSString *_Nullable title;
@property(nonatomic, assign, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END

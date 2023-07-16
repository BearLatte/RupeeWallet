//
//  RWPagingTitleCellModel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/15.
//

#import "RWPagingTitleCellModel.h"

@implementation RWPagingTitleCellModel
- (void)setTitle:(NSString *)title {
    _title = title;

    [self updateNumberSizeWidthIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;

    [self updateNumberSizeWidthIfNeeded];
}

- (void)updateNumberSizeWidthIfNeeded {
    if (self.titleFont) {
        _titleHeight = [self.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.height;
    }
}

@end

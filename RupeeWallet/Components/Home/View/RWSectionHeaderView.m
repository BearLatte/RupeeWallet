//
//  RWSectionHeaderView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/6.
//

#import "RWSectionHeaderView.h"
@interface RWSectionHeaderView()
@property(nonatomic, weak) UIImageView *imageView;
@end

@implementation RWSectionHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bgView;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_header_img"]];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        self.imageView = imgView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
    }];
}

@end

//
//  RWGenderSelectView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import "RWGenderSelectView.h"

@interface RWGenderSelectView()
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIView  *thumbView;
@property(nonatomic, weak) UIView  *sliderBackgroundView;
@property(nonatomic, weak) UILabel *maleLabel;
@property(nonatomic, weak) UILabel *femaleLabel;
@end

@implementation RWGenderSelectView

+ (instancetype)genderView {
    RWGenderSelectView *genderView = [[RWGenderSelectView alloc] init];
    genderView.gender = RWGenderMale;
    return genderView;
}

- (void)setGender:(RWGender)gender {
    _gender = gender;
    
    
    
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self.thumbView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@44);
            if(gender == RWGenderMale) {
                make.left.equalTo(@0);
            } else {
                make.left.equalTo(@(self.sliderBackgroundView.frame.size.width - 44));
            }
        }];
        [self.thumbView.superview layoutIfNeeded];
    }];
    
    
    
    if(gender == RWGenderMale) {
        self.maleLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
        self.femaleLabel.textColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
    } else {
        self.maleLabel.textColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR];
        self.femaleLabel.textColor = [UIColor colorWithHexString:THEME_COLOR];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.gender = RWGenderMale;
        
        UILabel *title = [[RWGlobal sharedGlobal] createLabelWithText:@"Gender" font:[UIFont systemFontOfSize:16] textColor:FORM_TITLE_TEXT_COLOR];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        self.titleLabel = title;
        
        UILabel *male = [[RWGlobal sharedGlobal] createLabelWithText:@"male" font:[UIFont systemFontOfSize:16] textColor:THEME_COLOR];
        male.textAlignment = NSTextAlignmentCenter;
        [self addSubview:male];
        self.maleLabel = male;
        
        UILabel *female = [[RWGlobal sharedGlobal] createLabelWithText:@"female" font:[UIFont systemFontOfSize:16] textColor:NORMAL_BORDER_COLOR];
        female.textAlignment = NSTextAlignmentCenter;
        [self addSubview:female];
        self.femaleLabel = female;
        
        
        UIView *sliderBg = [[UIView alloc] init];
        sliderBg.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        sliderBg.layer.cornerRadius = 14;
        sliderBg.layer.masksToBounds = YES;
        [self addSubview:sliderBg];
        self.sliderBackgroundView = sliderBg;
        
        
        UIView *thumb = [[UIView alloc] init];
        thumb.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
        thumb.layer.cornerRadius = 14;
        thumb.layer.masksToBounds = YES;
        [self.sliderBackgroundView addSubview:thumb];
        self.thumbView = thumb;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbViewTapped:)];
        [thumb addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.equalTo(@0);
        make.height.equalTo(@26);
    }];
    
    [self.maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(@0);
        make.size.equalTo(@(CGSizeMake(100, 44)));
    }];
    
    [self.femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maleLabel);
        make.right.equalTo(@0);
        make.size.equalTo(self.maleLabel);
    }];
    
    [self.sliderBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.maleLabel.mas_right);
        make.right.equalTo(self.femaleLabel.mas_left);
        make.height.equalTo(@44);
        make.bottom.equalTo(@0).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    
}

- (void)thumbViewTapped:(UITapGestureRecognizer *)tap {
    [RWADJTrackTool trackingWithPoint:@"bt6dr7"];
    if(self.gender == RWGenderMale) {
        self.gender = RWGenderFemale;
    } else {
        self.gender = RWGenderMale;
    }
}
@end

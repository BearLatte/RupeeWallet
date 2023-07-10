//
//  RWOCRCameraPanel.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/10.
//

#import "RWOCRCameraPanel.h"

@interface RWOCRCameraPanel()
@property(nonatomic, weak) UIImageView *dashedView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *frontButtonView;
@property(nonatomic, weak) UIImageView *backButtonView;
@property(nonatomic, weak) UILabel *frontIndicatorView;
@property(nonatomic, weak) UILabel *backIndicatorView;
@end

@implementation RWOCRCameraPanel
- (void)setOcrType:(RWOCRType)ocrType {
    _ocrType = ocrType;
    if(ocrType == RWOCRTypePanCardFront) {
        self.frontIndicatorView.text = @"Pan card Front";
        [self.backButtonView removeFromSuperview];
        [self.backIndicatorView removeFromSuperview];
    } else {
        self.frontIndicatorView.text = @"Aadhaar Card Front";
        self.backIndicatorView.text = @"Aadhaar Card Back";
    }
    
    [self layoutIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIImageView *dashed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotted_line"]];
        dashed.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:dashed];
        self.dashedView = dashed;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"Clear & original documents";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:INDICATOR_TEXT_COLOR];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *fronView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_panel"]];
        fronView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:fronView];
        self.frontButtonView = fronView;
        
        UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_panel"]];
        fronView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:backView];
        self.backButtonView = backView;
        
        UILabel *frontIndicator = [[UILabel alloc] init];
        frontIndicator.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        frontIndicator.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self addSubview:frontIndicator];
        self.frontIndicatorView = frontIndicator;
        
        UILabel *backIndicator = [[UILabel alloc] init];
        backIndicator.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
        backIndicator.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self addSubview:backIndicator];
        self.backIndicatorView = backIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(self.ocrType != RWOCRTypePanCardFront) {
        [self.dashedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dashedView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self);
    }];
    
    if(self.ocrType == RWOCRTypePanCardFront) {
        [self.frontButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.centerX.equalTo(self);
        }];
    } else {
        [self.frontButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.left.equalTo(@12);
            make.right.equalTo(self.mas_centerX).offset(-3);
            make.height.equalTo(@95);
        }];
        
        [self.backButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frontButtonView);
            make.left.equalTo(self.frontButtonView.mas_right).offset(6);
            make.size.equalTo(self.frontButtonView);
        }];
    }
    
    [self.frontIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frontButtonView.mas_bottom).offset(2);
        make.height.equalTo(@22);
        make.centerX.equalTo(self.frontButtonView);
        make.bottom.equalTo(@0).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    [self.backIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.frontIndicatorView);
        make.centerX.equalTo(self.backButtonView);
    }];
}

@end

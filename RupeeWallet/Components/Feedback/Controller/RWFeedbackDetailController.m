//
//  RWFeedbackDetailController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWFeedbackDetailController.h"
#import "RWPhotosView.h"

@interface RWFeedbackDetailController ()

@end

@implementation RWFeedbackDetailController

- (void)setupUI {
    [super setupUI];
    self.title = @"Detail";
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NAVIGATION_BAR_HEIGHT);
    }];
    
    UIView *replyBgView = [[UIView alloc] init];
    replyBgView.backgroundColor = [UIColor whiteColor];
    replyBgView.layer.cornerRadius = 14;
    replyBgView.layer.masksToBounds = YES;
    [self.contentView addSubview:replyBgView];
    
    UIView *replyTextBgView = [[UIView alloc] init];
    replyTextBgView.layer.cornerRadius = 14;
    replyTextBgView.layer.masksToBounds = YES;
    replyTextBgView.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
    replyTextBgView.layer.borderWidth = 1;
    [replyBgView addSubview:replyTextBgView];
    
    UITextView *replyTextView = [[UITextView alloc] init];
    replyTextView.font = [UIFont systemFontOfSize:14];
    replyTextView.textColor = [UIColor colorWithHexString:INDICATOR_TEXT_COLOR];
    replyTextView.text = self.feedback.feedBackReply;
    replyTextView.backgroundColor = [UIColor clearColor];
    [replyTextBgView addSubview:replyTextView];
    
    UILabel *replyDateLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.feedback.replyTime font:[UIFont systemFontOfSize:14] textColor:PLACEHOLDER_IMAGE_COLOR];
    [replyBgView addSubview:replyDateLabel];
    
    UIView *contentBgView = [[UIView alloc] init];
    contentBgView.backgroundColor = [UIColor whiteColor];
    contentBgView.layer.cornerRadius = 14;
    contentBgView.layer.masksToBounds = YES;
    [self.contentView addSubview:contentBgView];
    
    if(self.feedback.replyNum > 0) {
        [replyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(190);
        }];
        
        [replyTextBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(140);
        }];
        
        [replyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(20);
            make.right.bottom.mas_equalTo(-20);
        }];
        
        [replyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(replyTextBgView.mas_bottom).offset(4);
            make.right.mas_equalTo(-20);
        }];
        
        [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(replyBgView.mas_bottom).offset(14);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
    } else {
        [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
    }
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.layer.cornerRadius = 8;
    logoView.layer.masksToBounds = YES;
    [contentBgView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [logoView sd_setImageWithURL:[NSURL URLWithString:self.feedback.logo] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
    
    UILabel *loanNameLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.feedback.loanName font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [contentBgView addSubview:loanNameLabel];
    [loanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoView.mas_right).offset(10);
        make.centerY.mas_equalTo(logoView);
    }];
    
    UILabel *feebackTypeLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.feedback.feedBackType font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [contentBgView addSubview:feebackTypeLabel];
    [feebackTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoView.mas_bottom).offset(2);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *phoneNumberLabel = [[RWGlobal sharedGlobal] createLabelWithText:[NSString stringWithFormat:@"Phone number : %@", self.feedback.phone] font:[UIFont systemFontOfSize:16] textColor:THEME_TEXT_COLOR];
    [contentBgView addSubview:phoneNumberLabel];
    [phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(feebackTypeLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    
    UIView *contentTextBgView = [[UIView alloc] init];
    contentTextBgView.layer.cornerRadius = 14;
    contentTextBgView.layer.masksToBounds = YES;
    contentTextBgView.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
    contentTextBgView.layer.borderWidth = 1;
    [contentBgView addSubview:contentTextBgView];
    [contentTextBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneNumberLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    NSData *imagesData = [self.feedback.feedBackImg mj_JSONData];
    NSArray *images = [imagesData mj_JSONObject];
    
    UILabel *contentLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.feedback.feedBackContent font:[UIFont systemFontOfSize:16] textColor:INDICATOR_TEXT_COLOR];
    contentLabel.numberOfLines = 0;
    [contentTextBgView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_greaterThanOrEqualTo(60);
        if(images.count == 0) {
            make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
        }
    }];
    
    if(images.count > 0) {
        RWPhotosView *photosView = [RWPhotosView photosViewWithStyle:RWPhotosViewStylePreview maxItem:9];
        photosView.imageUrls = images.mutableCopy;
        [contentTextBgView addSubview:photosView];
        [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
        }];
    }
    
    
    UILabel *contentDateLabel = [[RWGlobal sharedGlobal] createLabelWithText:self.feedback.createTime font:[UIFont systemFontOfSize:16] textColor:TAB_BAR_NORMAL_FOREGROUND_COLOR];
    [contentBgView addSubview:contentDateLabel];
    [contentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentTextBgView.mas_bottom).offset(4);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
}

@end

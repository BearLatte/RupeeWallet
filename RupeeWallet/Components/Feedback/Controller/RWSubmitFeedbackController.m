//
//  RWSubmitFeedbackController.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWSubmitFeedbackController.h"
#import "RWFormInputView.h"
#import "RWProblemToastView.h"
#import "RWSelectionableModel.h"
#import "UITextView+Extension.h"
#import "RWPhotosView.h"

@interface RWSubmitFeedbackController ()

@property(nonatomic, strong) RWProductModel *_Nullable selectedProduct;
@property(nonatomic, copy) NSString *_Nullable selectedFeedbackType;

@property(nonatomic, weak) RWFormInputView *productChooseView;
@property(nonatomic, weak) RWFormInputView *problemTypeChooseView;
@property(nonatomic, weak) UITextView *feedBackContentTextView;
@property(nonatomic, weak) RWPhotosView *photosView;
@end

@implementation RWSubmitFeedbackController
- (void)setupUI {
    [super setupUI];
    self.title = @"Submit feedback";
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:THEME_COLOR];
    [self.view insertSubview:topView atIndex:0];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    UILabel *tipLabel = [[RWGlobal sharedGlobal] createLabelWithText:@"Please describe your problems in detail. Good app.I hope it can be more convenient." font:[UIFont systemFontOfSize:16] textColor:@"#ffffff"];
    tipLabel.numberOfLines = 0;
    [topView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT + 12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.layer.cornerRadius = 10;
    self.scrollView.layer.masksToBounds = YES;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-(BOTTOM_SAFE_AREA + 10));
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(0).priority(MASLayoutPriorityDefaultHigh);
    }];
    
    UILabel *phoneLabel = [[RWGlobal sharedGlobal] createLabelWithText:[NSString stringWithFormat:@"Phone number : %@", [RWGlobal sharedGlobal].currentPhoneNumber] font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] textColor:THEME_TEXT_COLOR];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
    
    __weak RWSubmitFeedbackController *weakSelf = self;
    
    RWFormInputView *productChooseView = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Loan Product" placeholder:@"Loan Product" keyboardType:UIKeyboardTypeDefault tapAction:^{
        NSMutableArray *list = @[].mutableCopy;
        for (RWProductModel *product in self.feedbackParams.loanProductList) {
            RWSelectionableModel *model = [[RWSelectionableModel alloc] init];
            model.logo = product.logo;
            model.title = product.loanName;
            [list addObject:model];
        }
        [RWProblemToastView showToastWithTitle:@"Loan Product" list:list didSelectedAction:^(NSInteger selectedIndex) {
            weakSelf.selectedProduct = self.feedbackParams.loanProductList[selectedIndex];
        }];
    } didEndEditingAction:nil];
    [self.contentView addSubview:productChooseView];
    [productChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLabel.mas_bottom);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    self.productChooseView = productChooseView;
    
    RWFormInputView *problemTypeChooseView = [RWFormInputView inputViewWithInputType:RWFormInputViewTypeList title:@"Type of problem" placeholder:@"Type of problem" keyboardType:UIKeyboardTypeDefault tapAction:^{
        NSMutableArray *list = @[].mutableCopy;
        for (NSString *type in self.feedbackParams.feedBackTypeList) {
            RWSelectionableModel *model = [[RWSelectionableModel alloc] init];
            model.title = type;
            [list addObject:model];
        }
        [RWProblemToastView showToastWithTitle:@"Loan Product" list:list didSelectedAction:^(NSInteger selectedIndex) {
            weakSelf.selectedFeedbackType = self.feedbackParams.feedBackTypeList[selectedIndex];
        }];
    } didEndEditingAction:nil];
    [self.contentView addSubview:problemTypeChooseView];
    [problemTypeChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(productChooseView.mas_bottom);
        make.left.right.mas_equalTo(productChooseView);
    }];
    self.problemTypeChooseView = problemTypeChooseView;
    
    UIView *feedbackContentBgView = [[UIView alloc] init];
    feedbackContentBgView.layer.cornerRadius = 14;
    feedbackContentBgView.layer.masksToBounds = YES;
    feedbackContentBgView.layer.borderColor = [UIColor colorWithHexString:NORMAL_BORDER_COLOR].CGColor;
    feedbackContentBgView.layer.borderWidth = 1;
    [self.contentView addSubview:feedbackContentBgView];
    [feedbackContentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.problemTypeChooseView.mas_bottom).offset(20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor colorWithHexString:THEME_TEXT_COLOR];
    textView.scrollEnabled = NO;
    [feedbackContentBgView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_greaterThanOrEqualTo(60);
    }];
    [textView setPlaceholderWithText:@"Please enter problem description" placeholderColor:PLACEHOLDER_IMAGE_COLOR];
    self.feedBackContentTextView = textView;
    
    RWPhotosView *photosView = [RWPhotosView photosViewWithStyle:RWPhotosViewStyleUpload maxItem:9];
    [feedbackContentBgView addSubview:photosView];
    [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20).priority(MASLayoutPriorityDefaultHigh);
    }];
    self.photosView = photosView;
    
    UIButton *submitBtn = [[RWGlobal sharedGlobal] createThemeButtonWithTitle:@"Submit" cornerRadius:30];
    [self.contentView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(feedbackContentBgView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(240, 60));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView).offset(-(BOTTOM_SAFE_AREA + 10)).priority(MASLayoutPriorityDefaultHigh);
    }];
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectedProduct:(RWProductModel *)selectedProduct {
    _selectedProduct = selectedProduct;
    self.productChooseView.inputedText = selectedProduct.loanName;
}

- (void)setSelectedFeedbackType:(NSString *)selectedFeedbackType {
    _selectedFeedbackType = selectedFeedbackType;
    self.problemTypeChooseView.inputedText = selectedFeedbackType;
}

- (void)submitBtnAction {
    if(!self.selectedProduct) {
        [RWProgressHUD showInfoWithStatus:@"Loan Product can not be empty"];
        return;
    }
    
    if(!(self.selectedFeedbackType.length > 0)) {
        [RWProgressHUD showInfoWithStatus:@"Type of problem can not be empty"];
        return;
    }
    
    if(!(self.feedBackContentTextView.text.length > 0)) {
        [RWProgressHUD showInfoWithStatus:@"Problem description can not be empty"];
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"phone"] = self.feedbackParams.phone;
    params[@"feedBackType"] = self.selectedFeedbackType;
    params[@"feedBackContent"] = self.feedBackContentTextView.text;
    params[@"productId"] = self.selectedProduct.productId;
    params[@"feedBackImg"] = [self.photosView.imageUrls mj_JSONString];
    
    [[RWNetworkService sharedInstance] saveFeedbackWithParameters:params success:^{
        [RWProgressHUD showSuccessWithStatus:@"Save Successed"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
@end

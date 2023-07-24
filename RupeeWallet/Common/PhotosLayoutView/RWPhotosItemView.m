//
//  RWPhotosItemView.m
//  RupeeWallet
//
//  Created by Tim on 2023/7/18.
//

#import "RWPhotosItemView.h"

@interface RWPhotosItemView()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, copy) DeleteBtnAction deleteBtnAction  ;
@end

@implementation RWPhotosItemView

+ (instancetype)itemViewWithIsShowDeleteBtn:(BOOL)isShowDeleteBtn tag:(NSInteger)tag deleteAction:(DeleteBtnAction)deleteBtnAction {
    RWPhotosItemView *itemView = [[RWPhotosItemView alloc] init];
    itemView.deleteBtn.hidden = !isShowDeleteBtn;
    itemView.tag = tag;
    itemView.deleteBtnAction = deleteBtnAction;
    return itemView;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"feedback_delete_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage createImageWithColor:[UIColor colorWithHexString:PLACEHOLDER_IMAGE_COLOR]]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteBtn];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.centerX.mas_equalTo(self);
    }];
}

- (void)deleteBtnClicked {
    if(self.deleteBtnAction) {
        self.deleteBtnAction(self.tag);
    }
}


@end

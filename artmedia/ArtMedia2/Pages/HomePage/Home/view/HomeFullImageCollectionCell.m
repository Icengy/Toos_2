//
//  HomeFullImageCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeFullImageCollectionCell.h"

#import "VideoListModel.h"

@interface HomeFullImageCollectionCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet AMButton *canShoppingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingBtnLeadingConstraint;

@property (weak, nonatomic) IBOutlet AMButton *authBtn;

@property (weak, nonatomic) IBOutlet AMIconImageView *userIconIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *likedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liked_widht;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation HomeFullImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLongPress:)];
    longPress.delegate = self;
    [self.contentIV addGestureRecognizer:longPress];
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _userNameLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _likedLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _authBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    ///
    [_contentIV am_setImageByDefaultCompressWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleToFill];

//    _authBtn.hidden = !_model.is_auth;
    _authBtn.hidden = YES;
    
    if ([ToolUtil isEqualToNonNull:_model.is_include_obj ]  && ![_model.is_include_obj integerValue]) {
        _canShoppingBtn.hidden = YES;
    }else {
        _canShoppingBtn.hidden = NO;
        _canShoppingBtn.backgroundColor = (_model.is_include_obj.integerValue == 1)?Color_RedA(0.8):Color_GreyLightA(0.8);
        if (_authBtn.hidden) {
            _shoppingBtnLeadingConstraint.constant = 8.0f;
        }else {
            _shoppingBtnLeadingConstraint.constant = 8.0f*2+_authBtn.width;
        }
    }
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    [_userIconIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    
    NSString *likeStr = [ToolUtil isEqualToNonNull:_model.like_num replace:@"0"];
    if (likeStr.integerValue > 9999) {
        likeStr = [NSString stringWithFormat:@"%.2fw", likeStr.doubleValue/ 10000];
    }
    _likedLabel.text = likeStr;
    [_likedLabel sizeToFit];
    _liked_widht.constant = _likedLabel.width;
}

- (void)clickToLongPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_clickToShowMenu) _clickToShowMenu(_model);
    }
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![UserInfoManager shareManager].model) {
        return NO;
    }
    return YES;
}

@end

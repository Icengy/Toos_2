//
//  HomeNormalCollectionViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/19.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "HomeNormalCollectionViewCell.h"

#import "VideoListModel.h"

@interface HomeNormalCollectionViewCell () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *conetentIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentIVHeightConstraint;

@property (weak, nonatomic) IBOutlet AMButton *canShoppingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingBtnLeadingConstraint;

@property (weak, nonatomic) IBOutlet AMButton *authBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet AMIconImageView *userIconIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *thumbsCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbsCount_width_constraint;

@end

@implementation HomeNormalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLongPress:)];
    longPress.delegate = self;
	[self addGestureRecognizer:longPress];
	
	_contentLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_userNameLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_thumbsCountLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    self.layer.shadowOffset = CGSizeMake(0, 2);
//    self.layer.shadowColor = RGB(21, 22, 26).CGColor;
//    self.layer.shadowOpacity = 0.05;
//    self.layer.shadowRadius = 4;
//    self.layer.masksToBounds = NO;
    
    _authBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
	[_conetentIV am_setImageByDefaultCompressWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFit];
	
//	_contentIVHeightConstraint.constant = _model.itemSizeModel.imageHeight;
//	_authBtn.hidden = !_model.is_auth;
    _authBtn.hidden = YES;
	
	if ([ToolUtil isEqualToNonNull:_model.is_include_obj]  && _model.is_include_obj.integerValue == 1) {
		_canShoppingBtn.hidden = NO;
	}else {
        _canShoppingBtn.hidden = YES;
	}

    _contentHeightConstraint.constant = _model.itemSizeModel.textHeight;
	_contentLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
	
	[_userIconIV am_setImageByCompress:60.0f withURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    
    NSString *likeNumStr = [ToolUtil isEqualToNonNull:_model.like_num replace:@"0"];
    if (likeNumStr.integerValue > 9999) {
        likeNumStr = [NSString stringWithFormat:@"%.1fw",likeNumStr.doubleValue /10000];
    }else if (likeNumStr.integerValue > 999) {
        likeNumStr = [NSString stringWithFormat:@"%.1fk",likeNumStr.doubleValue /1000];
    }
	_thumbsCountLabel.text = likeNumStr;
    CGSize countSize = [_thumbsCountLabel sizeThatFits:CGSizeZero];
    _thumbsCount_width_constraint.constant = countSize.width;
    
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

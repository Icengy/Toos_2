//
//  HomeToppedCollectionViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/19.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "HomeToppedCollectionViewCell.h"

#import "VideoListModel.h"
#import "NSString+Size.h"

@interface HomeToppedCollectionViewCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *contentIV;
@property (weak, nonatomic) IBOutlet GradientButton *playCountButton;
@property (weak, nonatomic) IBOutlet GradientButton *playTimeLengthButton;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AMIconImageView *userIconIV;

@property (weak, nonatomic) IBOutlet AMButton *collectButton;
@property (weak, nonatomic) IBOutlet AMButton *thumbsButton;
@property (weak, nonatomic) IBOutlet AMButton *buysButton;

@property (weak, nonatomic) IBOutlet AMButton *authBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authBtnTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbsBtnWidthConstraint;

@end

@implementation HomeToppedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToVisit:)];
	_userIconIV.userInteractionEnabled = YES;
	[_userIconIV addGestureRecognizer:tap];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLongPress:)];
    longPress.delegate = self;
	[self addGestureRecognizer:longPress];
	
	_playCountButton.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_playTimeLengthButton.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	
	_titleLabel.font = [UIFont addHanSanSC:17.0f fontType:1];
	_collectButton.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_thumbsButton.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	
	_authBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_authBtn.layer.cornerRadius = 2.0;
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
    
    [_bgView addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(4.0f, 4.0f)];
    [_contentIV addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(4.0f, 4.0f)];
	
	[_contentIV am_setImageByDefaultCompressWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold")];
	[_userIconIV am_setImageByCompress:60.0f withURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	
	[_playCountButton setTitle:[NSString stringWithFormat:@"%@次播放",[ToolUtil isEqualToNonNullKong:_model.play_num]] forState:UIControlStateNormal];
	if ([ToolUtil isEqualToNonNull:_model.video_length ]) {
		[_playTimeLengthButton setTitle:[NSString stringWithFormat:@"%@", [TimeTool timeFormatted:[[ToolUtil isEqualToNonNullKong:_model.video_length] doubleValue]]] forState:UIControlStateNormal];
	}else {
		[_playTimeLengthButton setTitle:@"0:00" forState:UIControlStateNormal];
	}
	
	_titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
	
    _model.collect_num = @"29999";
	_collectButton.selected = _model.iscollect;
	[_collectButton setTitle:[ToolUtil isEqualToNonNull:_model.collect_num replace:@"0"] forState:(UIControlStateNormal | UIControlStateSelected)];
//	[_collectButton setTitle:[ToolUtil isEqualToNonNull:_model.collect_num replace:@"0"] forState:UIControlStateSelected];
    
    CGFloat collectCharWidth = [_collectButton.titleLabel.text sizeWithFont:_collectButton.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _collectButton.height)].width;
    _collectBtnWidthConstraint.constant = 2.0f+ _collectButton.imageView.width + 5.0f + collectCharWidth + 2.0f;
	
	_thumbsButton.selected = _model.islike;
	[_thumbsButton setTitle:[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"] forState:(UIControlStateNormal | UIControlStateSelected)];
//	[_thumbsButton setTitle:[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"] forState:UIControlStateSelected];
    
    CGFloat thumbsCharWidth = [_thumbsButton.titleLabel.text sizeWithFont:_thumbsButton.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _thumbsButton.height)].width;
    _thumbsBtnWidthConstraint.constant = 2.0f+ _thumbsButton.imageView.width + 5.0f + thumbsCharWidth + 2.0f;

	
	if ([ToolUtil isEqualToNonNull:_model.is_include_obj ]  && ![_model.is_include_obj integerValue]) {
		_buysButton.hidden = YES;
	}else {
		_buysButton.hidden = NO;
		_buysButton.selected = [_model.is_include_obj integerValue] - 1;
	}
	
	if (_model.is_auth) {
		_authBtn.hidden = NO;
		if (_buysButton.hidden) {
			_authBtnTrailingConstraint.constant = -8.0f;
		}else {
			_authBtnTrailingConstraint.constant = -(8.0f*2+ _buysButton.width);
		}
	}else {
		_authBtn.hidden = YES;
	}
}

#pragma mark -
- (IBAction)clickToPlay:(AMButton *)sender {
	if (_clickToPlayBlock) _clickToPlayBlock(_model);
}

- (void)clickToVisit:(UIGestureRecognizer *)sender {
	if (_clickToVisitBlock) _clickToVisitBlock(_model);
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

//
//  AMVideoControlIerItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMVideoControlIerItemView.h"

#import "VideoListModel.h"

#import "GKSliderView.h"
#import "GKBallLoadingView.h"

#import "ZFSliderView.h"
#import "ZFUtilities.h"

@interface AMVideoControlIerItemView () <ZFSliderViewDelegate>//UITextFieldDelegate
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundIV;
@property (weak, nonatomic) IBOutlet AMButton *backBtn;
@property (weak, nonatomic) IBOutlet AMButton *moreBtn;

@property (weak, nonatomic) IBOutlet AMButton *goodsBtn;
@property (weak, nonatomic) IBOutlet AMButton *seekGoodsBtn;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet AMIconImageView *userIV;
@property (weak, nonatomic) IBOutlet AMButton *collectBtn;

@property (weak, nonatomic) IBOutlet AMVideoItemButton *likeBtn;
@property (weak, nonatomic) IBOutlet AMVideoItemButton *talkBtn;
@property (weak, nonatomic) IBOutlet AMVideoItemButton *shareBtn;

//@property (weak, nonatomic) IBOutlet AMTextField *inputTF;
//@property (weak, nonatomic) IBOutlet GKSliderView *slider;
@property (weak, nonatomic) IBOutlet ZFSliderView *slider;

@property (weak, nonatomic) IBOutlet AMButton *playBtn;

@property (nonatomic, strong) GKBallLoadingView *loadingView;

@property (weak, nonatomic) IBOutlet UIView *subBgV; //控件视图
@property (weak, nonatomic) IBOutlet UIView *progressBgV; //时间进度view
@property (weak, nonatomic) IBOutlet UILabel *curL; //当前时间
@property (weak, nonatomic) IBOutlet UILabel *totalL;//总时长

@property (assign, nonatomic) CGFloat totalTime;

@end

@implementation AMVideoControlIerItemView

- (GKBallLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [GKBallLoadingView loadingViewInView:self];
    }return _loadingView;
}

#pragma mark -
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.slider.isHideSliderBlock = YES;
    self.slider.sliderHeight = 1.0f;
    self.slider.delegate = self;
    self.slider.maximumTrackTintColor = RGB(53, 54, 57);
    self.slider.minimumTrackTintColor = RGB(224, 82, 39);//
    [self.slider setThumbImage:[UIImage imageNamed:@"slider_red"] forState:UIControlStateNormal];
    self.slider.value = 0;
    
    self.goodsBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.unameLabel.font = [UIFont addHanSanSC:17.0 fontType:2];
    self.descLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.likeBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.talkBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.shareBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToUserIcon:)];
    [self.userIV addGestureRecognizer:tap];
}

#pragma mark -
#pragma mark - getter
- (UIImageView *)coverImgView {
    return self.backgroundIV;
}

- (ZFSliderView *)sliderView {
    return self.slider;
}

#pragma mark -
- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    [self.backgroundIV am_setImageWithURL:_model.image_url placeholderImage:nil contentMode:UIViewContentModeScaleAspectFit];
    self.descLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    self.likeBtn.selected = _model.islike;
    [self.likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    if (_model.like_num.integerValue) {
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"]] forState:UIControlStateNormal];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"]] forState:UIControlStateSelected];
    }
    [self.talkBtn setTitle:@"评论" forState:UIControlStateNormal];
    if (_model.comment_num.integerValue) {
        [self.talkBtn setTitle:[NSString stringWithFormat:@"%@",[ToolUtil isEqualToNonNull:_model.comment_num replace:@"0"]] forState:UIControlStateNormal];
    }

    switch (_model.is_include_obj.integerValue) {
        case 0: {//无商品
            self.goodsBtn.hidden = YES;
            self.seekGoodsBtn.hidden = YES;
            break;
        }
        case 1: {//正常
            if ([ToolUtil isEqualOwner:_model.artModel.ID] || _model.goodsModel.good_sell_type == 0) {
                self.goodsBtn.hidden = YES;
                self.seekGoodsBtn.hidden = NO;
            }else {
                self.goodsBtn.hidden = NO;
                self.seekGoodsBtn.hidden = YES;
            }
            break;
        }
        case 2: {//已售空
            self.goodsBtn.hidden = YES;
            self.seekGoodsBtn.hidden = NO;
            
            break;
        }
            
        default:
            break;
    }

    /// 用户信息部分
    [self.userIV am_setImageWithURL:_model.artModel.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    if ([ToolUtil isEqualToNonNull:_model.artModel.art_name]) {
        self.unameLabel.text = [NSString stringWithFormat:@"@%@", _model.artModel.art_name];
    }else
        self.unameLabel.text = nil;
    
    self.collectBtn.hidden = _model.artModel.is_collect;
    if ([ToolUtil isEqualOwner:_model.artModel.ID]) {
        self.collectBtn.hidden = YES;
    }
    self.slider.isdragging = NO;
    self.progressBgV.hidden = YES;
    self.subBgV.hidden = !self.progressBgV.hidden;
    [self setCurrentTime:0 totalTime:0 progress:0];
}
#pragma mark -
- (void)setProgress:(float)progress {
    self.slider.value = progress;
}

- (void)startLoading {
    [self.loadingView startLoading];
}

- (void)stopLoading {
    [self.loadingView stopLoading];
    [self.loadingView removeFromSuperview];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.curL.text = [NSString stringWithFormat:@"%@ / ",timeString];
    self.slider.isdragging = YES;
}

- (void)setCurrentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress
{
    self.totalTime = totalTime;
    
    if (!self.slider.isdragging) {
        //停止拖动时，播放时
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.curL.text =  currentTime > 0 ? [NSString stringWithFormat:@"%@ / ",currentTimeString] : @"";
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalL.text = totalTime > 0 ? totalTimeString : @"";
        self.slider.value = progress;
    } else {
        if (!self.totalL.text.length) {
            NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
            self.totalL.text = totalTime > 0 ? totalTimeString : @"";
        }
    }

}
#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;


}

- (void)sliderTouchEnded:(float)value {
    if (self.totalTime > 0) {
        NSString *draggedTime = [ZFUtilities convertTimeSecond:self.totalTime*value];
        [self sliderValueChanged:value currentTimeString:draggedTime];

        if (self.sliderDelegate && [self.sliderDelegate respondsToSelector:@selector(sliderTouchEnded:)]) {
            [self.sliderDelegate sliderTouchEnded:self.totalTime*value];
        }
    } else {
        self.slider.value = 0;
    }
    self.slider.isdragging = NO;
    self.subBgV.hidden = NO;
    self.progressBgV.hidden = !self.subBgV.hidden;
    self.slider.isHideSliderBlock = YES;
}

- (void)sliderValueChanged:(float)value {
    
    if (self.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    
    self.progressBgV.hidden = NO;
    self.slider.isHideSliderBlock = NO;
    self.subBgV.hidden = YES;
    self.progressBgV.hidden = !self.subBgV.hidden;
    
    NSString *draggedTime = [ZFUtilities convertTimeSecond:self.totalTime*value];
    [self sliderValueChanged:value currentTimeString:draggedTime];
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickBack:)]) {
        [self.delegate controlViewDidClickBack:self];
    }
}

- (IBAction)clickToMore:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickMore:)]) {
        [self.delegate controlViewDidClickMore:sender];
    }
}

- (IBAction)clickToCollect:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickFollow:)]) {
        [self.delegate controlViewDidClickFollow:sender];
    }
}

- (IBAction)clickToLike:(AMVideoItemButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickLike:)]) {
        [self.delegate controlViewDidClickLike:sender];
    }
}

- (IBAction)clickToTalk:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickTalk:)]) {
        [self.delegate controlViewDidClickTalk:sender];
    }
}

- (IBAction)clickToShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickShare:)]) {
        [self.delegate controlViewDidClickShare:sender];
    }
}

- (IBAction)clickToGoods:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickGoods:)]) {
        [self.delegate controlViewDidClickGoods:sender];
    }
}

- (void)clickToUserIcon:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPersonal:)]) {
        [self.delegate controlViewDidClickPersonal:sender];
    }
}

- (IBAction)controlViewDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:sender];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickCreateTalk:)]) {
        [self.delegate controlViewDidClickCreateTalk:textField];
    }
    return NO;
}

#pragma mark -
- (UIView *)rightView {
    UIView *wrapView = [[UIView alloc] init];
    wrapView.backgroundColor = UIColor.clearColor;
    wrapView.frame = CGRectMake(0, 0, 54.0f, 44.0f);
    AMButton *button = [AMButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(10.0, 0, 44.0f, 44.0f);
    [button setImage:ImageNamed(@"icon-videoDet-planePost") forState:UIControlStateNormal];
    [wrapView addSubview:button];
    return wrapView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSTimeInterval delayTime = 0.3f;
    if (touch.tapCount <= 1) {
        [self performSelector:@selector(controlViewDidClick:) withObject:nil afterDelay:delayTime];
    }
}


@end

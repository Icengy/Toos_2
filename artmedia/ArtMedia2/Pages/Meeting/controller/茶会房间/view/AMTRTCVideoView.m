//
//  AMTRTCVideoView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMTRTCVideoView.h"

#import "AMMeetingRoomMemberModel.h"

@interface AMTRTCVideoTagLabel : UILabel

@end

@implementation AMTRTCVideoTagLabel

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.font = [UIFont addHanSanSC:10.0f fontType:0];
        self.layer.cornerRadius = 8.0f;
        self.clipsToBounds = YES;
    }return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = 16.0f;
    [super setFrame:frame];
}

@end

@interface AMTRTCVideoView ()

@property (weak, nonatomic) IBOutlet UIStackView *tagStackView;
@property (weak, nonatomic) IBOutlet AMTRTCVideoTagLabel *masterTag;
@property (weak, nonatomic) IBOutlet AMTRTCVideoTagLabel *selfTag;
@property (weak, nonatomic) IBOutlet AMButton *networkIdent;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIStackView *buttonStackView;
@property (weak, nonatomic) IBOutlet AMButton *audioBtn;
@property (weak, nonatomic) IBOutlet AMButton *videoBtn;


@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* uname;
@property (nonatomic, assign) VideoViewType type;

@property (nonatomic, assign) CGPoint touchPoint;

@end


@implementation AMTRTCVideoView {
    CAGradientLayer *_gradinentlayer;
}

@dynamic userId;
@dynamic userName;
@dynamic videoType;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)newVideoViewWithType:(VideoViewType)type userId:( NSString  * _Nullable )userId {
    return [[self class] newVideoViewWithType:type userId:userId userName:nil];
}

+ (instancetype)newVideoViewWithType:(VideoViewType)type userId:(NSString *)userId userName:(NSString * )userName {
    AMTRTCVideoView* videoView = (AMTRTCVideoView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    videoView.type = type;
    videoView.uid = userId;
    videoView.uname = userName;
    
    return videoView;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    NSString *imageStr = [NSString stringWithFormat:@"meetingroom-信号-%@", @(arc4random()%4+1)];
    [self.networkIdent setImage:ImageNamed(imageStr) forState:UIControlStateNormal];
    
    self.isShowGradinent = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self addGradineView];
}

#pragma mark - setter / getter
- (void)setUserModel:(AMMeetingRoomMemberModel *)userModel {
    _userModel = userModel;
    self.uid = _userModel.userId;
    self.uname = _userModel.userName;
    
    self.isMaster = (_userModel.isMaster.integerValue%2);
    self.isSelf = [ToolUtil isEqualOwner:_userModel.userId];
    
    self.audioBtn.selected = _userModel.isForbidAudio_Normal;
    self.videoBtn.selected = _userModel.isForbidVideo_Normal;
//    if (_userModel.isMaster.integerValue != 1) {
//        self.audioBtn.enabled = !_userModel.isForbidAudio_Manager;
//        self.videoBtn.enabled = !_userModel.isForbidVideo_Manager;
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadUserStateWithModel:)]) {
        [self.delegate reloadUserStateWithModel:_userModel];
    }
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
}

- (void)setType:(VideoViewType)type {
    _type = type;
}

- (void)setUname:(NSString *)uname {
    _uname = uname;
    NSLog(@"_uname = %@", _uname);
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_uname];
}

- (NSString *)userId {
    return _uid;
}

- (VideoViewType)videoType {
    return _type;
}

- (NSString *)userName {
    return _uname;
}

- (void)setLayoutType:(TCLayoutType)layoutType {
    _layoutType = layoutType;
    /// typeJude = yes 九宫格模式
    BOOL typeJude = (_layoutType == TC_Gird)? YES:NO;
    
    self.nameLabel.font = [UIFont addHanSanSC:typeJude?14.0f:11.0f fontType:0];
    [self.nameLabel adjustsFontSizeToFitWidth];
    
    _audioBtn.hidden = !typeJude;
    _videoBtn.hidden = !typeJude;
    self.isShowNetworkIndicator = typeJude;
}

- (void)setIsMaster:(BOOL)isMaster {
    _isMaster = isMaster;
//    [self changeTag];
}

- (void)setIsSelf:(BOOL)isSelf {
    _isSelf = isSelf;
//    [self changeTag];
}

- (void)setIsShowNetworkIndicator:(BOOL)isShowNetworkIndicator {
    _isShowNetworkIndicator = isShowNetworkIndicator;
    _networkIdent.hidden = !_isShowNetworkIndicator;
}

- (void)setIsShowGradinent:(BOOL)isShowGradinent {
    _isShowGradinent = isShowGradinent;
    
    [self addGradineView];
}

- (void)hiddenTag:(BOOL)hidden {
    if (hidden) {
        _selfTag.hidden = hidden;
        _masterTag.hidden = hidden;
        _nameLabel.hidden = hidden;
    }else
        [self changeTag];
}

- (void)setNetworkIndicatorImage:(UIImage *)image {
    [_networkIdent setImage:image forState:UIControlStateNormal];
}

#pragma mark - prvite
- (void)changeTag {
    _selfTag.hidden = !_isSelf;
    _masterTag.hidden = !_isMaster;
    _nameLabel.hidden = NO;
    if (_isSelf && _isMaster) {
        _masterTag.hidden = YES;
        _selfTag.hidden = NO;
    }
}

-(void)addGradineView {
    
    if (_gradinentlayer) [_gradinentlayer removeFromSuperlayer];
    if (self.isShowGradinent) {
        CAGradientLayer *gradinentlayer = [CAGradientLayer layer];

        gradinentlayer.colors=@[(__bridge id)[UIColorFromRGB(0x000000) colorWithAlphaComponent:0.4f].CGColor,
                                (__bridge id)[UIColorFromRGB(0x000000) colorWithAlphaComponent:0.0f].CGColor];
        //分割点  设置 风电设置不同渐变的效果也不相同
        gradinentlayer.locations = @[@0.0,@1.0];
        gradinentlayer.startPoint = CGPointMake(0.0, 0.0);
        gradinentlayer.endPoint = CGPointMake(0.0, 1.0);
        gradinentlayer.frame = self.bounds;
        _gradinentlayer = gradinentlayer;

        [self.layer addSublayer:_gradinentlayer];
    }
}

#pragma mark -
- (IBAction)onBtnMuteAudioClicked:(AMButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(onMuteAudioBtnClick:stateChanged:)]) {
        [self.delegate onMuteAudioBtnClick:self stateChanged:sender.selected];
    }
}

- (IBAction)onBtnMuteVideoClicked:(AMButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(onMuteVideoBtnClick:stateChanged:)]) {
        [self.delegate onMuteVideoBtnClick:self stateChanged:sender.selected];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchPoint = self.center;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint center = self.center;
    
    if (fabs(center.x - _touchPoint.x) > 0.000001f || fabs(center.y - _touchPoint.y) > 0.0000001f)
        return;
    
    if ([self.delegate respondsToSelector:@selector(onViewTap:touchCount:)]) {
        [self.delegate onViewTap:self touchCount:touches.anyObject.tapCount];
    }
}

@end

//
//  AMMeetingMemberTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingMemberTableCell.h"

#import "AMMeetingMemberModel.h"
#import "AMMeetingRoomMemberModel.h"

@interface AMMeetingMemberTagLabel : UILabel

@end

@implementation AMMeetingMemberTagLabel

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.font = [UIFont addHanSanSC:10.0f fontType:0];
        self.textColor = UIColor.whiteColor;
        self.layer.cornerRadius = 8.0f;
        self.clipsToBounds = YES;
    }return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = 16.0f;
    [super setFrame:frame];
}

@end

@interface AMMeetingMemberTableCell ()

@property (weak, nonatomic) IBOutlet AMIconImageView *userIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIStackView *tagStackView;
@property (weak, nonatomic) IBOutlet AMMeetingMemberTagLabel *myTag;
@property (weak, nonatomic) IBOutlet AMMeetingMemberTagLabel *masterTag;
@property (weak, nonatomic) IBOutlet UIImageView *identifyTag;

@property (weak, nonatomic) IBOutlet UIStackView *buttonStackView;
@property (weak, nonatomic) IBOutlet AMButton *microphoneBtn;
@property (weak, nonatomic) IBOutlet AMButton *cameraBtn;

@end

@implementation AMMeetingMemberTableCell {
    BOOL _isMaster;
    BOOL _isMy;
    BOOL _isArt;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _masterTag.hidden = arc4random()%2;
    _identifyTag.hidden = arc4random()%2;
    _myTag.hidden = arc4random()%2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStyle:(AMMeetingMemberStyle)style {
    _style = style;
    
    _nameLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    _cameraBtn.hidden = NO;
    _microphoneBtn.hidden = NO;
    switch (_style) {
        case AMMeetingMemberStyleDefault: {
            _nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
            _cameraBtn.hidden = YES;
            _microphoneBtn.hidden = YES;
            
            break;
        }
        case AMMeetingMemberStyleNormal: {
            
            [_cameraBtn setImage:ImageNamed(@"meetingroom-camera_off") forState:UIControlStateSelected];
            [_microphoneBtn setImage:ImageNamed(@"meetingroom-microphone_off") forState:UIControlStateSelected];
            break;
        }
        case AMMeetingMemberStyleManager: {
            
            [_cameraBtn setImage:ImageNamed(@"meetingroom-camera_forbid") forState:UIControlStateSelected];
            [_microphoneBtn setImage:ImageNamed(@"meetingroom-microphone_ forbid") forState:UIControlStateSelected];
            break;
        }
            
        default:
            break;
    }
}

- (void)setModel:(AMMeetingMemberModel *)model {
    _model = model;
    [_userIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    
//    _isMaster = [_model.id isEqualToString:_model.createUserId];
    _isMaster = NO;
    _isMy = [ToolUtil isEqualOwner:_model.createUserId];
    _isArt = (_model.utype.integerValue == 3);
    _masterTag.hidden = !_isMaster;
    _myTag.hidden = !_isMy;
    _identifyTag.hidden = !_isArt;
    if (_isMy) {
        _myTag.hidden = NO;
        _masterTag.hidden = YES;
        _identifyTag.hidden = YES;
    }else {
        if (_isMaster) {
            _myTag.hidden = YES;
            _masterTag.hidden = YES;
            _identifyTag.hidden = YES;
        }
    }
}

- (void)setRoomModel:(AMMeetingRoomMemberModel *)roomModel {
    _roomModel = roomModel;
    
    [_userIV am_setImageWithURL:_roomModel.userPhoto placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_roomModel.userName];
    
    _isMaster = (_roomModel.isMaster.integerValue == 1);
    _isMy = [ToolUtil isEqualOwner:_roomModel.userId];
    _isArt = (_roomModel.userType.integerValue == 3);
    _masterTag.hidden = !_isMaster;
    _myTag.hidden = !_isMy;
    _identifyTag.hidden = !_isArt;
    if (_isMy) {
        _myTag.hidden = NO;
        _masterTag.hidden = YES;
        _identifyTag.hidden = YES;
        if (_isMaster && self.style == AMMeetingMemberStyleManager) {
            self.cameraBtn.hidden = YES;
            self.microphoneBtn.hidden = YES;
        }
    }else {
        if (_isMaster) {
            _myTag.hidden = YES;
            _masterTag.hidden = NO;
            _identifyTag.hidden = YES;
        }
    }
    
    if (self.style == AMMeetingMemberStyleNormal) {/// 普通成员列表
        self.cameraBtn.selected = _roomModel.isForbidVideo_Normal;
        self.microphoneBtn.selected = _roomModel.isForbidAudio_Normal;
//        if (!_isMaster) {
//            self.cameraBtn.enabled = !_roomModel.isForbidVideo_Manager;
//            self.microphoneBtn.enabled = !_roomModel.isForbidAudio_Manager;
//        }
    }
    if (!_isMaster && self.style == AMMeetingMemberStyleManager) {
        self.cameraBtn.selected = _roomModel.isForbidVideo_Manager;
        self.microphoneBtn.selected = _roomModel.isForbidAudio_Manager;
    }
}

#pragma mark -
- (IBAction)clickToCamera:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberCell:didSelected:onVideoWithUserID:)]) {
        [self.delegate memberCell:self didSelected:sender onVideoWithUserID:_model.id];
    }
}

- (IBAction)clickToMicrophone:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberCell:didSelected:onAudioWithUserID:)]) {
        [self.delegate memberCell:self didSelected:sender onAudioWithUserID:_model.id];
    }
}

@end

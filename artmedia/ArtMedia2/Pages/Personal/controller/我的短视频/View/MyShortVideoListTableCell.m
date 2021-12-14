//
//  MyShortVideoListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyShortVideoListTableCell.h"

#import "VideoListModel.h"

@interface MyShortVideoListTableCell ()
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *videoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet GradientButton *lengthLabel;


@property (weak, nonatomic) IBOutlet UILabel *authMark;

@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@property (weak, nonatomic) IBOutlet AMButton *editBtn;
@property (weak, nonatomic) IBOutlet AMButton *lookBtn;

@property (weak, nonatomic) IBOutlet UILabel *selledMark;
@property (weak, nonatomic) IBOutlet UILabel *offMark;


@end

@implementation MyShortVideoListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _videoDescLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _timesLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _lengthLabel.titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _lengthLabel.fromColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.0];
    _lengthLabel.toColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.3];
    
    _coverView.backgroundColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.4];
    _coverView.hidden = YES;
    
    _authMark.font = [UIFont addHanSanSC:12.0f fontType:0];
    _selledMark.font = [UIFont addHanSanSC:12.0f fontType:0];
    _offMark.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _deleteBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _editBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _lookBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _lookBtn.hidden = ![UserInfoManager shareManager].isArtist;
    _selledMark.hidden = ![UserInfoManager shareManager].isArtist;
    _authMark.hidden = ![UserInfoManager shareManager].isArtist;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 20.0f;
    [super setFrame:frame];
}

- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    [_videoIV am_setImageWithURL:_model.image_url contentMode:(UIViewContentModeScaleAspectFill)];
    _videoDescLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    [_lengthLabel setTitle:[TimeTool timeFormatted:[[ToolUtil isEqualToNonNull:_model.video_length replace:@"0"] doubleValue]] forState:UIControlStateNormal];
    _timesLabel.text = [NSString stringWithFormat:@"%@次播放",[ToolUtil isEqualToNonNull:_model.play_num replace:@"0"]];
    
    _lookBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    _editBtn.hidden = YES;
    _authMark.hidden = YES;
    _selledMark.hidden = YES;
    _coverView.hidden = YES;
    _offMark.hidden = YES;
    
    if (_model.check_state.integerValue == 3) {/// 审核未通过/下架
        _deleteBtn.hidden = NO;
        _offMark.hidden = NO;
        _coverView.hidden = NO;
    }else {
        _authMark.hidden = ![ToolUtil isEqualToNonNull:_model.auth_code];
        if (![UserInfoManager shareManager].isArtist) {/// 普通用户
            _editBtn.hidden = NO;
            _deleteBtn.hidden = NO;
        }else {/// 艺术家
            if (_model.is_include_obj.integerValue == 2) {/// 作品已售
                _lookBtn.hidden = NO;
                _selledMark.hidden = NO;
                _coverView.hidden = NO;
            }else if (_model.is_include_obj.integerValue == 1) {/// 作品未售
                _lookBtn.hidden = NO;
                _editBtn.hidden = NO;
                _deleteBtn.hidden = NO;
            }else {/// 不包含作品
                _deleteBtn.hidden = NO;
                _editBtn.hidden = NO;
            }
        }
    }
    
}

- (IBAction)clickToDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoCell:didSelectedToDelete:)]) {
        [self.delegate shortVideoCell:self didSelectedToDelete:sender];
    }
}
- (IBAction)clickToEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoCell:didSelectedToEdit:)]) {
        [self.delegate shortVideoCell:self didSelectedToEdit:sender];
    }
}
- (IBAction)clickToLook:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoCell:didSelectedToLookworks:)]) {
        [self.delegate shortVideoCell:self didSelectedToLookworks:sender];
    }
}
- (IBAction)clickToVideoDetail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoCell:didSelectedToDetail:)]) {
        [self.delegate shortVideoCell:self didSelectedToDetail:sender];
    }
}

@end

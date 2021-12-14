//
//  ArtistHeadCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtistHeadCell.h"

@interface ArtistHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImageView;

@property (weak, nonatomic) IBOutlet AMIconView *headerIV;
@property (weak, nonatomic) IBOutlet AMButton *editButton;
@property (weak, nonatomic) IBOutlet AMButton *meetingButton;

@end

@implementation ArtistHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _fansTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _nameLabel.font = [UIFont addHanSanSC:21.0f fontType:2];
    _artTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    _editButton.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _meetingButton.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _meetingButton.backgroundColor = [Color_Whiter colorWithAlphaComponent:0.2f];
    
    self.coverView.backgroundColor = [Color_Black colorWithAlphaComponent:0.0f];
    self.backView.backgroundColor = [Color_Black colorWithAlphaComponent:0.4f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderStatus:(NSInteger)orderStatus{
    _orderStatus = orderStatus;
    
    self.meetingButton.hidden = NO;
    
    if ([ToolUtil isEqualOwner:self.model.userData.id]) {
        [self.editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
        [self.meetingButton setTitle:@"约见设置" forState:UIControlStateNormal];
    }else{
        if (orderStatus == 1) {
            [self.meetingButton setTitle:@"约见" forState:UIControlStateNormal];
        }else if (orderStatus == 2 || orderStatus == 4){
            [self.meetingButton setTitle:@"待约见" forState:UIControlStateNormal];
        }else{//3
            self.meetingButton.hidden = YES;
        }
        
        if (self.model.userData.is_collect) {
            [self.editButton setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            [self.editButton setTitle:@"+关注" forState:UIControlStateNormal];
        }
    }
}

- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    [self.backImageView am_setImageByDefaultCompressWithURL:model.userData.back_img placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    [self.headerIV.imageView am_setImageWithURL:model.userData.headimg placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    self.headerIV.artMark.hidden = (_model.userData.utype.integerValue < 3);

    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:model.userData.username];
    self.artTitleLabel.text = [ToolUtil isEqualToNonNullKong:model.userData.artist_title];
    if (self.artTitleLabel.text && self.artTitleLabel.text.length) {
        self.artTitleLabel.hidden = NO;
    }else {
        self.artTitleLabel.hidden = YES;
    }
    [self.artTitleLabel sizeToFit];
    
    NSInteger fansCount = [ToolUtil isEqualToNonNull:_model.userData.fans_num replace:@"0"].integerValue;
    if (fansCount > 9999) {
        CGFloat fansCountf = fansCount/10000.0;
        self.fansNumLabel.text = [NSString stringWithFormat:@"%.1fW", fansCountf];
    }else
        self.fansNumLabel.text = [NSString stringWithFormat:@"%@", @(fansCount)];

}


- (IBAction)buttonCLick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headButtonClick:buttonTitle:)]) {
        [self.delegate headButtonClick:self buttonTitle:sender.titleLabel.text];
    }
}

@end

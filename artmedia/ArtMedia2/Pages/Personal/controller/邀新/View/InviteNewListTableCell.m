//
//  InviteNewListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "InviteNewListTableCell.h"

#import "InviteInfoModel.h"

@interface InviteNewListTableCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_width_constraint;
@end

@implementation InviteNewListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inviteBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:11.0 fontType:0];
    _nameLabel.font = [UIFont addHanSanSC:14.0 fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSecondary:(BOOL)isSecondary {
    _isSecondary = isSecondary;
    self.accessoryType = _isSecondary?UITableViewCellAccessoryNone:UITableViewCellAccessoryNone;
    _inviteLabel.hidden = _isSecondary;
}

- (void)setModel:(InviteInfoModel *)model {
    _model = model;
    
    [self.iconIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleToFill)];
    
    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    
    self.timeLabel.text = [NSString stringWithFormat:@"注册时间：%@",[TimeTool getDateStringWithTimeStr:_model.addtime]];
    
    BOOL isAuth = (_model.utype.integerValue > 1);
    _authMark.hidden = !isAuth;
    _inviteBtn.hidden = isAuth;
    if (_inviteBtn.hidden) {
        _btn_width_constraint.constant = 0.0f;
    }else {
        _btn_width_constraint.constant = 106.0f;
    }
    [_timeLabel sizeToFit];
    [_nameLabel sizeToFit];
}

- (IBAction)clickToInvite:(id)sender {
    if (self.inviteBlock) self.inviteBlock(self.model);
}


- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

@end

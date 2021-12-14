//
//  UserListDetailTableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "UserListDetailTableViewCell.h"


@implementation UserListDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_headerIV.contentMode = UIViewContentModeScaleAspectFill;
	
	_userNameLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    _followedBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_headerIV.layer.cornerRadius = _headerIV.height/2;
	_headerIV.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    NSDictionary *userinfo = _detailType?_model:[_model objectForKey:@"artist"];
    
    [_headerIV am_setImageWithURL:[userinfo objectForKey:@"headimg"] placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:[userinfo objectForKey:@"uname"]];
    
    _followedBtn.hidden = _detailType?![[userinfo objectForKey:@"is_collect"] boolValue]:NO;
    
    if (![[ToolUtil isEqualToNonNull:[userinfo objectForKey:@"utype"] replace:@"0"] isEqualToString:@"3"]) {
        _userIdentifitionBtn.hidden = YES;
        _nameHeightConstraint.constant = _headerIV.height;
    }else {
        _userIdentifitionBtn.hidden = NO;
        _nameHeightConstraint.constant = _headerIV.height*2/3;
    }
}

@end

//
//  ImproveDataCCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ImproveDataCCell.h"

@implementation ImproveDataCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	
	_mainView.layer.cornerRadius = 4.0;
	_mainView.clipsToBounds = YES;
	
	_titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_contentLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentHeight:(CGFloat )reasonHeight reason:(NSString *)reasonStr {
	_contentLabel.text = reasonStr;
	_contentHightConstraint.constant = reasonHeight;
}

- (void)setIsShowDetail:(BOOL)isShowDetail {
	_isShowDetail = isShowDetail;
	
	_arrowBtn.selected = _isShowDetail;
}

@end

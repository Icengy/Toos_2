//
//  MyMessageTableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MyMessageTableViewCell.h"

#import "MessageInfoModel.h"

@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_nameLabel.font = [UIFont addHanSanSC:15.0f fontType:1];
	_contentLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_dateLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SystemMessageModel *)model {
    _model = model;
    _isReadedBtn.hidden = _model.isread;
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.message_title];
    _contentLabel.text = [ToolUtil isEqualToNonNullKong:_model.message_detail];
    if (_model.addtime.doubleValue > 0) {
        _dateLabel.hidden = NO;
        _dateLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_model.addtime.doubleValue]];
    }else
        _dateLabel.hidden = YES;
}

@end

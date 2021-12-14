//
//  CommitTableViewCell.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "CommitTableViewCell.h"

@implementation CommitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.textColor = Color_Black;
	_nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	
	_textFiled.font = [UIFont addHanSanSC:15.0f fontType:0];
	_textFiled.textColor = Color_Black;
	_textFiled.adjustsFontSizeToFitWidth = YES;
	
	_lineView.hidden = YES;
	
	[_textFiled addTarget:self action:@selector(textFieldBlock:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldBlock:(UITextField*)textField
{
    if(_textFiledBlock)
    {
        _textFiledBlock(textField.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

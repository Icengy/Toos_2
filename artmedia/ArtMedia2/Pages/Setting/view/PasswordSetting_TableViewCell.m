//
//  PasswordSetting_TableViewCell.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/19.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "PasswordSetting_TableViewCell.h"

@implementation PasswordSetting_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_titleLab.font = [UIFont addHanSanSC:15.0f fontType:0];
	_contentTF.font = [UIFont addHanSanSC:15.0f fontType:1];
	
	[_contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidChange:(UITextField *)textField {
	if (_contentStrBlock) _contentStrBlock(textField.text);
}

@end

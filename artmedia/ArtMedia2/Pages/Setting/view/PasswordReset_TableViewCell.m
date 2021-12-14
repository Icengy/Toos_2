//
//  PasswordReset_TableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PasswordReset_TableViewCell.h"

@implementation PasswordReset_TableViewCell


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.contentView.userInteractionEnabled = YES;
	self.userInteractionEnabled = YES;
	
	_codeNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_codeTF.font = [UIFont addHanSanSC:15.0f fontType:1];
	
	if (@available(iOS 12.0, *)) {
		_codeTF.textContentType = UITextContentTypeOneTimeCode;
	}
	
	_codeTF.keyboardType = UIKeyboardTypeNumberPad;
	[_codeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	_codeBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
//	_codeBtn.layer.borderWidth = 0.5f;
//	_codeBtn.layer.borderColor = Color_Grey.CGColor;
//	_codeBtn.layer.cornerRadius = 4.0f;
//	_codeBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickToGetCode:(AMButton *)sender {
	[_codeTF resignFirstResponder];
	if (_codeClickBlock) _codeClickBlock(sender);
}

- (void)textFieldDidChange:(UITextField *)textField {
	if (_codeStrBlock) _codeStrBlock(textField.text);
}


@end

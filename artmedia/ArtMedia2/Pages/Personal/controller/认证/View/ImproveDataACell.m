//
//  ImproveDataACell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ImproveDataACell.h"
#import "IdentifyModel.h"

@interface ImproveDataACell () <AMTextViewDelegate, UITextFieldDelegate>

@end

@implementation ImproveDataACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_nameTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	_fieldLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_fieldTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_positionLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_positionTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	_introLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_introTV.font = [UIFont addHanSanSC:14.0f fontType:0];
    _introTV.placeholder = @"请详细的介绍自己(选填)";
	
	_positionTF.delegate = self;
    [_positionTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
	_nameTF.delegate = self;
    [_nameTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _fieldTF.delegate = self;
	_introTV.ownerDelegate = self;
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

- (void)setModel:(IdentifyModel *)model {
	_model = model;
    _nameTF.text = [ToolUtil isEqualToNonNullKong:_model.real_name];
    _fieldTF.text = [ToolUtil isEqualToNonNullKong:_model.cateinfo.tcate_name];
	_positionTF.text = [ToolUtil isEqualToNonNullKong:_model.organization];
	_introTV.text = [ToolUtil isEqualToNonNullKong:_model.self_introduction];
    
    _nameTF.enabled = YES;
    _nameTF.text = [ToolUtil isEqualToNonNullKong:_model.real_name];
    if ([UserInfoManager shareManager].isAuthed) {
        if ([ToolUtil isEqualToNonNull:[UserInfoManager shareManager].model.auth_data.real_name]) {
            _nameTF.enabled = NO;
            _nameTF.text = [NSString stringWithFormat:@"%@（认证）",[UserInfoManager shareManager].model.auth_data.real_name];
            
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_nameTF.text];
            [attri addAttributes:@{NSForegroundColorAttributeName: RGB(153, 153, 153)} range:[_nameTF.text rangeOfString:@"（认证）"]];
            
            _nameTF.attributedText = attri;
        }
    }
}

- (BOOL)amTextViewShouldEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
	return YES;
}

- (void)amTextViewDidChange:(UITextView *)textView {
    if (_editDataBlock) _editDataBlock(textView.text, 3);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_fieldTF]) {
        if (_editDataBlock) _editDataBlock(textField.text, 1);
        return NO;
    }
    return YES;
}

- (void)textDidChanged:(UITextField *)textField {
    if (_editDataBlock) _editDataBlock(textField.text, [textField isEqual:_positionTF]?2:0);
}

@end

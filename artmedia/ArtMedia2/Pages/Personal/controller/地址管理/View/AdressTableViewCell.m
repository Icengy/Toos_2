//
//  AdressTableViewCell.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "AdressTableViewCell.h"

#import "MyAddressModel.h"

@implementation AdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_lineOneView.layer.borderWidth = 0.5f;
	_lineOneView.layer.borderColor = RGB(242, 242, 242).CGColor;
	
	_nameLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
	_phoneLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
	_adressLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_markBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	
	_deleteBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_deleteBtn.layer.cornerRadius = _deleteBtn.height/2;
	_deleteBtn.layer.borderColor = Color_Black.CGColor;
	_deleteBtn.layer.borderWidth = 0.5f;
	_deleteBtn.clipsToBounds = YES;
	_editBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_editBtn.layer.cornerRadius = _editBtn.height/2;
	_editBtn.layer.borderColor = Color_Black.CGColor;
	_editBtn.layer.borderWidth = 0.5f;
	_editBtn.clipsToBounds = YES;
	
}

- (void)setModel:(MyAddressModel *)model {
	_model = model;
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:model.reciver];
    _phoneLabel.text = [ToolUtil isEqualToNonNullKong:model.phone];
	NSString *address = [NSString stringWithFormat:@"%@ %@",[ToolUtil isEqualToNonNullKong:model.addrregion], [ToolUtil isEqualToNonNullKong:model.address]];
	address = [address stringByReplacingOccurrencesOfString:@"" withString:@" "];
	_adressLabel.text = address;
	_markBtn.selected = model.is_default;
}

- (IBAction)markBtnClick:(AMButton *)sender {
	if (sender.selected)
		return;
    if(_markBlock) {
        _markBlock();
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if(_deleteBlock) {
        _deleteBlock();
    }
}

- (IBAction)editBtnClick:(id)sender {
    if(_editBlock) {
        _editBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

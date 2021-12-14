//
//  AddNewBankCardCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "AddNewBankCardCell.h"

@interface AddNewBankCardCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *cellDetailTF;

@property (nonatomic ,strong) NSIndexPath *currentIndexPath;

@end

@implementation AddNewBankCardCell

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cellNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _cellDetailTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	_cellDetailTF.delegate = self;
	[_cellDetailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addNameText:(NSString *)nameString detailName:(NSString *)detailName placeholder:(NSString *)placeholder indexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled {
    self.currentIndexPath = indexPath;
	self.cellNameLabel.text = nameString;
	self.cellDetailTF.placeholder = placeholder;
    self.cellDetailTF.enabled = enabled;
    if (enabled) {
        self.cellDetailTF.text = detailName;
    }else {
        NSString *allStr = nil;
        if (indexPath.row) {
            allStr = [ToolUtil getSecretCardIDWitCardID:detailName];
        }else
            allStr =  [NSString stringWithFormat:@"%@（已认证）",detailName];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allStr];
        
        [attri setAttributes:@{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:0], NSForegroundColorAttributeName:Color_Black} range:[allStr rangeOfString:allStr]];
        [attri addAttributes:@{NSFontAttributeName:[UIFont addHanSanSC:12.0f fontType:0], NSForegroundColorAttributeName:RGB(180, 184, 204)} range:[allStr rangeOfString:@"（已认证）"]];
        
        self.cellDetailTF.attributedText = attri;
    }
}

- (void)addNameText:(NSString *)nameString detailName:(NSString *)detailName placeholder:(NSString *)placeholder indexPath:(NSIndexPath *)indexPath {
    [self addNameText:nameString detailName:detailName placeholder:placeholder indexPath:indexPath enabled:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (self.currentIndexPath.row == 2) {
		if ([self.delegate respondsToSelector:@selector(cellClickToAddBankName)]) {
			[self.delegate cellClickToAddBankName];
		}
		return NO;
	}else if (self.currentIndexPath.row == 3) {
		self.cellDetailTF.keyboardType = UIKeyboardTypeNumberPad;
		self.cellDetailTF.font = [UIFont addHanSanSC:19.0f fontType:0];
	}
	return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(writeTFValue:indexPath:)]) {
		[self.delegate writeTFValue:textField.text indexPath:_currentIndexPath];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (self.currentIndexPath.row == 3) {
        if (textField.text.length > 0 && !range.length) {
            if (textField.text.length%5 == 4) {
                self.cellDetailTF.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }
        }else {
            if (textField.text.length > 1) {
                if ([[textField.text substringFromIndex:textField.text.length - 1] isEqualToString:@" "]) {
                    self.cellDetailTF.text  = [textField.text substringToIndex:textField.text.length - 1];
                }
            }
        }
    }
	NSLog(@"textField.text = %@, range = %@, replacementString = %@",textField.text, NSStringFromRange(range), string);
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.currentIndexPath.row == 3) {
        self.cellDetailTF.font = [UIFont addHanSanSC:14.0f fontType:0];
    }
}

@end

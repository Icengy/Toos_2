//
//  ReceivableListCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ReceivableListCell.h"

#import "ReceivableModel.h"

@interface ReceivableListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agentHeightConstraint;

@property (weak, nonatomic) IBOutlet AMButton *removeBtn;
@property (weak, nonatomic) IBOutlet AMButton *selectedBtn;

@end

@implementation ReceivableListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    _bankNameLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _agentNameLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (!_selectedBtn.hidden) {
        _selectedBtn.selected = selected;
    }
    
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 15.0f*2;
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setModel:(ReceivableModel *)model {
	_model = model;
    [_iconIV am_setImageWithURL:_model.bank_img contentMode:UIViewContentModeScaleAspectFit];
    _nameLabel.text = [ToolUtil getSecretBankNumWithBankNum:_model.account_number];
    [_nameLabel adjustsFontSizeToFitWidth];
    _bankNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.bank_name];
    
    if (model.account_type.integerValue == 2) {
        _agentNameLabel.hidden = YES;
        _agentTopConstraint.constant = 0.0f;
        _agentHeightConstraint.constant = 0.0f;
    }else {
        _agentNameLabel.hidden = NO;
        _agentTopConstraint.constant = 8.0f;
        _agentHeightConstraint.constant = 20.0f;
        if ([ToolUtil isEqualToNonNullKong:_model.account_user_name]) {
            _agentNameLabel.text = [NSString stringWithFormat:@"经纪人：%@", _model.account_user_name];
        }
    }
    
    if (!_selectedBtn.hidden) {
        _selectedBtn.selected = _model.isSelected;
    }
}

- (void)setReceiveType:(NSInteger)receiveType {
    _receiveType = receiveType;
    _removeBtn.hidden = _receiveType;
    _selectedBtn.hidden = !_receiveType;
}

#pragma mark -
- (IBAction)clickToRemoveBinding:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didClickToRemoveBind:withModel:)]) {
        [self.delegate cell:self didClickToRemoveBind:sender withModel:_model];
    }
}

@end

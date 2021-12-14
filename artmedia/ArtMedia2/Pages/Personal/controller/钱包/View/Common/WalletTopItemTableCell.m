//
//  WalletTopItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletTopItemTableCell.h"

@interface WalletTopItemTableCell ()

@property (weak, nonatomic) IBOutlet GradientView *contentCarrier;

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yiBIconIV;
@property (weak, nonatomic) IBOutlet UILabel *availableValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unavailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *unavailableValueLabel;
@property (weak, nonatomic) IBOutlet AMButton *questionBtn;
@property (weak, nonatomic) IBOutlet AMButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet AMButton *cashoutBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableLabelLeftConstraint;

@end

@implementation WalletTopItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _availableLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _availableValueLabel.font = [UIFont addHanSanSC:25.0f fontType:2];
    _unavailableLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _unavailableValueLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _questionBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _rechargeBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStyle:(AMWalletItemStyle)style {
    _style = style;
    if (_style == AMWalletItemStyleYiB) {
        _contentCarrier.colorArray = @[RGB(121, 136, 252), RGB(124, 90, 249)];
        _cashoutBtn.hidden = YES;
        _availableLabel.text = @"可用艺币";
        _unavailableLabel.text = @"不可用艺币";
    }
    if (_style == AMWalletItemStyleBalance) {
        _contentCarrier.colorArray = @[RGB(242, 142, 38), RGB(253, 100, 79)];
        _rechargeBtn.hidden = YES;
        _yiBIconIV.hidden = YES;
        _availableLabelLeftConstraint.constant = 0.0f;
        _availableLabel.text = @"我的余额";
        _unavailableLabel.text = @"冻结";
    }
}

#pragma mark -
- (IBAction)clickToQuestion:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToQuestion:)]) {
        [self.delegate didClickToQuestion:sender];
    }
}

- (IBAction)clickToRecharge:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToRecharge:)]) {
        [self.delegate didClickToRecharge:sender];
    }
}

- (IBAction)clickToCashout:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToCashout:)]) {
        [self.delegate didClickToCashout:sender];
    }
}

@end

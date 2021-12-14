//
//  BankCardListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BankCardListTableCell.h"

@implementation BankCardListModel

@end

#pragma mark -
@interface BankCardListTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *itemIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedSignIV;

@end

@implementation BankCardListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.layer.borderColor = selected?RGB(251, 30, 30).CGColor:Color_Whiter.CGColor;
    self.selectedSignIV.hidden = !selected;
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setModel:(BankCardListModel *)model {
    _model = model;
    
    [_itemIV am_setImageWithURL:_model.back_icon contentMode:(UIViewContentModeScaleAspectFit)];
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.bank_name];
}

@end

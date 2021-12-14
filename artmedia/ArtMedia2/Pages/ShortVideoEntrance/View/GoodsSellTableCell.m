//
//  GoodsSellTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsSellTableCell.h"

#import "VideoGoodsModel.h"

@interface GoodsSellTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;

@property (weak, nonatomic) IBOutlet AMTextField *priceTF;
@property (weak, nonatomic) IBOutlet AMButton *mailBtn;

@end

@implementation GoodsSellTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _priceLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _mailLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    _priceTF.font = [UIFont addHanSanSC:15.0f fontType:0];
    _priceTF.placeholder = @"请输入作品价格（必填）";
    [self addPlaceLeftMarginForTextField:_priceTF];
    [_priceTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _priceTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsModel:(VideoGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    if ([ToolUtil isEqualToNonNull:_goodsModel.sellprice]) {
        _priceTF.text = _goodsModel.sellprice;
    }else
        _priceTF.text = nil;
    _mailBtn.selected = _goodsModel.freeshipping;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellCell:userInputResultForPriceWithinputStr:)]) {
        [self.delegate sellCell:self userInputResultForPriceWithinputStr:textField.text];
    }
    return YES;
}

- (void)textFieldTextDidChanged:(UITextField *)textField {
    if (![ToolUtil valifyInputPrice:textField.text]) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
    }
}

#pragma mark -
- (IBAction)clickToMail:(AMButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellCell:selecIstMail:)]) {
        [self.delegate sellCell:self selecIstMail:sender.selected];
    }
}

- (void)addPlaceLeftMarginForTextField:(UITextField *)textField {
    CGRect frame = textField.frame;
    frame.size.width = 8.0f;
    [textField setLeftView:[[UIView alloc]initWithFrame:frame]];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
}

@end

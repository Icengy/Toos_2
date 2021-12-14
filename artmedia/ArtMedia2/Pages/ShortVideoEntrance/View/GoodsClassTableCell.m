//
//  GoodsClassTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsClassTableCell.h"

@interface GoodsClassTableCell ()

@property (weak, nonatomic) IBOutlet AMIconImageView *imageIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageleadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GoodsClassTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageHeightConstraint.constant = self.style?self.height *0.8:0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!_style) {
        self.backgroundColor = selected?Color_Whiter:UIColor.clearColor;
        _nameLabel.textColor = selected?RGB(251, 30, 30):Color_Black;
    }else {
        _nameLabel.textColor = selected?RGB(251, 30, 30):Color_Black;
    }
    // Configure the view for the selected state
}

- (void)setStyle:(NSInteger)style {
    _style = style;
    if (_style == 0) {
        _imageIV.hidden = YES;
        _imageleadingConstraint.constant = 0.0f;
    }else {
        _imageIV.hidden = NO;
        _imageleadingConstraint.constant = 15.0f;
    }
}

- (void)setModel:(GoodsClassModel *)model {
    _model = model;
    if (_style) {
        [_imageIV am_setImageWithURL:_model.scate_banner contentMode:(UIViewContentModeScaleAspectFit)];
        _nameLabel.text = [ToolUtil isEqualToNonNullForZanWu:model.scate_name];
    }else {
        _nameLabel.text = [ToolUtil isEqualToNonNullForZanWu:model.tcate_name];
    }
}

@end

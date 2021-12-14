//
//  AMCerNonDataCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCerNonDataCollectionCell.h"

#import "VideoGoodsModel.h"

@interface AMCerNonDataCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AMCerNonDataCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setModel:(VideoGoodsModel *)model {
    _model = model;
    
    [_goodsIV am_setImageWithURL:_model.banner contentMode:UIViewContentModeScaleToFill];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.name];
}

@end

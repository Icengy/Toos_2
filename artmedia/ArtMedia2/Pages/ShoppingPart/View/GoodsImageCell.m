//
//  GoodsImageCell.m
//  ArtMedia2
//
//  Created by LY on 2020/12/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsImageCell.h"
@interface GoodsImageCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;


@end
@implementation GoodsImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsAtlas *)model{
    _model = model;
    [self.headImage am_setImageWithURL:model.amimgsrc placeholderImage:[UIImage imageNamed:@"logo"]];
    self.imageHeight.constant = model.pic_height/model.pic_width*K_Width;
}

@end

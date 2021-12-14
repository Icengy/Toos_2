//
//  PersonalArtGalleryCollectionViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalArtGalleryCollectionViewCell.h"

#import "VideoListModel.h"

@interface PersonalArtGalleryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *artIV;
@property (weak, nonatomic) IBOutlet UILabel *artNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *artTag1Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artTag1_width;

@property (weak, nonatomic) IBOutlet UILabel *artTag2Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artTag2_width;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet AMButton *buyBtn;

@end

@implementation PersonalArtGalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _artNameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _artTag1Label.font = [UIFont addHanSanSC:12.0f fontType:0];
    _artTag2Label.font = [UIFont addHanSanSC:12.0f fontType:0];
    _priceLabel.font = [UIFont addHanSanSC:18.0f fontType:2];
    
    [_buyBtn setBackgroundImage:[UIImage imageWithColor:RGB(204, 204, 204)] forState:UIControlStateDisabled];
    [_buyBtn setTitle:@"已售" forState:UIControlStateDisabled];
    [_buyBtn setBackgroundImage:[UIImage imageWithColor:RGB(219, 17, 17)] forState:UIControlStateNormal];
    [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];

}

- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    [_artIV am_setImageWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];
    _artNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    _artTag1Label.text = [ToolUtil isEqualToNonNullKong:_model.goodsModel.classModel.tcate_name];
    CGFloat tag1Width = [_artTag1Label.text sizeWithFont:_artTag1Label.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _artTag1Label.height)].width;
    if (tag1Width != 0) {
        tag1Width += 10.0f;
        if (tag1Width < 50.0f) tag1Width = 50.0f;
    }
    _artTag1_width.constant = tag1Width;
    
    _artTag2Label.text = [ToolUtil isEqualToNonNullKong:_model.goodsModel.classModel.secondcate.lastObject.scate_name];
    CGFloat tag2Width = [_artTag2Label.text sizeWithFont:_artTag2Label.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _artTag2Label.height)].width;
    if (tag2Width != 0) {
        tag2Width += 10.0f;
        if (tag2Width < 50.0f) tag2Width = 50.0f;
    }
    _artTag2_width.constant = tag2Width;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [ToolUtil isEqualToNonNull:_model.goodsModel.sellprice replace:@"0"].doubleValue];
    
    _buyBtn.enabled = (_model.is_include_obj.integerValue == 2)?NO:YES;
}


- (IBAction)clickToBuy:(id)sender {
    if (_buyGoodsBlock) _buyGoodsBlock(_model);
}

@end

//
//  GoodsImagesCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GoodsImagesCell.h"

#import "VideoGoodsImageModel.h"

@implementation GoodsImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_goodsIV.layer.cornerRadius = 4.0f;
}

- (IBAction)clickToAddImage:(id)sender {
	if (_clickGoodsPickBlock) _clickGoodsPickBlock();
}

- (IBAction)clickToDeleteGoodsIV:(id)sender {
	if (_clickGoodsDeleteBlock) _clickGoodsDeleteBlock(_indexPath);
}

- (void)setCurrentImage:(id)currentImage {
	_currentImage = currentImage;
    if (_currentImage && _currentImage.imgsrc && [ToolUtil isEqualToNonNull:_currentImage.imgsrc]) {
        self.addImageBtn.hidden = YES;
        self.goodsIV.hidden = NO;
        self.deleteBtn.hidden = NO;
        
        if ([_currentImage.imgsrc isKindOfClass:[UIImage class]]) {
            _goodsIV.image = _currentImage.imgsrc;
        }else if ([_currentImage.imgsrc isKindOfClass:[NSString class]]) {
            [_goodsIV am_setImageWithURL:_currentImage.imgsrc placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFit];
        }
    }else {
        self.addImageBtn.hidden = NO;
        self.goodsIV.hidden = YES;
        self.deleteBtn.hidden = YES;
    }

}


@end

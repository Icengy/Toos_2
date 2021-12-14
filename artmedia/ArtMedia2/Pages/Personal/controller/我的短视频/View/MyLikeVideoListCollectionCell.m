//
//  MyLikeVideoListCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyLikeVideoListCollectionCell.h"

#import "VideoListModel.h"

@interface MyLikeVideoListCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *videoDescLabel;
@property (weak, nonatomic) IBOutlet AMButton *canShoppingBtn;

@end

@implementation MyLikeVideoListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _videoDescLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    [_canShoppingBtn setImage:ImageNamed(@"user_videolist_shopcar") forState:UIControlStateNormal];
    [_canShoppingBtn setImage:ImageNamed(@"user_videolist_shopcar") forState:UIControlStateDisabled];
    [_canShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE22020)] forState:UIControlStateNormal];
    [_canShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xB3B3B3)] forState:UIControlStateDisabled];
}

- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    [_videoIV am_setImageByDefaultCompressWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleToFill];
    
    _videoDescLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    _canShoppingBtn.hidden = YES;
    if ([ToolUtil isEqualToNonNull:_model.is_include_obj] && [_model.is_include_obj integerValue] != 0) {
        _canShoppingBtn.hidden = NO;
        if ([_model.is_include_obj integerValue] == 1) {
            _canShoppingBtn.enabled = YES;
        }
        if ([_model.is_include_obj integerValue] == 2) {
            _canShoppingBtn.enabled = NO;
        }
    }
}

@end

//
//  RecommendArtsCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "RecommendArtsCollectionCell.h"

#import "VideoArtModel.h"

@interface RecommendArtsCollectionCell ()
@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RecommendArtsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
}


- (void)setArtModel:(VideoArtModel *)artModel {
    _artModel = artModel;
    
    [_logoIV am_setImageWithURL:_artModel.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFit)];
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_artModel.art_name];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_artModel.artist_title];
}

@end

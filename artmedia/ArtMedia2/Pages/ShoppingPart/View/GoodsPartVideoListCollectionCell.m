//
//  GoodsPartVideoListCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartVideoListCollectionCell.h"

@interface GoodsPartVideoListCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;

@end

@implementation GoodsPartVideoListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVideoInfo:(NSDictionary *)videoInfo {
    _videoInfo = videoInfo;
    
    [_videoIV am_setImageWithURL:[_videoInfo objectForKey:@"image_url"] contentMode:(UIViewContentModeScaleAspectFit)];
}

@end

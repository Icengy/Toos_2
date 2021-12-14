//
//  AMNewArtistMainVideoCollectionCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainVideoCollectionCell.h"
@interface AMNewArtistMainVideoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end
@implementation AMNewArtistMainVideoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    // Initialization code
}
- (void)setModel:(VideoListModel *)model{
    _model = model;
    [self.backImageView am_setImageWithURL:model.image_url placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
}
@end

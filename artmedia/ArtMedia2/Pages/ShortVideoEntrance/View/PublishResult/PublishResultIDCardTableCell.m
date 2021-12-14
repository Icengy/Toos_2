//
//  PublishResultIDCardTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishResultIDCardTableCell.h"

@interface PublishResultIDCardTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idCardIV;

@end

@implementation PublishResultIDCardTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

- (void)setArtworkIDCard:(NSString *)artworkIDCard {
    _artworkIDCard = artworkIDCard;
    [_idCardIV am_setImageWithURL:_artworkIDCard contentMode:(UIViewContentModeScaleAspectFit)];
}

@end

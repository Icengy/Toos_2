//
//  AMCertificateListCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateListCollectionCell.h"

@implementation AMCertificateListModel

@end

@interface AMCertificateListCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

@end

@implementation AMCertificateListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AMCertificateListModel *)model {
    _model = model;
    [_contentIV am_setImageWithURL:_model.certImagePath contentMode:(UIViewContentModeScaleToFill)];
}

- (UIImage *)cerImage {
    return _contentIV.image?:[UIImage new];
}

@end

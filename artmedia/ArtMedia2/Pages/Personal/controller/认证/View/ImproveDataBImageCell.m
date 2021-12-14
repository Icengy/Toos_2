//
//  ImproveDataBImageCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ImproveDataBImageCell.h"

@interface ImproveDataBImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@end

@implementation ImproveDataBImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    NSLog(@"_imageStr = %@",_imageStr);
    if ([ToolUtil isEqualToNonNull:_imageStr]) {
        _contentIV.hidden = NO;
        _deleteBtn.hidden = NO;
        _addLabel.hidden = YES;
        [_contentIV am_setImageWithURL:_imageStr contentMode:(UIViewContentModeScaleAspectFit)];
    }else {
        _contentIV.hidden = YES;
        _deleteBtn.hidden = YES;
        _addLabel.hidden = NO;
    }
}

- (IBAction)clickToDeleteImage:(id)sender {
    if (_deleteImageBlock) _deleteImageBlock();
}

@end

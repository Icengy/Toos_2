//
//  PersonalFullImageCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalFullImageCollectionCell.h"
#import "VideoListModel.h"

@interface PersonalFullImageCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet AMButton *canShoppingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingBtn_leading_constraint;

@property (weak, nonatomic) IBOutlet AMButton *authBtn;

@property (weak, nonatomic) IBOutlet UILabel *playsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PersonalFullImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _playsCountLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _videoLengthLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _authBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
    _model = model;
    
    ///
    [_contentIV am_setImageByDefaultCompressWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleToFill];

    _authBtn.hidden = !_model.is_auth;
    
    if ([ToolUtil isEqualToNonNull:_model.is_include_obj ]  && ![_model.is_include_obj integerValue]) {
        _canShoppingBtn.hidden = YES;
    }else {
        _canShoppingBtn.hidden = NO;
        _canShoppingBtn.backgroundColor = (_model.is_include_obj.integerValue == 1)?Color_RedA(0.8):Color_GreyLightA(0.8);
        if (_authBtn.hidden) {
            _shoppingBtn_leading_constraint.constant = 8.0f;
        }else {
            _shoppingBtn_leading_constraint.constant = 8.0f*2+_authBtn.width;
        }
    }
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    
    NSString *likeStr = [ToolUtil isEqualToNonNull:_model.like_num replace:@"0"];
    if (likeStr.integerValue > 9999) {
        likeStr = [NSString stringWithFormat:@"%.2fw", likeStr.doubleValue/ 10000];
    }
    _playsCountLabel.text = [NSString stringWithFormat:@"%@次播放", likeStr];
    [_playsCountLabel sizeToFit];
    
    _videoLengthLabel.text = [TimeTool timeFormatted:[[ToolUtil isEqualToNonNull:_model.video_length replace:@"0"] doubleValue]];
}


@end

//
//  MessageCollectTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/5/25.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageCollectTableCell.h"
#import "ComplexImageView.h"

#import "MessageInfoModel.h"

@interface MessageCollectTableCell ()
@property (weak, nonatomic) IBOutlet ComplexImageView *headerIV;
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *badgeView;

@property (nonatomic ,strong) MessageCollectInfoModel *collectionModel;
@property (nonatomic ,strong) MessageDiscussInfoModel *discussModel;


@end

@implementation MessageCollectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageInfoModel *)model {
    _model = model;
    
    if (_listStyle == MessageDetailListStyleDiscuss) {
        self.discussModel = (MessageDiscussInfoModel *)_model;
    }
    if (_listStyle == MessageDetailListStyleCollect){
        self.collectionModel = (MessageCollectInfoModel *)_model;
    }
}

- (void)setDiscussModel:(MessageDiscussInfoModel *)discussModel {
    _discussModel = discussModel;
    
    _headerIV.imageArray = _discussModel.user_head_images;

    [_videoIV am_setImageWithURL:_discussModel.obj_image placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];

    if (_discussModel.user_names.count) {
        NSString *textString = @"", *nameString = @"";
        if (_discussModel.user_names.count > 1) {
            for (NSString *name in _discussModel.user_names) {
                nameString = [nameString stringByAppendingFormat:@"%@、", name];
            }
            if (nameString && nameString.length && [nameString hasSuffix:@"、"])
                nameString = [nameString substringToIndex:nameString.length - 1];
            
            textString = [NSString stringWithFormat:@"%@ 等评论了我的短视频",nameString];
        }else {
            nameString = [ToolUtil isEqualToNonNullKong:_discussModel.user_names.lastObject];
            textString = [NSString stringWithFormat:@"%@ 评论了我的短视频",nameString];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:1], NSForegroundColorAttributeName:Color_Black} range:[textString rangeOfString:nameString]];
        _titleLabel.attributedText = attributedString;
    }

    if (_discussModel.addtime.doubleValue > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_discussModel.addtime.doubleValue]];
    }else
        _timeLabel.hidden = YES;
    
    _badgeView.hidden = _discussModel.is_read.boolValue;
}

- (void)setCollectionModel:(MessageCollectInfoModel *)collectionModel {
    _collectionModel = collectionModel;
    
    if (_collectionModel.user_info && _collectionModel.user_info.count) {
        __block NSMutableArray *imageArray = @[].mutableCopy, *unameArray = @[].mutableCopy;
        [_collectionModel.user_info enumerateObjectsUsingBlock:^(UserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArray addObject:obj.headimg];
            [unameArray addObject:obj.username];
        }];
        
        _headerIV.imageArray = imageArray;
        
        NSString *textString = @"", *nameString = @"";
        if (unameArray.count > 1) {
            for (NSString *name in unameArray) {
                nameString = [nameString stringByAppendingFormat:@"%@、", name];
            }
            if (nameString && nameString.length && [nameString hasSuffix:@"、"])
                nameString = [nameString substringToIndex:nameString.length - 1];
            
            textString = [NSString stringWithFormat:@"%@ 等赞了我的%@",nameString, (_collectionModel.collect_type.integerValue == 8)?@"评论":@"短视频"];
        }else {
            nameString = [ToolUtil isEqualToNonNullKong:unameArray.lastObject];
            textString = [NSString stringWithFormat:@"%@ 赞了我的%@",nameString, (_collectionModel.collect_type.integerValue == 8)?@"评论":@"短视频"];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:1], NSForegroundColorAttributeName:Color_Black} range:[textString rangeOfString:nameString]];
        _titleLabel.attributedText = attributedString;
    }
    
    if (_collectionModel.collect_type.integerValue == 8) {
        _videoIV.image = ImageNamed(@"discuss_logo");
    }
    if (_collectionModel.collect_type.integerValue == 5) {
        if ([ToolUtil isEqualToNonNullKong:_collectionModel.collect_banner]) {
            [_videoIV am_setImageWithURL:_collectionModel.collect_banner placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];
        }
    }
    if (_collectionModel.addtime.doubleValue > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_collectionModel.addtime.doubleValue]];
    }else
        _timeLabel.hidden = NO;
    
    _badgeView.hidden = YES;
}


@end

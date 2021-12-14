//
//  MessageReplyTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageReplyTableCell.h"

#import "UILabel+Extension.h"
#import "MessageInfoModel.h"

@interface MessageReplyTableCell ()
@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

@property (weak, nonatomic) IBOutlet UILabel *oldTitleLabel;
@end

@implementation MessageReplyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _userNameLabel.font = [UIFont addHanSanSC:15.0 fontType:2];
    _userTipsLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    
    _replyLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    _oldTitleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _videoTitleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    _dateLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageReplyInfoModel *)model {
    _model = model;
    
    NSString *logo = [[_model.notice objectForKey:@"user_head_images"] lastObject];
    [_logoIV am_setImageWithURL:logo placeholderImage:ImageNamed(@"logo")];
    
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:[[_model.notice objectForKey:@"user_names"] lastObject]];
    
    _replyLabel.text = [ToolUtil isEqualToNonNullKong:[_model.reply objectForKey:@"reply_comment"]];
    
    _videoTitleLabel.text = [ToolUtil isEqualToNonNullKong:[_model.video objectForKey:@"video_des"]];
    
    _oldTitleLabel.text = [ToolUtil isEqualToNonNullKong:[_model.comment objectForKey:@"comment"]];
    
    if ([[_model.notice objectForKey:@"addtime"] doubleValue] > 0) {
        _dateLabel.hidden = NO;
        _dateLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:[[_model.notice objectForKey:@"addtime"] doubleValue]]];
    }else
        _dateLabel.hidden = YES;
    
    _badgeView.hidden = [[_model.notice objectForKey:@"is_read"] boolValue];
}

@end

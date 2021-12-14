//
//  MessageListCell.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageListCell.h"

#import "MessageInfoModel.h"

@interface MessageListCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jumpMark;

@end

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setModel:(MessageSubModel *)model{
    _model = model;
    _mainTitleLabel.text = [ToolUtil isEqualToNonNullKong:_model.messageTitle];
    _contentLabel.text = [ToolUtil isEqualToNonNullKong:_model.messageDetail];
    
    if (_model.jumpType.integerValue && [ToolUtil isEqualToNonNull:_model.jumpId]) {
        _jumpMark.hidden = NO;
    }else {
        _jumpMark.hidden = YES;
    }
    
    if (_model.addtime.doubleValue > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_model.addtime.doubleValue]];
    }else {
        _timeLabel.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

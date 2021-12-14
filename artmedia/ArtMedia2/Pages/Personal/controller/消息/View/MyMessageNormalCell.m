//
//  MyMessageNormalCell.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyMessageNormalCell.h"
@interface MyMessageNormalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *customHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MyMessageNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _mainTitleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _subTitleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _numLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
}

- (void)setModel:(MessageSubModel *)model{
    _model = model;
    
    if ([ToolUtil isEqualToNonNull:_model.messageDetail]) {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = [ToolUtil isEqualToNonNullKong:_model.messageDetail];
    }else
        self.subTitleLabel.hidden = YES;
    
    if (_model.sum == 0) {
        self.numLabel.hidden = YES;
    }else {
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%@",@(_model.sum)];
        if (_model.sum > 99) {
            self.numLabel.text = @"99";
        }
    }
    if (_model.addtime.doubleValue > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_model.addtime.doubleValue]];
    }else {
        _timeLabel.hidden = YES;
    }
    
    [self updateIconStyle];
}

- (void)updateIconStyle {
    NSInteger userType = _model.userType.integerValue;
    NSInteger mType = _model.mtype.integerValue;
    
    switch (mType) {
        case 1: {
            _mainTitleLabel.text = @"系统消息";
            NSString *imageStr = [NSString stringWithFormat:@"message_speaker_%@",@(userType)];
            _customHeadImageView.image = ImageNamed(imageStr);
            break;
        }
        case 2: {
            _mainTitleLabel.text = @"会客通知";
            NSString *imageStr = [NSString stringWithFormat:@"message_tea_%@",@(userType)];
            _customHeadImageView.image = ImageNamed(imageStr);
            break;
        }
        case 3: {
            _mainTitleLabel.text = @"交易通知";
            NSString *imageStr = [NSString stringWithFormat:@"message_money_%@",@(userType)];
            _customHeadImageView.image = ImageNamed(imageStr);
            break;
        }
        case 4: {
            _mainTitleLabel.text = @"课程通知";
            NSString *imageStr = [NSString stringWithFormat:@"message_course_%@",@(userType)];
            _customHeadImageView.image = ImageNamed(imageStr);
            break;
        }
        case 5: {
            _mainTitleLabel.text = @"拍卖通知";
            NSString *imageStr = [NSString stringWithFormat:@"message_auction_%@",@(userType)];
            _customHeadImageView.image = ImageNamed(imageStr);
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  HomeNoticeCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/30.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeNoticeCell.h"

#import "HomeInforModel.h"

@interface HomeNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HomeNoticeCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _noticeLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setNoticeModel:(HomeInforModel *)noticeModel {
    _noticeModel = noticeModel;
    
    _noticeLabel.text = [ToolUtil isEqualToNonNullKong:_noticeModel.title];
    if (_noticeModel.addtime.doubleValue > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前", [TimeTool getDifferenceToCurrentSinceTimeStamp:_noticeModel.addtime.doubleValue]];
    }
}

@end

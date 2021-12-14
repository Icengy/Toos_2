//
//  MineMeeingItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MineMeeingItemTableCell.h"

#import "CustomPersonalModel.h"
#import "MineMeetingItemView.h"

@interface MineMeeingItemTableCell ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet MineMeetingItemView *meetingItemView;
@property (weak, nonatomic) IBOutlet MineMeetingItemView *appointmentItemView;

@end

@implementation MineMeeingItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    // Initialization code
    _meetingItemView.topTitleLabel.text = @"会客";
    _meetingItemView.bottomTitleLabel.text = @"0场待参加";
    
    _appointmentItemView.topTitleLabel.text = @"我的约见";
    _appointmentItemView.bottomTitleLabel.text = @"已预约0位";
    
    @weakify(self);
    _meetingItemView.ItemClickBlock = ^{
        @strongify(self);
        [self clickToSelected:0];
    };
    _appointmentItemView.ItemClickBlock = ^{
        @strongify(self);
        [self clickToSelected:1];
    };
    
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

- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    _meetingItemView.bottomTitleLabel.text = [NSString stringWithFormat:@"%@场待参加", [ToolUtil isEqualToNonNull:_model.my_meeting replace:@"0"]];
    _appointmentItemView.bottomTitleLabel.text = [NSString stringWithFormat:@"已预约%@位", [ToolUtil isEqualToNonNull:_model.my_appointment replace:@"0"]];
}

#pragma mark -
- (void)clickToSelected:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetingCell:didSelectedMeetingItemWithIndex:)]) {
        [self.delegate meetingCell:self didSelectedMeetingItemWithIndex:index];
    }
}

@end

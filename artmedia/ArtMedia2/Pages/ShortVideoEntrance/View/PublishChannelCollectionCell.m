//
//  PublishChannelCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishChannelCollectionCell.h"

#import "VideoListModel.h"

@interface PublishChannelCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;

@end

@implementation PublishChannelCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _channelLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = selected?RGB(219, 17, 17):RGB(245, 245, 245);
    self.channelLabel.textColor = selected?Color_Whiter:RGB(102, 102, 102);
    [super setSelected:selected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2;
}

- (void)setChannel:(VideoColumnModel *)channel {
    _channel = channel;
    _channelLabel.text = [ToolUtil isEqualToNonNullKong:_channel.column_name];
}

@end

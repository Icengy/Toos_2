//
//  PublishResultHeaderTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishResultHeaderTableCell.h"

@interface PublishResultHeaderTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PublishResultHeaderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    
    self.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.cornersRadii = CGSizeMake(8.0, 8.0);
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoName:(NSString *)videoName {
    _videoName = videoName;
    
    if ([ToolUtil isEqualToNonNull:_videoName]) {
        NSString *tips = @"视频已发布，并成功认证";
        NSString *video_name = [NSString stringWithFormat:@"《%@》",_videoName];
        _titleLabel.text = [NSString stringWithFormat:@"%@%@",tips,video_name];
    }else {
        _titleLabel.text = @"视频发布成功";
    }
}


@end

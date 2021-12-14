//
//  VideoListCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "VideoListCell.h"
@interface VideoListCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end
@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(AMCourseChapterModel *)model{
    _model = model;
    self.numLabel.text = model.chapterSort;
    self.chapterNameLabel.text = model.chapterTitle;
    self.timeLabel.text = [NSString stringWithFormat:@"%@开播",model.liveStartTime];
    if ([model.isFree isEqualToString:@"1"] && [self.courseModel.isFree isEqualToString:@"2"]) {
        self.freeLabel.hidden = NO;
        
    }else{
        self.freeLabel.hidden = YES;
    }
    
    
    
}


- (void)setChapterId:(NSString *)chapterId{
    _chapterId = chapterId;
    if ([chapterId isEqualToString:self.model.chapterId]) {
//        self.numLabel.textColor = RGB(219, 17, 17);
//        self.chapterNameLabel.textColor = RGB(219, 17, 17);
        self.playStatusLabel.textColor = RGB(224 , 82, 39);
        self.playStatusLabel.text = @"播放中";
        self.playImageView.image = [UIImage imageNamed:@"pause"];
        self.playImageView.hidden = NO;
    }else{
//        self.numLabel.textColor = RGB(21, 22 , 26);
//        self.chapterNameLabel.textColor = RGB(21, 22 , 26);
        self.playStatusLabel.textColor = RGB(26, 33 , 33);
        if ([self.model.liveStatus isEqualToString:@"4"] || [self.model.liveStatus isEqualToString:@"5"]) {
//            self.numLabel.textColor = RGB(21, 22 , 26);
//            self.chapterNameLabel.textColor = RGB(21, 22 , 26);
//            self.playStatusLabel.textColor = RGB(21, 22 , 26);
            self.playStatusLabel.text = @"回放生成中";
            self.playImageView.hidden = YES;
        }else if([self.model.liveStatus isEqualToString:@"6"]){
//            self.numLabel.textColor = RGB(21, 22 , 26);
//            self.chapterNameLabel.textColor = RGB(21, 22 , 26);
//            self.playStatusLabel.textColor = RGB(21, 22 , 26);
            self.playStatusLabel.text = @"看回放";
            self.playImageView.image = [UIImage imageNamed:@"playblack_classdetail"];
            self.playImageView.hidden = NO;
        }else if([self.model.liveStatus isEqualToString:@"1"]){
//            self.numLabel.textColor = RGB(21, 22 , 26);
//            self.chapterNameLabel.textColor = RGB(21, 22 , 26);
//            self.playStatusLabel.textColor = RGB(21, 22 , 26);
            self.playStatusLabel.text = @"课时未开始";
            self.playImageView.hidden = YES;
        }else if ([self.model.liveStatus isEqualToString:@"2"] || [self.model.liveStatus isEqualToString:@"3"]){
//            self.numLabel.textColor = RGB(21, 22 , 26);
//            self.chapterNameLabel.textColor = RGB(21, 22 , 26);
//            self.playStatusLabel.textColor = RGB(21, 22 , 26);
            self.playStatusLabel.text = @"直播中";
            self.playImageView.hidden = YES;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

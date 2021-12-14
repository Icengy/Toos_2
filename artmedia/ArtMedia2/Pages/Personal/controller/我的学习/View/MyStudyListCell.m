//
//  MyStudyListCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyStudyListCell.h"
@interface MyStudyListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWatchRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *liveStatusView;


@end

@implementation MyStudyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AMCourseModel *)model{
    _model = model;
    
    [self.headImageView am_setImageWithURL:model.coverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    self.titleLabel.text = model.courseTitle;
    
    if (![model.liveCourseStatus isEqualToString:@"7"]) {
        if (model.lastestLivechapter.courseId.length > 0) {//判断有没有最近待开播课时
            self.startTimeLabel.text = [NSString stringWithFormat:@"%@开播  课时%@",model.lastestLivechapter.liveStartTime , model.lastestLivechapter.chapterSort];
        }else{
            self.startTimeLabel.text = @"";
        }
    }else{
        self.startTimeLabel.text = [NSString stringWithFormat:@"已完结 共%@课时",model.totalLessonNum];
    }
    
    //观看记录
    if (model.liveWatchCourse.watchCourseId.length > 0 ) {
        self.lastWatchRecordLabel.text = [NSString stringWithFormat:@"上次观看至：%@",[ToolUtil isEqualToNonNull:model.liveWatchCourse.chapterTitle replace:@""]];
    }else{
        self.lastWatchRecordLabel.text = @"尚未观看";
    }
    
    if ([model.liveCourseStatus isEqualToString:@"6"]) {
        self.liveStatusView.hidden = NO;
    }else{
        self.liveStatusView.hidden = YES;
    }
    
}

@end

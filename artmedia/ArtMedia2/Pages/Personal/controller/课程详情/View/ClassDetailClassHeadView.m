//
//  ClassDetailClassHeadView.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailClassHeadView.h"
@interface ClassDetailClassHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *classLabel;


@end
@implementation ClassDetailClassHeadView

+ (instancetype)share{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)setModel:(AMCourseModel *)model{
    _model = model;
    NSString *str;
    //课程状态 1:初始状态;2:已发布未审核=审核中;3:审核失败;   4:待授课;   5:授课中;6:授课直播中;   7:授课完结
    if ([model.liveCourseStatus isEqualToString:@"1"] || [model.liveCourseStatus isEqualToString:@"2"] ||[model.liveCourseStatus isEqualToString:@"3"]) {
        str = [NSString stringWithFormat:@"（共%@个课时，尚未开播）",model.totalLessonNum];
    }else{
        if ([model.liveCourseStatus isEqualToString:@"7"]) {
            str = [NSString stringWithFormat:@"（共%@个课时，已全部播完）",model.totalLessonNum];
        }else if ([model.liveCourseStatus isEqualToString:@"4"]){
            str = [NSString stringWithFormat:@"（共%@个课时，待开播）",model.totalLessonNum];
        }else{//5 6
            str = [NSString stringWithFormat:@"（共%@个课时，已直播%@课时）",model.totalLessonNum, [ToolUtil isEqualToNonNull:model.totalLiveLessonNum replace:@"0"]];
        }
    }
    self.classLabel.text = str;
   
}
@end

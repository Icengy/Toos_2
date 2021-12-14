//
//  ClassDetailClassCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailClassCell.h"
@interface ClassDetailClassCell ()
@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UIStackView *playStackView;



@end
@implementation ClassDetailClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(AMCourseChapterModel *)model{
    _model = model;
    self.classNumLabel.text = [NSString stringWithFormat:@"%02ld",[model.chapterSort integerValue]];
    self.classTitleLabel.text = model.chapterTitle;
    if ([self.courseModel.isFree isEqualToString:@"1"]) {
        self.classTimeLabel.text = [NSString stringWithFormat:@"%@开播",model.liveStartTime];
    }else{
        if ([model.isFree isEqualToString:@"1"]) {//1:免费;2:收费'
            NSString *string1 = [NSString stringWithFormat:@"%@开播", model.liveStartTime];
            NSString *string2 = @"   免费课时";
            NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string1,string2]];
            [attstring addAttributes:@{NSForegroundColorAttributeName:RGB(233, 139, 17)} range:NSMakeRange(string1.length, string2.length)];
            self.classTimeLabel.attributedText = attstring;
        }else{
            self.classTimeLabel.text = [NSString stringWithFormat:@"%@开播",model.liveStartTime];
        }
    }
    
    
    //判断状态Label显示与否
    if ([model.liveStatus isEqualToString:@"1"] && [model.isFree isEqualToString:@"1"]) {//未开播,并且免费
        self.statusLabel.hidden = NO;
    }else{
        self.statusLabel.hidden = YES;
    }
  
    
    
    //判断右侧播放按钮显示与否
    if ([model.liveStatus isEqualToString:@"1"]) {
        self.classNumLabel.textColor = RGB(21, 22, 26);
        self.classTitleLabel.textColor = RGB(21, 22, 26);
        self.playLabel.text = @"";
        self.playStackView.hidden = YES;
        self.playImageView.hidden = YES;
    }else{
        self.playStackView.hidden = NO;
        if ([model.liveStatus isEqualToString:@"2"]) {//直播中
            self.classNumLabel.textColor = RGB(228, 49, 49);
            self.classTitleLabel.textColor = RGB(228, 49, 49);
            self.playLabel.text = @"直播中";
            self.playLabel.textColor = RGB(228, 49, 49);
            self.playImageView.image = [UIImage imageNamed:@"playred_classdetail"];
            self.playImageView.hidden = NO;
        }else if ([model.liveStatus isEqualToString:@"3"]){//直播中讲师离开直播间
            self.classNumLabel.textColor = RGB(228, 49, 49);
            self.classTitleLabel.textColor = RGB(228, 49, 49);
            self.playLabel.text = @"讲师离开直播间";
            self.playLabel.textColor = RGB(228, 49, 49);
            self.playImageView.image = [UIImage imageNamed:@"playred_classdetail"];
            self.playImageView.hidden = NO;
        }else if ([model.liveStatus isEqualToString:@"4"] || [model.liveStatus isEqualToString:@"5"]){//4:直播已结束=回放视频生成中;5:回放视频生成失败
            self.classNumLabel.textColor = RGB(21, 22, 26);
            self.classTitleLabel.textColor = RGB(21, 22, 26);
            self.playLabel.text = @"回放生成中";
            self.playLabel.textColor = RGB(21, 22, 26);
            self.playImageView.hidden = YES;
        }else if ([model.liveStatus isEqualToString:@"6"]){//回放视频生成成功
            self.classNumLabel.textColor = RGB(21, 22, 26);
            self.classTitleLabel.textColor = RGB(21, 22, 26);
            self.playLabel.text = @"看回放";
            self.playLabel.textColor = RGB(21, 22, 26);
            self.playImageView.image = [UIImage imageNamed:@"playblack_classdetail"];
            self.playImageView.hidden = NO;
        }
    }
}


@end

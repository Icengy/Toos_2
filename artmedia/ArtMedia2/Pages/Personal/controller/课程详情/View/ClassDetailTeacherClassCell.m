//
//  ClassDetailTeacherClassCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailTeacherClassCell.h"
@interface ClassDetailTeacherClassCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *joinRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *finishClassButton;
@property (weak, nonatomic) IBOutlet UIButton *watchReplayButton;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *watchLiveButton;



@end
@implementation ClassDetailTeacherClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setChapterModel:(AMCourseChapterModel *)chapterModel{
    _chapterModel = chapterModel;
    self.numLabel.text = [NSString stringWithFormat:@"%02ld",[chapterModel.chapterSort integerValue]];
    self.classTitleLabel.text = chapterModel.chapterTitle;
    if ([self.courseModel.isFree isEqualToString:@"1"]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@开播",chapterModel.liveStartTime];
    }else{
        if ([chapterModel.isFree isEqualToString:@"1"]) {//1:免费;2:收费'
            NSString *string1 = [NSString stringWithFormat:@"%@开播", chapterModel.liveStartTime];
            NSString *string2 = @"   免费课时";
            NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string1,string2]];
            [attstring addAttributes:@{NSForegroundColorAttributeName:RGB(233, 139, 17)} range:NSMakeRange(string1.length, string2.length)];
            self.timeLabel.attributedText = attstring;
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"%@开播",chapterModel.liveStartTime];
        }
    }
    //判断底部Label显示文字和颜色、是否显示这个Label
    //直播状态
    //1:未直播
    //2:直播中  3:直播中讲师离开直播间
    //4:直播已结束=回放视频生成中   5:回放视频生成失败
    //6:回放视频生成成功
    if ([chapterModel.liveStatus isEqualToString:@"4"] || [chapterModel.liveStatus isEqualToString:@"5"]) {//4:直播已结束=回放视频生成中;5:回放视频生成失败
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"直播已结束，回放生成中";
        self.statusLabel.textColor = RGB(153, 153, 153);
    }else{
        if ([chapterModel.liveStatus isEqualToString:@"2"] || [chapterModel.liveStatus isEqualToString:@"3"]) {//直播中
            self.statusLabel.hidden = NO;
            self.statusLabel.text = @"直播中";
            self.statusLabel.textColor = RGB(228, 49, 49);
        }else{
            self.statusLabel.hidden = YES;
        }
        
    }
    
    //判断底部按钮的显示与否
    //直播状态
    //1:未直播
    //2:直播中  3:直播中讲师离开直播间
    //4:直播已结束=回放视频生成中   5:回放视频生成失败
    //6:回放视频生成成功
    
    if ([self.courseModel.liveCourseStatus isEqualToString:@"1"] || [self.courseModel.liveCourseStatus isEqualToString:@"3"]) {//1:初始状态;3:审核失败
        self.joinRoomButton.hidden = YES;
        self.deleteButton.hidden = NO;
        self.editButton.hidden = NO;
        self.finishClassButton.hidden = YES;
        self.watchReplayButton.hidden = YES;
    }else if ([self.courseModel.liveCourseStatus isEqualToString:@"2"]){//2:已发布未审核=审核中
        self.joinRoomButton.hidden = YES;
        self.deleteButton.hidden = YES;
        self.editButton.hidden = YES;
        self.finishClassButton.hidden = YES;
        self.watchReplayButton.hidden = YES;
    }else{//4:待授课;5:授课中;6:授课直播中;7:授课完结
        if ([chapterModel.liveStatus isEqualToString:@"4"] || [chapterModel.liveStatus isEqualToString:@"5"]) {//4:直播已结束=回放视频生成中;5:回放视频生成失败
            self.joinRoomButton.hidden = YES;
            self.deleteButton.hidden = YES;
            self.editButton.hidden = YES;
            self.finishClassButton.hidden = YES;
            self.watchReplayButton.hidden = YES;
        }else{
            if ([chapterModel.liveStatus isEqualToString:@"2"] || [chapterModel.liveStatus isEqualToString:@"3"]) {//直播中
                self.joinRoomButton.hidden = NO;
                self.deleteButton.hidden = YES;
                self.editButton.hidden = YES;
                self.finishClassButton.hidden = NO;
                self.watchReplayButton.hidden = YES;
            }else{
                if ([chapterModel.liveStatus isEqualToString:@"1"]) {//待开始
                    self.joinRoomButton.hidden = NO;
                    self.deleteButton.hidden = YES;
                    self.editButton.hidden = YES;
                    self.finishClassButton.hidden = YES;
                    self.watchReplayButton.hidden = YES;
                }else{//6 回放视频生成成功
                    self.joinRoomButton.hidden = YES;
                    self.deleteButton.hidden = YES;
                    self.editButton.hidden = YES;
                    self.finishClassButton.hidden = YES;
                    self.watchReplayButton.hidden = NO;
                }
            }
        }
    }
    
    if ([self.courseModel.liveCourseStatus isEqualToString:@"2"]){
        self.buttonsView.hidden = YES;
    }else{
        self.buttonsView.hidden = NO;
    }
    
    if ([chapterModel.liveStatus isEqualToString:@"2"] || [chapterModel.liveStatus isEqualToString:@"3"]) {
        self.watchLiveButton.hidden = NO;
    }else{
        self.watchLiveButton.hidden = YES;
    }
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellButtonClick:buttonTitle:chapterModel:indexPath:)]) {
        [self.delegate cellButtonClick:self buttonTitle:sender.titleLabel.text chapterModel:self.chapterModel indexPath:self.indexPath];
    }
}

@end

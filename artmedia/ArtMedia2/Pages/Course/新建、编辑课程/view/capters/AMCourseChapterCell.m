//
//  AMCourseChapterCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseChapterCell.h"

#import "AMCourseChapterModel.h"

@interface AMCourseChapterCell ()
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@property (weak, nonatomic) IBOutlet AMButton *editBtn;

@end

@implementation AMCourseChapterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _sortLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    _timeLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _deleteBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _editBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(AMCourseChapterModel *)model {
    _model = model;
    
    _sortLabel.text = [NSString stringWithFormat:@"%02ld", [ToolUtil isEqualToNonNull:_model.chapterSort replace:@"1"].integerValue];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.chapterTitle];
    
    if ([ToolUtil isEqualToNonNull:_model.liveStartTime]) {
//        _timeLabel.text = [NSString stringWithFormat:@"%@开播",_model.liveStartTime];
        
        if ([self.courseModel.isFree isEqualToString:@"1"]) {
            if ([model.isFree isEqualToString:@"1"]) {//1:免费;2:收费'
                NSString *string1 = [NSString stringWithFormat:@"%@开播", model.liveStartTime];
                NSString *string2 = @"   免费课时";
                NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string1,string2]];
                [attstring addAttributes:@{NSForegroundColorAttributeName:RGB(233, 139, 17)} range:NSMakeRange(string1.length, string2.length)];
                _timeLabel.attributedText = attstring;
            }else{
                _timeLabel.text = [NSString stringWithFormat:@"%@开播",model.liveStartTime];
            }
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"%@开播",model.liveStartTime];
        }
        
        
        
        
    }else
        _timeLabel.text = @"时间格式错误";
}

- (IBAction)clickToDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chapterCell:didSelectedDelete:)]) {
        [self.delegate chapterCell:self didSelectedDelete:sender];
    }
}

- (IBAction)clickToEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chapterCell:didSelectedEdit:)]) {
        [self.delegate chapterCell:self didSelectedEdit:sender];
    }
}

@end

//
//  AMCoursePublishResultTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCoursePublishResultTableCell.h"

#import "AMCourseModel.h"

@interface AMCoursePublishResultTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *successIV;
@property (weak, nonatomic) IBOutlet UIImageView *failIV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet AMButton *successBtn;
@property (weak, nonatomic) IBOutlet AMButton *failBtn;

@end

@implementation AMCoursePublishResultTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont addHanSanSC:17.0 fontType:1];
    self.subTitleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    
    self.successBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
    self.failBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSuccess:(BOOL)success {
    _success = success;
    
    _successIV.hidden = !_success;
    _failIV.hidden = _success;
    
    _successBtn.hidden = !_success;
    _failBtn.hidden = _success;
    
    _titleLabel.text = _success?@"发布成功":@"发布失败";
    _titleLabel.textColor = _success?Color_Black:UIColorFromRGB(0xE22020);
    
    _subTitleLabel.text = _success?@"您的课程已进入审核阶段，我们将在1~3天内审核完审核通过后即可开始直播课程":@"您的课程创建失败，请重新创建！";
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

- (IBAction)clickToSuccess:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultCell:didSelectedWithSuccess:)]) {
        [self.delegate resultCell:self didSelectedWithSuccess:sender];
    }
}

- (IBAction)clickToFail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultCell:didSelectedWithFail:)]) {
        [self.delegate resultCell:self didSelectedWithFail:sender];
    }
}

@end

//
//  AMCourseEditCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseEditCell.h"
#import "AMCoursePriceEditView.h"

#import "AMCourseModel.h"

@interface AMCourseEditCell () <AMTextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AMTextField *titleTF;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet AMTextView *descTF;

@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet AMButton *freeBtn;
@property (weak, nonatomic) IBOutlet AMButton *nonFreeBtn;
@property (weak, nonatomic) IBOutlet AMCoursePriceEditView *payEditView;

@end

@implementation AMCourseEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _descLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _payLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _titleTF.font = [UIFont addHanSanSC:13.0f fontType:0];
    _descTF.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    _freeBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _nonFreeBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    _titleTF.charCount = 30;
    _titleTF.placeholder = @"请输入课程名称，30字以内";
    
    _descTF.charCount = 300;
    _descTF.placeholder = @"请输入课程简介，300字以内，非必填";
    
    [_titleTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _descTF.ownerDelegate = self;
    _payEditView.inputTF.delegate = self;
    [_payEditView.inputTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [_payEditView.inputTF addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
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

- (void)setModel:(AMCourseModel *)model {
    _model = model;
    _titleTF.text = [ToolUtil isEqualToNonNullKong:_model.courseTitle];
    _descTF.text = [ToolUtil isEqualToNonNullKong:_model.course_description];
//    _payEditView.inputTF.text = [ToolUtil isEqualToNonNullKong:_model.coursePrice];
    if (model.courseId.length > 0) {//编辑
        if ([_model.isFree isEqualToString:@"1"]) {//免费
            self.freeBtn.selected = YES;
            self.nonFreeBtn.selected = NO;
            self.payEditView.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                [self.delegate editCell:self didSeletedForCoursePrice:@"0"];
            }
        }else {//收费
            self.freeBtn.selected = NO;
            self.nonFreeBtn.selected = YES;
            self.payEditView.hidden = NO;
            self.payEditView.inputTF.text = model.coursePrice;
            if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                [self.delegate editCell:self didSeletedForCoursePrice:model.coursePrice];
            }
        }
    }else{//新建
        self.freeBtn.selected = YES;
        self.nonFreeBtn.selected = NO;
        self.payEditView.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
            [self.delegate editCell:self didSeletedForCoursePrice:@"0"];
        }
    }
    
}

#pragma mark - AMTextViewDelegate
- (BOOL)amTextViewShouldEndEditing:(AMTextView *)textView {
    return YES;
}

- (void)amTextViewDidChange:(AMTextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCourseDesc:)]) {
        [self.delegate editCell:self didSeletedForCourseDesc:textView.text];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEnd:(UITextField *)textField {
//    if ([ToolUtil isEqualToNonNull:textField.text]) {
//
//    }
    if (textField.text.integerValue < 10 || textField.text.length == 0) {
        SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
        alert.title = @"收费课程售价不能小于10艺币";
        alert.canTouchBlank = NO;
        alert.confirmBlock = ^{
            self.payEditView.inputTF.text = @"10";
            if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                [self.delegate editCell:self didSeletedForCoursePrice:@"10"];
            }
        };
        [alert show];
    }
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if ([textField isEqual:self.titleTF]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCourseTitle:)]) {
            [self.delegate editCell:self didSeletedForCourseTitle:textField.text];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
            [self.delegate editCell:self didSeletedForCoursePrice:textField.text];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    textField.text = nil;
    return YES;
}

#pragma mark -
/// 20201010
#define CoursePaySettingTag  202010100
- (IBAction)clickToPaySetting:(AMButton *)sender {
    if (sender.selected) return;
    sender.selected = !sender.selected;
    NSInteger tag = sender.tag - CoursePaySettingTag;
    if (tag) {/// 收费
        self.freeBtn.selected = NO;
        self.payEditView.hidden = NO;
        
        if (self.model.courseId.length > 0) {//编辑模式
            if (self.model.coursePrice.integerValue >= 10) {
                self.payEditView.inputTF.text = self.model.coursePrice;
                if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                    [self.delegate editCell:self didSeletedForCoursePrice:self.model.coursePrice];
                }
            }else{
                self.payEditView.inputTF.text = @"10";
                if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                    [self.delegate editCell:self didSeletedForCoursePrice:self.payEditView.inputTF.text];
                }
            }
        }else{//新建
            self.payEditView.inputTF.text = @"10";
            if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
                [self.delegate editCell:self didSeletedForCoursePrice:self.payEditView.inputTF.text];
            }
        }
    }else {//免费
        if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCoursePrice:)]) {
            [self.delegate editCell:self didSeletedForCoursePrice:@"0"];
        }
        self.nonFreeBtn.selected = NO;
        self.payEditView.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didSeletedForCourseFree:)]) {
        [self.delegate editCell:self didSeletedForCourseFree:tag?NO:YES];
    }
}

@end

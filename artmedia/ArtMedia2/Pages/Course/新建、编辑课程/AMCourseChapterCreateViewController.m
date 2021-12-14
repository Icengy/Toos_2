//
//  AMCourseChapterCreateViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseChapterCreateViewController.h"
#import <BRPickerView/BRDatePickerView.h>

#import "AMCourseChapterModel.h"


@interface AMCourseChapterCreateViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@property (weak, nonatomic) IBOutlet AMTextField *chapterTitleInptTF;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet AMTextField *timePickTF;

@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet AMButton *freeBtn;
@property (weak, nonatomic) IBOutlet UILabel *freeTipsLabel;

@property (weak, nonatomic) IBOutlet AMButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet AMButton *commitBtn;

@end

@implementation AMCourseChapterCreateViewController {
    NSDate *_currentData;
}

- (instancetype)init {
    if (self = [super init]) {
        //设置弹出的效果
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;//全屏透视
        //设置转场的效果
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.titleLabel.font = [UIFont addHanSanSC:17.0 fontType:0];
        self.chapterTitleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
        self.chapterTitleInptTF.font = [UIFont addHanSanSC:13.0 fontType:0];
        
        self.timeLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
        self.timePickTF.font = [UIFont addHanSanSC:13.0 fontType:0];
        
        self.freeLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
        self.freeTipsLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
        self.freeBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
        
        self.commitBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
        self.comfirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
        
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [Color_Black colorWithAlphaComponent:0.8];
    _currentData = [NSDate date];
    
    self.titleLabel.text = self.isEditChapter?@"编辑课时":@"添加新课时";
    self.comfirmBtn.hidden = self.isEditChapter;
    self.commitBtn.hidden = !self.isEditChapter;
    
    self.chapterTitleInptTF.charCount = 50;
    self.chapterTitleInptTF.delegate = self;
    self.timePickTF.delegate = self;
    self.timePickTF.rightViewMode = UITextFieldViewModeAlways;
    
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 26.0f, 26.0f);
    [rightBtn setImage:ImageNamed(@"course_time_down") forState:UIControlStateNormal];
    self.timePickTF.rightView = rightBtn;
    
    if (![ToolUtil isEqualToNonNull:_model.liveStartTime]) {
        NSDate *minDate = [NSDate br_setYear:_currentData.br_year month:_currentData.br_month day:_currentData.br_day+1 hour:(_currentData.br_hour ) minute:_currentData.br_minute];
        _model.liveStartTime = [NSDate br_stringFromDate:minDate dateFormat:AMDataFormatter2];
    }
    
    [self fillUIsWithModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)fillUIsWithModel {
    
    self.chapterTitleLabel.text = [NSString stringWithFormat:@"课时%@",[ToolUtil isEqualToNonNull:_model.chapterSort replace:@"0"]];
    
    self.chapterTitleInptTF.text = [ToolUtil isEqualToNonNullKong:_model.chapterTitle];
    self.timePickTF.text = [ToolUtil isEqualToNonNullKong:_model.liveStartTime];
    
    self.freeBtn.selected = (_model.isFree.integerValue == 1)?YES:NO;
    
    if ([_courseModel.isFree isEqualToString:@"1"]) {
        self.freeBtn.hidden = YES;
        self.freeLabel.hidden = YES;
        self.freeTipsLabel.hidden = YES;
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.timePickTF]) {
        [self.view endEditing:YES];
        [self showTimePicker];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.chapterTitleInptTF]) {
        _model.chapterTitle = textField.text;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickToSelectFree:(AMButton *)sender {
    if ([self.courseIsFree isEqual:@"1"]) {
        [SVProgressHUD showMsg:@"免费课程的课时不能设为收费的"];
        return;
    }
    sender.selected = !sender.selected;
    _model.isFree = sender.selected?@"1":@"2";
}

- (IBAction)clickToAdd:(id)sender {
    if (![ToolUtil isEqualToNonNull:_model.chapterTitle]) {
        [SVProgressHUD showMsg:@"请输入课时名称"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.clickToAddBlock) self.clickToAddBlock(self.model);
    }];
}

- (IBAction)clickToEdit:(id)sender {
    if (![ToolUtil isEqualToNonNull:_model.chapterTitle]) {
        [SVProgressHUD showMsg:@"请输入课时名称"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.clickToEditBlock) self.clickToEditBlock(self.model);
    }];
}

#pragma mark -
- (void)showTimePicker {
    BRDatePickerView *pickerView = [[BRDatePickerView alloc] init];
    pickerView.pickerMode = BRDatePickerModeYMDHM;
    pickerView.isAutoSelect = NO;

    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColor.whiteColor;
    customStyle.pickerTextColor = Color_Black;
    customStyle.separatorColor = UIColorFromRGB(0xCCCCCC);
    pickerView.pickerStyle = customStyle;

    NSDate *minDate = [NSDate br_setYear:_currentData.br_year month:_currentData.br_month day:_currentData.br_day + 1 hour:(_currentData.br_hour) minute:_currentData.br_minute];
    
    pickerView.minDate = minDate;
    if ([ToolUtil isEqualToNonNull:_model.liveStartTime]) {
        pickerView.selectDate = [NSDate br_dateFromString:_model.liveStartTime dateFormat:AMDataFormatter2];
    }else {
        pickerView.selectDate = minDate;
    }
    pickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        _model.liveStartTime = [NSDate br_stringFromDate:selectDate dateFormat:AMDataFormatter2];
        self.timePickTF.text = _model.liveStartTime;
    };

    [pickerView show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

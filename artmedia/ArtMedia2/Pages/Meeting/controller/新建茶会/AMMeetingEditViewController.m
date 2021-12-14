//
//  AMMeetingEditViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingEditViewController.h"

#import "AMMeetingOrderViewController.h"

#import <BRPickerView.h>
#import <BRPickerView/BRDatePickerView+BR.h>

#import "AMMeetingEditTableCell.h"
#import "AMMeetingNumberSelectView.h"
#import "AMDialogView.h"

@interface AMMeetingEditViewController () <UITableViewDelegate ,UITableViewDataSource, AMMeetingEditCellDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@property (strong, nonatomic) BRDatePickerView *datePickerView;

@property (strong, nonatomic) NSMutableArray <NSArray *>*numberDataSource;
@end

@implementation AMMeetingEditViewController {
    NSDate *_beiginDate, *_endDate, *_currentDate;
    NSString *_meetingTips;
    NSArray *_numberArray;
}

- (NSMutableArray *)numberDataSource {
    if (!_numberDataSource) {
        NSMutableArray *singleSource = @[].mutableCopy;
        for (int i = 1; i < 20; i ++) {
            [singleSource addObject:StringWithFormat(@(i + 1))];
        }
        _numberDataSource = @[singleSource, singleSource].mutableCopy;
    }return _numberDataSource;
}

- (BRDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[BRDatePickerView alloc] init];
        _datePickerView.pickerMode = BRDatePickerModeYMDHM;
        _datePickerView.isAutoSelect = YES;
        
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = UIColor.whiteColor;
        customStyle.pickerTextColor = Color_Black;
        customStyle.separatorColor = UIColorFromRGB(0xCCCCCC);
        _datePickerView.pickerStyle = customStyle;
        
    }return _datePickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"编辑会客信息"];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
    _confirmBtn.enabled = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.tableHeaderView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingEditTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingEditTableCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingEditTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingEditTableCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.style = indexPath.row;
    cell.contentStr = nil;
    switch (cell.style) {
        case AMMeetingEditTableCellStyleBeginDate: {
            if (_beiginDate) {
                cell.contentStr = [NSDate br_stringFromDate:_beiginDate dateFormat:AMDataFormatter2];
            }
            break;
        }
        case AMMeetingEditTableCellStyleExplain: {
            cell.contentStr = _meetingTips;
            break;
        }
        case AMMeetingEditTableCellStyleEndDate: {
            if (_endDate) {
                cell.contentStr = [NSDate br_stringFromDate:_endDate dateFormat:AMDataFormatter2];
            }
            break;
        }
        case AMMeetingEditTableCellStyleNumber: {
            if (_numberArray) {
                cell.contentStr = [NSString stringWithFormat:@"%@~%@",_numberArray.firstObject, _numberArray.lastObject];
            }
            
            break;
        }
            
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0, tableView.width - 30.0f, 50.0f)];
    
    return wrapView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)clickToConfirm:(id)sender {
    AMMeetingConfirmDialogView *dialogView = [AMMeetingConfirmDialogView shareInstance];
    dialogView.inviteCount = _selectedArray.count;
    dialogView.beginDate = [NSDate br_stringFromDate:_beiginDate dateFormat:AMDataFormatter2];// 开始时间
    dialogView.numberRangeArray = _numberArray;
    dialogView.meetingTips = _meetingTips;
    dialogView.meetingConfirmBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [self didSelectedToConfirm:sender];
        });
    };
    [dialogView show];
}

- (void)didSelectedToConfirm:(id)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"artistId"] = [UserInfoManager shareManager].uid;
    params[@"teaStartTime"] = [NSDate br_stringFromDate:_beiginDate dateFormat:AMDataFormatter2];// 开始时间
    params[@"teaSignUpEndTime"] = [NSDate br_stringFromDate:_endDate dateFormat:AMDataFormatter2];// 会客报名截止时间
    params[@"teaDesc"] = [ToolUtil isEqualToNonNullKong:_meetingTips];//会客说明
    params[@"peopleMax"] = StringWithFormat(_numberArray.lastObject);
    params[@"peopleMin"] = StringWithFormat(_numberArray.firstObject);
    params[@"createUserName"] = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
    
    if (_selectedArray.count) params[@"orderIds"] = _selectedArray;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addteaAbout] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showMsg:[response objectForKey:@"msg"] completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showMsg:errorMsg];
    }];
}

#pragma mark - AMMeetingEditCellDelegate
- (void)editCell:(AMMeetingEditTableCell *)editCell didFillInContent:(nonnull NSString *)contentStr style:(AMMeetingEditTableCellStyle)style {
    _meetingTips = contentStr;
    [self judgeBottomBtnState];
}

- (BOOL)editCell:(AMMeetingEditTableCell *)editCell didBeginEditContent:(AMTextView *)textView {
    if (editCell.style == AMMeetingEditTableCellStyleExplain)
        return YES;
    [self.view endEditing:YES];
    if (editCell.style == AMMeetingEditTableCellStyleNumber) {
        AMMeetingNumberSelectView *selectView = [AMMeetingNumberSelectView shareInstance];
        selectView.selectedArray = _numberArray;
        selectView.numberChangedBlock = ^(NSArray * _Nullable numberArray) {
            _numberArray = numberArray;
            editCell.contentStr = [NSString stringWithFormat:@"%@~%@",_numberArray.firstObject, _numberArray.lastObject];
            [self judgeBottomBtnState];
        };
        [selectView show];
    }else {
        _currentDate = [NSDate date];
        if (editCell.style == AMMeetingEditTableCellStyleBeginDate) {
            NSDate *minDate = [NSDate br_setYear:_currentDate.br_year month:_currentDate.br_month day:_currentDate.br_day hour:(_currentDate.br_hour + 2) minute:_currentDate.br_minute];
            NSDate *maxDate = [NSDate br_setYear:minDate.br_year month:(minDate.br_month + 1) day:minDate.br_day hour:minDate.br_hour minute:(minDate.br_minute - 1)];
            if (!_beiginDate) _beiginDate = minDate;
            
            self.datePickerView.title = @"选择会客开始时间";
            self.datePickerView.selectDate = _beiginDate;
            self.datePickerView.minDate = minDate;
            self.datePickerView.maxDate = maxDate;
            @weakify(self);
            self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                NSLog(@"选择的值：%@", selectValue);
                @strongify(self);
                _beiginDate = selectDate;
                _endDate = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self judgeBottomBtnState];
                });
            };
        }else {
            if (!_beiginDate) {
                [SVProgressHUD showMsg:@"请先设定会客开始时间"];
                return NO;
            }
            /// 大于当前时间50分钟 （10分钟）
            NSDate *minDate = [NSDate br_setYear:_currentDate.br_year month:_currentDate.br_month day:_currentDate.br_day hour:(_currentDate.br_hour + 1) minute:(_currentDate.br_minute - 10)];
            /// 小于当前时间1小时
            NSDate *maxDate = [NSDate br_setYear:_beiginDate.br_year month:_beiginDate.br_month day:_beiginDate.br_day hour:(_beiginDate.br_hour - 1) minute:_beiginDate.br_minute];
            
            BOOL minMoreThanMax = ([self.datePickerView br_compareDate:minDate targetDate:maxDate dateFormat:AMDataFormatter2] == NSOrderedDescending);
            if (minMoreThanMax) {
                [SVProgressHUD showMsg:@"报名截止时间过短，请重新选择" completion:^{
                    _beiginDate = nil;
                    _endDate = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self judgeBottomBtnState];
                    });
                }];
                return NO;
            }
            
            if (!_endDate) _endDate = minDate;
            
            self.datePickerView.title = @"设定会客截止报名时间";
            self.datePickerView.selectDate = _endDate;
            self.datePickerView.minDate = minDate;
            self.datePickerView.maxDate = maxDate;
            @weakify(self);
            self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                @strongify(self);
                _endDate = selectDate;
                editCell.contentStr = [NSDate br_stringFromDate:self->_endDate dateFormat:AMDataFormatter2];
                [self judgeBottomBtnState];
            };
        }
        [self.datePickerView show];
    }
    return NO;
}

#pragma mark -
- (void)judgeBottomBtnState {
    if (_beiginDate && _endDate && [ToolUtil isEqualToNonNull:_meetingTips] && _numberArray.count == 2) {
        self.confirmBtn.enabled = YES;
    }else
        self.confirmBtn.enabled = NO;
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

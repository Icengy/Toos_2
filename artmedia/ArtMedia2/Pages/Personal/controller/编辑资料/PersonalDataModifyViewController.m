//
//  PersonalDataModifyViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/18.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalDataModifyViewController.h"

#define AMDefaultSignature @"他很懒，什么都没说哦..."

@interface PersonalDataModifyViewController () <UITextFieldDelegate, AMTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *nameModView;

@property (weak, nonatomic) IBOutlet UITextField *nameModTF;
@property (weak, nonatomic) IBOutlet UILabel *nameLengthLabel;


@property (weak, nonatomic) IBOutlet UIView *introModView;
@property (weak, nonatomic) IBOutlet AMTextView *introModTV;

@property (weak, nonatomic) IBOutlet AMButton *modifySaveBtn;

@property (nonatomic ,copy) NSString *inputStr;
@end

@implementation PersonalDataModifyViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    _modifySaveBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    [_modifySaveBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_modifySaveBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
	
	_nameModView.hidden = _modeifyType;
	_introModView.hidden = !_modeifyType;
	if (_modeifyType) {
		_introModTV.ownerDelegate = self;
		_introModTV.placeholder = @"请输入个人简介";
        _introModTV.charCount = 50;
        if ([AMDefaultSignature isEqualToString:[UserInfoManager shareManager].model.signature]) {
            _introModTV.text = nil;
        }else
            _introModTV.text = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.signature];
	}else {
		_nameModTF.delegate = self;
		_nameModTF.font = [UIFont addHanSanSC:15.0f fontType:1];
        _nameModTF.placeholder = @"请输入你的昵称";
		_nameModTF.text = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
		_nameLengthLabel.text = [NSString stringWithFormat:@"%@/10",@([[ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username] length])];
		[_nameModTF addTarget:self action:@selector(namModTFValueChanged:) forControlEvents:UIControlEventEditingChanged];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:_modeifyType?@"修改简介":@"修改名字"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

#pragma mark -
- (BOOL)amTextViewShouldEndEditing:(AMTextView *)textView {
    self.inputStr = textView.text;
	[_introModTV resignFirstResponder];
	return YES;
}

- (void)amTextViewDidChange:(AMTextView *)textView {
    self.inputStr = textView.text;
    if ([self.inputStr isEqualToString:[ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.signature]]) {
        _modifySaveBtn.enabled = NO;
    }else
        _modifySaveBtn.enabled = YES;
}

- (void)namModTFValueChanged:(UITextField *)textField {
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;//键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length > 10) {
                textField.text = [textField.text substringToIndex:10];
            }
        }else{ //有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (textField.text.length >10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    self.inputStr = textField.text;
    _nameLengthLabel.text = [NSString stringWithFormat:@"%@/10",@(textField.text.length)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.inputStr = textField.text;
	[_nameModTF resignFirstResponder];
	return YES;
}


- (void)setInputStr:(NSString *)inputStr {
    _inputStr = inputStr;
    if (_modeifyType) return;
    if ([ToolUtil isEqualToNonNull:_inputStr] && _inputStr.length > 0) {
        self.modifySaveBtn.enabled = YES;
    }else {
        self.modifySaveBtn.enabled = NO;
    }
}

#pragma mark -
- (IBAction)clickToSave:(AMButton *)sender {
    if (_modeifyType == 0) {
        if ((![ToolUtil isEqualToNonNull:self.inputStr] || self.inputStr.length <= 0)) {
            [SVProgressHUD showMsg:@"名字不能为空！"];
            return;
        }
        if ([[self.inputStr substringToIndex:1] isEqualToString:@" "]) {
            [SVProgressHUD showMsg:@"名字首字符不能为空格！"];
            return;
        }
        if ([[self.inputStr substringToIndex:1] isEqualToString:@"_"]) {
            [SVProgressHUD showMsg:@"名字首字符不能为下划线！"];
            return;
        }
    }

	NSMutableDictionary *params = [NSMutableDictionary new];
	params[@"uid"] = [UserInfoManager shareManager].uid;
    
	if (!_modeifyType) {
		NSLog(@"修改名字");
		params[@"uname"] = self.inputStr;
	}else {
		NSLog(@"修改简介");
        if (_introModTV.text.length) {
            params[@"signature"] = self.inputStr;
        }else
            params[@"signature"] = AMDefaultSignature;
	}
	
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"修改成功" completion:^{
            [[UserInfoManager shareManager] updateUserDataWithKey:params.allKeys.lastObject value:params.allValues.lastObject complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    } fail:nil];
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

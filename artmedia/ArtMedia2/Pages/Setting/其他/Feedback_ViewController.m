//
//  Feedback_ViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "Feedback_ViewController.h"

#import "FeedBack_SettingView.h"

@interface Feedback_ViewController () <AMTextViewDelegate>

@property (nonatomic ,strong) FeedBack_SettingView *contentView;
@property (nonatomic ,strong) AMButton *commitFeedBtn;
@end

@implementation Feedback_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    [self.view addSubview:self.contentView];
	[self.view addSubview:self.commitFeedBtn];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.commitFeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view.mas_bottom).offset(-(SafeAreaBottomHeight+4.0f));
		make.centerX.equalTo(self.view);
		make.height.offset(self.commitFeedBtn.height);
		make.width.offset(self.commitFeedBtn.width);
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (FeedBack_SettingView *)contentView{
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"FeedBack_SettingView" owner:nil options:nil].lastObject;
        [_contentView setFrame:CGRectMake(0, SafeAreaTopHeight, K_Width, 240.f)];
		_contentView.textView.ownerDelegate = self;
    }
    return _contentView;
}

- (AMButton *)commitFeedBtn {
	if (!_commitFeedBtn) {
		_commitFeedBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		_commitFeedBtn.frame = CGRectMake(0, 0, K_Width - ADAptationMargin *2, ADBottomButtonHeight);
		_commitFeedBtn.backgroundColor = Color_Grey;
		_commitFeedBtn.layer.cornerRadius = ADBottomButtonHeight/2;
		_commitFeedBtn.clipsToBounds = YES;
		_commitFeedBtn.enabled = NO;
		
		[_commitFeedBtn setTitle:@"提交" forState:UIControlStateNormal];
		[_commitFeedBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
		_commitFeedBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
		_commitFeedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
		
		[_commitFeedBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
	}return _commitFeedBtn;
}

#pragma mark -
- (void)amTextViewDidChange:(AMTextView *)textView {
	if (textView.text.length) {
		self.commitFeedBtn.enabled = YES;
		self.commitFeedBtn.backgroundColor = Color_Black;
	}else {
		self.commitFeedBtn.enabled = NO;
		self.commitFeedBtn.backgroundColor = Color_Grey;
	}
}

#pragma mark -
- (void)commitAction:(id)sender {
    NSString *content = self.contentView.textView.text;
    if (content.length == 0) {
		[SVProgressHUD showMsg:@"请输入内容！"];
		return;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"感谢您的反馈！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureact = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:sureact];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

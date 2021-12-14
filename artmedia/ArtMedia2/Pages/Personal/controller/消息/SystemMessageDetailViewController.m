//
//  SystemMessageDetailViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SystemMessageDetailViewController.h"

#import "MyMessageTableViewCell.h"

#import "MessageInfoModel.h"

@interface SystemMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeightConstraint;

@end

@implementation SystemMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.navigationItem setTitle:@"消息详情"];
    
	_nameLabel.font = [UIFont addHanSanSC:21.0f fontType:2];
	_timeLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_contentTV.font = [UIFont addHanSanSC:16.0f fontType:0];
	
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.message_title];
	_nameHeightConstraint.constant = [_nameLabel.text sizeWithFont:_nameLabel.font andMaxSize:CGSizeMake(_nameLabel.width, CGFLOAT_MAX)].height+ADAptationMargin/2;
    if (_model.addtime.doubleValue > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool getDifferenceToCurrentSinceTimeStamp:_model.addtime.doubleValue]];
    }else
        _timeLabel.hidden = YES;
    
    _contentTV.text = [ToolUtil isEqualToNonNullKong:_model.message_detail];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
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

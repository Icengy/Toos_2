//
//  FeedBack_SettingView.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/20.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "FeedBack_SettingView.h"

@interface FeedBack_SettingView ()

@end
@implementation FeedBack_SettingView

- (void)awakeFromNib{
    [super awakeFromNib];
	_textView.placeholder = @"请输入您的意见反馈";
	_textView.font = [UIFont addHanSanSC:14.0f fontType:0];
	_textView.layer.cornerRadius = 4.0f;
	_textView.clipsToBounds = YES;
	_textView.layer.borderColor = RGB(229, 229, 229).CGColor;
	_textView.layer.borderWidth = 0.5f;
}

@end

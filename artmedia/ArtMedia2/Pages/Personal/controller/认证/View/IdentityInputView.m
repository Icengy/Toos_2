//
//  IdentityInputView.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/28.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "IdentityInputView.h"

//@interface IdentityInputView : UIView <UITextFieldDelegate>
//
//@property (weak, nonatomic) IBOutlet UIView *inputView;
//
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
//
//@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
//
//@property (nonatomic ,copy) void(^ userInputBlock)(NSInteger index, NSString *_Nullable inputStr);
//
//+ (IdentityInputView *)shareIntance;
//
//@end
//
//@implementation IdentityInputView
//
//- (void)awakeFromNib {
//	[super awakeFromNib];
//	_inputView.layer.cornerRadius = ADAPTATIONRATIOVALUE(6.0f);
//	_inputView.clipsToBounds = YES;
//
//	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
//	_cardLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
//
//	_nameTF.font = [UIFont addHanSanSC:14.0f fontType:0];
//	_cardNumTF.font = [UIFont addHanSanSC:14.0f fontType:0];
//
//	_nameTF.delegate = self;
//	_cardNumTF.delegate = self;
//}
//
//+ (IdentityInputView *)shareIntance {
//	NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IdentityInputViewController class]) owner:nil options:nil];
//
//	NSLog(@"%@",viewArray);
//
//	return [IdentityInputView new];
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//	NSInteger index = 0;
//	if ([textField isEqual:_cardNumTF]) {
//		index = 1;
//	}
//	if (_userInputBlock) _userInputBlock(index, textField.text);
//	return YES;
//}
//
//@end

@interface IdentityInputView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@property (weak, nonatomic) IBOutlet AMTextField *nameTF;
@property (weak, nonatomic) IBOutlet AMTextField *cardNumTF;

@end

@implementation IdentityInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
	[super awakeFromNib];
	_titleLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
	
	_inputView.layer.cornerRadius = 4.0f;
	_inputView.clipsToBounds = YES;
	
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_cardLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_nameTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	_cardNumTF.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_nameTF.delegate = self;
	_cardNumTF.delegate = self;
}

+ (IdentityInputView *)shareIntance {
	IdentityInputView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
	return view;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	NSInteger index = 0;
	if ([textField isEqual:_cardNumTF]) {
		index = 1;
	}
	if (_userInputBlock) _userInputBlock(index, textField.text);
	return YES;
}

@end

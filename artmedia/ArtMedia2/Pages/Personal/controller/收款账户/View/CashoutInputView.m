//
//  CashoutInputView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "CashoutInputView.h"

@interface CashoutInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (weak, nonatomic) IBOutlet UILabel *availableTipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTipsHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic ,strong) UILabel *leftView;
@property (nonatomic ,strong) AMButton *rightView;

@end

@implementation CashoutInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)leftView {
    if (!_leftView) {
        _leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25.0f, _inputTF.height)];
        _leftView.text = @"¥";
        _leftView.textColor = RGB(219, 17, 17);
        _leftView.font = [UIFont addHanSanSC:28.0f fontType:0];
        _leftView.textAlignment = NSTextAlignmentCenter;
        
    }return _leftView;;
}

- (AMButton *)rightView {
    if (!_rightView) {
        _rightView = [AMButton buttonWithType:UIButtonTypeCustom];
        _rightView.frame = CGRectMake(0, 0, 80.0f, _inputTF.height);
        [_rightView setTitle:@"全部提现" forState:UIControlStateNormal];
        [_rightView setTitleColor:RGB(219, 17, 17) forState:UIControlStateNormal];
        _rightView.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
        [_rightView addTarget:self action:@selector(clickToCashoutAll:) forControlEvents:UIControlEventTouchUpInside];
        
    }return _rightView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTF.font = [UIFont addHanSanSC:28.0f fontType:1];
    self.tipsLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.availableTipsLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    self.inputTF.delegate = self;
    [self.inputTF addTarget:self action:@selector(inputTVTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.inputTF.leftViewMode = UITextFieldViewModeAlways;
    self.inputTF.leftView = self.leftView;
    self.inputTF.rightView = self.rightView;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= ADAptationMargin;
    [super setFrame:frame];
}

- (void)setReceiveType:(NSInteger)receiveType {
    _receiveType = receiveType;
    self.availableTipsLabel.hidden = _receiveType?NO:YES;
    _availableTipsHeightConstraint.constant = _receiveType?44.0f:ADAptationMargin;
}

- (void)setAvailableCount:(NSString *)availableCount {
    _availableCount = availableCount;
    _availableTipsLabel.text = [NSString stringWithFormat:@"可提现金额：¥%@（提现金额最低10元）",[ToolUtil isEqualToNonNull:_availableCount replace:@"0"]];
    if (_receiveType &&_availableCount.doubleValue > 10.0f) {
        self.inputTF.rightViewMode = UITextFieldViewModeAlways;
    }else {
        self.inputTF.rightViewMode = UITextFieldViewModeNever;
    }

}

- (void)setShouldCount:(NSString *)shouldCount {
    _shouldCount = shouldCount;
    if ([ToolUtil isEqualToNonNull:_shouldCount])
        self.inputTF.text = StringWithFormat(_shouldCount);
}

- (void)inputTVTextDidChange:(id)sender {
    self.shouldCount = self.inputTF.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewValueChanged:)]) {
        [self.delegate inputViewValueChanged:self.shouldCount];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!_receiveType) return NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text) {
        if ([[textField.text substringWithRange:NSMakeRange(textField.text.length - 1, 1)] isEqualToString:@"."]) {
            self.shouldCount = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewValueChanged:)]) {
                [self.delegate inputViewValueChanged:self.shouldCount];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //如果输入的是“.”  判断之前已经有"."或者字符串为空
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
        return NO;
    }
    //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (str.length >= [str rangeOfString:@"."].location + 4) {
        return NO;
    }
    return YES;
}

#pragma mark -
- (void)clickToCashoutAll:(id)sender {
    self.shouldCount = self.availableCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewValueChanged:)]) {
        [self.delegate inputViewValueChanged:self.shouldCount];
    }
}

@end

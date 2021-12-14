//
//  SingleInputTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "SingleInputTableCell.h"

@interface SingleInputTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getiCodeBtnTrailingConstraint;
@end

@implementation SingleInputTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.inputTF.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.getCodeBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    self.inputTF.delegate = self;
    [self.inputTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    [self addRoundedCorners:self.corners withRadii:CGSizeMake(4.0f, 4.0f)];
    frame.origin.x += 10.0f;
    frame.size.width -= 10.0f * 2;
    [super setFrame:frame];
}

- (void)setCorners:(UIRectCorner)corners {
    _corners = corners;
    [self addRoundedCorners:corners withRadii:CGSizeMake(4.0f, 4.0f)];
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (_canEdit) {
        self.inputTF.text = [ToolUtil getSecretCardIDWitCardID:self.inputText];
    }else
        self.inputTF.text = self.inputText;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    if ([ToolUtil isEqualToNonNull:_titleText]) {
        self.titleLabel.text = _titleText;
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    if ([ToolUtil isEqualToNonNull:_placeholderText]) {
        self.inputTF.placeholder = _placeholderText;
    }
}

- (void)setInputText:(NSString *)inputText {
    _inputText = inputText;
    if ([ToolUtil isEqualToNonNull:_inputText]) {
        if (self.canEdit) {
            self.inputTF.text = [ToolUtil getSecretCardIDWitCardID:_inputText];
        }else
            self.inputTF.text = _inputText;
    }
}

- (void)setHideCodeBtn:(BOOL)hideCodeBtn {
    _hideCodeBtn = hideCodeBtn;
    self.getCodeBtn.hidden = _hideCodeBtn;
    self.getCodeBtnWidthConstraint.constant = _hideCodeBtn?0.0f:100.0f;
    self.getiCodeBtnTrailingConstraint.constant = _hideCodeBtn?0.0f:15.0f;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.inputTF.keyboardType = keyboardType;
}

- (void)setTimerCount:(NSInteger)timerCount {
    _timerCount = timerCount;
    if (_timerCount == 60) {
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:RGB(232, 28, 28) forState:UIControlStateNormal];
    }else {
        self.getCodeBtn.enabled = NO;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@s)",@(_timerCount)] forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:RGB(114, 114, 114) forState:UIControlStateNormal];
    }
}

- (void)textDidChanged:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:textDidChanged:)]) {
        [self.delegate cell:self textDidChanged:textField.text];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.canEdit;
}

#pragma mark -
- (IBAction)clickToGetCode:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedCodeBtn:)]) {
        [self.delegate cell:self didSelectedCodeBtn:sender];
    }
}
@end

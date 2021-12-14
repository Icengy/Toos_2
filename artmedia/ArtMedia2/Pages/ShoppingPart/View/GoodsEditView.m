//
//  GoodsEditView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsEditView.h"

#import "VideoGoodsModel.h"

@interface GoodsEditView () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_bottom_constraint;

@property (weak, nonatomic) IBOutlet UIView *priceCarrier;
@property (weak, nonatomic) IBOutlet UIView *mailCarrier;

@property (weak, nonatomic) IBOutlet UILabel *canSellLabel;
@property (weak, nonatomic) IBOutlet AMButton *sellBtn;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet AMButton *mailBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet AMTextField *priceTF;

@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation GoodsEditView {
    BOOL _isEditPrice;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
    self.frame = k_Bounds;
    
    _deleteBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _canSellLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _priceLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _mailLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
    [_confirmBtn setTitleColor:UIColorFromRGB(0xE22020) forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:Color_Grey forState:UIControlStateDisabled];
    
    _priceTF.font = [UIFont addHanSanSC:15.0f fontType:0];
    _priceTF.placeholder = @"请输入作品价格（必填）";
    _priceTF.delegate = self;
    [_priceTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
    CGRect frame = _priceTF.frame;
    frame.size.width = 8.0f;
    [_priceTF setLeftView:[[UIView alloc]initWithFrame:frame]];
    [_priceTF setLeftViewMode:UITextFieldViewModeAlways];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    /// 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardNotification:) name:UIKeyboardWillShowNotification object:nil];
    /// 监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setModel:(VideoGoodsModel *)model {
    _model = model;
    _sellBtn.selected = _model.good_sell_type;
    _mailBtn.selected = _model.freeshipping;
    if ([ToolUtil isEqualToNonNull:_model.sellprice]) {
        _priceTF.text = _model.sellprice;
    }else
        _priceTF.text = nil;
    
    [self judgeUIs:_model.good_sell_type];
}

#pragma mark -
- (IBAction)clickToDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:selecIstToDelete:)]) {
        [self.delegate editView:self selecIstToDelete:sender];
    }
}

- (IBAction)clickToCanSell:(AMButton *)sender {
    sender.selected = !sender.selected;
    [self judgeUIs:sender.selected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:selecIstToSell:)]) {
        [self.delegate editView:self selecIstToSell:sender.selected];
    }
}

- (IBAction)clickToMail:(AMButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:selecIstMail:)]) {
        [self.delegate editView:self selecIstMail:sender.selected];
    }
}

- (IBAction)clickToConfirm:(id)sender {
    [self endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:selecIstToConfirm:)]) {
        [self.delegate editView:self selecIstToConfirm:sender];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isEditPrice = YES;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:userInputResultForPriceWithinputStr:)]) {
        [self.delegate editView:self userInputResultForPriceWithinputStr:textField.text];
    }
    _isEditPrice = NO;
    return YES;
}

- (void)textFieldTextDidChanged:(UITextField *)textField {
    if (![ToolUtil valifyInputPrice:textField.text]) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
    }
    if (textField.text && textField.text.length) {
        _confirmBtn.enabled = YES;
    }else
        _confirmBtn.enabled = NO;
}

#pragma mark -
- (void)judgeUIs:(BOOL)hidden {
    _priceCarrier.hidden = !hidden;
    _mailCarrier.hidden = YES;
    
    if (hidden) {
        if (_priceTF.text && _priceTF.text.length) {
            _confirmBtn.enabled = YES;
        }else
            _confirmBtn.enabled = NO;
    }else
        _confirmBtn.enabled = YES;
}

- (void)handleKeyBoardNotification:(NSNotification *)noti {
    NSValue *value = [noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    __block float keyboardHeight = keyboardSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.content_bottom_constraint.constant = keyboardHeight;
    }];
}

- (void)hideKeyBoardNotification:(NSNotification *)noti {
    [UIView animateWithDuration:0.3 animations:^{
        self.content_bottom_constraint.constant = 0.0f;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) return NO;
    if (_isEditPrice) return NO;
    return YES;
}


@end

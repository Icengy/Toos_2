//
//  AuctionItemHeadView.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemHeadView.h"

@interface AuctionItemHeadView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet AMTextField *textField;
@property (weak, nonatomic) IBOutlet AMTextField *nameTextF;
@property (strong, nonatomic) AMButton *goNameBtn;
@property (strong, nonatomic) AMButton *goNumBtn;
@property (nonatomic , copy) NSString *totalAmount;
@property (nonatomic, assign) BOOL nameShowClose;
@end

@implementation AuctionItemHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    [self setupTextField:self.textField nameTextF:NO];
    [self setupTextField:self.nameTextF nameTextF:YES];
}

- (void)setupTextField:(AMTextField *)textF nameTextF:(BOOL)nameTextF
{
    textF.font = [UIFont addHanSanSC:12.0 fontType:0];
    textF.delegate = self;
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.textField.height, self.textField.height)];
    wrapView.backgroundColor = UIColor.clearColor;
    if (nameTextF) {
        self.goNameBtn.frame = wrapView.bounds;
        [wrapView addSubview:self.goNameBtn];
    } else {
        self.goNumBtn.frame = wrapView.bounds;
        [wrapView addSubview:self.goNumBtn];
    }
    textF.rightView = wrapView;
    textF.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setup:(NSString *)totalAmount nameTextF:(NSString *)nameTextFStr
{
    self.totalAmount = totalAmount;
    _numberLabel.text = [NSString stringWithFormat:@"拍品图录（%@件）",[ToolUtil isEqualToNonNull:_totalAmount replace:@"0"]];
    self.nameTextF.text = nameTextFStr;
    [self showNameCloseTextFiled:nameTextFStr.length];

}
- (void)showNameCloseTextFiled:(BOOL)nameTextFLength
{
    self.nameShowClose = nameTextFLength;
    if (nameTextFLength) {
        [self.goNameBtn setImage:ImageNamed(@"icon-delete-auctionDet") forState:UIControlStateNormal];
        [self.goNameBtn setImage:ImageNamed(@"icon-delete-auctionDet") forState:UIControlStateHighlighted];
    } else {
        [self.goNameBtn setImage:ImageNamed(@"icon-search-auctionDet") forState:UIControlStateNormal];
        [self.goNameBtn setImage:ImageNamed(@"icon-search-auctionDet") forState:UIControlStateHighlighted];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextF) {
        if (![ToolUtil isEqualToNonNull:self.nameTextF.text]) return;
        if (self.clickToGoAnyDetail) self.clickToGoAnyDetail(NO,self.nameTextF.text);
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.nameTextF) {
        [textField resignFirstResponder];
        [self showNameCloseTextFiled:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextF) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nameTextF) {
        [self showNameCloseTextFiled:NO];
    }
    return YES;
}

#pragma mark -
- (void)clickToGo:(id)btn
{
    if (btn == self.goNumBtn) {
        [self.textField resignFirstResponder];
        if (![ToolUtil isEqualToNonNull:self.textField.text]) return;
        if (self.clickToGoAnyDetail) self.clickToGoAnyDetail(YES,self.textField.text);
    } else {
        [self.nameTextF resignFirstResponder];
        if (![ToolUtil isEqualToNonNull:self.nameTextF.text]) return;
        if (self.nameShowClose) {
            self.nameTextF.text = @"";
        }
        if (self.clickToGoAnyDetail) self.clickToGoAnyDetail(NO,self.nameTextF.text);

    }
}

#pragma mark - Lazy
- (AMButton *)goNameBtn
{
    if (!_goNameBtn) {
        _goNameBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        [_goNameBtn setImage:ImageNamed(@"icon-search-auctionDet") forState:UIControlStateNormal];
        [_goNameBtn setImage:ImageNamed(@"icon-search-auctionDet") forState:UIControlStateHighlighted];
        [_goNameBtn addTarget:self action:@selector(clickToGo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goNameBtn;
}

- (AMButton *)goNumBtn
{
    if (!_goNumBtn) {
        _goNumBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        [_goNumBtn setImage:ImageNamed(@"icon-auctionProDet-arrowright") forState:UIControlStateNormal];
        [_goNumBtn setImage:ImageNamed(@"icon-auctionProDet-arrowright") forState:UIControlStateHighlighted];
        [_goNumBtn addTarget:self action:@selector(clickToGo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goNumBtn;
}
@end

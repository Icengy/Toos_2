//
//  MyInviterView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyInviterView.h"

#import "MyInviterItemFillView.h"
#import "MyInviterItemFilledView.h"

#import "InviteInfoModel.h"

@interface MyInviterView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,strong) IBOutlet MyInviterItemFillView *fillView;
@property (weak, nonatomic) IBOutlet UIButton *coonfirmBtn;
@property (nonatomic ,strong) IBOutlet MyInviterItemFilledView *filledView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation MyInviterView {
    /// 填写的邀请码
    NSString *_Nullable _fillInviteCode;
    BOOL _canTouchHidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.frame = k_Bounds;
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _canTouchHidden = NO;
    
    _titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    _tipsLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _coonfirmBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:1];
    
    self.fillView.endEditingBlock = ^(NSString * _Nullable inputCode) {
        _fillInviteCode = inputCode;
    };
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setInviterModel:(InviteInfoModel *)inviterModel {
    _inviterModel = inviterModel;
    self.fillView.inputTF.text = nil;
    if (_inviterModel) {
        _canTouchHidden = YES;
        
        self.titleLabel.text = @"我的邀请人";
        
        self.fillView.hidden = YES;
        self.filledView.hidden = NO;
        self.tipsLabel.hidden = YES;
        
        self.filledView.filledModel = _inviterModel;
    }else {
        self.fillView.hidden = NO;
        self.filledView.hidden = YES;
        self.tipsLabel.hidden = NO;
    }
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    if (_inviterModel) {
        [self hide];
    }else {
        if (![ToolUtil isEqualToNonNull:_fillInviteCode]) {
            [SVProgressHUD showError:@"您还未输入对方的邀请码"];
            return;
        }
        if (_confirmBlock) _confirmBlock(_fillInviteCode);
        if (_canTouchHidden) {
            [self hide];
        }
    }
}

- (IBAction)clickToBack:(id)sender {
    [self hide];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return _canTouchHidden;
}

@end

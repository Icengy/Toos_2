//
//  DiscussInputView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/7.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussInputView.h"

@interface DiscussInputView () <AMTextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet AMTextView *inputView;
@property (weak, nonatomic) IBOutlet AMButton *finishBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBottomConstraint;

@end

@implementation DiscussInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

static BOOL _hadInstance = NO;
+ (instancetype)shareInstance {
    DiscussInputView *inputView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    return inputView;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
        self.frame = [UIScreen mainScreen].bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _inputView.ownerDelegate = self;
    _inputView.text = nil;
    _inputView.placeholder = @"写下你想说的...";
    _inputView.charCount = 80;
    _inputView.font = [UIFont addHanSanSC:15.0f fontType:0];
    _finishBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _finishBtn.enabled = [ToolUtil isEqualToNonNull:_inputView.text];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _inputView.placeholder = @"写下你想说的...";
    if ([ToolUtil isEqualToNonNull:_placeholder]) {
        _inputView.placeholder = _placeholder;
    }
}

#pragma mark -
- (void)amTextViewDidChange:(AMTextView *)textView {
    _finishBtn.enabled = [ToolUtil isEqualToNonNull:textView.text];
    if (textView.contentSize.height > 40.0f) {
        _inputHeightConstraint.constant = textView.contentSize.height;
    }else {
        _inputHeightConstraint.constant = 40.0f;
    }
}

- (IBAction)clickToFinish:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:didFinishInputWith:)]) {
        [self.delegate inputView:self didFinishInputWith:_inputView.text];
    }
}

#pragma mark -
- (void)show {
    [self showWithKeybord:NO];
}

- (void)showWithKeybord:(BOOL)on {
    if (!self) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^ {
        
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _inputView.charCount = 80;
            if (on) [self.inputView becomeFirstResponder];
        });
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^ {
    }completion:^(BOOL finished) {
        _hadInstance = NO;
        [self endEditing:YES];
        [self removeFromSuperview];
    }];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.maxY = keyboardFrame.origin.y+15.f;
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.maxY = K_Height;
    }];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.inputView]) {
        return NO;
    }
    return YES;
}


@end

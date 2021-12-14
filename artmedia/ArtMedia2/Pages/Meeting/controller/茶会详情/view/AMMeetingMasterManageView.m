//
//  AMMeetingMasterManageView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/31.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingMasterManageView.h"

@interface AMMeetingMasterManageView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet AMButton *cancelBtn;

@property (weak, nonatomic) IBOutlet AMButton *eidtBtn;
@property (weak, nonatomic) IBOutlet AMButton *inviteListBtn;
@property (weak, nonatomic) IBOutlet AMButton *meetingCancelBtn;


@end

@implementation AMMeetingMasterManageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(HK_tea_managerModel *)model{
    _model = model;
    if (model.infoStatus == 2) {
        self.eidtBtn.hidden = YES;
    }else if(model.infoStatus == 3 || model.infoStatus == 4){
        self.eidtBtn.hidden = YES;
        self.meetingCancelBtn.hidden = YES;
    }
    
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _cancelBtn.titleLabel.font = [UIFont addHanSanSC:16.0 fontType:0];
    
    _eidtBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _inviteListBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _meetingCancelBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setStyle:(AMMeetingMasterManageStyle)style {
    _style = style;
    if (_style == AMMeetingMasterManageStyleDetault) {
        _eidtBtn.hidden = NO;
        _inviteListBtn.hidden = NO;
        _meetingCancelBtn.hidden = NO;
    }else {
        _eidtBtn.hidden = YES;
        _inviteListBtn.hidden = NO;
        _meetingCancelBtn.hidden = YES;
    }
}

#pragma mark -
- (IBAction)clickToCancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageView:didSelectedItemForCancel:)]) {
        [self.delegate manageView:self didSelectedItemForCancel:sender];
    }else
        [self hide];
}
- (IBAction)clickToEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageView:didSelectedItemForEdit:)]) {
        [self.delegate manageView:self didSelectedItemForEdit:sender];
    }
}
- (IBAction)clickToInvite:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageView:didSelectedItemForInviteList:)]) {
        [self.delegate manageView:self didSelectedItemForInviteList:sender];
    }
}
- (IBAction)clickToMeetingCancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageView:didSelectedItemForMeetingCancel:)]) {
        [self.delegate manageView:self didSelectedItemForMeetingCancel:sender];
    }
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) return NO;
    return YES;
}

@end

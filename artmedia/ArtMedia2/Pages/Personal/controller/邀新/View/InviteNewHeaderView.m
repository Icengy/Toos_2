//
//  InviteNewHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "InviteNewHeaderView.h"

@interface InviteNewHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteCountLabel;

@end

@implementation InviteNewHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.mainView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(self.mainView.height/2, self.mainView.height/2)];
}

- (void)setFrame:(CGRect)frame {
    [self.mainView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(self.mainView.height/2, self.mainView.height/2)];
    
    [super setFrame:frame];
}

- (void)setInviteCount:(NSString *)inviteCount {
    _inviteCount = inviteCount;
    _inviteCountLabel.text = [NSString stringWithFormat:@"已成功邀请%@人",_inviteCount];
}

@end

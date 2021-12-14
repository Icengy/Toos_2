//
//  InviteNewCodeTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "InviteNewCodeTableCell.h"

@interface InviteNewCodeTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet AMButton *inviteBtn;

@end

@implementation InviteNewCodeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _codeLabel.font = [UIFont addHanSanSC:24.0f fontType:1];
    _inviteBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInviteCodeStr:(NSString *)inviteCodeStr {
    _inviteCodeStr = inviteCodeStr;
    _codeLabel.text = _inviteCodeStr;
}

- (IBAction)clickToInvite:(id)sender {
    if (_inviteOtherBlock) _inviteOtherBlock();
}


@end

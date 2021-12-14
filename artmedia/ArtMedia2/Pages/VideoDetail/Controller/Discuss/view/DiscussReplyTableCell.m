//
//  DiscussReplyTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussReplyTableCell.h"

#import "DiscussItemInfoModel.h"

@interface DiscussReplyTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_widthConstriant;

@property (weak, nonatomic) IBOutlet UIView *name_view1;
@property (weak, nonatomic) IBOutlet UILabel *name_nickName1;
@property (weak, nonatomic) IBOutlet UILabel *name_mark1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark1_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark1_width;

@property (weak, nonatomic) IBOutlet UILabel *name_reply;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_reply_leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_reply_widhtConstraint;


@property (weak, nonatomic) IBOutlet UIView *name_view2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_view2_widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_view2_leadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *name_nickName2;

@property (weak, nonatomic) IBOutlet UILabel *name_mark2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark2_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark2_width;

@property (weak, nonatomic) IBOutlet UILabel *name_colon;

@end

@implementation DiscussReplyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _name_nickName1.font = [UIFont addHanSanSC:14.0f fontType:0];
    _name_mark1.font = [UIFont addHanSanSC:11.0f fontType:0];
    
    _name_reply.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    _name_nickName2.font = [UIFont addHanSanSC:14.0f fontType:0];
    _name_mark2.font = [UIFont addHanSanSC:11.0f fontType:0];
    _name_colon.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReplyModel:(DiscussItemInfoModel *)replyModel {
    _replyModel = replyModel;
    
    if (_replyModel.user_info) {
        _nameView.hidden = NO;
        _name_nickName1.text = [ToolUtil isEqualToNonNullKong:_replyModel.user_info.username];
        [self setAutherMark1Hidden:!_replyModel.is_author.boolValue];
        
        [self setAutherMark2Hidden:YES];
        if (_replyModel.to_user_info) {
            _name_reply.hidden = NO;
            _name_reply_leadingConstraint.constant = 4.0f;
            _name_view2.hidden = NO;
            _name_view2_leadingConstraint.constant = 4.0f;
            _name_nickName2.text = [ToolUtil isEqualToNonNullKong:_replyModel.to_user_info.username];
        }else {
            _name_reply.hidden = YES;
            _name_reply_leadingConstraint.constant = 0.0f;
            _name_reply_widhtConstraint.constant = 0.0f;
            _name_view2.hidden = YES;
            _name_view2_leadingConstraint.constant = 0.0f;
            _name_view2_widthConstraint.constant = 0.0f;
        }
    }else {
        _nameView.hidden = YES;
        _name_widthConstriant.constant = 0.0f;
    }
    [self.nameView layoutIfNeeded];
    
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_replyModel.reply_comment];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    NSMutableDictionary *attri = @{}.mutableCopy;
    attri[NSFontAttributeName] = [UIFont addHanSanSC:14.0f fontType:0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = _replyModel.user_info?self.nameView.width:0.0f;
    style.maximumLineHeight = self.nameView.height;
    style.lineSpacing = 4.0f;
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    attri[NSParagraphStyleAttributeName] = style;

    [attrString addAttributes:attri range:[_titleLabel.text rangeOfString:_titleLabel.text]];

    _titleLabel.attributedText = attrString;
    [_titleLabel sizeToFit];
    
    if (_layoutBlock) _layoutBlock();
}

- (void)setAutherMark1Hidden:(BOOL)isHidden {
    _name_mark1.hidden = isHidden;
    _name_mark1.text = isHidden?nil:@"作者";
    _name_mark1_leading.constant = isHidden?0.0f:4.0f;
    _name_mark1_width.constant = isHidden?0.0f:30.0f;
}

- (void)setAutherMark2Hidden:(BOOL)isHidden {
    _name_mark2.hidden = isHidden;
    _name_mark2.text = isHidden?nil:@"作者";
    _name_mark2_leading.constant = isHidden?0.0f:4.0f;
    _name_mark2_width.constant = isHidden?0.0f:30.0f;
}

@end

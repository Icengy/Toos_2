//
//  DiscussDetailTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/7.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussDetailTableCell.h"

#import "DiscussItemInfoModel.h"

@interface DiscussDetailTableCell ()

@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleMarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *name_replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *name_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *name_markLabel;
@property (weak, nonatomic) IBOutlet UILabel *name_colon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_title_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_mark_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_colon_leading;

@end

@implementation DiscussDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_iconIV addBorderWidth:2.0f borderColor:RGB(230, 230, 230)];
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _titleMarkLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _dateLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _name_titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _name_replyLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _name_markLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _name_colon.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLongPress:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(DiscussItemInfoModel *)itemModel {
    _itemModel = itemModel;
    
    [_iconIV am_setImageWithURL:_itemModel.user_info.headimg placeholderImage:ImageNamed(@"logo")];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_itemModel.user_info.username];
    _titleMarkLabel.hidden = !_itemModel.is_author.boolValue;
    _dateLabel.text = [TimeTool disscussTimestampWithTimeStr:_itemModel.addtime];
    
    if (_itemModel.to_user_info) {
        _nameView.hidden = NO;
        
        _name_replyLabel.text = @"回复";
        
        _name_titleLabel.text = [ToolUtil isEqualToNonNullKong:_itemModel.to_user_info.username];
        _name_title_leading.constant = 4.0f;
        
        _name_markLabel.hidden = YES;
        _name_markLabel.text = nil;
        _name_mark_width.constant = 0.0f;
        _name_mark_leading.constant = 0.0f;
        
        _name_colon.text = @"：";
        _name_colon_leading.constant = 4.0f;
    }else {
        _nameView.hidden = YES;
    }
    [self.nameView layoutIfNeeded];
    
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = [ToolUtil isEqualToNonNullKong:_itemModel.reply_comment];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    NSMutableDictionary *attri = @{}.mutableCopy;
    attri[NSFontAttributeName] = [UIFont addHanSanSC:14.0f fontType:0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = _itemModel.to_user_info?self.nameView.width:0.0f;
    style.maximumLineHeight = self.nameView.height;
    style.lineSpacing = 4.0f;
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    attri[NSParagraphStyleAttributeName] = style;

    [attrString addAttributes:attri range:[_contentLabel.text rangeOfString:_contentLabel.text]];

    _contentLabel.attributedText = attrString;
    [_contentLabel sizeToFit];
    
}

#pragma mark -
- (IBAction)clickToLogo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didSelectedLogo:withModel:)]) {
        [self.delegate detailCell:self didSelectedLogo:sender withModel:_itemModel];
    }
}

- (void)clickToLongPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:clickToShowMenuWithModel:)]) {
            [self.delegate detailCell:self clickToShowMenuWithModel:_itemModel];
        }
    }
}

@end

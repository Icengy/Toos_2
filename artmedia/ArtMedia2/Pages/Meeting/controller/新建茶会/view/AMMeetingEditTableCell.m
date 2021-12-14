//
//  AMMeetingEditTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingEditTableCell.h"

@interface AMMeetingEditTableCell () <AMTextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTipsLabel;
@property (weak, nonatomic) IBOutlet AMTextView *cellContentTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTV_height_constraint;

@end

@implementation AMMeetingEditTableCell

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _cellTipsLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        _cellTitleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        _cellContentTV.font = [UIFont addHanSanSC:14.0f fontType:0];
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cellContentTV.ownerDelegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

- (void)setStyle:(AMMeetingEditTableCellStyle)style {
    _style = style;
    switch (_style) {
        case AMMeetingEditTableCellStyleBeginDate: {
            _cellTipsLabel.hidden = NO;
            
            _cellTitleLabel.text = @"会客开始时间";
            _cellContentTV.placeholder = @"设定会客开始时间";
            
            break;
        }
        case AMMeetingEditTableCellStyleExplain: {
            _cellTipsLabel.hidden = YES;
            
            _cellTitleLabel.text = @"会客说明";
            _cellContentTV.placeholder = @"请设置会客说明";
            break;
        }
        case AMMeetingEditTableCellStyleEndDate: {
            _cellTipsLabel.hidden = YES;
            
            _cellTitleLabel.text = @"会客截止报名时间";
            _cellContentTV.placeholder = @"设定会客截止报名时间";
            break;
        }
        case AMMeetingEditTableCellStyleNumber: {
            _cellTipsLabel.hidden = YES;
            
            _cellTitleLabel.text = @"人数范围";
            _cellContentTV.placeholder = @"设定会客人数范围";
            break;
        }
            
        default:
            break;
    }
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    _cellContentTV.text = _contentStr;
}

#pragma mark - AMTextViewDelegate
- (BOOL)amTextViewShouldBeginEditing:(AMTextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didBeginEditContent:)]) {
        return [self.delegate editCell:self didBeginEditContent:textView];
    }
    return YES;
}

- (void)amTextViewDidChange:(AMTextView *)textView {
    CGFloat textViewHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
    if (textViewHeight < 44.0f) textViewHeight = 44.0f;
    _contentTV_height_constraint.constant = textViewHeight;
    
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCell:didFillInContent:style:)]) {
        [self.delegate editCell:self didFillInContent:textView.text style:_style];
    }
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end

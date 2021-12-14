//
//  DiscussInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussInfoTableCell.h"

#import "DiscussItemInfoModel.h"

@interface DiscussInfoTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DiscussInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLongPress:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(DiscussItemInfoModel *)model {
    _model = model;
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.comment];
    [_titleLabel sizeToFit];
}

#pragma mark -
- (void)clickToLongPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(infoCell:clickToShowMenuWithModel:)]) {
            [self.delegate infoCell:self clickToShowMenuWithModel:_model];
        }
    }
}

@end

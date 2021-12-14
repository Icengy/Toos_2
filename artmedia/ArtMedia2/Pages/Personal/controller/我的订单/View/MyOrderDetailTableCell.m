//
//  MyOrderDetailTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyOrderDetailTableCell.h"

@implementation MyOrderDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _subTitleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  PublishResultFooterTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishResultFooterTableCell.h"

@implementation PublishResultFooterTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    self.cornersRadii = CGSizeMake(8.0, 8.0);
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

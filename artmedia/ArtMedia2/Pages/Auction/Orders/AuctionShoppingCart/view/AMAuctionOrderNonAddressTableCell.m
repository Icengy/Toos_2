//
//  AMAuctionOrderNonAddressTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderNonAddressTableCell.h"

@interface AMAuctionOrderNonAddressTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation AMAuctionOrderNonAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.needCorner = YES;
    self.rectCorner = UIRectCornerAllCorners;
    self.cornerRudis = 8.0f;
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    
    self.titleLable.font = [UIFont addHanSanSC:14.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  AMAuctionOrderAddressTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderAddressTableCell.h"

#import "MyAddressModel.h"

@interface AMAuctionOrderAddressTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultMark;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation AMAuctionOrderAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.needCorner = YES;
    self.rectCorner = UIRectCornerAllCorners;
    self.cornerRudis = 8.0f;
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    
    self.areaLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.isDefaultMark.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.addressLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.infoLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressModel:(MyAddressModel *)addressModel {
    _addressModel = addressModel;
    
    _isDefaultMark.hidden = !_addressModel.is_default;
    _areaLabel.text = [ToolUtil isEqualToNonNullKong:_addressModel.addrregion];
    [_areaLabel sizeToFit];
    
    _addressLabel.text = [ToolUtil isEqualToNonNullKong:_addressModel.address];
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@", [ToolUtil isEqualToNonNullKong:_addressModel.reciver], [ToolUtil isEqualToNonNullKong:_addressModel.phone]];
}

@end

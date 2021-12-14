//
//  OrderAddressSelectCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "OrderAddressSelectCell.h"

#import "MyAddressModel.h"

@interface OrderAddressSelectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *noAddressView;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultIcon;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaLeftTrailingConstraint;

@end

@implementation OrderAddressSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_bottomLine.image = [ImageNamed(@"address_line") resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	
	_isDefaultIcon.font = [UIFont addHanSanSC:11.0f fontType:0];
	_areaLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_addressLabel.font = [UIFont addHanSanSC:20.0f fontType:1];
	_personLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_isDefaultIcon.layer.cornerRadius = 4.0;
	_isDefaultIcon.clipsToBounds = YES;
	
	NSLog(@"areaLeftTrailingConstraint =%.2f",_areaLeftTrailingConstraint.constant);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressModel:(MyAddressModel *)addressModel {
	_addressModel = addressModel;
	if ([ToolUtil isEqualToNonNull:_addressModel.ID]) {
		_addressView.hidden = NO;
		_noAddressView.hidden = YES;
		
		_isDefaultIcon.hidden = !_addressModel.is_default;
		_areaLeftTrailingConstraint.constant = (!_addressModel.is_default)?-40.f:8.0f;
		_areaLabel.text = [ToolUtil isEqualToNonNullKong:_addressModel.addrregion];
		_addressLabel.text = [ToolUtil isEqualToNonNullKong:_addressModel.address];
		_personLabel.text = [NSString stringWithFormat:@"%@ %@", [ToolUtil isEqualToNonNullKong:_addressModel.reciver], [ToolUtil isEqualToNonNullKong:_addressModel.phone]];
		
	}else {
		_noAddressView.hidden = NO;
		_addressView.hidden = YES;
	}
}



@end

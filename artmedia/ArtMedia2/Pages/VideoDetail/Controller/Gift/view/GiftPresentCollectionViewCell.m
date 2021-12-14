//
//  GiftPresentCollectionViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GiftPresentCollectionViewCell.h"

@interface GiftPresentCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation GiftPresentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		self.backgroundColor = Color_Red;
		self.layer.borderColor = Color_Red.CGColor;
		_titleLabel.textColor = Color_Whiter;
	}else {
		self.backgroundColor = RGB(0, 0, 0);
		self.layer.borderColor = RGB(114, 114, 114).CGColor;
		_titleLabel.textColor = Color_Whiter;
	}
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
	_indexPath = indexPath;
	switch (_indexPath.row) {
		case 0:
			_titleLabel.text = @"1";
			break;
		case 1:
			_titleLabel.text = @"3";
			break;
		case 2:
			_titleLabel.text = @"5";
			break;
		case 3:
			_titleLabel.text = @"10";
			break;
		case 4:
			_titleLabel.text = @"15";
			break;
			
		default:
			_titleLabel.text = @"自定义";
			break;
	}
}

@end

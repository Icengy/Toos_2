//
//  BlacklistTableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2020/1/9.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "BlacklistTableViewCell.h"

@implementation BlacklistModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"headimg":@[@"collect_banner"],
			 @"name":@[@"collect_title"],
			 @"ID":@"id"
			 };
}

@end


@interface BlacklistTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet AMButton *removeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeBtnWidthConstraint;

@end

@implementation BlacklistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_removeBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_removeBtnWidthConstraint.constant = [_removeBtn.titleLabel.text sizeWithFont:_removeBtn.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _removeBtn.height)].width + ADAptationMargin*3;
	
	_nameLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_headIV.clipsToBounds = YES;
	_headIV.layer.cornerRadius = _headIV.height/2;
}

- (void)setModel:(BlacklistModel *)model {
	_model = model;
	
	[_headIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	
	_nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.name];
}

- (IBAction)clickToRemove:(AMButton *)sender {
	if (_removeBlock) _removeBlock(_model);
}
@end

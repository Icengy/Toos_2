//
//  AMMeetingBookingListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingBookingListTableCell.h"

#import "AMMeetingPleaseUserModel.h"

@interface AMMeetingBookingListTableCell ()
@property (weak, nonatomic) IBOutlet AMIconImageView *userIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation AMMeetingBookingListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setModel:(AMMeetingPleaseUserModel *)model {
    _model = model;
    
    [_userIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    
    _bookingLabel.text = [ToolUtil isEqualToNonNullKong:_model.createTime];
    
    _selectedBtn.selected = _model.isSelected;
}

@end

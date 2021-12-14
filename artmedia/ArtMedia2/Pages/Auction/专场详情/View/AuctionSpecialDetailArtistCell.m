//
//  AuctionSpecialDetailArtistCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionSpecialDetailArtistCell.h"

#import "AuctionModel.h"

@interface AuctionSpecialDetailArtistCell ()

@property (weak, nonatomic) IBOutlet AMIconView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *heatLabel;
@property (weak, nonatomic) IBOutlet AMButton *focusButton;

@end

@implementation AuctionSpecialDetailArtistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToPersonal:)];
    logoTap.delegate = self;
    [self.headImageView addGestureRecognizer:logoTap];
}

- (IBAction)focusClick:(AMButton *)sender {
    if (self.focusBlock) self.focusBlock(sender);
}

- (void)clickToPersonal:(id)sender {
    if (self.clickToPersonal) self.clickToPersonal();
}

- (void)setModel:(AuctionModel *)model{
    
    _model = model;
    
    [_headImageView.imageView am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _headImageView.artMark.hidden = (_model.utype.integerValue < 3);
    
    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.hostUserName];
    self.heatLabel.text = [ToolUtil isEqualToNonNullKong:_model.artist_title];
    self.focusButton.selected = _model.is_collect.boolValue;
    if ([model.hostUserId isEqualToString:[UserInfoManager shareManager].uid]) {
        self.focusButton.hidden = YES;
    }else{
        self.focusButton.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

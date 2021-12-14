//
//  ClassDetailArtistCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailArtistCell.h"
@interface ClassDetailArtistCell ()
@property (weak, nonatomic) IBOutlet AMIconView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet AMButton *focusButton;
@end
@implementation ClassDetailArtistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoArtistHome)];
    [self.artistImageView addGestureRecognizer:tap];
    self.artistImageView.userInteractionEnabled = YES;
    // Initialization code
}
- (void)setModel:(AMCourseModel *)model{
    _model = model;
    
    [self.artistImageView.imageView am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFit)];
    
    self.artistNameLabel.text = model.teacherName;
//    self.artistTitleLabel.text = [ToolUtil isEqualToNonNullKong:model.tea]
    if ([model.isMySelf isEqualToString:@"1"]) {
        self.focusButton.hidden = YES;
    }
}
- (void)gotoArtistHome{
    if (self.gotoArtistHomeBlock) {
        self.gotoArtistHomeBlock();
    }
}

- (void)setUserModel:(CustomPersonalModel *)userModel{
    _userModel = userModel;
    
//    self.artistNameLabel.text = [ToolUtil isEqualToNonNullKong:_userModel.userData.username];
    if ([ToolUtil isEqualToNonNull:_userModel.userData.artist_title]) {
        self.artistTitleLabel.hidden = NO;
        self.artistTitleLabel.text = [ToolUtil isEqualToNonNullKong:_userModel.userData.artist_title];
    }else {
        self.artistTitleLabel.hidden = YES;
        self.artistTitleLabel.text = nil;
    }
    self.artistImageView.artMark.hidden = (_userModel.userData.utype.integerValue < 3);
    
    self.focusButton.selected = _userModel.userData.is_collect;
    self.focusButton.layer.borderColor = self.focusButton.selected?UIColorFromRGB(0x6F6969).CGColor:UIColorFromRGB(0x373535).CGColor;
}


- (IBAction)focusClick:(AMButton *)sender {
    if (self.focusClickBlock) {
        self.focusClickBlock(self.model.teacherId);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

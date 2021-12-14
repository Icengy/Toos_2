//
//  HK_invitationListCell.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_invitationListCell.h"

@interface HK_invitationListCell()
@property (nonatomic,weak) IBOutlet AMIconImageView *headerImage;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *masterLabel;
@property (nonatomic,weak) IBOutlet UIImageView *certificationImage;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@end

@implementation HK_invitationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    self.statusLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setModel:(HK_tea_managerModel *)model{
    _model = model;
    
    [self.headerImage am_setImageWithURL:model.headimg placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFit];
    self.nameLabel.text=model.uname;
    if (model.status==1) {
        self.statusLabel.text=@"已参加";
        self.statusLabel.textColor=RGBA(225, 32, 32, 1);
    }else if(model.status==2){
        self.statusLabel.text=@"不参加";
        self.statusLabel.textColor=RGBA(154, 154, 154, 1);
    }else if (model.status==3){
        self.statusLabel.text=@"待确认";
        self.statusLabel.textColor=RGBA(226, 146, 32, 1);
    }
    if (model.utype==3) {
        self.certificationImage.hidden=NO;
    }else{
        self.certificationImage.hidden=YES;
    }
    self.masterLabel.hidden = YES;
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

@end

//
//  ArtworkListCell.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtworkListCell.h"
@interface ArtworkListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;



@end
@implementation ArtworkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    // Initialization code
    
}
- (void)setModel:(ArtWorkListModel *)model{
    _model = model;
    [self.headImageView am_setImageWithURL:model.gbanner placeholderImage:[UIImage imageNamed:@"logo"]];
    self.titleLabel.text = model.gname;
    self.tipsLabel.text = model.des;
    
    NSLog(@"%f",(K_Width - 30) *(model.pic_width/model.pic_height));
    
//    if (model.pic_width > K_Width - 30) {
//        self.imageHeight.constant = (K_Width - 30) *(model.pic_height/model.pic_width);
//    }else{
//        self.imageHeight.constant = K_Width - 30;
//    }
    self.imageHeight.constant = (K_Width - 30) *(model.pic_height/model.pic_width);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

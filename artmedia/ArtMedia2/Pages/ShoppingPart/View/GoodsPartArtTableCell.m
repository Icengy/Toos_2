//
//  GoodsPartArtTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartArtTableCell.h"

@interface GoodsPartArtTableCell ()
@property (weak, nonatomic) IBOutlet AMIconView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
//@property (weak, nonatomic) IBOutlet UILabel *worksLabel;

@property (weak, nonatomic) IBOutlet AMButton *followBtn;
@property (weak, nonatomic) IBOutlet AMButton *homeBtn;

@end

@implementation GoodsPartArtTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(clickToHome)];
    [self.headIV addGestureRecognizer:tap];
    
    _nameLabel.font = [UIFont addHanSanSC:15.0f fontType:1];
    
    _fansLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
//    _worksLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _followBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _homeBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(UserInfoModel *)model {
    _model = model;
    
    [_headIV.imageView am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _headIV.artMark.hidden = (_model.utype.integerValue < 3);
    
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.username];
    
//    NSString *fans_num = [ToolUtil isEqualToNonNull:_model.fans_num replace:@"0"];
//    if (fans_num.integerValue > 9999) {
//        fans_num = [NSString stringWithFormat:@"%.2fw",fans_num.doubleValue/10000];
//    }
//    NSString *fans_Str = [NSString stringWithFormat:@"粉丝 %@",fans_num];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fans_Str];
//    [attr addAttribute:NSForegroundColorAttributeName value:RGB(217, 153, 4) range:[fans_Str rangeOfString:fans_num]];
    
    _fansLabel.text = [ToolUtil isEqualToNonNull:model.artist_title replace:@""];
    
//    NSString *goods_num = [ToolUtil isEqualToNonNull:_model.goods_num replace:@"0"];
//    if (goods_num.integerValue > 999) {
//        goods_num = [NSString stringWithFormat:@"%.2fk",fans_num.doubleValue/1000];
//    }
//    NSString *goods_Str = [NSString stringWithFormat:@"作品 %@",goods_num];
//    NSMutableAttributedString *attr_goods = [[NSMutableAttributedString alloc] initWithString:goods_Str];
//    [attr_goods addAttribute:NSForegroundColorAttributeName value:RGB(217, 153, 4) range:[goods_Str rangeOfString:goods_num]];
//
//    _worksLabel.attributedText = attr_goods;
    
    _followBtn.hidden = [ToolUtil isEqualOwner:_model.id];
    _followBtn.selected = _model.is_collect;
    _followBtn.layer.borderColor = _followBtn.currentTitleColor.CGColor;
}

- (IBAction)clickToFollow:(AMButton *)sender {
//    sender.selected = !sender.selected;
//    sender.layer.borderColor = sender.currentTitleColor.CGColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(artCell:didSelectedToFollow:)]) {
        [self.delegate artCell:self didSelectedToFollow:sender];
    }
}

- (void)clickToHome{
    if (self.delegate && [self.delegate respondsToSelector:@selector(artCell:didSelectedToShowArtHome:)]) {
        [self.delegate artCell:self didSelectedToShowArtHome:nil];
    }
}

@end

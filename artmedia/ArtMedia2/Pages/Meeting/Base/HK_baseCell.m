//
//  HK_baseCell.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_baseCell.h"
@interface HK_baseCell()

@end
@implementation HK_baseCell
+ (id)cellWithTableView:(UITableView *)tableView andCellIdifiul:(NSString *)cellId{
    HK_baseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[HK_baseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.BgView];
        
    }
    return self;
}
- (void)configUI{
    
}
- (void)layoutUI{
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.BgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@15);
//        make.right.equalTo(@(-15));
//        make.top.bottom.equalTo(@(0));
//    }];
}
- (UIView *)BgView{
    if (!_BgView) {
        _BgView=[[UIView alloc]init];
        _BgView.backgroundColor=[UIColor blackColor];
       
    }
    return _BgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

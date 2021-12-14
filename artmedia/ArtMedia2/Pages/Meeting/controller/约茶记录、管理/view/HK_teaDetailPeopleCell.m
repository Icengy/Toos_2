//
//  HK_teaDetailPeopleCell.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_teaDetailPeopleCell.h"

#import "AMMeetingOrderManagerListModel.h"

@interface HK_teaDetailPeopleCell()

@property (nonatomic,strong)AMIconImageView *headerImage;
@property (nonatomic,strong)UILabel *NameLabel;
@property (nonatomic,strong)UILabel *introduceLabel;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIView *lineView;
@end

@implementation HK_teaDetailPeopleCell

+ (id)cellWithTableView:(UITableView *)tableView andCellIdifiul:(NSString *)cellId{
    HK_teaDetailPeopleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[HK_teaDetailPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HK_teaDetailPeopleCell class])];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
- (void)setModel:(AMMeetingOrderManagerListModel *)model{
    _model=model;
    [self.headerImage am_setImageWithURL:model.headimg placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    self.NameLabel.text=model.uname;
    self.introduceLabel.text=model.artistTitle;
    if (model.orderStatus==1) {
        self.statusLabel.text=@"待邀请";
        self.statusLabel.textColor=RGBA(226, 32, 32, 1);
    }else if(model.orderStatus==2){
        self.statusLabel.text=@"已邀请";
        self.statusLabel.textColor=RGBA(225, 154, 26, 1);
    }else if (model.orderStatus==3){
        self.statusLabel.text=@"已确认";
        self.statusLabel.textColor=RGBA(154, 154, 154, 1);
    }else if (model.orderStatus==4){
        self.statusLabel.text=@"已取消";
        self.statusLabel.textColor=RGBA(154, 154, 154, 1);
    }
}
- (void)configUI{
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.NameLabel];
    [self.contentView addSubview:self.introduceLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
    [self layoutUI];
}
- (void)layoutUI{
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@9);
        make.top.equalTo(@14);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).with.offset(8.5);
        make.top.equalTo(@17.5);
        make.width.mas_greaterThanOrEqualTo(30);
        make.height.equalTo(@15);
    }];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NameLabel.mas_left);
        make.top.equalTo(self.NameLabel.mas_bottom).with.offset(10);
        make.width.mas_greaterThanOrEqualTo(30);
        make.height.equalTo(@15);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10.5);
        make.centerY.equalTo(self.NameLabel.mas_centerY);
        make.height.equalTo(@15);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    
}
- (AMIconImageView *)headerImage{
    if (!_headerImage) {
        _headerImage=[[AMIconImageView alloc]init];
        _headerImage.image=[UIImage imageNamed:@"美术馆图吧"];
        _headerImage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoArtistMainView)];
        [_headerImage addGestureRecognizer:tap];
    }
    return _headerImage;
}
- (UILabel *)NameLabel{
    if (!_NameLabel) {
        _NameLabel=[[UILabel alloc]init];
        _NameLabel.text=@"张三";
        _NameLabel.font=FONTN1(@"PingFangSC-Medium", 15);
        _NameLabel.textColor=RGB(51, 51, 51);
    }
    return _NameLabel;
}
- (UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel=[[UILabel alloc]init];
        _introduceLabel.textColor=MainLabelColor;
        _introduceLabel.font=FONTN1(@"PingFangSC-Regular", 12);
        _introduceLabel.text=@"知名书法大师";
        
    }
    return _introduceLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc]init];
        _statusLabel.textColor=MainLabelColor;
        _statusLabel.font=FONTN1(@"PingFangSC-Regular", 15);
//        _statusLabel.text=@"已参加";
    }
    return _statusLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=RGBA(230, 230, 230, 1);
    }
    return _lineView;
}
- (void)gotoArtistMainView{
    if (self.gotArtistBlock) {
        self.gotArtistBlock(self.model.artistId);
    }
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.size.width -= 30;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

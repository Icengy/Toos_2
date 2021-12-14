//
//  HK_appointmentTeaCell.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_appointmentTeaCell.h"

#import "AMMeetingOrderManagerListModel.h"

@interface HK_appointmentTeaCell()
@property (nonatomic,strong)AMIconImageView *headerImage;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *introduceLabel;
@property (nonatomic,strong)UILabel *appointmentStatusL;
@property (nonatomic,strong)UILabel *appointmentTime;
@end
@implementation HK_appointmentTeaCell

+ (id)cellWithTableView:(UITableView *)tableView andCellIdifiul:(NSString *)cellId{
    HK_appointmentTeaCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[HK_appointmentTeaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.introduceLabel];
    [self.contentView addSubview:self.appointmentStatusL];
    [self.contentView addSubview:self.appointmentTime];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutUI];
}

- (void)setModel:(AMMeetingOrderManagerListModel *)model{
    _model=model;
    self.titleLabel.text=model.uname;
    if (model.orderStatus == 1) {
        self.appointmentStatusL.text=@"待邀请";
        self.appointmentStatusL.textColor=RGBA(226, 32, 32, 1);
    }else if(model.orderStatus == 2){
        self.appointmentStatusL.text=@"已邀请";
        self.appointmentStatusL.textColor=RGBA(225, 154, 26, 1);
    }else if (model.orderStatus == 3){
        self.appointmentStatusL.text=@"已确认";
        self.appointmentStatusL.textColor=RGBA(154, 154, 154, 1);
    }else if (model.orderStatus == 4){
        self.appointmentStatusL.text=@"已取消";
        self.appointmentStatusL.textColor=RGBA(154, 154, 154, 1);
    }
    self.introduceLabel.text = [ToolUtil isEqualToNonNullKong:model.artistTitle];
}

- (void)layoutUI{
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@9);
        make.size.mas_equalTo(CGSizeMake(42*MainScreenWidht, 42*MainScreenWidht));
        make.top.equalTo(@14);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImage.mas_top);
        make.left.equalTo(self.headerImage.mas_right).with.offset(8.5);
        make.width.mas_greaterThanOrEqualTo(30);
        make.height.equalTo(@14);
    }];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(12);
        make.width.mas_greaterThanOrEqualTo(30);
        make.height.equalTo(@(15));
    }];
    [self.appointmentStatusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(@(15));
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    [self.appointmentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.appointmentStatusL.mas_right);
        make.height.equalTo(@(15));
        make.width.mas_greaterThanOrEqualTo(30);
        make.centerY.equalTo(self.introduceLabel.mas_centerY);
    }];
}

#pragma mark -
- (AMIconImageView *)headerImage{
    if (!_headerImage) {
        _headerImage=[[AMIconImageView alloc]init];
        _headerImage.backgroundColor=Color_Black;

    }
    return _headerImage;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=RGB(51, 51, 51);
        _titleLabel.font=DefaultFont;
        _titleLabel.text=@"张大千";
    }
    return _titleLabel;
}
- (UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel=[[UILabel alloc]init];
        _introduceLabel.textColor=MainLabelColor;
        _introduceLabel.font=FONTN1(@"PingFangSC-Regular", 13);
        _introduceLabel.text=@"知名书法大家";
    }
    return _introduceLabel;
}
- (UILabel *)appointmentStatusL{
    if (!_appointmentStatusL) {
        _appointmentStatusL=[[UILabel alloc]init];
        _appointmentStatusL.textColor=MainLabelColor;
        _appointmentStatusL.text=@"待邀请";
        _appointmentStatusL.font=FONTN1(@"PingFangSC-Regular", 14);
    }
    return _appointmentStatusL;
}
- (UILabel *)appointmentTime{
    if (!_appointmentTime) {
        _appointmentTime=[[UILabel alloc]init];
        _appointmentTime.textColor=MainLabelColor;
        _appointmentTime.font=FONTN1(@"PingFangSC-Regular", 12);
        _appointmentTime.text=@"3天前预约";
    }
    return _appointmentTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

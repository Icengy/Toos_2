//
//  HK_Tea_appointmentDetailCell.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_Tea_appointmentDetailCell.h"
#import "HK_Label.h"
#import "AMMeetingOrderManagerListModel.h"

@interface HK_Tea_appointmentDetailCell()
@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic,strong)UILabel *rightLabel;
@property (nonatomic,strong)HK_Label *delayLabel;
@property (strong , nonatomic) UIButton *detailButton;
@end
@implementation HK_Tea_appointmentDetailCell

+ (id)cellWithTableView:(UITableView *)tableView andCellIdifiul:(NSString *)cellId{
    HK_Tea_appointmentDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[HK_Tea_appointmentDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.delayLabel];
    [self.contentView addSubview:self.detailButton];
    [self layoutUI];
}
- (void)layoutUI{
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@9.5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.equalTo(@15);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.height.equalTo(@15);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    [self.delayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10.5));
        make.size.mas_equalTo(CGSizeMake(48*MainScreenWidht, 22*MainScreenWidht));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.height.equalTo(@28);
        make.width.mas_greaterThanOrEqualTo(71);
    }];
 
}
- (void)setLeftStr:(NSString *)leftStr{
    _leftStr=leftStr;
    self.leftLabel.text=leftStr;
}
- (void)setRightStr:(NSString *)rightStr{
    _rightStr=rightStr;
    if ([self.leftStr isEqualToString:@"约见保证金"]) {
        self.rightLabel.text=[NSString stringWithFormat:@"￥%@",_rightStr];
    }else{
        self.rightLabel.text=_rightStr;
    }
    
    if ([rightStr isEqualToString:@"查看详情"]) {
        self.rightLabel.hidden = YES;
        self.detailButton.hidden = NO;
    }else{
        self.rightLabel.hidden = NO;
        self.detailButton.hidden = YES;
    }
}

- (void)gotoDetail{
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock();
    }
}

- (void)setTime_Status:(NSInteger)time_Status{
    _time_Status=time_Status;
}

- (void)setModel:(AMMeetingOrderManagerListModel *)model{
    _model = model;
    if ([self.leftStr isEqualToString:@"预约到期时间"] && model.orderStatus == 1) {
        if ([model.payStatus isEqualToString:@"1"]) {
            self.delayLabel.hidden=NO;
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.delayLabel.mas_left).with.offset(-5);
                make.centerY.equalTo(self.delayLabel.mas_centerY);
                make.height.equalTo(@15);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
        }else{
            self.delayLabel.hidden=YES;
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-10);
                make.centerY.equalTo(self.leftLabel.mas_centerY);
                make.height.equalTo(@15);
                make.width.mas_greaterThanOrEqualTo(50);
            }];
        }
    }else{
        self.delayLabel.hidden=YES;
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(self.leftLabel.mas_centerY);
            make.height.equalTo(@15);
            make.width.mas_greaterThanOrEqualTo(50);
        }];
    }
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel=[[UILabel alloc]init];
        _leftLabel.textColor=MainLabelColor;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text=@"";
        _leftLabel.font=FONTN1(@"PingFangSC-Regular", 15);
    }
    return _leftLabel;
}
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel=[[UILabel alloc]init];
        _rightLabel.textColor=TitleColor;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text=@"";
        _rightLabel.font=FONTN1(@"PingFangSC-Regular", 14);
    }
    return _rightLabel;
}
- (HK_Label *)delayLabel {
    if (!_delayLabel) {
        _delayLabel = [[HK_Label alloc]init];
        _delayLabel.text=@"延期";
        _delayLabel.hidden=YES;
        _delayLabel.userInteractionEnabled=YES;
        _delayLabel.textAlignment=NSTextAlignmentCenter;
        _delayLabel.textColor=[UIColor whiteColor];
        _delayLabel.font=FONTN1(@"PingFangSC-Regular", 13);
//        [SKArchCutter cuttingView:_delayLabel cuttingDirection:UIRectCornerAllCorners cornerRadii:11 borderWidth:0.5 borderColor:RGBA(226, 32, 32, 1) backgroundColor:RGBA(226, 32, 32, 1)];
        _delayLabel.backgroundColor = RGBA(226, 32, 32, 1);
        [_delayLabel addRoundedCorners:(UIRectCornerAllCorners) withRadii:CGSizeMake(11.0f, 11.0f)];
        WeakSelf(self);
        _delayLabel.block = ^(NSString * _Nonnull labeltext, NSInteger index) {
            if ([weakself.delegate respondsToSelector:@selector(delayAction)]) {
                [weakself.delegate delayAction];
            }
        };
    }
    return _delayLabel;
}
- (UIButton *)detailButton{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.layer.borderWidth = 0.5;
        _detailButton.layer.borderColor = RGB(195, 197, 204).CGColor;
        _detailButton.layer.cornerRadius = 14;
        [_detailButton addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"查看详情"];
        [string addAttributes:@{ NSFontAttributeName : FONTN1(@"PingFangSC-Regular", 13)} range:NSMakeRange(0, string.length)];
        [_detailButton setAttributedTitle:string forState:UIControlStateNormal];
        
    }
    return _detailButton;
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

//
//  MineOrderItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MineOrderItemTableCell.h"

#import "CustomPersonalModel.h"

@interface MineOrderItemTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet AMReverseButton *allBtn;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *daifukuan_btn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *daifahuo_btn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *daishouhuo_btn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *yiwancheng_btn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *tuihuo_btn;

@end

@implementation MineOrderItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    // Initialization code
    _orderTitleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _allBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonalMenuItemButton *btn = (PersonalMenuItemButton *)obj;
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        btn.isAddRight = YES;
        btn.badgeNum = 0;
    }];
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

- (void)setUnreadModel:(CustomPersonalUnreadOrderModel *)unreadModel {
    _unreadModel = unreadModel;
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonalMenuItemButton *btn = (PersonalMenuItemButton *)obj;
        switch (idx) {
            case 0:/// 待付款
                btn.badgeNum = _unreadModel.wait_pay_num.integerValue;
                break;
            case 1:/// 待发货
                btn.badgeNum = _unreadModel.wait_deliver_num.integerValue;
                break;
            case 2:/// 待收货
                btn.badgeNum = _unreadModel.wait_receive_num.integerValue;
                break;
            case 4:/// 退货
                btn.badgeNum = _unreadModel.wait_return_num.integerValue;
                break;
                
            default:
                break;
        }
    }];
    
}

#pragma mark -
- (IBAction)clickToAll:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCell:didSelectedToAll:)]) {
        [self.delegate orderCell:self didSelectedToAll:sender];
    }
}

#define MineOrderItemTagDetault  2020900
- (IBAction)clickToStatus:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCell:didSelectedOrderCellWithIndex:)]) {
        NSInteger tag = sender.tag - MineOrderItemTagDetault;
        [self.delegate orderCell:self didSelectedOrderCellWithIndex:tag];
    }
}

@end

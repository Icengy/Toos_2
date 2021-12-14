//
//  ArtManagerPendingTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerPendingTableCell.h"

#import "ArtManagerPendingItemView.h"

#define ArtManagerPendingItemIndexDetault 202009030
@interface ArtManagerPendingTableCell ()
/// 待发货订单
@property (weak, nonatomic) IBOutlet ArtManagerPendingItemView *daifahuo_item;
/// 待处理退货
@property (weak, nonatomic) IBOutlet ArtManagerPendingItemView *daituihuochuli_item;
/// 待待处理约见
@property (weak, nonatomic) IBOutlet ArtManagerPendingItemView *daiyuejianchuli_item;
/// 待开始会客
@property (weak, nonatomic) IBOutlet ArtManagerPendingItemView *daikaishihuike_item;

@end

@implementation ArtManagerPendingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _daifahuo_item.logoIV.image = ImageNamed(@"am_待发货订单");
    _daifahuo_item.subTitleLabel.text = @"待发货订单";
    
    _daituihuochuli_item.logoIV.image = ImageNamed(@"am_待处理退货");
    _daituihuochuli_item.subTitleLabel.text = @"待处理退货";
    
    _daiyuejianchuli_item.logoIV.image = ImageNamed(@"am_待处理约见");
    _daiyuejianchuli_item.subTitleLabel.text = @"待处理约见";
    
    _daikaishihuike_item.logoIV.image = ImageNamed(@"am_待开始会客");
    _daikaishihuike_item.subTitleLabel.text = @"待开始会客";
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ArtManagerPendingItemView class]]) {
            [self clickToItem:(ArtManagerPendingItemView *)obj];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 20.0f;
    [super setFrame:frame];
}
/// 待发货数量
- (void)setWait_deliver_num:(NSInteger)wait_deliver_num {
    _wait_deliver_num = wait_deliver_num;
    _daifahuo_item.counttitleLabel.text = StringWithFormat(@(_wait_deliver_num));
}
/// 待处理会客
- (void)setWait_deal_meeting:(NSInteger)wait_deal_meeting {
    _wait_deal_meeting = wait_deal_meeting;
    _daikaishihuike_item.counttitleLabel.text = StringWithFormat(@(_wait_deal_meeting));
}
/// 待处理退货数量
- (void)setWait_deal_refund_num:(NSInteger)wait_deal_refund_num {
    _wait_deal_refund_num = wait_deal_refund_num;
    _daituihuochuli_item.counttitleLabel.text = StringWithFormat(@(_wait_deal_refund_num));
}
/// 待处理约见
- (void)setWait_deal_appointment:(NSInteger)wait_deal_appointment {
    _wait_deal_appointment = wait_deal_appointment;
    _daiyuejianchuli_item.counttitleLabel.text = StringWithFormat(@(_wait_deal_appointment));
}

- (void)clickToItem:(ArtManagerPendingItemView *)item {
    @weakify(self);
    item.selectedItemBlock = ^(ArtManagerPendingItemView * _Nonnull item) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(pendingMenuCell:didSelectedMenuItemWithIndex:)]) {
            NSInteger tag = item.tag - ArtManagerPendingItemIndexDetault;
            [self.delegate pendingMenuCell:self didSelectedMenuItemWithIndex:(ArtManagerPendingMenuItemIndex)tag];
        }
    };
}


@end

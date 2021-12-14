//
//  AMAuctionShoppingCartHeaderTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionShoppingCartHeaderTableCell.h"

#import "AMAuctionOrderBaseModel.h"

@interface AMAuctionShoppingCartHeaderTableCell ()

@property (weak, nonatomic) IBOutlet AMButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation AMAuctionShoppingCartHeaderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.statusLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    self.needCorner = YES;
    self.rectCorner = UIRectCornerTopRight | UIRectCornerTopLeft;
    self.cornerRudis = 8.0f;
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    
    self.isShoppingCart = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsShoppingCart:(BOOL)isShoppingCart {
    self.selectedBtn.hidden = !isShoppingCart;
}

- (void)setModel:(AMAuctionOrderBusinessModel *)model {
    _model = model;
    
    self.selectedBtn.selected = _model.isSelect;
    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.hostUserName];
    
    NSString *statusStr = nil;
    switch (_model.orderStatus) {
        case AMAuctionOrderStyleToBePaid: {/// 待支付
            statusStr = @"待支付";
            break;
        }
        case AMAuctionOrderStyleToBeDelivered: {/// 待发货
            statusStr = @"待发货";
            break;
        }
        case AMAuctionOrderStyleDelivered: {/// 已发货
            statusStr = @"已发货";
            break;
        }
        case AMAuctionOrderStyleReceived: {/// 已收货
            statusStr = @"已收货";
            break;
        }
        case AMAuctionOrderStyleSuccess: {/// 交易成功
            statusStr = @"交易成功";
            break;
        }
        case AMAuctionOrderStyleClose: {/// 交易关闭
            statusStr = @"交易关闭";
            break;
        }
            
        default:
            break;
    }
    self.statusLabel.text = statusStr;
}

- (void)setShowStatus:(BOOL)showStatus {
    _showStatus = showStatus;
    self.statusLabel.hidden = !_showStatus;
}

#pragma mark -
- (IBAction)clickToSelected:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartHeaderCell:didClickToSelected:)]) {
        [self.delegate shoppingCartHeaderCell:self didClickToSelected:sender];
    }
}

@end

//
//  WalletListDetailHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletListDetailHeaderView.h"

#import "WalletListBaseModel.h"

@interface WalletListDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelBottomConstraint;

@property (nonatomic ,strong) WalletBalanceListModel *balanceDetailModel;
@property (nonatomic ,strong) WalletRevenueListModel *revenueDetailModel;
@property (nonatomic ,strong) WalletYBListModel *yibDetailModel;
@property (nonatomic ,strong) WalletEstimateListModel *estimateDetailModel;


@property (nonatomic ,copy ,nullable) NSString *titleText;
@property (nonatomic ,copy ,nullable) NSString *tipsText;
@end

@implementation WalletListDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _countLabel.font = [UIFont addHanSanSC:23.0f fontType:2];
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    if (_titleLabel.hidden) {
        _countLabelBottomConstraint.constant = -self.countLabel.height/2;
    }else {
        _countLabelBottomConstraint.constant = 0.0f;
    }
}

#pragma mark - setter
- (void)setDetailModel:(WalletListBaseModel *)detailModel {
    _detailModel = detailModel;
    switch (_detailModel.style) {
        case AMWalletItemDetailStyleYBRecharge:    /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
            self.yibDetailModel = (WalletYBListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout:   /// 收入-提现
        case AMWalletItemDetailStyleRevenueMeetingProfit: /// 收入-会客
        case AMWalletItemDetailStyleRevenueCourseProfit:{   /// 收入-直播课
            
            self.revenueDetailModel = (WalletRevenueListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleBalanceExpenditure:    /// 余额-支出
        case AMWalletItemDetailStyleBalanceRollin:     /// 余额-转入
        case AMWalletItemDetailStyleBalanceCashout:    /// 余额-提现
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
            self.balanceDetailModel = (WalletBalanceListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleEstimateSaleValid:     /// 预估销售-有效
        case AMWalletItemDetailStyleEstimateSaleInvalid:     /// 预估销售-无效
        case AMWalletItemDetailStyleEstimateProfitValid:     /// 预估收益-有效
        case AMWalletItemDetailStyleEstimateProfitInvalid: {    /// 预估收益-无效
            
            self.estimateDetailModel = (WalletEstimateListModel *)_detailModel;
            break;
        }
        default:
            break;
    }
}

- (void)setRevenueDetailModel:(WalletRevenueListModel *)revenueDetailModel {
    _revenueDetailModel = revenueDetailModel;
    
    NSString *valueStr = nil;
    if (_revenueDetailModel.bill_type.integerValue - 1) {
        valueStr = [NSString stringWithFormat:@"-¥%@",[ToolUtil isEqualToNonNull:_revenueDetailModel.price replace:@"0"]];
    }else {
        valueStr = [NSString stringWithFormat:@"+¥%@",[ToolUtil isEqualToNonNull:_revenueDetailModel.price replace:@"0"]];
    }
    self.titleText = valueStr;
    self.tipsText = [ToolUtil isEqualToNonNullKong:_revenueDetailModel.bill_category];
}

- (void)setEstimateDetailModel:(WalletEstimateListModel *)estimateDetailModel {
    _estimateDetailModel = estimateDetailModel;

    self.titleText = [NSString stringWithFormat:@"+ ¥%@",[ToolUtil isEqualToNonNull:_estimateDetailModel.reward_money replace:@"0"]];;
    
    NSString *tips = nil;
    if (_estimateDetailModel.reward_order_state.integerValue == 2) {
        tips = @"买家已退货";
    }
    self.tipsText = tips;
}

- (void)setBalanceDetailModel:(WalletBalanceListModel *)balanceDetailModel {
    _balanceDetailModel = balanceDetailModel;
    
}

- (void)setYibDetailModel:(WalletYBListModel *)yibDetailModel {
    _yibDetailModel = yibDetailModel;
    
}


#pragma mark -
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    _countLabel.text = _titleText;
}

- (void)setTipsText:(NSString *)tipsText {
    NSLog(@"setTipsText");
    _tipsText = tipsText;
    _titleLabel.text = _tipsText;
    if ([ToolUtil isEqualToNonNull:_tipsText]) {
        _titleLabel.hidden = NO;
    }else {
        _titleLabel.hidden = YES;
    }
}

@end

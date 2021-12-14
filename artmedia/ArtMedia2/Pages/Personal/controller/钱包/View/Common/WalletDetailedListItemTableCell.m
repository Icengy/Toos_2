//
//  WalletDetailedListItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 明细Cell
//

#import "WalletDetailedListItemTableCell.h"

#import "WalletListBaseModel.h"

@interface WalletDetailedListItemTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *detailsTipsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueCenterYConstraint;

@property (nonatomic ,strong) WalletBalanceListModel *balanceDetailModel;
@property (nonatomic ,strong) WalletRevenueListModel *revenueDetailModel;
@property (nonatomic ,strong) WalletYBListModel *yibDetailModel;
@property (nonatomic ,strong) WalletEstimateListModel *estimateDetailModel;

@property (nonatomic ,strong) UIView *coverView;

@property (nonatomic ,copy) NSString *valueStr;
@end

@implementation WalletDetailedListItemTableCell

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [RGB(255, 255, 255) colorWithAlphaComponent:0.6];
    }return _coverView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _detailsValueLabel.font = [UIFont addHanSanSC:17.0f fontType:2];
    _detailsTipsLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _detailsTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _detailsTimeLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_coverView) {
        [self insertSubview:self.coverView aboveSubview:self.accessoryView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
}

#pragma mark -
- (void)setDetailModel:(WalletListBaseModel *)detailModel {
    _detailModel = detailModel;
    switch (_detailModel.style) {
        case AMWalletItemDetailStyleYBRecharge:    /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
//            self.yibDetailModel = (WalletYBListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout:  /// 收入-提现
        case AMWalletItemDetailStyleRevenueMeetingProfit: /// 收入-茶会
        case AMWalletItemDetailStyleRevenueCourseProfit: {    /// 收入-直播课
            
            self.revenueDetailModel = (WalletRevenueListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleBalanceExpenditure:    /// 余额-支出
        case AMWalletItemDetailStyleBalanceRollin:     /// 余额-转入
        case AMWalletItemDetailStyleBalanceCashout:    /// 余额-提现
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
//            self.balanceDetailModel = (WalletBalanceListModel *)_detailModel;
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
    
    self.detailsTimeLabel.text = [TimeTool getDateStringWithTimeStr:_revenueDetailModel.addtime];
    
    NSString *valueStr = nil;
    if (_revenueDetailModel.bill_type.integerValue - 1) {
        self.detailsValueLabel.textColor = RGB(51, 51, 51);
        valueStr = [NSString stringWithFormat:@"- ¥%@",[ToolUtil isEqualToNonNull:_revenueDetailModel.bill_amount replace:@"0"]];
    }else {
        self.detailsValueLabel.textColor = RGB(219, 17, 17);
        valueStr = [NSString stringWithFormat:@"+ ¥%@",[ToolUtil isEqualToNonNull:_revenueDetailModel.bill_amount replace:@"0"]];
    }
    
    self.valueStr= valueStr;
    
    self.detailsTitleLabel.text = [ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.bill_title];
    
    if ([ToolUtil isEqualToNonNull:_revenueDetailModel.bill_category]) {
        self.detailsTipsLabel.hidden = NO;
        self.valueCenterYConstraint.constant = 0.0f;
        self.detailsTipsLabel.text = _revenueDetailModel.bill_category;
    }else {
        self.detailsTipsLabel.hidden = YES;
        self.valueCenterYConstraint.constant = (self.contentView.centerY - self.detailsTitleLabel.centerY);
    }
}

- (void)setEstimateDetailModel:(WalletEstimateListModel *)estimateDetailModel {
    _estimateDetailModel = estimateDetailModel;
    
    if (_estimateDetailModel.style == AMWalletItemDetailStyleEstimateSaleValid || _estimateDetailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_estimateDetailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid ||
        _estimateDetailModel.style == AMWalletItemDetailStyleEstimateProfitInvalid) {
        [self addSubview:self.coverView];
    }
    
    self.detailsTimeLabel.text = [TimeTool getDateStringWithTimeStr:_estimateDetailModel.addtime];
    
    self.detailsValueLabel.textColor = RGB(51, 51, 51);
    self.valueStr = [NSString stringWithFormat:@"+ ¥%@",[ToolUtil isEqualToNonNull:_estimateDetailModel.actual_amount replace:@"0"]];
    
    self.detailsTitleLabel.text = [ToolUtil isEqualToNonNullForZanWu:_estimateDetailModel.title];
    
    if (_estimateDetailModel.reward_order_state.integerValue != 2) {
        self.detailsTipsLabel.hidden = YES;
        self.valueCenterYConstraint.constant = (self.contentView.centerY - self.detailsTitleLabel.centerY);
    }else {
        self.detailsTipsLabel.hidden = NO;
        self.valueCenterYConstraint.constant = 0;
        self.detailsTipsLabel.text = @"买家已退货";
    }
}

- (void)setValueStr:(NSString *)valueStr {
    _valueStr = valueStr;
    self.detailsValueLabel.text = _valueStr;
    [self.detailsValueLabel sizeToFit];
    self.valueWidthConstraint.constant = (self.detailsValueLabel.width < 20.0)?20.0f:self.detailsValueLabel.width;
}

@end

//
//  WalletListDetailCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletListDetailCell.h"

#import "WalletListBaseModel.h"

@interface WalletListDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet IRTLButton *showDetailBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showDetailBtnTrailingConstraint;

@property (nonatomic ,strong) WalletBalanceListModel *balanceDetailModel;
@property (nonatomic ,strong) WalletRevenueListModel *revenueDetailModel;
@property (nonatomic ,strong) WalletYBListModel *yibDetailModel;
@property (nonatomic ,strong) WalletEstimateListModel *estimateDetailModel;

@property (nonatomic ,copy ,nullable) NSString *contentText;
@property (nonatomic ,copy ,nullable) NSString *detailBtnText;

@end

@implementation WalletListDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _contentLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _showDetailBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickToShowDetail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToDetailBtn:)]) {
        [self.delegate didClickToDetailBtn:sender];
    }
}


#pragma mark - setter
- (void)setDetailModel:(WalletListBaseModel *)detailModel {
    _detailModel = detailModel;
    
    self.detailBtnText = [self getDetailBtnText];
    
    switch (_detailModel.style) {
        case AMWalletItemDetailStyleYBRecharge:    /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
            self.yibDetailModel = (WalletYBListModel *)_detailModel;
            break;
        }
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout:  /// 收入-提现
        case AMWalletItemDetailStyleRevenueMeetingProfit: /// 收入-茶会
        case AMWalletItemDetailStyleRevenueCourseProfit: { /// 收入-直播课
            
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

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    if (_titleText) {
        _titleLabel.text = _titleText;
    }
}

- (void)setShowDetailHidden:(BOOL)showDetailHidden {
    _showDetailHidden = showDetailHidden;
    if (_showDetailHidden) {
        _showDetailBtnTrailingConstraint.constant = - (_showDetailBtn.width);
    }else {
        _showDetailBtnTrailingConstraint.constant = 15.0f;
    }
    _showDetailBtn.hidden = _showDetailHidden;
}

#pragma mark -
- (void)setRevenueDetailModel:(WalletRevenueListModel *)revenueDetailModel {
    _revenueDetailModel = revenueDetailModel;
    
    if ([ToolUtil isEqualToNonNull:self.titleText]) {
        
        if ([self.titleText hasPrefix:@"用户名称"] ||
            [self.titleText hasPrefix:@"购买人"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.uname];
        }
        if ([self.titleText hasPrefix:@"收入编号"] ||
            [self.titleText hasPrefix:@"订单编号"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.bill_record_number];
        }
        if ([self.titleText hasPrefix:@"收入时间"] || [self.titleText hasPrefix:@"账单时间"]) {
            self.contentText = [TimeTool getDateStringWithTimeStr:_revenueDetailModel.addtime];
        }
        if ([self.titleText hasPrefix:@"提现用户"]) {
            self.contentText = [NSString stringWithFormat:@"%@\n%@",[ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.bankname],[ToolUtil getSecretBankNumWithBankNum:_revenueDetailModel.bankno]];
        }
        if ([self.titleText hasPrefix:@"商品名称"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.good_name];
        }
        if ([self.titleText hasPrefix:@"会客时间"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_revenueDetailModel.tea_info.tea_start_time];
        }
        if ([self.titleText hasPrefix:@"课程名称"]) {
            self.contentText = [ToolUtil isEqualToNonNullKong:_revenueDetailModel.course_info.from_object_name];
        }
        if ([self.titleText hasPrefix:@"支付艺币"]) {
            self.contentText = [NSString stringWithFormat:@"%ld艺币",[ToolUtil isEqualToNonNull:_revenueDetailModel.course_info.order_price replace:@"0"].integerValue];
        }
        if ([self.titleText hasPrefix:@"购买时间"]) {
            self.contentText = [TimeTool getDateStringWithTimeStr:_revenueDetailModel.course_info.buy_time];
        }
    }
}

- (void)setEstimateDetailModel:(WalletEstimateListModel *)estimateDetailModel {
    _estimateDetailModel = estimateDetailModel;
    
    if ([ToolUtil isEqualToNonNull:self.titleText]) {
        
        if ([self.titleText hasPrefix:@"订单编号"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_estimateDetailModel.ordersn];
        }
        if ([self.titleText hasPrefix:@"支付时间"]) {
            self.contentText = [TimeTool getDateStringWithTimeStr:_estimateDetailModel.addtime];
        }
        if ([self.titleText hasPrefix:@"商品名称"]) {
            self.contentText = [ToolUtil isEqualToNonNullForZanWu:_estimateDetailModel.title];
        }
    }
}

- (void)setBalanceDetailModel:(WalletBalanceListModel *)balanceDetailModel {
    _balanceDetailModel = balanceDetailModel;
    
}

- (void)setYibDetailModel:(WalletYBListModel *)yibDetailModel {
    _yibDetailModel = yibDetailModel;
    
}

- (void)setDetailBtnText:(NSString *)detailBtnText {
    _detailBtnText = detailBtnText;
    [self.showDetailBtn setTitle:_detailBtnText forState:UIControlStateNormal];
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    _contentLabel.text = _contentText;
}

#pragma mark -
- (NSString *_Nullable)getDetailBtnText {
    if (_detailModel.style == AMWalletItemDetailStyleYBConsumption) //艺币-消费
        return @"查看详情";
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueProfit )// 收入-收益
        return @"主页";
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueMeetingProfit )// 收入-会客
        return @"查看会客";
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueCourseProfit)// 收入-直播课
        return @"查看课程";
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueSale || //收入-销售
        _detailModel.style == AMWalletItemDetailStyleBalanceRefund || // 余额-退款
        _detailModel.style == AMWalletItemDetailStyleBalanceExpenditure || // 余额-支出
        _detailModel.style == AMWalletItemDetailStyleEstimateSaleValid || // 预估销售-有效
        _detailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid) // 预估销售-无效
        return @"查看订单";
    return nil;
}
@end

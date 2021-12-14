//
//  WalletRevenueTopItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletRevenueTopItemTableCell.h"

#import "WalletRevenueItemView.h"

@interface WalletRevenueTopItemTableCell () <WalletRevenueItemViewDelegate>
@property (weak, nonatomic) IBOutlet GradientView *contentCarrier;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@property (weak, nonatomic) IBOutlet UIView *saleCarrier;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
///销售item
@property (weak, nonatomic) IBOutlet WalletRevenueItemView *saleView;

@property (weak, nonatomic) IBOutlet UIView *profitCarrier;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
///收益item
@property (weak, nonatomic) IBOutlet WalletRevenueItemView *profitView;

@end

@implementation WalletRevenueTopItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentCarrier.colorArray = @[RGB(71, 149, 240), RGB(39, 109, 255)];
    self.saleView.delegate = self;
    self.profitView.delegate = self;
    
    self.incomeLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.saleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    self.profitLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRevenueData:(NSDictionary *)revenueData {
    _revenueData = revenueData;
    
    NSString *history_sale_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"history_sale_money"] replace:@"0"];
    NSString *history_reward_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"history_reward_money"] replace:@"0"];
    NSString *now_sale_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"now_sale_money"] replace:@"0"];
    NSString *now_reward_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"now_reward_money"] replace:@"0"];
    
    _incomeLabel.text = [NSString stringWithFormat:@"累计收入：%.2f",(history_reward_money.doubleValue + history_sale_money.doubleValue)];
    _saleView.mainLabel.text = [NSString stringWithFormat:@"¥ %.2f",now_sale_money.doubleValue];
    _saleView.mainLabel.adjustsFontSizeToFitWidth = YES;
    _profitView.mainLabel.text = [NSString stringWithFormat:@"¥ %.2f",now_reward_money.doubleValue];
    _profitView.mainLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setIsAuthUser:(BOOL)isAuthUser {
    _isAuthUser = isAuthUser;
    self.saleCarrier.hidden = !_isAuthUser;
}

#pragma mark -
- (void)didClickToCashout:(id)sender {
    NSInteger index = 0;
    if ([sender isEqual:self.profitView.cashoutBtn]) index = 1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToCashout:forIndex:)]) {
        [self.delegate didClickToCashout:sender forIndex:index];
    }
}

@end

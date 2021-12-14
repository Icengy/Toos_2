//
//  PersonalWalletTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalWalletTableViewCell.h"

#import "PersonalWalletItemView.h"

#import "CustomPersonalModel.h"

@interface PersonalWalletTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbale;
@property (weak, nonatomic) IBOutlet AMReverseButton *accountBtn;


@property (weak, nonatomic) IBOutlet UIStackView *stackView;
/// 我的钱包
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *balanceItem;
/// 预估收益
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *estimateItem;
/// 我的积分
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *integralItem;

@end

@implementation PersonalWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLbale.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonalWalletItemView *itemView = (PersonalWalletItemView *)obj;
        itemView.topTitleLabel.textColor = Color_Black;
        itemView.topTitleLabel.font = [UIFont addHanSanSC:18.0f fontType:3];
        itemView.bottomTitleLabel.textColor = UIColorFromRGB(0x999999);
        itemView.bottomTitleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    }];
    
    _balanceItem.bottomTitleLabel.text = @"我的钱包";
    _estimateItem.bottomTitleLabel.text = @"预估收益";
    _integralItem.bottomTitleLabel.text = @"我的积分";
    _balanceItem.topTitleLabel.text = @"￥0";
    _estimateItem.topTitleLabel.text = @"￥987";
    _integralItem.topTitleLabel.text = @"2020";
    
    _balanceItem.personalWalletItemBlock = ^{
        [self clickToSelectWalletItem:0];
    };
    _estimateItem.personalWalletItemBlock = ^{
        [self clickToSelectWalletItem:1];
    };
    _integralItem.personalWalletItemBlock = ^{
        [self clickToSelectWalletItem:2];
    };
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

- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    
    double now_sale_money = [ToolUtil isEqualToNonNull:[_model.wallet objectForKey:@"now_sale_money"] replace:@"0"].doubleValue;
    double now_reward_money = [ToolUtil isEqualToNonNull:[_model.wallet objectForKey:@"now_reward_money"] replace:@"0"].doubleValue;
    
    _balanceItem.topTitleLabel.text = [NSString stringWithFormat:@"¥ %.2f", (now_sale_money + now_reward_money)];
    _estimateItem.topTitleLabel.text = [NSString stringWithFormat:@"¥ %.2f", [ToolUtil isEqualToNonNull:_model.pre_reward_money replace:@"0"].doubleValue];
    _integralItem.topTitleLabel.text = [NSString stringWithFormat:@"%@", [ToolUtil isEqualToNonNull:[_model.wallet objectForKey:@"now_integral"] replace:@"0"]];
    
}

#pragma mark -
- (void)clickToSelectWalletItem:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(walletCell:didSelectedWalletItemWithIndex:)]) {
        [self.delegate walletCell:self didSelectedWalletItemWithIndex:index];
    }
}

- (IBAction)clickToAccount:(id)sender {
    if ([self.delegate respondsToSelector:@selector(walletCell:didSelectedToAccount:)]) {
        [self.delegate walletCell:self didSelectedToAccount:sender];
    }
}



@end

//
//  MyAuctionMoneyTableCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyAuctionMoneyTableCell.h"
#import "MyAuctionMoneyNormalView.h"

#import "MyAuctionMoneyModel.h"

@interface MyAuctionMoneyTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet MyAuctionMoneyNormalView *payView;
@property (weak, nonatomic) IBOutlet MyAuctionMoneyNormalView *returnView;
@property (weak, nonatomic) IBOutlet MyAuctionMoneyNormalView *forfeitureView;

@end

@implementation MyAuctionMoneyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyAuctionMoneyNormalView *normalView = (MyAuctionMoneyNormalView *)obj;
        normalView.style = idx;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyAuctionMoneyModel *)model {
    
    _model = model;
    
    NSString *auctionFieldTitle = [ToolUtil isEqualToNonNull:_model.auctionFieldTitle]?[NSString stringWithFormat:@"·%@",_model.auctionFieldTitle]:@"";
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", [ToolUtil isEqualToNonNullKong:_model.hostUserName], auctionFieldTitle];
    
    self.payView.hidden = NO;
    self.payView.dateStr = [ToolUtil isEqualToNonNullKong:_model.depositPayTime];
    self.payView.priceStr = [NSString stringWithFormat:@"%@",@(_model.depositAmount.integerValue)];
    
    self.returnView.hidden = _model.depositOrderStatus.integerValue != 4;
    self.returnView.dateStr = [ToolUtil isEqualToNonNullKong:_model.depositRefundTime];
    self.returnView.priceStr = [NSString stringWithFormat:@"%@",@(_model.depositRefundAmount.integerValue)];
    
    self.forfeitureView.hidden = _model.depositOrderStatus.integerValue != 5;
    self.forfeitureView.dateStr = [ToolUtil isEqualToNonNullKong:_model.depositForfeitureTime];
    self.forfeitureView.priceStr = [NSString stringWithFormat:@"%@",@(_model.depositForfeitureAmount.integerValue)];
    
    
    if (self.returnView.hidden && self.forfeitureView.hidden) {
        self.payView.clipsToBounds = YES;
        [self.payView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(8.0, 8.0)];
    }else {
        self.payView.clipsToBounds = NO;
        [self.payView addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeZero];
    }
    
}

@end

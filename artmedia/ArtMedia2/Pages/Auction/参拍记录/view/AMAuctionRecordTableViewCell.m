//
//  AMAuctionRecordTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionRecordTableViewCell.h"

#import "AMAuctionRecordModel.h"

#define AMAuctionRecordStateTagDetault  2020111616120

@interface AMAuctionRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *lotIV;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIStackView *stateStackView;

@end

@implementation AMAuctionRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UILabel *)obj setFont:[UIFont addHanSanSC:14.0 fontType:0]];
    }];
    
    [self.stateStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AMButton *)obj titleLabel].font = [UIFont addHanSanSC:12.0 fontType:0];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AMAuctionRecordModel *)model {
    _model = model;
    [self.lotIV am_setImageWithURL:_model.opusCoverImage placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    self.titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.composeTitle];
    
    NSString *number = [ToolUtil isEqualToNonNull:_model.goodNumber replace:@"0"];
    if ([ToolUtil isEqualToNonNull:_model.goodNumber]) {
        self.numberLabel.text = [NSString stringWithFormat:@"编号：LOT %04ld", number.integerValue];
    }
    
    NSInteger index = _model.isWinner.integerValue;
    /// isWinner = 、1：未得标、2未结算、3：已结算
    [self.stateStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AMButton *)obj setHidden:YES];
        if (obj.tag - AMAuctionRecordStateTagDetault == index) {
            [(AMButton *)obj setHidden:NO];
        }
    }];
}

@end

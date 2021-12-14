//
//  YiBRechargeItemCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "YiBRechargeItemCollectionCell.h"

@interface YiBRechargeItemCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *YBLabel;
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;

@end

@implementation YiBRechargeItemCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _YBLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
    _RMBLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setSelected:(BOOL)selected {
    self.layer.borderColor = [selected?RGB(219, 17, 17):RGB(204, 204, 204) CGColor];
    _YBLabel.textColor = selected?RGB(219, 17, 17):RGB(51, 51, 51);
    _RMBLabel.textColor = selected?RGB(219, 17, 17):RGB(153, 153, 153);
    
    [super setSelected:selected];
}

- (void)setNum:(NSNumber *)num {
    _num = num;
    _YBLabel.attributedText = [self getCountLabelAttribute:[NSString stringWithFormat:@"%@艺币", _num]];
    _RMBLabel.text = [NSString stringWithFormat:@"￥%.2f", _num.doubleValue];
}

#pragma mark - private
- (NSMutableAttributedString *)getCountLabelAttribute:(NSString *)string {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSFontAttributeName: [UIFont addHanSanSC:20.0f fontType:1]} range:ranges[i].range];
    }
    return attStr;
}

@end

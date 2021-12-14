//
//  AMMeetingSettingBondCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingSettingBondCollectionCell.h"

@interface AMMeetingSettingBondLabel : UILabel

@end

@implementation AMMeetingSettingBondLabel

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.font = [UIFont addHanSanSC:18.0f fontType:0];
    }return self;
}

- (void)setText:(NSString *)text {
    if ([ToolUtil isEqualToNonNull:text] && [text rangeOfString:@"/人"].location != NSNotFound) {
        NSRange range = [text rangeOfString:@"/人"];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont addHanSanSC:13.0f fontType:0] range:range];
        [self setAttributedText:attriStr];
    }else
        [super setText:text];
}

@end

@interface AMMeetingSettingBondCollectionCell ()
@property (weak, nonatomic) IBOutlet AMMeetingSettingBondLabel *bondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markIV;

@end

@implementation AMMeetingSettingBondCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    _markIV.hidden = !selected;
    self.layer.borderColor = selected?UIColorFromRGB(0xE22020).CGColor:UIColorFromRGB(0xCCCCCC).CGColor;
    [super setSelected:selected];
}

- (void)setBondNum:(NSString *)bondNum {
    _bondNum = bondNum;
    _bondLabel.text = [NSString stringWithFormat:@"¥%.2f/人",[[ToolUtil isEqualToNonNull:_bondNum replace:@"0"] floatValue]];
}

@end

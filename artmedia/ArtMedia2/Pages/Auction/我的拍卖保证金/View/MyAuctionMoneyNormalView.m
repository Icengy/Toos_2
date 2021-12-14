//
//  MyAuctionMoneyNormalView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyAuctionMoneyNormalView.h"

@interface MyAuctionMoneyNormalView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic,strong) IBOutlet UIView* view;

@property (weak, nonatomic) IBOutlet UIImageView *marginIV;

@end

@implementation MyAuctionMoneyNormalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}


- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.backgroundColor = UIColor.clearColor;
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.marginIV.image = [ImageNamed(@"dashed-line-1px") resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    self.dateLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.priceLabel.font = [UIFont addHanSanSC:16.0 fontType:2];
    
}

- (void)setStyle:(NSInteger)style {
    _style = style;
    
    self.marginIV.hidden = !_style;
    
    NSString *titleStr;
    UIColor *textColor;
    switch (_style) {
        case 0: {
            titleStr = @"缴费";
            textColor = UIColorFromRGB(0xB28762);
            break;
        }
        case 1: {
            titleStr = @"退回";
            textColor = UIColorFromRGB(0xFE9452);
            break;
        }
        case 2: {
            titleStr = @"罚没";
            textColor = UIColorFromRGB(0x41CBC6);
            break;
        }
        default: {
            titleStr = @"缴费";
            textColor = UIColorFromRGB(0xB28762);
            break;
        }
    }
    _titleLabel.text = titleStr;
    _priceLabel.textColor = textColor;
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    _dateLabel.text = [ToolUtil isEqualToNonNullKong:_dateStr];
}

- (void)setPriceStr:(NSString *)priceStr {
    _priceStr = priceStr;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_priceStr];
}

@end

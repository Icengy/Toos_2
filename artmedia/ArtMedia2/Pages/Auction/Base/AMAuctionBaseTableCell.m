//
//  AMAuctionBaseTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@implementation AMAuctionBaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectedBackgroundView = [UIView new];
    self.multipleSelectionBackgroundView = [UIView new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsShoppingCart:(BOOL)isShoppingCart {
    
    _isShoppingCart = isShoppingCart;
}

- (void)setFrame:(CGRect)frame {
    self.clipsToBounds = self.needCorner;
    if (self.needCorner) {
        [self addRoundedCorners:self.rectCorner withRadii:CGSizeMake(self.cornerRudis, self.cornerRudis)];
    }
    frame.origin.x += self.insets.left;
    frame.size.width -= (self.insets.left + self.insets.right);
    [super setFrame:frame];
}


-(void)layoutSubviews {
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews) {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    img.frame = CGRectMake(img.x, img.y, 25.0f, 25.0f);
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"icon-orderPay-press"];
                    }else
                        img.image=[UIImage imageNamed:@"icon-orderPay-normal"];
                }
            }
        }
    }
    [super layoutSubviews];
}

//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img = (UIImageView *)v;
                    img.frame = CGRectMake(img.x, img.y, 25.0f, 25.0f);
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"icon-orderPay-normal"];
                    }
                }
            }
        }
    }
}

@end

//
//  LivingRoomCell.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "LivingRoomCell.h"

@interface LivingRoomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistTitleLabel;

@end

@implementation LivingRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,_peopleImageView.width,_peopleImageView.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(0, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];

    [self.peopleImageView.layer addSublayer:gl];
}

- (void)setModel:(LivingRoomModel *)model{
    _model = model;
    [self.peopleImageView am_setImageWithURL:model.headimg placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFit];
    self.artistNameLabel.text = [ToolUtil isEqualToNonNullKong:model.uname];
    self.artistTitleLabel.text = [ToolUtil isEqualToNonNullKong:model.artistTitle];
}

- (UIColor*)RandomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
    
}
@end

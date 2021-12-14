//
//  JoinClassActionSheetView.m
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "JoinClassActionSheetView.h"
@interface JoinClassActionSheetView()
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *ecoinBalanceLabel;


@end
@implementation JoinClassActionSheetView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5];
}
- (IBAction)closeClick:(UIButton *)sender {
    [self hide];
}
- (IBAction)joinClick:(UIButton *)sender {
    if (self.joinClassBlock) {
        [self hide];
        self.joinClassBlock();
    }
}

- (void)setModel:(AMCourseModel *)model{
    _model = model;
    if ([model.isFree isEqualToString:@"1"]) {
        self.payStatusLabel.text = @"免费加入学习";
        self.ecoinBalanceLabel.hidden = YES;
        [self.payButton setTitle:@"确认加入" forState:UIControlStateNormal];
    }else{
        self.payStatusLabel.text = @"付费加入学习";
        self.ecoinBalanceLabel.hidden = NO;
//        self.ecoinBalanceLabel.text = [NSString stringWithFormat:@"当前账户：%@艺币",];
        [self.payButton setTitle:[NSString stringWithFormat:@"%@艺币购买",model.coursePrice] forState:UIControlStateNormal];
    }
}
- (void)setEcoinModel:(ECoinModel *)ecoinModel{
    _ecoinModel = ecoinModel;
    self.ecoinBalanceLabel.text = [NSString stringWithFormat:@"当前账户：%@艺币",ecoinModel.nowVirtualMoney];
}
+ (instancetype)shareInstance{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^ {
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^ {
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

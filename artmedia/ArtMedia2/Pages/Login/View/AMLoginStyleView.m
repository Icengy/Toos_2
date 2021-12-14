//
//  AMLoginStyleView.m
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMLoginStyleView.h"


@interface AMLoginStyleView ()

@property (nonatomic, assign) AMLoginStyleType loginStyleType;

@end
@implementation AMLoginStyleView

- (instancetype)initWithFrame:(CGRect)frame loginStyleBlock:(AMLoginStyleBtnBlock)loginStyleBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.loginStyleBlock = loginStyleBlock;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSArray *imageArr = @[@"icon-signUp-phone",@"icon-signUp-locked"];
    NSArray *btnTagArr = @[@(AMLoginStyleTypeCode),@(AMLoginStyleTypeMobile)];

    if ([WXApi isWXAppInstalled]) {
        imageArr = @[@"icon-signUp-wechat",@"icon-signUp-phone",@"icon-signUp-locked"];
        btnTagArr = @[@(AMLoginStyleTypeWechat),@(AMLoginStyleTypeCode),@(AMLoginStyleTypeMobile)];
    }
    UIView *lastV = self;
    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIButton *btn = [UIButton czh_buttonWithTarget:self action:@selector(btnClick:) frame:CGRectZero imageName:imageArr[i]];
        btn.tag =  [btnTagArr[i] integerValue];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(lastV.mas_left).mas_offset(100);
            }else {
                make.left.equalTo(lastV.mas_right).mas_offset(23);
            }
            make.centerY.equalTo(lastV.mas_centerY);
        }];
        lastV = btn;
    }
}

- (void)btnClick:(UIButton *)btn
{
    AMLoginStyleType styleType = btn.tag;
    if (self.loginStyleBlock) {
        self.loginStyleBlock(styleType);
    }
}

@end

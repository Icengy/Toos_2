//
//  AMAuthLoginFailView.m
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuthLoginFailView.h"
#import "AMLoginStyleView.h"


@implementation AMAuthLoginFailView

- (IBAction)btnClick:(UIButton *)btn
{
    if (self.btnBlock) {
        self.btnBlock();
    }
}

@end

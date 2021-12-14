//
//  HomeNormalViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeNormalViewController : BaseViewController

@property(nonatomic,copy) void(^clickToMoveBlock)(NSInteger index);
/// -1 推荐 -2 关注 01234...
@property (nonatomic ,assign) NSInteger listType;

@end

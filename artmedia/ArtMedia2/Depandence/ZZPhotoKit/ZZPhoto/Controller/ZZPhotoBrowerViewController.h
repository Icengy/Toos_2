//
//  ZZPhotoBrowerViewController.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"

@class ZZPhotoBrowerViewController;
@protocol ZZPhotoBrowerDelegate <NSObject>

@optional
- (void)browerViewController:(ZZPhotoBrowerViewController *)brower didSelectedWithIndex:(NSInteger)selectedIndex selectArray:(NSArray *)selectArray;

@end

@interface ZZPhotoBrowerViewController : UIViewController

@property (nonatomic ,weak) id <ZZPhotoBrowerDelegate> delegate;


@property (nonatomic,   copy) NSArray *photoData;

@property (nonatomic,   strong) NSMutableArray *selectArray;

@property (nonatomic ,assign) NSInteger maxSelectNum;
@property (nonatomic, assign) NSInteger scrollIndex;

-(void) showIn:(UIViewController *)controller;

@end

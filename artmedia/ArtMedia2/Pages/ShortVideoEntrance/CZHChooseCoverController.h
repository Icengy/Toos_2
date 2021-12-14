//
//  CZHChooseCoverController.h
//  saveCover
//
//  Created by 郭洪凯 on 2020/7/29.
//  Copyright © 2020年 郭洪凯. All rights reserved.
//


#import "BaseViewController.h"

@interface CZHChooseCoverController : BaseViewController
///本地视频路径
@property (nonatomic, copy) NSURL *videoPath;
///封面回调
@property (nonatomic, copy) void (^coverImageBlock)(UIImage *coverImage);
@end

//
//  HomeTopSegment.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//定义block，用来传递点击的第几个按钮
typedef void (^PassValueBlock)(NSInteger index);

@interface HomeTopSegment : UIView

@property(assign ,nonatomic) NSInteger currentSelectedIndex;
@property (nonatomic ,assign) BOOL sameTitleSize;
//定义一下block
@property(copy ,nonatomic) PassValueBlock returnBlock;
/**
 初始化

 @param size 控件大小
 @param itemArray 子控件标题
 @return self
 */
+ (HomeTopSegment *)shareInstanceWithSize:(CGSize)size itemArray:(NSArray *)itemArray;

@end

NS_ASSUME_NONNULL_END

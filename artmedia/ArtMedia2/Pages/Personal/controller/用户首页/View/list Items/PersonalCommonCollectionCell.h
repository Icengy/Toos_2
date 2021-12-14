//
//  PersonalCommonCollectionCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
@class GradientButton;

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCommonCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END

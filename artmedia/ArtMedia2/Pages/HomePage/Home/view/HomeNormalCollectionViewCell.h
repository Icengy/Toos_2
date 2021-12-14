//
//  HomeNormalCollectionViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/19.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface HomeNormalCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;
@property(nonatomic,copy) void(^clickToShowMenu)(VideoListModel *model);

@end

NS_ASSUME_NONNULL_END

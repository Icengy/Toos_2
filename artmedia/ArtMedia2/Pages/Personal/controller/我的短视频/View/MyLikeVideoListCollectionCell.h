//
//  MyLikeVideoListCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyLikeVideoListCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END

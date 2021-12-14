//
//  HomeFullImageCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface HomeFullImageCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;
@property(nonatomic,copy) void(^clickToShowMenu)(VideoListModel *model);

@end

NS_ASSUME_NONNULL_END

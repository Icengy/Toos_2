//
//  PersonalFullImageCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface PersonalFullImageCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END
